#!/bin/tcsh -f

# In preparation for doing mini- and full-probabilistic tractography,
# the uncertainty of relevant tracking parameters (GFA and directions)
# need to be estimated. In FATCAT, this is done using jackknife
# resampling over a number of iterations.

# *HOWEVER*, since there is currently no HARDI modeler in AFNI,
# there's also no 'official' uncertainty estimator program.  I can
# imagine that in models with ODFs, one could do good approximations
# of voxelwise uncertainty per direction, at least.  

# For the time being, the current method described here is a
# patch/*very* rough estimate.  For now, it's a constant cone of
# uncertainty for each possible directional vector, and a constant
# uncertainty for GFA.  Perhaps a better model could be based on the
# DTI uncertainties, but for the moment, this is one simple idea.

# Other models calculated in other programs are certainly welcome; I
# probably will try to do something with ODFs at some
# point. Discussion (or better, contribution!) is welcome.

# Not much else to be said about this. Just the script.  

# We need a four-brik uncertainty set: [0] for GFA, and [1..3] for the
# three directional vectors of this HARDI set.

# logic being: in DTI, FA is thresholded at 0.2 and has minimum uncert
# of 0.015, so going for similar ratio here based on GQI-GFA threshold
# being used. (0.04/0.2)*0.015~0.003.
3dcalc -a mask_DWI+orig -expr 'a*(0.04/0.2)*0.015' \
    -prefix TEMP_GQI_01.nii.gz                     \
    -overwrite

# and then a bit of increasing uncertainty for each of the directions:
# 3deg, 4deg, 5deg.
3dcalc -a mask_DWI+orig -expr 'a*3*(3.14159/180)' \
    -prefix TEMP_GQI_02.nii.gz                    \
    -overwrite
3dcalc -a mask_DWI+orig -expr 'a*4*(3.14159/180)' \
    -prefix TEMP_GQI_03.nii.gz                    \
    -overwrite
3dcalc -a mask_DWI+orig -expr 'a*5*(3.14159/180)' \
    -prefix TEMP_GQI_04.nii.gz                    \
    -overwrite

3dTcat \
    -prefix HARDI/Simple_Uncert.nii.gz  \
    TEMP_GQI_??.nii.gz                  \
    -overwrite

# get rid of the evidence...
\rm -f TEMP_GQI_??.nii.gz
