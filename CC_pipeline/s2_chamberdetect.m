% This script takes .ets files from Olympus as input
% My images have a single chamber on it. The script will not work if there
% are multiple chambers on it. It is ok if still some of an adjacent
% chamber is visible but not a full one
% The script will create:
% 1) registered .avi movie of each .ets file with timestamp and
% possibility to burn in the chamber box used for image cropping
% 2) .csv file per position/frame about registration: xy translation. nan if
% failed
% 3) Per position/chamber: new folder containing single tif files of all
% channels for each frame. Black image stored if registration failed for
% all channels.

reload = 1; %leave at 1 unless troubleshooting
if reload
    close all
    clear
    reload=1;
end

%%%%% two parameters need to be set by user! %%%%
% directory of config file storage
mainconfigname = 'jbanalysisconfig_cc.json';
configdir = 'D:\GitHub\azimages\julian\CC_pipeline\';


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

% Logical array where true indicates a valid entry
validEntries = ~isnan(meta.rotangle) & meta.rotangle >= -360 & meta.rotangle <= 360;

% Check if all entries in 'rotangle' are valid
allValid = all(validEntries);

if ~allValid
    msgbox('Please run 1_rotation.mat first to define rotation angle for all replicates.', 'missing info', 'error')
    return
end

% sort meta file and get all replicate names
meta = sortrows(meta, {'replicate', 'pos'}, 'ascend');
allrep = unique(meta.replicate);


% create savedir
if masterdir(end) ~= filesep; masterdir=[masterdir, filesep]; end
savedirRoot = [masterdir, savedirname];
if ~isfolder(savedirRoot)
    mkdir(savedirRoot)
end

% disable warnings
disableWarnings();


%define optimizer and metric for registration, change some parameters
[optimizer,metric] = imregconfig('multimodal'); 
optimizer.InitialRadius=6.e-04;
optimizer.MaximumIterations=300;
optimizer.GrowthFactor=1.05;
optimizer.Epsilon=1.5000e-06;

% set image scaling paramters
maxin_val=(2^bitdepth)-1; %max intensity values possible
thr1 = thr1*maxin_val; % min and max values for mat2gray for PH
thr2 = thr2*maxin_val; % min and max values for mat2gray for GFP
thr3 = thr3*maxin_val; % min and max values for mat2gray for RFP


