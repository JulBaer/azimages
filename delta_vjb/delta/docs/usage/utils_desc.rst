
Utilities module
=================

`Source <https://gitlab.com/dunloplab/delta/-/blob/master/delta/utilities.py>`_ | 
:doc:`API <../_generated/delta.utilities>` 

The utilities module contains many functions used in several different parts of 
the code. The most important elements are described below.


.. _xpreader:

The XPreader class
--------------------

The :doc:`xpreader class <../_generated/delta.utilities.xpreader>` is used to
read experiment files. This can either be 
`Bio-Formats <https://www.openmicroscopy.org/bio-formats/>`_ compatible files
such as the open format OME-TIFF, Nikon's .nd2 format, Olympus's .oib format,
Zeiss's .czi format and many more. Or it can be a folder containing separate 
image files for all positions, imaging channels, and timepoints.

In order to read Bio-Formats compatible files, please use the `use_bioformats`
flag::

    reader = delta.utilities.xpreader('/path/to/file.nd2', use_bioformats=True)

.. note::
    python-bioformats, the wrapper for the original java Bioformats library, 
    is maintained by the 
    `CellProfiler <https://github.com/CellProfiler/python-bioformats>`_ team 
    which they kindly make available to the community. While it has been 
    working flawlessly in our hands so far, they can not guarantee that it will
    always work for other applications than CellProfiler.

In order to read data from an experiment stored in a folder, the xpreader 
object can be called with 3 optional arguments that describe the structure of
the data under the folder:

