﻿namespace kri.gen

import OpenTK
import System.Runtime.InteropServices


#----	COMMON DATA STORING & CREATION	----#

[StructLayout(LayoutKind.Sequential)]
public struct Vertex:
	public pos	as Vector4
	public rot	as Quaternion
	public def constructor(p as Vector4, q as Quaternion):
		pos,rot = p,q

[StructLayout(LayoutKind.Sequential)]
public struct VertexUV:
	public pos	as Vector4
	public rot	as Quaternion
	public uv	as Vector2


#----	RAW MESH DATA	----#

public struct Constructor:
	public v	as (Vertex)
	public i	as (ushort)
	
	# fill up the mesh data
	public def apply(m as kri.Mesh) as void:
		kri.vb.Array.Default.bind()
		if v:
			m.nVert = v.Length
			m.nPoly = m.nVert / m.polySize
			vbo = kri.vb.Attrib()
			vbo.init( v, false )
			kri.Help.enrich(vbo, 4, 'vertex','quat')
			m.vbo.Add(vbo)
		if i:
			m.nPoly = i.Length / m.polySize
			m.ind = kri.vb.Index()
			m.ind.init( i, false )
	
	# triangle mesh subdivision
	public def subDivide() as void:
		# it has to be triangle list! no check is possible here
		assert v and i and i.Length%3 == 0
		nPoly = i.Length / 3
		v2 = array[of Vertex]( v.Length + 3*nPoly )
		v.CopyTo(v2,0)
		i2 = array[of ushort]( 3*nPoly * 4 )
		# iterating over polygons
		def avg(ref a as Vertex, ref b as Vertex):
			return Vertex( Vector4.Lerp(a.pos,b.pos,0.5), a.rot )
		for j in range(nPoly):
			i0 = List[of ushort](i[j*3+k] for k in range(3)).ToArray()
			x = List[of Vertex](v[k] for k in i0).ToArray()
			j2 = v.Length + j*3
			List[of Vertex](avg(x[k],x[(k+1)%3]) for k in range(3)).CopyTo(v2,j2)
			j3 = 3*j*4
			(of ushort: j2+0,j2+1,j2+2) .CopyTo(i2,j3+0)
			(of ushort: i0[0],j2+0,j2+2).CopyTo(i2,j3+3)
			(of ushort: j2+0,i0[1],j2+1).CopyTo(i2,j3+6)
			(of ushort: j2+2,j2+1,i0[2]).CopyTo(i2,j3+9)
		i,v = i2,v2
