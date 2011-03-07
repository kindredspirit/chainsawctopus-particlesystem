﻿namespace support.defer

import OpenTK.Graphics.OpenGL
import kri.shade


public class Context:
	public final buf		= kri.frame.Buffer()
	public final gbuf		= par.Value[of kri.buf.Texture]('gbuf')
	public final sh_diff	= Object.Load('/mod/lambert_f')
	public final sh_spec	= Object.Load('/mod/phong_f')
	public final sh_apply	= Object.Load('/g/apply_f')
	
	public def constructor():
		# diffuse, specular, world space normal
		gbuf.Value = buf.emitArray(3)


#---------	RENDER TO G-BUFFER	--------#

public class Fill( kri.rend.tech.Meta ):
	private final buf	as kri.frame.Buffer
	# init
	public def constructor(con as Context):
		super('g.make', false, ('c_diffuse','c_specular','c_normal'), *kri.load.Meta.LightSet)
		shade(('/g/make_v','/g/make_f','/light/common_f'))
		buf = con.buf
	# resize
	public override def setup(far as kri.frame.Array) as bool:
		buf.init( far.Width, far.Height )
		t = buf.A[0].Tex
		fm = kri.frame.Buffer.AskFormat( kri.frame.Buffer.Class.Color, 8 )
		fm = PixelInternalFormat.Rgb10A2
		t.intFormat = fm
		t.samples = 3
		t.init(far.Width,far.Height)
		t.filt(false,false)
		return true
	# work	
	public override def process(con as kri.rend.Context) as void:
		con.needDepth(false)
		buf.A[-1].Tex = con.Depth
		buf.activate()
		con.SetDepth(0f, false)
		con.ClearColor()
		drawScene()