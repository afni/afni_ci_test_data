#!/bin/tcsh
# CA_EZ_atlas.csh
#
# read NIML atlas point lists created by CA_EZ_Prep_genx.m and make
# AFNI datasets from the hdr files from the Anatomy Toolbox
# data downloaded from 
#   http://www.fz-juelich.de/inm/inm-1/DE/Forschung/_docs/SPMAnantomyToolbox/SPMAnantomyToolbox-doc.html

if ( $#argv > 0 ) then
   echo "not for general use"
   exit
endif

set headout_pre = caez_pmaps_temp
set headout = caez_pmaps_18
# this is the list of mni space output prefixes
set allmnilist = ( caez_pmaps_18 caez_gw_18 caez_mpm_18 caez_ml_18 caez_lr_18 )
set mnipmaplist = ( caez_pmaps_18 caez_gw_18 )
set mniatlist = ( caez_mpm_18 caez_ml_18 caez_lr_18 )

set ca_ez_max = 250
set outspace = MNI_ANAT
set hnote = "Cytoarchitectonic - Eickhoff, Zilles, Version 1.8"
set geomparent = "PMaps/wThalamus_Motor.nii"
set TT_outspace = TT_N27

# niml atlas points list for each atlas
# created by CA_EZ_Prep_genx.m
set pmap_nimlin = pm.niml
set gw_nimlin = gw.niml # grey, white matter map list created here
set ml_nimlin = ml.niml
set lr_nimlin = lr.niml
set mpm_nimlin = mpm.niml

# output in "orig" view to start for NIFTI files (sform,qform_code=2)
setenv AFNI_NIFTI_VIEW orig
setenv AFNI_ANALYZE_VIEW orig

# make these datasets as small as possible
setenv AFNI_COMPRESSOR GZIP

# put original dataset labels in a list (the names of the files)
set sb_labels = `grep SB_LABEL $pmap_nimlin | awk -F\" '{print $2}'`

# put corresponding structure labels in another list
# this list is tricky to use because of spaces, quotes and parentheses
#  and we don't really need it here anyway. Sub-brick labels
#  can be the original dataset names, as it has been done for ages
# set sb_structs = (`grep STRUCT pm.niml | awk -F= '{print $2}'|tr \" \' ` )

rm $headout+orig.*
rm $headout+tlrc.*
rm caez*+tlrc.HEAD
rm caez*+tlrc.BRIK
rm caez*+tlrc.BRIK.gz
rm MNIa_caez*+tlrc.HEAD
rm MNIa_caez*+tlrc.BRIK
rm MNIa_caez*+tlrc.BRIK.gz
rm TT_caez*+tlrc.HEAD
rm TT_caez*+tlrc.BRIK
rm TT_caez*+tlrc.BRIK.gz
rm MNI_caez*+tlrc.HEAD
rm MNI_caez*+tlrc.BRIK
rm MNI_caez*+tlrc.BRIK.gz

3dcopy ~/abin/TT_N27+tlrc.HEAD .

cd PMaps
rm ${headout_pre}+tlrc.*
rm ${headout_pre}+orig.*

set sbdsetlist = ""

# put a NIFTI file as the first sub-brick temporarily just to get the
# origin and orientation right (I hope)
3dcalc -a wThalamus_Motor.nii -prefix ${headout_pre} -expr a/$ca_ez_max\
    -datum byte

foreach sb ($sb_labels)
   # some of these labels are for .nii NIFTI files
   if -e $sb then
      set sbdset = $sb
   # while most others are for Analyze hdr files
   else
      set sbdset = "${sb}.hdr"
   endif
   # datasets are not only a mixture of NIFTI and Analyze, 
   # they are also mixture of byte and short data with the NIFTI ones having
   # an origin explicitly set (hopefully all are identified orig view here)
   3dcalc -a $sbdset -prefix ${sb}_b -datum byte -expr "a/$ca_ez_max" \
     -overwrite

   set sbdsetlist = ($sbdsetlist ${sb}_b+orig)
end

# glue all the orig view datasets together
3dbucket -glueto ${headout_pre}+orig  $sbdsetlist
# now change the type to tlrc view
3drefit -view tlrc ${headout_pre}+orig

mv ${headout_pre}+tlrc.* ..
cd ..

# remove the first dummy sub-brick used for setting the grid
3dbucket -prefix ${headout} ${headout_pre}+tlrc'[1..$]'

# don't need the temp file
rm ${headout_pre}+tlrc.HEAD ${headout_pre}+tlrc.HEAD
rm ${headout_pre}+tlrc.BRIK* ${headout_pre}+tlrc.BRIK*

set headout = "${headout}+tlrc"

set sbi = 0

# replace sub-brick label for every sub-brick with original dataset name
foreach sb_label ($sb_labels)
  3drefit -sublabel $sbi $sb_label $headout
  @ sbi ++
end


# the compressed file takes much less space because the prob. maps
#  are mostly zero (1/200 of original byte data). 
# gzip ${headout}.BRIK


# most of these datasets are stored as Analyze files, but a few are NIFTI
# as with the PMaps, I use one as a reference for the geometry
# the data are stored LPI,151,188,154 voxels - non-square grid,
# but cubic 1mm3 voxels
# First the three atlases besides the PMaps
# the MPM is oddly formatted with floating point values and a scale factor
# these need to be rounded appropriately as done in the conversion to integer
# below
3dcalc -a AllAreas_v18.hdr -expr 'a+0.001' -datum byte \
  -DAFNI_NIFTI_VIEW='tlrc' -prefix caez_mpm_18_temp -nscale
#to3d -geomparent $geomparent -view tlrc -prefix caez_mpm_18_temp \
#  "3Db:0:0:151:188:154:AllAreas_v18.img"
to3d -geomparent $geomparent -view tlrc -prefix caez_ml_18 \
  "3Db:0:0:151:188:154:MacroLabels.img"

# remove non-atlas structural values from mpm dataset
# The N27 data is superimposed in the lower range (less than 103) this way
# but this is not useful for atlases and is more difficult to work with
cat mpm.niml | grep "VAL=" | awk -F= '{print $2}' | tr -d \" > mpmvals.1D
set tt = `3dBrickStat -min -max -slow mpmvals.1D`
3dcalc -a caez_mpm_18_temp+tlrc."<${tt[1]}..${tt[2]}>" -expr a \
   -prefix caez_mpm_18

to3d -geomparent $geomparent -view tlrc -prefix caez_lr_18 \
 "3Db:0:0:151:188:154:AnatMask.img"

# copy the colin N27 brain in MNI_ANAT,the template upon which all this based
to3d -geomparent $geomparent -view tlrc -prefix caez_colin27_T1_18 \
 "3Db:0:0:151:188:154:colin27T1_seg.img"

# now combine the grey and and white probability maps
to3d -geomparent $geomparent -view tlrc -prefix caez_wgrey_18_temp \
 "3Db:0:0:151:188:154:wgrey.img"
to3d -geomparent $geomparent -view tlrc -prefix caez_wwhite_18_temp \
 "3Db:0:0:151:188:154:wwhite.img"
3dbucket -prefix caez_gw_18_temp caez_wgrey_18_temp+tlrc \
                                 caez_wwhite_18_temp+tlrc
# ****** wgrey.img and wwhite.img are flipped left/right
# this needs to be fixed by Eickhoff, but is patched here
3dLRflip -prefix caez_gw_18_temp_flip caez_gw_18_temp+tlrc

# Make this dataset scale from 0 to 1 instead of 0-250
3dcalc -a caez_gw_18_temp_flip+tlrc -expr "a/$ca_ez_max" \
   -prefix caez_gw_18
# label the sub-bricks
3drefit -sublabel 0 "grey" -sublabel 1 "white" caez_gw_18+tlrc

set nimlout = $gw_nimlin
echo '<atlas_point_list' > $nimlout
echo ' ni_form="ni_group" >' >> $nimlout
set sbi = 0
foreach sblabel ( "grey" "white" )
  # write out NIML point structure
  # the STRUCT field contains the structure name
  # the SB_LABEL field contains the sub-brick label that is associated with
  #  this structure
  echo '<ATLAS_POINT' >> $nimlout
  echo 'data_type="atlas_point"' >> $nimlout
  echo 'STRUCT='$sblabel >> $nimlout
  echo 'VAL='\"$sbi\" >> $nimlout
  echo 'OKEY='\"$sbi\" >> $nimlout
  echo 'GYoAR="0"' >> $nimlout
  echo 'COG=" 0.000000 0.000000 0.000000"' >> $nimlout
  echo 'SB_LABEL='$sblabel' />' >> $nimlout
  @ sbi ++
end
echo '</atlas_point_list>' >> $nimlout


# Now add a few attributes to the dataset headers

# make Talairached copies of all these using the manually
# transformed TT_N27 as a base with output of 1 mm3
# nearest neighbor interpolation even on pmaps to preserve 10% steps
# also create new TT_N27 look-alike and check this
foreach atlas_dset ( $allmnilist caez_colin27_T1_18 )
   # make MNI datasets from the MNI_ANAT datasets by shifting these
   @Shift_Volume -MNI_Anat_to_MNI -dset ${atlas_dset}+tlrc \
       -prefix MNI_${atlas_dset}
   adwarp -resam NN -force -apar TT_N27+tlrc.HEAD -dpar MNI_${atlas_dset}+tlrc \
    -prefix TT_$atlas_dset
end

# don't need the MNI space dataset anymore directly
rm MNI_caez*+tlrc.*

# set attributes for the non-probabilistic atlases
foreach atlas_dset_pre ( $mniatlist )
   set atlas_dset = "${atlas_dset_pre}+tlrc"
   set TT_atlas_dset = " TT_${atlas_dset_pre}+tlrc"
   # MNI_ANAT space atlases
   3drefit -space $outspace  $atlas_dset
   3drefit -cmap INT_CMAP    $atlas_dset
   3drefit -atrint ATLAS_PROB_MAP 0 $atlas_dset
   3dNotes -HH "$hnote" $atlas_dset

   # TT_N27 space atlases
   3drefit -space $TT_outspace $TT_atlas_dset
   3drefit -cmap INT_CMAP $TT_atlas_dset
   3drefit -atrint ATLAS_PROB_MAP 0 $TT_atlas_dset
   3dNotes -HH "$hnote" $TT_atlas_dset
end

# set some attributes for the probability maps
foreach atlas_dset_pre ( $mnipmaplist )
   set atlas_dset = "${atlas_dset_pre}+tlrc"
   set TT_atlas_dset = " TT_${atlas_dset_pre}+tlrc"

   # MNI_ANAT space datasets
   3drefit -space $outspace $atlas_dset
   3drefit -cmap CONT_CMAP $atlas_dset
   3drefit -atrint ATLAS_PROB_MAP 1 $atlas_dset
   3dNotes -HH "$hnote" $atlas_dset

   # TT_N27 space datasets
   3drefit -space $TT_outspace $TT_atlas_dset
   3drefit -cmap CONT_CMAP $TT_atlas_dset
   3drefit -atrint ATLAS_PROB_MAP 1 $TT_atlas_dset
   3dNotes -HH "$hnote" $TT_atlas_dset

end

# update the anatomical datasets too
3drefit -space $outspace caez_colin27_T1_18+tlrc
3drefit -space $TT_outspace TT_caez_colin27_T1_18+tlrc

# put the atlas_point_list niml table in each dataset
3drefit -atrstring ATLAS_LABEL_TABLE file:$pmap_nimlin caez_pmaps_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$gw_nimlin caez_gw_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$ml_nimlin caez_ml_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$lr_nimlin caez_lr_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$mpm_nimlin caez_mpm_18+tlrc

3drefit -atrstring ATLAS_LABEL_TABLE file:$pmap_nimlin TT_caez_pmaps_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$gw_nimlin TT_caez_gw_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$ml_nimlin TT_caez_ml_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$lr_nimlin TT_caez_lr_18+tlrc
3drefit -atrstring ATLAS_LABEL_TABLE file:$mpm_nimlin TT_caez_mpm_18+tlrc

# rename the originals to have MNIa in prefix
foreach atlas_dset ( $allmnilist caez_colin27_T1_18 )
   3drename ${atlas_dset}+tlrc MNIa_${atlas_dset}
end

# delete the extra intermediate files
rm caez*_temp*+tlrc.*
rm PMaps/*.HEAD PMaps/*.BRIK.gz

tar czvf caez_18_all_atlases.tgz MNIa_caez*+tlrc.* TT_caez*+tlrc.*

echo "Examine each atlas in the AFNI GUI to see how they match existing atlases"
echo "As each atlas is read in as underlay or overlay, it is added to the current"
echo "session's list of atlases. A whereami request will show any viewed atlases"
echo "in the AFNI GUI. Verify there are names for all structures, left and right"
echo "are not flipped, and that atlases align well with their templates."
echo
echo "When satisfied that all atlases are correct, archive old atlases and copy"
echo "new atlases to afni server using these commands (or something like them):"
echo
echo "cd /Volumes/elrond/pub/dist/atlases/current/"
echo "tar -czvf /Volumes/elrond/pub/dist/atlases/atlases_mm_yyyy.tgz *"
echo "cd -"
echo "cp MNIa_caez*+tlrc.* /Volumes/elrond/pub/dist/atlases/current/"
echo "cp TT_caez*+tlrc.* /Volumes/elrond/pub/dist/atlases/current/"
echo "cp /Users/dglen/data/atlas/eickhoff/Anatomy/CA_EZ_atlas.csh /Volumes/elrond/pub/dist/atlases/current/"
echo "cp caez_18_all_atlases.tgz  /Volumes/elrond/pub/dist/atlases/"
