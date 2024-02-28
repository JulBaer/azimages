# azimages by Julian Bär
Repository of AZinkernagel lab for time-lapse microscopy image analysis code associated with the article available on [bioarxiv](https://www.biorxiv.org/content/10.1101/2024.02.27.582246v1): Single-cell approach dissecting *agr* quorum sensing dynamics in *Staphylococcus aureus* by Julian Bär, Samuel G. V. Charlton, Andrea Tarnutzer, Giovanni Stefano Ugolini, Eleonora Secchi and Annelies S. Zinkernagel.

# General info
For both mother-machine (mm) and connected-chamber pipelines, the general workflow is similar. Both require a metadata csv file which describes the included images and tracks pipeline progress. Initial steps (config and preprocessing) are performed in MATLAB and segmentation and tracking in Python. Both  pipelines start by creating a config file to store variables used by subsequent scripts followed by a preprocessing script to idenfity regions of interest (filled microfluidic chamber), register image to compensate for stage drift, extract ROI and copy in a new folder and create an overview movie. Subsequently, StarDist2D segmentation is performed for all images and, for certain mother-machine experiments, cell tracking with DeLTA2.0 is performend. The python jupyter books run in dedicated conda environments. The yaml files to create the envs can be found in the folder `envs`. 
The two pipelines are described below.

# mother-machine (mm) image analysis pipeline

## Meta data structure:
Columns after `Process` will be filled by the script iteratively and should be left empty by the user. The previous ones need/can to be filled by the user. The user can add as many more columns as needed to describe their experimental design.
If there's any weird errors of the MATLAB script regarding wrong format of a column, add a dummy row 1 in which you fill out each cell. Matlab cannot assign strings to numeric table columns and if all is empty, it assigns automatically numeric which then makes it crash if it wants to assign a string...
Columns of meta file:
- `replicate`: same format as the folders mentioned above
- `pos`: for each replicate starting at 1 up to number of position
- `dt`: framerate (min between frames)
- `strain`: bacterial strain name
- `Notes`: whatever arbitrary and unstructured note you want to put down
- `Exclude`: If == "excl" the entire position will be skipped. If =="top", chambers in the top channel will be excluded. (we use chips that split into a top and bottom flow channel with chambers on both sides of each of those). This means, if the very top row was imaged, the entire position will be excluded and if a middle section was imaged, only the top row will be excluded (FOV has chambers both from top and bottom flow channel). Reverse is performed if =="bot".
- `MaxFr`: frames after MaxFr are ignored
- `type`: Type of experiment. User variable. For the original: sAIP = synthetic homologous AIP. mAIP: mixed homologous and heterologous AIP. short: quick framerate needed for successful DeLTA tracking
- `Process`: numeric Process name (Olympus CellSense position ID, only the digits without 'Process' and the underscores). To avoid any mistakes due to weird sorting and naming by CellSense, I suggest filling that manually. The script will then use this number to open an image and will not assume any kind of sorting. If it is left empty, the field is filled by script based on natural sorting
- Following variables describe the subset of experiments of the publication included in the example movies and for which the raw images are available on BioArchive
- `maindir`: original folder name of the processed images. Filled by script
- `nchamber`: number of chambers used for this position. Filled by script
- `MiddleRow`: Our MM chips split into two channels, therefore we can image either the top or bottow side of the channel (1 row of chambers visible) or the middle portion in which we can see double the number of chambers in one FOV. The script automatically detects which type of FOV we have and assigns =1 if this is a middle row. Filled by script
- `Top1Bot0FRow`: if MiddleRow == 0, this variable indicates if this is a top row (=1) or a bottom row (=0). Filled by script
- `rotation`: automatically detected rotation correction of the image (assumed same rotation for all positions of 1 biological replicate/folder and performs this rotation estimation only once per folder). Filled by script
- `StageX`: X position of stage. Filled by script
- `StageY`: Y position of stage. Filled by script
- `PxinUmX`: spatial calibration factor. Filled by script
- `PxinUmY`: spatial calibration factor (should always be the same as the one for X, I guess). Filled by script
- `register`: Turns to "Done" once the s1_preprocessing.m has been run. Filled by script
- `stardist`: Turns to "Done" once the StarDist script has been run. Filled by script
- `stardist_fails`: reports any error messages occuring during te run of the StarDist script. Filled by script
- `delta`: Turns to "Done" once the 3) DeLTA script has been run. Filled by script
- `delta_fails`: reports any error messages occuring during te run of the DeLTA script. Filled by script

 
## 0) Create json config file (s0_writeconfig.m)
This is a small MATLAB script to generate a json file containing all variables needed to adapt by the user for the following scripts.
The variables are described in the script and an example json file is included in the repo.

