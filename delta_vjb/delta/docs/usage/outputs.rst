Output files
=================

By default, the :doc:`pipeline <pipeline_desc>` will save 3 files per processed
position: A pickle file that can be used to reload the corresponding `Position`
object, a "legacy" Matlab MAT file that contains the main output data of the 
`Position` object (ie, :ref:`Lineage objects <lineage>`, label stacks, and 
other parameters relevant to data analysis), and an MP4 movie file to quickly
check the quality of the segmentation and tracking.

Pickle file
------------
The :doc:`Position class <../_generated/delta.pipeline.Position>` 
objects can be saved as pickle files. This means that all 
information about the position can be retrieved and further processed, and the 
underlying :ref:`Lineage class <lineage>` objects can be used for data analysis.

You can reload the pickle file for any position with the following::

    pos = delta.pipeline.Position(None,None,None)
    pos.load('/path/to/PositionXXXXXX.pkl')

or::

    pos = delta.pipeline.load_position('/path/to/PositionXXXXXX.pkl')

Although this will not allow you to have access to the corresponding 
experimental images and to run most processing operations. You can set the
necessary attributes with e.g.::

    reader = delta.utilities.xpreader('/path/to/file/or/folder')
    pos = delta.pipeline.Position(
        position_nb=5,
        reader=reader,
        models=delta.utils.load_models(),
        drift_correction=delta.config.drift_correction,
        crop_windows=delta.config.crop_windows
        )
    pos.load('/path/to/PositionXXXXXX.pkl')

Alternatively, you can reload all positions in an experiment with::

    reader = delta.utilities.xpreader('/path/to/file/or/folder')
    processor = delta.pipeline.Pipeline(
        reader,
        resfolder='/path/to/results/folder'
        reload=True
        )

Beware however that, for large movies, you might run into memory
issues if you try to reload all positions at once. Another way to do it to
avoid this problem can be::

    reader = delta.utilities.xpreader('/path/to/file/or/folder')
    processor = delta.pipeline.Pipeline(reader)
    
    # Load single position:
    processor.positions[6].load('/path/to/Position000006.pkl')
    
    # Do something, for example:
    import matplotlib.pyplot as plt
    plt.plot(
        processor.positions[6].rois[0].lineage.cells[0]['frames'],
        processor.positions[6].rois[0].lineage.cells[0]['length']
        )
    
    # Remove data from memory once you're done:
    processor.positions[6].clear()

Check the :ref:`Lineage class <lineage>` description for more information on
how to access single-cell extracted features.


MAT file
---------
The Matlab MAT file can be loaded in Matlab of course but also in python::

    delta_result = scipy.io.loadmat('PositionXXXXXX.mat',simplify_cells=True)

The data structure is presented as if loaded in python here. The structure is
generally the same if the MAT file is loaded in Matlab. The following
equivalencies can be used for data structures:

* float32 <=> single
* dict <=> struct
* list <=> cell

Because this was originally written for Matlab only, the data structure is not optimal
for python, especially when it comes to indexing: A lot of elements use 1-based
indexing when python indexing is usually 0-based. We try to be as clear as 
possible about these cases here. The notes about 0-based & 1-based indexing can
generally be ignored if the data is loaded in Matlab.

For each position, the data structure is as follows:

.. code-block:: text

    delta_result : dict
    DeLTA data loaded from the MAT file.
    Fields:
    |
    |
    |---moviedimensions : 1D array of int
    |       Dimensions of the experiment movie stored as [Y, X, Channels, 
    |       timepoints].
    |
    |---tiffile : str
    |       Path to the original experiment file. Can be a tif file, nd2, czi, oib
    |       or other Bio-formats files, or a folder with an image sequence.
    |
    |---proc : dict
    |       Dictionary of data relevant to image preprocessing operations.
    |       Fields:
    |       |
    |       |---chambers : 2D array of float32
    |       |       Bounding box of detected chambers in the image, stored as
    |       |       [X top left corner, Y top left corner, width, height].
    |       |       Dimensions are chamber -by- 4.
    |       |
    |       |---rotation : float32
    |       |       Rotation angle to apply to get chambers horizontal, in degrees.
    |       |
    |       |---XYdrift : 2D array of float32
    |               Image drift estimated over time, stored as [Y, X]. Dimensions
    |               are timepoints -by- 2.
    |
    |---res : list of dict
            List of dictionaries containing data relevant to segmentation and 
            lineages for each chamber in the FOV.
            Fields:
            |
            |---labelsstack : 3D array of uint16
            |       Stack of images containing labelled segmentation masks. Each
            |       single cell is uniquely labelled. Labels use 1-based indexing:
            |       In python, Label L in the stack corresponds to cell #L-1 in the
            |       lineage list (see below). The dimensions are timepoints -by-
            |       U-Net size y -by- U-Net size x.
            |
            |---labelsstack_resized : 3D array of uint16
            |       Same as labelstack above, except it has been resized from the
            |       256 -by- 32 default dimensions of the U-Nets to the original
            |       dimensions of the chamber bounding box. Dimensions are
            |       timepoints -by- box_height -by- box_width
            |
            |---lineage: list of dict
                    Lineage information for all cells detected and tracked in the
                    chamber.
                    Fields:
                    |
                    |---area : 1D array of float32
                    |       Cell area over time, in pixels.
                    |
                    |---daughters : 1D array of float32
                    |       Daughter cells over time. 0 if no division happened at
                    |       timepoint, otherwise daughters are indexed with 1-based 
                    |       indexes: In python, daughter D corresponds to 
                    |       cell/item #D-1 in lineage list.
                    |
                    |---edges : array of str
                    |       Which edges of the ROI the cell is currently touching.
                    |
                    |---fluo1/fluo2/fluo3... : 1D array of float32
                    |       Mean fluorescence value over time.
                    |
                    |---frames : 1D array of float32
                    |       Frame numbers / timepoints where the cell is present. 
                    |       Frame numbers use 1-based indexing: In python, Frame
                    |       number F here corresponds to frame/timepoint #F-1 in
                    |       labelsstack for example.
                    |
                    |---length : 1D array of float32
                    |       Cell length over time, in pixels.
                    |
                    |---mother : int
                    |       Mother cell number for this cell. 0 if no mother
                    |       detected (eg first timepoint), 1-based indexing 
                    |       otherwise: In python, mother M is cell/item #M-1 in 
                    |       this lineage list.
                    |
                    |---new_pole : 2D array of float32
                    |       Position of the new pole of the cell, over time. 
                    |       Note that positions are given as (Y, X) vectors.
                    |       Dimensions are timepoints -by- 2.
                    |
                    |---old_pole : 2D array of float32
                    |       Position of the old pole of the cell, over time. 
                    |       Note that positions are given as (Y, X) vectors.
                    |       Dimensions are timepoints -by- 2.
                    |
                    |---perimeter : 1D array of float32
                    |       Perimeter of the cell, in number of pixels.
                    |
                    |---width : 1D array of float32
                            Cell width over time, in pixels.

MP4 movie file
------------------

This one is straight-forward: An MP4 movie file with h264 codecs is saved to
disk with the other save files for quick checking of outputs quality. The 
relevant functions that create and write the movie are
:doc:`results_movie <../_generated/delta.pipeline.Position.results_movie>`
and :doc:`vidwrite <../_generated/delta.utilities.vidwrite>`
