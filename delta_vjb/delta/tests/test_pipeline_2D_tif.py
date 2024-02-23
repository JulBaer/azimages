#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 20 17:50:34 2021

@author: ooconnor
"""
import sys
from pathlib import Path

import pytest

import delta


@pytest.mark.order(2)
def test_pipeline_tif_stack():

    # 'Pretend' arguments were passed to the cmd line:
    sys.argv = [sys.argv[0]]
    xpfolder = Path(__file__).parent / "data/movie_2D_tif"
    sys.argv.append(str(xpfolder))

    # Load configuration:
    delta.utils.cfg.load_config(presets="2D", config_level="global")

    # Init reader
    xpreader = delta.utils.xpreader()

    # Init pipeline:
    xp = delta.pipeline.Pipeline(xpreader)

    xp.process(frames=[0, 1, 2, 3], clear=False)

    # Testing position pickle save
    import tempfile

    with tempfile.TemporaryDirectory() as tempdirname:
        assert len(xp.positions) > 0
        pos = xp.positions[0]
        pos.save(filename=tempdirname + "position0", save_format=("pickle",))
        import copy

        old_pos = copy.deepcopy(pos)

        # Testing Position.clear
        pos.clear()
        for k in pos.__dict__.keys():
            if k not in pos._pickle_skip:
                assert getattr(pos, k) is None

        # Testing Position.load
        pos.load(tempdirname + "position0.pkl")

    # Testing load from pipeline save:
    # Init new xpreader:
    new_xpreader = delta.utils.xpreader(xpfolder)

    # Load up processor:
    new_xp = delta.pipeline.Pipeline(
        new_xpreader, reload=True, resfolder=xpfolder / "delta_results"
    )

    assert len(xp.positions) == len(new_xp.positions)