focusfail=0; %init
for repi = 1:length(allrep)
    replicate = string(allrep(repi));

    % make savedir per replicate
    savedir = [savedirRoot, filesep, char(replicate), filesep];
    if ~isfolder(savedir)
        mkdir(savedir)
    end
    % get id of replicate and main directory
    replind = strcmp((meta.replicate), replicate);
    maindir = fullfile(masterdir, char(replicate));

    cd(maindir) %set directory to main folder
    alldir=dir('_*'); %list of all dirs inside the main containing images
    
    if sum(isnan(meta.Process(replind)))==0
        procL = meta.Process(replind);
    else
        procL = [];
    end

    % position list based on meta file
    posL = meta.pos(replind)';
    allC=1; %don't change...
    curpos = 0;
    for posi=posL %go over all folders
        % get index of current position
        metai = strcmp(meta.replicate,  char(replicate)) & meta.pos == posi;
        if strcmp(meta.Exclude(metai), 'excl'); continue; end
        if strcmp(meta.register(metai), 'Done'); continue; end
    
            % display to user which folder is processed currently
        curpos = curpos+1;
        disp(['Replicate: ', char(replicate), ' (', num2str(repi, '%02.f'),'/',num2str(length(allrep),'%02.f'),...
                ') | Position Nr. ', num2str(posi, '%02.f'),' (',num2str(curpos,'%02.f'), '/' num2str(length(posL),'%02.f'), ')']);
        
        if isempty(procL)
            % get process number (olympus position ID) from folder name
            dird=[maindir, alldir(posi).name, filesep, 'stack1']; %get dir of image
            procnr = str2double(extract(alldir(posi).name, digitsPattern));
        else
            procnr = procL(curpos);
            dird=[maindir, filesep, '_Process_', num2str(procnr), '_', filesep, 'stack1']; %get dir of image
        end

        % get maxframe
        maxfr = meta.MaxFr(metai);
    
        % get rotation angle
        rotangle = meta.rotangle(metai);
        % get deltaT
        dt = meta.dt(metai);
        
        %init VideoWriter
        cd(savedir)
        try %init video writer for movie inside savedir
            vidOV = VideoWriter(['Pos_',num2str(posi),'_OV.mp4'],'MPEG-4');
        catch
            close(vidOV);
            vidOV = VideoWriter(['Pos_',num2str(posi),'_OV.mp4'],'MPEG-4');
        end
        vidOV.FrameRate = vidfr; %set framerate
        open(vidOV); %open writer
    
        %load the image stack
        clear r
        r = bfGetReader([dird, filesep, 'frame_t_0.ets']);
        r = loci.formats.Memoizer(r);
        loci.common.DebugTools.setRootLevel('DEBUG');
    
        % get info about microscope stage and store it. my older scripts need
        % it in the registration table but writing it to the meta makes
        % actually more sense.
        omeMeta = r.getMetadataStore();
        meta.StageX(metai) = double(omeMeta.getPlanePositionX(0,0).value);
        meta.StageY(metai) = double(omeMeta.getPlanePositionY(0,0).value);
        meta.PxinUmX(metai) = double(omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER));
        meta.PxinUmY(metai) = double(omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER));
    
        %get the number of images in there
        if isempty(maxfr) | isnan(maxfr)
            n_im=r.getImageCount()/n_channel; %auto-calc
        else
            n_im=maxfr;
        end
    
        % Initialize empty registration table with specified variable names and types
        Tregistration = table(...
            cell(0, 1), ... % Empty cell array for 'replicate' (string)
            [], [], [], [], ... % Empty arrays for 'pos', 'frame', 'x_reg', 'y_reg' (numeric)
            cell(0, 1), ... % Empty cell array for 'FolderName' (string)
            'VariableNames', {'replicate', 'pos', 'frame', 'x_reg', 'y_reg', 'FolderName'
        });
        
        fix3prev=[]; %init
        regfail=0;%init
        regfailcount = 0; %init
        clf('reset')
        ti=1; %start at t=1
        for tind=1:n_im
            ti=tind;

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
           
        
            if ti==1 %if it is the first, use this as the alignement reference
                tform = affine2d(); %reset registration
                bfO=bf; %save the first image
                szfix=imref2d(size(bfO)); %get reference coordinates
                
                %get the fixed points image for alignment. downsample the
                %image to improve speed:
                fixed=imresize(bfO,downsampleF);%downsample
                size_fixed = size(fixed);
                clear fixed
                
%                         chamber position detection. Overcomplicated
%                         multi-step process incoming!
%                       Step 0: initial raw skeleton lines of chambers
                chambs=imresize(bfO,downsampleF); %resize
                fix3 = chambs;
                chambs = chambs-imbothat(chambs,strel('disk',10,4));
                chambs = imreducehaze(chambs); %reduce haze
                chambs = mat2gray(colfilt(chambs,[4 4],'sliding',@median)); %blur3 [4 4] original
                chambs = mat2gray(colfilt(chambs,[5 5],'sliding',@max)); %blur2

                chambgr=chambs; %backup grayscale
                
                fix3 = imreducehaze(fix3); %reduce haze
                fix3 = mat2gray(colfilt(fix3,[5 5],'sliding',@max)); %blur2
                fix3 = mat2gray(colfilt(fix3,[4 4],'sliding',@median)); %blur3
                fix3 = imclose(fix3, strel('disk',10));
                
                % crop some of the border away
                crpam = ceil(0.06*size(fix3,1));
                fix3 = fix3(crpam:size(fix3,1)-crpam,crpam:size(fix3,1)-crpam);
                fix3or = fix3;
           
