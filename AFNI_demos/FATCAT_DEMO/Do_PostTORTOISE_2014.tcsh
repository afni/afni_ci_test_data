#!/bin/tcsh -xef

# Here, we'll go from the DWI + (TORTOISE-style) B-matrix information
# to do tensor reconstruction and tracking.

# For the Sept, 2014 NIH Bootcamp:
# these commands can be run in the TORTOISE-processed demo data set
# (AFNI_bootcamp_TORTOISE_tutorial_data.tar.gz) in the following
# directory--
# TORTOISE_tutorial_2014/DR-BUDDI_example/final/dti_35vol_AP_scan1_up_bupdown_DMC_L0_SAVE_AFNI/

# *******************************************************************


# slightly more svelte brain mask
3dAutomask                                  \
    -prefix mask2.nii.gz                    \
    INPREF_MD.nii                           \
    -overwrite

# We could convert the TORTOISE-style B-matrix to either AFNI-style
# one or to grads (see "1dDW_Grad_o_Mat" help for more about style
# differences); here, I'll opt for 3 columns of gradient components,
# and we won't need to keep the single row of zeros at the top (i.e.,
# don't need to turn on a switch to keep it-- 3dDWItoDT expects b=0
# data in the first DWI brick, and no row of zeros in the grad file
# for it).
# 
# We will also need to check if one of the grads needs to be flipped
# at all-- only way for sure I know to check this is to process
# through to whole brain tracking and see that it looks ok (checking
# through corpus callosum and cingulate bundles seems good procedure).
# -> after first attempt with no flip, I saw that the CC was pretty
# empty in the middle, probably falsely so, so I invoked a -flip_z...
1dDW_Grad_o_Mat                             \
    -in_bmatT_cols BMTXT.txt                \
    -out_grad_cols GRADS.txt                \
    -flip_z

# tensor reconstruction-- sep_dsets is useful here; nonlinear is
# default anyways.
3dDWItoDT -nonlinear -eigs -sep_dsets       \
    -mask mask2.nii.gz                      \
    -prefix DT                              \
    GRADS.txt                               \
    DWI.nii                                 \
    -overwrite

# simple deterministic, WB tracking; just use 1 seed per vox for speed
3dTrackID -mode DET                         \
    -mask mask2.nii.gz                      \
    -netrois mask2.nii.gz                   \
    -logic OR                               \
    -prefix o.WB                            \
    -dti_in DT                              \
    -alg_Nseed_X 1                          \
    -alg_Nseed_Y 1                          \
    -alg_Nseed_Z 1                          \
    -overwrite

# view it-- looks lovely!
suma -tract o.WB_000.niml.tract 

# *******************************************************************

# and now a probabilistic example:

# First, we need to estimate uncertainty of a few key DT parameters
# that are used in tracking.  Below a *very* small number of
# iterations is used, just for the sake of brevity.
3dDWUncert                                 \
    -grads GRADS.txt                       \
    -inset DWI.nii                         \
    -input DT                              \
    -mask mask2.nii.gz                     \
    -prefix o.UNC                          \
    -iters 10                              \
    -overwrite

# a really simple mini-probabilistic procedure.
3dTrackID -mode MINIP                       \
    -mask mask2.nii.gz                      \
    -netrois mask2.nii.gz                   \
    -logic OR                               \
    -prefix o.WB_MP                         \
    -dti_in DT                              \
    -uncert o.UNC_UNC+orig                  \
    -mini_num 5                             \
    -alg_Nseed_X 1                          \
    -alg_Nseed_Y 1                          \
    -alg_Nseed_Z 1                          \
    -overwrite

# View it!
suma -tract o.WB_000.niml.tract 
