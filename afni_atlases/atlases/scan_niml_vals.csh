#!/bin/tcsh
set dset = $1
set niml1Dfile = $2

set nz = 0
foreach ival ( `cat $niml1Dfile` )
   set vc = `3dBrickStat -count -non-zero $dset"<${ival}>"`
   if ($vc == "0") then
      echo "index $ival - no voxels with that index"
      @ nz++
   endif
end
echo "Total number of zero voxel indices is $nz"
