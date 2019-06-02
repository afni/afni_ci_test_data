
There is now a tutorial that comes with the class data (AFNI_data6)
used in the Start to Finish class. This should be a good read for
someone new to FMRI processing and/or AFNI. To use it:

0. make sure your AFNI version is current

1. download and extract the AFNI_data6.tgz package from

   http://afni.nimh.nih.gov/pub/dist/edu/data

2. download the current afni16_start_to_finish.pdf slides and read through
the first few to understand the experiment and afni_proc.py

   http://afni.nimh.nih.gov/pub/dist/edu/latest/afni16_start_to_finish/afni16_start_to_finish.pdf

3. start reading the tutorial, and follow the steps to process the data

----------------------------

The tutorial is just text files right now (it might stay that way),
though I will probably put html wrappers on it at some point. The
files are under the tutorial directory, so the path to them is:

AFNI_data6/FT_analysis/tutorial

That directory is available in expanded form at:

   http://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/AFNI_data6/FT_analysis/tutorial


Note that it is not yet finished, but goes pretty far. It gets through
the 3dDeconvolve command options and understanding the X-matrix. It
still needs coverage of the regression results, blur estimation and
completion of the single subject script, and possibly pages on subsequent
group analysis.

Hopefully this will be useful to some.

- rick


initial release: 28 July 2010