%                   Step 3: Find position of chambers
                colsum = sum(chambs,1); % figure;plot(colsum)
                rowsum = sum(chambs,2); % figure;plot(rowsum)
                
                % if rotation is applied (that is more than just a
                % flip), make image again a bit smaller to cut away
                % black regions
                if mod(rotangle, 90)>0
                    reducerange = floor(size(chambs,1)*0.05);
                    colsum(1:reducerange) = 0;
                    colsum(end-reducerange:end) = 0;
                    rowsum(1:reducerange) = 0;
                    rowsum(end-reducerange:end) = 0;
                end
                
                % find peaks in intensity along both axes. They mark
                % the border of the chamber, usually. Use a minimal
                % peak distance to ensure that the peaks are spread as
                % far as expected (hardcoded. bad.)
                [pks, chamx] = findpeaks(colsum, 'SortStr', 'descend', 'MinPeakProminence', 1, 'MinPeakDistance', 80);
                [~, idx] = sort(abs(chamx - length(colsum)/2));
                chamx = sort(chamx(idx(1:2)));
                [pks, chamy] = findpeaks(rowsum, 'SortStr', 'descend', 'MinPeakProminence', 1, 'MinPeakDistance', 200);
                
                % if only one peak has been found on y axis, we likely
                % have a single control chamber. If we reduce the
                % minimal peak distance, we probably find it
                if length(chamy) == 1
                   potsingle = 1;
                   [pks, chamy] = findpeaks(rowsum, 'SortStr', 'descend', 'MinPeakProminence', 1, 'MinPeakDistance', 100);
                   chamsz = 110;
                else
                    potsingle = 0;
                    chamsz = 220;
                end

                % if more than 2 peaks, take the largest 2
                [~, idx] = sort(abs(chamy - length(rowsum)/2));
                if length(chamy)>2
                    if diff(abs(chamy(idx(2:3)) - length(rowsum)/2)) < 20
                        [~, idx] = sort(pks, 'descend');
                    end
                end
                chamy = sort(chamy(idx(1:2)));
                
                % check how far the distance betweens peaks is off 
                % from the expected distance
                chamy = sort(chamy);
                chamyd = chamy(2) -chamy(1);
                chamydoff = chamyd - chamsz;
                if potsingle
                    if mean(chamy)<size(chambs,2)/2
                        chamy(2) = chamy(2) - abs(chamydoff);
                    else
                        chamy(1) = chamy(1) + abs(chamydoff);
                    end
                else
                    if chamydoff > 0
                       chamy(1) = chamy(1) + chamydoff/2;
                       chamy(2) = chamy(2) - chamydoff/2;
                    elseif chamydoff < 0
                       chamy(1) = chamy(1) - abs(chamydoff)/2;
                       chamy(2) = chamy(2) + abs(chamydoff)/2;                     
                    end
                end
              
                % final chamber crop box
                chambox = [chamx(1), chamy(1), chamx(2)-chamx(1) chamy(2)-chamy(1)];
                
                % shrink it a to exclude area close to the opening
                % to the flow channel. Use this then to detect the
                % barrier position.
                chamboxnar = chambox;
                narrowing = 22;
                chamboxnar(2) = chamboxnar(2) +narrowing;
                chamboxnar(4) = chamboxnar(4) -narrowing;
                crpim = imcrop(chambs, chamboxnar);
                rowsum = -sum(crpim,2);
                [pks, chamy] = findpeaks(rowsum, 'SortStr', 'descend', 'MinPeakProminence', 1);
                if potsingle
                    potsingle = 1;
                    barrierpos = nan;
                else
                    % [~, idx] = sort(abs(chamy - length(rowsum)/2));
                    % chamy = sort(chamy(idx(1:2)));
                    barrierpos = chamy(1)+narrowing;
                end
                
                    %     this is a diagnostic plot I sometimes use
%                     figure;
%                     imshow(chambs);
% %                     imshow(B);
% %                     imshow(chambs);
%                     hold on;
%                     for k = 1 : size(chambox,1)
%                         thisBB = chambox(k,:); % Or allBB(k, :)
%                         rectangle('Position',  thisBB, 'EdgeColor', 'r', 'LineWidth', 1);
%                     end
%                     hold off;
%                     

                % upsample and round box and barrierposition
                chambox=round(chambox*1/downsampleF);
                barrierpos=round(barrierpos*1/downsampleF);
                
                % cleanup
                clear chambs xs sel xtop xbot props B chambs1 bfc1 bfc2  ytoprow ybotrow B B1

