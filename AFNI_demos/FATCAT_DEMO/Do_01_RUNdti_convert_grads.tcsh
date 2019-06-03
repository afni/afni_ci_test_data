#!/bin/tcsh -f


# Read in the b-vector file that was output by dcm2nii (here called
# simply 'bvec') when converting dicoms, and output a usable gradient
# file for 3dDWItoDT and 3dDWUncert.

# Fun things: the data was acquired as three repetitions of 3 b0s + 30
# grads with b=1000. Now, AVEB0_DWI.nii.gz was created by: averaging
# all nine b0s to form the first brik, and then averaging each of the
# three repeated DWIs to make the next thirty briks (which were
# concatenated in order).  Thus, we only effectively want to deal with
# only the first repetition of the scan and end up with 30 grads, with
# no b0s at the top of the grad file.

# Default behavior of 1dDW_Grad_o_Mat is to get rid of b0s-- so that's
# fine.

# We will use the handy AFNI 1d-file (which is really for any
# rectangular matrix shapes) to select only the 'first repetition' of
# 33 images from the input bvec file (that's the use of [square
# brackets], since it's a row-file).

# Bonus consideration: there's a fun scanner-conversion-toolbox
# interaction that means that oftentimes, one of the gradients needs
# to be 'flipped' (accomplished by multiplying one of the components
# by '-1'). The only way I know of finding out what needs to be done
# is by processing one data set through to whole brain tractography,
# and making sure the length of the corpus callosum looks nice (it
# won't show up in FA maps, it's something that affects the
# eigenvectors, and I haven't perfected the art of reading those for
# this effect). At least the effect is usually consistent on a given
# scanner. Having processed *this* data set, I know that it's in need
# of a y-flip, which is done here.

# Sidenote: due to the symmetries of the system/measures, any flipping
# any two components is equivalent to flipping the third.  That is, we
# could flip *either* solely the y-component here, *or* both the x-
# and z-components.  The signs of gradients would differ, but all
# tensor estimates and parameters would be the same.  Ok then.

# All that being noted, here we go:

1dDW_Grad_o_Mat                     \
    -in_grad_rows 'bvec[0..32]'     \
    -flip_y                         \
    -out_grad_cols GRADS_30.dat

#Create a version without the Y flipping to illustrate how
#incorrect gradient flipping options manifest themselves
#in whole brain tractography
1dDW_Grad_o_Mat                     \
    -in_grad_rows 'bvec[0..32]'     \
    -out_grad_cols GRADS_30.bad.dat
