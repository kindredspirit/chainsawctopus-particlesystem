﻿namespace kri.rend

import System
import OpenTK.Graphics

#---------	COLOR CLEAR	--------#

public class Clear( Basic ):
	public backColor	= Color4.Black
	public def constructor():
		super(false)
	public override def process(con as Context) as void:
		con.activate()
		con.ClearColor( backColor )


#---------	EARLY Z FILL	--------#

public class EarlyZ( tech.General ):
	private sa	= kri.shade.Smart()
	public def constructor():
		super('zcull')
		# make shader
		sa.add( '/zcull_v', 'empty', 'tool', 'quat', 'fixed' )
		sa.link( kri.Ant.Inst.slotAttributes, kri.Ant.Inst.dict )
	private override def construct(mat as kri.Material) as kri.shade.Smart:
		return sa
	public override def process(con as Context) as void:
		con.activate(false, 1f, true)
		con.ClearDepth(1f)
		drawScene()


#---------	INITIAL FILL EMISSION	--------#

public class Emission( tech.Meta ):
	public final pBase	= kri.shade.par.Value[of Color4]('base_color')
	public fillDepth	= false
	public backColor	= Color4.Black
	
	public def constructor():
		super('mat.emission', null, 'emissive')
		shade('/mat_base')
		dict.var(pBase)
		pBase.Value = Color4.Black
	public override def process(con as Context) as void:
		if fillDepth:
			con.activate(true, 1f, true)
			con.ClearDepth(1f)
		else: con.activate()
		con.ClearColor( backColor )
		drawScene()


#---------	GAUSS FILTER	--------#

public class Gauss(Basic):
	protected final sa		= kri.shade.Smart()
	protected final sb		= kri.shade.Smart()
	protected final texIn	= kri.shade.par.Value[of kri.Texture]('input')
	public	buf		as kri.frame.Buffer	= null

	public def constructor():
		super(false)
		dict = kri.shade.rep.Dict()
		dict.unit(texIn)
		sa.add('copy_v','/filter/gauss_hor_f')
		sa.link( kri.Ant.Inst.slotAttributes, dict )
		sb.add('copy_v','/filter/gauss_ver_f')
		sb.link( kri.Ant.Inst.slotAttributes, dict )

	public override def process(con as Context) as void:
		return	if not buf
		assert buf.A[0].Tex and buf.A[1].Tex
		for i in range(2):
			texIn.Value = t = buf.A[i].Tex
			t.bind(0)
			kri.Texture.Filter(false,false)
			kri.Texture.Wrap( OpenGL.TextureWrapMode.Clamp, 2 )
			buf.activate(3 ^ (1<<i))
			(sa,sb)[i].use()
			kri.Ant.inst.emitQuad()



#---------	RENDER SSAO	--------#


#---------	RENDER EVERYTHING AT ONCE	--------#

public class All( tech.General ):
	public def constructor():
		super('all')
	private override def construct(mat as kri.Material) as kri.shade.Smart:
		sa = kri.shade.Smart()
		sa.link( kri.Ant.Inst.slotAttributes, kri.Ant.Inst.dict )
		return sa
	public override def process(con as Context) as void:
		con.activate(true, 0f, true)
		con.ClearDepth(1f)
		con.ClearColor()
		drawScene()