%                     each chamber is going to be cropped out and stored in a new directory
%                       inside the savedir. Make these new dirs
                for k = 1 : size(chambox,1)
                    chamberPath = fullfile(savedir, 'Chambers', ...
                      sprintf('Pos%02.f_Chamb%02.f', posi, k));
                    mkdir(chamberPath)
                    % Delete all tifs if there are any
                    delete(fullfile(chamberPath, '*tif'));
                end
                
                % write the registration info
                Tregistration.pos(end+1)=posi;
                Tregistration.frame(end)=ti;
                Tregistration.x_reg(end)=0;
                Tregistration.y_reg(end)=0;
                Tregistration.FolderName(end)={dird};
                Tregistration.replicate(end)={replicate};

                % and the meta file with info about chamber position and
                % nanochannel position inside the crop
                meta.BarrierYincrop(metai) = barrierpos; 
                meta.chamberbox1(metai) = chambox(1);
                meta.chamberbox2(metai) = chambox(2);
                meta.chamberbox3(metai) = chambox(3);
                meta.chamberbox4(metai) = chambox(4);

                % save meta updates
                currow = meta(metai,:);
                meta = preprocessMetaTable(metaname);
                meta(metai,:) = currow;
                try
                    writetable(meta,...
                    [masterdir, filesep, 'meta_processing.csv'],...
                    'Delimiter', ',');
                catch
                    writetable(meta,...
                    [masterdir, filesep, 'meta_processing-temp.csv'],...
                    'Delimiter', ',');
                end
                %%%%  END OF FIRST IMAGE ANALYSIS %%%%%


                    
            else %all other images are aligned to the 1st image 
                chambs=imresize(bf,downsampleF); %resize
                chambs = imreducehaze(chambs); %reduce haze
                chambs = mat2gray(colfilt(chambs,[5 5],'sliding',@max)); %blur2
                chambs = mat2gray(colfilt(chambs,[4 4],'sliding',@median)); %blur3
                
                mov3 = imclose(chambs, strel('disk',10));
                mov3 = mov3(crpam:size(mov3,1)-crpam,crpam:size(mov3,1)-crpam);

                % check OOF
                blurval = blur(imresize(bfO,0.1), imresize(bf,0.1));
                if blurval>OOFcutoff
                    OOF = 1;
                    regfail = 1;
                    disp(['Frame out of focus. Blur-value: ', num2str(blurval)])
                else
                    OOF = 0;
                end
               
                % iterative check for registration. usually 1st one
                % works already
                % Scale transformation according to downsampling factor
                tform.T(3,1:2) = tform.T(3,1:2) * downsampleF;
                for trial=1:3
                    if OOF; continue; end
                    % Perform image registration
                    tform = imregtform(mov3,...
                        fix3,'translation',optimizer,metric,...
                        'InitialTransformation', tform);
                    %warp to fit first image
                    mov3mv=imwarp(mov3, tform, 'OutputView', imref2d(size(fix3)));

                    %now, iterate over different starting conditions (regarding x and y) for
                    %registration until a good one is found. That was the
                    %only way I could think of to manage a consistently good
                    %registration

                    %do the iteration if crosscorrelation between the first
                    %image and the registration image is below 0.5
                    %(chosen based on my humble experience...)
                    xOffset = ceil(tform.T(3,1));
                    yOffset = ceil(tform.T(3,2));
                    xRange = max(1, 1+xOffset) : size(fix3,2)+min(0, xOffset-1);
                    yRange = max(1, 1+yOffset) : size(fix3,1)+min(0, yOffset-1);
                    % Extract regions for correlation check
                    fix3check = fix3(yRange, xRange);
                    mov3check = mov3mv(yRange, xRange);
                    % Calculate check regions based on transformation
                    correlation = abs(corr2(fix3check, mov3check));
                    if correlation < 0.5 || isnan(correlation)

                        % Reset registration if previous values are not NaN
                        if ~isnan(Tregistration.x_reg(end-regfailcount))
                            tform.T(3,1) = Tregistration.x_reg(end-regfailcount) * downsampleF;
                        end
                        if ~isnan(Tregistration.y_reg(end-regfailcount))
                            tform.T(3,2) = Tregistration.y_reg(end-regfailcount) * downsampleF;
                        end
                        % Adjust fixed image or set failure flag based on trial number
                        switch trial
                            case 1
                                fix3 = fix3prev2;
                            case 2
                                fix3 = fix3or;
                            case 3
                                regfail = 1;
                        end
                    else
                        % Successful registration, exit loop
                        regfail = 0;
                        break
                    end
                end

                Tregistration.pos(end+1) = posi;
                Tregistration.frame(end) = ti;
                Tregistration.replicate(end) = {replicate};
                Tregistration.FolderName(end)={dird};
                if ~regfail
                    fix3prev2 = fix3prev;
                    fix3prev = fix3;
                    fix3 = mov3mv;
                    % Scale transformation according to downsampling factor
                    tform.T(3,1:2) = tform.T(3,1:2) * (1/downsampleF);
                    % apply registration to BF, GFP and RFP
                    bf=imwarp(bf,tform,'OutputView',szfix);
                    if n_channel>1
                        gfp=imwarp(gfp,tform,'OutputView',szfix);
                    end
                    if n_channel>2
                        rfp=imwarp(rfp,tform,'OutputView',szfix);
                    end
                    Tregistration.x_reg(end)=tform.T(3,1);
                    Tregistration.y_reg(end)=tform.T(3,2);
                else
                    fix3 = fix3prev;
                    if isnan(Tregistration.x_reg(end-1))
                        regfailcount = regfailcount + 1;
                    else
                        regfailcount = 1;
                    end
                    Tregistration.x_reg(end)=nan;
                    Tregistration.y_reg(end)=nan;
                    tform.T(3,1)=Tregistration.x_reg(end-regfailcount); %reset registration
                    tform.T(3,2)=Tregistration.y_reg(end-regfailcount); %reset registration
                end
                clear mov3 mov3mv mov3mvc bfc1 bfc2 chambs chambs1 chambgr gcr                    
            end
                
                %%%% END OF IMAGE REGISTRATION %%%%%
                 
                
                %%%% now, lets write movies and cropped
                %%%% chamber images %%%%%
                for chi=1:size(chambox,1)
                    crbx=chambox(chi,:); %crop box for chamber
                    skip=0; %track if there is a reason to skip the chamber
                    
                    %1) skip if the chamber is actually out of the current image. It
                    %can be moved out due to image drift and following
                    %registration
                    if tform.T(3,1)<0
                        if crbx(1)+crbx(3)-tform.T(3,1)>size(bf,1)
                            skip=1;
                        end
                    else
                        if crbx(1)-tform.T(3,1)<1
                            skip=1;
                        end
                    end
                    
