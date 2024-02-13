global function RTKSound_InitMetaData
global function RTKSound_OnUpdate
global function RTKSound_OnDestroy

global struct RTKSound_Properties
{
	string sound = ""
	bool play = false
	float delay = 0
}

struct PrivateData
{
	bool hasPlayed = false
}

void function RTKSound_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "RTKSound_OnDestroy" )
}

void function RTKSound_OnDestroy( rtk_behavior self )
{
	Signal( self, "RTKSound_OnDestroy" )
}

void function RTKSound_OnUpdate( rtk_behavior self, float dt )
{
	PrivateData p
	self.Private( p )

	string sound = self.PropGetString( "sound" )
	bool play = self.PropGetBool( "play" )
	float delay = self.PropGetFloat( "delay" )

	if( !play )
		p.hasPlayed = false

	if( sound != "" && play && !p.hasPlayed )
	{
		p.hasPlayed = true
		if ( delay < 0.01 ) 
			EmitUISound( sound )
		else
			thread RTKSound_PlayThread( self, sound, delay )
	}
}

void function RTKSound_PlayThread( rtk_behavior self, string sound, float delay )
{
	EndSignal( self, "RTKSound_OnDestroy" )

	rtk_panel panel = self.GetPanel()

	wait( delay )

	if ( IsValid( panel ) && panel.IsActiveInHierarchy() )
		EmitUISound( sound )
}