
Configuration files
=================================

`Source code <https://gitlab.com/dunloplab/delta/-/blob/master/delta/config.py>`_ | 
:doc:`API <../_generated/delta.config>` 

The config.py module loads JSON configuration files, and is then used to 
parameterize multiple operations throughout the 
:doc:`pipeline <pipeline_desc>` , :doc:`data <data_desc>`, :doc:`models <model_desc>` 
and :doc:`utilities <utils_desc>` modules. It is also used in the 
:doc:`example scripts <scripts>` although these values can be changed.

The :doc:`assets <assets_desc>` module can automatically write config files based 
on downloaded assets, but you can also write your own JSON config files if you 
want to change default config values. JSON files can be opened with any text
editor, and are fairly readable. For more information on each parameter, check
out the API.

Before running any operation with DeLTA, you will need to load a configuration
file. To do so, you can simply run the following after import::

    delta.config.load_config()

By default, this will import the '2D' presets configuration file from the local
configuration level or, if not found, from the global configuration level.

Presets and configuration levels
--------------------------------
If an explicit path to a JSON configuration file is not provided to `load_config()`,
the function will look for config files based on 2 other arguments: `presets`
and `config_level`. Presets can be either '2D' or 'mothermachine', and 
`load_config()` will look for files named 'config_2D.json' or 
'config_mothermachine.json' accordingly::

    delta.config.load_config(presets='2D')
    delta.config.load_config(presets='mothermachine')
    
Note that you can use different preset names, but the 'config_<presets>.json' 
file must exist in the local or global folder.

By default, `load_config()` will look for the relevant config file in two 
different locations: 

#. | First, it will look into a 'local' folder which is under 
     the current user's personal home folder, in a .delta hidden config folder. 
     For example on a typical linux/osx installation this would be
     `/home/yourusername/.delta/`, and under a typical windows installation this would 
     be `C:\\Users\\yourusername\\.delta\\`
   | Because the exact path will vary depending
     on which user is calling `load_config()`, this can be a good way for each user on
     the same system to have their own personal config file that they can tweak
     independently.

#. | Then, if it did not find the relevant config file, it will look into a 
     'global' folder that resides under the delta installation folder in the 'assets'
     subfolder. For example under our cluster conda install, this would be under
     `/project/dunlopgroup/.conda/envs/delta_conda2/lib/python3.9/site-packages/delta/assets/config`
   | This means that all users on the same system will have access to this config file if they
     all use the same install of delta. This can be a good way to have all users use the same
     configurations.

But you can also specify that you want to strictly look into the local or global
folder::

    delta.config.load_config(presets='2D',config_level='local')
    delta.config.load_config(presets='mothermachine',config_level='global')
    delta.config.load_config(presets='mypresetsname',config_level='local')

Explicit config file path
-------------------------
Of course, you might want to use completely different paths or filenames. You
can provide the path to a config file directly::

    delta.config.load('/path/to/myconfigfile.json')

This allows you to generate and use your own config files wherever you want on
your system

Modify configuration on-the-fly
--------------------------------
You can also change configuration parameters after loading::

    delta.config.target_size_seg = (1024,1024)
    delta.config.min_cell_area = 0
    delta.config.save_format = ('pickle',)

Note that for tensorflow-related parameters `TF_CPP_MIN_LOG_LEVEL` and 
`memory_growth_limit`, modifying them after loading may not actually change
tensorflow's behavior. You will probably need to re-import DeLTA and make the
changes in the JSON config file.

Old config imports
------------------

If you try to import a config file that was generated for an older version of
DeLTA, you may get a warning message if the parameters in the file do not match
the parameters for the new version of DeLTA. This does not necessarily mean that 
the entire software will not work so we allow the load to continue, but it is
probably better for you to update that file or re-generate one with the
:doc:`assets downloader <assets_desc>`

Also note that, in the source code, you may find places where the config module is
referred to through the utils module, in statements such as::

    from .utilities import cfg

Which is due to how we used to load configuration in previous versions. Now
both `delta.config` and `delta.utils.cfg` point to the same thing.
