
#define the group
	Group = FATCAT

#define various States
	StateDef = std.smoothwm
	StateDef = std.pial
	StateDef = std.inflated_lh
	StateDef = std.sphere_lh
	StateDef = std.white
	StateDef = std.sphere.reg_lh
	StateDef = std.inf_200_lh
	StateDef = std.inflated_rh
	StateDef = std.sphere_rh
	StateDef = std.sphere.reg_rh
	StateDef = std.inf_200_rh

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ././std.60.lh.smoothwm.gii
	LocalDomainParent = ././SAME
	LabelDset = ././std.60.lh.aparc.a2009s.annot.niml.dset
	SurfaceState = std.smoothwm
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ././SAME

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ././std.60.lh.pial.gii
	LocalDomainParent = ././std.60.lh.smoothwm.gii
	SurfaceState = std.pial
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ././std.60.lh.smoothwm.gii

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ././std.60.rh.smoothwm.gii
	LocalDomainParent = ././SAME
	LabelDset = ././std.60.rh.aparc.a2009s.annot.niml.dset
	SurfaceState = std.smoothwm
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ././SAME

NewSurface
	SurfaceFormat = ASCII
	SurfaceType = GIFTI
	SurfaceName = ././std.60.rh.pial.gii
	LocalDomainParent = ././std.60.rh.smoothwm.gii
	SurfaceState = std.pial
	EmbedDimension = 3
	Anatomical = Y
	LocalCurvatureParent = ././std.60.rh.smoothwm.gii
