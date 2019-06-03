#!/bin/tcsh -f

# One-stop shop to run all the Do_*_RUN*tcsh programs here.  Running
# this script might be useful if, for example, you want to run all the
# RUN commands and view outputs, thereafter savoring the results and
# reading the comments.

# We'll do the sets in the following order: DTI, HARDI, RSFC.  If you
# only wanted to do one set for some reason (but note, some of the
# RSFC programs require inputs from the DTI ones), you could comment
# some out.

set all_DTI = `\ls Do_??_RUNdti*tcsh`
set all_HARDI = `\ls Do_??_RUNhardi*tcsh`
set all_RSFC = `\ls Do_??_RUNrsfc*tcsh`

# RUN-DTI programs
foreach run ( $all_DTI )
    printf "\nNOW RUNNING DTI-based example:    $run\n"
    tcsh $run
end

# RUN-HARDI programs
foreach run ( $all_HARDI )
    printf "\nNOW RUNNING HARDI-based example:    $run\n"
    tcsh $run
end

# RUN-RSFC programs
foreach run ( $all_RSFC )
    printf "\nNOW RUNNING RSFC-based example:    $run\n"
    tcsh $run
end


printf "\n\nDONE with all FATCAT Do_*RUN*-scripts!\n\n"
