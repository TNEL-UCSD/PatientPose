''' parse_openpose.py

Loads OpenPose JSON data

Usage: python parse_openpose.py [folder of .json files]

Inputs:
    - Folder of OpenPose joint coordinate files (.json)

Outputs:
    - Struct of joint coordinates [2x7xn] corresponding to [Head LHand RHand LElbow RElbow LShldr RShldr]

Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
Website: http://www.tnel.ucsd.edu
'''

#%% Import Libraries
import sys
import argparse
import json
import numpy as np
import glob

#%% Parse JSON Files
def parse_json(data_folder):
  # list all files in directory
  file_paths = glob.glob(data_folder + "*.json")
  
  # sort in alphanumeric order
  file_paths.sort()
  
  # define pose structure
  pose = np.ndarray(shape=(2,7,len(file_paths)))
  
  # define confidence structure
  confidence = np.ndarray(shape=(7,len(file_paths)))
  
  # loop through each file
  for n, f in enumerate(file_paths):
    # load the data
    with open(f) as data_file:
      data = json.load(data_file)
    
    # extract pose points depending on manually checking which person
    p = 0
    current_pose = data['people'][p]['pose_keypoints']
    
    # convert to numpy array
    current_pose = np.asarray(current_pose)
    
    # head
    pose[:,0,n] = current_pose[0:2]
    confidence[0,n] = current_pose[2]
    
    # left hand
    pose[:,2,n] = current_pose[21:23]
    confidence[2,n] = current_pose[23]
    
    # right hand
    pose[:,1,n] = current_pose[12:14]
    confidence[1,n] = current_pose[14]
  
    # left elbow
    pose[:,4,n] = current_pose[18:20]
    confidence[4,n] = current_pose[20]
  
    # right elbow
    pose[:,3,n] = current_pose[9:11]
    confidence[3,n] = current_pose[11]
    
    # left shoulder
    pose[:,6,n] = current_pose[15:17]
    confidence[6,n] = current_pose[17]
    
    # right shoulder
    pose[:,5,n] = current_pose[6:8]
    confidence[5,n] = current_pose[8]
    
  return pose, confidence

#%% Main
if __name__ == "__main__":
  # create parser
  parser = argparse.ArgumentParser(description='OpenPose JSON Parser')
  parser.add_argument('data_folder', type=str, default=None, help='Folder of OpenPose data')
  
  # parse arguments
  args = parser.parse_args()
  data_folder = args.data_folder
  
  # parse OpenPose json files
  pose, confidence = parse_json(data_folder)
  
  # concatenate data
  data = np.concatenate((pose,confidence[np.newaxis,:,:]),axis=0)
  
  # write to system out
  data_reshaped = np.reshape(data,(data.shape[0]*data.shape[1]*data.shape[2]), order='F')
  data_list = data_reshaped.tolist()
  sys.stdout.write(" ".join(map(str,data_list)))
  