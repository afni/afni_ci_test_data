#!/bin/tcsh

## Get the list of unique image files
## * The reason for doing this unique image list
##   is that sometimes multiple copies of the same
##   image are output by DICOM server software,
##   and that is confusing to the Dimon program.
## * The uniq_images program will make a list of
##   images that are not identical.
## * uniq_images is an AFNI package program.

uniq_images I*[0123456789] > uniq_image_list.txt

## run Dimon to read in the files and create a NIFTI format dataset

## * the list of input files is from uniq_images
## * the output filename prefix will be T1.3D
## * the output file will be stored in the directory
##     above this one
## * the input files will be sorted by acquisition time,
##     not by filename
## * if the DICOM header has duplicate elements, use
#      the last copy found, not the first

Dimon -infile_list uniq_image_list.txt \
      -gert_create_dataset             \
      -gert_write_as_nifti             \
      -gert_to3d_prefix T1.3D          \
      -gert_outdir ..                  \
      -dicom_org                       \
      -use_last_elem                   \
      -save_details Dimon.details      \
      -gert_quit_on_err

## delete the list of unique images

\rm uniq_image_list.txt
