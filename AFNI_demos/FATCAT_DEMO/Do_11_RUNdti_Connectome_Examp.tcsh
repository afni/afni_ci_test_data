#!/bin/tcsh


# What's in a name of files.
set FATPATH = "./"
set UNCFILE = `ls DTI/o.UNCERT*HEAD`
set UNCFILE = "${UNCFILE[1]}"
set ROIs    = "SUMA/aparc+aseg_REN_gm.nii.gz"
set ltROIs = "SUMA/aparc+aseg_REN_all.niml.lt"
set outdir = "CONNECTOMING"

echo $ltROIs

if ( ! -d ${outdir} ) then
    mkdir ${outdir}
endif

#### select a subset of GM, here from both hemispheres
###printf "\n\nTake GM ROIs from the initial data set.\n\n"
###3dcalc -a $ROIs                                         \
###    -expr 'a*within(a,42,113)'                          \
###    -prefix ${outdir}/CONNrois_SUB.nii                  \
###    -overwrite

# put the GM map into DWI space/coors
printf "\n\nTransfer the GM ROIs to DWI space.\n\n"
3dresample -master ${FATPATH}/AVEB0_DWI.nii.gz         \
    -prefix ${outdir}/DWI_CONNrois_SUB.nii             \
    -inset $ROIs                  \
    -overwrite

# minor inflation, 1 vox 
printf "\n\nMinorly inflate GM ROIs which are not touching WM,\n"
printf "\tas defined by the FA mask the GM ROIs to DWI space.\n\n"
3dROIMaker                                                \
    -wm_skel ${FATPATH}/DTI/DT_FA+orig.                   \
    -skel_thr 0.2   -skel_stop                            \
    -inflate 1                                            \
    -inset ${outdir}/DWI_CONNrois_SUB.nii                 \
    -refset ${outdir}/DWI_CONNrois_SUB.nii                \
    -prefix ${outdir}/DWI_CONNrois_SUB_ROI                \
    -overwrite

# copy label table to the data set
printf "\n\nCopy label-table to the new map of targets for tracking.\n\n"
3drefit -labeltable ${ltROIs}                             \
    ${outdir}/DWI_CONNrois_SUB_ROI_GMI+orig


# tracking: 1 seed per vox
printf "\n\nBasic tracking #1: deterministic, 1 seed per voxel.\n\n"

time 3dTrackID -mode DET                                        \
    -netrois ${outdir}/DWI_CONNrois_SUB_ROI_GMI+orig            \
    -alg_Nseed_X 1 -alg_Nseed_Y 1 -alg_Nseed_Z 1                \
    -logic AND                                                  \
    -dti_in ${FATPATH}/DTI/DT                                   \
    -prefix ${outdir}/o.OME                                     \
    -dump_rois AFNI                                             \
    -no_indipair_out                                            \
    -nifti                                                      \
    -overwrite




# tracking: 8 seeds per vox
printf "\n\nBasic tracking #2: deterministic, 8 seeds per voxel.\n\n"

time 3dTrackID -mode DET                                        \
    -netrois ${outdir}/DWI_CONNrois_SUB_ROI_GMI+orig            \
    -logic AND                                                  \
    -dti_in ${FATPATH}/DTI/DT                                   \
    -prefix ${outdir}/o.OME8                                    \
    -dump_rois AFNI                                             \
    -no_indipair_out                                            \
    -nifti                                                      \
    -overwrite

printf "\n\nDone!  See script file 'Do_11_RUNdti_Connectome_Examp.tcsh'.\n"
printf "\tfor examples of viewing results in SUMA, and other options.\n\n"

cat << EOF

 COMMENT 1: for viewing some of the results above, you can run any of
    the the following:
        suma -tract CONNECTOMING/o.OME_000.niml.tract  
        suma -tract CONNECTOMING/o.OME8_000.niml.tract
    and then, as an additional connectomic treat, color the tracts
    distinctly by which pair of target ROIs they connect; this makes use
    of the fact that 3dTrackID outputs the connection tracts as bundles,
    information which SUMA can use to colorize.  To do so after opening up
    SUMA to view a set of tracts: 
    in open SUMA window, click on:  View -> Object Controller,
    and at the bottom of the Controller click on 'Switch Dset',
    and select 'fg:*_BUN', which colors different bundles differently.

 COMMENT 2: There might be a lot of messages output like:
     "++ Network [0]:   [1234]th WM bundle has only one tract!"
    This just notes that while, yes, a tract was found between regions,
    there weren't a lot of them (just one in fact), and so one might not
    be sure about the robustness of the finding.  This is one reason why
    probabilistic tracking is preferable to DET (and even to MINIP), as 
    it gives better control over robustness.  
    However, even for DET and MINIP tracking, one can have a bit of 
    control by setting a threshold to reject bundles that have too few
    tracts.  This is done with the '-bundle_thr V' option, where V is the
    number of tracts a bundle needs to make it through to output 
    (default V=1).
EOF

# COMMENT 3: in the above tracking examples, one could also include
# the following option to have the volume maps of where the tracts go
# per connection, by including:
#       -dump_rois AFNI 
# Having the labeltable functionality, the dumped files will
# automatically be named using the label strings themselves, instead
# of the zero-padded ROI numbers (though, one can use the
# '-dump_no_labtab' switch to use the latter).



 


