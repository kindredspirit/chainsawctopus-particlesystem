﻿namespace test

[System.STAThread]
def Main(argv as (string)):
	using ant = kri.Ant('kri.conf',0):
		view = kri.ViewScreen(8,0)
		rchain = kri.rend.Chain()
		view.ren = rchain
		rlis = rchain.renders
		
		rlis.Add( Link() )
		#rlis.Add( Offset() )
		rlis.Add( Read() )
		rlis.Add( Feedback(null) )
		
		ant.views.Add( view )
		ant.Run(1.0,1.0)