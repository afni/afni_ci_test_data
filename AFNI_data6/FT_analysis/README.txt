
The contents of this directory include:

   FT                   - anat/EPI/timing/SUMA data for single subject FT
   README.txt           - this file
   s01.ap.simple        - afni_proc.py command: simple, matches tutorial
   s02.ap.align         - AP command: modern, with registration and censoring
   s03.ap.surface       - AP command: surface analysis
   s04.cmd.usubj        - uber_subject.py command: to match bootcamp
                        * this also processes the data under ~/subject_results
   s05.ap.uber          - AP command: produced by s04.cmd.usubj
   s06.ap.rest          - AP command: example 10 with 3 runs
   s07.ap.rest.11       - AP command: example 11
   s09.cleanup          - delete results of scripts

   s11.proc.FT          - proc script: produced by s01.ap.simple
   s12.proc.FT.align    - proc script: produced by s02.ap.align
   s13.proc.FT.surf     - proc script: produced by s03.ap.surface
   s15.proc.FT          - proc script: produced by s05.ap.uber
   s16.proc.FT.rest     - proc script: produced by s06.ap.rest
   s17.proc.FT.rest.11  - proc script: produced by s07.ap.rest.11

   tutorial             - tutorial for single subject analysis

needed for bootcamp:
   FT

needed for the tutorial:
   FT
   s01.ap.simple
   tutorial

In a typical AFNI bootcamp (class notes afni16_start_to_finish.pdf), only
the FT directory is needed.  Students are expected to run uber_subject.py
as shown by the instructor.  If that is not possible, consider using either
s04.cmd.usubj or s05.ap.uber.

For the tutorial, at present only s01.ap.simple is needed (which would
essentially produce s11.proc.FT), along with the input data under FT.

