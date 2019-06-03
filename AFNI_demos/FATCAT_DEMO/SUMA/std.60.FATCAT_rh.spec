# MapIcosahedron generated spec file
#History: [ziad@eomer.nimh.nih.gov: Fri Nov 22 13:24:11 2013] MapIcosahedron -spec FATCAT_rh.spec -ld 60 -dset_map rh.thickness.gii.dset -dset_map rh.curv.gii.dset -dset_map rh.sulc.gii.dset -prefix std.60.

#define the group
	Group = FATCAT

#define various States
	StateDef = std.smoothwm
	StateDef = std.pial
	StateDef = std.inflated
	StateDef = std.sphere
	StateDef = std.white
	StateDef = std.sphere.reg
	StateDef = std.inf_200

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ./std.60.rh.smoothwm.gii
	LocalDomainParent = ./SAME
	LabelDset = ./std.60.rh.aparc.a2009s.annot.niml.dset
	SurfaceState = std.smoothwm
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ./SAME

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ./std.60.rh.pial.gii
	LocalDomainParent = ./std.60.rh.smoothwm.gii
	SurfaceState = std.pial
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ./std.60.rh.smoothwm.gii

