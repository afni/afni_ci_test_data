#!/bin/tcsh

# January, 2014.

# An example of using DSI-Studio (Yeh et al., 2010) to reconstruct
# HARDI models for use in tracking. Note: this is *NOT* a tutorial on
# using DSI-Studio, but merely a simple example in using it to make
# some examples for HARDI-tracking with AFNI-FATCAT-3dTrackID.  Please
# refer to the DSI-Studio website/poster/papers/etc. for more
# information. Key to this enterprise has been the recent DSI-Studio
# addition of enabling NIFTI file outputs (many thanks), so that
# AFNI-FATCAT can use the results.

# This script was run from the $maindir, defined just below

#*********************************************************************
# Just setting some names/locations of things-- user can adjust
# appropriately for own usage
# 1) where DSI-Studio has been installed
set whereprog = "/usr/local/pkg/dsistudio/20120919"
# 2) where the demo is-- for some reason, I needed to put full path of
#    'home', and couldn't use '~' abbreviation
set maindir = "/home/paul/FATCAT_DEMO"
# 3) where I want my output to go 
set whereto = "$maindir/HARDI"
#*********************************************************************


# DSI-Studio start: make source file; b_table was made using
# AFNI-1dDW_Grad_o_Mat-- note its columnar structure including
# b-values.
$whereprog/dsi_studio   \
    --action=src                               \
    --source="$maindir/AVEB0_DWI.nii.gz"      \
    --b_table="$whereto/b_table.txt"   \
    --output="$whereto/output.src"                 


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
#                  GQI
#  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

# Make use of GQI to construct directions (<=3 per vox);
# makes a 'fib' file called: output.src.odf8.f3rec.gqi.1.25.fib.gz
$whereprog/dsi_studio   \
    --action=rec                               \
    --source="$whereto/output.src"   \
    --thread=4                                 \
    --method=4                                 \
    --param0=1.25                              \
    --record_odf=1                             \
    --odf_order=8                              \
    --num_fiber=3

# Export data from 'fib' file to NIFTI; for tracking, we need dirs
# and a WM-proxy map.  Here, I'm outputting both FA and GFA (will
# just use latter, probably)
$whereprog/dsi_studio   \
    --action=exp                               \
    --source="$whereto/output.src.odf8.f3rec.gqi.1.25.fib.gz"  \
    --export=dirs,fa0,gfa    


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
#                  QBALL
#  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

# Make use of QBall to construct directions (<=3 per vox)
# makes a 'fib' file called: output.src.odf8.f3rec.qbi.sh8.1.25.fib.gz
$whereprog/dsi_studio   \
    --action=rec                               \
    --source="$whereto/output.src"   \
    --thread=4                                 \
    --method=3                                 \
    --param0=1.25                              \
    --record_odf=1                             \
    --odf_order=8                              \
    --num_fiber=3

# Export data from 'fib' file to NIFTI; for tracking, we need dirs
# and a WM-proxy map.  Here, I'm outputting both FA and GFA (will
# just use latter, probably)
$whereprog/dsi_studio   \
    --action=exp                               \
    --source="$whereto/output.src.odf8.f3rec.qbi.sh8.1.25.fib.gz"  \
    --export=dirs,fa0,gfa

# bit of copying to shorter file names:
3dcopy \
    $whereto/output.src.odf8.f3rec.qbi.sh8.1.25.fib.gz.gfa.nii.gz \
    $whereto/QBALL_GFA.nii.gz
3dcopy \
    $whereto/output.src.odf8.f3rec.qbi.sh8.1.25.fib.gz.dirs.nii.gz \
    $whereto/QBALL_DIRS.nii.gz
3dcopy \
    $whereto/output.src.odf8.f3rec.qbi.sh8.1.25.fib.gz.fa0.nii.gz \
    $whereto/QBALL_FA.nii.gz


printf "\nDONE.\n"
