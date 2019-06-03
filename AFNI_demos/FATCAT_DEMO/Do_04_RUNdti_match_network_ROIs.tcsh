#!/bin/tcsh -f

# A simple example of matching ICA-derived network maps with known or
# `standard' reference ones.  Here, the reference data is a set of 20
# ICs obtained from the 1000+ RS-FMRI sets of the Functional
# Connectome Project (Biswal et al. 2000, PNAS).

# The reference MULTISITE* set has been (just linearly) mapped from
# MNI standard to the DWI native space of this subject.  There are 20
# ICs in the reference set and 4 ICs in the subject example
# set. Outputs are:
#    + a rearranged set of the subject ICs, to put the corresponding
#      `best' match (as determined with Pearson correlation of
#      flattened spatial Z-score maps) per reference IC (PREFIX_REF*)
#    + a rearranged set of reference ICs, to put the corresponding
#      `best' match per subject IC (PREFIX_IN*)
#    + a text file recording the reordering of brick files as well as
#      the Pearson correlations and Dice coefficients of similarity
#      (two *.vals)
#
#    (The way I remember which output goes with which input is: 
#        the *REF*-named output overlays on the 'ref'set, 
#        and 
#        the *IN*-named output overlays on the 'in'set.)

# Here, thresholding of maps, inset values >1 and refset values >3,
# was used just for the Dice evaluation ('-only_dice_thr').

3dMatch                                \
    -inset SOME_ICA_NETS_in_DWI+orig   \
    -refset MULTISITE_in_DWI+orig      \
    -in_min 1.0                        \
    -ref_min 3                         \
    -only_dice_thr                     \
    -prefix MATCHED                    \
    -overwrite

    
