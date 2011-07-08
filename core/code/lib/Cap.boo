﻿namespace kri.lib

import OpenTK.Graphics.OpenGL

#-----------------------------------#
#	RENDER SYSTEM CAPABILITIES		#
#-----------------------------------#

public final class Capabilities:
	public final drawBuffers	as byte	
	public final multiSamples	as byte
	public final vertexAttribs	as byte
	public final colorAttaches	as byte
	public final textureUnits	as byte
	public final textureLayers	as ushort
	public final textureSize	as uint
	public final renderBufSize	as uint
	public final samplesColor	as ushort	= 0
	public final samplesInt		as ushort	= 0
	public final samplesDepth	as ushort	= 0
	public final elemIndices	as uint
	public final elemVertices	as uint
	public final contextVersion	as string
	public final shadingVersion	as string
	public final bones			as byte
	
	public static def Var(pn as GetPName) as int:
		val as int = -1
		GL.GetInteger(pn,val)
		return val
	
	public def constructor(gl3 as bool):
		contextVersion	= GL.GetString( StringName.Version )
		shadingVersion	= GL.GetString( StringName.ShadingLanguageVersion )
		drawBuffers		= Var( GetPName.MaxDrawBuffers )
		multiSamples	= Var( GetPName.MaxSamples )
		vertexAttribs	= Var( GetPName.MaxVertexAttribs )
		colorAttaches	= Var( GetPName.MaxColorAttachments )
		textureUnits	= Var( GetPName.MaxCombinedTextureImageUnits )
		textureLayers	= Var( GetPName.MaxArrayTextureLayers )
		textureSize		= Var( GetPName.MaxTextureSize )
		renderBufSize	= Var( GetPName.MaxRenderbufferSize )
		if gl3:
			samplesColor	= Var( GetPName.MaxColorTextureSamples )
			samplesInt		= Var( GetPName.MaxIntegerSamples )
			samplesDepth	= Var( GetPName.MaxDepthTextureSamples )
		elemIndices		= Var( GetPName.MaxElementsIndices )
		elemVertices	= Var( GetPName.MaxElementsVertices )
		vertComponents	= Var( GetPName.MaxVertexUniformComponents )
		bones = System.Math.Min( vertComponents>>3, 128 )