#!/bin/tcsh -f

# In preparation for doing mini- and full-probabilistic tractography,
# the uncertainty of relevant DTI parameters (FA and e1) need to be
# estimated. In FATCAT, this is done using jackknife resampling over a
# number of iterations. 

# In this example, only a small number of iterations is used. You
# should probably do a couple hundred, at least.  Even so, it's
# generally not too terribly long of a calculation (unless you have a
# huge number of gradients). Make sure data is masked, though!

# Not much else to be said about this. Just the program.

time 3dDWUncert -echo_edu         \
    -inset AVEB0_DWI.nii.gz       \
    -prefix DTI/o.UNCERT          \
    -input DTI/DT                 \
    -grads GRADS_30.dat           \
    -iters 50                     \
    -overwrite


