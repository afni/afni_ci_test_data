#!/bin/tcsh -f
set Ssize = (900 1000)
set Axsize = (350 500)
set Sasize = (500 500)

set sc1 = (0 900) #Screen 1
set sc2 = (1400 1050) #Screen 2


set Spos = (`ccalc -i $sc1[1] + 1` 0)
set AposAx = (`ccalc -i $sc1[1] + 1 + $Ssize[1]` 0)
set AposSa = (`ccalc -i $sc1[1] + 1 + $Ssize[1]` `ccalc -i $Axsize[2]`)

@Quiet_Talkers -npb_val 4
sleep 2


suma  -dev  -npb 4   \
      -setenv "'SUMA_VO_InitSlices = Ax:0.5 hCo'"   \
      -tract DTI/o.WB_000.niml.tract   \
      -spec SUMA/std.60.FATCAT_both.spec  \
      -sv mprage+orig   \
      -vol mprage+orig &

afni -DAFNI_GLOBAL_SESSION=DTI/ -npb 4 -niml -yesplugouts      
           
sleep 4
           
set an = `prompt_user -pause 'Hit enter to position windows on screen'`
if ("$an" != 1) goto END

DriveSuma -npb 4  \
          -com surf_cont -view_surf_cont y   \
          -com viewer_cont -viewer_size $Ssize -viewer_position $Spos \
          -com viewer_cont -key '[' -key ']' -key 'F5'
          
          
plugout_drive -npb 4 \
               -com 'SWITCH_UNDERLAY mprage'  \
               -com 'SWITCH_OVERLAY DT_FA'    \
               -com 'SET_PBAR_SIGN A.+'       \
               -com "OPEN_WINDOW A.axialimage "   \
               -com "OPEN_WINDOW A.axialimage    geom=${Axsize[1]}x${Axsize[2]}+${AposAx[1]}+0"   \
               -com "OPEN_WINDOW A.sagittalimage "   \
               -com "OPEN_WINDOW A.sagittalimage geom=${Sasize[1]}x${Sasize[2]}+${AposAx[1]}+${AposSa[2]}"   \
               -quit
               
set an = `prompt_user -pause "\
      Simultaneous InstaTract and InstaCorr in a single subject\n\
\n\
This demo is meant to illustrate the simultaneous use of instatract \n\
and instacorr in a single subject. You can start by creating a mask on \n\
the tracts. To do so: Select (right-click) a point on the tracts\n\
                      Open the object controller (ctrl+s)\n\
                      Click on Masks, twice.\n\
This creates a masking sphere and only tracts going through it are\n\
displayed. To move the sphere right-double click on it then select\n\
any location on tracts, slices, surfaces, etc. The ball turns into\n\
a mesh when SUMA is in 'Mask Manipulation Mode' (see help in SUMA,\n\
(ctrl+h), for details.)\n\
To start the next phase, start to talking to AFNI by pressing 't' in \n\
the SUMA window. Now when you move the mask in SUMA, it will also move\n\
in AFNI and vice versa.\n\
Display the surfaces in SUMA press '[' and ']' - they were hidden at the\n\
start.\n\
Setup AFNI's instacorr using dataset errts.anaticor.FATCAT+orig, blur by 4\n\
turn off flitering - it's been done already -, set seed radius to 6\n\
and then press Setup+Keep.\n\
In SUMA, shift+ctl+right click somewhere to move the masking ball AND tell\n\
AFNI to set the instacorr seed. AFNI will compute the resting state \n\
correlation with the seed and send the results back to SUMA, which displays\n\
the results on the surface. Lower the threshold in AFNI to about .3 \n\n\
If the surfaces obstruct the view, pry them apart with ctrl+click+drag and \n\
try again.\n\
If function is showing on one hemisphere only, right-click on surface, \n\
open its controller (ctrl+s) --> Switch Dset to one with FuncAfni_00 in \n\
its name.\n\n\
For more help, see interactive mouse usage (ctrl+h) in SUMA, AFNI's message\n\
board, or email saadz@mail.nih.gov"`


END:
