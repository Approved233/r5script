




global function MobileRespawnBeacon_Init
global function OnWeaponActivate_mobile_respawn
global function OnWeaponDeactivate_mobile_respawn
global function OnWeaponPrimaryAttack_mobile_respawn
global function OnWeaponPrimaryAttackAnimEvent_mobile_respawn
global function GetRespawnStationUseTime_Mobile
global function MobileRespawn_SetDeployPositionValidationFunc

























global const string MOBILE_RESPAWN_BEACON_WEAPON_REF = "mp_ability_mobile_respawn_beacon"

const string MOBILE_RESPAWN_BEACON_STARTUP_SOUND = "Survival_MobileRespawnBeacon_Startup"
const string MOBILE_RESPAWN_INTERACT_PULSATE_SOUND = "Survival_RespawnEquippedBeacon_Full_Extended" 

const asset MOBILE_RESPAWN_BEACON_MODEL = $"mdl/props/mobile_respawn_beacon/mobile_respawn_beacon_animated.rmdl"
const asset MOBILE_RESPAWN_BEACON_EFFECT = $"P_mrb_holo"
const asset MOBILE_RESPAWN_BEACON_AR_DROP_POINT_FX = $"P_mrb_ar_drop_point"
const asset MOBILE_RESPAWN_BEACON_AB_FX = $"P_mrb_afterburner"
const asset MOBILE_RESPAWN_BEACON_AB_LIGHTS_FX = $"P_mrb_ab_lights"
const asset MOBILE_RESPAWN_BEACON_COUNTDOWN_PULSE_FX = $"P_mrb_countdown_pulse"
const asset MOBILE_RESPAWN_BEACON_SMOKE_TRAIL = $"P_mrb_trail_smoke_linger"
const bool MOBILE_RESPAWN_BEACON_DEBUG_DRAW = false
const float MOBILE_RESPAWN_BEACON_DESTROY_PROP_RADIUS = 25 	
const int MOBILE_RESPAWN_BEACON_BAD_AIRSPACE_RADIUS = 150 	
const string MOBILE_RESPAWN_BEACON_IMPACT_TABLE = "mobile_respawn_beacon"
const float MOBILE_RESPAWN_BEACON_SLOPED_LANDING_LIMIT = 0.3 	

const string MOBILE_RESPAWN_BEACON_MOVER_SCRIPTNAME = "mobile_respawn_beacon_mover"














struct
{
	bool mobileRespawnDeployed

	table< entity, vector > savedSlopeNormal









	CarePackagePlacementInfo functionref( entity ) deployPositionValidationFunc
} file




void function MobileRespawnBeacon_Init()
{
	PrecacheScriptString( MOBILE_RESPAWN_BEACON_SCRIPTNAME )

	SURVIVAL_Loot_RegisterConditionalCheck( MOBILE_RESPAWN_BEACON_WEAPON_REF, MobileRespawn_ConditionalCheck )
	PrecacheModel( MOBILE_RESPAWN_BEACON_MODEL )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_EFFECT )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_AR_DROP_POINT_FX )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_AB_FX )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_AB_LIGHTS_FX )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_COUNTDOWN_PULSE_FX )
	PrecacheParticleSystem( MOBILE_RESPAWN_BEACON_SMOKE_TRAIL )
	PrecacheImpactEffectTable( MOBILE_RESPAWN_BEACON_IMPACT_TABLE )
	PrecacheImpactEffectTable( "mobile_respawn_dust" )
	RegisterSignal( "MobileBeaconLanded" )
	MobileRespawn_SetDeployPositionValidationFunc( GetCarePackagePlacementInfo )









		RegisterSignal( "MobileRespawnPlacement" )

}

void function MobileRespawn_SetDeployPositionValidationFunc( CarePackagePlacementInfo functionref( entity ) validationFunc )
{
	file.deployPositionValidationFunc = validationFunc
}

