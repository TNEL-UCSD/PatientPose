# PatientPose
[Translational Neuroengineering Lab @ UC San Diego](tnel.ucsd.edu)


## Setup
### Requirements

### Python environment 

options/environment.yml contains instructions for creating a near-complete python environment to run 'get_training_data.py'. To create this environment, the run the following command from src/

`conda env create -f environment.yml`

__NOTE__ - to complete this environment, please install [pyflow](https://github.com/pathak22/pyflow) 

## Workflow

### 0 - Data preparation

Here we assume study video is collected in a single folder, represented as a sequence of images (.jpg). 

### 1 - Generate training data

Frames for manual annotation / training are identified using optical flow to estimate periods where the subject is either idle or moving. 

`python get_training_data.py *input_dir* `

Optional arguments:

* *--save_dir*, the full path for output data (defaults to './results')
* *--n_jobs*, number of threads to use when annotating data (defaults to 1 thread) 


Output:

* *flow_data*, folder containing PNG images of estimated flow (Vx, Vy) between sequential training images
* *training-kalman*, folder containing sub-selected images to annotate kalman filter training data
* *training-posemodel*, folder containing sub-selected images to annotate patientpose model training data
* *flow.mp4*, color visualization of the optical flow calculated for given data
* *motion-report.csv*, file describing each frame analyzed. Headers include filename (frame), whether frame was excluded for artifact (@Excluded), frame marked movement (@Movement), as well as the magnitude of optical flow over the subject (mag\_subject) or on the borders of the camera (mag\_border)
* *summary.png*, image showing estimated flow and marked frames 
* *training-report.csv*, similar to motion-report.csv but includes additional columns whether frames were used for training, by type. 

#### Example 1 - annotate training data using default options

`python get_training_data.py "\path\to\data\"`


#### Example 2 - annotate training data using all but 2 cpu threads

`python get_training_data.py "\path\to\data\" --n_jobs -1`


#### Example 3 - annotate training data, save to different location, and use 4 cpu threads

`python get_training_data.py "\path\to\data\" --save_dir "\some\other\path" --n_jobs 4`

## Citation

	@article{chen2018patientpose,
		author = {K. Chen and P. Gabriel and A. Alasfour and C. Gong and W. K. Doyle and O. Devinsky and D. Friedman and P. Dugan and L. Melloni and T. Thesen and D. Gonda and S. Sattar and S. Wang and V. Gilja},
		journal = {IEEE Journal of Translational Engineering in Health and Medicine}, 
		title = {Patient-Specific Pose Estimation in Clinical Environments}, 
		year = {2018}, 
		volume = {6}, 
		pages = {1-11}, 
		doi = {10.1109/JTEHM.2018.2875464}, 
		ISSN = {2168-2372}, 
		month = {}
	}

