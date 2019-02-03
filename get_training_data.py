# -*- coding: utf-8 -*-
''' get_training_data.py

Generates training data for a CNN model, according to

Usage: python get_training_data.py [folder path]

Optional args:  --save_dir [folder path]
                --n_jobs [int]

Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
Website: http://www.tnel.ucsd.edu
'''

import sys
import os
import argparse
import time

import cv2
import numpy as np
import pandas as pd
from shutil import copy
from tqdm import tqdm

# for current use, add kinectmatics path before importing
# future work-> kinectmatics will be included with PatientPose
module_path = './lib'

if module_path not in sys.path:
    sys.path.append(module_path)

import kinectmatics as km
from kinectmatics import libvid
from kinectmatics import opticalflow as kof

#%% command to use:
# python get_training_data.py "D:\data\workspace_opticalflow\Color"
#folder = "D:\\data\\workspace_opticalflow\\Color"
#save_dir = "D:\\data\\workspace_opticalflow\\Color\\results"
#res = (480, 270)

#python get_training_data.py "E:\NY591\2016.10.08.10.39\Color" --save_dir "D:\data\workspace_opticalflow\test_research"


def _get_train_kf(df_in, len_seg=10, n_move=50, n_still=10):
    df = df_in.copy()
    valid_movement = df['@Movement'].values
    valid_movement[df['@Excluded']] = 0

    valid_still = np.logical_not(np.logical_or(valid_movement, df['@Excluded'].values))

    # Find all movement periods
    candidates = km.array_to_sequence(valid_movement)
    candidates_still = km.array_to_sequence(valid_still)

    # Reject short movement periods (len < len_seg)
    candidates = candidates[candidates['duration'] >= len_seg]
    candidates_still = candidates_still[candidates_still['duration'] >= len_seg]

    # Randomly sample n_seg segments
    candidates = candidates.sample(n=min(n_move, len(candidates)), replace=False)
    candidates_still = candidates_still.sample(n=min(n_still, len(candidates)), replace=False)

    # Add label to distinguish
    candidates['label'] = 'Move-kf'
    candidates_still['label'] = 'Still-kf'

    # Combine move and still candidate periods for sampling
    candidates_full = pd.concat([candidates, candidates_still])

    # Generate list of actual frames to be used
    df_return = []
    b_train_kf = np.zeros(len(df))
    for i, val in candidates_full.iterrows():
        df_temp = df.iloc[val['onset']:(val['onset']+len_seg)]
        df['label'] = val['label']
        b_train_kf[val['onset']:(val['onset']+len_seg)] = 1
        df_return.append(df_temp)

    df_return = pd.concat(df_return, sort=False)
    df_return.sort_index(inplace=True)
    df_return.reset_index(drop=True, inplace=True)

    return df_return, b_train_kf.astype(bool), candidates_full


def _get_train_pose(df_in, fr_move=0.7, n_max=2000):
    df = df_in.copy()
    valid_movement = df['@Movement'].values
    valid_movement[df['@Excluded']] = 0
    valid_movement[df['trainKF']] = 0

    valid_still = np.logical_not(df['@Movement'].values)
    valid_still[df['@Excluded']] = 0
    valid_still[df['trainKF']] = 0

    n_move = np.round(min(fr_move*n_max, sum(valid_movement))).astype(int)
    n_still = min(sum(valid_still), np.round(n_move*(1-fr_move)/fr_move).astype(int))

    print("Selecting {0}/{1} marked movement frames".format(n_move, sum(valid_movement)))
    candidates = df[valid_movement].sample(n=n_move, replace=False)

    print("Selecting {0}/{1} marked still frames".format(n_still, sum(valid_still)))
    candidates_still = df[valid_still].sample(n=n_still, replace=False)

    # Add label to distinguish
    candidates['label'] = 'Move-pose'
    candidates_still['label'] = 'Still-pose'

    b_train_pose = np.zeros(len(df))

    # Combine move and still candidate periods for sampling
    df_return = pd.concat([candidates, candidates_still], sort=False)
    df_return.sort_index(inplace=True)

    b_train_pose[df_return.index] = 1

    df_return.reset_index(drop=True, inplace=True)

    return df_return, b_train_pose.astype(bool)


def _save_training_data(df_in, save_dir):
    df = df_in.copy()

    pose_dir = os.path.join(save_dir, 'training-posemodel')
    kf_dir = os.path.join(save_dir, 'training-kalman')

    if not os.path.exists(kf_dir):
        os.mkdir(kf_dir)
    if not os.path.exists(pose_dir):
        os.mkdir(pose_dir)

    count_pose = 0
    count_kf = 0

    for i, val in tqdm(df.iterrows()):
        _,ext = os.path.splitext(val['frame'])
        if pd.isnull(val['label']):
            continue
        elif 'pose' in val['label']:
            count_pose += 1
            savefile = os.path.join(pose_dir, 'Frame_{0}{1}'.format(count_pose, ext))

        elif 'kf' in val['label']:
            count_kf += 1
            savefile = os.path.join(kf_dir, 'Frame_{0}{1}'.format(count_kf, ext))

        else:
            print("invalid file: {0}".format(val['frame']))
            continue

        copy(val['frame'], savefile)


def generate_training(df_in, save_dir):

    df = df_in.copy()
    file_movements = os.path.join(save_dir, 'training-report.csv')

    # Get Kalman filter candidates
    train_kf, b_train_kf, candidates_kf = _get_train_kf(df, len_seg=10, n_move=50, n_still=10)
    df['trainKF'] = b_train_kf

    train_pose, b_train_pose = _get_train_pose(df, fr_move=0.7, n_max=2500)
    df['trainPP'] = b_train_pose

    df.to_csv(file_movements, index=False)

    df_save = pd.concat([train_pose, train_kf], sort=False)

    _save_training_data(df_save, save_dir)

    return df


def run_movement_labeling(folder, save_dir):
    image_list_raw = km.get_image_list(folder, image_fmt='jpg')

    file_movements = os.path.join(save_dir, 'motion-report.csv')

    df = None

    if os.path.exists(file_movements):
        print("  Loading pre-processed movement data.")
        df = pd.read_csv(file_movements)
    else:
        # Get file names of optical flow data for fast loading
        flow_dir = os.path.join(save_dir, 'flow_data')
        flow_list = km.get_image_list(flow_dir, image_fmt='png')
        flow_list = np.reshape(flow_list, (2,-1)).T

        # Generate binary mask for separating video border and subject
        res = _get_resolution(flow_list[0,0])
        artifact_mask = libvid.make_border_mask(res, buff_h=0.05, buff_v=0.0).T

        # Populate flow magnitudes around subject and border
        mag_subject = np.zeros((len(image_list_raw),))
        mag_border = np.zeros((len(image_list_raw),))

        for i, (fx, fy) in tqdm(enumerate(flow_list)):
            mag, ang = kof.load_flow(fx, fy)

            mag_subject[i+1] = mag.mean()
            mag_border[i+1] = mag[artifact_mask].mean()

        # note these threshold parameters are arbitrary to the example... should provide defaults but allow for manipulation through parameters in this function
        bn_subject = km.threshold_signal(mag_subject, thresh=0.1)
        bn_border = km.threshold_signal(mag_border, thresh=1.5)

        bn_subject, rj_subject = km.clean_detection(bn_subject, len_isolation=1, min_spacing=10)
        bn_border, rj_border = km.clean_detection(bn_border, len_isolation=10, min_spacing=5)

        df = pd.DataFrame({'frame':image_list_raw, '@Excluded':(rj_subject+rj_border+bn_border).astype(bool), '@Movement':bn_subject,
                           'mag_border':mag_border, 'mag_subject':mag_subject})
        df.to_csv(file_movements, index=False)

    return df


def _get_resolution(fim):
    img = cv2.imread(fim)
    height, width, _ = img.shape
    return (width, height)


def _scale_res(res, scale=4):
    return (int(res[0]/scale), int(res[1]/scale))


