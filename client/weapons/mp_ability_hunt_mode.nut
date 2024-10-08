global function OnWeaponPrimaryAttack_hunt_mode
global function MpAbilityHuntModeWeapon_Init
global function MpAbilityHuntModeWeapon_OnWeaponTossPrep
global function OnWeaponDeactivate_hunt_mode

#if DEV
global function GetBloodhoundColorCorrectionID
#endif

const float HUNT_MODE_DURATION = 30.0
const float HUNT_MODE_KNOCKDOWN_TIME_BONUS = 5.0
const int HUNT_MODE_KNOCKDOWN_HEAL_BONUS = 50 
const asset HUNT_MODE_ACTIVATION_SCREEN_FX = $"P_hunt_screen"
const asset HUNT_MODE_BODY_FX = $"P_hunt_body"

struct
{

		int colorCorrection = -1





} file

void function MpAbilityHuntModeWeapon_Init()
{








	RegisterSignal( "HuntMode_ForceAbilityStop" )
	RegisterSignal( "HuntMode_End" )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, StopHuntMode )


		RegisterSignal( "HuntMode_StopColorCorrection" )
		RegisterSignal( "HuntMode_StopActivationScreenFX" )
		
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )
		PrecacheParticleSystem( HUNT_MODE_ACTIVATION_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode, HuntMode_StartEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode, HuntMode_StopEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StopVisualEffect )


}


float function HuntMode_GetExtendedDuration()
{
	return GetCurrentPlaylistVarFloat( "bloodhound_ult_upgraded_duration", 40 )
}


float function HuntMode_GetDuration( entity player )
{
	float result = HUNT_MODE_DURATION










	if( PlayerHasPassive( player, ePassives.PAS_ULT_UPGRADE_ONE ) ) 
	{
		return HuntMode_GetExtendedDuration()
	}


	return result
}



























































































































































void function MpAbilityHuntModeWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.SetScriptTime0( 0.0 )













}


var function OnWeaponPrimaryAttack_hunt_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	
	HuntMode_Start( weaponOwner )

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}


void function OnWeaponDeactivate_hunt_mode( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()






}


void function HuntMode_Start( entity player )
{
	array<int> ids = []
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.threat_vision, 1.0 ) )
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.15 ) )

	float huntDuration = HuntMode_GetDuration( player )
	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode, 1.0, huntDuration, huntDuration ) )
	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode_visuals, 1.0, huntDuration, 5.0 ) )



























}


void function EndThreadOn_HuntCommon( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "BleedOut_OnStartDying" )




}







































































































































































































































































































































void function HuntMode_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	EndThreadOn_HuntCommon( player )
	player.EndSignal( "HuntMode_StopColorCorrection" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const LERP_IN_TIME = 0.0125    
	float startTime = Time()

	while ( true )
	{
		float weight = StatusEffect_GetSeverity( player, eStatusEffect.hunt_mode_visuals )
		
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )











		WaitFrame()
	}
}

void function HuntMode_StartEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StopEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturateOn()
	Chroma_StartHuntMode()
	thread HuntMode_UpdatePlayerScreenColorCorrection( ent )
	thread HuntMode_PlayActivationScreenFX( ent )
}

void function HuntMode_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturateOff()
	Chroma_EndHuntMode()
	ent.Signal( "HuntMode_StopColorCorrection" )
	ent.Signal( "HuntMode_StopActivationScreenFX" )
}

void function HuntMode_PlayActivationScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	EndThreadOn_HuntCommon( clientPlayer )

	entity viewPlayer = GetLocalViewPlayer()
	int fxid          = GetParticleSystemIndex( HUNT_MODE_ACTIVATION_SCREEN_FX )

	int fxHandle = StartParticleEffectOnEntity( viewPlayer, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( fxHandle, true )
	Effects_SetParticleFlag( fxHandle, PARTICLE_SCRIPT_FLAG_NO_DESATURATE, true )


	OnThreadEnd(
		function() : ( clientPlayer, fxHandle )
		{
			if ( IsValid( clientPlayer ) )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, false, true )
			}
		}
	)

	clientPlayer.WaitSignal( "HuntMode_StopActivationScreenFX" )
}



void function StopHuntMode()
{

		entity player = GetLocalViewPlayer()
		player.Signal( "HuntMode_ForceAbilityStop" )





}

#if DEV
int function GetBloodhoundColorCorrectionID()
{
	return file.colorCorrection
}
#endif
