#!/bin/tcsh -f

# Simple examples of performing deterministic ('-mode DET')
# tractography, for HARDI data (assumes previous viewing of
# Do_05*dti.tcsh for DTI tracking. Here, DSI-Studio's GQI model was
# used for reconstructing the same DWI/DTI data collected, with up to
# 3 directions per voxel.  The Do*tcsh file for *that* reconstruction
# and conversion to NIFTI files in DSI-Studio is located in this
# directory, in case you are interested.  It also includes
# instructions for a QBall reconstruction (no charge!).

# HARDI deterministic tracking considerations are preeetty similar to
# those for DTI.  We'll mirror most of the DTI examples.  Note that
# the GFA values tend to be a lot smaller than the FA values, so the
# threshold we're using here is 0.04.

# A) Deterministic whole-brain tracking; set of targets is just the
#    volume mask. This can be useful for diagnostic purposes, sanity
#    check for gradients+data, for interactively selecting interesting
#    subsets later, etc. This uses most of the default algopts, but
#    sets a higher minimum length for keeping tracks:
printf "\n\nA) WHOLE BRAIN TRACKING:\n"
3dTrackID -mode DET                      \
    -hardi_gfa HARDI/GQI_GFA.nii.gz      \
    -hardi_dirs HARDI/GQI_DIRS.nii.gz    \
    -netrois mask_DWI+orig               \
    -logic OR                            \
    -alg_Thresh_FA 0.04                  \
    -alg_Thresh_Len 30                   \
    -prefix HARDI/o.WB_HAR               \
    -overwrite             -echo_edu  


# B) Track through the 3dROIMaker-produced networks, AND logic.
#    And, for interest, output the six main tracking parameters that
#    could be set in an '-algopt' file (in nice NIML format).
#    This will search for scalar files with the prefix given after 
#    '-hardi_pars'-- note that since both the GFA file and '-hardi_pars'
#    files have the same prefix, there will be a repeated matrix in the
#    grid files.  Not a huge deal, but something to consider when naming
#    files.
printf "\n\nB) AND-logic TRACKING (4 networks):"
3dTrackID -mode DET                       \
    -hardi_gfa HARDI/GQI_GFA.nii.gz       \
    -hardi_dirs HARDI/GQI_DIRS.nii.gz     \
    -hardi_pars HARDI/GQI                 \
    -netrois "ROI_ICMAP_GMI+orig"         \
    -logic AND                            \
    -alg_Thresh_FA 0.04                   \
    -prefix HARDI/o.NETS_AND_HAR          \
    -write_opts                           \
    -overwrite             -echo_edu  


# B) Track through the 3dROIMaker-produced networks, OR logic.  
#    Setting the numbers of seeds/vox to 1x1x1=1.
printf "\n\nC) OR-logic TRACKING (4 networks):\n"
3dTrackID -mode DET                       \
    -hardi_gfa HARDI/GQI_GFA.nii.gz       \
    -hardi_dirs HARDI/GQI_DIRS.nii.gz     \
    -netrois "ROI_ICMAP_GMI+orig"         \
    -logic OR                             \
    -alg_Thresh_FA 0.04                   \
    -alg_Nseed_X 1                        \
    -alg_Nseed_Y 1                        \
    -alg_Nseed_Z 1                        \
    -prefix HARDI/o.NETS_OR_HAR           \
    -overwrite             -echo_edu  


