% This script takes .ets files from Olympus as input
% 1) registered .avi movie of each .ets file with timestamp and
% possibility to burn in the chamber box used for image cropping
% 2) .csv file per position/frame about registration: xy translation. nan if
% failed
% 3) Per position/chamber: new folder containing single tif files of all
% channels for each frame ( or stacks). Black image stored if registration failed for
% all channels.

% % note for me: I used a function from here: https://ch.mathworks.com/matlabcentral/fileexchange/68350-image-blur-measurement
% % which needs to cited: http://ijssst.info/Vol-19/No-1/paper7.pdf
% % I modified it to directly take images instead of doing an imread on the
% % inputs

reload = 1; %leave at 1 unless troubleshooting
if reload
    close all
    clear
    reload=1;
end

%% Configuration File Location
% Define the name and directory for the configuration file.
mainconfigname = 'jbanalysisconfig_mm';
configdir = 'C://Users/zinke/Documents/GitHub/azimages/julian/MM_pipeline';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% end of user defined parameters %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





if ~endsWith(mainconfigname, '.json')
    % If it does not, append '.json' to 'mainconfigname'
    mainconfigname = [mainconfigname, '.json'];
end

% Iterate through each field in the structure
cfg = jsondecode(fileread(fullfile(configdir, mainconfigname)));
fields = fieldnames(cfg);
for i = 1:length(fields)
    fieldName = fields{i};
    fieldValue = cfg.(fieldName);

    % Assign each field to a variable in the base workspace
    assignin('base', fieldName, fieldValue);
end

   % read in meta file and assign correct VariableTypes
metaname = fullfile([masterdir, filesep, metacsv]);
meta = preprocessMetaTable(metaname);

% set image scaling paramters
maxin_val=(2^bitdepth)-1; %max intensity values possible
thr1 = thr1*maxin_val; % min and max values for mat2gray for PH
thr2 = thr2*maxin_val; % min and max values for mat2gray for FL1
thr3 = thr3*maxin_val; % min and max values for mat2gray for FL2

%define optimizer and metric for registration, change some parameters
[optimizer,metric] = imregconfig('multimodal'); 
optimizer.InitialRadius=6.e-04;
optimizer.MaximumIterations=300;
optimizer.GrowthFactor=1.05;
optimizer.Epsilon=1.5000e-06;

% disable warnings
disableWarnings();

% list all reps
uniqrep = unique(meta.replicate);

% go over all replicates
for maini = 1:length(uniqrep)
    % get replicate id
    replicate = char(uniqrep(maini));

    % get full folder for the replicate based on the subdir names provided
    for pardi = 1:length(typedirs)
        potmaindir = fullfile(masterdir, char(typedirs(pardi)), replicate);
        if isdir(potmaindir)
            maindir = potmaindir;
        end
    end

    if maindir(end) ~= filesep
        maindir=[maindir, filesep];
    end

    % find which rows correspond to that replicate
    replind = strcmp((meta.replicate), replicate);
    replindx = find(replind);

    % if all are done or marked with anything in register, skip this
    % replicate. Only register == empty will be processed
    todo = 0;
    for checkprog = 1:sum(replind)
        if length(char(meta.register(replindx(checkprog)))) == 0
            todo = todo + 1;
        end
    end
    if todo == 0
        continue
    end

    % update folder name
    meta.maindir(replind) = {maindir};
    
    cd(maindir) %set directory to main folder (replicate)
    alldir=dir('_*'); %list of all dirs inside the main containing images

    % get list of positions
    % if process number is in meta for all positions, use this as this is
    % less error-prone and unique. Otherwise just go by position in the
    % ordered folder list
    if sum(isnan(meta.Process(replind)))==0
        procL = meta.Process(replind);
        posL = 1:size(procL);
    else
        procL = [];
         posL = 1:size(alldir, 1);
    end
        
    %initialize some variables
    focusfail=0; %focus failed
    blurrefimgor = [];  %ref image for focus check
    reg_box_ref = zeros(length(posL),4); %registration image crop box
    curpos = 0; %pos counter

    dird=[maindir, alldir(1).name, filesep, 'stack1']; %get dir of image
    r = bfGetReader([dird, filesep, 'frame_t_0.ets']); %able to pull out just one image instead of entire file
    r = loci.formats.Memoizer(r);

    % load first image
    bf = mat2gray(bfGetPlane(r, 1), thr1);

    % create savedirs
    savedir = [masterdir, filesep, savedirname, filesep, replicate, filesep];
    if ~isfolder(savedir)
        mkdir(savedir)
    end
    vidsavedir = [savedir, 'movies', filesep];
    if ~isfolder(vidsavedir)
        mkdir(vidsavedir)
    end
    reginfofolder = [savedir, 'reginfofolder', filesep];
    if ~isfolder(reginfofolder)
        mkdir(reginfofolder)
    end

%  go over all folders, find chamber positions and detect empty chambers.
%  Optionally, show all to the user and let him/her decide if these should
%  really be discarded   
for posi=posL %go over folders  
    curpos = curpos + 1;
    
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
    
    % get index of replicate and position (based on process nr)
    replind = strcmp(meta.replicate, replicate);
    posind = replind & meta.Process == procnr;

    % if there are none, skip
    if sum(posind) == 0
        if posi == posL(1)
            fix3 = [];
            allchambox = [];
            allflipim = [];
        end
        continue
    end
    
    % If this position is already done or marked for exclusion or skip,  skip rest of the loop
    if strcmp(char(meta.register{posind}), 'Done') || strcmp(char(meta.Exclude{posind}), 'excl') || strcmp(char(meta.Exclude{posind}), 'skip')
        if posi == posL(1)
            rotangle = meta.rotation(posind);
            fix3 = [];
            allchambox = [];
            allflipim = [];
        end
        if ~strcmp(char(meta.register{posind}), 'Done')
            meta.register(posind) = {'Marked as excluded'};
        end
        continue
    end

    % init lists for detection of which type of FOV (middle, top, bottom)
    if posi == 1 || ~exist('onerow')
        onerow = zeros(size(posL,2),1); %we have only 1 row of chambers
        onerowtop = zeros(size(posL,2),1); %we have only 1 row of chambers
    end

    % display to user which folder is processed currently
    disp(['Preprocessing: Replicate: ', replicate, ' (', num2str(maini, '%02.f'),'/',num2str(length(uniqrep),'%02.f'),...
            ') | Position Nr. ', num2str(posi, '%02.f'),' (',num2str(curpos,'%02.f'), '/' num2str(length(posL),'%02.f'), ')']);
    
    % assign process number if it was empy
    if isnan(meta.Process(posind))
        meta.Process(posind) = procnr;
    end
    
%     init the bioformats reader
    clear r
    try
        r = bfGetReader([dird, filesep, 'frame_t_0.ets']);
    catch
        if posi == posL(1)
            rotangle = [];
            fix3 = [];
            allchambox = [];
            allflipim = [];
        end
        meta.register(posind) = {''};
        continue
    end
    r = loci.formats.Memoizer(r);
    loci.common.DebugTools.setRootLevel('DEBUG');
    omeMeta = r.getMetadataStore();
    % get the stage position and calibration factor values
    meta.StageX(posind)=double(omeMeta.getPlanePositionX(0,0).value);
    meta.StageY(posind)=double(omeMeta.getPlanePositionY(0,0).value);
    meta.PxinUmX(posind)=double(omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER));
    meta.PxinUmY(posind)=double(omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER));

%     read in first image.
    bi = 1;
    clear bf
    bf = mat2gray(bfGetPlane(r, bi), thr1);
    
    %downsample for registration reference
    fixed=imresize(bf,downsampleF);
    size_fixed = size(fixed);
    
    % init some variables if this is first of position list or if the
    % rotation angle is still empty
    if posi == posL(1) || isempty(rotangle)
        rotangle = [];
        if ~isempty(rotangleimpose)
            rotangle = rotangleimpose;
            bf = imrotate(bf, rotangle);
        end
        fix3 = [];
        allchambox = [];
        allflipim = [];
    else
        if ~isempty(rotangleimpose)
            rotangle = rotangleimpose;
        end
        bf = imrotate(bf, rotangle);
    end
    
    bfO = bf; %save the first image
    
    % this function performs processing of the first frame:
    % a) rotation correction estimation (only if not done for that
    % replicate)
    % b) find area for image registration
    % (the numbers either above (top row), in between
    % (middle row) or below (bottom row) the chambers);
    % c) Find area of chambers to extract
    [onerow ,reg_box_ref, rotangle, fix3, allchambox, allflipim, posL, onerowtop, skippos] =...
    frameONEprocessing(bfO, downsampleF, downsampleF_chamberdetect,...
        posi, size_fixed, chamw, posL, onerow, rotangle, fix3, savedir,...
        savestack, maxrotangle, allchambox, allflipim, reg_box_ref, onerowtop,...
        emptychamuser, shortenchamber, char(meta.Exclude{posind}), rotangleimpose);

    if skippos
        if posi == posL(1)
            rotangle = [];
            fix3 = [];
            allchambox = [];
            allflipim = [];
        end
        meta.register(posind) = {'frame1failure'};
        continue
    end

    % add info of FOV type to meta table
    if ~isnan(onerow(posi))
        meta.MiddleRow(posind) = ~onerow(posi);
        meta.nchambers(posind) = size(allchambox{posi}, 1);
        if onerow(posi)
            flps = allflipim{posi};
            meta.Top1Bot0FRow(posind) = unique(flps);
        else
            meta.Top1Bot0FRow(posind) = nan;
        end
    else
        meta.MiddleRow(posind) = nan;
        meta.Top1Bot0FRow(posind) = nan;
        meta.nchambers(posind) = nan;
        meta.register(posind) = {'frame1failure'};
    end
    
    % and the rotation angle
    meta.rotation(posind) = rotangle; 
    
    bfO = bf; %save the first image
    szfix(posi) = imref2d(size(bfO)); %get reference coordinates
    end