* `prototype`: This argument describes the structure of the folder with a C-style / printf 
    formatted string. For example, if all image files are under the same 
    top-level folder with names such as `PositionXX_ChannelXX_FrameXXXXXX.tif` the
    prototype would be `Position%02d_Channel%02d_Frame%06d.tif. But sub-folders
    can also be part of the prototype, like `Channel%01d/Position%03d/IMG_%09d.tiff`.
* `fileorder`: Order of the 3 indexes in the prototype, `p` for 'Position',
    `c` for 'channel', and `t` for 'timepoint'. The order can be any combination
    of these three letters. 'p', 'ct', 'cpt', or 'pctcpt' would all work, if 
    the prototype has enough fields (and of course if the files actually exist).
    For example the last example could work with the absurd prototype:
    `Pos%03d_Channel%05d/Timepoint%07d/Chan_%02d/IMG_%09d.tif`
* `filenamesindexing`: Whether to start position, channel, and frames numbering
    from 0 or from 1 (ie, is the very first frame Pos00/Chan00/Time0000.tif or
    Pos01/Chan01/Time00001.tif?)

The following examples are all valid::

    reader = delta.utilities.xpreader(
        '/path/to/xpfolder/',
        prototype='Position%02d_Channel%01d_Time%03d.tif',
        fileorder='pct',
        filenamesindexing=1
        )

::

    reader = delta.utilities.xpreader(
        '/path/to/xpfolder/',
        prototype='Time%04d/Channel%06d.png',
        fileorder='tc',
        filenamesindexing=0
        )

::

    reader = delta.utilities.xpreader(
        '/path/to/xpfolder/',
        prototype='Channel%01d/Position%02d_Time%04d/IMG_%04d.tif',
        fileorder='cptt',
        filenamesindexing=1
        )

If the filenames do not in fact correspond to the prototype, fileorder, and 
indexing, the xpreader may still initialize without raising an exception. To
make sure it has identified files in the folder properly, check that the 
following properties are correct::

    reader.positions
    reader.channels
    reader.timepoints

.. note::
    The reader can not use channel names instead of channel numbers when resolving
    filenames. You can have files named 'Position02/Channel1/Frame001042.tif'
    and 'Position02/Channel2/Frame001042.tif' but you can not use names like 
    'Position02/Trans/Frame001042.tif' and 'Position02/GFP/Frame001042.tif'.
    
.. _lineage:

The Lineage class
-------------------

The main purpose of :doc:`Lineage objects <../_generated/delta.utilities.Lineage>`
is to maintain a list of dictionaries under the `cells` attribute that represent 
the lineage information 
and the extracted features data of each single cell within an :doc:`ROI <pipeline_desc>`.

A single-cell dictionnary will look like this::

    {
        'area': [159.5, 171.5, 186.0, 207.5, 239.5, 285.5, 149.0, 177.0, 196.5, 205.5, 218.0, 239.0],
        'daughters': [None, None, None, None, None, None, 45, None, None, None, None, None],
        'edges': ['', '', '', '', '', '', '', '', '', '', '', '+y'],
        'fluo1': [1287.149732620321, 1272.8308457711444, 1253.7706422018348, 1233.880658436214, 1230.1654676258993, 1229.4420731707316, 1236.4685714285715, 1222.2634146341463, 1289.4977973568282, 1392.6443514644352, 1472.1620553359685, 1483.358695652174],
        'frames': [79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90],
        'id': 41,
        'length': [21.0, 22.0, 26.34152603149414, 29.0, 32.245391845703125, 35.0, 19.0, 22.0, 24.0, 27.0, 29.0, 31.0],
        'mother': 39,
        'new_pole': [array([86, 11]), array([92, 11]), array([98, 11]), array([107,  11]), array([112,  11]), array([121,  11]), array([112,  11]), array([112,  11]), array([118,  10]), array([127,   9]), array([137,  10]), array([146,   8])],
        'old_pole': [array([77, 10]), array([81, 10]), array([83, 11]), array([87, 11]), array([91, 11]), array([95, 10]), array([104,  11]), array([121,  10]), array([131,  11]), array([141,   9]), array([153,   9]), array([168,   9])],
        'perimeter': [53, 57, 62, 69, 75, 83, 50, 54, 59, 65, 68, 72],
        'width': [8.0, 8.0, 8.713990211486816, 8.0, 9.531414031982422, 10.0, 9.0, 9.0, 9.0, 8.0, 8.0, 9.0]
     }

With the following *lineage-related* keys:

* `daughters`: The daughters this cell has produced at each timepoint
* `frames`: The movie frames where this cell is present
* `id`: The cell number in the lineage list (0-based indexing)
* `mother`: The cell that spawned this cell (None if unknown)
* `new_pole`: The position of the new pole of the cell over time. This is 
  the pole that was closer to the septum when division occured
* `old_pole`: The position of the old pole of the cell over time. This is 
  the pole that was further from the septum when division occured

And the following *extracted feature* keys:

* `area`: Total area of the cell, as computed by 
  :doc:`cell_area() <../_generated/delta.utilities.cell_area>`
* `edges`: Edges of the image touched by the cell, as computed by 
  :doc:`image_edges() <../_generated/delta.utilities.image_edges>`
* `fluoN`: Average fluorescence for channel #N of the cell, as computed by 
  :doc:`cell_fluo() <../_generated/delta.utilities.cell_fluo>`
* `length`: Cell length, as computed by 
  :doc:`cell_width_length() <../_generated/delta.utilities.cell_width_length>`
* `perimeter`: Cell perimeter, as computed by 
  :doc:`cell_perimeter() <../_generated/delta.utilities.cell_perimeter>`
* `width`: Cell width, as computed by 
  :doc:`cell_width_length() <../_generated/delta.utilities.cell_width_length>`

.. note::
    The extracted feature keys will depend on what features you have chosen to
    extract. By default they are all extracted. We may add more features in the
    future, but we will not touch the lineage information structure.

.. note::
    Old pole and new pole are assigned randomly for the cells present at the 
    beginning of the movie.

If you want to access a specific value in time for a specific cell, you can use 
the `getvalue()` method::

    timepoint=81
    key='fluo1'
    cell_nb=41
    value = lin.getvalue(cell_nb,timepoint,key)

Or you can change a value with setvalue::

    lin.setvalue(cell_nb,timepoint,key,1294.45)

We are currently working on methods that would allow to also re-assign lineage
information and propagate those changes to the rest of the lineage tree as part
of our effort to generate post-processing GUIs, but 
these methods are a work in progress and need to be extensively tested before
they can be used.

See also our :doc:`results analysis examples <analysis>`
