#!/bin/tcsh -f

# An example of filtering and calculating some RSFC components as part
# of a last step in resting state processing (things like tissue
# regression, smoothing and detrending have been done already, so they
# are not done here, but one can). As noted in the 3dRSFC helpfile,
# the program mainly a wrapper around the existing 3dBandpass program
# (by R. Cox), with extra functionality added. Since some RSFC
# parameters include both pre- and post-bandpassing information (e.g.,
# fALFF), these procedures were joined together into one program.

# Here, the input data set is in FMRI-native space; it could also have
# been mapped to DWI space before processing if that's useful.

# Produced data sets contain: LFFs (i.e., the filtered time series,
# here containing frequencies between 0.01-0.1 Hz), ALFF, fALFF,
# mALFF, RSFA, fRSFA, and mRSFA.  See 3dRSFC description/helpfile for
# more description if these aren't familiar quantities.

# Also, note that in the nice script-producing producing program in
# AFNI, 'afni_proc.py' by R. Reynolds, one can include a
# '-regress_RSFC' option to do this filtering and RSFC parameter
# calculation in that pipeline.  Please see the 'afni_proc.py' help
# file, and particularly Example 10b, to read more about this.

3dRSFC                          \
    -nodetrend                  \
    -prefix FMRI/REST_filt      \
    0.01 0.1                    \
    REST_proc_unfilt.nii.gz     \
    -overwrite
