#!/bin/tcsh -f

# Simple examples of performing deterministic ('-mode DET')
# tractography. 

# Note that one can analyze networks of target ROIs simultaneously,
# with each network defined as a separate brik. Within each network,
# each ROI is the set of voxels with a given integer >0; anti-targets
# or NOT-regions (where tracts dare not propagate) can be defined with
# voxel values <0.

# Several files get output, some as track-like info and some as
# standard AFNI brik files. The user defines a prefix for naming, and
# then there will be further naming of 'which network' it is, since
# there can be multiple bricks; the number tacked onto the output
# prefix matches the '-netrois ROI' file brik from which it came.

# Required for DTI tracking are MD, FA and L1 files.  Default behavior
# is to search for other scalar (=single brik) files with the same
# input prefix, to include those for tracking stats (such as, here, L2
# and L3).

# There's a number of algorithm control parameters that one can set.
# See the '3dTrackID' help file for more info.  These can be: left as
# default; input one-by-one; input as a group in an '-algopts A_FILE'
# file. 


# A) Deterministic whole-brain tracking; set of targets is just the
#    volume mask. This can be useful for diagnostic purposes, sanity
#    check for gradients+data, for interactively selecting interesting
#    subsets later, etc. This uses most of the default algopts, but
#    sets a higher minimum length for keeping tracks:
printf "\n\nA) WHOLE BRAIN TRACKING:\n"
3dTrackID -mode DET                   \
    -dti_in DTI/DT                    \
    -netrois mask_DWI+orig            \
    -logic OR                         \
    -alg_Thresh_Len 30                \
    -prefix DTI/o.WB                  \
    -overwrite             -echo_edu  

# A.1) And do the same using the gradient directions without 
#the proper flipping option.
printf "\n\nA) WRONG DIRECTIONS, WHOLE BRAIN TRACKING:\n"
3dTrackID -mode DET                   \
    -dti_in DTI.bad/DT                \
    -netrois mask_DWI+orig            \
    -logic OR                         \
    -alg_Thresh_Len 30                \
    -prefix DTI.bad/o.WB.bad              \
    -overwrite             -echo_edu  


# B) Track through the 3dROIMaker-produced networks, AND logic.
#    And, for interest, output the six main tracking parameters that
#    could be set in an '-algopt' file (in nice NIML format).
printf "\n\nB) AND-logic TRACKING (4 networks):"
3dTrackID -mode DET                   \
    -dti_in DTI/DT                    \
    -netrois "ROI_ICMAP_GMI+orig"     \
    -logic AND                        \
    -prefix DTI/o.NETS_AND            \
    -write_opts                       \
    -overwrite             -echo_edu  


# B) Track through the 3dROIMaker-produced networks, OR logic.
#    Also reading the nicely-formatted '-algopt' file, which in this
#    case mostly changes the numbers of seeds/vox to 1x1x1=1.
#    Also, just for fun, the search feature for extra scalars is
#    turned off.
printf "\n\nC) OR-logic TRACKING (4 networks):\n"
3dTrackID -mode DET                   \
    -dti_in DTI/DT                    \
    -netrois "ROI_ICMAP_GMI+orig"     \
    -logic OR                         \
    -dti_search_NO                    \
    -algopt ALGOPTS_DET.niml.opts     \
    -prefix DTI/o.NETS_OR             \
    -overwrite             -echo_edu  


# C) For visualization, create surface contours of the ROIs
foreach net (0 1 2 3)
   IsoSurface -isocmask "-a ROI_ICMAP_GM+orig[${net}] -expr (step(a))" \
              -input ROI_ICMAP_GM+orig"[${net}]"  -overwrite           \
              -o_gii Net_00${net}.gii
   ConvertSurface -flip_orient -overwrite -i Net_00${net}.gii -o Net_00${net}.gii
   quickspec -overwrite -tn GIFTI Net_00${net}.gii -spec Net_00${net}.spec
   3dVol2Surf  -spec Net_00${net}.spec -grid_parent ROI_ICMAP_GMI+orig.        \
               -sv mprage+orig. -surf_A Net_00${net}.gii -use_norms -overwrite \
               -f_p1_fr -1 -f_pn_fr 1 -map_func max                            \
               -out_niml Net_00${net}.cols.niml.dset
   \rm -f Net_00${net}.spec
end
