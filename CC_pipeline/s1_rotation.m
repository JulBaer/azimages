%% Manual Rotation Determination for Image Analysis

% Initialize or reset environment
reload = true;
if reload
    close all; clear; reload = true; % Ensure a clean workspace for the operation
end

%% User-Defined Parameters
% Path to the configuration JSON file
configdir = 'D:\GitHub\azimages\julian\CC_pipeline\';
mainconfigname = 'jbanalysisconfig_cc.json';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% end of user defined parameters %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Configuration and Metadata Loading
% Load configuration from JSON
cfgFilePath = fullfile(configdir, mainconfigname);

% Iterate through each field in the structure
cfg = jsondecode(fileread(fullfile(configdir, mainconfigname)));
fields = fieldnames(cfg);
for i = 1:length(fields)
    fieldName = fields{i};
    fieldValue = cfg.(fieldName);

    % Assign each field to a variable in the base workspace
    assignin('base', fieldName, fieldValue);
end

% Load and preprocess metadata table
metaname = fullfile(masterdir, metacsv);
meta = preprocessMetaTable(metaname);

% Check and proceed only if rotation angles need determination
% Logical array where true indicates a valid entry
validEntries = ~isnan(meta.rotangle) & meta.rotangle >= -360 & meta.rotangle <= 360;

% Check if all entries in 'rotangle' are valid
allValid = all(validEntries);

if allValid
    msgbox('Rotation angle for all replicates recorded.', 'Success')
    return
end

%% Main Rotation Angle Determination Loop
disableWarnings();

% these need to be processed
allrep = unique(meta.replicate(~validEntries));

% set image scaling paramters
maxin_val=(2^bitdepth)-1; %max intensity values possible
thr1 = thr1*maxin_val; % min and max values for mat2gray for PH
thr2 = thr2*maxin_val; % min and max values for mat2gray for GFP
thr3 = thr3*maxin_val; % min and max values for mat2gray for RFP

for repi = 1:numel(allrep)
    replicate = allrep{repi};
    replicate = string(allrep(repi));
    % disp(replicate)

   
    % get id of replicate and main directory
    replind = strcmp((meta.replicate), replicate);
    maindir = fullfile(masterdir, replicate);

    cd(maindir) %set directory to main folder
    alldir=dir('_*'); %list of all dirs inside the main containing images
    

    if sum(isnan(meta.Process(replind)))==0
        procL = meta.Process(replind);
        posL = 1:size(procL);
    else
        procL = [];
        posL = 1:size(alldir, 1);
    end
    

    for posi=posL %go over all folders
        % if there were missing process numbers, get that now from folder name.
    % Otherwise, use that from the meta file
    if isempty(procL)
        % get process number (olympus position ID) from folder name
        dird=[maindir, alldir(posi).name, filesep, 'stack1']; %get dir of image
        procnr = str2double(extract(alldir(posi).name, digitsPattern));
    else
        procnr = procL(posi);
        dird=[maindir, filesep, '_Process_', num2str(procnr), '_', filesep, 'stack1']; %get dir of image
    end
        
    % get index of current position
    metai = replind & meta.Process == procnr;
    if strcmp(meta.Exclude(metai), 'excl'); continue; end
    if strcmp(meta.register(metai), 'Done'); continue; end
    
    dird=fullfile(maindir, alldir(posL(posi)).name, filesep, 'stack1'); %get dir of image
    r = bfGetReader(char(fullfile(dird, filesep, 'frame_t_0.ets'))); %able to pull out just one image instead of entire file
    r = loci.formats.Memoizer(r);
    bf = imadjust(mat2gray(bfGetPlane(r, 1), thr1));

    anglcheck = 1; %run until 0
    qtxt = ['Replicate: ', char(replicate),...
        ' || Insert rotation angle to check (-360 to 360). If you click OK without changing the number, correct angle is assumed'];
    rotangle = 0; %init
    while anglcheck
            bfc = imrotate(bf, rotangle); % apply rotation
            imshow(bfc)
    %         next few lines are for adding a grid
            axis on;
            [rows, columns, numberOfColorChannels] = size(bfc);
            hold on;
            for row = 1 : 200 : rows
              line([1, columns], [row, row], 'Color', 'r');
            end
            for col = 1 : 200 : columns
              line([col, col], [1, rows], 'Color', 'r');
            end
            %get user input for angle
            % Flag to keep the loop running until valid input is received
            validInput = false;
            while ~validInput
                rotangleN = inputdlg(qtxt, 'Rotation angle', 1, {num2str(rotangle)});
                
                % Check if the dialog was cancelled
                if isempty(rotangleN)
                    disp('User cancelled the input.');
                    return; % Exit if user cancelled the input
                else
                    rotangleN = str2double(rotangleN{1}); % Convert the input to a number
                    
                    % Check if the input is a single number, not NaN, and within the desired range
                    if ~isnan(rotangleN) && isscalar(rotangleN) && rotangleN >= -360 && rotangleN <= 360
                        validInput = true; % Input is valid, exit the loop
                    else
                        % Input is invalid, display an error message and prompt again
                        waitfor(msgbox('Invalid input. Please enter a single number between -360 and +360.', 'Error','error'));
                    end
                end
            end

            if rotangleN == rotangle %if it was te same, angle is correct
                anglcheck = 0;
            else %otherwise, update actual rotation angle
               rotangle = rotangleN; 
            end
        end
    % update rotation angle
   meta = preprocessMetaTable(metaname);
   meta.rotangle(replind) = rotangle;
   writetable(meta,...
            metaname,...
            'Delimiter', ',');
    clear r bfc bf rotangleN
    end
end
close all
% Final message indicating completion
msgbox('Rotation angle for all replicates recorded.', 'Success');

%% Supporting Functions

function meta = preprocessMetaTable(metaname)
    % Read and preprocess the metadata table
    opts = detectImportOptions(metaname);
    % Define columns and their desired types
    charColumns = {'Exclude', 'Note', 'register', 'stardist', 'stardist_fails'};
    doubleColumns = {'MaxFr', 'Process', 'StageX', 'StageY', 'PxinUmX', 'PxinUmY', 'BarrierYincrop', 'chamberbox1', 'chamberbox2', 'chamberbox3', 'chamberbox4'};
    
    % Update VariableTypes for specified columns
    for colName = [charColumns, doubleColumns]
        colType = 'char';
        if ismember(colName, doubleColumns)
            colType = 'double';
        end
        opts.VariableTypes{strcmp(opts.VariableNames, colName)} = colType;
    end
    meta = readtable(metaname, opts);
    meta = sortrows(meta, {'replicate', 'pos'}, 'ascend');
end

function disableWarnings()
    % Disable specific MATLAB warnings
    warning('off', 'MATLAB:table:RowsAddedExistingVars');
    warning('off', 'images:imfindcircles:warnForSmallRadius');
    warning('off', 'MATLAB:MKDIR:DirectoryExists');
end