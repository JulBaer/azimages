
Results analysis
=================

Here are a few examples on how the data can be analyzed. These
examples are not necessarily interesting in their results
but they demonstrate various ways to analyze data from the output 
files. The MAT files can also be loaded and analyzed in Matlab,
and the general logic of the analysis would be the same
although there are some minor differences in how to index
arrays and cells (See :doc:`Output files <outputs>`)

2D results from .pkl file and Position/Lineage object
--------------------------------------------------------

First after running e.g. :ref:`run_pipeline.py <run_pipeline>`
on the 2D evaluation movie you can reload the data to memory
from the pickle file::

    reader = delta.utilities.xpreader(delta.config.eval_movie)
    processor = delta.pipeline.Pipeline(reader, reload=True)

.. note::
    There are many ways to reload the pickle file to memory. 
    See :doc:`output files <outputs>`

Then, for the first and only position, retrieve the lineage for 
the region of interest (ie the whole frame)::

    lin = processor.positions[0].rois[0].lineage

Check which cells are present in the first frame::

    first_cells = lin.cellnumbers[0]

Plot each cell's length over time, with different colors
for the first cells::
    
    import matplotlib.pyplot as plt

    for cell in lin.cells:
        if cell['id'] not in first_cells:
            plt.plot(cell['frames'],cell['length'],color=[.5,.5,.5])
    
    for cnb in first_cells:
        cell = lin.cells[cnb]
        plt.plot(cell['frames'],cell['length'])
    
    plt.xlabel('frame #')
    plt.ylabel('length (pixels)')
    plt.show()

You should get this:

.. image:: https://gitlab.com/dunloplab/delta/-/raw/images/cell_length_plot.png
    :alt: A plot of the imaged cell's length over time. The two initial cells are colored while others are gray.
    :align: center

You can also display which cells are descended from 
either of the first two cells on the last frame.

First define a function to retrieve which of the first two cells is the
ancestor::

    def which_first(lineage, cell_nb, first_cells):
        
        # Get cell dict:
        cell = lineage.cells[cell_nb]
        
        # If orphan or reached one of the first two cells:
        if cell['mother'] is None or cell['mother'] in first_cells:
            return cell['mother']
        
        # Otherwise go up the lineage tree:
        else:
            return which_first(lineage, cell['mother'], first_cells)

Then go over every cell of the last frame 
to reconstruct the image based on each cells' ancestry::

    import numpy as np

    # Last labels frame:
    labels = processor.positions[0].rois[0].label_stack[-1]

    # Initialize color image (all light gray)
    color_image = np.full(
        shape=labels.shape+(3,),
        fill_value=175,
        dtype=np.uint8
        )

    # Go over cells in last frame:
    for cnb in lin.cellnumbers[-1]:
        
        # Which initial cell is ancestor?
        ancestor = which_first(lin, cnb, first_cells)
        
        # Pick color based on ancestor:
        if ancestor is None:
            if cnb==0:
                color=[255,0,0]
            elif cnb==1:
                color=[0,0,255]
            else:
                color=[0,0,0]
        elif ancestor==0:
            color=[200,60,60]
        elif ancestor==1:
            color=[60,60,200]
        
        # Color in the cell:
        for c, val in enumerate(color):
            color_image[:,:,c][labels==cnb+1]=val

    plt.imshow(color_image)
    plt.show()

Which should give you something like:

.. image:: https://gitlab.com/dunloplab/delta/-/raw/images/ancestors_delta.png
    :alt: A colored representation of the last frame where cells are colored according to ancestry
    :align: center

Mother machine from MAT file
----------------------------------------------------------------

.. note::
    Here we are loading the MAT file in python. Because this 
    format is originally intended for Matlab, some indexes need
    to be decreased by 1 in a few places. The logic presented here
    is otherwise applicable to Matlab

Here we load the MAT file with scipy::

    from scipy.io import loadmat

    reloaded = loadmat('Position000002.mat',simplify_cells=True)

Then we can plot the fluorescence for the mother cell and its daugthers
in the sixth chamber::

    import matplotlib.pyplot as plt

    # Lineage of sixth chamber (index 5 in python)
    chamber = 5
    lin = reloaded['res'][chamber]['lineage']

    # Mother cell:
    mother = lin[0]

    # Plot daughters fluorescence:
    for daughter_nb in mother['daughters']:
        if daughter_nb > 0:
            daughter = lin[int(daughter_nb)-1] # No -1 in Matlab
            plt.plot(daughter['frames'],daughter['fluo1'],color=[.5,.5,.5])

    # Plot mother fluorescence:
    plt.plot(mother['frames'], mother['fluo1'])

    plt.xlabel('frame #')
    plt.ylabel('GFP (a.u.)')
    plt.show()

Which should give you:

.. image:: https://gitlab.com/dunloplab/delta/-/raw/images/cell_fluo_plot.png
    :alt: A plot of a mother's cell fluorescence over time (blue) and of its daughters (gray)
    :align: center

And we can also reconstruct the whole field of view and color cells based on 
their generation::

    import numpy as np
    import matplotlib.cm as cmap

    # Function to count number of generations:
    def generation(lineage, cell_nb):
        
        if lineage[cell_nb-1]['mother']==0: # No -1 in Matlab
            return 0
        else:
            return generation(lineage, lineage[cell_nb-1]['mother']) +1 # No -1 in Matlab


    frame = 100 # Some random frame
    imshape = tuple(reloaded['moviedimensions'][0:2])

    # Init colored image:
    color_image = np.full(
        shape = imshape + (3,),
        fill_value=255,
        dtype = np.uint8
        )

    # Colormap for the generations:
    colormap = cmap.get_cmap('plasma',lut=5)

    # Go over ROIs/chambers:
    for roi, roi_pos in zip(reloaded['res'],reloaded['proc']['chambers']):
        
        # Chamber lineage:
        lin = roi['lineage']
        
        # Labels image for frame:
        labels = roi['labelsstack_resized'][frame]
        
        # Cells present in frame:
        cells = np.unique(labels)[1:]
        
        # Go over each cell:
        for cell in cells:
            
            # Get generation and color:
            cell_gen = generation(lin, cell)
            color = colormap(cell_gen)
            
            # Draw cell:
            pixels = np.where(labels==cell)
            for c, val in enumerate(color[0:3]):
                color_image[
                    pixels[0]+int(roi_pos[1]),
                    pixels[1]+int(roi_pos[0]),
                    c
                    ]=val*255

    plt.imshow(color_image)
    plt.show()

Which should produce an image like this:

.. image:: https://gitlab.com/dunloplab/delta/-/raw/images/moma_generations.png
    :alt: Reconstructed mother machine colored image where cells are color-coded by generation
    :align: center
