%% train_kf.m
%   ---- AUTHOR INFORMATION ----
%   Kenny Chen
%   Translational Neuroengineering Laboratory (TNEL) @ UC San Diego

clear; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Apply Model to KF Training Data
opt.modelFile = '/home/kjchen/Documents/tnel_patient-analysis/models/ny531.caffemodel';
[kf_raw, ~, ~, ~] = applyNet(im.namesSaveNatSort, opt, tnelOpt);

%% Load GT KF Training Data
uiopen('matlab');
detections.manual.locs = kf_gt;

%% Train KF noise parameters
[Q,R] = kf_train(kf_gt, kf_raw);

save([pwd '/parameters/QR_' dateTime '.mat'],'Q','R');
