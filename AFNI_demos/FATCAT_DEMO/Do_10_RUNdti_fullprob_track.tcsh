#!/bin/tcsh -f

# Do some probabilistic tractography, using networks of ROIs derived
# from RS-FMRI and DTI data/uncertainty.  There are a few different
# options for outputs and things, so good to look through helpfile.
# This uses outputs of 3dDWItoDT, 3dROIMaker and 3dDWUncert.

# This program will: 

# Treat each '-netrois' brik as a network of ROIs, each ROI labelled
# by a distinct integer.

# It uses the previous uncertainty estimates to perturb the DTI
# parameters for each run of wholebrain tractography of this Monte
# Carlo simulation; the number of iterations and 'seeds' per voxel per
# iteration is defined by the user (defaults: 5 seeds per voxel and
# 1000 iterations).

# In addition to the standard FACTID parameters of tract propagation
# (min FA, max turning angle, min tract length), there is also an
# algorithm option for determining if a voxel has had enough tracts
# run through it to be included in the WM-ROI for a given connection.
# It's defined as a decimal times: (the number of iterations) x (the
# total number of seeds per voxel per iteration).  Thus, if you have
# 200 iterations and 5 seeds/vox/iter, then an option value of 0.001
# would require just 0.001*200*5=1 tract through a voxel to include it
# as part of a 'WM region' connecting two network ROIs. (NB: the
# tract-threshold number is floored at 1, so you can't undershoot
# that.) (Another NB: sometimes the rounding of floating point
# multiplication can be a bit funny, so you might set your fraction
# value to something like 0.0011 if it's not what you want,
# precisely.)

# The example here has a small number of total iterations, probably
# less than a desired value in actual analysis (consider the default
# values as being a better starting point for more serious
# running). The algopt file used here is the 'plain text' variety,
# just a column of numbers, which for the PROB mode represent:
# alg_Thresh_FA, alg_Thresh_ANG, alg_Thresh_Len, 
# alg_Thresh_Frac, alg_Nseed_Vox and alg_Nmonte.

# NB: we also keep track of the voxels through which tracks go that
# just go through a single ROI, because we can (that's the *INDIMAP*
# output).

# As usual for pairwise connections, trimming of tracks is done
# automatically-- the strands of tracks that aren't between two
# targets get left off (if you really want, this setting can be turned
# off, but probably that would be for very few cases...). NB: tracts
# which only go through a single target ROI aren't trimmed, so one
# still gets a 'broad' view of target-associated WM, anyways. For a
# discussion of the '-dump_rois' option, see the 3dTrackID helpfile,
# or the post-run reading, below.

set uncfile = `ls DTI/o.UNCERT*HEAD`

time 3dTrackID -mode PROB                \
    -netrois ROI_ICMAP_GMI+orig          \
    -uncert "${uncfile[1]}"    \
    -dti_in DTI/DT                       \
    -mask mask_DWI+orig                  \
    -algopt ALGOPTS_PROB.dat             \
    -dump_rois AFNI                      \
    -prefix DTI/o.PR                     \
    -overwrite           -echo_edu

# SOME READING FOR AFTER RUNNING:

# There were four networks input, so there will be 4 sets of files
# output.  In this case, ones associated with brik [0]:
#          o.PR_000.grid
#          o.PR_000_INDIMAP+orig.
#          o.PR_000_PAIRMAP+orig.,
#          ....
# and so on for networks defined in the [1], [2] and [3] briks.

# At the top of *.grid, is the number, N_roi, of ROIs in the network.
# Then there is the number of matrices in the file: a fixed number
# (three: two forms of counting the number of tracks between targets,
# and the number of voxels per WM ROI) plus 2x however many parameter
# files have been read in (for each parameter, a matrix of means and
# of standard deviations).

# Then there are several N_roi x N_roi matrices of numbers of numbers.
# Each matrix is labeled: 'FA' is for the mean fractional anisotropy,
# and 'sFA' is for its standard deviation.

# For example, the first matrix is the integer number of tracks
# connecting any given pair of target ROIs, counting along columns
# 1..N_roi and along rows 1..N_roi. Thus, diagonal elements are just
# for tracks that went through at least one target ROI; matrix element
# (3,2) is for tracks which connected target-3 and target-2.  If there
# were no tracks (or not enough, based on the set threshold)
# connecting them, then the value is a 0.

# The *INDIMAP* file has N_roi+1 bricks.  Brick [0] shows voxels where
# more tracks than the threshold value passed through for any
# individual hit or connection of any ROI in that network.  Brick [1]
# shows voxels where more tracks than the threshold value passed
# through for all individual hits or connections through target
# ROI-1. For Brick [2], all voxels related to tracks for target ROI
# [2]... up to Brick [N_roi]. The values at each voxel are the number
# of tracks passing through.

# The *PAIRMAP* file also has N_roi+1 bricks.  Brick [0] is a binary
# map and shows voxels where more CONNECTING tracks than the threshold
# value passed through for *any* pair of targets in that
# network. Brick [1] shows voxels where a suprathreshold number of
# tracks connected target ROI-1 to ROI-2 or to ROI-3... or to
# ROI-N_roi. You can tell which it connected to because the voxel
# value will be 2^i for a track connecting target ROI-1 and ROI-i.  If
# a voxel had tracks passing through which connected ROI-1 to ROI-2
# and ROI-1 to ROI-4, then the value would be 2^2+2^4=20.  This may
# seem odd, but it provides a unique decomposition of identifiers.

# **Now, if this PAIRMAP output system seems odd and really difficult
# to use in practice, you can also use the handy '-dump_rois {TYPE}'
# option and dump out a bunch of individual masks for each ROI
# connection (the type could be in AFNI-file format or as something
# that looks like a 3dmaskdump output); for this option, please see
# the 3dTrackID helpfile.  My thought in the original output was: ease
# of viewing; but probably to *use* the WM-regions for other things,
# you will want to dump the found WM-ROIs (they go into their own
# directory, and don't really take up that much space).

# For fun, you can compare the relative 'volumes' of outputs from DET,
# MINIP and PROB mode, for the AND-logic connections. Even with just
# 200 probabilistic iterations (and a pretty low treshold of having
# just a few tracts pass through a voxel to include it in an ROI),
# this shows some of the difference between deterministic and
# probabilistic tractography.  Most likely, a comparison will provide
# some evidence bit about why the latter is much preferred, both for
# theoretical reasons, like we know that we have imperfect measures
# and therefore imperfect tensors/parameters guiding simple
# algorithms, and for heuristic evidence based on experience with data
# like this.  Certainly, neither method is perfect, and it seems like
# both might be prone to 'false negatives' -- missing out on
# physiologically present fibers.  That is why it is probably a good
# idea to set a pretty low threshold for keeping voxels. And also, one
# might want to look at HARDI methods...
