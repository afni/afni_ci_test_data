#!/bin/tcsh -f

# Calculate ReHo of the LFF time series-- the Kendall Coefficient of
# Concordance (KCC, or Kendall's W) of a neighborhood of time series.

# Three examples are given here, based on different possibilities of
# 'neighborhood' definition:
#    A): for each voxel, take face-, edge- and corner-wise neighbors, for
#        a total of 27 voxels
#    B): ellipsoidal shape of 'hood, defined by desired number of voxels
#        each semi-axis (this could be useful for non-isotropic voxels, for
#        instance, even though the sample set voxels here are isotropic)
#    C): calculate ReHo of networks of arbitrarily shaped ROIs via labelled
#        masks-- the input time series is the un-LFF-bandpassed time series
#        that had been mapped to DWI space (same space as the 3dROIMaker'ed
#        networks)

# also, chi_sq values are chosen to be output here as well.

# Case A, default
3dReHo                                      \
    -inset FMRI/REST_filt_LFF+orig          \
    -prefix FMRI/REST_REHO_N27              \
    -chi_sq                                 \
    -overwrite

# Case B
3dReHo                                      \
    -inset FMRI/REST_filt_LFF+orig          \
    -neigh_X 3                              \
    -neigh_Y 4                              \
    -neigh_Z 2                              \
    -prefix FMRI/REST_REHO_ELL              \
    -chi_sq                                 \
    -overwrite

# Case C-- NB: a map of `case A' values is also calculated by default.
#    The ROI network values are output in *.vals and *.chi text files,
#    one network per line (in order of subbrick).
3dReHo                                      \
    -inset REST_in_DWI.nii.gz               \
    -mask mask_DWI+orig                     \
    -in_rois ROI_ICMAP_GM+orig              \
    -prefix FMRI/REST_in_DWI_REHO_ROI       \
    -overwrite



