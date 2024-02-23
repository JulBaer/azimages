
Training with the data module
==============================

`Source <https://gitlab.com/dunloplab/delta/-/blob/master/delta/data.py>`_ | 
:doc:`API <../_generated/delta.data>` 

The Data module contains functions and generators to read and pre-process 
training sets files, perform data augmentation operations, and
feed inputs into the U-Net models for training, as well as functions and generators 
to pre-process inputs for prediction. In addition a few functions are provided for 
light post-processing and saving results to disk.

This module was implemented a while ago and many functions are redundant with
some from the :doc:`utilities module <utils_desc>`. However, we decided not to 
merge or modify this module for reproducibility purposes. Note that it might 
get re-written at some point in the future.

Training generators and datasets
---------------------------------

The module contains 2 generator functions to be used for training the segmentation
and tracking U-Nets, namely 
:doc:`trainGenerator_seg() <../_generated/delta.data.trainGenerator_seg>` and
:doc:`trainGenerator_track() <../_generated/delta.data.trainGenerator_track>`.

For every batch, these generators read random training samples from the training
sets folders, apply the same data augmentation operation to all images within
the same sample, and then stack these samples together to form a batch of size
`batch_size`.

For segmentation, the structure of the training sets is:

* `img` folder [Input]: movie frames
    Microscopy images to use as training inputs. So far
    we've been exclusively using phase contrast images, but these could be 
    replaced by bright field or fluorescence images, or even a mix of the three
* `seg` folder [Output]: Segmentation ground-truth
    Segmentation groundtruth to train the the U-Net 
    against to try and learn how to segment the cells
* `wei` folder [Output]: Weight maps, optional
    Pixel-wise weight maps. These are used to multiply the
    loss in certain key regions of the image and force the model to focus on
    these regions. The main use for them is to force the models to focus on
    small borders between cells. These can be generated from the `seg` images
    with :doc:`seg_weights() <../_generated/delta.data.seg_weights>` and
    :doc:`seg_weights_2D() <../_generated/delta.data.seg_weights_2D>`

For tracking, the stucture is:

* `previmg` folder [Input]: movie frames at previous time point
    Microscopy images to use as training inputs for the
    previous time point, i.e. the time point that we want to predict tracking *from*.
* `seg` folder [Input]: 'seed' cell from previous time point
    Images of the segmentation of a single cell from the previous time that we
    want to predict tracking for
* `img` folder [Input]: Input movie frames at current time point
    Microscopy images to use as training inputs for the
    current time point, i.e. the time point that we want to predict tracking *for*.
* `segall` folder [Input]: Segmentation at current time point
    Segmentation images of all cells at the current time point.
* `mot_dau` folder [Output]: Tracking ground-truth
    Tracking maps for the tracking U-Net to be trained against. Outlines the
    tracking of the 'seed' cell into the current time point, or if it divided, 
    of both cells that resulted from the division.
* `wei` folder [Output]: Weight maps, optional
    Pixel-wise weight maps. These are used to multiply the
    loss in certain key regions of the image and force the model to focus on
    these regions. The main use for them is to force the models to focus on
    the area surrounding the 'seed' cell. These can be generated from the `segall`
    and `mot_dau` images
    with :doc:`tracking_weights() <../_generated/delta.data.tracking_weights>`

.. note::
    The folder names do not need to strictly follow this nomenclature or
    even all be grouped under the same folder as the path to each folder is 
    passed as an input to the training generators.

See :ref:`Training scripts <training_scripts>` for examples use of the generators. 
For an example of datasets structure, check out your 
:doc:`downloaded training sets <assets_desc>`.

Data augmentation
------------------

A key element to making the U-Nets able to generalize to completely new experiments
and images is data augmentation. These operations modify the original training
samples in order to not only artificially inflate the size of the training sets
but also to force the models to learn to make predictions in sub-optimal or 
different imaging conditions, for example via the addition of noise or changes
in the image histograms.

The main function is :doc:`data_augmentation <../_generated/delta.data.data_augmentation>`.
It takes as an input a stack of images to process with the same operations, and augmentations
operations parameters dictionary of what operations to apply and with what parameters or parameter
ranges.

