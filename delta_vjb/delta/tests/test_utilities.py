#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 19 15:01:05 2021

@author: ooconnor
"""
#
import random

import pytest
import numpy as np
import cv2
from scipy.ndimage import binary_fill_holes
from pathlib import Path
import sys

from delta import utils, pipeline

#%% Eval create_windows


def rand_img(image_size):
    img = np.random.random(image_size)
    return img


def test_deskew_0():
    _test_deskew("angle_+0.53.tif", 0.53)

def test_deskew_1():
    _test_deskew("angle_-0.32.tif", -0.32)

def _test_deskew(filename, angle0):
    file = Path(__file__).parent / "data/images" / filename
    image0 = cv2.imread(str(file), cv2.IMREAD_ANYDEPTH)
    image = utils.imrotate(image0, -angle0)
    assert np.abs(utils.deskew(image)) <= 0.25
    for angle in np.linspace(-3, 3, 30):
        image = utils.imrotate(image0, angle - angle0)
        assert np.abs(utils.deskew(image) + angle) <= 0.25

@pytest.mark.order(2)
class Test_create_windows:
    def test_create_windows_base(self):
        assert (
            utils.create_windows(
                rand_img((512, 512)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 1
        )

    def test_create_windows_2048x2048(self):
        assert (
            utils.create_windows(
                rand_img((2048, 2048)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 25
        )

    def test_create_windows_200x200(self):
        assert (
            utils.create_windows(
                rand_img((200, 200)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 1
        )

    def test_create_windows_200x600(self):
        assert (
            utils.create_windows(
                rand_img((200, 600)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 2
        )

    def test_create_windows_600x200(self):
        assert (
            utils.create_windows(
                rand_img((600, 200)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 2
        )

    def test_create_windows_100x700(self):
        assert (
            utils.create_windows(
                rand_img((1000, 700)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 6
        )

    def test_create_windows_696x520(self):
        assert (
            utils.create_windows(
                rand_img((696, 520)), target_size=(512, 512), min_overlap=24
            )[0].shape[0]
            == 4
        )


#%% Eval find_contours


def rand_mask(image_size, max_dots=100, max_radius=30):
    "Generate a random binary mask with random size dots"
    mask = np.zeros(image_size, dtype=np.uint8)
    num_dots = random.randint(0, max_dots)

    for dot in range(num_dots):
        cv2.circle(
            mask,
            center=(random.randint(0, image_size[0]), random.randint(0, image_size[0])),
            radius=random.randint(1, max_radius),
            color=1,
            thickness=-1,
        )

    # Holes cause issues here
    mask = binary_fill_holes(mask).astype(np.uint8)

    return mask


def evaluate_contours(mask, contours, image_size):
    "Reconstruct mask from contours and make it is the same as the original"

    new_mask = np.zeros(image_size, dtype=np.uint8)
    new_mask = cv2.drawContours(new_mask, contours, -1, 1, thickness=-1)

    return not (np.bitwise_xor(mask, new_mask).any())


@pytest.mark.order(2)
@pytest.mark.parametrize("execution_number", range(10))  # Run it 10 times
class Test_find_contours:
    def test_find_contours_base(self, execution_number):
        image_size = (512, 512)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_2048x2048(self, execution_number):
        image_size = (2048, 2048)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_200x200(self, execution_number):
        image_size = (200, 600)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_200x600(self, execution_number):
        image_size = (200, 600)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_600x200(self, execution_number):
        image_size = (600, 200)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_100x700(self, execution_number):
        image_size = (100, 700)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_696x520(self, execution_number):
        image_size = (696, 520)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)

    def test_find_contours_256x32(self, execution_number):
        image_size = (256, 32)
        mask = rand_mask(image_size)
        contours = utils.find_contours(mask)
        assert evaluate_contours(mask, contours, image_size)


def test_skeleton_poles():
    skel = np.array(
        [
            [0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 1, 0],
            [1, 1, 1, 0, 0, 1],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 1, 1],
            [0, 0, 0, 1, 0, 0],
        ],
        dtype=np.bool_,
    )
    mask_poles = utils.skeleton_poles(skel)
    solution = np.array(
        [
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
        ],
        dtype=np.bool_,
    )
    assert np.array_equal(mask_poles, solution)


def test_extract_poles():
    labels = np.array(
        [
            [1, 1, 0, 2, 2, 2],
            [1, 1, 0, 2, 2, 2],
            [1, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 4, 4],
            [3, 3, 3, 0, 4, 4],
        ]
    )
    skel = np.array(
        [
            [0, 1, 0, 1, 1, 0],
            [1, 0, 0, 0, 0, 1],
            [0, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 0],
            [1, 1, 1, 0, 0, 1],
        ],
        dtype=np.bool_,
    )
    mask_poles = utils.skeleton_poles(skel)
    poles = utils.extract_poles(mask_poles, labels)
    solution = [
        [np.array([0, 1]), np.array([2, 1])],  # Cell 1
        [np.array([0, 3]), np.array([1, 5])],  # Cell 2
        [np.array([4, 0]), np.array([4, 2])],  # Cell 3
        [np.array([3, 4]), np.array([4, 5])],  # Cell 4
    ]
    assert np.array_equal(poles, solution)


@pytest.mark.parametrize("execution_number", range(1000))  # Run it 1000 times
def test_track_poles(execution_number):
    # Random previous old pole:
    prev_old = np.random.randint(low=0, high=32767, size=2, dtype=np.int16)
    # Random previous new pole is some small random distance away:
    while True:
        increment = np.random.normal(loc=0, scale=20, size=2).astype(np.int16)
        dist = np.linalg.norm(increment)
        if dist < 10:  # At least 10 pixels between poles
            continue
        prev_new = prev_old + increment
        if np.all(prev_new >= 0):
            break

    while True:
        # Simulate whole cell shift:
        cell_shift = np.random.gamma(shape=2, scale=2, size=2)

        # Simulate small pole shifts:
        increment = np.random.uniform(low=-3, high=3, size=2)
        new_new = prev_new + cell_shift + increment

        # Simulate small pole shifts:
        increment = np.random.uniform(low=-3, high=3, size=2)
        new_old = prev_old + cell_shift + increment

        new_new = new_new.astype(np.int16)
        new_old = new_old.astype(np.int16)
        if np.all(new_new >= 0) and np.all(new_old >= 0):
            break

    if random.random() > 0.5:
        poles = [new_new, new_old]
    else:
        poles = [new_old, new_new]

    out_old, out_new = utils.track_poles(poles, prev_old, prev_new)

    assert np.all(out_old == new_old)
    assert np.all(out_new == new_new)


@pytest.mark.parametrize("execution_number", range(1000))  # Run it 1000 times
def test_division_poles(execution_number):

    # Random previous old pole:
    prev_old = np.random.randint(low=0, high=32767, size=2, dtype=np.int16)
    # Random previous new pole is some small random distance away:
    while True:
        increment = np.random.normal(loc=0, scale=20, size=2).astype(np.int16)
        dist = np.linalg.norm(increment)
        if dist < 20:  # At least 20 pixels between poles
            continue
        prev_new = prev_old + increment
        if np.all(prev_new >= 0):
            break

    # Generate shift poles to create "current frame"
    while True:
        # Simulate whole cell shift:
        cell_shift = np.random.gamma(shape=2, scale=2, size=2)

        # Simulate small pole shifts:
        increment = np.random.uniform(low=-3, high=3, size=2)
        daughter_old = prev_new + cell_shift + increment

        # Simulate small pole shifts:
        increment = np.random.uniform(low=-3, high=3, size=2)
        mother_old = prev_old + cell_shift + increment

        daughter_old = daughter_old.astype(np.int16)
        mother_old = mother_old.astype(np.int16)
        if np.all(daughter_old >= 0) and np.all(mother_old >= 0):
            break

    # Generate septum and new poles:
    septum = mother_old / 2 + daughter_old / 2

    # Shift by 2 pixels towards mother to get mother's new pole
    sep2mot = 2 * (septum - mother_old) / np.linalg.norm(septum - mother_old)
    mother_new = (mother_old + sep2mot).astype(np.int16)

    # Shift by 2 pixels towards mother to get mother's new pole
    sep2dau = 2 * (septum - daughter_old) / np.linalg.norm(septum - daughter_old)
    daughter_new = (daughter_old + sep2dau).astype(np.int16)

    # Randomly assign poles to the input lists:
    if random.random() > 0.5:
        mother_poles = [mother_new, mother_old]
    else:
        mother_poles = [mother_old, mother_new]

    if random.random() > 0.5:
        daughter_poles = [daughter_new, daughter_old]
    else:
        daughter_poles = [daughter_old, daughter_new]

    if random.random() > 0.5:
        first_cell_is_mother_t = True
        poles_cell1 = mother_poles
        poles_cell2 = daughter_poles
    else:
        first_cell_is_mother_t = False
        poles_cell2 = mother_poles
        poles_cell1 = daughter_poles

    # Run division poles:
    mother_poles_out, daughter_poles_out, first_cell_is_mother = utils.division_poles(
        poles_cell1, poles_cell2, prev_old, prev_new
    )

    # Assertions:
    assert first_cell_is_mother == first_cell_is_mother_t
    assert np.all(mother_old == mother_poles_out[0])
    assert np.all(mother_new == mother_poles_out[1])
    assert np.all(daughter_old == daughter_poles_out[0])
    assert np.all(daughter_new == daughter_poles_out[1])


#%% Make sure contour coloring and cv2 colormap work
def _base_test_color(max_dots):

    # Get random mask and RGB frame:
    mask = rand_mask((2048, 2048), max_dots=max_dots)
    frame = np.repeat(mask[:, :, np.newaxis].astype(np.float64), 3, axis=2)

    # Get cells numbers and contours:
    cells, contours = utils.getcellsinframe(utils.label_seg(mask), return_contours=True)

    # Get random colors:
    colors = utils.getrandomcolors(len(cells), seed=random.randint(0, 1024))

    # Color cells contours:
    for c, cell in enumerate(cells):
        frame = cv2.drawContours(
            frame,
            contours,
            c,
            color=colors[cell],
            thickness=1,
        )

    return mask, frame


def _evaluate_color_nb(mask, frame):

    # Get cell contours:
    contours = utils.find_contours(mask)

    # Get colors present in frame:
    colors = np.unique(
        np.reshape(frame, (frame.shape[0] * frame.shape[1], frame.shape[2])), axis=0
    )

    # Assert that we have the right nb of colors:
    assert colors.shape[0] == len(contours) + np.unique(mask).shape[0]


@pytest.mark.order(2)
@pytest.mark.parametrize("execution_number", range(5))  # Run it 10 times
class Test_color_contours:
    def test_nocell(self, execution_number):
        mask, frame = _base_test_color(0)
        _evaluate_color_nb(mask, frame)

    def test_onecell(self, execution_number):
        mask, frame = _base_test_color(1)
        _evaluate_color_nb(mask, frame)

    def test_twocells(self, execution_number):
        mask, frame = _base_test_color(2)
        _evaluate_color_nb(mask, frame)

    def test_100cells(self, execution_number):
        mask, frame = _base_test_color(100)
        _evaluate_color_nb(mask, frame)


#%% Test xpreader


class Test_xpreader:
    def test_2D_tif_cmdln_filename_noresfolder(self):
        # 'Pretend' arguments were passed to the cmd line:
        sys.argv = [sys.argv[0]]
        sys.argv.append(str(Path(__file__).parent / "data" / "movie_2D_tif"))

        # Load configuration:
        utils.cfg.load_config(presets="2D", config_level="global")

        # Init reader
        xpreader = utils.xpreader()

        # Init pipeline:
        xp = pipeline.Pipeline(xpreader)

    def test_2D_tif_cmdln_allargs(self):
        # 'Pretend' arguments were passed to the cmd line:
        sys.argv = [sys.argv[0]]
        sys.argv.append(str(Path(__file__).parent / "data" / "movie_2D_tif"))

        sys.argv.append("--resfolder")
        sys.argv.append(
            str(Path(__file__).parent / "data" / "movie_2D_tif" / "results")
        )

        sys.argv.append("--order")
        sys.argv.append("pct")

        sys.argv.append("--index")
        sys.argv.append("1")

        sys.argv.append("--prototype")
        sys.argv.append(
            "Position%02dChanel%02dFrame%06d.tif"
        )  # Currently there is a typo where it is chanel not channel

        # Load configuration:
        utils.cfg.load_config(presets="2D", config_level="global")

        # Init reader
        xpreader = utils.xpreader()

        # Init pipeline:
        xp = pipeline.Pipeline(xpreader)

    def test_2D_tif_xpreader_filename_noresfolder(self):

        sys.argv = [sys.argv[0]]

        # Load configuration:
        utils.cfg.load_config(presets="2D", config_level="global")

        # Init reader
        xpreader = utils.xpreader(Path(__file__).parent / "data" / "movie_2D_tif")

        # Init pipeline:
        xp = pipeline.Pipeline(xpreader)

    def test_2D_tif_xpreader_filename_and_resfolder(self):

        sys.argv = [sys.argv[0]]

        # Load configuration:
        utils.cfg.load_config(presets="2D", config_level="global")

        # Init reader
        xpreader = utils.xpreader(Path(__file__).parent / "data" / "movie_2D_tif")

        # Init pipeline:
        xp = pipeline.Pipeline(
            xpreader,
            resfolder=Path(__file__).parent / "data" / "movie_2D_tif" / "results",
        )

    def test_moma_tif_xpreader_filename_noresfolder(self):

        sys.argv = [sys.argv[0]]

        # Load configuration:
        utils.cfg.load_config(presets="2D", config_level="global")

        # Init reader
        xpreader = utils.xpreader(
            Path(__file__).parent / "data" / "movie_mothermachine_tif"
        )

        # Init pipeline:
        xp = pipeline.Pipeline(xpreader)
