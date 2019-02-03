""""kinectmatics - Kinect computer vision toolbox for movement kinematics"""

name = "kinectmatics"

from .version import __version__

from .timesegmentation import clean_detection, threshold_signal, filter_isolated_cells, array_to_sequence, merge_neighboring_cells
from .opticalflow import process_image, process_flow_from_list
from .libvid import video_to_frames, frames_to_video, folder_to_list, get_image_list