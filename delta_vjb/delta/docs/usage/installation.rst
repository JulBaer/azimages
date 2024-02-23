Installation
=================================

If you only want to rapidly check how DeLTA could perform on your 
data first, please check out our free
`Google Colab notebook <https://colab.research.google.com/drive/1UL9oXmcJFRBAm0BMQy_DMKg4VHYGgtxZ>`_.

You can now install DeLTA directly from conda-forge, or from the git repository.

We recommend using `Anaconda <https://www.anaconda.com/>`_ to install the 
necessary libraries and create a dedicated environment. However, we have been 
able to setup environments with pip too.

.. note::
    DeLTA does not automatically install python-bioformats anymore. You will 
    need to install it specifically

.. note::
    DeLTA does not come packaged with spyder anymore. If you want to add it to
    your environment you will have to do so specifically

.. note::
    If you want to use the 
    `elastic deformation package <https://pypi.org/project/elasticdeform/>`_, 
    you can install it a posteriori via pip::
    
        (base)$ pip install elasticdeform
    

Hardware requirements
----------------------
We recommend running DeLTA on GPU for 
significantly faster processing. To do so you will need 
`an nvidia gpu with a cuda compute capability of 3.5 or higher <https://developer.nvidia.com/cuda-gpus>`_
and `an up-to-date gpu driver <https://www.nvidia.com/Download/index.aspx?lang=en-us>`_.
If no compatible GPU/driver is found on the system, tensorflow will run on CPU.

For more information see 
`here <https://docs.anaconda.com/anaconda/user-guide/tasks/tensorflow/>`_ 
and `here <https://www.tensorflow.org/guide/gpu>`_.

If you do not have access to a compatible GPU, DeLTA will run fine on CPU but 
will be slower. Computing clusters and cloud computing platforms are also an 
alternative that has been working well for us.

Prerequisites
--------------

On Windows, you will need 
`c++ <https://docs.microsoft.com/en-us/cpp/build/vscpp-step-0-installation>`_ and 
`.NET <https://docs.microsoft.com/en-us/dotnet/framework/install/guide-for-developers>`_ 
support for Visual studio, and a recent 
`Java JDK <https://www.oracle.com/java/technologies/javase-downloads.html>`_ 
(≥8) if you want to use python-bioformats.

On Linux, you will need a recent JDK/OpenJDK and will need to create a 
`JAVA_HOME` environment variable pointing to it, for example on Ubuntu::

    (base)$ export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

You will also need libGL. On Debian/Ubuntu type systems::

    (base)$ apt install libgl1

.. note::
    The dollar sign and everything before it are not part of the shell commands

Install from conda-forge
------------------------

.. highlight:: bash

DeLTA is now available as `a conda package <https://anaconda.org/conda-forge/delta2>`_
through conda-forge. To install it,
simply run in your system's shell::

    (base)$ conda create -n delta_env -c conda-forge delta2

Or if you want to also install e.g. spyder alongside it::

    (base)$ conda create -n delta_env -c conda-forge delta2 spyder

If you want to use the python-bioformats library to be able to read various
microscopy file formats, run the following::
    
    (base)$ conda activate delta_env
    (delta_env)$ conda install pip
    (delta_env)$ pip install python-bioformats

.. note::
    For now DeLTA is only available on conda-forge for Linux and MacOSX 
    because the 
    `conda-forge version of tensorflow is not up to date <https://github.com/conda-forge/tensorflow-feedstock/pull/111>`_. 
    You can however install from the .yml file below on Windows.

.. note::
    You will need to activate the environment before you can import DeLTA in
    python

Install with conda from delta_env.yml
-------------------------------------

You can also clone or download our git repository and then use the 
`delta_env.yml` file to  install the environment::

    (base)$ conda env create -f /path/to/delta/delta_env.yml

If you want to install spyder or other libraries with DeLTA, we recommend
modifying the .yml file or creating another one with the added packages. You
can try to install them afterwards, but some large packages (like spyder) tend
to cause headaches if you do it this way.

Again, if you want to use python-bioformats, run::
    
    (base)$ conda activate delta_env
    (delta_env)$ conda install pip
    (delta_env)$ pip install python-bioformats

.. note::
    conda sometimes takes a long time to resolve the environment. Lately we 
    have had better luck using 
    `mamba <https://mamba.readthedocs.io/en/latest/>`_ instead

Install with pip
-----------------

We have typically had more trouble installing with pip than with
conda, so we recommend using the latter, but we have been able to
install dependencies with pip and run DeLTA with it. First you
will need to clone or download our repository.

Also make sure you have installed the prerequisites above, and also 
`the latest CUDA toolkit <https://developer.nvidia.com/cuda-downloads>`_
and `cuDNN <https://developer.nvidia.com/cudnn>`_ to be able to
run on GPU

then you should be able to run either of the following:

* Install dependencies from the requirements file::
   
       $ pip install -r requirements.txt
   
