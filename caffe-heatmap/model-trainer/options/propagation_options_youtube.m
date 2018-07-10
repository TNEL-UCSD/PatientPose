%% --- occlusion model options 
opts.occlusion.radius = 5*2;
opts.occlusion.patchwidth = 31*2-1;
opts.occlusion.numnegperim = 5;
opts.occlusion.sensitivity = 0.98;
opts.occlusion.hog_cell_size = 3*2;
opts.occlusion.negradius = 30*2;
opts.occlusion.negradiusmult = 6*2;
opts.occlusion.rgbsubsamp = 2*2; %half the size of the patch for rgb template
opts.occlusion.rotations = [-30 -10 0 10 30]; %augment training data with these rotations
opts.occlusion.detection_labels = [1 4 5 6 7]; %what joint labels will we run the occlusion detector on

%% shape options
opts.shape.width = 15;
opts.shape.anchor = [0.3 0.9];
opts.shape.height = 80;
opts.shape.scaleval = 1/3;

%% evaluation options
opts.evaluator.hog.cellsize = 3;
opts.evaluator.hog.shape.width = opts.shape.width*2;
opts.evaluator.hog.shape.height = opts.shape.height;
opts.evaluator.maxtrainframes = 500; %1500 used for full processing
opts.background.maxframes = 100; %maximum number of frames used to produce background model (set at 500 for full processing mode)

%% propagation options
opts.imscale = 1; %scale image
opts.initialise.numframestocluster = 5000; %number of frames to uniformaly sample from video to initialise the clustering
opts.initialise.numclusters = 200; %number of clusters to use when sampling frames for training
opts.cluster.numneighbours = 2; %step sized used for selecting frames when clustering (i.e. select every 2nd frame)
opts.verify.percentagekeep = 0.1; %percentage of frames to keep for bootstrapping
%
opts.flow.numneighbours = 1; %step size used for selecting frames to temporally propagate (i.e. set to 1 to select every frame or 2 to select every 2nd frame etc)
opts.flow.stepsize = 30; %step size between neighbouring frames (full processing set to 30) window width used to temporally propagate

%% ------ colour histogram options ------   used for producing a CP image and domain specific
opts.colourhist.bits  = 5;    %number of bits per colour channel
opts.colourhist.smoothvariance = 1; %variance used for gaussian when smoothing histograms
opts.colourhist.R = 1e-10;  %regularisation constant added to histograms

%% Fusion CNN pose options
opts.cnn.finetune.model_filename = [pwd '/caffe-heatmap/models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'];
opts.cnn.finetune.base_solver_file = [pwd '/caffe-heatmap/model-trainer/+fusion/base_scripts/solver.prototxt'];
opts.cnn.finetune.base_def_file = [pwd '/caffe-heatmap/model-trainer/+fusion/base_scripts/train_val.prototxt'];
opts.cnn.finetune.dims = [256 256];
opts.cnn.finetune.base_train_script = [pwd '/caffe-heatmap/model-trainer/+fusion/base_scripts/train.sh'];
opts.cnn.finetune.ramdisk_folder = [pwd '/caffe-heatmap/model-trainer/+fusion/training_data/'];
opts.cnn.finetune.main_save_folder = [pwd '/caffe-heatmap/model-trainer/+fusion/fusion_training/'];
opts.cnn.finetune.cafferoot = [pwd '/caffe-heatmap/'];

%% ------- deepflow options --------
opts.deepflowstatic = [pwd '/caffe-heatmap/model-trainer/3_dependencies/DeepFlow_release2.0/deepflow2-static'];
