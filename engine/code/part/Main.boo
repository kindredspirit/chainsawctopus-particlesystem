﻿namespace kri.part

import System
import System.Collections.Generic
import kri.shade


# interleaved attribute array holder
public class DataHolder( kri.vb.ISource ):
	[Getter(Data)]
	public data		as kri.vb.Attrib	= null
	public va		= kri.vb.Array()
	public def init(sem as kri.vb.Info*, num as uint) as void:
		if data:	data.Semant.Clear()
		else:		data = kri.vb.Attrib()
		data.Semant.AddRange( sem )
		va.bind()
		data.initAll( num )

# external particle attribute
public struct ExtAttrib:
	public dest		as int
	public source	as int
	public vat		as kri.vb.ISource


#---------------------------------------#
#	PARTICLE EMITTER 					#
#---------------------------------------#

public enum TechState:
	Unknown
	Ready
	Invalid

public class Emitter(DataHolder):
	public visible	as bool		= true
	public onUpdate	as callable(kri.Entity) as bool	= null
	public obj		as kri.Entity	= null
	public mat		as kri.Material	= null
	public final owner	as Manager
	public final name	as string
	public final extList	= List[of ExtAttrib]()
	public final techReady	= array[of TechState]( kri.lib.Const.nTech )

	public def constructor(pm as Manager, str as string):
		owner,name = pm,str
	public def constructor(pe as Emitter):
		visible	= pe.visible
		obj		= pe.obj
		mat		= pe.mat
		owner	= pe.owner
		name	= pe.name

	public def allocate() as void:
		assert owner
		init( owner.data.Semant, owner.total )

	public def prepare() as bool:
		if onUpdate and not onUpdate(obj):
			return false
		loadFake()
		return true

	public def loadFake()	as void:
		d = Dictionary[of int,int]()
		for fa in extList:
			vat = fa.vat.Data
			assert vat
			if fa.source >= 0:
				d.Clear()
				d[fa.source] = fa.dest
				vat.attribTrans(d)
			else: vat.attrib( fa.dest )

	public def listAttribs() as (int):
		return	array(sem.slot	for sem in data.Semant) + \
				array(ext.dest	for ext in extList)


#---------------------------------------#
#	PARTICLE CREATION CONTEXT			#
#---------------------------------------#

public class Context:
	# particle attribs
	public final	at_pos		= kri.Ant.Inst.slotParticles.getForced('pos')
	public final	at_rot		= kri.Ant.Inst.slotParticles.getForced('rot')
	public final	at_sys		= kri.Ant.Inst.slotParticles.getForced('sys')
	public final	at_sub		= kri.Ant.Inst.slotParticles.getForced('sub')
	public final	at_speed	= kri.Ant.Inst.slotParticles.getForced('speed')
	# particle ghost attribs
	public final	ghost_pos	= kri.Ant.Inst.slotAttributes.getForced('@pos')
	public final	ghost_rot	= kri.Ant.Inst.slotAttributes.getForced('@rot')
	public final	ghost_sys	= kri.Ant.Inst.slotAttributes.getForced('@sys')
	public final	ghost_sub	= kri.Ant.Inst.slotAttributes.getForced('@sub')
	# root shaders
	public final	sh_init	= Object.Load('/part/init_v')
	public final	sh_draw	= Object.Load('/part/draw/main_v')
	public final	sh_root	= Object.Load('/part/root_v')
	public final	sh_tool	= Object.Load('/part/tool_v')
	# fur shaders
	public final	sh_fur_init	= Object.Load('/part/fur/init_v')
	public final	sh_fur_root	= Object.Load('/part/fur/root_v')
	# born shaders
	public final	sh_born_instant	= Object.Load('/part/born/instant_v')
	public final	sh_born_static	= Object.Load('/part/born/static_v')
	public final	sh_born_time	= Object.Load('/part/born/time_v')
	# emit surface shaders
	public final	sh_surf_node	= Object.Load('/part/surf/node_v')
	public final	sh_surf_vertex	= Object.Load('/part/surf/vertex_v')
	public final	sh_surf_face	= Object.Load('/part/surf/face_v')
