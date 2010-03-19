﻿namespace kri.ani.data

import System.Collections.Generic

#---------------------
#	KEY: single curve point

public struct Key[of T(struct)]:
	public t	as single
	public co	as T
	public h1	as T
	public h2	as T
	

public interface IPlayer:
	def touch() as void

public interface IChannel:
	def update(pl as IPlayer, time as single) as void


#---------------------
#	CHANNEL[T]: generic channel data

public class Channel[of T(struct)](IChannel):
	public final kar	as (Key[of T])
	# proper callable definitions in generics depend on BOO-854
	public final fup	as callable	#(IPlayer,byte,T)
	public lerp			as callable	#(ref T, ref T,single) as T
	public bezier		as bool	= true
	public extrapolate	as bool	= false

	public def constructor(num as int, f as callable):
		kar = array[of Key[of T]](num)
		fup = f

	def IChannel.update(pl as IPlayer, time as single) as void:
		fup(pl, moment(time))
		
	public def moment(time as single) as T:
		assert lerp and kar.Length
		i = System.Array.FindIndex(kar) do(k as Key[of T]):
			return k.t > time	# ref causes BOO-1289
		if i<=0:
			a = kar[i]
			if extrapolate:
				if i: return lerp(a.co, a.h2, time - a.t)
				else: return lerp(a.co, a.h1, a.t - time)
			return a.co
		a,b = kar[i-1],kar[i]
		t = (time - a.t) / (b.t - a.t)
		if bezier:
			a1 = lerp(a.co, a.h2, t)
			b1 = lerp(b.h1, b.co, t)
			return lerp(a1, b1, t)
		return lerp(a.co, b.co, t)


#---------------------
#	RECORD: complete animation data
#	PLAYER: partial IPlayer implementation

public class Record:
	public final name		as string
	public final length		as single
	public final channels	= List[of IChannel]()
	public def constructor(str as string, t as single):
		name,length = str,t


public class Player(IPlayer):
	public final anims	= List[of Record]()
	def IPlayer.touch() as void:
		pass
	public def play(name as string) as Anim:
		rec = anims.Find({r| return r.name == name})
		return Anim(self,rec)


#---------------------
#	ANIM: universal animation

public class Anim( kri.ani.IBase ):
	public final player	as IPlayer
	public final record	as Record
	
	public def constructor(pl as IPlayer, rec as Record):
		player,record = pl,rec
	
	def kri.ani.IBase.onFrame(time as double) as uint:
		return 2	if not record
		return 1	if time > record.length
		for c in record.channels:
			c.update(player,time)
		player.touch()
		return 0
