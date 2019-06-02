#!/bin/tcsh

# ======================================================================
# Create an ideal time series for run 1 only, combining Vis and Aud, as
# if there there were only a single stimulus condition.
#
# This would create a ideal time series like epi_r1_ideal.1D.
#
# Note that the epi_r1 files include 4s (2 TRs) of pre-steady time.
# ======================================================================


# ----------------------------------------------------------------------
# - combine timing for the 2 conditions (vis and aud)
# - add 4 seconds (2 TRs)
# - sort the times, per run
# - extract just the first run, line 1
# - save as regressor, AV_r1.stim.txt
timing_tool.py -timing stim_AV1_vis.txt -extend stim_AV2_aud.txt \
 	-add_offset 4 -sort -write_timing -			 \
	| column_cat -line 1 - > AV_r1.stim.txt

# ----------------------------------------------------------------------
# convert timing to a single regressor, AV_r1.ideal.1D
# (152 time points matches epi_r1, at TR=2s)
3dDeconvolve -nodata 152 2					\
    -polort -1                                                  \
    -num_stimts 1                                               \
    -stim_times 1 AV_r1.stim.txt 'BLOCK(20,1)' -stim_label 1 VA \
    -x1D AV_r1.ideal.1D -x1D_stop


echo ""
echo "++ made AV_r1.ideal.1D; consider running:"
echo ""
echo "   1dplot -one epi_r1_ideal.1D AV_r1.ideal.1D"
echo ""
