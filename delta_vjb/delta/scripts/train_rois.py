"""
This script trains the chambers segmentation U-Net.

@author: jblugagne
"""
import os

from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping

from delta.utilities import cfg
from delta.model import unet_rois
from delta.data import trainGenerator_seg

# Load config:
cfg.load_config(presets="mothermachine")

# Files:
training_set = cfg.training_set_rois
savefile = cfg.model_file_rois

# Parameters:
batch_size = 1
epochs = 600
steps_per_epoch = 250
patience = 50

# Data generator parameters:
data_gen_args = dict(
    rotation=3,
    shiftX=0.1,
    shiftY=0.1,
    zoom=0.25,
    horizontal_flip=True,
    vertical_flip=True,
    rotations_90d=True,
    histogram_voodoo=True,
    illumination_voodoo=True,
    gaussian_noise=0.03,
)

# Generator init:
myGene = trainGenerator_seg(
    batch_size,
    os.path.join(training_set, "img"),
    os.path.join(training_set, "seg"),
    None,
    augment_params=data_gen_args,
    target_size=cfg.target_size_rois,
)

# Define model:
model = unet_rois(input_size=cfg.target_size_rois + (1,))
model.summary()

# Callbacks:
model_checkpoint = ModelCheckpoint(
    savefile, monitor="loss", verbose=1, save_best_only=True
)
early_stopping = EarlyStopping(monitor="loss", mode="min", verbose=1, patience=patience)

# Train:
history = model.fit_generator(
    myGene,
    steps_per_epoch=steps_per_epoch,
    epochs=epochs,
    callbacks=[model_checkpoint, early_stopping],
)
