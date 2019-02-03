# PatientPose
Beta Release

[Translational Neuroengineering Lab @ UC San Diego](tne.ucsd.edu)


## Setup
### Requirements

### Python environment 

options/environment.yml contains instructions for creating a near-complete python environment to run 'get_training_data.py'. To create this environment, the run the following command from src/

'''
conda env create -f environment.yml
'''

__NOTE__ - to complete this environment, please install [pyflow](https://github.com/pathak22/pyflow) 

## Pipeline

### 0 - Data preparation

Here we assume study video is collected in a single folder, represented as a sequence of images (.jpg). 

### 1 - Generate training data

Frames for manual annotation / training are identified using optical flow to estimate periods where the subject is either idle or moving. 

'''
python get_training_data.py *input_dir* 
'''

Optional arguments:
* --save_dir, the full path for output data (defaults to './results')
* --n_jobs, number of threads to use when annotating data (defaults to 1 thread) 

Output:
* flow_data, folder containing PNG images of estimated flow (Vx, Vy) between sequential training images
* training-kalman, folder containing sub-selected images to annotate kalman filter training data
* training-posemodel, folder containing sub-selected images to annotate patientpose model training data
* flow.mp4, color visualization of the optical flow calculated for given data
* motion-report.csv, file describing each frame analyzed. Headers include filename (frame), whether frame was excluded for artifact (@Excluded), frame marked movement (@Movement), as well as the magnitude of optical flow over the subject (mag_subject) or on the boarders of the camera (mag_border)
* summary.png, image showing estimated flow and marked frames 
* training-report.csv, similar to motion-report.csv but includes additional columns whether frames were used for training, by type. 

#### Example 1 - annotate training data using default options
'''
python get_training_data.py "\path\to\data\"
'''

#### Example 2 - annotate training data using all but 2 cpu threads
'''
python get_training_data.py "\path\to\data\" --n_jobs -1
'''

#### Example 3 - annotate training data, save to different location, and use 4 cpu threads
'''
python get_training_data.py "\path\to\data\" --save_dir "\some\other\path" --n_jobs 4
'''

