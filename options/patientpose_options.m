%% PatientPose options
pp.blurimage = true;
pp.blurimagesigma256 = 3;
pp.blurimagesigma1080 = 15;
pp.existingrect = false; % if cropping rectangle exists already
pp.inputfiletype = 'jpg';
pp.resize = false; % crop or not
pp.saverawjoints = false;
pp.visualizeoutput1 = true; % visualize post-processing
pp.visualizeoutput1Skel = true;
pp.visualizeoutput1Heatmap = false;
pp.visualizeoutput2 = false;

pp.input2vidloc = [pwd '/caffe-heatmap/model-trainer/1_data/videos/'];
pp.input2initloc = [pwd '/caffe-heatmap/model-trainer/1_data/initialisation/'];
pp.personalizeloc = [pwd '/caffe-heatmap/model-trainer/'];

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
