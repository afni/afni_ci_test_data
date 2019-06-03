#!/bin/tcsh -f

set stat = 0
setenv AFNI_ENVIRON_WARNINGS NO
setenv SUMA_DriveSumaMaxCloseWait 15
setenv SUMA_DriveSumaMaxWait 15

if ( ! -f DTI/o.NETS_OR_000.niml.tract) then
   echo "Missing tractography file. Make sure that you have run Do_05_RUNdti_DET_tracking.tcsh first"
   goto BEND
endif

#Select a communication port
set sport = 12

#Close all afni/suma session chatting on this port
@Quiet_Talkers -npb_val $sport

#Launch SUMA with whole brain det. tractography and the anatomical volume
#This is an important first step in checking the tractography results
suma -dev -npb $sport -niml -setenv "'SUMA_VO_InitSlices = Ax:0.5,Sa:0.5:2:0.5'"\
                 -vol mprage+orig. \
                 -tract DTI/o.WB_000.niml.tract  &
afni -npb $sport -niml -yesplugouts -layout demo_layout \
                            mprage+orig.HEAD DTI/*.HEAD ROI_ICMAP_GMI+orig.HEAD &

#Give time for AFNI to come up, minimize chance of obstructing comment
sleep 3
set l = `prompt_user -pause \
"          SUMA & AFNI will make an apparition momentarily\n\n\
We begin with a simple look at the tracts.\n\
Right-click on the tracts to select a location along them.\n\
This would make AFNI jump to the same location if the two\n\
programs are talking. Press 't' in SUMA to get them talking\n\
and try the selections again.\n\n\
Open the tract controller via View --> Object Controllers or (ctlr+s)\n\
and select a location on the tract.\n\n\
           InstaTract - interactive mask selection\n\n\
Create a a mask by clicking on Masks in the tract controller.\n\
This creates a masking sphere and only tracts going through it are\n\
displayed. To move the sphere right-double click on it to place SUMA\n\
in 'Mask Manipulation Mode' which is indicated by displaying the ball\n\
in mesh mode (see help in SUMA, (ctrl+h), for details.).\n\
Selecting a location on the tracts, the slices, or surfaces, will make\n\
the ball jump to that location. The mask should also be visibile in AFNI\n\
and clicking in AFNI will make the mask move in SUMA also.\n\n\
To turn off 'Mask Manipulation Mode' right-double click in open air, or on\n\
the ball itself.\n\
\n\
Another click on Masks will also open the masks controller, which allows\n\
for complex masking configurations.\n\
\n\
Hit OK when done playing with whole brain tracts.\n\
The next example will look at tracts going through the DMN.\n"`
if ("$l" != "1") goto BEND           

#Now close SUMA and look for tractography results for a network 0
#of ROIs                 
@Quiet_Talkers -npb_val $sport
afni -npb $sport -niml -yesplugouts -layout demo_layout \
                            mprage+orig.HEAD DTI/*.HEAD ROI_ICMAP_GMI+orig.HEAD &
plugout_drive -npb $sport  -com 'SET_FUNCTION o.NETS_OR_000_INDIMAP+orig 0 0' \
                           -com 'SET_THRESHOLD A.0'  \
                           -com 'SET_ANATOMY mprage+orig' \
                           -com 'SET_DICOM_XYZ 18 7 -10'   \
                           -quit
suma -npb $sport  -niml -onestate                  \
                  -vol mprage+orig.                \
                  -i Net_000.gii                   \
                  -tract DTI/o.NETS_OR_000.niml.tract &
DriveSuma -npb $sport   -com surf_cont -surf_label Net_000.gii          \
                        -switch_cmap amber_monochrome -Dim 1.0          \
                        -com viewer_cont -key '.' -key 't'

set l = `prompt_user -pause \
"          SUMA & AFNI should be up soon.\n\n\
Here we are showing those tracts that go through any of the ROIs in the DMN\n\
per the results of deterministic tracking in 3dTrackID\n\n\
\n\
This is a good time to play with the volume controller too.\n\
To open one, select a voxel by right clicking on a slice and open \n\
the controller if it is not up already (ctrl+s, or View --> Object Controller)\n\
Try sliders, volume rendering, transparency, color mapping, etc.\n\n\
Use BHelp to get help for various GUI fields. Complain if BHelp is lacking.\n\n\
Hit OK when done with this. AFNI and SUMA will close afterwards."`
if ("$l" != "1") goto BEND           

@Quiet_Talkers -npb_val $sport

goto END

BEND:
   set stat = 1
   
END:
   exit $stat
