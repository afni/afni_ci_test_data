#!/bin/tcsh -f

# Standard calculation of diffusion tensors (DTs) and associated
# parameters using existing 3dDWtoDTI by D. Glen.

# Output DTI directory has already been made.

# Grad file has already been made using 1dDW_Grad_o_Mat

# Make use of a brain mask, output eigenvalues, eigenvectors, DTs and
# parameters in separate files.  Use nonlinear fitting to estimate
# DTs (think that's the default, anyways).

# Gradient file and b0+DWIs are given.

3dDWItoDT -echo_edu                  \
    -prefix DTI/DT                   \
    -mask mask_DWI+orig              \
    -eigs -sep_dsets -nonlinear      \
    GRADS_30.dat                     \
    AVEB0_DWI.nii.gz                 \
    -overwrite

#And use the version without the Y flipping to illustrate how
#incorrect gradient flipping options manifest themselves
#in whole brain tractography
if ( ! -d DTI.bad ) mkdir DTI.bad
3dDWItoDT -echo_edu                  \
    -prefix DTI.bad/DT               \
    -mask mask_DWI+orig              \
    -eigs -sep_dsets -nonlinear      \
    GRADS_30.bad.dat                 \
    AVEB0_DWI.nii.gz                 \
    -overwrite
