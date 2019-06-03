This is version 2.2 of the AFNI FATCAT (Functional And Tractographic
Connectivity Analysis Toolbox) demo set (Taylor & Saad, 2013, in Brain
Connectivity).

* In updating from v2.1 -> v2.2, the scripts around the ROI selection
  for post-FreeSurfer/connectomic tracking have changed.  There have
  also been a few naming changes, reflecting some changes in AFNI
  program functionality. *

This demo set consists of DWI and RS-FMRI data, as well as example
HARDI-reconstructions, some of which has been processed using AFNI,
FSL (such melodic for ICA), dcm2nii and DSI-Studio (for
HARDI-modeling) programs.

The FATCAT programs run from commandlines. Here, short examples and
scripts of several, but not all, programs and features are given in
the Do_* files. The primary purpose of these scripts is to provide a
number of realistic and/or didactic examples for using FATCAT programs
in MRI analysis. Thus, there are descriptions, musings and suggestions
in the comments in each Do_* file.

There are roughly three sets of analyses, which are not really
independent.  There is one for DTI, one for HARDI and one for RSFC.
Particularly for DTI and HARDI outputs, there are a number of script
examples for viewing results nicely in SUMA, courtesy of ZS
Saad. Users are encouraged to check the outputs of each program, even
when scripts are not given.

Work is currently being done for a tutorial using the
SUMA-visualization tools, though some scripts are provided here for
viewing features.  Additionally, work will continue on the HARDI
features, for example for including a more rigorous method for
treating directional uncertainty.

***********************************************************************

To run a script, one should simply be able to type, for example, the
followin in a commandline:
$ tcsh Do_01_RUNdti_convert_grads.tcsh
or
$ ./Do_01_RUNdti_convert_grads.tcsh
and similarly for each Do_* file.

Some of these scripts use existing AFNI programs, such as 3dDWItoDT
and 3dcalc, as well.  They should generally be run in the order of
enumeration (first Do_01*, then Do_02*, etc.) since outputs from some
steps become inputs for others. If you want a shortcut to run all
calculations-scripts, but not the visualization ones, then run
Do_00_PRESTO*.tcsh.  Even so, it's worth reading through some of the
comments and descriptions in the comments of each file.  

Questions/comments/suggestions are always welcome, either on the AFNI 
Message Board website, or via email:
PA Taylor:  neon.taylor@gmail.com
ZS Saad:    saadz@mail.nih.gov

***********************************************************************

+ SCRIPTS to run (more detailed description in comments of each):

Do_00_PRESTO_ALL_RUNS.tcsh           :Execute all Do_*RUN*.tcsh scripts
Do_01_RUNdti_convert_grads.tcsh      :turn outputs from dcm2nii into usable
                                      gradient columns, includes component 
                                      flipping and b0 removal
Do_01_RUNhardi_convert_grads.tcsh    :turn outputs from dcm2nii into usable
                                      b-table columns for DSI-Studio
Do_02_RUNdti_DW_to_DTI.tcsh          :calculate tensor and associate parameters
                                      from DWIs (stored in directory called 
                                      DTI).
Do_03_RUNdti_make_network_ROIs.tcsh  :estimate ROIs for tractography from RS-
                                      FMRI data contained in SOME*, which 
                                      contains some ICA output components 
                                      (NB: file SOME* has been mapped into 
                                      native DW space).
Do_04_RUNdti_match_network_ROIs.tcsh :match IC Z-score maps of individual's data
                                      with a reference set
Do_05_RUNdti_DET_tracking.tcsh       :deterministic tractography examples for
                                      DTI model data, highlighting various 
                                      options and user-control features
Do_05_RUNhardi_DET_tracking.tcsh     :deterministic tractography examples for
                                      HARDI model data, highlighting various
                                      options and user-control features
Do_06_VISdti_SUMA_visual.tcsh        :fun SUMA visualization of tract output,
                                      as well as WM-ROI statistics, all in one.
Do_07_RUNdti_uncertainty_est.tcsh    :in preparation for both mini- and full-
                                      probabilistic tracking, here we
                                      calculate uncertainty estimates of some
                                      DT parameters.
Do_07_RUNhardi_uncertainty_est.tcsh  :since the HARDI modeling is not currently
                                      performed in AFNI/FATCAT, there isn't a 
                                      program for calculating uncertainty of
                                      parameters, such as there is for DTI using
                                      3dDWUncert. This describes a *very* 
                                      simplistic method for assigning approx.
                                      values of uncertainty for parameters.
Do_08_RUNdti_miniprob_track.tcsh     :simple extension of deterministic tracking
                                      to include some tensor perturbations + 
                                      Monte Carlo iterations; output is 
                                      essentially the same style as for purely 
                                      deterministic, but gives a broader 
                                      picture of potential tract estimations 
                                      including tensor uncertainty
Do_08_RUNhardi_miniprob_track.tcsh   :simple extension of deterministic tracking
                                      (as above) for HARDI case
Do_09_VIS*tcsh                       :more visualization & comparison
Do_10_RUNdti_fullprob_track.tcsh     :run probabilistic tractography for DTI 
                                      data
Do_10_RUNhardi_fullprob_track.tcsh   :run probabilistic tractography for HARDI 
                                      data
Do_11_VIS*tcsh                       :more visualization of probabilistic output
Do_12_RUNrsfc_netw_corr.tcsh         :calculate correlation matrices of 
                                      functional ROI networks, particularly for
                                      accompanying some of the statistical WM-
                                      ROI output obtained from tractography
Do_13_RUNrsfc_RSFCfilt_param.tcsh    :final step of processing for resting state
                                      time series, bandpassing to low frequency
                                      fluctuations (LFFs); at this step, several
                                      spectral coefficients can be calculated
                                      such as ALFF, fALFF, etc.
Do_14_RUNrsfc_ReHo_param.tcsh        :calculate Kendall's W (coefficient of 
                                      concordance, or ReHo=Regional Homogeneity)
                                      for functional LFFs output by RSFCfilt

***********************************************************************

Briefly, the data files contained in this demo are:

+ DWI data from scanning:
    AVEB0_DWI.nii.gz
    mask_DWI+orig.*
    bval
    bvec

+ RS-FMRI from scanning, processing, and also ICA (NB: mapped into DWI space):
    REST_in_DWI.nii.gz
    SOME_ICA_NETS_in_DWI+orig.*

+ ANATOMICAL data and skull-stripped surface:
    mprage+orig.*
    toy.gii

+ PARAMETER files for running deterministic and probabilistic tractography (with 
    some important differences in formats between the *.niml.opts and *dat):
    ALGOPTS_DET.niml.opts
    ALGOPTS_PROB.dat

+ MNI reference IC bricks mapped into DWI for reference:
    MULTISITE_in_DWI+orig*

+ HARDI-modeled data (from the same AVEB0_DWI.nii.gz) from DSI-Studio, 
    using GQI reconstruction; also included is the example script of DSI-Studio
    commands used for constructing and converting the data to NIFTI files:
    HARDI/GQI*.nii.gz
    HARDI/do_dsistudio.tcsh
