"""
This script simply runs the DeLTA pipeline on a movie.

Please download the latest models and evaluation movies first with
delta.assets.download_assets().

In order to use on bioformats-compatible files such .nd2, .czi, .oib, ome-tiff
 etc files please install python-bioformats first.

@author: jeanbaptiste
"""

import delta

# Load config ('2D' or 'mothermachine'):
delta.config.load_config(presets="2D")

# Use eval movie as example (or replace by None for interactive selection):
file_path = delta.config.eval_movie

# Init reader (use bioformats=True if working with nd2, czi, ome-tiff etc):
xpreader = delta.utils.xpreader(file_path)

# Init pipeline:
xp = delta.pipeline.Pipeline(xpreader)

# Run it (you can specify which positions, which frames to run etc):
xp.process()
