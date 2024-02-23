
Example scripts
=================
These scripts are not packaged with DeLTA as part of the conda-forge package,
however you can find them on our 
`gitlab under scripts <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts>`_

They can be run from anywhere on your system if you installed through conda. If
you are using the source code from our gitlab, you will need to add the delta
repository to your python path or call them from the top of the repository in
order to be able to import DeLTA. If you are using git to stay up to date with
the latest release of DeLTA, we recommend copying and modifying these scripts
outside of the git repository.

If this is your first use, you will need to :doc:`download assets <assets>` 
before running these scripts.

.. _run_pipeline:

Run pipeline
-------------

`run_pipeline.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/run_pipeline.py>`_

This script loads the default 2D configuration file and processes the evaluation
movie. Note that you can also change the presets to 'mothermachine' and it will
also run, evaluating the mother machine evaluation movie instead.

To check where the output files were saved::

    xp.resfolder

.. _training_scripts:

Training scripts
-----------------

We provide 3 example training scripts: 

* `train_rois.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/train_rois.py>`_
  can be used to train a new ROIs identification U-Net. By default it will train to
  recognize mother-machine chambers from our base training set. However this script
  can be used to either adapt the model to recognize mother machine chambers in your
  own images, or even to recognize different types of ROIs like a different type of 
  microfluidic chambers.
* `train_seg.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/train_seg.py>`_,
  can be used to train a new segmentation U-Net. By default it will train to segment
  *E. coli* cells from the downloaded assets 2D training set, but you can switch it
  to the mothermachine presets or use it to train on your own data.
* `train_track.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/train_track.py>`_.
  can be used to train a new tracking U-Net. By default it will train to track
  *E. coli* cells from the downloaded assets 2D training set, but you can switch it
  to the mothermachine presets or use it to train on your own data.

In general we recommend merging your training set with ours for training because 
it tends to improve performance. It also lowers the number of new training sample 
required if the images are similar enough. See our papers for more information
on how to generate training samples. We have been working on graphical user 
interfaces to streamline the process but we do not yet have an estimate for when
these would be finalized.

.. note::
    If you have developed your own training sets for any new application or simply
    to get better results better with your data and you would like to share them, feel free
    to contact us! We would be more than happy to make them available to the community or
    merge them with our training sets and train our latest models on them.

.. _eval_scripts:

Evaluation scripts
------------------

We provide 3 scripts to quickly gauge the performance of the trained U-Net
models. These scripts are also intended as a way for users to gain an 
understanding of how the U-Nets are used in the main pipeline, and what data
formats they take as input and produce as outputs.

* `segmentation_rois.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/segmentation_rois.py>`_
  produces segmentation masks delineating the mother machine chambers present in the 
  mother machine evaluation movie. In the mother machine `Pipeline`, the predictions
  from this U-Net for the first timepoint are used to then crop out images of 
  single chambers in the rest of the movie, after drift correction is applied.
* `segmentation.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/segmentation.py>`_
  segments cells in the 2D evaluation movie. You can change the 
  segmentation folder to any image sequence you want to evaluate. The outputs
  from the segmentation U-Net are used, in the `Pipeline` and `Position` objects,
  to generate tracking inputs. You can check out what the input data to the
  U-Net looks like with `input_batch = next(predGene)`
* `tracking.py <https://gitlab.com/dunloplab/delta/-/blob/master/delta/scripts/tracking.py>`_
  uses the outputs `segmentation.py` to perform single-cell tracking. The
  :ref:`predictCompilefromseg_track <prediction_gen>` generator uses the filenames
  to infer images order and to compile tracking inputs for every segmented cell
  over time.