def run_optical_flow(folder, save_dir):
    image_list_raw = km.get_image_list(folder, image_fmt='jpg')

    try:
        image_list_flow = km.get_image_list(os.path.join(save_dir, 'flow_data'), image_fmt='png')
    except:
        image_list_flow = []

    if len(image_list_flow) == 2*(len(image_list_raw)-1):
        print("Optical flow has already been regenerated! Moving on to the next phase...")
        return True
    else:
        print("Flow must be (re)generated...\n{0} frames counted, {1} frames expected.".format(len(image_list_flow), 2*(len(image_list_raw)-1)))

    res = _get_resolution(image_list_raw[0])
    res = _scale_res(res)
    print("Frame width, height = {0}".format(res))

    processed = False
    try:
        processed = km.process_flow_from_list(image_list_raw, dir_save=save_dir, res=res, n_jobs=-1)
        print("Finished processing flow.")

    except:
        print("Flow failed to be processed.")


    return processed


def _summarize_training(df_in, save_dir):
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(3,1, figsize=(10,10))

    t = df_in.index

    # plot raw amplitudes with binary annotations
    ax[0].plot(t, df_in['mag_subject'], 'k')
    ax[0].set_xlim((t[0], t[-1]))
    ax[0].set_xlabel('Frame number (a.u.)')
    ax[0].set_ylabel('Mean flow magnitude (pixels per frame)')

    ax[1].plot(t, df_in['mag_subject'], 'k--')
    ax[1].plot(t, -1 + df_in['@Movement'], 'b')
    ax[1].plot(t, -2 + df_in['@Excluded'], 'r')
    ax[1].set_xlim((t[0], t[-1]))
    ax[1].set_xlabel('Frame number (a.u.)')
    ax[1].legend(('Magnitude', 'Movement', 'Excluded'))

    ax[2].plot(t, df_in['mag_subject'], 'k--')
    ax[2].plot(t, -1 + df_in['@Movement'], 'b--')
    ax[2].plot(t, -2 + df_in['@Excluded'], 'r--')
    ax[2].plot(t, -1 + df_in['trainPP'], 'g')
    ax[2].plot(t, -2 + df_in['trainKF'], 'c')

    ax[2].set_xlim((t[0], t[-1]))
    ax[2].set_xlabel('Frame number (a.u.)')
    ax[2].legend(('Magnitude', 'Pose Frames', 'KF Frames'))

    ax[0].set_title('Average Flow Magnitude (per frame)')
    ax[1].set_title('Movement Period Segmentation')
    ax[2].set_title('Selected Training Frames')

    plt.tight_layout()

    fig.savefig(os.path.join(save_dir,'summary.png'))


def run_single_folder(folder, save_dir):

    # Make sure input folder is valid
    valid_folder = os.path.isdir(folder)
    if not valid_folder:
        print("Folder is not valid. END")
        return

    print("Loading: {0} [exists:{2}]\nSaving: {1}".format(folder, save_dir, valid_folder))


    # Make sure save folder exists / can be made
    if not os.path.exists(save_dir):
        try:
            os.mkdir(save_dir)
        except:
            print("Unable to write saving folder.")
            return

    # Generate optical flow (logic contained within function)
    valid_flow = run_optical_flow(folder, save_dir)

    if valid_flow:
        print("Now labeling movement frames with flow")
        df_labels = run_movement_labeling(folder, save_dir)
    else:
        print("UNKNOWN: flow somehow incomplete.")
        return

    if df_labels is not None:
        df_annotated = generate_training(df_labels, save_dir)

    _summarize_training(df_annotated, save_dir)


def main(input_dir, save_dir):
#    print("Loading: {0}\nSaving: {1}".format(input_dir, save_dir))
    tic = time.time()
    run_single_folder(input_dir, save_dir)
    print("Runtime: {0}s".format(time.time() - tic))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='PatientPose assistive Python script that extracts optical flow (pyflow) and and marks frames for manual annotation.')
    parser.add_argument('input_dir', help='enter full path to image folder')
    parser.add_argument('--save_dir', help='enter full path for saving data; default=./results')
    parser.add_argument('--n_jobs', help='number of threads to use; -1: all threads but 2; default= 1 thread')

    args = parser.parse_args()

    if not args.save_dir:
        save_dir = os.path.join(args.input_dir, 'results')
    else:
        save_dir = args.save_dir

    if args.n_jobs:
        n_jobs = args.n_jobs
    else:
        n_jobs = 1

    main(args.input_dir, save_dir)
    print("Done.")
