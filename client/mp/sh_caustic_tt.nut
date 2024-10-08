global function Caustic_TT_Init
global function Caustic_TT_RegisterNetworking
global function IsCausticTTEnabled
global function GetCausticTTCanisterFrameForLoot
global function AreCausticTTCanistersClosed
global function CausticTT_SetGasFunctionInvertedValue







global function Caustic_TT_ServerCallback_SetCanistersOpen
global function Caustic_TT_ServerCallback_SetCanistersClosed
global function Caustic_TT_ServerCallback_SetSwitchesEnabled
global function Caustic_TT_ServerCallback_SetSwitchesDisabled
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOn
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOff

const string CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT = "caustic_tt_floor_ambient_generic"
const string CAUSTIC_TT_TURBINE_SCRIPTNAME = "caustic_tt_turbine"


const string CAUSTIC_TT_SWITCH_SCRIPTNAME = "caustic_tt_switch"
const string CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME = "caustic_tt_canister_frame"

const float CANISTER_TIMER_START = 15.0
const float CANISTER_TIMER_END = 10.0

const int CANISTER_DISTANCE_FRAME_TO_LOOT_SQR = 4900









































































struct
{
	bool 				canistersClosed = true
	bool				switchesEnabled = true
	array < entity >	canisterFrames
	array < entity >	canisterSwitches
	array < entity >	windowHighlights
	array < string >	canisterLootRefs

	bool isGasFunctionInverted = false


		array < entity >	toxicWaterEmitters














} file

void function Caustic_TT_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

		AddCreateCallback( "prop_dynamic", CausticCanisterSwitchSpawned )





}

void function Caustic_TT_RegisterNetworking()
{
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersOpen" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersClosed" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetSwitchesEnabled" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetSwitchesDisabled" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOn" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOff" )
}


void function CausticCanisterSwitchSpawned( entity panel )
{
	if( panel.GetScriptName() != CAUSTIC_TT_SWITCH_SCRIPTNAME )
		return

	
	
	Caustic_TT_SetButtonUsable( panel )
}

void function Caustic_TT_SetButtonUsable( entity canisterSwitch )
{










		
		
		
		
		if( canisterSwitch.e.canUseEntityCallback != null )
			return


	SetCallback_CanUseEntityCallback( canisterSwitch, CanisterSwitch_CanUse )
	AddCallback_OnUseEntity_ClientServer( canisterSwitch, CanisterSwitch_OnUse )


		AddEntityCallback_GetUseEntOverrideText( canisterSwitch, GetCanisterSwitchUseTextOverride )

}

void function EntitiesDidLoad()
{
	if ( !IsCausticTTEnabled() )
		return

	PrecacheScriptString( "caustic_tt_loot" )
















		
		foreach ( entity emitter in GetEntArrayByScriptName( CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT ) )
			file.toxicWaterEmitters.append( emitter )

		
		foreach ( entity turbine in GetEntArrayByScriptName( CAUSTIC_TT_TURBINE_SCRIPTNAME ) )
		{
			entity turbineRotator = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", turbine.GetOrigin(), turbine.GetAngles() )
			turbine.SetParent( turbineRotator )
			turbineRotator.NonPhysicsRotate( < 0, 0, 1 >, 60 )
		}


	foreach ( entity canisterSwitch in GetEntArrayByScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME ) )
	{
		Caustic_TT_SetButtonUsable( canisterSwitch )
		file.canisterSwitches.append( canisterSwitch )
	}

	
	foreach ( entity canisterFrame in GetEntArrayByScriptName( CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME ) )
		file.canisterFrames.append( canisterFrame )


























































































































	if ( file.isGasFunctionInverted )
		thread CanisterSwitch_TrapActivate_Thread( null, true ) 
}

bool function CanisterSwitch_CanUse ( entity player, entity canisterSwitch, int useFlags )
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, canisterSwitch ) )
		return false

	return true
}


string function GetCanisterSwitchUseTextOverride( entity canisterSwitch )
{
	if ( file.switchesEnabled )
	{
		if ( !file.isGasFunctionInverted )
			return "#CAUSTIC_TT_SWITCH_ON"
		else
			return "#CAUSTIC_TT_SWITCH_ON_INVERTED"
	}

	return ""
}


void function CanisterSwitch_OnUse( entity canisterSwitch, entity player, int useInputFlags )
{
	if ( file.switchesEnabled && IsBitFlagSet( useInputFlags, USE_INPUT_LONG ) )
			thread CanisterSwitch_UseThink_Thread( canisterSwitch, player )
	else
	{



	}
}

