#!/bin/tcsh -f

# (For more mini-probbing info, see Do_08*dti*.tcsh first!)

# This is a mini-probabilistic tracking example for a HARDI model and
# the (currently) very simple uncertainty file.

# Previously, in Do_05*hardi*.tcsh, we looked at AND-logic connections
# among the four networks of interest. Let's do a few iterations in
# MINIP mode, and compare results.

3dTrackID -mode MINIP                     \
    -hardi_gfa HARDI/GQI_GFA.nii.gz       \
    -hardi_dirs HARDI/GQI_DIRS.nii.gz     \
    -netrois "ROI_ICMAP_GMI+orig"         \
    -logic AND                            \
    -mini_num 5                           \
    -uncert HARDI/Simple_Uncert.nii.gz    \
    -unc_min_FA 0.0015                    \
    -alg_Thresh_FA 0.04                   \
    -prefix HARDI/o.NETS_AND_MINIP_HAR    \
    -write_opts                           \
    -overwrite             -echo_edu  