% now store all that meta info
try
    writetable(meta,...
    [masterdir, filesep, 'meta_processing.csv'],...
    'Delimiter', ',');
catch
    writetable(meta,...
    [masterdir, filesep, 'meta_processing-temp.csv'],...
    'Delimiter', ',');
end

% % % % main part
close all; f=figure('NextPlot', 'replacechildren', 'MenuBar', 'none', 'ToolBar', 'none');
ax1 = axes();
ax1.Toolbar.Visible = 'off';
ax1.PickableParts = 'none';
ax.XLim = [1 410];
ax.YLim = [1 410];
curpos = 0;
for posi=posL %go over folders/position
    
    %init VideoWriter
    if isempty(procL)
        % get process number (olympus position ID) from folder name
        dird=[maindir, alldir(posi).name, filesep, 'stack1']; %get dir of image
        procnr = str2double(extract(alldir(posi).name, digitsPattern));
    else
        procnr = procL(posi);
        dird=[maindir, filesep, '_Process_', num2str(procnr), '_', filesep, 'stack1']; %get dir of image
    end
    
    % get index of replicate and position (based on process nr)
    replind = strcmp(meta.replicate, replicate);
    posind = replind & meta.Process == procnr;

    cd(savedir)
    
    regfail = 0;%init
    clf('reset')
    ti = 1; %start at t=1
    curpos = curpos+1;
    deltaT = meta.dt(posind);

    if strcmp(char(meta.Exclude{posind}), 'excl') ||...
            strcmp(char(meta.Exclude{posind}), 'skip') ||...
            strcmp(char(meta.Exclude{posind}), 'frame1failure') ||...
            strcmp(char(meta.register{posind}), 'Marked as excluded')
        meta.register(posind) = {'Marked as excluded'};
        continue
    end
    if strcmp(char(meta.register{posind}), 'Done')
        continue
    end
    if sum(posind) == 0
        continue
    end
    
    try %init video writer for movie inside savedir
        vidname = [vidsavedir, 'Pos',num2str(posi,'%02.f'),'.avi'];
        vidOV = VideoWriter(vidname, 'Motion JPEG AVI');
    catch
        close(vidOV);
        vidOV = VideoWriter(vidname, 'Motion JPEG AVI');
    end
    vidOV.FrameRate = vidfr; %set framerate
    open(vidOV); %open writer

    %init the bioformats image reader for the current position
    if reload
        clear r
        r = bfGetReader([dird, filesep, 'frame_t_0.ets']);
        r = loci.formats.Memoizer(r);
        loci.common.DebugTools.setRootLevel('DEBUG');
    end

    %get the number of images in there is no user-specified max frame
    if ~isnan(meta.MaxFr(posind))
        n_im = meta.MaxFr(posind);
    else
        n_im = r.getImageCount()/n_channel; %auto-calc
    end

            % Initialize empty registration table with specified variable names and types
    Tregistration = table(...
        cell(0, 1), ... % Empty cell array for 'replicate' (string)
        [], [], [], [], [], [], ... % Empty arrays for 'pos', 'frame', 'x_reg', 'y_reg', 'BlurVal'. 'Process' (numeric)
        'VariableNames', {'replicate', 'pos', 'frame', 'x_reg', 'y_reg', 'BlurVal', 'Process'
    });

    % go over all frames
    disp(['Image registration and chamber extraction. Current position: ', num2str(posi)])
    for tind=1:n_im
        ti=tind;
        % user update:
        disp(['Replicate: ', replicate, ' (', num2str(maini, '%02.f'),'/',num2str(length(uniqrep),'%02.f'),...
            ') | Position Nr. ', num2str(posi, '%02.f'),' (',num2str(curpos,'%02.f'), '/' num2str(length(posL),'%02.f'),...
            ') | Frame: ', num2str(ti, '%03.f'), '/' num2str(n_im,'%03.f')]);

    % part for more than 1 channel. Coded & tested with either phasecontrast only 
    % or phasecontrast + 1 or 2 FL channel
     % Initialize the channel images to zeros
        bf = [];
        gfp = [];
        rfp = [];

        % Calculate base index for the current time point
        baseIndex = (ti - 1) * n_channel;
        if n_channel == 1
            % For single-channel data, only process the BF channel
            bi = ti; % Brightfield index is directly based on time index
            bf = mat2gray(bfGetPlane(r, bi), thr1);
            % Rotate image if needed
            bf = imrotate(bf, rotangle);
            % GFP and RFP channels are not applicable, so create empty arrays
            gfp = zeros(size(bf));
            rfp = zeros(size(bf));
        else
            % For multi-channel data, calculate indexes based on the number of channels
            bi = baseIndex + 1; % Brightfield channel index
            gi = baseIndex + 2; % GFP channel index
            
            % Load and process Brightfield and GFP channels
            bf = mat2gray(bfGetPlane(r, bi), thr1);
            gfp = mat2gray(bfGetPlane(r, gi), thr2);
            
            % Rotate images if needed
            bf = imrotate(bf, rotangle);
            gfp = imrotate(gfp, rotangle);
            
            if n_channel > 2
                % If there is an RFP channel, process it
                ri = baseIndex + 3; % RFP channel index
                rfp = mat2gray(bfGetPlane(r, ri), thr3);
                rfp = imrotate(rfp, rotangle);
            else
                % If no RFP channel, create an empty array
                rfp = zeros(size(bf));
            end
        end

%if it is the first frame, use this as the alignement reference
        if ti==1 
            tform = affine2d(); %reset registration
            
%                     write info to registration table
            Tregistration.pos(end+1)=posi;
            Tregistration.frame(end)=ti;
            Tregistration.x_reg(end)=0;
            Tregistration.y_reg(end)=0;
            pat = digitsPattern;
            Tregistration.Process(end)=str2double(extract(alldir(posi).name, pat));
            
            chambox = allchambox{posi}; %get the current chamber box again
            flipim = allflipim{posi}; % get the current flag for image flipping
            skipcham = zeros(size(chambox,1), 1); %init skip flag for chambers
            bfO = bf; %backup frame 1
            blurrefimgor = imresize(bfO,0.1); %blur reference image
            fixed = imresize(bfO,downsampleF);%downsample
            size_fixed = size(fixed);
            clear fixed                  
            
        else %all other images are aligned to the 1st image
            % init registration section
            mov3=imcrop(imresize(bf,downsampleF),reg_box_ref(posi,:)); 

            %this function performs the image registration
            [regfail, tform, reg_box_mov, blurval] =...
                registerimages(bf, bfO, downsampleF, downsampleF_chamberdetect, ...
                onerow, onerowtop, size_fixed, reg_box_ref, posi, fix3, OOFcutoff, ...
                rotangle, optimizer, metric, ti, Tregistration);

            % apply registration to BF, GFP and RFP
            if ~regfail
                bf = imwarp(bf,tform,'OutputView',szfix(posi));
                if n_channel>1
                    gfp = imwarp(gfp,tform,'OutputView',szfix(posi));
                else
                    gfp = zeros(size(bf));
                end
                if n_channel>2
                    rfp = imwarp(rfp,tform,'OutputView',szfix(posi));
                else
                    rfp = zeros(size(bf));
                end
            end

            % save registration info into table
            Tregistration.pos(end+1) = posi;
            Tregistration.frame(end) = ti;
            Tregistration.BlurVal(end) = blurval;
            Tregistration.Process(end) = str2double(extract(alldir(posi).name, digitsPattern));
            if ~regfail
                Tregistration.x_reg(end) = tform.T(3,1);
                Tregistration.y_reg(end) = tform.T(3,2);
            else
                Tregistration.x_reg(end) = nan;
                Tregistration.y_reg(end) = nan;
            end
        end
                 
