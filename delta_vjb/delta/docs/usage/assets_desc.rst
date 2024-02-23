
Downloading assets
=================================

`Source code <https://gitlab.com/dunloplab/delta/-/blob/master/delta/assets.py>`_ | 
:doc:`API <../_generated/delta.assets>` 

We provide archives of our trained models, training sets, and evaluation movies
in `this google drive folder <https://drive.google.com/drive/folders/1nTRVo0rPP9CR9F6WUunVXSXrLNMT_zCP?usp=sharing>`_

You can download them manually, but the assets module allows you to download 
and save them automatically, and also to generate the JSON config files that 
points to their location so you can start using DeLTA right away.

You will only need to run this once after install, unless you want to
re-download assets.

Automated download
----------------------

You can download assets interactively simply by executing the following line
in python after importing delta::

    delta.assets.download_assets()

For a first installation/use, we recommend downloading all assets and setting the
configuration level to 'global'. See :doc:`Configuration files <config_desc>` 
for more information. 

Please note that some of these datasets are several GBs in size and the 
download process can take a while. By default they are saved in an 'assets' 
folder under the delta installation path. If you are only interested in running
DeLTA as-is, without retraining or evaluating outputs, you can only accept
the models and save the corresponding config file, the 
:doc:`pipeline <pipeline_desc>` will run.

Download and path options
--------------------------

You can also specify which assets to download if you want to automate the process::

    delta.assets.download_assets(
        load_models=True,
        load_sets=True,
        load_evals=False,
        config_level='local'
    )

or specify where to save them, for example if you don't want them to be saved 
under the installation directory::

    delta.assets.download_assets(
        load_models='/path/to/models/folder',
        load_sets=False,
        load_evals='/other/path/to/eval/folder',
        config_level='/my/path/to/config_file.json'
    )

