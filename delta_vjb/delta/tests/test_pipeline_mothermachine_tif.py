#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  8 10:08:21 2021

@author: jeanbaptiste
"""

import sys
from pathlib import Path

import pytest

import delta


@pytest.mark.order(2)
def test_pipeline_mothermachine():
    sys.argv = [sys.argv[0]]
    xpfolder = Path(__file__).parent / "data/movie_mothermachine_tif"
    sys.argv.append(str(xpfolder))

    # Load configuration:
    delta.utils.cfg.load_config(presets="mothermachine", config_level="global")

    xpreader = delta.utils.xpreader()

    xp = delta.pipeline.Pipeline(xpreader)

    xp.process(clear=False)

    # Testing load from pipeline save:
    # Init new xpreader:
    new_xpreader = delta.utils.xpreader(xpfolder)

    # Load up processor:
    new_xp = delta.pipeline.Pipeline(
        new_xpreader, reload=True, resfolder=xpfolder / "delta_results"
    )

    assert len(xp.positions) == len(new_xp.positions)
