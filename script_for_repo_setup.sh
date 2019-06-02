#!/bin/bash
set -e
datalad rev-create afni_ci_test_data/
cd afni_ci_test_data/
wget https://afni.nimh.nih.gov/pub/dist/edu/data/AFNI_data6.tgz
tar xvfz AFNI_data6.tgz
rm AFNI_data6.tgz
# Stringent conditions for what a "big" file is:
git config annex.largefiles 'largerthan=10kb'
# Add it to the repo
datalad rev-save
datalad create-sibling  --as-common-datasrc afni_ci_test_data  --ui true  --target-url https://afni.nimh.nih.gov/pub/dist/data/afni_ci_test_data/.git afni:/fraid/pub/dist/data/afni_ci_test_data
datalad create-sibling-github  --github-organization afni --existing reconfigure --publish-depends afni --access-protocol ssh afni_ci_test_data
datalad publish --to github --transfer-data all
datalad run "mkdir mini_data; 3dAutobox -input AFNI_data6/afni/second_anat+orig.BRIK -prefix mini_data/cropped.nii.gz; 3dresample -dxyz 3 3 3 -input mini_data/cropped.nii.gz -prefix mini_data/anat_3mm.nii.gz;rm mini_data/cropped.nii.gz"
datalad run "3dAutobox -input AFNI_data6/afni/strip+orig.BRIK -prefix tmp.nii.gz; 3dresample -dxyz 3 3 3 -input tmp.nii.gz -prefix mini_data/anat_3mm_no_skull.nii.gz;rm tmp.nii.gz"
datalad run "3dZeropad -master mini_data/anat_3mm.nii.gz -prefix mini_data/anat_3mm_no_skull_zero_padded.nii.gz mini_data/anat_3mm_no_skull.nii.gz"
datalad run "cd mini_data;3dAutomask -prefix mask_3mm.nii.gz anat_3mm_no_skull.nii.gz"
datalad run -m "add aligned data to mini_data" "3dAllineate -base mini_data/anat_3mm_no_skull.nii.gz -source AFNI_data6/afni/epi_r1+orig.BRIK'[0]' -prefix mini_data/aligned.nii.gz -1Dparam_save mini_data/aligned.1D -maxrot 2 -maxshf 1 -nmatch 20 -conv 2 -cost lpc"
datalad install ///openfmri/ds000002
datalad rev-save -m "add ds000002"
datalad run -m "add setup_script" "cp ../script_for_repo_setup.sh ."
datalad publish --to github --transfer-data all
