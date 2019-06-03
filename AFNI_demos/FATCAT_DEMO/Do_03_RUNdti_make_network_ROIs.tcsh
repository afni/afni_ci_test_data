#!/bin/tcsh -f

# Read in the inset, which here has 4 briks, each a resting state
# network (RSN) from FSL-melodic ICA output; voxel values are
# Z-scores.

# Apply a value threshold of 3.0, creating islands of high
# Z-scores. Apply a volume threshold of 130 voxels to the islands
# which are formed. Then, each ROI gets inflated by 2 voxels
# (unless... see next paragraph).

# Read in another data set to play the role of defining a 'skeleton'
# of white matter (WM). Here, we use the aforefashioned FA map,
# defining the 'WM' to be anything with FA>0.2.  Importantly, we also
# ask the ROI inflation to stop after hitting this newly-defined WM,
# so that ROIs don't artificially expand unreasonably into WM. We're
# just trying to the to-be-tractographic-target-ROIs to touch/barely
# overlap with WM-- a goal is to not have them expand 'too much' to be
# hitting far away WM.

# Use a brain mask so inflated ROIs don't stick out. Output the 4-brik
# ROI maps (both inflated *GM* and non-inflated *GMI*) in the current
# directory.

3dROIMaker -echo_edu                          \
    -inset SOME_ICA_NETS_in_DWI+orig          \
    -thresh 3.0                               \
    -volthr 130                               \
    -inflate 2                                \
    -wm_skel DTI/DT_FA+orig.                  \
    -skel_thr 0.2                             \
    -skel_stop                                \
    -mask mask_DWI+orig                       \
    -prefix ./ROI_ICMAP                       \
    -overwrite
    