void function OnWeaponActivate_mobile_respawn( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )



		if ( ownerPlayer == GetLocalViewPlayer() )
		{
			RunUIScript( "CloseSurvivalInventoryMenu" )
		}

		string name = weapon.GetWeaponClassName()








			{
				OnBeginPlacingMobileRespawn( weapon, ownerPlayer )

				if ( !InPrediction() ) 
					return
			}


	int skinIndex = weapon.GetSkinIndexByName( "mobile_respawn_beacon_clacker" )
	if ( skinIndex != -1 )
		weapon.SetSkin( skinIndex )
}

void function OnWeaponDeactivate_mobile_respawn( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )


		SetBeaconDeployed( false )
		OnEndPlacingMobileRespawn( ownerPlayer )
		if ( !InPrediction() ) 
			return

}













var function OnWeaponPrimaryAttack_mobile_respawn( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	CarePackagePlacementInfo placementInfo = file.deployPositionValidationFunc( ownerPlayer )

	if ( placementInfo.failed )
		return 0





























		SetBeaconDeployed( true )
		PlayerUsedOffhand( ownerPlayer, weapon )

		if ( weapon.GetWeaponPrimaryClipCount() <= 1 ) 
		{
			ownerPlayer.Signal( "MobileRespawnPlacement" )
		}








	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}









var function OnWeaponPrimaryAttackAnimEvent_mobile_respawn(entity ent, WeaponPrimaryAttackParams params)
{
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	

	return 0 
}

















float function GetRespawnStationUseTime_Mobile( entity ent )
{
	return 7.0
}


void function OnEndPlacingMobileRespawn( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "MobileRespawnPlacement" )
}



void function SetBeaconDeployed( bool state )
{
	file.mobileRespawnDeployed = state
}



entity function CreateProxy( asset modelName )

{
	entity modelEnt = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, modelName )
	modelEnt.kv.renderamt = 255
	modelEnt.kv.rendermode = 3
	modelEnt.kv.rendercolor = "255 255 255 255"

	modelEnt.Anim_Play( "ref" )
	modelEnt.Hide()

	return modelEnt
}



void function DestroyProxy( entity ent )
{
	Assert( IsNewThread(), "Must be threaded off" )
	ent.EndSignal( "OnDestroy" )

	if ( file.mobileRespawnDeployed )
		wait 0.225

	ent.Destroy()
}


bool function MobileRespawn_ConditionalCheck( string ref, entity player )
{
	return false
}


bool function MobileRespawnBeacon_PLV_FastMRB_Enabled()
{
	bool fastMRB_Enabled = GetCurrentPlaylistVarBool( "mobilerespawnbeacon_fastmrb_enabled", false )
	return( fastMRB_Enabled )
}





















































































































































































































































































































































































































































































void function MobileRespawnPlacement( entity weapon, entity player, asset modelName )
{
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "MobileRespawnPlacement" )

	entity beacon = CreateProxy( modelName )
	beacon.EnableRenderAlways()
	beacon.Show()
	DeployableModelHighlight( beacon )

	OnThreadEnd(
		function() : ( beacon )
		{
			if ( IsValid( beacon ) )
				thread DestroyProxy( beacon )

			HidePlayerHint( "#MOBILE_RESPAWN_HINT" )
		}
	)

	AddPlayerHint( 3.0, 0.25, $"", "#MOBILE_RESPAWN_HINT" )

	while ( true )
	{
		CarePackagePlacementInfo placementInfo = file.deployPositionValidationFunc( player )

		beacon.SetOrigin( placementInfo.origin )
		beacon.SetAngles( placementInfo.angles )

		if ( !placementInfo.failed )
			DeployableModelHighlight( beacon )
		else
			DeployableModelInvalidHighlight( beacon )

		if ( placementInfo.hide )
			beacon.Hide()
		else
			beacon.Show()

		WaitFrame()
	}
}



void function OnBeginPlacingMobileRespawn( entity weapon, entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread MobileRespawnPlacement( weapon, player, MOBILE_RESPAWN_BEACON_MODEL )
}


















































































































































































































































































































































































































































