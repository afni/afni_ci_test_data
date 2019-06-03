#!/bin/tcsh -f

# Calculate the correlation matrices of networks of (presumably GM)
# ROIs

# One can do this simultaneously with multiple networks defined as
# sub-bricks.  Such is done in this example, using the GM network
# outputs of 3dROIMaker. Note: here we will use the *non-inflated*
# outputs of that program, the *GM_*; the inflated ones, *GMI*, were
# more useful for linking functional results with tractography.

# In this example the switch to output Fisher Z-score values, in
# addition to the Pearson correlation 'r', in the *netcc text file is
# utilized.

# Each output *.netcc text file contains: 
#    + the number of ROIs (with some #-padding & description)
#    + the number of matrices (with some #-padding & description)
#    + the labels of the ROIS (which need not be consecutive)
#    + Pearson correlation matrix (parameter label: 'CC')
#    + (if '-fish_z') Fisher z-transform correlation matrix ('FZ')
# Essentially, it's the same format as the *.grid files output by the 
# tractography program, 3dTrackID

# As usual, multi-brik files can be entered, each representing a
# different network.  In the output, the prefix will have the number
# of the network glued on, so that PREFIX_000* goes with network/brik
# [0], PREFIX_001* goes with network/brik [1], etc.

# In this example, four *.netcc text files will be output, since
#    there are four networks (subbricks in the -in_rois FILE)

3dNetCorr                                       \
    -inset REST_in_DWI.nii.gz                   \
    -in_rois ROI_ICMAP_GM+orig                  \
    -fish_z                                     \
    -prefix FMRI/REST_corr_rz                   \
    -overwrite                 -echo_edu