The operations names and their parameters are:

* illumination_voodoo: bool. 
    Whether to apply the `illumination voodoo` operation. It simulates a 
    variation in illumination along the Y axis.
* histogram_voodoo: bool. 
    Whether to apply the histogram voodoo operation. It performs an elastic 
    deformation on the image histogram to simulate changes in illumination.
* elastic_deformation: dict. 
    If key exists, the elastic deformation operation is applied. 
    The parameters are given as a dict. sigma values are 
    given under the sigma key, deformation points are given under 
    the points key. For example: {'sigma': 25, 'points': 5}
    You will need to install the 
    `elasticdeform <https://pypi.org/project/elasticdeform/>`_ module via pip
    to be able to use this operation. Beware that it may cause some cell 
    borders to disappear and as such can degrade performance. 
    See elasticdeform's doc for more information on the sigma and points 
    parameters.
* gaussian_noise: float. 
    Apply gaussian noise to the image. The sigma value of the 
    gaussian noise is uniformly sampled between 0 and +gaussian_noise.
* gaussian_blur: float.
    Apply gaussian blur to the image. The sigma value is the
    standard deviation of the kernel in the x and y direction.
* horizontal_flip: bool.
    Whether to flip the images horizontally. Input images have a 
    50% chance of being flipped
* vertical_flip: bool. 
    Whether to flip the images vertically. Input images have a 50% 
    chance of being flippedtrainGenerator_track
* rotations90d: bool. 
    Whether to randomly rotate the images in 90° increments. 
    Each 90° rotation has a 25% chance of happening
* rotation: int or float. 
    Range of random rotation to apply, in degrees. The angle is uniformly 
    sampled in the range [-rotation, +rotation]
* zoom: float.
    Range of random "zoom" to apply. The image is randomly zoomed 
    by a factor that is sampled from an exponential distribution 
    with a lamba of 3/zoom. The random factor is clipped at +zoom.
* shiftX: int/float. 
    The range of random image translation shift to apply along X, in pixels. A uniformly 
    sampled shift between [-shiftX, +shiftX] is applied
* shiftY: int/float. 
    The range of random image translation shift to apply along Y, in pixels. A uniformly 
    sampled shift between [-shiftY, +shiftY] is applied

Note that one extra data augmentation operation, for tracking, is executed at 
the level of the generator, and not by the `data_augmentation()` function:
Different image translation shifts are applied for images from the previous time point
and for images of the current time point. This is meant to simulate random shifts and drift 
in the
field of view over time, which often happen in timelapse movies for a variety of reasons.

This operation can be executed by passing a >0 `shift_cropbox` argument to
:doc:`trainGenerator_track() <../_generated/delta.data.trainGenerator_track>`
and using the `crop_windows` flag.

.. _prediction_gen::

Prediction generators
----------------------

To be able to rapidly assess the performance of the U-Nets after training, the
prediction generators
:doc:`predictGenerator_seg() <../_generated/delta.data.predictGenerator_seg>` and
:doc:`predictCompilefromseg_track() <../_generated/delta.data.predictCompilefromseg_track>`
can read and compile evaluation data to feed into the trained models. Please
note that these are not used in any way by the :doc:`pipeline <pipeline_desc>` 
module and are only intended for quick evaluation and explanation purposes.

`predictGenerator_seg` simply reads an image files sequence in order from a 
folder, crops or resizes images to fit the U-Net input size, and then yields
those images.

`predictCompilefromseg_track` is a little more complicated however. It reads 
image sequences in both an inputs image folder, and in a segmentation folder.
As such it is intended to be used after segmentation predictions have been made
and saved to disk. The generator uses the file names to infer the position, roi, and
time point of each sample to ensure that they are processed in the correct order.
The outputs are saved to disk with an appended `_cellXXXXXX` suffix their filename to keep track
of which cells are tracked to which (cells are numbered from top of the image to bottom).

See :ref:`Evaluation scripts <eval_scripts>` for examples
