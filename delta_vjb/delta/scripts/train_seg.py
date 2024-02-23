"""
This script trains the cell segmentation U-Net

@author: jblugagne
"""
import os

from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping

from delta.utilities import cfg
from delta.model import unet_seg
from delta.data import trainGenerator_seg

# Load config:
cfg.load_config(presets="2D")

# Files:
training_set = cfg.training_set_seg
savefile = cfg.model_file_seg

# Training parameters:
batch_size = 1
epochs = 600
steps_per_epoch = 300
patience = 50

# Data generator parameters:
data_gen_args = dict(
    rotation=2,
    rotations_90d=True,
    zoom=0.15,
    horizontal_flip=True,
    vertical_flip=True,
    illumination_voodoo=True,
    gaussian_noise=0.03,
    gaussian_blur=1,
)

# Generator init:
myGene = trainGenerator_seg(
    batch_size,
    os.path.join(training_set, "img"),
    os.path.join(training_set, "seg"),
    os.path.join(training_set, "wei"),
    augment_params=data_gen_args,
    target_size=cfg.target_size_seg,
    crop_windows=cfg.crop_windows,
)

# Define model:
model = unet_seg(input_size=cfg.target_size_seg + (1,))
model.summary()

# Callbacks:
model_checkpoint = ModelCheckpoint(
    savefile, monitor="loss", verbose=2, save_best_only=True
)
early_stopping = EarlyStopping(monitor="loss", mode="min", verbose=2, patience=patience)

# Train:
history = model.fit(
    myGene,
    steps_per_epoch=steps_per_epoch,
    epochs=epochs,
    callbacks=[model_checkpoint, early_stopping],
)