## 1) Register images, detect (filled) chambers and extract small images (s1_preprocessing.m)
MATLAB based preprocessing. It needs a couple functions from the image processing toolbox (https://www.mathworks.com/products/image.html) and needs the bioformats toolbox (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html#installation).

### General datastructure:
`masterdir` (config variable): contains subfolders (specified in config `typedirs`) which then contains subfolders for each biological replicate (format: 1 letter, 2 numbers, eg *s02*). These then contain the output of the Olympus microscope (_ProcessXXXXX_ folders (1 per position, containing the .ets image file) and a corresponding .vsi file).
The `masterdir` also needs to contain a meta file (add name in config as `metacsv`), see  `.../MM_pipeline/meta_processing.csv` for an example and details above.
If you follow this data structure, you can just hit run for the MATLAB script. It assumes 100x magnification images and runs with Olympus default image file format. If you use another imaging platform, there's likely some adjustment that needs to be done. I am happy to help you adjust whatever you need if you can provide me with an example file.
This script will iterate over all the folders and save processed images within `masterdir/savedirname` (config) in seperate folders for each replicate. In there, it will create 3 more folders:
- `movies`: overview movies with all channels overlaid. A timestamp and size bar as well as an optional rectangle for each exported chambers are added. Details for movie formating are defined in the config file.
- `reginfofolder`: a csv file for each position containing info about the image registration: x and y drift (relative to first frame) as well as blur percentage value (based on https://ijssst.info/Vol-19/No-1/paper7.pdf)
- `Chambers`: main output directory. For each Position, a new folder is created. These contain again a folders for each chamber. In there, seperate .tif files (default. Also tif stack possible, see config) for each frame and channel. Naming scheme: replicate\Position\Chamber\ChamberChannelFrame.tif. Ch1 is always assumed to be either phasecontrast or brightfield.
Example: "...\s02\Pos03\Chamb05\Chamb05Ch2Fr123.tif"

## 2) Run StarDist2D segmentation (s2_stardist.ipynb)
Uses the `.../envs/jbStarDist.yaml` conda environment.
Mother-machine specific model is stored in `.../stardist_models/mm` 
The script uses the config from `s0_writeconfig.mat`. Most importantly, the `stardistmodeldir` needs to be specified. The specified dir should contain a folder named `stardist` which contains the `weights_best.h5`, `thresholds.json` and `config.json`. Mine is a custom trained model.
Additionally, you can indicate if there are fluorescent channels you want to be quantified with regionprops (`flims`) and limit the GPU RAM usage of StarDist (`ramsize` to define available RAM in GB and `ramlimit` as proportion StarDist is allowed to use).
The script will create a new folder within the folder of each chamber (`savedirname\replicate\position\chamber...`)( called `seg_sd2` in which 16bit segmented images will be stored (same name and size as the phasecontrast images)
Additionally, it will create in the folder of the replicate a new folder `stardistdata` in which properties (regionprops) of the stardist segmented images will be saved
Default output columns:
- `replicate`: name of the replicate, same as in the meta file
- `pos`: position ID, same as in the folder name and meta file
- `chamber`: chamber ID, same as in folder name
- `frame`: frame number, starting at 1
- `label`: Cell ID, same as in the image saved in seg_sd2, starting at 1
- `area`: cell area in pixel
- `centroid-0` and `centroid-1`: Y and X position of cell within the chamber crop image
- `axis_major` and `axis_minor`: longest and shortest axis through the cell
- `eccentricity`: quantification of roundness of cell
- `intensity_mean` and `intensity_max`: average and maximal florescent intensity. If more than 1 fluorescent channel, the values will be prefixed with fluo1_ and fluo2_, etc
- `folder`: original folder location

 
## 3) Run DeLTA 2.0 tracking (s3_delta.ipynb)
Uses the  `.../envs/jbdelta.yaml` conda environment.
I use a local version of DeLTA 2.0 as I did some minor mods (no cell pole detection, just use center. Disable all user messages and some minor bug fixes for my type of images including a custom weights function for tracking training). I need to check all my changes and see how I can merge them into the official branch. For the moment, my DeLTA version is included in this github repo (`.../delta_vjb`) and is attached to the sys path at the start of the script to be able to access functions in it. The path for it is specified in `s0_writeconfig.mat`. Therefore, there's no need to install DeLTA within conda which anyway failed for Windows (maybe fixed by now?). The tracking model file is large and not in the repo. Please download it from Zenodo (10.5281/zenodo.10694025).
The script runs in a similar fashion as the stardist one over all folders for which the section 1) and 2) are already done. It generates a new folder called `deltadata` within the replicate folder and saves a .csv for each position and chamber which contains the tracking output of delta processed with a function provided by Simon van Vliet to generate a pandas table that can easily be exported to .csv and then read into R for whatever you want to do. If you want the native DeLTA format of data, select `pickle` as an option in the `saveformats` variable.
The script uses the config from s0_writeconfig.mat:
- `deltapath`  as I use a locally modified delta version that is not installed via conda or pip, I append the path to where I have that delta package stored and load from there. Please modify accordingly
- `configpath` Path to the storage of the DeLTA config file. Edit your local copy of it: It needs to point to the tracking model (hdf5) file downloadable from Zenodo [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10694025.svg)](https://doi.org/10.5281/zenodo.10694025).
- `imageprototype` structure of the image naming scheme, all the ID numbers in it and the number format of the Ids
- `orderprototype` corresponding structure of IDs. *p* = position; *c* = color channel; *t* = frame
- `image_heigth` and `image_width` pad images to this size if they're smaller. 256x256 is also the size the tracking model has been trained for and it cannot be smaller than that. Never tried with bigger images...
- `cropimages` a parameter in the creation of the position object of delta.
- `driftcor` a parameter in the creation of the posiiton object of delta.
- `saveformats` you can save movies for the tracking, data in pickle or .mat formats (native delta outputs). Additionally, I anyway save a .csv for each movie with some easier-to-read formating.
- `clearsaves` If True, delete all detected delta output before attempting to track. Useful if you're troubleshooting and want to make sure all previous attempts are erased
- `savemovie` If True, save the Delta movie
- `savemoviefreq` frequency of movie saving
- `features_list` delta features to track


# connected chamber (cc) image analysis pipeline

## Meta data structure:
Columns after `Process` will be filled by the script iteratively and should be left empty by the user. The previous ones need/can be filled by the user. The user can add as many more columns as needed to describe their experimental design.
If there's any weird errors of the MATLAB script regarding wrong format of a column, add a dummy row 1 in which you fill out each cell. Matlab cannot assign strings to numeric table columns and if all is empty, it assigns automatically numeric which then makes it crash if it wants to assign a string...
Columns of meta file:
- `replicate`: same format as the folders
- `pos`: for each replicate starting at 1 up to number of position
- `TopStrain` & `BotStrain`: bacterial strain name for the top and bottom chambers
- `type`, `media`, `flow`, `Btype`: User variables.
- `MaxFr`: frames after MaxFr are ignored
- `Exclude`: If == "excl" the entire position will be skipped
- `Notes`: whatever arbitrary and unstructured note you want to put down
- `Process`: numeric Process name (Olympus CellSense position ID, only the digits without 'Process' and the underscores). To avoid any mistakes due to weird sorting and naming by CellSense, I suggest filling that manually. The script will then use this number to open an image and will not assume any kind of sorting. If it is left empty, the field is filled by script based on natural sorting
- `rotangle`: either manually fill in the rotation angle or use the `s1_rotation.m` script to write it into the meta file
- `StageX`: X position of stage. Filled by script
- `StageY`: Y position of stage. Filled by script
- `PxinUmX`: spatial calibration factor. Filled by script
- `PxinUmY`: spatial calibration factor (should always be the same as the one above, I guess). Filled by script
- `chamberbox1` to `chamberbox4` give the position of the detected bounding box of the connected chamber in the format x_start, y_start, width, height
- `register`: Turns to "Done" once the `s2_chamgerdetect.m` has been run. Filled by script
- `stardist`: Turns to "Done" once the StarDist script has been run. Filled by script
- `stardist_fails`: reports any error messages occuring during te run of the StarDist script. Filled by script

## 0) Create json config file (s0_writeconfig.m)
This is a small MATLAB script to generate a json file containing all variables needed to adapt by the user for the following scripts.
The variables are described in the script and an example json file is included in the repo.

## 1) Manual rotation correction (s1_rotation.mat)
Visually aided manual image rotation detection to write that information in the meta csv file. The next script relies on accurate vertical alignment of the chamber with the two connected chambers on top of each other.

## 2) Register images, detect (filled) chambers and extract small images (s2_chamberdetect.m)
MATLAB based preprocessing. It needs a couple functions from the image processing toolbox (https://www.mathworks.com/products/image.html) and needs the bioformats toolbox (https://docs.openmicroscopy.org/bio-formats/6.1.0/users/matlab/index.html#installation).

### General datastructure:
`masterdir` (config variable): contains subfolders for each biological replicate (format: 1 letter, 2 numbers, eg *s02*). These then contain the output of the Olympus microscope (_ProcessXXXXX_ folders (1 per position, containing the .ets image file) and a corresponding .vsi file).
The `masterdir` also needs to contain a meta file (add name in config `metacsv`), see  `.../CC_pipeline/meta_processing.csv` for an example and details above.
If you follow this data structure, you can just hit run for the MATLAB script. It assumes 100x magnification images and runs with Olympus default image file format. If you use another imaging platform, there's likely some adjustment that needs to be done. I am happy to help you adjust whatever you need if you can provide me with an example file.
This script will iterate over all the folders and save processed images within `masterdir/savedirname` (config) in seperate folders for each replicate. In there, it will create 3 more folders:
- `movies`: overview movies with all channels overlaid. A timestamp and size bar as well as an optional rectangle for each exported chambers are added. Details for movie formating are defined in the config file.
- `reginfofolder`: a csv file for each position containing info about the image registration: x and y drift (relative to first frame) as well as blur percentage value (based on https://ijssst.info/Vol-19/No-1/paper7.pdf)
- `Chambers`: main output directory. For each Position, a new folder is created. These contain again a folders for each chamber. In there, seperate .tif files (default. Also tif stack possible, see config) for each frame and channel. Naming scheme: replicate\Position\Chamber\ChamberChannelFrame.tif. Ch1 is always assumed to be either phasecontrast or brightfield.
Example: "...\s02\Pos03\Chamb05\Chamb05Ch2Fr123.tif"

## 2) Run StarDist2D segmentation (s3_stardist.ipynb)
Uses the `...\envs\jbStarDist.yaml` conda environment.
Connected chamber specific model is stored in `.../stardist_models/cc` 
The script uses the config from `s0_writeconfig.mat`. Most importantly, the `stardistmodeldir` needs to be specified. The specified dir should contain a folder named `stardist` which contains the `weights_best.h5`, `thresholds.json` and `config.json`. Mine is a custom trained model.
Additionally, you can indicate if there are fluorescent channels you want to be quantified with regionprops (`flims`) and limit the GPU RAM usage of StarDist (`ramsize` to define available RAM in GB and `ramlimit` as proportion StarDist is allowed to use).
The script will create a new folder within the folder of each chamber (`savedirname\replicate\position\chamber...`)( called `seg_sd2` in which 16bit segmented images will be stored (same name and size as the phasecontrast images)
Additionally, it will create in the folder of the replicate a new folder `stardistdata` in which properties (regionprops) of the stardist segmented images will be saved
Default output columns:
- `replicate`: name of the replicate, same as in the meta file
- `pos`: position ID, same as in the folder name and meta file
- `chamber`: chamber ID, same as in folder name
- `frame`: frame number, starting at 1
- `label`: Cell ID, same as in the image saved in seg_sd2, starting at 1
- `area`: cell area in pixel
- `centroid-0` and `centroid-1`: Y and X position of cell within the chamber crop image
- `axis_major` and `axis_minor`: longest and shortest axis through the cell
- `eccentricity`: quantification of roundness of cell
- `intensity_mean` and `intensity_max`: average and maximal florescent intensity. If more than 1 fluorescent channel, the values will be prefixed with fluo1_ and fluo2_, etc
- `folder`: original folder location
