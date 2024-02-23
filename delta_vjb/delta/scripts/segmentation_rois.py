"""
This script will run the rois identification/segmentation U-Net. 

To see how to extract roi images with this segmentation masks, see the 
preprocessing section of pipeline.py and getROIboxes() in utilities.py

@author: jblugagne
"""

import os
import glob


from delta.utilities import cfg
from delta.data import saveResult_seg, predictGenerator_seg, postprocess
from delta.model import unet_rois

# Load config file:
cfg.load_config(presets="mothermachine")

# Images sequence (change to whatever images sequence you want to evaluate):
inputs_folder = cfg.eval_movie

# Output folder:
outputs_folder = os.path.join(inputs_folder, "roi_masks")
if not os.path.exists(outputs_folder):
    os.makedirs(outputs_folder)

# List files in inputs folder:
input_files = sorted(
    glob.glob(inputs_folder + "/*.tif") + glob.glob(inputs_folder + "/*.png")
)

# Load up model:
model = unet_rois(input_size=cfg.target_size_rois + (1,))
model.load_weights(cfg.model_file_rois)

# Inputs data generator:
predGene = predictGenerator_seg(
    inputs_folder, files_list=input_files, target_size=cfg.target_size_rois
)

# Predictions:
results = model.predict_generator(predGene, len(input_files), verbose=1)

# Post process results:
results[:, :, :, 0] = postprocess(results[:, :, :, 0])

# Save to disk:
saveResult_seg(outputs_folder, results, files_list=input_files)
