﻿namespace kri.rend.part

import System.Collections.Generic
import OpenTK.Graphics.OpenGL


public class Defer( kri.rend.defer.ApplyBase ):
	private final pHalo		= kri.shade.par.Value[of OpenTK.Vector4]('halo_data')
	private final light		= kri.Light( energy:1f, quad1:0f, quad2:0f )
	private final attr		= kri.Ant.Inst.slotAttributes.find(2)	# particles attrutes
	private final trans		= Dictionary[of int,int]()
	# init
	public def constructor(pc as kri.part.Context, con as kri.rend.defer.Context, qord as byte):
		super(qord)
		# attributes
		assert attr.Length == 2
		GL.Arb.VertexAttribDivisor(attr[0],1)
		GL.Arb.VertexAttribDivisor(attr[1],1)
		sa.attrib( attr[0], 'at_part_sys' )
		sa.attrib( attr[1], 'at_part_pos' )
		# program link
		dict.var(pHalo)
		sa.add('/part/draw/light_v')
		relink(con)
		# trans dictionary
		trans[pc.at_sys] = attr[0]
		trans[pc.at_pos] = attr[1]
	# work
	private override def onDraw() as void:
		# draw particles
		for pe in kri.Scene.Current.particles:
			#todo: add light particle meta
			continue	if not pe.mat
			halo = pe.mat.Meta['halo'] as kri.meta.Halo
			continue	if not halo
			pHalo.Value = halo.Data
			light.setLimit( pHalo.Value.X )
			pe.data.attribTrans(trans)	
			kri.Ant.Inst.params.activate(light)
			sa.use()
			sphere.draw( pe.owner.total )