%                     2) if registration or focus (not coded yet...)
%                     failed, skip
                    if regfail || focusfail
                       skip=1; 
                    end
                    
%                     crop the images
                    bcr=imcrop(bf, crbx);
                    if n_channel>1
                        gcr=imcrop(gfp, crbx);
                    else
                        gcr=zeros(size(bcr));
                    end
                    if n_channel>2
                        rcr=imcrop(rfp, crbx);
                    else
                        rcr=zeros(size(bcr));
                    end
                    
%                     if a skip is indicated, a black image will be
%                     exported
                    if skip
                        bcr=zeros(size(bcr));
                        gcr=zeros(size(gcr));
                        if n_channel>2
                            rcr=zeros(size(rcr));
                        end
                    end
                    
                    
%                     wirte the chamber images. 
                    channels = {bcr, gcr, rcr}; % Assuming bcr, gcr, rcr are your channel data variables
                    channelNames = {chname1, chname2, chname3};
                    for idx = 1:n_channel
                        writeImage(channels{idx}, bitdepth, maxin_val, savedir, posi, chi, ti, channelNames{idx});
                    end
                    channels = [];
                end
                
                
                
                %calculate the overlay (for movie only). Super crude... But works.
%                 I assume now that the order is PH, GFP, RFP
                % and col1, col2 are your RGB multipliers for gfp and rfp channels respectively
                    
                % Pre-allocate a 3D matrix for RGB channels
                combinedImage = zeros(size(bf, 1), size(bf, 2), 3);
                
                % Combine channels with color weights
                combinedImage(:,:,1) = bf + gfp * col1(1) + rfp * col2(1); % Red channel
                combinedImage(:,:,2) = bf + gfp * col1(2) + rfp * col2(2); % Green channel
                combinedImage(:,:,3) = bf + gfp * col1(3) + rfp * col2(3); % Blue channel
                
                % Clip values to maximum 0.9999 to avoid saturation
                combinedImage(combinedImage > 1) = 0.9999;
                
                % Normalize combined image based on its maximum value
                maxValue = max(combinedImage(:));
                combinedImage = combinedImage / maxValue;
                
                % Convert to uint8 format for display or saving
                combinedRGBImage = uint8(combinedImage * 255);


                if regfail
                    bcol = 'red';
                    tcol = 'red';
                else
                    bcol = 'cyan';
                    tcol = 'White';
                end

                 if burn_chamb %burn the chamber boundaries into movie
                  ov=insertShape(combinedRGBImage,'Rectangle', chambox,...
                      'Color', bcol, 'LineWidth', 10);
                 end
                 
                 barl = 10/meta.PxinUmX(metai);
                 linepos = [size(ov, 1)*0.9 - barl, size(ov, 2)*0.97, size(ov, 1)*0.9, size(ov, 2)*0.97];
                 ov = insertShape(ov,'Line', linepos, 'Color', 'white', 'LineWidth', 10);
                 txtpos = [(linepos(3)+linepos(1))/2, linepos(2)*0.95];

                 ov = (insertText(ov, txtpos, ['10 ',sprintf('%s',char(956), 'm')],...
                     'FontSize', 50, 'TextColor', 'white',...
                     'AnchorPoint', 'CenterTop', 'BoxOpacity', 0));
            
                %create time string to burn into image for movie
                time1=(ti-1)*dt;
                tH=floor(time1/60);
                tM=time1-tH*60;
                if tH<10
                    tH=['0',num2str(tH)];
                else
                    tH=num2str(tH);
                end
                if tM<10
                    tM=['0',num2str(tM)];
                else
                    tM=num2str(tM);
                end
                tstring=[tH, ':',tM];
                ov = insertText(ov, [00, 00], tstring, 'FontSize', 80, 'BoxColor', tcol);

                linepos = [meta.chamberbox1(metai), ...
                    meta.chamberbox2(metai) + meta.BarrierYincrop(metai), ...
                    meta.chamberbox1(metai) + meta.chamberbox3(metai), ...
                    meta.chamberbox2(metai) + meta.BarrierYincrop(metai)];
                ov = insertShape(ov,'Line', linepos, 'Color', bcol, 'LineWidth', 10);

                ov = imresize(ov, vidsz);
                % show it
                if liveimages>0
                    m = imshow(imresize(ov, liveimages));
                    drawnow %made that the display on fig is updated                
                end
    
                %write the movie
                writeVideo(vidOV, ov);
                clear ov gfp bf rfp
                 
                 if ti==n_im
                     close(vidOV)
                 end
        end %end of time loop
    
        
        %save the Tregistration table
    writetable(Tregistration,...
        [savedir, 'Pos', num2str(posi,'%02.f'),'_registrationInfo.csv'],...
        'Delimiter', ',')
    
    
    meta.register(metai) = {'Done'};
    currow = meta(metai,:);
    meta = preprocessMetaTable(metaname);
    meta(metai,:) = currow;
    try
        writetable(meta,...
        [masterdir, filesep, 'meta_processing.csv'],...
        'Delimiter', ',');
    catch
        writetable(meta,...
        [masterdir, filesep, 'meta_processing-temp.csv'],...
        'Delimiter', ',');
    end
end %end of all things!

end
return

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

% Function to construct the file path and write the image
function writeImage(channelData, bitDepth, maxInVal, saveDir, posi, chi, ti, channelName)
    if bitDepth == 16
        imgType = 'uint16';
    else
        imgType = 'uint8';
    end
    imgData = feval(imgType, channelData * maxInVal); % Convert image data based on bit depth
    fileName = fullfile(saveDir, 'Chambers', sprintf('Pos%02.f_Chamb%02.f', posi, chi), ...
        sprintf('Pos%02.f_Chamb%02.f_fr%03.f_%s.tif', posi, chi, ti, channelName));
    imwrite(imgData, fileName);
end

function meta = preprocessMetaTable(metaname)
    % Read and preprocess the metadata table
    opts = detectImportOptions(metaname);
    % Define columns and their desired types
    charColumns = {'Exclude', 'Notes', 'register', 'stardist', 'stardist_fails'};
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