# -*- coding: utf-8 -*-
"""
Created on Tue Jun  5 19:18:03 2018

@author: kali
"""
import os
import ntpath

import cv2
from natsort import natsorted
import numpy as np

def make_border_mask(res, buff_h=0.1, buff_v=0.1):
    mask = np.zeros(res)
    
    width = int(res[0]*buff_h)
    height = int(res[1]*buff_v)
    
    if width:  
        mask[:width,:] = 1
        mask[-width:,:] = 1
    if height:
        mask[:,:height] = 1
        mask[:,-height:] = 1
    
    return mask.astype(bool)

#%% 
def get_image_list_research(data_dir, folder, imtype='Color', image_fmt='jpg'):
    data_path = os.path.join(data_dir, folder)
    image_path = os.path.join(data_path, imtype)
    
#    image_names = [f for f in os.listdir(image_path) if (f[-3:]==image_fmt and os.path.isfile(os.path.join(image_path, f)))]
    
    image_list = [os.path.join(image_path,f) for f in os.listdir(image_path) if (f[-3:]==image_fmt and os.path.isfile(os.path.join(image_path, f)))]
    image_list = natsorted(image_list)
    
    return image_list, image_path

def get_image_list(data_dir, image_fmt='jpg'):    
#    image_names = [f for f in os.listdir(image_path) if (f[-3:]==image_fmt and os.path.isfile(os.path.join(image_path, f)))]
    
    image_list = [os.path.join(data_dir,f) for f in os.listdir(data_dir) if (f[-3:]==image_fmt and os.path.isfile(os.path.join(data_dir, f)))]
    image_list = natsorted(image_list)
    
    return image_list

#%%
def folder_to_list(dir_frames):
    return natsorted([os.path.join(dir_frames, f) for f in os.listdir(dir_frames) if os.path.isfile(os.path.join(dir_frames, f))])

def _folder_name_from_video(file_video):
    name_video = ntpath.basename(file_video)
    name_video = name_video.split(".")[0]
    return name_video


def video_to_frames(file_video, dir_save):

    if not os.path.exists(file_video):
        print("Invalid video file... conversion halted.")
        return None
    else:
        folder_save = _folder_name_from_video(file_video)
        folder_save = os.path.join(dir_save, folder_save)
        
        if not os.path.exists(folder_save):
            os.mkdir(folder_save)
        else:
            print("Folder already generated.")
            return None

    vidcap = cv2.VideoCapture(file_video)
    success, image = vidcap.read()
    
    count = 0
    while success:
        save_name = "{0}/image{1}.png".format(folder_save, count)
        cv2.imwrite(save_name, image)

        success, image = vidcap.read()
        count += 1

    return True
    
#%%
def frames_to_video(dir_frames, file_video, fs=15.0, res=(320,240), keep_frames=True):
    
    
    if not os.path.exists(dir_frames):
        print("Invalid frames folder... conversion halted.")
        return None
    
    # overwrite previous video:
    if os.path.exists(file_video):
        os.remove(file_video)

    files_images = natsorted([os.path.join(dir_frames, f) for f in os.listdir(dir_frames) if os.path.isfile(os.path.join(dir_frames, f)) and f[-3:]=='jpg'])
    
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    out = cv2.VideoWriter(file_video, fourcc, fs, res) 
    for file in files_images:
        frame = cv2.imread(file)
        out.write(frame)
      
    print("Video processing completed.")
        
    out.release()
    
    if not keep_frames:
        clear_frames(dir_frames)
    
    return True

def clear_frames(dir_frames, fmt='jpg'):
    files_images = natsorted([os.path.join(dir_frames, f) for f in os.listdir(dir_frames) if os.path.isfile(os.path.join(dir_frames, f)) and f[-3:]==fmt])

    for f in files_images:
        os.remove(f)