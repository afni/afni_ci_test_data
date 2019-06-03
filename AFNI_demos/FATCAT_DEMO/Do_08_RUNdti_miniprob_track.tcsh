#!/bin/tcsh -f

# Mini-probabilistic tracking example: this method uses determinstic
# tractography + a simple extension of including few Monte Carlo
# iterations of perturbed tensor values (via uncertainty estimations).
# This can be useful to get a broader (more robust?) sense of tract
# locations, intermediate to (and faster than) full probabilistic
# tracking itself-- hence it is referred to as the
# `mini-probabilistic' option.  The same deterministic algorithm
# options from before are used.

# Previously, in Do_05*.tcsh, we looked at AND-logic connections among
# the four networks of interest. Let's do a few iterations in MINIP
# mode, and compare results.

set uncfile = `\ls DTI/o.UNCERT*HEAD`

3dTrackID -mode MINIP                 \
    -dti_in DTI/DT                    \
    -netrois "ROI_ICMAP_GMI+orig"     \
    -logic AND                        \
    -mini_num 7                       \
    -uncert "${uncfile[1]}"    \
    -prefix DTI/o.NETS_AND_MINIP      \
    -write_opts                       \
    -overwrite             -echo_edu  
