# -*- coding: utf-8 -*-
"""
Created on Tue Jun  5 13:22:47 2018

@author: kali
"""
import os
import time 
from functools import partial
from multiprocessing import Pool, cpu_count

import numpy as np
import cv2
import pyflow
from tqdm import tqdm

from kinectmatics import libvid

def load_flow(fx, fy):
    
    def _load_frame(frame):
        im = cv2.imread(frame, -1)
        return im
    
    imx = _load_frame(fx)
    imy = _load_frame(fy)

    flow = np.stack([imx, imy], axis=2)
    flow = restore_flow(flow)
    flow = process_flow(flow)
    return flow

def compress_flow(flow, scale=np.iinfo('uint16').max):# scale=65535.0):
    
    scale_flow = np.copy(flow.astype(np.float64))
    MIN = -175.
    MAX = 175.
    
    scale_flow[:,:,0] = float(scale)*(flow[:,:,0] - MIN) / (MAX - MIN)
    scale_flow[:,:,1] = float(scale)*(flow[:,:,1] - MIN) / (MAX - MIN)
    
    scale_flow = scale_flow.astype(np.uint16)
    return scale_flow

def restore_flow(flow, scale=np.iinfo('uint16').max):
    scaled_flow = np.copy(flow.astype(np.float64))
    MIN = -175.
    MAX = 175.
    
    scaled_flow[:,:,0] = ((scaled_flow[:,:,0] * (MAX - MIN)) / (float(scale))) + MIN #* 255.
    scaled_flow[:,:,1] = ((scaled_flow[:,:,1] * (MAX - MIN)) / (float(scale))) + MIN #* 255.

#    scaled_flow = scaled_flow.astype(np.float64) #+ 64.
    return scaled_flow.astype(np.float64)

def process_image(im):
    im_processed = np.copy(im)
    im_processed = im_processed.astype(float) / 255.
    
    return im_processed

def process_flow(flow):
    mag, ang = cv2.cartToPolar(flow[..., 0], flow[..., 1])
    return mag, ang


def get_flow(im1, im2, alpha=0.012, ratio=0.75, minWidth=20, nOuterFPIterations=7, nInnerFPIterations=1,
        nSORIterations=30, colType=0):
#    s = time.time()
    
#    # smooth images with gaussian blur
#    res=im1.shape
#    k = int(np.sum([int(str(res[0])[:-2]), int(str(res[1])[:-2])]))
#    if k % 2 == 0: k = k + 1
#    
#    im1 = cv2.GaussianBlur(im1, (k, k), 0)
#    im2 = cv2.GaussianBlur(im2, (k, k), 0)

    u, v, _ = pyflow.coarse2fine_flow(im1, im2, alpha, ratio, minWidth, nOuterFPIterations, nInnerFPIterations,
        nSORIterations, colType)
    
#    e = time.time()
#    print('Time Taken: %.2f seconds for image of size (%d, %d, %d)' % (
#        e - s, im1.shape[0], im1.shape[1], im1.shape[2]))
    flow = np.concatenate((u[..., None], v[..., None]), axis=2)
    
    return flow



def make_flow_image(flow, MIN = 2.5, MAX=50.):
    hsv = np.zeros((flow.shape[0], flow.shape[1], 3), dtype=np.uint8)
    hsv[:, :, 0] = 255
    hsv[:, :, 1] = 255
    mag, ang = cv2.cartToPolar(flow[..., 0], flow[..., 1])
    hsv[..., 0] = ang*180/np.pi/2 # 255. * ang / (2 * np.pi)
    hsv[..., 2] = 255. * (mag + MIN) / (MAX) #cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX)
    
    return cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)
    
    # what if memory required for flow array is too large?
    # -> first, estimate speed of calculation
    
def save(flow, dir_save, i):
    # rescale flow to save as 16-bit PNG grayscale image: [Vx, Vy]
    
