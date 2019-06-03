#!/bin/tcsh -f

# (For more full-prob trackinging info, see Do_10*dti*.tcsh first!)

# This is a full-probabilistic tracking example for a HARDI model and
# the (currently) very simple uncertainty file.

3dTrackID -mode PROB                      \
    -hardi_gfa HARDI/GQI_GFA.nii.gz       \
    -hardi_dirs HARDI/GQI_DIRS.nii.gz     \
    -netrois "ROI_ICMAP_GMI+orig"         \
    -uncert HARDI/Simple_Uncert.nii.gz    \
    -unc_min_FA 0.0015                    \
    -alg_Thresh_FA 0.04                   \
    -alg_Thresh_Frac 0.011                \
    -alg_Nseed_Vox 5                      \
    -alg_Nmonte 40                        \
    -prefix HARDI/o.PR_HAR                \
    -write_opts                           \
    -overwrite             -echo_edu  