% write movies and cropped chamber images 
        for chi=1:size(chambox,1)
            crbx=chambox(chi,:); %crop box for chamber
            skip=0; %track if there is a reason to skip the chamber
            
            %1) skip if the chamber is actually out of the current image. It
            %can be moved out due to image drift and following
            %registration
            if regfail
               skip=1;
            else
                if tform.T(3,1)<0 
                    if crbx(1)+crbx(3)-tform.T(3,1)>size(bf,1)
                        skip=1;
                    end
                else
                    if crbx(1)-tform.T(3,1)<1
                        skip=1;
                    end
                end
            end
            
%                       if a skip is indicated, a black image will be
%                     exported. Create this now
            if skip
                bcr=imcrop(bf, crbx); 
                bcr=zeros(size(bcr));
                if n_channel>1
                    gcr=zeros(size(gcr));
                end
                if n_channel>2
                    rcr=zeros(size(rcr));
                end
                skipcham(chi) = skipcham(chi)+1;

            else %if no skip
%                       crop the images
                bcr=imcrop(bf, crbx); 
                if n_channel>1
                    gcr=imcrop(gfp, crbx);
                else
                    gcr = zeros(size(bcr));
                end
                if n_channel>2
                    rcr=imcrop(rfp, crbx);
                else 
                    rcr = zeros(size(bcr));
                end
            
                if flipim(chi) %flip images so all have the same orientation. Helps for DeLTA tracking
                   bcr = imrotate(bcr, 180); 
                    if n_channel>1
                        gcr=imrotate(gcr, 180);
                    end
                    if n_channel>2
                        rcr=imrotate(rcr, 180);
                    end
                end
            end

            
            % get image name
            if savestack
                genname =[savedir,'Chambers',filesep,...
                  'Pos', num2str(posi,'%02.f'),...
                  filesep, 'Pos', num2str(posi,'%02.f'), '_Chamb',num2str(chi,'%02.f'), '_'];
            else
                  genname = [savedir,'Chambers',filesep,...
                  'Pos', num2str(posi,'%02.f'),...
                  filesep, 'Chamb',num2str(chi,'%02.f'),filesep,...
                  'Chamb',num2str(chi,'%02.f')];
            end
          
            % and save the images
          saveimages(savestack, genname, bitdepth, n_channel, maxin_val, bcr, gcr, rcr, ti, chname1, chname2, chname3);
           
          % if at last frame, check how many frames failes due to
          % any reason. If more than the thrshold, delete the
          % images of that chamber again
            if checkfailedchambers
                if ti==n_im && skipcham(chi)>maxfailedchamber*n_im
                     rmdir([savedir,'Chambers',filesep,...
                          'Pos', num2str(posi,'%02.f'),...
                          filesep, 'Chamb',num2str(chi,'%02.f')], 's');
                end
            end
        end
                
        % create movie frame
        ov = movieframecreation(bf, gfp, rfp, n_channel,...
            regfail, chambox, col1, col2, col3, burn_chamb, meta, deltaT, posind, ti);
        
        % resize it
        ov = imresize(ov, vidsz);
        
        % show it
        if liveimages>0
            m = imshow(imresize(ov, liveimages));
            drawnow %made that the display on fig is updated                
        end

        %write the movie
        writeVideo(vidOV, ov);
         
        % if last frame, close movie and check chamber naming. Delta
        % cannot deal with positions that do not start with a chamber
        % nr 01... I rename all chambers to have consecutive nr
        % starting at 1 if that would happen because chamber 1 was excluded
        % eg because the registration moved it out too much
        if ti==n_im
             close(vidOV)
             if checkfailedchambers
                 cd([savedir,'Chambers',filesep,...
                              'Pos', num2str(posi,'%02.f')]);
                  chambdirs = dir('*Cham*');
                  if ~isempty(chambdirs)
                      ch1 = chambdirs(1).name;
                      ch1 = str2num(ch1(end-1:end));
                      chn = string({chambdirs(:).name});
                      chn = (extract(chn,digitsPattern));
                      chn = str2num(char(chn(:)));
            
                      if ch1 ~= 1 | sum(chn - [0; chn(1:end-1)]~=1)>0
                          disp(['Correcting folder names... Current position: ', num2str(posi)])
                          for icham = 1:length(chambdirs)
                              chname = chambdirs(icham).name;
                              oldnum = str2num(chname(end-1:end));
                              if oldnum == icham; continue; end
                              newnum = [chname(1:end-2), num2str(icham, '%02.f')];
            
                              segd = dir('*seg_*');
                              if ~isempty(segd); runs = 2; else; runs=1; end
                              try
                                  for runi = 1:runs
                                      if runi==1
                                        cd([chambdirs(icham).folder, filesep, chname])
                                      elseif runi==2
                                        cd([chambdirs(icham).folder, filesep, chname, filesep, 'seg_sd2'])
                                      end
                                      imgs = dir('*.tif*');
                                      for ifiles = 1:length(imgs)
                                          oldname = imgs(ifiles).name;
                                          newname = [newnum, oldname(length(newnum)+1:end)];
                                          movefile(oldname, newname)
                                      end
                                  end
                                  cd([chambdirs(icham).folder])
                                  movefile(chname, newnum)
                              catch
                                  runs = 0;
                              end
                          end
                          if runs==2
                              cd([chambdirs(icham).folder])
                              cd ..
                              cd data
                              curposi = ['Pos', num2str(posi, '%02.f')];
                              imgs = dir([curposi, '*']);
                              for ifiles = 1:length(imgs)
                                  oldname = imgs(ifiles).name;
                                  newname = [curposi,...
                                      newnum, '.csv'];
                                  movefile(oldname, newname)
                              end
                          end
                      end
                  end
             end
         
        %                  save register in meta file
             meta.register(posind) = {'Done'};
             currow = meta(posind,:);
             meta = preprocessMetaTable(metaname);
             meta(posind,:) = currow;
            try
                writetable(meta,...
                [masterdir, filesep, 'meta_processing.csv'],...
                'Delimiter', ',');
            catch
                writetable(meta,...
                [masterdir, filesep, 'meta_processing-temp.csv'],...
                'Delimiter', ',');
            end
        
            try
            writetable(meta,...
                [masterdir, filesep, 'meta_processing_', char(datetime('today', 'Format','yyyy-MM-dd')), '.csv'],...
                'Delimiter', ',');
            catch
            end
        end
    end %end of time loop

    % write registration info table
    writetable(Tregistration,...
        [reginfofolder,'Pos', num2str(posi,'%02.f'),'_registration.csv'],...
        'Delimiter', ',')

    clear Tregistration
    end %end of all things!
end


function disableWarnings()
    % Disable specific MATLAB warnings
    warning('off', 'MATLAB:table:RowsAddedExistingVars');
    warning('off', 'images:imfindcircles:warnForSmallRadius');
    warning('off','MATLAB:MKDIR:DirectoryExists')
    warning('off', 'images:regmex:registrationOutBoundsTermination')
end

function meta = preprocessMetaTable(metaname)
    % Read and preprocess the metadata table
    opts = detectImportOptions(metaname);
    % Define columns and their desired types
    charColumns = {'Exclude', 'Note', 'register', 'stardist', 'stardist_fails', 'delta', 'delta_fails'};
    doubleColumns = {'MaxFr', 'Process', 'StageX', 'StageY', 'PxinUmX', 'PxinUmY',...
        'MiddleRow', 'Top1Bot0FRow', 'nchambers', 'rotation'};
    
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


