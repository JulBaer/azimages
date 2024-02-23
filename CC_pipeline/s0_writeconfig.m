% % % % WRITE CONFIG FILE FOR CHAMBER IMAGE ANALYSIS PIPELINE % % % %

% This script generates a JSON configuration file used by various scripts
% in the connected chamber image analysis pipeline. Customize the
% parameters below to match your analysis requirements.

%% Initialization - Do not change this section
cfg = struct(); % Initialize configuration structure

%% Configuration File Location
% Define the name and directory for the configuration file.
mainconfigname = 'jbanalysisconfig_cc';
configdir = 'D:\GitHub\azimages\julian\CC_pipeline\';

%% General Configuration Values
% Directory containing image datasets and metadata.
cfg.masterdir = 'E:\Julian\barrier\sharing\'; % Main image directory

% Directory name for saving analysis results.
cfg.savedirname = 'savesV1';

% Name of the metadata CSV file.
cfg.metacsv = 'meta_processing.csv';

% Number of imaging channels (e.g., 1 for phase contrast, 2+ for fluorescence).
cfg.n_channel = 2;

% Bit depth of images (e.g., 8, 16, or 32).
cfg.bitdepth = 16;

%% Preprocessing Variables
% Specify positions to process (empty array [] processes all positions).
cfg.posL = [];

% Rotation angle for images to ensure vertical orientation of chambers.
cfg.rotangle = [];

% Downsampling factors for image registration and chamber detection.
cfg.downsampleF = 0.15;
cfg.downsampleF_chamberdetect = 0.15;

% Intensity scaling thresholds for each channel.
cfg.thr1 = [0, 0.9]; % For 1st channel (e.g., phase contrast)
cfg.thr2 = [0.002, 0.85]; % For 2nd channel (1st fluorescence channel)
cfg.thr3 = [0.002, 0.1]; % For 3rd channel (2nd fluorescence channel)

%% Image Quality and Chamber Detection Parameters
cfg.OOFcutoff = 4; % Out-of-focus cutoff value for frame rejection
cfg.chambelong = 12; % Pixel padding for chamber boundary elongation
cfg.chamw = 8; % Chamber width in pixels after downsampling
cfg.chamb_binthresh = 0.35; % Binarization threshold for chamber detection

%% Channel Naming for Cropped Image Export
cfg.chname1 = 'Ch1'; % Name of the 1st channel
cfg.chname2 = 'Ch2'; % Name of the 2nd channel
cfg.chname3 = 'Ch3'; % Name of the 3rd channel

%% Video Creation Parameters
% Colors for fluorescence channels in the output video.
cfg.col1 = [0.95, 0.99, 0]; % Color for 1st fluorescence channel
cfg.col2 = [1, 0, 0]; % Color for 2nd fluorescence channel
cfg.col3 = [0, 0, 1]; % Color for an additional channel or overlay

% Frame rate and size for the output video.
cfg.vidfr = 10; % Video frame rate
cfg.vidsz = [1024, 1024]; % Video size [width, height]

% Option to overlay chamber boundaries on the output movie (1 = yes, 0 = no).
cfg.burn_chamb = 1;

% Option for live image display during processing.
cfg.liveimages = 0.5; % Display scaling factor (0.5 = 50% size)

%% Stardist Parameters for Cell Segmentation
cfg.stardistmodeldir = 'D://GitHub/azimages/julian/stardist/models/stardist-bar';
cfg.flims = true; % Enable fluorescence data extraction and CSV export
cfg.ramsize = 8000; % Available GPU RAM in MB
cfg.ramlimit = 0.85; % Max proportion of GPU RAM to use

%% JSON File Generation - Do not change this section
% Convert configuration structure to JSON text
jsonText = jsonencode(cfg, 'PrettyPrint', true);

% Write JSON text to file
% Check if 'mainconfigname' ends with '.json'
if ~endsWith(mainconfigname, '.json')
    % If it does not, append '.json' to 'mainconfigname'
    mainconfigname = [mainconfigname, '.json'];
end
fid = fopen(fullfile(configdir, mainconfigname), 'w');
if fid == -1
    error('Cannot create JSON file');
end
fwrite(fid, jsonText, 'char');
fclose(fid);

% Confirmation message
msgbox(['Config file exported: ', fullfile(configdir, [mainconfigname, '.json'])]);