* Install from the online Python Package Index (PyPI)::
   
       $ pip install delta2
  

.. note::
	You might want to create a virtual environment
	first. You can use your favorite environment manager to do so.

Finally, on Windows, to be able to use the ffmpeg-python module and save mp4 
output files you will need to 
`download ffmpeg.exe <https://www.ffmpeg.org/download.html>`_ and place it in
your environment's binaries directory. Otherwise ffmpeg-python will issue a
cryptic message about not finding the file specified when trying to save.

See also 
`Tensorflow's pip install instructions <https://www.tensorflow.org/install/pip>`_

Check installation
------------------

You can check what libraries have been installed with::

    (base)$ conda activate delta_env
    (delta_env)$ conda list

or with pip::

    pip list

To check that Tensorflow is able to detect the GPU, please run the following
in the python interpreter:

.. code-block:: python

    >>> import tensorflow as tf
    >>> tf.config.list_physical_devices()

Your GPU should appear in the list.


Import DeLTA
-------------

If you installed from conda-forge or PyPI, you should be all set. The following
line in a python interpreter should work from anywhere on your system
(it will issue a warning about not finding elastic-deform if you didn't install 
it):

.. code-block:: python

    >>> import delta

However, if you installed the dependencies from delta_env.yml or requirements.txt
and are running from the sources in the repo, you will need to have delta in your
python search path. The simplest way to do it is to cd into the root of the delta 
git repository and try to import from there. However, since you will probably 
want to import DeLTA from other parts of your system, you will need to append the
path to the repository to your `PYTHONPATH` environment variable:

1. You can append temporarily from within python:
    
   .. code-block:: python
   
       >>> import sys
       >>> sys.path.append('/path/to/delta')
    
2. You can append temporarily from the shell before starting the interpreter
   or your IDE::
   
        (linux/osx)$ export PYTHONPATH="${PYTHONPATH}:/path/to/delta"
        (windows)$ set PYTHONPATH=%PYTHONPATH%;C:\path\to\delta
     
3. You can append permanently:
    
   - On linux: add the following line to your `~/.bashrc`::
    
       export PYTHONPATH="${PYTHONPATH}:/path/to/delta"
    
   - On windows: add the following line to your `C:\\autoexec.bat`::
    
       set PYTHONPATH=%PYTHONPATH%;C:\path\to\delta
    

.. note::
    There are many other ways to do this and we can't list them all here.

Once this is done you can import delta from wherever on the filesystem. 
With the PyPI and conda-forge installations, DeLTA is installed under a path
that is already part of `PYTHONPATH`. For more information see 
`python's official documentation <https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH>`_

Troubleshooting
---------------

Problems with tensorflow-estimator or h5py
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We have sometimes run into issues where conda would install versions of 
`tensorflow-estimator` that did not match the version of the base 
`tensorflow` library. To check which versions got installed if you run
into issues with `tensorflow-estimator` please run the following::

    (delta_env)$ conda list | grep tensorflow

If the versions of the estimator and the base library are too different this will
cause problems. You can run the following to install the correct version::

    (delta_env)$ conda install tensorflow-estimator==2.X

with 'X' replaced by the version of your base tensorflow.

Similarly for h5py, sometimes a version that is too recent or too old gets 
installed. Depending on which version was installed, try::

    (delta_env)$ conda install h5py==2.*

or::

    (delta_env)$ conda install h5py==3.*

You can also check which libraries have worked for us in the past  in the 
:ref:`installed library lists below <recent_installs>`

cuDNN (or other libraries) not loading
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We have run into OOM errors or some GPU-related libraries failing to load or 
initialize on laptops. See the "Limiting GPU memory growth" section on 
`this tensorflow help page <https://www.tensorflow.org/guide/gpu>`_. 
Setting the `memory_growth_limit` parameter in the 
:doc:`JSON config file <config_desc>` to a set value in MB (eg 1024, 2048...) 
should solve the issue.


OOM - Out of memory (GPU)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On GPU, you might run into memory problems. This is both linked to the batch 
size and the size of the images. The batch size is straightforward to change, 
lower the value at the beginning of the :ref:`training scripts <training_scripts>`.
Note that lower batch sizes may mean slower training convergence or lower 
performance overall.

The other solution would be to use a smaller image target size. However if the 
original training images and masks are for example 512×512, downsizing them to 
256×256 will reduce the memory footprint, but it might cause some borders 
between cells in the binary masks to disappear. Instead, training images should
be resized upstream of DeLTA to make sure that your training set does feature 
cell-to-cell borders in the segmentation masks.

Another reason why this may happen is that the pipeline is trying to feed too 
many samples to the U-Nets at once. Try lowering pipeline_seg_batch and 
pipeline_track_batch in your JSON config file.

.. _recent_installs::

Recent installations library versions
-------------------------------------

Here is a list of installations that have worked for us on various systems
in case you run into dependency issues:

:doc:`Successful installations <installs_lists>`



    
