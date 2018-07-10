%% TNEL options
tnelOpt.blurimage = true;
tnelOpt.blurimagesigma256 = 3;
tnelOpt.blurimagesigma1080 = 15;
tnelOpt.existingrect = false; % if cropping rectangle exists already
tnelOpt.inputfiletype = 'jpg';
tnelOpt.resize = false; % crop or not
tnelOpt.saverawjoints = false;
tnelOpt.visualizeoutput1 = true; % visualize post-processing
tnelOpt.visualizeoutput1Skel = true;
tnelOpt.visualizeoutput1Heatmap = false;
tnelOpt.visualizeoutput2 = false;

tnelOpt.input2vidloc = [pwd '/caffe-heatmap/model-trainer/1_data/videos/'];
tnelOpt.input2initloc = [pwd '/caffe-heatmap/model-trainer/1_data/initialisation/'];
tnelOpt.personalizeloc = [pwd '/caffe-heatmap/model-trainer/'];

%% Caffe-Heatmap options
opt.dims = [256 256];
opt.layerName = 'conv5_fusion';
opt.numJoints = 7;
opt.personalized = false;
opt.useGPU = true;
opt.visualizeskel = false; % visualize in real time
opt.visualizeheatmap = false;
opt.heatmapstyle = 'combined'; % combined or separate

opt.modelDefFile = [pwd '/caffe-heatmap/models/heatmap-flic-fusion/matlab.prototxt'];

%% Personalized Pose Estimator options
personalOpt.numcpus = 30;