#    np.save('{0}/Flow{1}'.format(dir_save,i), flow)

    flow_scale = compress_flow(flow)

    flow_name = '{0}/FlowVx_{1}.png'.format(dir_save,i)
    cv2.imwrite(flow_name, flow_scale[:,:,0])
    flow_name = '{0}/FlowVy_{1}.png'.format(dir_save,i)
    cv2.imwrite(flow_name, flow_scale[:,:,1])
    
    # visualize flow through HSV enconding
    im_flow = make_flow_image(flow)    
    flow_name = '{0}/FlowHSV_{1}.jpg'.format(dir_save,i)
    cv2.imwrite(flow_name, im_flow)


def _par_process(params, tuple_value):
    
    dir_save, rescale = params[0], params[1]
    
    index, (f1, f2) = tuple_value
#    
    
    print(tuple_value, dir_save)
    
    _, flow = process(f1, f2, index, rescale)
    save(flow, dir_save, index)
    del flow
       
    
def process(f1, f2, index, rescale=None):
    
    # pull flow values from frames
    im1 = process_image(cv2.imread(f1))
    im2 = process_image(cv2.imread(f2))

    if rescale is not None:
        im1 = cv2.resize(im1, rescale)
        im2 = cv2.resize(im2, rescale)
                
    flow = get_flow(im1, im2)
    
    # convert flow (Vx, Vy) to (Magnitude [pixels per frame], Angle [radians])
    mag, ang = process_flow(flow)
    
    results = [np.mean(mag), np.std(mag)]
    
    del im1, im2, mag, ang
    
    return results, flow
    
    #%%
def process_flow_from_list(frames, dir_save=None, dat=True, viz=True, res=(320,240), n_jobs=1):
    ''' Converts a list of images to be loaded and converted to optical flow
    NOTE sequential not required, consider parallelizing calcuations, pairing frames
    :return: Returns flow data
    '''
    #%%
#    # Flow Options:
#    alpha = 0.012
#    ratio = 0.75
#    minWidth = 20
#    nOuterFPIterations = 7
#    nInnerFPIterations = 1
#    nSORIterations = 30
#    colType = 0  # 0 or default:RGB, 1:GRAY (but pass gray image with shape (h,w,1))
    
    if len(frames) < 2:
        print("Need at least 2 frames to calculate flow. Currently providing: {0} frames".format(len(frames)))
        return None
    dir_data = os.path.join(dir_save, 'flow_data/')

    if dir_save is not None and os.path.exists(dir_save):
        print("Preparing saving stage...")
        if not os.path.exists(dir_data):
            os.mkdir(dir_data)
            
        dir_video = os.path.join(dir_save, 'flow.mp4')
#        
#    if viz:
#        im1 = process_image(cv2.imread(frames[0]))
#        fourcc = cv2.VideoWriter_fourcc(*'MJPG')
#        out = cv2.VideoWriter(dir_video, fourcc, 30.0, res)        

    s = time.time()
    
#    params = {'dir':dir_data, 'rescale':res}
    params = (dir_data, res)

    # run linearly
    if n_jobs == 1:
        print("Getting flow (linear)    ", flush=True)
        for i, (f1, f2) in tqdm(enumerate(zip(frames[:-1], frames[1:]))):
            
            results, flow = process(f1, f2, i, rescale=res)
            save(flow, dir_data, i)
            
    else:
        n_jobs = cpu_count() - 2 if n_jobs == -1 else n_jobs
        n_jobs = min(n_jobs, len(frames))
        print("Getting flow (parallel, n_jobs={0}/{1} total)    ".format(n_jobs, cpu_count()))
        pool = Pool(processes=n_jobs)
        pool.map(partial(_par_process, params), enumerate(zip(frames[:-1], frames[1:])))
        pool.close()
#        if viz:
#            out.write(im_flow)
#            
#                    
#        if (np.mod(i+1, np.ceil(0.1*(len(frames)-1)))) == 0:
#            print(" | ", end="")
#    if viz:
#        out.release()
        
    if viz:
        #%%
        libvid.frames_to_video(dir_data, dir_video, fs=15.0, res=res, keep_frames=False)
        #%%
        
    print("")
    e = time.time()
    print('Time Taken: %.2f seconds for %d images' % (
        e - s, len(frames)))
    
    return True

#    print('Time Taken: %.2f seconds for %d images of size (%d, %d, %d)' % (
#        e - s, i, im1.shape[0], im1.shape[1], im1.shape[2]))

