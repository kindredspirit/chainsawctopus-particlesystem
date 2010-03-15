﻿namespace kri.load

import System
import OpenTK
import OpenTK.Graphics
import OpenTK.Graphics.OpenGL
import kri.shade


#------		LOAD CONTEXT		------#

public class Meta:
	# params
	public final pEmissive	= par.Value[of Color4]()
	public final pDiffuse	= par.Value[of Color4]()
	public final pSpecular	= par.Value[of Color4]()
	public final pMatData	= par.Value[of Vector4]()
	# metas
	public final emissive	as int
	public final diffuse	as int
	public final specular	as int
	public final parallax	as int
	public final reflection	as int
	# create
	public def constructor(sm as kri.lib.Slot, d as rep.Dict):
		emissive	= sm.getForced('mat.emissive')
		diffuse		= sm.getForced('mat.diffuse')
		specular	= sm.getForced('mat.specular')
		parallax	= sm.getForced('mat.parallax')
		reflection	= sm.getForced('mat.reflection')
		d.add('mat.emissive',	pEmissive)
		d.add('mat.diffuse',	pDiffuse)
		d.add('mat.specular',	pSpecular)
		d.add('mat_scalars',	pMatData)
		

public class Shade:
	# light models
	public final lambert	= Object('/mod/lambert_f')
	public final cooktorr	= Object('/mod/cooktorr_f')
	public final phong		= Object('/mod/phong_f')
	# parallax
	public final shift0		= Object('/mod/shift0_f')
	public final shift1		= Object('/mod/shift1_f')
	# meta units
	public final text_gen0	= Object('/mod/text_0_v')
	public final text_gen1	= Object('/mod/text_uv_v')
	public final text_2d	= Object('/mod/text_2d_f')
	public final bump_gen0	= Object('/mod/bump_0_v')
	public final bump_gen1	= Object('/mod/bump_uv_v')
	public final bump_2d	= Object('/mod/bump_2d_f')
	public final refl_gen	= Object('/mod/refl_v')
	public final refl_2d	= Object('/mod/refl_2d_f')


public class Context:
	public final ms		= Meta(kri.Ant.Inst.slotMetas, kri.Ant.Inst.dict)
	public final slib	= Shade()
	public final mDef	= kri.Material('default')
	
	public static def MakeTex(*data as (byte)) as kri.Texture:
		tex = kri.Texture( TextureTarget.Texture2D )
		tex.bind()
		kri.Texture.Filter(false,false)
		kri.Texture.Init(1,1, PixelInternalFormat.Rgba8, data)
		return tex
	
	public def constructor():
		mDef.meta[ ms.emissive	]	= kri.meta.Emission( ms.pEmissive )
		mDef.meta[ ms.diffuse	]	= mDiff = kri.meta.Diffuse	( ms.pDiffuse,	ms.pMatData )
		mDef.meta[ ms.specular	]	= mSpec = kri.meta.Specular	( ms.pSpecular,	ms.pMatData )
		mDef.meta[ ms.parallax	]	= mParx = kri.meta.Parallax	( ms.pMatData )
		mDiff.shader = slib.lambert
		mSpec.shader = slib.phong
		mParx.shader = slib.shift0
		mDef.unit[ kri.Ant.Inst.units.texture	] = kri.meta.Unit(
			MakeTex(0xFF,0xFF,0xFF,0xFF), slib.text_gen0, slib.text_2d )
		mDef.unit[ kri.Ant.Inst.units.bump		] = kri.meta.Unit(
			MakeTex(0x80,0x80,0xFF,0x80), slib.bump_gen0, slib.bump_2d )