void function CanisterSwitch_UseThink_Thread( entity ent, entity playerUser )
{
	ent.EndSignal( "OnDestroy" )

	ExtendedUseSettings settings
	settings.loopSound = "survival_titan_linking_loop"
	settings.successSound = "ui_menu_store_purchase_success"
	settings.duration = 1.0
	settings.successFunc = CanisterSwitch_ExtendedUseSuccess


		settings.icon = $""
		settings.hint = !file.isGasFunctionInverted ? Localize ( "#CAUSTIC_TT_ACTIVATE" ) : Localize ( "#CAUSTIC_TT_ACTIVATE_INVERTED" )
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = CanisterSwitch_DisplayRui


	waitthread ExtendedUse( ent, playerUser, settings )
}

void function CanisterSwitch_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{

		RuiSetString( rui, "holdButtonHint", settings.holdHint )
		RuiSetString( rui, "hintText", settings.hint )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", Time() + settings.duration )

}

void function CanisterSwitch_ExtendedUseSuccess( entity canisterSwitch, entity player, ExtendedUseSettings settings )
{
	if ( !file.switchesEnabled )
		return

	if ( !IsValid( player ) )
		return

	if ( !IsValid( canisterSwitch ) )
		return

	CanisterSwitches_Disabled()
	SetCanistersOpen()

	if ( !file.isGasFunctionInverted )
		thread CanisterSwitch_TrapActivate_Thread( player )
	else
		thread CanisterSwitch_TrapActivate_Inverted_Thread( player )
}

void function CanisterSwitch_TrapActivate_Thread( entity player, bool isInvertedSetup = false )
{






























	wait 2.0











	if ( isInvertedSetup )
		return

	wait 7.5






	wait 7.5 





	wait CANISTER_TIMER_END

	thread CanisterSwitch_TrapExpired_Thread()
}

void function CanisterSwitch_TrapExpired_Thread()
{








































	SetCanistersClosed()

	wait 2.0





	wait 5.0






	wait 3.0

	CanisterSwitches_Enabled()
}

const float CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN = 20.0
const float CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN_EXTENDED = 25.0
void function CanisterSwitch_TrapActivate_Inverted_Thread( entity player )
{
	bool useDefaultSFX = true


		if ( GameMode_IsActive( eGameModes.CONTROL ) )
			useDefaultSFX = false

















































	wait 7.0






	
	if ( useDefaultSFX )
	{
		wait CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN
	}
	else
	{
		wait CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN_EXTENDED
	}

	thread CanisterSwitch_TrapExpired_Inverted_Thread()
}

void function CanisterSwitch_TrapExpired_Inverted_Thread()
{
































	SetCanistersClosed()

	wait 2.0








	wait 5.0






	wait 3.0

	
	wait 30.0

	CanisterSwitches_Enabled()
}

void function CanisterSwitches_Disabled()
{











	file.switchesEnabled = false
}

void function CanisterSwitches_Enabled()
{

































}

void function SetCanistersClosed()
{
	file.canistersClosed = true








}

void function SetCanistersOpen()
{
	file.canistersClosed = false








}


























































































































































































































































































void function Caustic_TT_ServerCallback_SetCanistersOpen()
{
	file.canistersClosed = false
}

void function Caustic_TT_ServerCallback_SetCanistersClosed()
{
	file.canistersClosed = true
}

void function Caustic_TT_ServerCallback_SetSwitchesEnabled()
{
	file.switchesEnabled = true
}

void function Caustic_TT_ServerCallback_SetSwitchesDisabled()
{
	file.switchesEnabled = false
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOff()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( false )
	}
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOn()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( true )
	}
}


entity function GetCausticTTCanisterFrameForLoot( entity lootEnt )
{
	foreach ( canisterFrame in file.canisterFrames )
	{
		if ( IsValid( canisterFrame ) ) 
			if ( DistanceSqr( canisterFrame.GetOrigin(), lootEnt.GetOrigin() ) < CANISTER_DISTANCE_FRAME_TO_LOOT_SQR )
				return canisterFrame
	}

	return null
}

bool function AreCausticTTCanistersClosed( entity canisterPanel )
{
	return file.canistersClosed
}

















bool function IsCausticTTEnabled()
{
	if ( GetCurrentPlaylistVarBool( "caustic_tt_enabled", true ) )
	{
		return HasEntWithScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME )
	}

	return false
}


bool function CausticTT_IsGasFunctionInverted()
{
	return file.isGasFunctionInverted
}

void function CausticTT_SetGasFunctionInvertedValue( bool val )
{
	Assert( !Flag( "EntitiesDidLoad" ), "Caustic TT: Trying to set inverted gas function after initialization has been completed" )

	file.isGasFunctionInverted = val
}