% this function does the processing of the first frame: detect area for
% registration and detect filled chambers
function [onerow ,reg_box_ref, rotangle, fix3, allchambox, allflipim, posL, onerowtop, skippos] =...
    frameONEprocessing(bfO, downsampleF, downsampleF_chamberdetect,...
    posi, size_fixed, chamw, posL, onerow, rotangle, fix3, savedir,...
    savestack, maxrotangle, allchambox, allflipim, reg_box_ref, onerowtop,...
    emptychamuser, shortenchamber, excl, rotangleimpose)
    try        
        if ~isempty(rotangleimpose)
            rotangle = rotangleimpose;
        end
        rotanglewasempty = isempty(rotangle); %to ensure we then apply the rotation afterwards
        
        %do the chamber detection initialization
        [chambs, chambs1, onerow, rotangle, chambs1bck, onerowtop] = ...
            chamberdetectioninitialize(bfO, downsampleF,...
            downsampleF_chamberdetect, posi, onerow, rotangle, maxrotangle, onerowtop, emptychamuser);

        % apply rotation if this wasn't done before
        if rotanglewasempty
           bfO = imrotate(bfO, rotangle); 
        end
        %       Find area of number labels. This is used for image
        %       registration. Slightly different approaches for one and double row
        %       images    
        chambs1=imresize(chambs1,size_fixed); %resize to main image size
        sft=floor(size(chambs1,1)*0.01); %padding by this many pixels
    
        if onerow(posi) %onerow case
            reg_box_ref(posi,1) = 1; %start at x=1
            reg_box_ref(posi,3) = size(chambs1,1); %go until end of image
            
            props=regionprops(chambs1,'Area', 'PixelIdxList'); %get pixel IDX of the 1 big object (chambers)
            chambs1bck=imresize(chambs1bck,size_fixed); %resize backup main binarization to registration image size
            propsAll=regionprops(chambs1bck,'Area', 'PixelIdxList'); %get pixel IDX of the all object (chambers)
    
            if size(propsAll,1) > 1
                chambs1bck(props(1).PixelIdxList)=0; %remove the 1 big object (chambers) from backup
                % and clean top and back parts
                if onerowtop(posi)
                    chambs1bck(:, round(size(chambs1bck,1)/2):size(chambs1bck,1)) = 0;
                else
                    chambs1bck(:, 1:round(size(chambs1bck,1)/2)) = 0;
                end
                props=regionprops('table', chambs1bck, 'BoundingBox'); %get bounding box of the remaining objects
                
                reg_box_ref(posi,2) = min(props.BoundingBox(:,2)) - sft; %take smallest Y and pad
                reg_box_ref(posi,4) = max(props.BoundingBox(:,4)) + 2*sft; %take largest one and pad
            else
                props=regionprops('table', chambs1bck, 'BoundingBox'); %get bounding box of the remaining objects          
                if onerowtop(posi)
                    reg_box_ref(posi,2) = ceil(2*sft); %take smallest Y and pad
                    reg_box_ref(posi,4) = floor(props.BoundingBox(1,2) -sft -reg_box_ref(posi,2)); %take largest one and pad
                else
                    reg_box_ref(posi,2) = ceil(props.BoundingBox(1,2) + props.BoundingBox(1,4) + sft); %take smallest Y and pad
                    reg_box_ref(posi,4) = size(chambs1,2) - 2*sft - reg_box_ref(posi,2); %take largest one and pad
                end
            end
            
        else %two row case
            reg_prop = regionprops('table', chambs1, 'BoundingBox'); %get bounding boxes of two regions containing chambers
            reg_box_ref(posi,1)=1; %start at x=1
            [~,topi]=min(reg_prop.BoundingBox(:,2)); %which one is the top region?
            if topi==1
                boti=2;
            else
                boti=1;
            end %assign id for bottom region
            reg_box_ref(posi,2) = reg_prop.BoundingBox(topi,2)+...
                reg_prop.BoundingBox(topi,4) - sft; % y start based on previous area detection - padding
            reg_box_ref(posi,3) = size(chambs1,1); %go until end of image
            reg_box_ref(posi,4)=reg_prop.BoundingBox(boti,2) - ...
                reg_box_ref(posi,2) + sft*2; % y end based on previous area detection + padding
        end

    reg_box_ref(posi,:)=round(reg_box_ref(posi,:)); %round bounding box it
    if abs(rotangle)>0 % if there was some rotation applied, crop away some X-border as well to not include black area
        reg_box_ref(posi,1) = round(0.02*reg_box_ref(posi,3));
        reg_box_ref(posi,3) = reg_box_ref(posi,3) - reg_box_ref(posi,1);
    end

    %this is the final image crop for registration
    fix3{posi}=(imcrop(imresize(bfO,downsampleF),reg_box_ref(posi,:))); 

    % Find position of chambers
    B = imopen(imclose(chambs,strel('line',30,90)), strel('line',20,90));
    B = bwmorph(B, 'skel'); %skeletonize 1
    B = bwareaopen(B,5,4); %open
    B = bwmorph(B, 'skel', 'Inf'); %skeletonize 2
    B = imdilate(B, strel('disk', 1)); %dilate it
    rowsum = sum(B,2); %calc rowsum
    rowsum = rowsum>0.3*size(B,1); %find rows with big filled part
    B(rowsum,:)=0; %and exclude areas with big filled regions
    B = imclose(B, strel('line',5,90)); %close image with a vertical line (close the chambers)
    B = logical(B -(imerode(B,strel('line',5,0)))); %erode away a horizontal line
    B = bwskel(B); %and reskeletonize

    %find remaining objects, remove non-vertical objects
    %and objects with a small length
    props=regionprops(B,'MajorAxisLength','Orientation', 'PixelIdxList');
    for ind=1:size(props,1)
        ori=abs(props(ind).Orientation);
        if ~(ori>70 && ori<110) %keep only objects with angle between 70 and 110
            B(props(ind).PixelIdxList)=0;
        end
        if props(ind).MajorAxisLength<5 %keep only 5+px long skeleton objects
            B(props(ind).PixelIdxList)=0;
        end
    end

    %refind chamber objects
    props=regionprops('table',B, 'BoundingBox', 'Centroid');
    chamlen=quantile(props.BoundingBox(:,4), 0.95); %use 95 percentile of the length as reference
    chamlen = min([chamlen, 48]); %but it should be min 48
    chamlen = ceil(chamlen*1.05); %increase length

    skippos = 0;
    %define start points of the chambers in y axis
    if onerow(posi) %case of 1 row
        if onerowtop(posi) %if bottom chambers
            yrow = floor(quantile(props.BoundingBox(:,2) + props.BoundingBox(:,4), 0.2) + 2 - chamlen); %top end of chamber area
            flipim = ones(size(props.Centroid(:,1),1),1); %we'll flip these images
            skippos = strcmp(excl, 'top');
        else
            yrow=ceil(quantile(props.BoundingBox(:,2) + props.BoundingBox(:,4), 0.8)+...
           3-chamlen); %top end of chamber area
            flipim = zeros(size(props.Centroid(:,1),1),1); %don't flip these
            skippos = strcmp(excl, 'bot');
        end
        xs = props.Centroid(:,1)-chamw/2; %get x position

    %         define the crop boxes of each chamber
        chambox=round([xs,...
            repmat(yrow, size(xs)), ...
            repmat(chamw, size(xs)), ...
            repmat(chamlen, size(xs))]);
    else %2 rows
        ytoprow = ceil(quantile(props.BoundingBox(:,2) + props.BoundingBox(:,4), 0.4) + 3 - chamlen); %define y top of top row
        ybotrow = floor(quantile(props.BoundingBox(:,2), 0.7) -3);%define y top of bottom row

        %find the ones in the top row
        props.intoprow = props.BoundingBox(:,2)<(ytoprow+ybotrow)/2;

        ybotrow = floor(quantile(props.BoundingBox(~props.intoprow,2), 0.1) -2);%define y top of bottom row

        %and the ones in the bottom
        xbot = props.Centroid(~props.intoprow,1);

        %extract the x values for both
        sel=logical([diff(xbot)>3;1]);
        xbot=xbot(sel); % X of bottom row                   
        xtop = props.Centroid(props.intoprow,1); % X of top row
        sel=logical([diff(xtop)>3;1]);
        xtop=xtop(sel);

        % need to check what I am doing here..? I think I check that the
        % spacing is more or less equal and remove spurious chamber starts
        % in between
        dtop = [xtop(2:end);0] - xtop; dtop = dtop(1:end-1);
        dbot = [xbot(2:end);0] - xbot; dbot = dbot(1:end-1);
        avd = mean([dtop;dbot]);
        cutd = quantile([dtop;dbot], 0.9) + 5;

        %filter spurious chamber starts and sort them
        if ~isempty(find(dtop>cutd))
            xtop = sort([xtop;(xtop(find(dtop>cutd)):avd:xtop(find(dtop>cutd)+1))']);
        end
        if ~isempty(find(dbot>cutd))
            xbot = sort([xbot;(xbot(find(dbot>cutd)):avd:xbot(find(dbot>cutd)+1))']);
        end
        
%         exclude chambers close to image edge. likely be excluded by
%         registration correction anyway...
        xtop = xtop(xtop<0.975*size(B,2));
        xbot = xbot(xbot<0.975*size(B,2));
        xtop = xtop(xtop>0.025*size(B,2));
        xbot = xbot(xbot>0.025*size(B,2));
    
        %combine again
        if strcmp(excl, 'top')
            xs=floor([xbot])-chamw/2;
            chambox=round([xs,...
                [repmat(ybotrow, size(xbot))], ...
                repmat(chamw, size(xs)), ...
                repmat(chamlen, size(xs))]); 
            flipim = [ones(size(xbot))]; %which ones to flip?
        elseif strcmp(excl, 'bot')
            xs=floor([xtop])-chamw/2;
            chambox=round([xs,...
                [repmat(ytoprow, size(xtop))], ...
                repmat(chamw, size(xs)), ...
                repmat(chamlen, size(xs))]); 
            flipim = [zeros(size(xtop))]; %which ones to flip?
        else
            xs=floor([xtop;xbot])-chamw/2;
            %final list of chamber cropping boxes
            chambox=round([xs,...
                [repmat(ytoprow, size(xtop)); ...
                repmat(ybotrow, size(xbot))], ...
                repmat(chamw, size(xs)), ...
                repmat(chamlen, size(xs))]); 
            flipim = [zeros(size(xtop)); ones(size(xbot))]; %which ones to flip?
        end
        
    end

if skippos
    return
end

    %     this is a diagnostic plot I sometimes use

%                         figure;
% %                         imshow(chambgr);
%     %                     imshow(B);
%                         imshow(chambs);
%                         hold on;
%                         for k = 1 : length(chambox)
%                             thisBB = chambox(k,:); % Or allBB(k, :)
%                             rectangle('Position',  thisBB, 'EdgeColor', 'r', 'LineWidth', 1);
%                         end
%                         hold off;

    %scale up again!
    chambox=chambox*1/downsampleF_chamberdetect;
    close all
    %make sure that cropping areas are within the actual
    %image:
    sel=chambox(:,1)<1;
    chambox(sel,3) = chambox(sel,3)-abs(chambox(sel,1));
    chambox(sel,1) = 1;
    sel=(chambox(:,1)+chambox(:,3))>size(bfO,1);
    chambox(sel, 3) = ...
        size(bfO,1) - chambox(sel,1);

    %         cut out small image and look for circles. If none are found,
    %         discard this chamber. Optionally, let user decide if they really
    %         should be deleted or just use all
    if emptychamuser == 0 || emptychamuser == 1
        chamempty = zeros(size(chambox,1),1);
        for chi=1:size(chambox,1)
            crbx=chambox(chi,:); %crop box for chamber
            bcr=imcrop(bfO, crbx); %crop the images
        %         find circles:
            [cen, rad] = imfindcircles(bcr, [5, 20], 'ObjectPolarity', 'dark',...
                'Method' ,'TwoStage', 'Sensitivity', 0.7);
    

            if emptychamuser == 1 %manual user chamber selection
                figure;imshow(bcr); viscircles(cen,rad);
    
                answer = questdlg('Discard chamber?', ...
	                'Chamber selection', ...
	                'Keep','Discard','Cancel','Keep');
                % Handle response
                switch answer
                    case 'Keep'
                        chamempty(chi) = 0;
                    case 'Discard'
                        chamempty(chi) = 1;
                    case 'Cancel'
                        return
                end
            else %automatic chamber selection
                % if no circles have been found, I consider this chamber as empty
                if isempty(cen)
                    chamempty(chi) = 1;
                end
            end
        end
    
        nempty = sum(chamempty); %are there any empty chambers?
        if nempty > 0 %yes
            emptyid = find(chamempty == 1); %which chamber ids?
            chambox(emptyid,:) = []; %remove
            flipim(emptyid) = []; %remove
        end
    end

    % use only bottom ~1/3 of chamber or the entire one?
    if shortenchamber
        newlen = round(max([unique(round(chambox(:,4)*0.65)), 180])); %get new length of chamber
        shift = floor(unique(chambox(:,4)) - newlen); %the shift that needs to be applied
    
        chambox(:,4) = newlen; %assign new length
        chambox(find(flipim),2) = chambox(find(flipim),2) + round(shift*0.1); %move y start
        chambox(find(~flipim),2) = chambox(find(~flipim),2) + shift - round(shift*0.1); %move y start
    end

    % %     a diagnostic plot
%         figure;imshow(bfO); 
%         hold on;
%         for k = 1 : length(chambox)
%             thisBB = chambox(k,:); % Or allBB(k, :)
%             rectangle('Position',  thisBB, 'EdgeColor', 'r', 'LineWidth', 1);
%         end
%         hold off;

    chambox=round(chambox);
    for bxi = 1:size(chambox,1)
        if ~mod(chambox(bxi,3), 2)
           chambox(bxi,3) = chambox(bxi,3)+1;
        end
        if ~mod(chambox(bxi,4), 2)
           chambox(bxi,4) = chambox(bxi,4)+1;
        end
    end
    allchambox{posi} = chambox; %cell of all chamboxes
    close all
    allflipim{posi} = flipim; %cell of the image flip flag

    clear chambs xs sel xtop xbot props B chambs1 bfc1 bfc2  ytoprow ybotrow
    clear flipim

    %     make a dir per Position
    fname = [savedir,'Chambers',filesep,...
      'Pos', num2str(posi,'%02.f')];
      try
        rmdir(fname, 's');
      catch
      end
    mkdir(fname);

    if ~savestack
       for k = 1 : length(chambox)
            fname2 = [fname, filesep, 'Chamb',num2str(k,'%02.f')];
            mkdir(fname2);
        end
    end
        clear chambox
    catch % any error, reset values and display an error. but just continue with next pos
        posL = posL(posL ~= posi);
        allchambox{posi} = nan(1,4); %cell of all chamboxes
        allflipim{posi} = nan; %cell of the image flip flag
        reg_box_ref(posi,:) = nan(1,4);
        fix3{posi} = nan(4,4);
        onerow(posi)=nan;
        skippos = 1;
        disp(['Chamber detection error at position ', num2str(posi), '. Discarded!!'])
    end
end


% This function is for the chamber detection. Used only for frame 1
% processing
function [chambs, chambs1, onerow, rotangle, chambs1bck, onerowtop] = ...
            chamberdetectioninitialize(bfO, downsampleF,...
            downsampleF_chamberdetect, posi, onerow,...
            rotangle, maxrotangle, onerowtop, emptychamuser)
        
    chambs = imresize(bfO,downsampleF_chamberdetect); %resize
    chambs = smallimgprocessing(chambs); %get a filtered and smoothed grayscale image

    chambgr=chambs; %backup grayscale

    bthresh = graythresh(chambgr)-0.05; %get binarize threshold
    bfc1=imbinarize(chambgr, bthresh);  %binarize imshow(bfc1)
    percb = sum(bfc1(:))/(size(bfc1,1)*size(bfc1,2)); %check if binarization was okish
    upb = bfc1(1:floor(size(bfc1,1)/2),:); % get percentage foreground in upper half of image
    botb = bfc1(ceil(size(bfc1,1)/2):size(bfc1,1),:); % get percentage foreground in lower half of image
    percbup = sum(upb(:))/(size(upb,1)*size(upb,2)); %check if binarization was okish
    percbbot = sum(botb(:))/(size(botb,1)*size(botb,2)); %check if binarization was okish
    
    % Determine FOV position based on percentage of foreground in full,
    % upper and lower binary image
    if percbbot < 0.075
        percb = percbup;
        potonerow = 1;
    elseif percbup < 0.075
        percb = percbbot;
        potonerow = 1;
    else
        potonerow = 0;
    end
        lothrbin = 0.21;
        hithrbin = 0.3;

        % adjust threshold for binarization if too small or big
    if percb<lothrbin
        if percb<0.14
            bfc1 = imbinarize(chambgr, bthresh-0.14);  %binarize
        else
            bfc1 = imbinarize(chambgr, bthresh-0.1);  %binarize
        end
    elseif percb>hithrbin
        bfc1 = imbinarize(chambgr, bthresh+0.08);  %binarize
    end
    
%     rotation angle detection (only 1st position per replicate)
    chambs = bfc1;%reassign    
    if posi==1 || isempty(rotangle)
        bfc1 = imdilate(bfc1, true(9,9)); % dilate
        bfc1 = imfill(bfc1,"holes"); % fill holes
        
        % keep 1 or 2 objects depending if middle FOV or not
        if potonerow
            bfc1 = bwareafilt(bfc1, 1);
        else
            bfc1 = bwareafilt(bfc1, 2);
        end
        
        % shorten image a bit
        shorten = floor(0.05*size(bfc1,1));

        bfc1 = bfc1(:,shorten:end-shorten);
        
        % fill horizontal lines to generate a big block
        s=sum(bfc1,2); 
        for ilin=1:length(s)
            if s(ilin)>length(s)*0.2
               bfc1(ilin,:) = 1; 
            end
        end
        bfc1(1,:) = 0; bfc1(:,1) = 0;
        bfc1(end,:) = 0; bfc1(:,end) = 0;

        % get angle
        blb = regionprops('table', bfc1, 'Orientation');
        acc = 0.25; %on a 0.25 angle accuracy
        rotangle = -round(mean(blb.Orientation)/acc)*acc;
        % if larger than max rotation angle, set to 0
        if abs(rotangle)>maxrotangle; rotangle=0; end
        % apply rotation!
        chambs = imrotate(chambs, rotangle);
    end
    
    bfc2 = bwmorph(chambs,'skel'); %skeletonize
    bfc2 = bwmorph(imdilate(bfc2,strel('line',4,90)),'bridge');%close gaps
    bfc2 = bwareaopen(bfc2, 100, 4); %open again

    %remove horizontal lines "manually"
    s=sum(bfc2,2); 
    for ilin=1:size(chambs,2)
        if s(ilin)<20
           chambs(ilin,:) = 0; 
        end
        if s(ilin)>0.95*length(s)
           chambs(ilin,:) = 0; 
        end
    end

    %                     Step 1: find block area of the 2 rows of chambers:
    chambs1=imdilate(chambs,strel('line',12,00)); %dilate with a straight horizontal line
    chambs1=imfill(chambs1,'holes'); %fill holes 
    chambs1 = bwareaopen(chambs1, 1500); %remove "small" objects

    % fill or remove horizontal lines
    s=sum(chambs1,2);
    for ilin=1:size(chambs1,2)
        if s(ilin)>length(s)*0.95
           chambs1(ilin,:) = 1; 
        end
        if s(ilin)<length(s)*0.3
            chambs1(ilin,:) = 0; 
        end
    end

    %     determine if it's an image with 2 or 1 row of
    %     chambers by comparing size of 2 biggest objects.
    %     When similar, we have 2 rows.
    %       If we have only 1 row, determine if it's a bottom
    %       or top row by comparing centroid Y coordinates. If
    %       the Y of the bigger section (chambers) is higher,
    %       we're in bottom row and vice versa
    
%     sometimes, cells that stuck to top of chambers inside the flow
%     channel can mess with binarization. usually, these are elongated or are low extent.
%     filter them out
    props = regionprops(chambs1, 'PixelIdxList', 'Extent', 'Area', 'MajorAxisLength', 'MinorAxisLength');
    [val, indx] = maxk(vertcat(props.Area), 2);
    if props(indx(2)).MinorAxisLength / props(indx(2)).MajorAxisLength < 0.1
        chambs1(props(indx(2)).PixelIdxList)=0;
    end
    for ind=1:size(props,1)
        ext=abs(props(ind).Extent);
        if ext<0.8 %keep only 5+px long skeleton objects
            chambs1(props(ind).PixelIdxList)=0;
        end
    end
    
    if potonerow
        props = regionprops('Table', chambs1, 'PixelIdxList', 'Centroid', 'BoundingBox');
        [~, maxi] = max(props.BoundingBox(:,3)-props.BoundingBox(:,1));
        if percbbot > percbup
            remblb = find(props.Centroid(:, 2) < props.Centroid(maxi, 2));
        else
            remblb = find(props.Centroid(:, 2) > props.Centroid(maxi, 2));
        end
        
        if ~isempty(remblb)
            for ind = remblb
                pxl = props.PixelIdxList(ind);
                chambs1(pxl{:})=0;
            end
        end
    end

    chambs1bck = chambs1; %backup the "full" binarization for later cleanup
    chambs1=bwareafilt(chambs1,2); %select the 2 biggest objects

    % get area again
    props = regionprops('table',chambs1,'Area', 'PixelIdxList', 'Centroid');
    if size(props,1) == 1 || min(props.Area)/max(props.Area) < 0.5  %if the ratio between the 2 largest obj is small
       onerow(posi) = 1; %we have only 1 row of chambers
       [~, bigi] = max(props.Area); %idx of big object
       [~, smalli] = min(props.Area); %and small object
       if size(props,1) > 1 %if there are more than 1 object, compare size
           if props.Centroid(bigi,2) > props.Centroid(smalli,2) %center of chambers is bigger than number object
               onerowtop(posi) = 1;
           else
               onerowtop(posi) = 0;
           end
       else
           if props.Centroid(1,2) < size(chambs1,2)/2 %center of chambers is smaller than half image
               onerowtop(posi) = 1;
           else
               onerowtop(posi) = 0;
           end
       end
    else
       onerow(posi) = 0;
    end

    if onerow(posi)
        chambs1=bwareafilt(chambs1,1); %select the 1 biggest object if we have only 1 row
    else
        %remove horizontal lines "manually" again for 2 chamber blocks
        s=sum(chambs1,2); 
        for ilin=1:size(chambs,2)
            if s(ilin)<size(chambs,2)*0.8
               chambs1(ilin,:) = 0; 
            end
        end
    end
    chambs1=imdilate(chambs1, strel('disk',2,4)); %dilate a bit more with a disk
    chambs(~chambs1)=0;   %remove all objects from main chamber detection binary that are not in the block        
end

% this function registeres any frame >1 to the frame 1
function [regfail, tform, reg_box_mov, blurval] =...
    registerimages(bf, bfO, downsampleF, downsampleF_chamberdetect, ...
    onerow, onerowtop, size_fixed, reg_box_ref, posi, fix3, OOFcutoff, rotangle, ...
    optimizer, metric, ti, Tregistration)
    
% check if OOF (relative to frame 1, assumes frame 1 is in focus
    blurval = blur(imresize(bfO,0.1), imresize(bf,0.1));
    if blurval>OOFcutoff % if OOF, skip basically everything else
        OOF = 1;
        regfail = 1;
        disp(['Frame out of focus. Blur-value: ', num2str(blurval)])
        tform = [];
        reg_box_mov = [];
    else                    
        bfc=imresize(bf,downsampleF_chamberdetect); %downsample
        bfc = smallimgprocessing(bfc); %get filtered grayscale image
        
        bthresh = graythresh(bfc)-0.05; %get binarization threshold
    
        bfc1=imbinarize(bfc, bthresh);  %binarize
        percb = sum(bfc1(:))/(size(bfc,1)*size(bfc,2)); %check binarization
        upb = bfc1(1:floor(size(bfc1,1)/2),:);
        botb = bfc1(ceil(size(bfc1,1)/2):size(bfc1,1),:);
    
        %binarize image
        if onerow(posi)
            percb = percb*2;
        end
        lothrbin = 0.21;
        hithrbin = 0.3;
    
        if percb<lothrbin
            if percb<0.14
                bfc1 = imbinarize(bfc, bthresh-0.14);  %binarize
            else
                bfc1 = imbinarize(bfc, bthresh-0.1);  %binarize
            end
        elseif percb>hithrbin
            bfc1 = imbinarize(bfc, bthresh+0.09);  %binarize
        end
        bfc = bfc1; %reassign
    
    %   skeletonize and remove horizontal lines
        bfc2 = bwmorph(bfc,'skel');
        bfc2 = bwmorph(imdilate(bfc2,strel('line',4,90)),'bridge');%close gaps
        bfc2 = bwareaopen(bfc2, 100, 4);
    
        %remove horizontal lines
        s=sum(bfc2,2);
        for ilin=1:size(bfc,2)
            if s(ilin)<0.15*length(s)
                bfc(ilin,:) = 0; 
            end
            if s(ilin)>0.95*length(s)
                bfc(ilin,:) = 0; 
            end
        end
    
        bfc1=imdilate(bfc,strel('line',12,00)); %dilate with a straight horizontal line
        bfc1=imfill(bfc1,'holes'); %fill holes 
        bfc1 = bwareaopen(bfc1, 1500); %remove "small" objects
        %remove horizontal lines again
        s=sum(bfc1,2); 
        for ilin=1:size(bfc1,2)
            if s(ilin)>size(bfc1,2)*0.95
                bfc1(ilin,:) = 1; 
            end
            if s(ilin)<length(s)*0.3
                bfc1(ilin,:) = 0; 
            end
        end
        bfc11bck = bfc1; %backup the "full" binarization for later cleanup
        bfc1=bwareafilt(bfc1,2); %select the 2 biggest objects
    
        if onerow(posi)
            bfc1=bwareafilt(bfc1,1); %select the 1 biggest object if we have only 1 row
        else
        %remove horizontal lines "manually" again for 2 chamber blocks
            s=sum(bfc1,2); 
            for ilin=1:size(bfc1,2)
                if s(ilin)<size(bfc1,2)*0.8
                   bfc1(ilin,:) = 0; 
                end
            end
        end
        bfc1=imdilate(bfc1, strel('disk',2,4)); %dilate a bit more with a disk
        bfc(~bfc1)=0;   %remove all objects from main chamber detection binary that are not in the block             
    
        %define cropping box for registration:                    
        bfc1=imresize(bfc1,size_fixed); %resize to main image size
        sft=floor(size(bfc1,1)*0.01); %padding by this many pixels
        if onerow(posi) %onerow case
            try
                props=regionprops(bfc1,'Area', 'PixelIdxList'); %get pixel IDX of the 1 big object (chambers)
                bfc11bck=imresize(bfc11bck,size_fixed); %resize backup main binarization to registration image size
                
                reg_box_mov(1) = 1; %start at x=1
                reg_box_mov(3) = size(bfc1,1); %go until end of image
    
    
                if size(props,1) > 1
                    bfc11bck(props(1).PixelIdxList)=0; %remove the 1 big object (chambers) from backup
                    props=regionprops('table', bfc11bck, 'BoundingBox'); %get bounding box of the remaining objects
                    
    
                    prefilt = props.BoundingBox(:,2) < reg_box_ref(posi,2)*1.2 & props.BoundingBox(:,2) > reg_box_ref(posi,2)*0.8;
    
                    reg_box_mov(2) = min(props.BoundingBox(prefilt,2)) - sft; %take smallest Y and pad
                    reg_box_mov(4) = max(props.BoundingBox(prefilt,4)) + 2*sft; %take largest one and pad
    
                else
                    props=regionprops('table', bfc1, 'BoundingBox'); %get bounding box of the chamber area         
                    if onerowtop(posi)
                        reg_box_mov(2) = ceil(sft); %from upper image end
                        reg_box_mov(4) = floor(props.BoundingBox(1,2) +2*sft -reg_box_mov(2)); %up to beginning of chambers
                    else
                        reg_box_mov(2) = ceil(props.BoundingBox(1,2) + props.BoundingBox(4) + sft); %end of chamber area
                        reg_box_mov(4) = size(bfc1,2) - 2*sft - reg_box_mov(2); %end of image
                    end
                end
    
                
            catch % if any error, use the enlarged crop box of the frame 1
                reg_box_mov = reg_box_ref(posi,:);
                reg_box_mov(2) = reg_box_mov(2)-15;
                reg_box_mov(4) = reg_box_mov(4)+30;
            end
        else %two row case
            try
            reg_prop = regionprops('table', bfc1, 'BoundingBox'); %get bounding boxes of two regions containing chambers
            reg_box_mov(1)=1; %start at x=1
            [~,topi]=min(reg_prop.BoundingBox(:,2)); %which one is the top region?
            if topi==1; boti=2; else boti=1; end %assign id for bottom region
            reg_box_mov(2) = reg_prop.BoundingBox(topi,2)+...
                reg_prop.BoundingBox(topi,4) - sft; % y start based on previous area detection - padding
            reg_box_mov(3) = size(bfc1,1); %go until end of image
            reg_box_mov(4)=reg_prop.BoundingBox(boti,2) - ...
                reg_box_mov(2) + sft*2; % y end based on previous area detection + padding
            catch % if any error, use the enlarged crop box of the frame 1
                reg_box_mov = reg_box_ref(posi,:);
                reg_box_mov(2) = reg_box_mov(2)-15;
                reg_box_mov(4) = reg_box_mov(4)+30;
            end
        end
        reg_box_mov(:)=round(reg_box_mov(:)); %round bounding box it
        if abs(rotangle)>0.01 % if there was some rotation applied, crop away some X-border as well to not include black area
            reg_box_mov(1) = round(0.01*reg_box_mov(3));
            reg_box_mov(3) = reg_box_mov(3) - reg_box_mov(1);
        end
        if reg_box_mov(1)<1; reg_box_mov(1) = 1; end
        if reg_box_mov(2)<1; reg_box_mov(2) = 1; end
    
        %this is the final image crop for registration
        mov3=(imcrop(imresize(bf,downsampleF),reg_box_mov)); 
    
        %                     if this one is completely away from the initial
        %                     frame1 cropping area, make some adjustments
        if (size(mov3,1)<reg_box_ref(posi,4)*0.5) || ...
            abs(reg_box_ref(posi,2)-reg_box_mov(2)) > 40
            reg_box_mov = reg_box_ref(posi,:);
            reg_box_mov(2) = min(reg_box_mov(2)-10, 1);
            reg_box_mov(4) = reg_box_mov(4)+20;
            if reg_box_mov(1)<1; reg_box_mov(1) = 1; end
            if reg_box_mov(2)<1; reg_box_mov(2) = 1; end
            mov3=(imcrop(imresize(bf,downsampleF),reg_box_mov));
        end
        try
            blurval = blur(fix3{posi}, mov3);
        catch
            blurval = nan;
        end
        
        % if this is frame >2, use the previous frame registration as starting
        % point for the estimation
        if ti > 2 && ~isnan(Tregistration.x_reg(end))
            tform = transltform2d;
            tform.T(3,1) = Tregistration.x_reg(end);
            tform.T(3,2) = Tregistration.y_reg(end);
            tform.T(3,1) = tform.T(3,1)*downsampleF;
            tform.T(3,2) = tform.T(3,2)*downsampleF;
            tform = imregtform(mov3,...
                        fix3{posi},'translation',optimizer,metric,...
                        'InitialTransformation', tform);
        else
            tform = imregtform(mov3,...
                fix3{posi},'translation',optimizer,metric);
        end
        
        %run registration
        %warp to fit first image
        mov3mv=imwarp(mov3, tform, 'OutputView', imref2d(size(fix3{posi})));
    
        % diagnostic plot
            % figure;imshow(fix3{posi});figure;imshow(mov3mv)
    
        chks=1; %init
        scf=1.1; %scale starting condition by that much
        regfail=0; %init. If switched to 1, registration failed and frame is discarded
    end

    %do the iteration if crosscorrelation between the first
    %image and the registration image is below 0.5
    %(chosen based on my humble experience...)
    if blurval>OOFcutoff
        OOF = 1;
        regfail = 1;
        disp(['Frame out of focus. Blur-value: ', num2str(blurval)])
    else
        OOF = 0;

                %calc cross-correlation between the two images for areas that are
                %actually image in the aligned frame
        rowsum = sum(mov3mv,2);
        correg = abs(corr2(fix3{posi}(rowsum>0,:),mov3mv(rowsum>0,:)));

            %now, iterate over different starting conditions (regarding x and y) for
    %registration until a good one is found. That was the
    %only way I could think of to manage a consistently good
    %registration if the cross-correlation is really bad initially
        
    if correg < 0.5 %cross-correlation
            reg_box_movalt = reg_box_ref(posi,:);
            reg_box_movalt(2) = reg_box_movalt(2)-15;
            reg_box_movalt(4) = reg_box_movalt(4)+30;
            mov3alt=(imcrop(imresize(bf,downsampleF),reg_box_movalt));
            disp(['Initial registration failed. cross-corr: ', num2str(correg)]);
            try
                tform = imregtform(mov3alt,...
                    fix3{posi},'translation',optimizer,metric);
                %warp to fit first image
                mov3mv=imwarp(mov3alt, tform, 'OutputView', imref2d(size(fix3{posi})));
                if abs(corr2(fix3{posi},mov3mv))>0.3
                    regfail = 0;
                    regi=1; %turns to 1 if succeed
                    reg_box_mov = reg_box_movalt;
                    disp(['Iterative registration succeeded. cross-corr: ', num2str(abs(corr2(fix3{posi},mov3mv)))]);
                else
                    regi=0; %turns to 1 if succeed
                    regfail = 1;
                end
            catch
                regi=0; %turns to 1 if succeed
                regfail = 1;
            end
            
            while ~regi
                if chks==1 %chks indicate which option to try
                    tform.T(3,1) = -25*scf;
                    tform.T(3,2) = 0;
                elseif chks==2
                    tform.T(3,1) = 25*scf;
                    tform.T(3,2) = 0;
                elseif chks==3
                    tform.T(3,1) = -25*scf;
                    tform.T(3,2) = -10;
                elseif chks==4
                    tform.T(3,1) = 0;
                    tform.T(3,2) = -10;
                elseif chks==5
                    tform.T(3,1) = 25*scf;
                    tform.T(3,2) = -10;
                elseif chks==6
                    tform.T(3,1) = 25*scf;
                    tform.T(3,2) = 10;
                end

                %rerun the registration with different starting
                %conditions regarding movement in x and y
                tform = imregtform(mov3,...
                    fix3{posi},'translation',optimizer,metric,...
                    'InitialTransformation', tform);
                %rewarp
                mov3mv=imwarp(mov3, tform, 'OutputView', imref2d(size(fix3{posi})));

                % for more accurate crosscorrelation
                % calculation, I cut both images to be only the
                % region where there is actual signal (the one
                % that is registered/moved will have some black
                % introduced by the shift)
                if tform.T(3,1)<0
                    mov3mvc=imcrop(mov3mv,...
                        [1,1, size(mov3mv,2)+floor(tform.T(3,1)),size(mov3mv,1)] );
                    fix3c=imcrop(fix3{posi},...
                        [1,1, size(mov3mv,2)+floor(tform.T(3,1)),size(mov3mv,1)] );
                else
                    mov3mvc=imcrop(mov3mv,...
                        [floor(tform.T(3,1)),1, size(mov3mv,2)-floor(tform.T(3,1)),size(mov3mv,1)] );
                    fix3c=imcrop(fix3{posi},...
                        [floor(tform.T(3,1)),1, size(mov3mv,2)-floor(tform.T(3,1)),size(mov3mv,1)] );
                end

                % ugly way of coding iterations...
                if chks>6 %if at more than 6 iterations
                    if scf==2 %and scaling factor already increased to 2, abort and discard frame
                        regi=1;
                        regfail=1;
                    end
                    scf=2; %otherwise, set scaling factor to 2 and restart iteration
                    chks=0;
                end

                correg = abs(corr2(fix3c,mov3mvc));
                if correg>0.5 %that's when I consider the registration successful
                   regi=1;
                   regfail=0;
                   disp(['Iterative registration succeeded. cross-corr: ', num2str(correg)]);
                end
                chks=chks+1;
            end
        end
    end

    if ~OOF
        if regfail %if it failed, just use the frame1 box and make some adjustments
            disp(['Registration failed']);
        end
        %upscale the transformation based on the downsampling
        %factor
        corS1=reg_box_mov(1)-reg_box_ref(posi,1);
        corS2=reg_box_mov(2)-reg_box_ref(posi,2);
        tform.T(3,1)=tform.T(3,1)*(1/downsampleF)-corS1*(1/downsampleF);
        tform.T(3,2)=tform.T(3,2)*(1/downsampleF)-corS2*(1/downsampleF);
    end
    clear mov3 mov3mv mov3mvc
    clear bfc1 bfc2 chambs chambs1 chambgr gcr


    %                     store registration info in a table
    
end

% this function saves the final cropped images for each chamber
function saveimages(savestack, genname, bitdepth, n_channel,...
    maxin_val, bcr, gcr, rcr, ti, chname1, chname2, chname3)
    if savestack
        
        %                     write the chamber images. 
        if bitdepth==16 %store as uint16
          imwrite(uint16(bcr*maxin_val), [genname, chname1, '.tif'],...
              'WriteMode','append')

          if n_channel>1
               imwrite(uint16(gcr*maxin_val), [genname, chname2, '.tif'],...
              'WriteMode','append')
          end        

          if n_channel>2
              imwrite(uint16(rcr*maxin_val), [genname, chname3, '.tif'],...
                  'WriteMode','append')
          end
        else %store as uint8
            imwrite(uint8(bcr*maxin_val), [genname, chname1, '.tif'],...
              'WriteMode','append')

          if n_channel>1
              imwrite(uint8(gcr*maxin_val), [genname, chname2, '.tif'],...
                  'WriteMode','append')
          end

          if n_channel>2
              imwrite(uint8(rcr*maxin_val), [genname, chname3, '.tif'],...
                  'WriteMode','append')
          end
        end
        else %single page tifs
        

        if bitdepth==16 %store as uint16
          imwrite(uint16(bcr*maxin_val), [genname, chname1, 'Fr', num2str(ti,'%03.f'), '.tif']);

          if n_channel>1
              imwrite(uint16(gcr*maxin_val), [genname, chname2, 'Fr', num2str(ti,'%03.f'), '.tif']);
          end        

          if n_channel>2
              imwrite(uint16(rcr*maxin_val), [genname, chname3, 'Fr', num2str(ti,'%03.f'), '.tif']);
          end
        else %store as uint8
            imwrite(uint8(bcr*maxin_val), [genname, chname1, 'Fr', num2str(ti,'%03.f'), '.tif']);

          if n_channel>1
              imwrite(uint8(gcr*maxin_val), [genname, chname2, 'Fr', num2str(ti,'%03.f'), '.tif']);
          end        

          if n_channel>2
              imwrite(uint8(rcr*maxin_val), [genname, chname3, 'Fr', num2str(ti,'%03.f'), '.tif']);
          end
        end
    end
end

% this function creates the frame for the movie export by generating a
% colored overlay of the FL channels ontop of the PH or BF image.
% Also burns in chamber boundaries, adds a timestamp and a size bar
function ov = movieframecreation(bf, gfp, rfp, n_channel,...
    regfail, chambox, col1, col2, col3, burn_chamb, meta, deltaT, posind, ti)
%calculate the overlay (for movie only). Super crude... But works.
%                 I assume now that the order is PH, GFP, RFP
%if it is a registration fail image, make a black frame
%                  if regfail
%                      ov=cat(3, zeros(size(bf)),zeros(size(bf)),zeros(size(bf)));
%                      ov = uint8(ov * 256);
%                  else
     if n_channel>1
         rchan = bf;
         rchan = rchan + gfp*col1(1);
         rchan = rchan + rfp*col2(1);

         gchan = bf;
         gchan = gchan + gfp*col1(2);
         gchan = gchan + rfp*col2(2);

         bchan = bf;
         bchan = bchan + gfp*col1(3)*1.5;
         bchan = bchan - rfp*col2(2)*0.5;

         rchan(rchan>1) = 0.999;
         gchan(gchan>1) = 0.999;
         bchan(bchan>1) = 0.999;

         ov = cat(3, rchan, gchan, bchan);  % combine gfp, rfp and bf
         ov = uint8(ov * 256); %scale back to uint
     else 
         ov = cat(3, bf, bf, bf);  % combine gfp, rfp and bf
         ov = uint8(ov * 256); %scale back to uint
     end
%                  end

    if regfail
        bcol = 'red';
        tcol = 'red';
    else
        bcol = 'cyan';
        tcol = 'White';
    end

     if burn_chamb %burn the chamber boundaries into movie
      ov=insertShape(ov,'Rectangle', chambox,...
          'Color', bcol, 'LineWidth', 5);
     end
     barl = 10/meta.PxinUmX(posind);
     linepos = [size(ov, 1)*0.9 - barl, size(ov, 2)*0.97, size(ov, 1)*0.9, size(ov, 2)*0.97];
     ov = insertShape(ov,'Line', linepos, 'Color', 'white', 'LineWidth', 5);
     txtpos = [(linepos(3)+linepos(1))/2, linepos(2)*0.95];
     
     ov = (insertText(ov, txtpos, ['10 ',sprintf('%s',char(956), 'm')],...
         'FontSize', 50, 'TextColor', 'white',...
         'AnchorPoint', 'CenterTop', 'BoxOpacity', 0));
    %create time string to burn into image for movie
    time1 = (ti-1)*deltaT;
    tH = floor(time1/60);
    tM = time1-tH*60;
    if tH<10
        tH = ['0',num2str(tH)];
    else
        tH = num2str(tH);
    end
    if tM<10
        tM = ['0',num2str(tM)];
    else
        tM = num2str(tM);
    end
    tstring = [tH, ':',tM];
    ov = insertText(ov, [30, 50], tstring, 'FontSize', 80, 'BoxColor', tcol);
end

% small function to process downscaled image for various downstream
% analysis
function out1 = smallimgprocessing(im1)
    im1 = imreducehaze(im1); %reduce haze
    im1 = mat2gray(colfilt(im1,[4 3],'sliding',@max)); %blur2
    out1 = mat2gray(colfilt(im1,[5 2],'sliding',@median)); %blur3
end

% modified from here:
% https://ch.mathworks.com/matlabcentral/fileexchange/68350-image-blur-measurement
% it's a small function to estimate blur percentage between two images
% relative to first image
function blurperc=blur(original,blur)
    I=(original);
    C1=I;
    % C1=rgb2gray(I);   
    I2=blur;
    % C2=rgb2gray(I2);
    C2=I2;
    [m1 n1]=size(C1);  
    [m2 n2]=size(C2);                               
    for i=2:m1-1                                 
        for j=2:n1-1
    A1=[abs(C1(i,j)-C1(i-1,j-1)),abs(C1(i,j)-C1(i-1,j)),abs(C1(i,j)-C1(i-1,j+1)),abs(C1(i,j)-C1(i,j-1)),abs(C1(i,j)-C1(i,j+1)),abs(C1(i,j)-C1(i+1,j-1)),abs(C1(i,j)-C1(i+1,j)),abs(C1(i,j)-C1(i+1,j+1))];
    maximum1=max(A1);  
    M1(i-1,j-1)=maximum1;   
    end
    end
    
    for i=2:m2-1                                 
        for j=2:n2-1
    A2=[abs(C2(i,j)-C2(i-1,j-1)),abs(C2(i,j)-C2(i-1,j)),abs(C2(i,j)-C2(i-1,j+1)),abs(C2(i,j)-C2(i,j-1)),abs(C2(i,j)-C2(i,j+1)),abs(C2(i,j)-C2(i+1,j-1)),abs(C2(i,j)-C2(i+1,j)),abs(C2(i,j)-C2(i+1,j+1))];
    maximum2=max(A2);
    M2(i-1,j-1)=maximum2; 
    end
    end
    
    blur1_mean=mean(mean(M1));
    blur2_mean=mean(mean(M2));
    
    blurperc=abs(blur1_mean-blur2_mean)/blur1_mean;
end
