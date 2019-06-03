#!/bin/tcsh -fv

set stat = 0
setenv AFNI_ENVIRON_WARNINGS NO
setenv SUMA_DriveSumaMaxCloseWait 15
setenv SUMA_DriveSumaMaxWait 15

if ( ! -f DTI/o.NETS_OR_000.niml.tract) then
   echo "Missing tractography file. Make sure you have run all 'RUNdti' scripts from: "
   echo "   Do_01_RUNdti_convert_grads.tcsh to Do_08_RUNdti_miniprob_track.tcsh"
   goto BEND
endif


set sport = 12
set sport2 = `ccalc -i $sport+1`



@Quiet_Talkers -npb_val $sport -npb_val $sport2 

#goto SET1

SET0:
#Looking at the whole brain tractography
suma  -npb $sport -niml \
      -spec SUMA/std.60.FATCAT_both.spec \
      -sv mprage+orig \
      -vol mprage+orig. \
      -tract DTI/o.WB_000.niml.tract &

sleep 5                            
set l = `prompt_user -pause "\
        Example 0/4: Whole brain determinsitic tractography with surfaces\n\
\n\
This is the same data as in the Do_06 script, except that we are also\n\
showing the cortical surfaces.\n\
Open the object controllers for volume, tracts, and surfaces by selecting\n\
an object and using ctrl+s to open its controller. After the first controller\n\
is open, selecting a new object will automatically open the new object's\n\
controller.\n\n\
Select a tract and create a tract mask (click Masks in the controller).\n\
The mask can be positioned on the surfaces, just as you would position it\n\
on the tracts or the slices. However the surfaces obstruct the view and tracts\n\
are not visible. You could make them transparent (press 'o' twice in SUMA)\n\
but that may not be ideal. Another option is to pry the surfaces apart with\n\
ctrl+click and drag, left right, and/or up down. You can now position the mask\n\
on the pried surfaces and have the same masking effect. When the surfaces are\n\
pried apart, a doppleganger of the mask is shown on the displaced surfaces, \n\
and the mask ball is shown in the anatomically correct location.\n\
\n\
For more on prying, see SUMA's help (ctrl+h), search for 'F10' for example.\n\
\n\
Walk along the corpus callosum, for instance, and watch tracts follow along.\n\
\n\
When talking to AFNI, correspondence between pried surfaces and locations in\n\
the volume is maintained throughout.\n\
\n\
Hit OK when you're ready to move to Example 1"`
if ("$l" != "1") goto BEND
DriveSuma -npb $sport -com kill_suma
sleep 5

SET1:
#Looking at the default mode connections
afni -npb $sport -niml -yesplugouts -layout demo_layout \
                          *.HEAD DTI/*.HEAD  &
suma  -npb $sport -niml \
      -onestate \
      -i SUMA/std.60.lh.smoothwm.gii -i SUMA/std.60.rh.smoothwm.gii \
      -i Net_000.gii     \
      -sv mprage+orig \
      -vol mprage+orig. \
      -tract DTI/o.NETS_AND_000.niml.tract &
DriveSuma -npb $sport \
            -com viewer_cont -key 't' -key '.' \
            -com surf_cont -view_surf_cont y
DriveSuma -npb $sport \
            -com surf_cont -surf_label Net_000.gii \
            -load_dset Net_000.cols.niml.dset   \
            -switch_cmap ROI_i32 -Dim 0.3
sleep 5                            
set l = `prompt_user -pause "\
   Example 1/4: Looking at deterministic PAIRWISE connections between DMN ROIs\n\
\n\
One novel thing to try here would be to look at the tracts as colored by \n\
bundle. A bundle is a bunch of tracts linking a pair of ROIs.\n\
To do so, hide the surfaces by pressing '[' and ']' then open the tract\n\
controller, click on 'Switch Dset' and pick the third option, the one \n\
that ends with 'BUN' in the name. Note also that bundles are named by\n\
the bounding ROIs. The label is shown in SUMA on the top of the viewing space\n\
\n\
Consider overlaying diffusion data or DTI processing results in AFNI.\n\
Is the anatomical volume well aligned with the FA results\n\
\n\
Hit OK when you're ready to move to Example 2. This will open another SUMA\n\
window which will show the MINIPROB variant of the same network."`
if ("$l" != "1") goto BEND



SET2:
#Looking at the default mode mess with MINIP
suma  -npb $sport2 -niml \
      -onestate \
      -i SUMA/std.60.lh.smoothwm.gii -i SUMA/std.60.rh.smoothwm.gii \
      -i Net_000.gii     \
      -sv mprage+orig \
      -vol mprage+orig. \
      -tract DTI/o.NETS_AND_MINIP_000.niml.tract &

sleep 5                            
set l = `prompt_user -pause "\
   Example 2/4: Looking at the MINIPROB PAIRWISE connections between DMN ROIs\n\
\n\
Compare the tracts results from the MINIPROB approach to those from the \n\
determinsitc approach.\n\n\
Hit OK when ready for Example 3"`
if ("$l" != "1") goto BEND
DriveSuma -npb $sport -com kill_suma
DriveSuma -npb $sport2 -com kill_suma
plugout_drive -npb $sport -com 'QUIT' -quit
sleep 5


SET3:
#Looking at the 'grid' output, the 'graph' data
afni -npb $sport -niml -yesplugouts -layout demo_layout \
                            *.HEAD DTI/*.HEAD &
cd DTI/
suma  -npb $sport -niml \
      -onestate \
      -i ../SUMA/std.60.lh.smoothwm.gii -i ../SUMA/std.60.rh.smoothwm.gii \
      -i ../Net_000.gii     \
      -sv ../mprage+orig \
      -vol ../mprage+orig. \
      -gdset o.NETS_AND_MINIP_000.niml.dset &
cd -
DriveSuma -npb $sport \
            -com viewer_cont -key 't'  \
            -com surf_cont -view_surf_cont y
            
sleep 5                            
set l = `prompt_user -pause "\
   Example 3/4: Looking at the connectivity matrices between DMN ROIs\n\
\n\
A connectivity matrix is considered a graph dataset in SUMA and can be\n\
rendered as a set of nodes connected by edges, or as a matrix.\n\
The dual forms can be rendered simultaneously this way:\n\
   Open a new SUMA controller (ctrl+n)\n\
   Switch states till you get to the matrix ('.' key)\n\
   Select a connection, either by clicking on an edge or its corresponding\n\
   cell in the matrix.\n\
\n\
The edges (cells) carry the connection values. Open the graph controller\n\
to get information about a particular connection, and do all the kinds \n\
of colorization controls that are available for surface datasets and volumes.\n\
\n\
Selecting an edge highlights the cell in the matrix and vice versa.\n\
Selecting a node (label, or ball) will only show connections to that node.\n\
\n\
The set of controls on the lower left side is particular to graph datasets.\n\
Explore as curiosity moves you, the BHelp button comes in handy here but the\n\
help messages are still a work in progress. Complain away!\n\
\n\
Of note is the 'Bundles' button, try it, it is cool.\n\
\n\
Note that as with all AFNI datasets, you can have multiple sub-bricks,\n\
here matrices of course. You can navigate between them using the \n\
sub-brick selectors on the right side of the controller.\n\
\n\
Hit OK to close everything and quit"`
if ("$l" != "1") goto BEND
DriveSuma -npb $sport -com kill_suma
plugout_drive -npb $sport -com 'QUIT' -quit


goto END

BEND:
   set stat = 1
   
END:
   exit $stat
