untyped


global function WeaponUtility_Init

global function ApplyVectorSpread
global function DebugDrawMissilePath
global function DegreesToTarget
global function EntityCanHaveStickyEnts
global function EntityShouldStick
global function EntityShouldStickEx
global function GetVectorFromPositionToCrosshair
global function GetVelocityForDestOverTime
global function GetPlayerVelocityForDestOverTime
global function InitMissileForRandomDriftForVortexLow
global function IsPilotShotgunWeapon
global function PlantStickyEntity
global function PlantStickyEntityOnConsistentSurface
global function PlantStickyEntityThatBouncesOffWalls
global function PlantStickyEntityOnWorldThatBouncesOffWalls
global function EnergyChargeWeapon_OnWeaponChargeLevelIncreased
global function EnergyChargeWeapon_OnWeaponChargeBegin
global function EnergyChargeWeapon_OnWeaponChargeEnd
global function Fire_EnergyChargeWeapon
global function FireHitscanShotgunBlast
global function FireProjectileShotgunBlast
global function ProjectileShotgun_GetOuterSpread
global function ProjectileShotgun_GetInnerSpread
global function FireProjectileBlastPattern
global function FireGenericBoltWithDrop
global function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player
global function OnWeaponActivate_updateViewmodelAmmo
global function WeaponCanCrit
global function GiveEMPStunStatusEffects
global function GetMaxTrackerCountForTitan
global function FireBallisticRoundWithDrop
global function DoesModExist
global function DoesModExistFromWeaponClassName
global function IsModActive
global function PlayerUsedOffhand
global function GetDistanceString
global function IsWeaponInSingleShotMode
global function IsWeaponInBurstMode
global function IsWeaponOffhand
global function IsWeaponInAutomaticMode
global function IsMeleeWeaponNotFists
global function OnWeaponReadyToFire_ability_tactical
global function GetMeleeWeapon
global function OnWeaponRegenEndGeneric
global function Ultimate_OnWeaponRegenBegin
global function OnWeaponActivate_RUIColorSchemeOverrides
global function PlayDelayedShellEject
global function IsABaseGrenade
global function HandleDisappearingParent
global function CalcProjectileTrajectory
global function SolveBallisticArc
global function GetCrosshairTargetData
global function GetCrosshairTargetDataAngles
global function AreAbilitiesSilenced
global function GetNeededEnergizeConsumableCount
global function HasEnoughEnergizeConsumable
global function OnWeaponEnergizedStart
global function IsWeaponSemiAuto
global function PlayerHasWeapon
global function PlayerCanUseWeapon
global function GetValidLootModsInstalled
global function GetNonInstallableWeaponMods
global function GetNonInstallableTrackableWeaponMods
global function GetWeaponClassName
global function GetWeaponMods
global function GetSlotForWeapon
global function CanAttachToWeapon
global function GetBaseWeaponRef
global function GetLockedSetsDisabledByCrafting
global function AttachmentPointSupported
global function GetAttachmentPointStyle
global function GetAttachmentsForPoint
global function HasWeapon
global function WeaponHasSameMods
global function GetWeaponIndex
global function SimpleShouldNotBlockReloadCallback


































global function UICallback_UpdateLaserSightColor


global function Weapon_AddSingleCharge


global function ServerCallback_SetWeaponPreviewState
global function ServerCallback_KineticLoaderReloadedThroughSlide
global function ServerCallback_KineticLoaderReloadedThroughSlideEnd
global function ApplyKineticLoaderFunctionality
global function ServerToClient_Activate_Smart_Reload


global function OnWeaponTryEnergize

global function OnWeaponAttemptOffhandSwitch_Never

#if DEV
global function DEV_DumpStickinessTable
global function DevPrintAllStatusEffectsOnEnt
#endif














































global function GlobalClientEventHandler
global function UpdateViewmodelAmmo
global function IsOwnerViewPlayerFullyADSed
global function GetAmmoColorByType
global function TryCharacterButtonCommonReadyChecks


global function ShouldShowADSScopeView
global function HasFullscreenScope

global function AddCallback_OnPlayerAddedWeaponMod
global function AddCallback_OnPlayerRemovedWeaponMod
global function AddCallback_OnPlayerAddedToggleWeaponMod
global function AddCallback_OnPlayerRemovedToggleWeaponMod

global function CodeCallback_OnPlayerAddedWeaponMod
global function CodeCallback_OnPlayerRemovedWeaponMod
global function CodeCallback_OnPlayerAddedToggleWeaponMod
global function CodeCallback_OnPlayerRemovedToggleWeaponMod

global function EnergyChoke_OnWeaponModCommandCheckMods


global function DisplayCenterDotRui


global function IsTurretWeapon
global function IsHMGWeapon
global function IsMeleeWeapon


global function GetInfiniteAmmo










global function CodeCallback_GetIsModOptic


global struct MarksmansTempoSettings
{
	int   requiredShots
	float graceTimeBuildup
	float graceTimeInTempo
	int  fadeoffMatchGraceTime
	float fadeoffOnPerfectMomentHit
	float fadeoffOnFire

	string weaponDeactivateSignal
}
global const string MOD_MARKSMANS_TEMPO = "hopup_marksmans_tempo"
global const string MOD_MARKSMANS_TEMPO_ACTIVE = "marksmans_tempo_active"
global const string MOD_MARKSMANS_TEMPO_BUILDUP = "marksmans_tempo_buildup"
global const string MARKSMANS_TEMPO_REQUIRED_SHOTS_SETTING = "marksmans_tempo_required_shots"
global const string MARKSMANS_TEMPO_GRACE_TIME_SETTING = "marksmans_tempo_grace_time"
global const string MARKSMANS_TEMPO_GRACE_TIME_IN_TEMPO_SETTING = "marksmans_tempo_grace_time_in_tempo"
global const string MARKSMANS_TEMPO_FADEOFF_MATCH_GRACE_TIME = "marksmans_tempo_fadeoff_match_grace_time"
global const string MARKSMANS_TEMPO_FADEOFF_ON_PERFECT_MOMENT_SETTING = "marksmans_tempo_fadeoff_on_perfect_moment"	
global const string MARKSMANS_TEMPO_FADEOFF_ON_FIRE_SETTING = "marksmans_tempo_fadeoff_on_fire"
global const string MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT = "marksmans_tempo_fadeoff_abort"
global const string ENERGIZE_STATUS_RUI_ABORT_SIGNAL = "EnergizRuiThinkAbortSignal"
global const string WEAPON_CHARGED_RUI_ABORT_SIGNAL = "ChargedRuiThinkAbortSignal"
global function MarksmansTempo_Validate
global function MarksmansTempo_OnActivate
global function MarksmansTempo_OnDeactivate
global function MarksmansTempo_AbortFadeoff
global function MarksmansTempo_SetPerfectTempoMoment
global function MarksmansTempo_OnFire
global function MarksmansTempo_RemoveTempo
global function MarksmansTempo_ClearTempo



global enum eShatterRoundsTypes
{
	STANDARD,
	SHATTER_TRI,

	_count
}
global const string SHATTER_ROUNDS_HOPUP_MOD = "hopup_shatter_rounds"
global const string SHATTER_ROUNDS_ALTFIRE_MOD = "altfire_shatter"
global const string SHATTER_ROUNDS_HIPFIRE_MOD = "shatter_rounds_hipfire"
global const string SHATTER_ROUNDS_THINK_END_SIGNAL = "shatter_rounds_think_end"
global const string SHATTER_ROUNDS_ADS_THINK_THREAD_ABORT_SIGNAL = "shatter_rounds_ads_think_end"
global function ShatterRounds_UpdateShatterRoundsThink







global const string SMART_RELOAD_HOPUP = "hopup_smart_reload"
global const string LMG_FAST_RELOAD_MOD = "fast_reload_mod"
global const string LMG_OVERLOADED_AMMO_MOD = "overloaded_ammo"
global const string END_SMART_RELOAD = "end_smart_reload_functionality"
global const string ULTIMATE_ACTIVE_MOD_STRING = "ultimate_active"

const vector LOWAMMO_UI_COLOR = <0, 255, 0> / 255.0
const vector OVERLOADAMMO_UI_COLOR = <0, 200, 200> / 255.0
const vector OUTOFAMMO_UI_COLOR = <255, 65, 65> / 255.0
const vector NORMALAMMO_UI_COLOR = ZERO_VECTOR

global const string OVERLOAD_AMMO_SETTING = "smart_reload_overload_ammo_required"
global const string LOW_AMMO_FAC_SETTING = "low_ammo_fraction"
global const string SMART_RELOAD_LOW_AMMO_FRAC_SETTING = "smart_reload_low_ammo_fraction"

global struct SmartReloadSettings
{
	int OverloadedAmmo
	float LowAmmoFrac
}

const int MIN_AMMO_REQUIRED = 0
const int MAX_AMMO_REQUIRED = 11

global function OnWeaponActivate_Smart_Reload
global function OnWeaponDeactivate_Smart_Reload
global function OnWeaponReload_Smart_Reload


global struct KineticLoaderSettings
{
	float  loadDelay
	float  additiveDelay
	float  maxDelay
	int    ammoToLoad
	string kineticLoaderSFX
}

global function OnWeaponActivate_Kinetic_Loader
global function OnWeaponDeactivate_Kinetic_Loader

global const string END_KINETIC_LOADER = "end_kinetic_loader_functionality"
global const string KINETIC_LOADER_HOPUP = "hopup_kinetic_loader"
global const string END_KINETIC_LOADER_CHOKE = "end_kinetic_loader_choke_functionality"

global const string KINETIC_LOAD_DELAY_SETTING = "kinetic_load_delay"
global const string KINETIC_LOAD_ADDITIVE_DELAY_SETTING = "kinetic_load_additive_delay"
global const string KINETIC_LOAD_MAX_DELAY_SETTING = "kinetic_load_max_delay"
global const string KINETIC_AMMO_TO_LOAD_SETTING = "kinetic_ammo_to_load"
global const string KINETIC_LOAD_SFX_SETTING = "kinetic_load_sfx"

global const string END_KINETIC_LOADER_RUI = "end_kinetic_loader_functionality"











global const bool PROJECTILE_PREDICTED = true
global const bool PROJECTILE_NOT_PREDICTED = false

global const bool PROJECTILE_LAG_COMPENSATED = true
global const bool PROJECTILE_NOT_LAG_COMPENSATED = false

global const PRO_SCREEN_IDX_MATCH_KILLS = 1
global const PRO_SCREEN_IDX_AMMO_COUNTER_OVERRIDE_HACK = 2

global const int DAMAGEARROW_WP_INT_INDEX_ID = 0
global const int DAMAGEARROW_WP_INT_INDEX_TEAM = 1
global const int DAMAGEARROW_WP_INT_INDEX_VISIBILITY_TYPE = 2

global const int DAMAGEARROW_WP_ENT_OWNER = 0





const float DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC = 0.4
const bool DEBUG_PROJECTILE_BLAST = false

const float EMP_SEVERITY_SLOWTURN = 0.7
const float EMP_SEVERITY_SLOWMOVE = 0.50
const float LASER_STUN_SEVERITY_SLOWTURN = 0.4
const float LASER_STUN_SEVERITY_SLOWMOVE = 0.30

global const asset FX_EMP_BODY_HUMAN = $"P_emp_body_human"
global const asset FX_EMP_BODY_TITAN = $"P_emp_body_titan"
const SOUND_EMP_REBOOT_SPARKS = "marvin_weld"
const FX_EMP_REBOOT_SPARKS = $"weld_spark_01_sparksfly"
const EMP_GRENADE_BEAM_EFFECT = $"wpn_arc_cannon_beam"
const DRONE_REBOOT_TIME = 5.0
const GUNSHIP_REBOOT_TIME = 5.0

const bool DEBUG_BURN_DAMAGE = false

const float BOUNCE_STUCK_DISTANCE = 5.0

const float GOLD_MAG_TIME_BEFORE_STOWED_RELOAD = 5.0

const int ITEM_STICKS = 1
const int ITEM_NOT_FOUND_STICKINESS = -1

global const string ARROWS_UNSTICK_SIGNAL = "arrows_unstick"

global struct RadiusDamageData
{
	int   explosionDamage
	int   explosionDamageHeavyArmor
	float explosionRadius
	float explosionInnerRadius
}

global struct EnergyChargeWeaponData
{
	string fx_barrel_glow_attach
	asset  fx_barrel_glow_final_1p
	asset  fx_barrel_glow_final_3p
}









































global struct ArcSolution
{
	bool valid
	vector fire_velocity
	float duration
}

global struct CrosshairTargetData
{
	bool inRange
	vector crosshairStart
	vector groundTarget
	vector groundTargetNormal
	vector airburstTarget
	float distanceToTarget
	vector directionToTarget
}

struct
{




















		var satchelHintRUI = null


	array<void functionref( entity, entity, string )> playerAddedWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerRemovedWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerAddedToggleWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerRemovedToggleWeaponModCallbacks


		table < entity, bool > weaponReloadedThroughSlideTable
		table < entity, int > weaponAmmoToLoadTotalTable


	table< string, table <string, int> > throwableItemStickinessTable

	array<string>				 nonInstalledModsTracked
} file

global int HOLO_PILOT_TRAIL_FX



StringSet STICKY_CLASSES = {
	worldspawn = IN_SET,
	player = IN_SET,
	prop_dynamic = IN_SET,
	prop_script = IN_SET,
	prop_death_box = IN_SET,
	func_brush = IN_SET,
	func_brush_lightweight = IN_SET,
	phys_bone_follower = IN_SET,
	door_mover = IN_SET,
	prop_door = IN_SET,
	script_mover = IN_SET,
	player_vehicle = IN_SET,
	turret = IN_SET,
	prop_loot_grabber = IN_SET,
	prop_lootroller = IN_SET,
}

void function WeaponUtility_Init()
{
	level.trapChainReactClasses <- {}
	level.trapChainReactClasses[ "mp_weapon_frag_grenade" ]            <- true
	
	
	

	
	RegisterSignal( "EMP_FX" )
	RegisterSignal( "ArcStunned" )
	RegisterSignal( "CleanupPlayerPermanents" )
	RegisterSignal( "PlayerChangedClass" )
	RegisterSignal( "OnSustainedDischargeEnd" )
	RegisterSignal( "EnergyWeapon_ChargeStart" )
	RegisterSignal( "EnergyWeapon_ChargeReleased" )

	RegisterSignal( "GoldMagPerkEnd" )

	RegisterSignal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )

	RegisterSignal ( END_SMART_RELOAD )

	RegisterSignal ( END_KINETIC_LOADER )
	RegisterSignal ( END_KINETIC_LOADER_CHOKE )
	Remote_RegisterClientFunction( "ServerCallback_KineticLoaderReloadedThroughSlide", "entity", "int", 0, 32 )
	Remote_RegisterClientFunction( "ServerCallback_KineticLoaderReloadedThroughSlideEnd", "entity" )
	Remote_RegisterClientFunction( "ApplyKineticLoaderFunctionality", "entity" , "entity" )
	Remote_RegisterClientFunction( "ServerToClient_Activate_Smart_Reload", "entity" , "int", 0, 64, "float", 0.0, 1.0, 32 )



	Remote_RegisterServerFunction( "ClientCallback_UpdateLaserSightColor" )

	RegisterSignal ( END_KINETIC_LOADER_RUI )







	PrecacheParticleSystem( EMP_GRENADE_BEAM_EFFECT )
	PrecacheParticleSystem( FX_EMP_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_BODY_HUMAN )
	PrecacheParticleSystem( FX_EMP_REBOOT_SPARKS )

	PrecacheImpactEffectTable( CLUSTER_ROCKET_FX_TABLE )




























	HOLO_PILOT_TRAIL_FX = PrecacheParticleSystem( $"P_ar_holopilot_trail" )

	RegisterSignal( SHATTER_ROUNDS_THINK_END_SIGNAL )




	AddCallback_OnPlayerAddedToggleWeaponMod( ShatterRounds_OnPlayerAddedWeaponMod )
	AddCallback_OnPlayerRemovedToggleWeaponMod( ShatterRounds_OnPlayerRemovedWeaponMod )

	InitThrowableItemStickinessDatatable()

	file.nonInstalledModsTracked = [ DRAGON_LMG_ENERGIZED_MOD, "altfire_double_tap", "akimbo_active", "akimbo_offhand", "akimbo_disable" ]
}

const asset THROWABLE_ITEM_STICKINESS_DATATABLE = $"datatable/throwable_item_stickiness.rpak"
const int ENT_NAME_COL = 0

void function InitThrowableItemStickinessDatatable()
{
	array< string > throwableItems = [
		VOID_RING_WEAPON_REF, BUBBLE_BUNKER_WEAPON_NAME, ECHO_LOCATOR_WEAPON_NAME,
		"mp_weapon_jump_pad", "mp_ability_horizon_tac_space_elevator", CAUSTIC_DIRTY_BOMB_WEAPON_CLASS_NAME,
		GRENADE_EMP_WEAPON_NAME, GUNGAME_THROWING_KNIFE_WEAPON_NAME, RIOT_DRILL_SCRIPT_NAME,
		"mp_weapon_cluster_bomb_launcher", "mp_ability_debuff_zone", SPIKE_STRIP_WEAPON_NAME

		TRANSPORT_PORTAL_WEAPON_NAME

	]

	var dataTable = GetDataTable( THROWABLE_ITEM_STICKINESS_DATATABLE )
	int numRows = GetDataTableRowCount( dataTable )

	foreach ( string item in throwableItems )
	{
		table< string, int > columnTable
		int col = GetDataTableColumnByName( dataTable, item )

		Assert( col >= 0 )





		for ( int j = 0; j < numRows; j++ )
		{
			string entName = GetDataTableString( dataTable, j, ENT_NAME_COL )
			int value = int( GetDataTableString( dataTable, j, col ) )

			Assert( !(entName in columnTable), "Ent " + entName +" already in stickiness table! There is a duplicate row" )

			columnTable[ entName ] <- value
		}

		file.throwableItemStickinessTable[ item ] <- columnTable
	}
}




void function GlobalClientEventHandler( entity weapon, string name )
{
	if ( name == "ammo_update" )
		UpdateViewmodelAmmo( false, weapon )

	if ( name == "ammo_full" )
		UpdateViewmodelAmmo( true, weapon )
}

void function UpdateViewmodelAmmo( bool forceFull, entity weapon )
{
	Assert( weapon != null ) 

	if ( !IsValid( weapon ) )
		return
	if ( !IsLocalViewPlayer( weapon.GetWeaponOwner() ) )
		return

	int bodyGroupCount = weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ammo_index_count )
	if ( bodyGroupCount <= 0 )
		return

	int rounds                = weapon.GetWeaponPrimaryClipCount()
	int maxRoundsForClipSize  = weapon.GetWeaponPrimaryClipCountMax()
	int maxRoundsForBodyGroup = (bodyGroupCount - 1)
	int maxRounds             = minint( maxRoundsForClipSize, maxRoundsForBodyGroup )

	if ( forceFull || (rounds > maxRounds) )
		rounds = maxRounds

	
	weapon.SetViewmodelAmmoModelIndex( rounds )
}


void function OnWeaponActivate_updateViewmodelAmmo( entity weapon )
{

		UpdateViewmodelAmmo( false, weapon )

}



void function OnWeaponActivate_RUIColorSchemeOverrides( entity weapon )
{



}



























int function Fire_EnergyChargeWeapon( entity weapon, WeaponPrimaryAttackParams attackParams, EnergyChargeWeaponData chargeWeaponData, bool playerFired = true, float patternScale = 1.0, bool ignoreSpread = true )
{
	int chargeLevel = EnergyChargeWeapon_GetChargeLevel( weapon )
	
	if ( chargeLevel == 0 )
		return 0

	
	float spreadChokeFrac = 1.0
	
	switch( chargeLevel )
	{
		case 1:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_1" ) )
			break

		case 2:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_2" ) )
			break

		case 3:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_3" ) )
			break

		case 4:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_4" ) )
			break

		default:
			Assert( false, "chargeLevel " + chargeLevel + " doesn't have matching weaponsetting for projectile_spread_choke_frac_" + chargeLevel )
	}
	patternScale *= spreadChokeFrac

	float speedScale = 1.0
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	if ( weapon.IsChargeWeapon() )
		EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


int function EnergyChargeWeapon_GetChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 1

	if ( !weapon.IsReadyToFire() )
		return 0

	if ( !weapon.IsChargeWeapon() )
		return 1

	int chargeLevel = weapon.GetWeaponChargeLevel()
	return chargeLevel
}


bool function EnergyChargeWeapon_OnWeaponChargeLevelIncreased( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{

		if ( InPrediction() && !IsFirstTimePredicted() )
			return true






	int level    = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	string tickSound
	string tickSound_3p

	if ( level == maxLevel )
	{
		tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final" ) )
		tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final_3p" ) )
	}
	else
	{
		switch ( level )
		{
			case 1:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1_3p" ) )

				break

			case 2:
				if ( chargeWeaponData.fx_barrel_glow_attach != "" )
					weapon.PlayWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p, chargeWeaponData.fx_barrel_glow_attach )

				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2_3p" ) )

				break

			case 3:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3_3p" ) )
				break
		}
	}

	if ( tickSound != "" || tickSound_3p != "" )
		weapon.EmitWeaponSound_1p3p( tickSound, tickSound_3p )

	return true
}


void function EnergyChargeWeapon_StopCharge( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	if ( chargeWeaponData.fx_barrel_glow_attach != "" )
		weapon.StopWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p )

	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) ) )
	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) ) )


		
		float chargeTime          = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		int chargeLevels          = weapon.GetWeaponSettingInt( eWeaponVar.charge_levels )
		int chargeLevelBase       = weapon.GetWeaponSettingInt( eWeaponVar.charge_level_base )
		float chargeLevelsReduced   = (chargeLevels - chargeLevelBase).tofloat()
		float weaponMinChargeTime = 0.0

		if ( chargeLevelsReduced > 0.0 )
		{
			weaponMinChargeTime = chargeTime / chargeLevelsReduced
		}

		if ( Time() - weapon.w.startChargeTime >= weaponMinChargeTime )
		{
			weapon.EmitWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_end" ) ) )
		}







}


bool function EnergyChargeWeapon_OnWeaponChargeBegin( entity weapon )
{
	weapon.Signal( "EnergyWeapon_ChargeStart" )

	if ( weapon.GetWeaponChargeFraction() == 0 )
	{
		weapon.w.startChargeTime = Time()

		string chargeStart    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start" ) )
		string chargeStart_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start_3p" ) )
		weapon.EmitWeaponSound_1p3p( chargeStart, chargeStart_3p )
	}

	string chargeLoop    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) )
	string chargeLoop_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) )
	weapon.EmitWeaponSound_1p3p( chargeLoop, chargeLoop_3p )

	return true
}


void function EnergyChargeWeapon_OnWeaponChargeEnd( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	
	weapon.Signal( "EnergyWeapon_ChargeReleased" )

	thread EnergyChargeWeapon_StopCharge_Think( weapon, chargeWeaponData )
}


void function EnergyChargeWeapon_StopCharge_Think( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "EnergyWeapon_ChargeStart" )
	weapon.EndSignal( "EnergyWeapon_ChargeReleased" )

	while ( true )
	{
		WaitFrame()

		if ( EnergyChargeWeapon_GetChargeLevel( weapon ) <= 1 )
			break
	}

	EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )
}


void function FireHitscanShotgunBlast( entity weapon, vector pos, vector dir, int numBlasts, int damageType, float damageScaler = 1.0, float ornull maxAngle = null, float ornull maxDistance = null )
{
	Assert( numBlasts > 0 )
	int numBlastsOriginal = numBlasts

	






	if ( maxDistance == null )
		maxDistance = weapon.GetMaxDamageFarDist()
	expect float( maxDistance )

	if ( maxAngle == null )
		maxAngle = weapon.GetAttackSpreadAngle() * 0.5
	expect float( maxAngle )

	entity owner                  = weapon.GetWeaponOwner()
	array<entity> ignoredEntities = [ owner ]
	int traceMask                 = TRACE_MASK_SHOT
	int visConeFlags              = VIS_CONE_ENTS_TEST_HITBOXES | VIS_CONE_ENTS_CHECK_SOLID_BODY_HIT | VIS_CONE_ENTS_APPOX_CLOSEST_HITBOX | VIS_CONE_RETURN_HIT_VORTEX

	entity antilagPlayer
	if ( owner.IsPlayer() )
	{
		if ( owner.IsPhaseShifted() )
			return

		antilagPlayer = owner
	}

	
	Assert( maxAngle > 0.0, "JFS returning out at this instance. We need to investigate when a valid mp_titanweapon_laser_lite weapon returns 0 spread" )
	if ( maxAngle == 0.0 )
		return

	array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( pos, dir, maxDistance, (maxAngle * 1.1), ignoredEntities, traceMask, visConeFlags, antilagPlayer, weapon )
	foreach ( result in results )
	{
		float angleToHitbox = 0.0
		if ( !result.solidBodyHit )
			angleToHitbox = DegreesToTarget( pos, dir, result.approxClosestHitboxPos )

		numBlasts -= HitscanShotgunBlastDamageEntity( weapon, pos, dir, result, angleToHitbox, maxAngle, numBlasts, damageType, damageScaler )
		if ( numBlasts <= 0 )
			break
	}

	
	owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return

	
	const int MAX_TRACERS = 16
	bool didHitAnything   = ((numBlastsOriginal - numBlasts) != 0)
	bool doTraceBrushOnly = (!didHitAnything)
	if ( numBlasts > 0 )
	{
		WeaponFireBulletSpecialParams fireBulletParams
		fireBulletParams.pos = pos
		fireBulletParams.dir = dir
		fireBulletParams.bulletCount = minint( numBlasts, MAX_TRACERS )
		fireBulletParams.scriptDamageType = damageType
		fireBulletParams.skipAntiLag = false
		fireBulletParams.dontApplySpread = false
		fireBulletParams.doDryFire = true
		fireBulletParams.noImpact = false
		fireBulletParams.noTracer = false
		fireBulletParams.activeShot = false
		fireBulletParams.doTraceBrushOnly = doTraceBrushOnly
		weapon.FireWeaponBullet_Special( fireBulletParams )
	}
}


vector function ApplyVectorSpread( vector vecShotDirection, float spreadDegrees, float bias = 1.0 )
{
	vector angles   = VectorToAngles( vecShotDirection )
	vector vecUp    = AnglesToUp( angles )
	vector vecRight = AnglesToRight( angles )

	float sinDeg = deg_sin( spreadDegrees / 2.0 )

	
	float x
	float y
	float z

	if ( bias > 1.0 )
		bias = 1.0
	else if ( bias < 0.0 )
		bias = 0.0

	
	float shotBiasMin = -1.0
	float shotBiasMax = 1.0

	
	float shotBias = ((shotBiasMax - shotBiasMin) * bias) + shotBiasMin
	float flatness = (fabs( shotBias ) * 0.5)

	while ( true )
	{
		x = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		y = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		if ( shotBias < 0 )
		{
			x = (x >= 0) ? 1.0 - x : -1.0 - x
			y = (y >= 0) ? 1.0 - y : -1.0 - y
		}
		z = x * x + y * y

		if ( z <= 1 )
			break
	}

	vector addX        = vecRight * (x * sinDeg)
	vector addY        = vecUp * (y * sinDeg)
	vector m_vecResult = vecShotDirection + addX + addY

	return m_vecResult
}


float function DegreesToTarget( vector origin, vector forward, vector targetPos )
{
	vector dirToTarget = targetPos - origin
	dirToTarget = Normalize( dirToTarget )
	float dot         = DotProduct( forward, dirToTarget )
	float degToTarget = (acos( dot ) * 180 / PI)

	return degToTarget
}


const SHOTGUN_ANGLE_MIN_FRACTION = 0.1
const SHOTGUN_ANGLE_MAX_FRACTION = 1.0
const SHOTGUN_DAMAGE_SCALE_AT_MIN_ANGLE = 0.8
const SHOTGUN_DAMAGE_SCALE_AT_MAX_ANGLE = 0.1

int function HitscanShotgunBlastDamageEntity( entity weapon, vector barrelPos, vector barrelVec, VisibleEntityInCone result, float angle, float maxAngle, int numPellets, int damageType, float damageScaler )
{
	entity target = result.ent

	
	if ( !target.IsTitan() && damageScaler > 1 )
		damageScaler = max( damageScaler * 0.4, 1.5 )

	entity owner = weapon.GetWeaponOwner()
	
	if ( !IsValid( target ) || !IsValid( owner ) )
		return 0

	
	vector hitLocation = result.visiblePosition
	vector vecToEnt    = (hitLocation - barrelPos)
	vecToEnt.Norm()
	if ( Length( vecToEnt ) == 0 )
		vecToEnt = barrelVec

	
	WeaponFireBulletSpecialParams fireBulletParams
	fireBulletParams.pos = barrelPos
	fireBulletParams.dir = vecToEnt
	fireBulletParams.bulletCount = 1
	fireBulletParams.scriptDamageType = damageType
	fireBulletParams.skipAntiLag = true
	fireBulletParams.dontApplySpread = true
	fireBulletParams.doDryFire = true
	fireBulletParams.noImpact = false
	fireBulletParams.noTracer = false
	fireBulletParams.activeShot = false
	fireBulletParams.doTraceBrushOnly = false
	weapon.FireWeaponBullet_Special( fireBulletParams ) 



















































	return 1
}


void function FireProjectileShotgunBlast( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, float outerSpread, float innerSpread, int numProjectiles )
{
	vector vecFwd   = attackParams.dir
	vector vecRight = AnglesToRight( VectorToAngles( attackParams.dir ) )

	array<vector> spreadVecs = GetProjectileShotgunBlastVectors( attackParams.pos, vecFwd, vecRight, outerSpread, innerSpread, numProjectiles )

	for ( int i = 0; i < spreadVecs.len(); i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool ignoreSpread = true  
		bool deferred     = i > (spreadVecs.len() / 2)
		entity bolt       = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileShotgunBlastVectors( vector pos, vector forward, vector right, float outerSpread, float innerSpead, int numSegments )
{
#if DEBUG_PROJECTILE_BLAST
		DebugDrawLine( pos, pos + forward * 250, COLOR_RED, true, 3.0 )
		array<vector> outerVecs
		array<vector> innerVecs
#endif

	int numRadialSegments = numSegments - 1

	float degPerSegment = 360.0 / numRadialSegments
	array<vector> randVecs

	
	for ( int i = 0 ; i < numRadialSegments ; i++ )
	{
		vector randVec = VectorRotateAxis( forward, right, RandomFloatRange( innerSpead, outerSpread ) )
		randVec = VectorRotateAxis( randVec, forward, RandomFloatRange( degPerSegment * i, degPerSegment * (i + 1) ) )
		randVec.Norm()
		randVecs.append( randVec )

#if DEBUG_PROJECTILE_BLAST
			vector innerVec = VectorRotateAxis( forward, right, innerSpead )
			innerVec = VectorRotateAxis( innerVec, forward, degPerSegment * i )
			innerVec.Norm()
			innerVecs.append( innerVec )

			vector outerVec = VectorRotateAxis( forward, right, outerSpread )
			outerVec = VectorRotateAxis( outerVec, forward, degPerSegment * i )
			outerVec.Norm()
			outerVecs.append( outerVec )
#endif
	}

	
	
	
	
	

	
	randVecs.append( forward )

#if DEBUG_PROJECTILE_BLAST
		for ( int i = 0 ; i < numRadialSegments ; i++ )
		{
			vector o1 = pos + outerVecs[i] * 250
			vector o2 = (i == numRadialSegments - 1) ? pos + outerVecs[0] * 250 : pos + outerVecs[i + 1] * 250
			vector i1 = pos + innerVecs[i] * 250
			vector i2 = (i == numRadialSegments - 1) ? pos + innerVecs[0] * 250 : pos + innerVecs[i + 1] * 250

			DebugDrawLine( o1, o2, COLOR_YELLOW, true, 3.0 )
			DebugDrawLine( i1, i2, COLOR_YELLOW, true, 3.0 )
			DebugDrawLine( i1, o1, COLOR_YELLOW, true, 3.0 )
		}

		foreach ( vector vec in randVecs )
		{
			DebugDrawSphere( pos + vec * 250, 1.0, COLOR_RED, true, 3.0, 3 )
		}
#endif

	return randVecs
}


float function ProjectileShotgun_GetOuterSpread( entity weapon )
{
	return weapon.GetAttackSpreadAngle()
}


float function ProjectileShotgun_GetInnerSpread( entity weapon )
{
	float innerSpread = 0

	var innerSpreadVar = expect float ornull( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )
	if ( innerSpreadVar == null )
		innerSpread = ProjectileShotgun_GetOuterSpread( weapon ) * DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC
	else
		innerSpread = expect float ( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )

	return innerSpread
}


void function FireProjectileBlastPattern( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, array<vector> blastPattern, float patternScale = 1.0, bool ignoreSpread = true )
{
	if ( !IsValid( weapon ) )
		return

	int projectilesPerShot = weapon.GetProjectilesPerShot()
	int patternLength      = blastPattern.len()
	Assert( projectilesPerShot <= patternLength, "Not enough blast pattern points (" + patternLength + ") for " + projectilesPerShot + " projectiles per shot" )

	float defaultPatternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_default_scale" ) )
	patternScale *= defaultPatternScale
#if DEBUG_PROJECTILE_BLAST
		printt( "blast pattern scale:", defaultPatternScale )
#endif

	array<vector> scaledBlastPattern = clone blastPattern

	if ( patternScale != 1.0 )
	{
		for ( int i = 0; i < scaledBlastPattern.len(); i++ )
		{
			scaledBlastPattern[i] *= patternScale
		}
	}

	float patternZeroDistance = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_zero_distance" ) )

	array<vector> spreadVecs = GetProjectileBlastPatternVectors( attackParams, scaledBlastPattern, patternZeroDistance )

	for ( int i = 0; i < projectilesPerShot; i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool deferred = i > (spreadVecs.len() / 2)
		entity bolt   = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileBlastPatternVectors( WeaponPrimaryAttackParams attackParams, array<vector> blastPattern, float patternZeroDistance )
{
	vector startPos            = attackParams.pos
	vector forward             = attackParams.dir
	vector right               = AnglesToRight( VectorToAngles( attackParams.dir ) )
	vector up                  = AnglesToUp( VectorToAngles( forward ) )
	vector patternCenterAtZero = startPos + (forward * patternZeroDistance)

	array<vector> patternVecs

	foreach ( offsetVec in blastPattern )
	{
		vector offsetPos = patternCenterAtZero + (right * offsetVec.x)
		offsetPos += (up * offsetVec.y)

		vector vecToTarget = Normalize( offsetPos - startPos )
		patternVecs.append( vecToTarget )

#if DEBUG_PROJECTILE_BLAST
			DebugDrawLine( startPos, offsetPos, COLOR_RED, true, 3.0 )
#endif
	}

	return patternVecs
}


entity function FireBallisticRoundWithDrop( entity weapon, vector pos, vector dir, bool isPlayerFired, bool ignoreSpread, int projectileIndex, bool deferred )
{
	int boltSpeed   = int( weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed ) )
	int damageFlags = weapon.GetWeaponDamageFlags()

	float boltGravity  = 0.0
	if ( weapon.GetWeaponSettingBool( eWeaponVar.bolt_gravity_enabled ) )
	{
		var zeroDistance = weapon.GetWeaponSettingFloat( eWeaponVar.bolt_zero_distance )
		if ( zeroDistance == null )
			zeroDistance = 4096.0

		expect float( zeroDistance )

		boltGravity = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_gravity_scale )
		float worldGravity = GetConVarFloat( "sv_gravity" ) * boltGravity
		float time         = zeroDistance / float( boltSpeed )

		if ( DEBUG_BULLET_DROP <= 1 )
			dir += (GetZVelocityForDistOverTime( zeroDistance, time, worldGravity ) / boltSpeed)
	}

	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = pos
	fireBoltParams.dir = dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	fireBoltParams.dontApplySpread = ignoreSpread
	fireBoltParams.projectileIndex = projectileIndex
	fireBoltParams.deferred = deferred
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )


		Chroma_FiredWeapon( weapon )


	return bolt
}


string function GetDistanceString( float distInches )
{
	float distFeet   = distInches / 12.0
	float distYards  = distInches / 36.0
	float distMeters = distInches / 39.3701

	return format( "%.2fm %.2fy %.2ff %.2fin", distMeters, distYards, distFeet, distInches )
}


vector function GetZVelocityForDistOverTime( float distance, float duration, float gravity )
{
	float voz = 0.5 * gravity * duration * duration / duration
	return <0, 0, voz>
}


int function FireGenericBoltWithDrop( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{

		if ( !weapon.ShouldPredictProjectiles() )
			return 1


	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 1
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = PROJ_SPEED_SCALE
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	if ( bolt != null )
	{
		bolt.kv.gravity = PROJ_GRAVITY
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1
	}

		Chroma_FiredWeapon( weapon )



	return 1
}


var function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGenericBoltWithDrop( weapon, attackParams, true )
}


var function OnWeaponPrimaryAttack_EPG( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos = attackParams.pos
	fireMissileParams.dir = attackParams.dir
	fireMissileParams.speed = 1
	fireMissileParams.scriptTouchDamageType = damageTypes.largeCaliberExp
	fireMissileParams.scriptExplosionDamageType = damageTypes.largeCaliberExp
	fireMissileParams.doRandomVelocAndThinkVars = false
	fireMissileParams.clientPredicted = false
	entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile )
	{
		EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}

	return missile
}


bool function PlantStickyEntityOnWorldThatBouncesOffWalls( entity ent, DeployableCollisionParams collisionParams, float bounceDot = DOT_45DEGREE, vector angleOffset = ZERO_VECTOR, bool skipHullTrace = false )
{
	entity hitEnt = collisionParams.hitEnt
	if ( HitEntIsValidToStick( hitEnt ) )
	{
		float dot = collisionParams.normal.Dot( UP_VECTOR )

		if ( dot < bounceDot )
		{













				return false

		}

		return PlantStickyEntity( ent, collisionParams, angleOffset, skipHullTrace )
	}

	return false
}

bool function HitEntIsValidToStick( hitEnt )
{
	if ( !hitEnt || !IsValid( hitEnt ) )
		return false

	var hitEntName = hitEnt.GetScriptName()

	if ( hitEnt.IsWorld() )
		return true
	if ( hitEnt.HasPusherAncestor() )
		return true
	if ( hitEnt.IsFuncBrush() )
		return true
	if ( hitEntName == "ziprail_launcher_prop" )
		return true
	if ( hitEntName == "jump_tower" )
		return true

	return false
}

#if DEV
const bool DEBUG_SURFACE_TEST = false
const float DEBUG_SURFACE_TEST_TIME = 20
#endif
const float SURFACE_TEST_TRACE_LENGTH = 66

bool function PlantStickyEntityOnConsistentSurface( entity projectile, DeployableCollisionParams collisionParams, float consistentDotThreshold, float size, vector angleOffset = ZERO_VECTOR )
{
	bool surfaceIsConsistent = true

	
	vector forward = CrossProduct( collisionParams.normal, <1, 0, 0> ) 
	if ( Length( forward ) == 0.0 )
	{
		forward = CrossProduct( collisionParams.normal, UP_VECTOR )
	}
	vector surfaceAngles = AnglesOnSurface( collisionParams.normal, forward )
	vector right         = AnglesToRight( surfaceAngles )

#if DEV
		if ( DEBUG_SURFACE_TEST )
		{
			
			
			 DebugDrawArrow( collisionParams.pos, collisionParams.pos + collisionParams.normal * SURFACE_TEST_TRACE_LENGTH / 2, 10, COLOR_GREEN, true, DEBUG_SURFACE_TEST_TIME )
		}
#endif

	int goodHitCount            = 0
	array<vector> testPositions = [ <-1, -1, 0>, <-1, 1, 0>, <1, 1, 0>, <1, -1, 0> ]
	for ( int i = 0; i < testPositions.len(); ++i )
	{
		vector testPos = testPositions[i]

		vector origin    = collisionParams.pos + collisionParams.normal * size
		vector endOrigin = origin + forward * testPos.x * size + right * testPos.y * size - collisionParams.normal * SURFACE_TEST_TRACE_LENGTH

#if DEV
			if ( DEBUG_SURFACE_TEST )
			{
				DebugDrawArrow( origin, endOrigin, 5, COLOR_CYAN, true, DEBUG_SURFACE_TEST_TIME )
			}
#endif
		TraceResults traceResult = TraceLine( origin, endOrigin, [ projectile ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

		if ( traceResult.fraction < 1.0 ) 
		{
			float dot = traceResult.surfaceNormal.Dot( collisionParams.normal )
			if ( dot < consistentDotThreshold )
			{
				surfaceIsConsistent = false
#if DEV
					if ( DEBUG_SURFACE_TEST )
					{
						DebugDrawArrow( traceResult.endPos, traceResult.endPos + traceResult.surfaceNormal * 20, 5, <255, 100, 0>, true, DEBUG_SURFACE_TEST_TIME )
					}
#endif
			}
			else
			{
				goodHitCount++
#if DEV
					if ( DEBUG_SURFACE_TEST )
					{
						DebugDrawArrow( traceResult.endPos, traceResult.endPos + traceResult.surfaceNormal * 20, 5, <100, 255, 0>, true, DEBUG_SURFACE_TEST_TIME )
					}
#endif
			}
		}
		else
		{
			surfaceIsConsistent = false
			break
		}
	}


	if ( !surfaceIsConsistent )
	{











		return false
	}

	return PlantStickyEntity( projectile, collisionParams, angleOffset )
}

bool function PlantStickyEntityThatBouncesOffWalls( entity projectile, DeployableCollisionParams cp, float bounceDot = DOT_45DEGREE, vector angleOffset = ZERO_VECTOR )
{

	if ( IsBitFlagSet( cp.deployableFlags, eDeployableFlags.VEHICLES_LARGE_DEPLOYABLE ) && EntIsHoverVehicle( cp.hitEnt ) )
		return PlantStickyEntity_LargeDeployableOnVehicle( projectile, cp, angleOffset )


	float dot = cp.normal.Dot( UP_VECTOR )
	if ( dot < bounceDot )
	{









		return false
	}













	return PlantStickyEntity( projectile, cp, angleOffset )
}


#if DEV
const bool DEBUG_DRAW_PLANT_STICKY = false
#endif

bool function PlantStickyEntity( entity ent, DeployableCollisionParams cp, vector angleOffset = ZERO_VECTOR, bool skipHullTrace = false, bool moveOnNoHitTrace = true )
{
	if ( !EntityShouldStickEx( ent, cp ) )
		return false
	Assert( !ent.IsMarkedForDeletion(), "" )
	Assert( !cp.hitEnt.IsMarkedForDeletion(), "" )

	
	if ( LengthSqr( cp.normal ) <= FLT_EPSILON )
	{
		Warning( "PlantStickyEntity: normal vector " + cp.normal + " is a zero vector. Entity: '" + ent + "' is sticking to HitEnt: '" + cp.hitEnt + "' at position: " + cp.pos )
		cp.normal = UP_VECTOR
	}

	vector plantAngles = AnglesCompose( VectorToAngles( cp.normal ), angleOffset )
	vector plantPosition
	if ( skipHullTrace )
	{
		plantPosition = cp.pos
	}
	else
	{
		vector traceDir    = cp.normal * -1
		vector entPos 	   = cp.pos
		vector mins        = cp.ignoreHullSize ? ZERO_VECTOR: ent.GetBoundingMins()
		vector maxs        = cp.ignoreHullSize ? ZERO_VECTOR: ent.GetBoundingMaxs()
#if DEV
		const float DRAW_DURATION = 60
		if ( DEBUG_DRAW_PLANT_STICKY )
		{
			DebugDrawSphere( cp.pos, 5, COLOR_YELLOW, false, DRAW_DURATION )
			DebugDrawBox( cp.pos, mins , maxs, COLOR_YELLOW, 1, DRAW_DURATION )

			DebugDrawArrow( cp.pos, cp.pos + cp.normal*20, 10, COLOR_YELLOW, false, DRAW_DURATION )
		}
#endif

		int traceMask 	   = (ent.IsProjectile() && ent.GetProjectileWeaponSettingBool( eWeaponVar.grenade_use_mask_ability )) ? TRACE_MASK_ABILITY : TRACE_MASK_SHOT
		array<entity> ignoreEnts = [ent]
		if ( ent.IsProjectile() && ent.proj.ignoreOwnerForPlaceStickyEnt && IsValid( ent.GetOwner() ) )
			ignoreEnts.append( ent.GetOwner() )

		TraceResults trace
		if( ( cp.hitEnt.IsPlayer() || cp.hitEnt.IsNPC() ) && ent.IsProjectile() && ent.ProjectileGetWeaponClassName() == "mp_weapon_cluster_bomb_launcher" )
		{
			vector center = cp.hitEnt.GetWorldSpaceCenter()
			center.z = entPos.z
			trace = TraceLineHighDetail( entPos, center, ignoreEnts, traceMask, TRACE_COLLISION_GROUP_NONE )
		}
		else if( cp.highDetailTrace || ( ent.IsProjectile() && ent.proj.useHighDetailCollisionTraceForPlaceStickyEnt ) )
		{
			trace = TraceHullHighDetail( entPos, ( entPos + ( traceDir * cp.traceLength ) ), mins, maxs, ignoreEnts, ( traceMask & ~CONTENTS_HITBOX ), TRACE_COLLISION_GROUP_NONE, cp.normal )
		}
		else
		{
			trace = TraceHull( entPos, ( entPos + ( traceDir * cp.traceLength ) ), mins, maxs, ignoreEnts, ( traceMask & ~CONTENTS_HITBOX ), TRACE_COLLISION_GROUP_NONE, cp.normal )

		}

#if DEV
			if ( DEBUG_DRAW_PLANT_STICKY )
			{
				DebugDrawArrow( entPos, trace.endPos, 4, COLOR_GREEN, false, DRAW_DURATION )
			}
#endif

		if( moveOnNoHitTrace || trace.fraction < 1.0 )
		{
			plantPosition = trace.endPos

#if DEV
			if ( DEBUG_DRAW_PLANT_STICKY )
			{
				DebugDrawSphere( plantPosition, 3, COLOR_RED, false, DRAW_DURATION )
				DebugDrawBox( plantPosition, mins , maxs, COLOR_RED, 1, DRAW_DURATION )
			}
#endif
		}
		else
		{
			plantPosition = cp.pos

#if DEV
			if ( DEBUG_DRAW_PLANT_STICKY )
			{
				DebugDrawSphere( plantPosition, 3, COLOR_BLUE, false, DRAW_DURATION )
			}
#endif
		}

		if ( !LegalOrigin( plantPosition ) )
			return false

		if ( trace.startSolid && IsValid( trace.hitEnt ) && !trace.hitEnt.IsWorld() && ent.IsProjectile() && ent.GetProjectileWeaponSettingBool( eWeaponVar.grenade_mover_destroy_when_planted ) )
		{



			return false
		}
	}

	if ( IsOriginInvalidForPlacingPermanentOnto( plantPosition, ent ) )
		return false







		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )

	ent.SetVelocity( ZERO_VECTOR )

	
	if ( !EntityShouldStickEx( ent, cp ) )
		return false
	Assert( !ent.IsMarkedForDeletion(), "" )
	Assert( !cp.hitEnt.IsMarkedForDeletion(), "" )

	
	if ( cp.hitEnt.IsWorld() )
	{
		ent.SetVelocity( ZERO_VECTOR )
		ent.StopPhysics()
	}
	else
	{
		if ( cp.hitBox > 0 )
			ent.SetParentWithHitbox( cp.hitEnt, cp.hitBox, true )
		else
			ent.SetParent( cp.hitEnt )	

		if ( cp.hitEnt.IsPlayer() || IsDoor( cp.hitEnt ) || IsReinforced (cp.hitEnt))
			thread HandleDisappearingParent( ent, cp.hitEnt )
	}

	CommonOnSuccessfulStickyPlant( ent, cp )
	return true
}

void function CommonOnSuccessfulStickyPlant( entity ent, DeployableCollisionParams cp )
{
	if ( IsABaseGrenade( ent ) )
	{
		ent.MarkAsAttached()
		ent.AddGrenadeStatusFlag( GSF_PLANTED )
	}
	if ( ent.IsProjectile() )
	{
		ent.proj.isPlanted = true
		if ( ent.proj.deployFunc != null )
			ent.proj.deployFunc( ent, cp )
	}
}


bool function PlantStickyEntity_LargeDeployableOnVehicle( entity ent, DeployableCollisionParams cp, vector angleOffset = ZERO_VECTOR )
{
	if ( !HoverVehicle_AttachEntToNearestAbilityAttachment( ent, cp.hitEnt, false, false, ZERO_VECTOR ) )
		return false
	CommonOnSuccessfulStickyPlant( ent, cp )
	return true
}









bool function IsABaseGrenade( entity ent )
{

		return (ent instanceof C_BaseGrenade)



}

void function HandleDisappearingParent( entity ent, entity parentEnt )
{














	parentEnt.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )

	parentEnt.WaitSignal( "StartPhaseShift", "DeathTotem_PreRecallPlayer" )

	ent.ClearParent()

}

string function GetClassnamefromStickyHitEnt( entity hitEnt )
{
	string ornull classNameRaw = hitEnt.GetNetworkedClassName()
	return ((classNameRaw == null) ? "" : expect string( classNameRaw ))
}

bool function EntityShouldStickEx( entity stickyEnt, DeployableCollisionParams params )
{
	entity hitEnt = params.hitEnt
	if ( !EntityCanHaveStickyEnts( stickyEnt, hitEnt ) )
		return false

	string className = GetClassnamefromStickyHitEnt( hitEnt )
	if ( className == "prop_door" )
	{
		float normal = ((params.normal == ZERO_VECTOR) ? 0.0 : params.normal.Dot( UP_VECTOR ))
		if ( normal > DOT_60DEGREE )
			return false
	}

	if ( stickyEnt.IsMarkedForDeletion() )
		return false
	if ( hitEnt.IsMarkedForDeletion() )
		return false
	if ( hitEnt == stickyEnt )
		return false
	if ( hitEnt == stickyEnt.GetParent() )
		return false


	if ( IsBitFlagSet( params.deployableFlags, eDeployableFlags.VEHICLES_NO_STICK ) && ( className == "player_vehicle" ) )
		return false


	if ( hitEnt.GetScriptName() == DIRTY_BOMB_TARGETNAME && params.hitBox == 0 && stickyEnt.GetScriptName() != RIOT_DRILL_SCRIPT_NAME)
		return false

	return true
}
bool function EntityShouldStick( entity stickyEnt, entity hitEnt )
{
	DeployableCollisionParams params
	params.hitEnt = hitEnt
	return EntityShouldStickEx( stickyEnt, params )
}

bool function EntityCanHaveStickyEnts( entity stickyEnt, entity ent )
{
	if ( !IsValid( ent ) )
		return false

	string stickyEntScriptName = stickyEnt.GetScriptName()
	string entScriptName = ent.GetScriptName()

	if ( ent.GetModelName() == $"" ) 
		return false

	
	if ( ent.IsProjectile() )
		return false

	string stickyEntWeaponClassName = ""




	if ( stickyEnt instanceof C_Projectile )

	{
		stickyEntWeaponClassName = stickyEnt.ProjectileGetWeaponClassName()
	}

	var entClassname = ent.GetNetworkedClassName()
	if ( entClassname == null )
		return false

	
	
	
	
	
	string stickyThrowableName = stickyEntWeaponClassName == "" ? stickyEntScriptName : stickyEntWeaponClassName
	int stickyValue = GetThrowableEntStickinessToEntity( stickyThrowableName, entScriptName )
	if (  stickyValue != ITEM_NOT_FOUND_STICKINESS )
		return stickyValue == ITEM_STICKS

	
	if ( entClassname == "phys_bone_follower" && stickyEntWeaponClassName == "mp_weapon_throwingknife" )
		return false

	if ( entClassname == "prop_lootroller" && stickyEntWeaponClassName != "" )
		return true

	
	if ( entClassname == "prop_death_box" && IsEntParentedToObjectOfScriptname( ent, HOVER_VEHICLE_SCRIPTNAME ) )
		return false

	
	
	if ( entScriptName == WRECKING_BALL_BALL_SCRIPT_NAME )
		return true
	
	if ( stickyEntScriptName == RIOT_DRILL_SCRIPT_NAME )
		return true

	if ( stickyEntWeaponClassName == "mp_ability_debuff_zone" && DebuffZone_GetAllowableStickyEnts( ent ) )
		return true

	if( IsForgedShadowsShield( ent ) )
		return ShadowShield_IsAllowedStickyEnt( ent, stickyEnt, stickyEntWeaponClassName )

	
	if ( entScriptName == MOBILE_SHIELD_SCRIPTNAME )
		return MobileShield_IsAllowedStickyEnt( ent, stickyEnt, stickyEntWeaponClassName )


		
		if ( entClassname == "phys_bone_follower" && IsValid( ent.GetOwner() ) )
		{
			entity cannonEnt = ent.GetOwner()

			if ( cannonEnt.GetScriptName() == GetEnumString( "eSkydiveLauncherType", eSkydiveLauncherType.GRAVITY_CANNON ) )
			{
				
				
				if ( INVALID_GRAVITY_CANNON_PLACEABLES.contains( stickyEntWeaponClassName ) )
				{
					return false
				}
			}
		}


	if ( !(string( entClassname ) in STICKY_CLASSES) && !ent.IsNPC() )
		return false









	if ( stickyEntWeaponClassName != "" )
	{
		
		
		

		if ( ent.IsPlayer() && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_pilot" ) == 0) )
			return false
		if ( ent.IsNPC() && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_npc" ) == 0) )
			return false
		if ( (ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME ) && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_drone" ) == 0) )
			return false
	}






	return true
}

#if DEV
void function DEV_DumpStickinessTable()
{
	bool dumpedEnts = false
	foreach( string throwable, table<string, int> ent in file.throwableItemStickinessTable )
	{
		if ( !dumpedEnts )
		{
			printf("Ents: ")
			foreach( string name, int tmp in file.throwableItemStickinessTable[throwable] )
			{
				printf("-> " + name)
			}
			printf("Throwables: ")
			dumpedEnts = true
		}

		printf("-> " + throwable)
	}
}
#endif

int function GetThrowableEntStickinessToEntity( string stickyThrowableName, string entScriptName )
{
	if ( stickyThrowableName in file.throwableItemStickinessTable &&
			entScriptName in file.throwableItemStickinessTable[ stickyThrowableName ] )
		return file.throwableItemStickinessTable[ stickyThrowableName ][ entScriptName ]

	return ITEM_NOT_FOUND_STICKINESS
}

bool function IsEntParentedToObjectOfScriptname( entity ent, string scriptname )
{
	entity parentEnt = ent.GetParent()
	while ( IsValid( parentEnt ) )
	{
		if ( parentEnt.GetScriptName() == scriptname )
			return true

		parentEnt = parentEnt.GetParent()
	}
	return false
}

#if DEV
void function ShowExplosionRadiusOnExplode( entity ent )
{
	ent.WaitSignal( "OnDestroy" )

	float innerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosion_inner_radius" ) )
	float outerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosionradius" ) )

	vector org    = ent.GetOrigin()
	vector angles = ZERO_VECTOR
	thread DebugDrawCircle( org, angles, innerRadius, <255, 255, 51>, true, 3.0 )
	thread DebugDrawCircle( org, angles, outerRadius, COLOR_WHITE, true, 3.0 )
}
#endif



























































































































































































bool function WeaponCanCrit( entity weapon )
{
	
	if ( !weapon )
		return false

	return weapon.GetWeaponSettingBool( eWeaponVar.critical_hit )
}


vector function GetVectorFromPositionToCrosshair( entity player, vector startPos )
{
	Assert( IsValid( player ) )

	
	vector traceStart        = player.EyePosition()
	vector traceEnd          = traceStart + (player.GetViewVector() * 20000)
	array<entity> ignoreEnts = [ player ]
	TraceResults traceResult = TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	
	vector vec = traceResult.endPos - startPos
	vec = Normalize( vec )
	return vec
}










void function InitMissileForRandomDriftForVortexHigh( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 8, 2.5, 0, 0, 100, 100, 0 )
}


void function InitMissileForRandomDriftForVortexLow( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 0.3, 0.085, 0, 0, 0.5, 0.5, 0 )
}































































































































































































































































































































































vector function GetVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	const GRAVITY = 750

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


vector function GetPlayerVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	

	float gravityScale = GetGlobalSettingsFloat( DEFAULT_PILOT_SETTINGS, "gravityScale" )
	float GRAVITY      = 750 * gravityScale 

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}



bool function IsOwnerViewPlayerFullyADSed( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !IsValid( owner ) )
		return false

	if ( !owner.IsPlayer() )
		return false

	if ( owner != GetLocalViewPlayer() )
		return false

	float zoomFrac = owner.GetZoomFrac()
	if ( zoomFrac < 1.0 )
		return false

	return true
}



void function DebugDrawMissilePath( entity missile )
{
	EndSignal( missile, "OnDestroy" )
	vector lastPos = missile.GetOrigin()
	while ( true )
	{
		WaitFrame()
		if ( !IsValid( missile ) )
			return
		DebugDrawLine( lastPos, missile.GetOrigin(), COLOR_GREEN, true, 20.0 )
		lastPos = missile.GetOrigin()
	}
}


bool function IsPilotShotgunWeapon( string weaponName )
{
	if ( IsWeaponKeyFieldDefined( weaponName, "weaponSubClass" ) && GetWeaponInfoFileKeyField_GlobalString( weaponName, "weaponSubClass" ) == "shotgun" )
		return true

	return false
}















































































void function GiveEMPStunStatusEffects( entity target, float duration, float fadeoutDuration = 0.5, float slowTurnSeverity = EMP_SEVERITY_SLOWTURN, float slowMoveSeverity = EMP_SEVERITY_SLOWMOVE )
{




















}

#if DEV
string ornull function FindEnumNameForValue( table searchTable, int searchVal )
{
	foreach ( string keyname, int value in searchTable )
	{
		if ( value == searchVal )
			return keyname
	}
	return null
}

void function DevPrintAllStatusEffectsOnEnt( entity ent )
{
	printt( "Effects:", ent )
	array<float> effects = StatusEffect_GetAllSeverity( ent )
	int length           = effects.len()
	int found            = 0
	for ( int idx = 0; idx < length; idx++ )
	{
		float severity = effects[idx]
		if ( severity <= 0.0 )
			continue
		string ornull name = FindEnumNameForValue( eStatusEffect, idx )
		Assert( name )
		expect string( name )
		printt( " eStatusEffect." + name + ": " + severity )
		found++
	}
	printt( found + " effects active.\n" )
}
#endif

entity function GetMeleeWeapon( entity player )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.IsWeaponOffhandMelee() )
			return weaponEnt
	}

	return null
}




























































































































































































































































































































































































































































































































































































































































































































































































































void function PlayerUsedOffhand( entity player, entity offhandWeapon, bool sendPINEvent = true, entity trackedProjectile = null, table pinAdditionalData = {} )
{







































		if ( offhandWeapon == player.GetOffhandWeapon( OFFHAND_ULTIMATE ) )
		{
			if ( offhandWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate ) == 0 )
				UltimateWeaponStateSet( eUltimateState.CHARGING )
			else
				UltimateWeaponStateSet( eUltimateState.ACTIVE )
		}
		Chroma_PlayerUsedAbility( player, offhandWeapon )

}


void function AddCallback_OnPlayerAddedWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	
	file.playerAddedWeaponModCallbacks.append( callbackFunc )
}

void function AddCallback_OnPlayerRemovedWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	
	file.playerRemovedWeaponModCallbacks.append( callbackFunc )
}

void function AddCallback_OnPlayerAddedToggleWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	
	file.playerAddedToggleWeaponModCallbacks.append( callbackFunc )
}

void function AddCallback_OnPlayerRemovedToggleWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	
	file.playerRemovedToggleWeaponModCallbacks.append( callbackFunc )
}

void function CodeCallback_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerAddedWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}





}


void function CodeCallback_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerRemovedWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}





}

void function CodeCallback_OnPlayerAddedToggleWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerAddedToggleWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}





}


void function CodeCallback_OnPlayerRemovedToggleWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerRemovedToggleWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}





}














































































































































































































































































































































































































































































































































































































































int function GetMaxTrackerCountForTitan( entity titan )
{
	array<entity> primaryWeapons = titan.GetMainWeapons()
	if ( primaryWeapons.len() > 0 && IsValid( primaryWeapons[0] ) )
	{
		if ( primaryWeapons[0].HasMod( "pas_lotech_helper" ) )
			return 4
	}

	return 3
}


bool function DoesModExist( entity weapon, string modName )
{
	array<string> mods = GetWeaponMods_Global( weapon.GetWeaponClassName() )
	return mods.contains( modName )
}


bool function DoesModExistFromWeaponClassName( string weaponName, string modName )
{
	array<string> mods = GetWeaponMods_Global( weaponName )
	return mods.contains( modName )
}


bool function IsModActive( entity weapon, string modName )
{
	array<string> activeMods = weapon.GetMods()
	return activeMods.contains( modName )
}


bool function IsWeaponInSingleShotMode( entity weapon )
{
	if ( weapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
		return false

	if ( !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto ) )
		return false

	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) == 0
}


bool function IsWeaponInBurstMode( entity weapon )
{
	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) > 1
}


bool function IsWeaponOffhand( entity weapon )
{
	switch( weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) )
	{
		case eWeaponFireMode.offhand:
		case eWeaponFireMode.offhandInstant:
		case eWeaponFireMode.offhandHybrid:
			return true
	}
	return false
}


bool function IsWeaponInAutomaticMode( entity weapon )
{
	return !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )
}

bool function IsMeleeWeaponNotFists( entity player )
{
	if ( !IsValid(player) )
		return false

	entity meleeWeapon = player.GetOffhandWeapon( OFFHAND_MELEE )
	bool isHeirloom = meleeWeapon.GetWeaponSettingBool( eWeaponVar.is_heirloom )
	bool isArtifact = meleeWeapon.GetWeaponSettingBool( eWeaponVar.is_artifact )

	return isHeirloom || isArtifact
}


bool function OnWeaponAttemptOffhandSwitch_Never( entity weapon )
{
	return false
}



void function ServerCallback_SetWeaponPreviewState( bool newState )
{
#if DEV
		entity player = GetLocalClientPlayer()

		if ( newState )
		{
			printt( "Weapon Skin Preview Enabled" )
			player.ClientCommand( "bind LEFT \"WeaponPreviewPrevSkin\"" )
			player.ClientCommand( "bind RIGHT \"WeaponPreviewNextSkin\"" )
			player.ClientCommand( "bind UP \"WeaponPreviewNextCamo\"" )
			player.ClientCommand( "bind DOWN \"WeaponPreviewPrevCamo\"" )

			player.ClientCommand( "bind_held LEFT weapon_inspect" )
		}
		else
		{
			player.ClientCommand( "bind LEFT \"+ability 12\"" )
			player.ClientCommand( "bind RIGHT \"+ability 13\"" )
			player.ClientCommand( "bind UP \"+ability 10\"" )
			player.ClientCommand( "bind DOWN \"+ability 11\"" )

			SetStandardAbilityBindingsForPilot( player )
			printt( "Weapon Skin Preview Disabled" )
		}
#endif
}


void function OnWeaponReadyToFire_ability_tactical( entity weapon )
{



}


void function OnWeaponRegenEndGeneric( entity weapon )
{






		entity owner = weapon.GetWeaponOwner()
		if ( !IsValid( owner ) || !owner.IsPlayer() )
			return
		if ( owner.GetOffhandWeapon( OFFHAND_ULTIMATE ) == weapon )
			Chroma_UltimateReady()

}


void function Ultimate_OnWeaponRegenBegin( entity weapon )
{

		UltimateWeaponStateSet( eUltimateState.CHARGING )

}





















void function PlayDelayedShellEject( entity weapon, float time, int count = 1, bool persistent = false )
{
	AssertIsNewThread()

	weapon.EndSignal( "OnDestroy" )

	asset vmShell      = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_view )
	asset worldShell   = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_world )
	string shellAttach = weapon.GetWeaponSettingString( eWeaponVar.fx_shell_eject_attach )

	if ( shellAttach == "" )
		return

	for ( int i = 0; i < count; i++ )
	{
		wait time

		if ( !IsValid( weapon ) )
			return
		entity viewmodel = weapon.GetWeaponViewmodel()
		if ( !IsValid( viewmodel ) )
			return
		weapon.PlayWeaponEffect( vmShell, worldShell, shellAttach, persistent )
	}
}

























































































































































































































































































































































































































































































































void function UICallback_UpdateLaserSightColor()
{
	Remote_ServerCallFunction( "ClientCallback_UpdateLaserSightColor" )
}

bool function TryCharacterButtonCommonReadyChecks( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return false
	if ( player != GetLocalClientPlayer() )
		return false

	if ( HoverVehicle_PlayerIsDriving( player ) )
		return false


	return true
}



bool function ShouldShowADSScopeView( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	if ( !HasFullscreenScope( weapon ) )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

	if ( player.GetZoomFrac() < weapon.GetWeaponSettingFloat( eWeaponVar.ads_fov_zoomfrac_end ) )
		return false

	return true
}


bool function HasFullscreenScope( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	if ( weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ads_scope_set ) <= 0 )
		return false

	if ( weapon.GetWeaponInfoFileKeyField( "bodygroup_ads_scope_name" ) == null )
		return false

	return true
}


vector function GetAmmoColorByType( string ammoType )
{
	int colorID  = ammoColors[ammoType]
	vector color = GetKeyColor( colorID ) / 255.0
	return color
}



bool function EnergyChoke_OnWeaponModCommandCheckMods( entity player, entity weapon, string mod, bool isAdd )
{
	weapon.ForceChargeEndNoAttack()
	weapon.Signal( END_KINETIC_LOADER_CHOKE )
	weapon.RemoveMod( "kinetic_choke" )
	if ( isAdd && weapon.HasMod( KINETIC_LOADER_HOPUP ) && mod == "choke")
	{
		if( !weapon.HasMod( "hopup_kinetic_choke" ) )
		{
			weapon.AddMod( "hopup_kinetic_choke" )
			thread KineticLoaderChokeFunctionality_ServerThink( player, weapon )
		}
	}
	else if ( !isAdd && weapon.HasMod( KINETIC_LOADER_HOPUP ) && mod == "choke")
	{
		weapon.RemoveMod( "hopup_kinetic_choke" )
	}
	return true
}































vector function CalcProjectileTrajectory( vector startPos, vector targetPos, float desiredTravelTime, bool debugDraw )
{
	
	
	
	

	vector startToTarget     = targetPos - startPos
	vector startToTargetFlat = FlattenVec( startToTarget )
	float xDiff              = Length( startToTargetFlat )
	float yDiff              = startToTarget.z


	float velX = (xDiff) / desiredTravelTime

	float gravity = GetConVarFloat( "sv_gravity" )

	float velY = (yDiff + 0.5 * gravity * desiredTravelTime * desiredTravelTime) / desiredTravelTime

	vector horizontalLaunchVel = Normalize( startToTargetFlat ) * velX

	vector launchVel = <horizontalLaunchVel.x, horizontalLaunchVel.y, velY>

	if ( debugDraw )
	{
		const float DRAW_TIME = 0.1
		DebugDrawSphere( startPos, 5, COLOR_YELLOW, false, DRAW_TIME )
		DebugDrawSphere( targetPos, 5, COLOR_YELLOW, false, DRAW_TIME )
		DebugDrawArrow( startPos, startPos + launchVel, 10, COLOR_YELLOW, false, DRAW_TIME )
	}

	return launchVel
}


ArcSolution function SolveBallisticArc( vector launchOrigin, float launchSpeed, vector targetOrigin, float gravity, bool lowAngle = true )
{
	ArcSolution as

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	vector diff = targetOrigin - launchOrigin
	vector diffXZ =FlattenVec( diff );
	float groundDist = Length( diffXZ );

	float speed2 = launchSpeed*launchSpeed;
	float speed4 = launchSpeed*launchSpeed*launchSpeed*launchSpeed;
	float y = diff.z;
	float x = groundDist;
	float gx = gravity*x;

	float root = speed4 - gravity*(gravity*x*x + 2*y*speed2);

	
	if (root < 0)
		return as;

	as.valid = true
	root = sqrt( root );

	float lowAng = atan2(speed2 - root, gx)
	float highAng = atan2(speed2 + root, gx)

	float goodAngle = ( lowAngle ) ? lowAng : highAng

	vector groundDir = Normalize( diffXZ )
	as.fire_velocity = ( groundDir * cos( goodAngle ) *launchSpeed ) + ( < 0, 0, 1 > * sin( goodAngle ) * launchSpeed )
	float groundSpeed = Length( FlattenVec( as.fire_velocity ) )
	groundSpeed = ( groundSpeed > 0 ) ? groundSpeed : 1.0
	as.duration = groundDist / groundSpeed

	return as;
}

CrosshairTargetData function GetCrosshairTargetData( entity player, float minDistance, float maxDistance, float airBurstHeight, bool capAtMaxRange = false )
{
	CrosshairTargetData data
	data.crosshairStart = player.CameraPosition()
	vector crosshairEnd = data.crosshairStart + player.GetViewForward() * maxDistance
	DoTraceCoordCheck( false )
	array< entity > ignoreEnts = [ player ]
	ignoreEnts.extend( GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( DEATHBOX_FLYER_SCRIPT_NAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( JUMPTOWER_PING_NAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( REDEPLOY_BALLOON_INFLATABLE_SCRIPT_NAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( BANGALORE_SMOKESCREEN_SCRIPTNAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( RESPAWN_DROPSHIP_TARGETNAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( VANTAGE_COMPANION_SCRIPTNAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( CARE_PACKAGE_SCRIPTNAME ) )
	ignoreEnts.extend( GetEntArrayByScriptName( WORKBENCH_CLUSTER_AIRDROPPED_SCRIPTNAME ) )
	ignoreEnts.extend( GetPlayerArray_Alive() )
	TraceResults crosshairResults = TraceLineHighDetail( data.crosshairStart, crosshairEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )

	data.groundTarget = crosshairResults.endPos
	data.groundTargetNormal = crosshairResults.surfaceNormal
	data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >
	data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
	data.directionToTarget =  Normalize( data.groundTarget - data.crosshairStart )
	float flattenedDistanceToTarget = Distance2D( data.groundTarget, data.crosshairStart )
	bool isPlayerAbove =  ( data.groundTarget.z  - data.crosshairStart.z ) <= 0

	if( flattenedDistanceToTarget < minDistance )
	{
		data.groundTarget = crosshairResults.endPos + ( FlattenNormalizeVec ( data.directionToTarget ) * ( minDistance - flattenedDistanceToTarget ) )
		vector downTraceEnd = < data.groundTarget.x, data.groundTarget.y, data.groundTarget.z - 250 >
		TraceResults downTraceResults = TraceLineHighDetail( data.groundTarget, downTraceEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
		if( downTraceResults.startSolid || downTraceResults.fraction < 1.0 )
			data.groundTarget = downTraceResults.endPos
		data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >
		data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
		data.inRange = CrosshairInRange( crosshairResults, player, isPlayerAbove )
	}
	else if ( capAtMaxRange && crosshairResults.fraction == 1.0 )
	{
		vector downTraceStart = data.crosshairStart + ( FlattenNormalizeVec ( data.directionToTarget ) *  maxDistance )
		vector downTraceEnd = < data.groundTarget.x, data.groundTarget.y, data.groundTarget.z - 25000 >
		TraceResults downTraceResults = TraceLineHighDetail( data.groundTarget, downTraceEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
		if( downTraceResults.startSolid || downTraceResults.fraction < 1.0 )
			data.groundTarget = downTraceResults.endPos
		data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >
		data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
		data.inRange = true
	}
	else
		data.inRange = CrosshairInRange( crosshairResults, player, isPlayerAbove )
	DoTraceCoordCheck( true )

	return data
}

bool function CrosshairInRange( TraceResults crosshairResults, entity player, bool isPlayerAbove  )
{
	bool inRange = false
	const array< string > HOVER_TANK_ENTS = [ "_hover_tank_mover", "_hover_tank_interior"]

	if( IsValid( crosshairResults.hitEnt ) && HOVER_TANK_ENTS.contains( crosshairResults.hitEnt.GetScriptName() ) )
	{
		entity ground = player.GetGroundEntity()
		float velocity = Length( crosshairResults.hitEnt.GetVelocity() )
		if( isPlayerAbove || velocity == 0.0 || ground == crosshairResults.hitEnt )
			inRange = crosshairResults.fraction < 1.0
		else
			inRange = false
	}
	else
		inRange = crosshairResults.fraction < 1.0

	return inRange
}

CrosshairTargetData function GetCrosshairTargetDataAngles( entity player, float minDistance, float maxDistance, float airBurstHeight, bool capAtMaxRange = false )
{
	const bool DEBUG_AIRBUST_TARGET = false
	CrosshairTargetData data

	vector cameraAngles           = player.CameraAngles()
	vector cameraFwd              = AnglesToForward( cameraAngles )
	vector cameraFwdFlat          = FlattenNormalizeVec( cameraFwd )

	DoTraceCoordCheck( false )
	array< entity > ignoreEnts = [ player ]
	ignoreEnts.extend( GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME ) )
	TraceResults testTrace = TraceLineHighDetail( player.CameraPosition(), player.CameraPosition() + cameraFwd*maxDistance*2.0, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
	float heightDiff = testTrace.endPos.z - player.CameraPosition().z
	float PITCH_ADJUST = GraphCapped( heightDiff, 300, -1000, -10, 20 )

	if ( DEBUG_AIRBUST_TARGET )
		printt( "GetCrosshairTargetDataAngles - heightDiff: " + heightDiff + " PITCH_ADJUST: " + PITCH_ADJUST )

	float MIN_PITCH = 25 + PITCH_ADJUST
	float MAX_PITCH = -10  + PITCH_ADJUST

	float desiredDistanceToTarget = GraphCapped( cameraAngles.x, MIN_PITCH, MAX_PITCH, minDistance, maxDistance )


	data.crosshairStart = player.CameraPosition()
	vector crosshairEnd = player.GetOrigin() + cameraFwdFlat*desiredDistanceToTarget

	TraceResults initialCameraTrace = TraceLineHighDetail( data.crosshairStart, crosshairEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )

	if ( DEBUG_AIRBUST_TARGET )
	{
		DebugDrawLine( data.crosshairStart + <0, 0, 1>, crosshairEnd, COLOR_ORANGE, false, 0.1 )
		DebugDrawSphere( crosshairEnd, 5, COLOR_ORANGE, true, 0.1 )
		DebugDrawSphere( initialCameraTrace.endPos, 10, COLOR_GREEN, false, 0.1 )
	}

	data.groundTarget = initialCameraTrace.endPos
	data.groundTargetNormal = initialCameraTrace.surfaceNormal
	data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >
	data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
	data.directionToTarget =  Normalize( data.groundTarget - data.crosshairStart )

	if ( initialCameraTrace.fraction < 1.0 ) 
	{
		if ( DEBUG_AIRBUST_TARGET )
			DebugDrawText( initialCameraTrace.endPos, "Initial cant see", false, 0.1 )

		
		bool canTraceAbove = false
		float heightMult = 0.0
		TraceResults traceAbove
		while ( !canTraceAbove && heightMult < 10.0)
		{
			heightMult += 1.0
			traceAbove = TraceLineHighDetail( data.crosshairStart, crosshairEnd + < 0, 0, airBurstHeight*heightMult >, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
			canTraceAbove = traceAbove.fraction == 1.0
		}

		if ( canTraceAbove )
		{
			TraceResults traceDown = TraceLineHighDetail( traceAbove.endPos, crosshairEnd, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
			data.groundTarget = traceDown.endPos
			data.groundTargetNormal = traceDown.surfaceNormal
			data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >
			data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
			data.directionToTarget =  Normalize( data.groundTarget - data.crosshairStart )

			if ( DEBUG_AIRBUST_TARGET )
			{
				DebugDrawText( traceAbove.endPos, "Can see this point", false, 0.1 )
				DebugDrawLine( traceAbove.endPos, traceDown.endPos, COLOR_GREEN, false, 0.1)
				DebugDrawSphere( traceDown.endPos, 10, COLOR_GREEN, false, 0.1 )
			}
		}

	}
	else
	{
		
		TraceResults traceDown = TraceLineHighDetail( initialCameraTrace.endPos, initialCameraTrace.endPos - <0,0,6000>, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
		data.groundTarget = traceDown.endPos
		data.groundTargetNormal = traceDown.surfaceNormal
		data.airburstTarget = data.groundTarget + < 0, 0, airBurstHeight >

		if ( DEBUG_AIRBUST_TARGET )
		{
			DebugDrawLine( initialCameraTrace.endPos, traceDown.endPos, COLOR_GREEN, false, 0.1)
			DebugDrawSphere( traceDown.endPos, 10, COLOR_GREEN, false, 0.1 )
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}


	
	TraceResults traceToAirburst = TraceLineHighDetail( player.GetWorldSpaceCenter(), data.airburstTarget, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
	if( traceToAirburst.fraction < 1.0 )
	{
		float heightMult = 1.0
		while ( traceToAirburst.fraction < 1.0 &&  heightMult < 5.0 )
		{
			heightMult += 0.5
			data.airburstTarget = data.groundTarget + < 0, 0, heightMult*airBurstHeight >
			traceToAirburst = TraceLineHighDetail( player.GetWorldSpaceCenter(), data.airburstTarget, ignoreEnts, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS ) & ~CONTENTS_WINDOW, TRACE_COLLISION_GROUP_PROJECTILE )
		}

		data.distanceToTarget = Distance( data.groundTarget, data.crosshairStart )
		data.directionToTarget =  Normalize( data.groundTarget - data.crosshairStart )

		if ( DEBUG_AIRBUST_TARGET )
		{
			DebugDrawLine(player.GetWorldSpaceCenter(), data.airburstTarget, COLOR_PURPLE, false, 0.1  )
			printt( "GetCrosshairTargetDataAngles - heightMult needed: " + heightMult )
		}
	}

	data.inRange = true

	DoTraceCoordCheck( true )


	if ( DEBUG_AIRBUST_TARGET )
	{
		DebugDrawSphere( data.groundTarget , 5, COLOR_PURPLE, false, 0.1 )
		DebugDrawText( data.groundTarget, "ground", false, 0.1 )
		DebugDrawSphere( data.airburstTarget , 15, COLOR_PURPLE, false, 0.1 )
		DebugDrawText( data.airburstTarget, "air", false, 0.1 )
		DebugDrawLine( data.groundTarget, data.airburstTarget, COLOR_PURPLE, false, 0.1  )
	}

	return data
}

void function Weapon_AddSingleCharge( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int maxClip = weapon.GetWeaponPrimaryClipCountMax()
	int fullAdd = weapon.GetWeaponPrimaryClipCount() + ammoReq
	int newClip = minint( maxClip, fullAdd )
	weapon.SetWeaponPrimaryClipCount( newClip )

	if ( fullAdd > maxClip )
	{
		int diff = fullAdd - maxClip
		int maxAmmo = weapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE )
		int fullAmmoAdd = weapon.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) + diff
		int newAmmo = minint( maxAmmo, fullAmmoAdd )
		weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, newAmmo )
	}
}


bool function AreAbilitiesSilenced( entity player )
{
	if ( !IsValid( player ) )
		return true

	if ( StatusEffect_HasSeverity( player, eStatusEffect.silenced ) )
		return true
	if ( StatusEffect_HasSeverity( player, eStatusEffect.is_boxing ) )
		return true

	return false
}


int function GetNeededEnergizeConsumableCount( entity weapon, entity player )
{
	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetWeaponInfoFileKeyField_GlobalInt ( weaponRef, "energized_consumable_needed_amount" )

	int requiredCountWithPassive = consumableRequiredCount
	
	{
		if ( consumableRef == "health_pickup_combo_small" )
			requiredCountWithPassive = player.HasPassive( ePassives.PAS_BONUS_SMALL_HEAL ) ? maxint( 1, consumableRequiredCount - 1 ) : consumableRequiredCount
	}

	return requiredCountWithPassive
}

bool function HasEnoughEnergizeConsumable( entity weapon, entity player )
{
	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )
	int consumableCurrentCount = SURVIVAL_CountItemsInInventory( player, consumableRef )

	LootData lootData = SURVIVAL_Loot_GetLootDataByRef( consumableRef )

	
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
		return true

	return consumableCurrentCount >= consumableRequiredCount
}

bool function OnWeaponTryEnergize( entity weapon, entity player )
{
	if ( !IsValid( player ) )
		return false

	if ( !IsValid( weapon ) )
		return false

	string weaponName = weapon.GetWeaponClassName()
	float maxInputFrac = GetWeaponInfoFileKeyField_GlobalFloat( weaponName, "energized_max_reenergize_frac" )
	float energizedDuration = GetWeaponInfoFileKeyField_GlobalFloat( weaponName, "energized_duration" )
	float chargeFrac = max( weapon.GetEnergizedEndTime() - Time(), 0 ) / energizedDuration

	if ( !(weapon.GetEnergizeState() == ENERGIZE_ENERGIZED && weapon.GetLastEnergizeState() == ENERGIZE_ENERGIZING) )
	{
		if ( chargeFrac > maxInputFrac )
		{

				string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_full_text" )
				AnnouncementMessageRight( player, Localize( pingStringData ) )

			return false
		}
	}
	bool isUltWeaponAndUltIsFull = IsBitFlagSet( weapon.GetWeaponTypeFlags(), WPT_ULTIMATE ) && ( weapon.GetWeaponPrimaryClipCount() >= weapon.GetWeaponPrimaryClipCountMax() )
	if ( isUltWeaponAndUltIsFull )
	{

			string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_full_text" )
			AnnouncementMessageRight( player, Localize( pingStringData ) )

		return false
	}

	if( !HasEnoughEnergizeConsumable( weapon, player ) )
	{

		int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )
		string consumableName = GetWeaponInfoFileKeyField_GlobalString( weaponName, consumableRequiredCount > 1 ? "energized_consumable_name_plural" : "energized_consumable_name_singular" )
		string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable_required_hint" )

		
		if( weaponName == "mp_weapon_dragon_lmg"  )
			AnnouncementMessageRight( player, Localize( pingStringData, Localize( consumableName ) ) )
		else
			AnnouncementMessageRight( player, Localize( pingStringData, consumableRequiredCount, Localize( consumableName ) ) )

		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )
		Quickchat( eCommsAction[commsData], null )


		return false
	}

	return true
}

void function OnWeaponEnergizedStart( entity weapon, entity player, bool costConsumable )
{
	if ( !IsValid( weapon ) || !costConsumable )
		return

	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )

	LootData lootData = SURVIVAL_Loot_GetLootDataByRef( consumableRef )

	
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
		return

	SURVIVAL_RemoveFromPlayerInventory( player, consumableRef, consumableRequiredCount )
}


void function DisplayCenterDotRui( entity weapon, string abortSignal, float appearDelay, float duration, float dotAlpha, float fadeInDuration, float fadeOutDuration )
{
	AssertIsNewThread()
	if ( !IsValid( weapon ) )
		return
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( abortSignal )

	var rui = CreateCockpitPostFXRui( $"ui/crosshair_single_dot_helper.rpak" )
	RuiSetBool( rui, "isActive", false )

	OnThreadEnd(
		function() : ( rui, weapon, player )
		{
			RuiDestroy( rui )
		}
	)

	wait appearDelay

	if ( !IsValid( weapon ) )
		return

	float endTime = Time() + duration

	RuiSetBool( rui, "isActive", true )
	RuiSetFloat( rui, "birthTime", Time() )
	RuiSetFloat( rui, "deathTime", endTime )
	RuiSetFloat( rui, "dotAlpha", dotAlpha )
	RuiSetFloat( rui, "fadeInDuration", fadeInDuration )
	RuiSetFloat( rui, "fadeOutDuration", fadeOutDuration )

	while ( Time() < endTime )
	{
		WaitFrame()
	}

	RuiSetBool( rui, "isActive", false )
}











bool function MarksmansTempo_Validate( entity weapon, MarksmansTempoSettings settings )
{
	bool hasMarksmansTempo = weapon.HasMod( MOD_MARKSMANS_TEMPO )





		if ( !InPrediction() )
			return hasMarksmansTempo


	if ( !hasMarksmansTempo )
	{
		MarksmansTempo_RemoveTempo( weapon, settings )
		return false
	}

	return true
}

void function MarksmansTempo_OnActivate( entity weapon, MarksmansTempoSettings settings )
{
	AssertIsNewThread()
	weapon.EndSignal( "OnDestroy" )


		if ( !InPrediction() )
			return









	WaitFrame()	

	bool valid = MarksmansTempo_Validate( weapon, settings )








}

void function MarksmansTempo_OnDeactivate( entity weapon, MarksmansTempoSettings settings )
{

	if ( !InPrediction() )
		return


	if ( MarksmansTempo_Validate( weapon, settings ) )
		MarksmansTempo_ClearTempo( weapon, settings )
}

void function MarksmansTempo_AbortFadeoff( entity weapon, MarksmansTempoSettings settings )
{
	weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
}

void function MarksmansTempo_SetPerfectTempoMoment( entity weapon, MarksmansTempoSettings settings, entity player, float time, bool useOnPerfectMomentFadeoff )
{

		if ( !InPrediction() )
			return


	bool hasMarksmansTempo = weapon.HasMod( MOD_MARKSMANS_TEMPO )




	if ( hasMarksmansTempo && (!IsClient() || InPrediction()) )
	{
		weapon.SetScriptTime1( time )

		if ( useOnPerfectMomentFadeoff )
		{
			weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
			float fadeoffDelay = time - Time()
			float fadeoffTime
			if ( settings.fadeoffMatchGraceTime > 0 )
				fadeoffTime = weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) ? settings.graceTimeInTempo : settings.graceTimeBuildup
			else
				fadeoffTime = settings.fadeoffOnPerfectMomentHit
			thread MarksmansTempo_Fadeoff( weapon, settings, fadeoffTime + fadeoffDelay )
		}
	}
}

void function MarksmansTempo_Fadeoff( entity weapon, MarksmansTempoSettings settings, float fadeTime )
{
	AssertIsNewThread()
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( settings.weaponDeactivateSignal )
	weapon.EndSignal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )

	wait fadeTime
	MarksmansTempo_ClearTempo( weapon, settings )
}

void function MarksmansTempo_OnFire( entity weapon, MarksmansTempoSettings settings, bool useOnFireFadeoff )
{

		if ( !InPrediction() )
			return


	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_BUILDUP )
	weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
	if ( MarksmansTempo_Validate( weapon, settings ) )
	{
		float graceTime = weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) ? settings.graceTimeInTempo : settings.graceTimeBuildup
		if ( Time() <= weapon.GetScriptTime1() + graceTime  )
		{
			int newShotCount = minint( weapon.GetScriptInt1() + 1, settings.requiredShots )
			weapon.SetScriptInt1( newShotCount )
			if ( newShotCount >= settings.requiredShots )
			{
				weapon.AddMod( MOD_MARKSMANS_TEMPO_ACTIVE )
			}

			if ( !weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) )
			{
				weapon.AddMod( MOD_MARKSMANS_TEMPO_BUILDUP )
			}

			if ( useOnFireFadeoff )
				thread MarksmansTempo_Fadeoff( weapon, settings, settings.fadeoffOnFire )
		}
		else
		{
			MarksmansTempo_ClearTempo( weapon, settings )
		}
	}
}

void function MarksmansTempo_ClearTempo( entity weapon, MarksmansTempoSettings settings )
{

		if ( !InPrediction() )
			return


	weapon.SetScriptInt1( 0 )
	MarksmansTempo_ClearMods( weapon )
}

void function MarksmansTempo_RemoveTempo( entity weapon, MarksmansTempoSettings settings )
{

		if ( !InPrediction() )
			return


	weapon.SetScriptInt1( -1 ) 
	MarksmansTempo_ClearMods( weapon )
}

void function MarksmansTempo_ClearMods( entity weapon )
{
	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_ACTIVE )
	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_BUILDUP )
}












void function ShatterRounds_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( mod != SHATTER_ROUNDS_HIPFIRE_MOD )
		return

	if ( !IsValid( weapon ) )
		return

	ShatterRounds_AddShatterRounds( weapon )
}


void function ShatterRounds_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( mod != SHATTER_ROUNDS_HIPFIRE_MOD )
		return

	if ( !IsValid( weapon ) )
		return

	ShatterRounds_RemoveShatterRounds( weapon )
}


void function ShatterRounds_UpdateShatterRoundsThink( entity weapon )
{
	AssertIsNewThread()
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( SHATTER_ROUNDS_THINK_END_SIGNAL )
	weapon.EndSignal( "OnDestroy" )

	Assert( eShatterRoundsTypes._count == 2 )

	WaitFrame()		

	int curState = -1
	while ( true )
	{
		if ( !IsValid( player ) || !IsValid( weapon ) )
			return

		if ( weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) && curState != 0 )
		{
			ShatterRounds_AddShatterRounds( weapon )
			curState = 0
		}
		else if ( !weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) && curState != 1 )
		{
			ShatterRounds_RemoveShatterRounds( weapon )
			curState = 1
		}

		WaitFrame()
	}
}

void function ShatterRounds_AddShatterRounds( entity weapon )
{





		if ( weapon.GetWeaponClassName() == "mp_weapon_bow" )
			WeaponBow_UpdateArrowColor( weapon, eShatterRoundsTypes.SHATTER_TRI )


}

void function ShatterRounds_RemoveShatterRounds( entity weapon )
{





		if ( weapon.GetWeaponClassName() == "mp_weapon_bow" )
			WeaponBow_UpdateArrowColor( weapon, eShatterRoundsTypes.STANDARD )

}




































































































void function ServerToClient_Activate_Smart_Reload( entity weapon, int overloadAmmo, float lowAmmoFrac )
{
	SmartReloadSettings settings
	settings.OverloadedAmmo = overloadAmmo
	settings.LowAmmoFrac = lowAmmoFrac

	OnWeaponActivate_Smart_Reload( weapon, settings )
}




void function OnWeaponActivate_Smart_Reload( entity weapon, SmartReloadSettings settings )
{
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()

	if ( IsValid( player ) )
	{

		int slot = GetSlotForWeapon( player, weapon )
		if ( slot >= 0 )
			weapon.w.activeOptic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
		else
			weapon.w.activeOptic = ""

		ApplySmartReloadFunctionality ( player, weapon, settings )
	}
}

void function ApplySmartReloadFunctionality( entity player, entity weapon, SmartReloadSettings settings )
{




	thread ApplySmartReloadFunctionality_ClientThink ( player, weapon, settings )

}

void function OnWeaponReload_Smart_Reload( entity weapon, int milestoneIndex )
{
	LootData weaponLootData = SURVIVAL_Loot_GetLootDataByRef( weapon.GetWeaponClassName() )

	SmartReloadSettings settings
	settings.OverloadedAmmo				 = GetWeaponInfoFileKeyField_GlobalInt( weaponLootData.baseWeapon, OVERLOAD_AMMO_SETTING )

	entity player = weapon.GetWeaponOwner()
	int clipCount = weapon.GetWeaponPrimaryClipCount()
	int maxClipCount = weapon.GetWeaponPrimaryClipCountMax ()
	int maxClipWithoutOverloadedAmmo = maxClipCount - settings.OverloadedAmmo
	int overFlowAmmo = clipCount - maxClipWithoutOverloadedAmmo
	string ammoType = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )
	int ammoPoolType = eAmmoPoolType[ ammoType ]


	if ( !weapon.HasMod( SMART_RELOAD_HOPUP ) )
	{
		weapon.RemoveMod( LMG_OVERLOADED_AMMO_MOD )
		weapon.RemoveMod( LMG_FAST_RELOAD_MOD )
	}

	if ( weapon.HasMod( LMG_FAST_RELOAD_MOD ) )
	{

		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return

		EmitSoundOnEntity( player, "UI_InGame_BoostedLoader_Reload" )

	}
	else
	{






































		weapon.RemoveMod( LMG_OVERLOADED_AMMO_MOD )
	}
}























void function OnWeaponDeactivate_Smart_Reload ( entity weapon )
{
	weapon.Signal ( END_SMART_RELOAD )
	entity player = weapon.GetWeaponOwner()

	if( !IsValid( weapon ) || !IsValid( player) )
		return













}

void function ApplySmartReloadFunctionality_ClientThink ( entity player, entity weapon, SmartReloadSettings settings )
{

		AssertIsNewThread()
		weapon.EndSignal( "OnDestroy" )
		weapon.EndSignal( END_SMART_RELOAD )

		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return
		player.EndSignal( "OnDeath" )

		vector lowAmmoColor      = SrgbToLinear( LOWAMMO_UI_COLOR )
		vector normalAmmoColor   = SrgbToLinear( NORMALAMMO_UI_COLOR )
		vector overloadAmmoColor = SrgbToLinear( OVERLOADAMMO_UI_COLOR )
		vector outofAmmoColor    = SrgbToLinear( OUTOFAMMO_UI_COLOR )

		int clipCount
		int maxClipCount
		int overloadClipCount
		int maxAmmoRequiredCount
		float clipCountFrac = 1.0
		float offset = 0.05
		var rui = ClWeaponStatus_GetWeaponHudRui( player )
		var reloadRui = GetAmmoStatusHintRui()
		var crosshairRui = CreateCockpitPostFXRui( $"ui/ammo_status_hint.rpak", HUD_Z_BASE )
		var chargeBarRui = CreateCockpitPostFXRui( $"ui/crosshair_reload_hopup_bar.rpak" )

		OnThreadEnd(
			function() : ( player, weapon, rui, reloadRui, crosshairRui, chargeBarRui )
			{
				RuiDestroy( crosshairRui )
				RuiDestroy( chargeBarRui )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetFloat3( rui, "ammoGlowColor", SrgbToLinear( NORMALAMMO_UI_COLOR ) )
			}
		)

		while ( true )
		{
			clipCount = weapon.GetWeaponPrimaryClipCount()
			maxClipCount = weapon.GetWeaponPrimaryClipCountMax()
			overloadClipCount = maxClipCount - settings.OverloadedAmmo
			maxAmmoRequiredCount = int( maxClipCount * settings.LowAmmoFrac)
			clipCountFrac = float( clipCount) / float( maxClipCount )

			if ( weapon.HasMod( LMG_FAST_RELOAD_MOD ) && weapon.IsReloading() )
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", true )
				RuiSetBool( crosshairRui, "showHopupReloadBG", true )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && weapon.HasMod( LMG_OVERLOADED_AMMO_MOD ) && clipCount > overloadClipCount )
			{
				RuiSetFloat3( rui, "ammoGlowColor", overloadAmmoColor )
				RuiSetFloat3( chargeBarRui, "bracketColor", overloadAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", true )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && clipCount > MIN_AMMO_REQUIRED && clipCount <= maxAmmoRequiredCount )
			{
				RuiSetFloat3( rui, "ammoGlowColor", lowAmmoColor )
				RuiSetFloat3( chargeBarRui, "bracketColor", lowAmmoColor )
				RuiSetBool( reloadRui, "showHopupReloadIcon", true )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && clipCount == 0 )
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", outofAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", false )
			}
			else
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", normalAmmoColor )
				RuiSetFloat3( rui, "ammoGlowColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", false )
			}

			if ( weapon.HasMod( SMART_RELOAD_HOPUP ) )
			{
				RuiSetBool( chargeBarRui, "isActive", true )
				RuiSetFloat( chargeBarRui, "energizeFrac", clipCountFrac )
				RuiSetFloat( chargeBarRui, "adsFrac", player.GetZoomFrac() )

				switch ( weapon.w.activeOptic )
				{
					case "":	
					offset = 0.05
					break
					case "optic_cq_hcog_classic":
						offset = 0.08
						break
					case "optic_cq_holosight":
						offset = 0.11
						break
					case "optic_cq_hcog_bruiser":
						offset = 0.09
						break
					case "optic_cq_holosight_variable":
						offset = 0.09
						break
					case "optic_ranged_hcog":
						offset = 0.11
						break
					case "optic_ranged_aog_variable":
						offset = 0.14
						break
					case "optic_cq_threat":
						offset = 0.07
						break
				}
				RuiSetFloat( chargeBarRui, "offset", offset )
			}
			WaitFrame()
		}

}

void function ApplySmartReloadFunctionality_ServerThink ( entity player, entity weapon, SmartReloadSettings settings )
{


























}

bool function IsTurretWeapon( entity weapon )
{
	if( !IsValid( weapon ) || !weapon.IsWeaponX() )
		return false

	return ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault( weapon.GetWeaponClassName(), "is_turret_weapon" , 0 ) == 1 )
}

bool function IsHMGWeapon( entity weapon )
{
	if( !IsValid( weapon ) || !weapon.IsWeaponX() )
		return false

	return ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault( weapon.GetWeaponClassName(), "is_hmg_weapon" , 0 ) == 1 )
}

bool function IsMeleeWeapon( entity weapon )
{
	if( !IsValid( weapon ) || !weapon.IsWeaponX() )
		return false

	return ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault( weapon.GetWeaponClassName(), "is_Melee_Weapon" , 0 ) == 1 )
}

bool function IsWeaponSemiAuto( entity weapon )
{
	return weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )
}

void function OnWeaponActivate_Kinetic_Loader( entity weapon)
{
	if ( !IsValid( weapon ) )
		return

	if( !weapon.IsWeaponX() )
		return

	entity player = weapon.GetWeaponOwner()

	if ( IsValid( player ) )
	{
		if ( weapon.HasMod ( KINETIC_LOADER_HOPUP ) )
		{

			if ( InPrediction() )

			{
				
				if ( weapon.HasMod( "hopup_kinetic_choke" ) && weapon.HasMod( "kinetic_choke" ) )
				{
						weapon.RemoveMod( "kinetic_choke" )
				}
			}

			ApplyKineticLoaderFunctionality( player, weapon )
		}

	}
}

void function OnWeaponDeactivate_Kinetic_Loader( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if( !weapon.IsWeaponX() )
		return

	weapon.Signal( END_KINETIC_LOADER )
	weapon.Signal( END_KINETIC_LOADER_CHOKE )


	weapon.Signal( END_KINETIC_LOADER_RUI )

}

void function ApplyKineticLoaderFunctionality( entity player, entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if( !weapon.IsWeaponX() )
		return

	if ( !IsValid( player ) )
		return

	weapon.Signal( END_KINETIC_LOADER )
	weapon.Signal( END_KINETIC_LOADER_CHOKE )







		weapon.Signal( END_KINETIC_LOADER_RUI )
		thread ApplyKineticLoader_ClientThink( player, weapon )

}

void function KineticLoaderChokeFunctionality_ServerThink( entity player, entity weapon )
{


























































}
void function KineticLoaderFunctionality_ServerThink( entity player, entity weapon )
{






































































































}
void function KineticLoaderChokeGraceWindow_ServerThink( entity player, entity weapon )
{
































































}











































void function ServerCallback_KineticLoaderReloadedThroughSlide( entity weapon, int ammoToLoadTotal )
{
	if ( !IsValid( weapon ) )
		return

	file.weaponReloadedThroughSlideTable[weapon] <- true
	file.weaponAmmoToLoadTotalTable[weapon] <- ammoToLoadTotal
}
void function ServerCallback_KineticLoaderReloadedThroughSlideEnd( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if( weapon in file.weaponReloadedThroughSlideTable )
		delete file.weaponReloadedThroughSlideTable[ weapon ]

	if( weapon in file.weaponAmmoToLoadTotalTable )
		delete file.weaponAmmoToLoadTotalTable[ weapon ]
}


void function ApplyKineticLoader_ClientThink( entity player, entity weapon )
{

		AssertIsNewThread()
		weapon.EndSignal( "OnDestroy" )
		weapon.EndSignal( END_KINETIC_LOADER_RUI )

		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return

		player.EndSignal( "OnDeath" )

		vector lowAmmoColor      = SrgbToLinear( OVERLOADAMMO_UI_COLOR )
		vector normalAmmoColor   = SrgbToLinear( NORMALAMMO_UI_COLOR )

		var rui = ClWeaponStatus_GetWeaponHudRui( player )
		var crosshairRui = CreateCockpitPostFXRui( $"ui/ammo_status_hint.rpak", HUD_Z_BASE )

		OnThreadEnd(
			function() : ( player, weapon, crosshairRui )
			{
				RuiDestroy( crosshairRui )
				if( weapon in file.weaponReloadedThroughSlideTable )
					delete file.weaponReloadedThroughSlideTable[ weapon ]

				if( weapon in file.weaponAmmoToLoadTotalTable )
					delete file.weaponAmmoToLoadTotalTable[ weapon ]
			}
		)

		if (!IsValid( weapon ) || !IsValid( player ) )
			return


		string ammoTypeRef = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )
		asset ammoIcon = $""
		if ( SURVIVAL_Loot_IsRefValid( ammoTypeRef ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoTypeRef )
			ammoIcon = ammoData.hudIcon
		}

		
		string mod = GetInstalledWeaponAttachmentForPoint( weapon, "mag" )
		int magTier = 4
		asset magIcon = $""
		LootData weaponData = SURVIVAL_GetLootDataFromWeapon( weapon )

		if ( SURVIVAL_Loot_IsRefValid ( mod ) ) 
		{
			LootData magData = SURVIVAL_Loot_GetLootDataByRef( mod )
			magTier = magData.tier
			magIcon = magData.hudIcon
		}

		float UiStartTime = -1

		while ( IsValid( weapon ) && IsValid( player ))
		{
			int ammoToLoadTotal = 0
			bool reloadedThroughSlide = false

			if( weapon in file.weaponAmmoToLoadTotalTable )
				ammoToLoadTotal = file.weaponAmmoToLoadTotalTable[ weapon ]

			if( weapon in file.weaponReloadedThroughSlideTable )
				reloadedThroughSlide = file.weaponReloadedThroughSlideTable[ weapon ]

			if ( reloadedThroughSlide )
			{
				if( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) == weapon  )
				{
					if( UiStartTime != -1 )
					{
						RuiSetFloat( rui, "passiveHoldTime", 0 )
					}

					string ammoToLoadSting = Localize( "#WPN_HOPUP_KINETIC_LOADER_RELOAD_HINT", ammoToLoadTotal )
					RuiSetString( crosshairRui, "ammoToLoadString", ammoToLoadSting )
					RuiSetFloat3( rui, "ammoGlowColor", lowAmmoColor )
					RuiSetBool( crosshairRui, "showKineticReloadText", true )
					RuiSetBool( crosshairRui, "showHopupKineticReloadBG", true )

				}
				else
				{
					if( UiStartTime == -1 )
					{
						UiStartTime = Time()
						RuiSetFloat3( rui, "ammoGlowColor", normalAmmoColor )
						RuiSetBool( crosshairRui, "showKineticReloadText", false )
						RuiSetBool( crosshairRui, "showHopupKineticReloadBG", false )
					}

					RuiSetString( rui, "passiveDesc", Localize( "#WPN_HOPUP_KINETIC_LOADER_RELOAD_HINT", ammoToLoadTotal ) )
					RuiSetImage( rui, "passiveMagIcon", magIcon )
					RuiSetImage( rui, "passiveIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )
					RuiSetImage( rui, "passiveAmmoIcon", ammoIcon )
					RuiSetInt( rui, "passiveTier", magTier )
					RuiSetInt( rui, "passiveAltTier", weaponData.tier )
					RuiSetBool( rui, "displayPassiveBonusPopup", !GetCurrentPlaylistVarBool( "hud_hide_infopopup", false ) )

					float timeDiff = Time() - UiStartTime 
					RuiSetGameTime( rui, "passiveActivationTime", UiStartTime )
					RuiSetFloat( rui, "passiveHoldTime", max( timeDiff, 3.0 ) )

				}
			}
			else
			{
				UiStartTime = -1

				RuiSetFloat3( rui, "ammoGlowColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showKineticReloadText", false )
				RuiSetBool( crosshairRui, "showHopupKineticReloadBG", false )
			}

			WaitFrame()
		}

}

























































bool function GetInfiniteAmmo( entity weapon )
{
	return weapon.GetInfiniteAmmoState() != INFINITEAMMO_NONE
}





























































































































































































bool function CodeCallback_GetIsModOptic( entity weapon, string modName )
{
	return SURVIVAL_Loot_IsRefValid( weapon.GetWeaponClassName() ) && SURVIVAL_Loot_IsRefValid( modName ) && GetAttachPointForAttachmentOnWeapon( weapon.GetWeaponClassName(), modName ) == "sight"
}

bool function PlayerHasWeapon( entity player, string weaponName )
{
	array<entity> weapons = player.GetMainWeapons()
	weapons.extend( player.GetOffhandWeapons() )

	foreach ( weapon in weapons )
	{
		if ( weapon.GetWeaponClassName() == weaponName )
			return true
	}

	return false
}

bool function PlayerCanUseWeapon( entity player, string weaponClass )
{
	return ((player.IsTitan() && weaponClass == "titan") || (!player.IsTitan() && weaponClass == "human"))
}

array<string> function GetValidLootModsInstalled( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return []

	bool dropOpticForKittedWeapons = ShouldDropOpticForKittedWeapon()

	if ( !dropOpticForKittedWeapons )
	{
		if ( SURVIVAL_Weapon_IsAttachmentLocked( weaponName ) )
			return []
	}

	array<string> mods = GetWeaponMods( weapon )
	array<string> validMods
	foreach ( mod in mods )
	{
		if ( SURVIVAL_Loot_IsRefValid( mod ) )
		{
			if ( dropOpticForKittedWeapons )
			{
				string attachPoint = GetAttachPointForAttachmentOnWeapon( weaponName, mod )

				if ( !SURVIVAL_Weapon_IsAttachmentLocked( weaponName ) || attachPoint == "sight" )
					validMods.append( mod )
			}
			else
			{
				validMods.append( mod )
			}
		}
	}

	return validMods
}

array<string> function GetNonInstallableWeaponMods( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( weapon.GetNetworkedClassName() != "prop_survival" && !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return weapon.GetMods()

	bool isAttachmentLocked = SURVIVAL_Weapon_IsAttachmentLocked( weaponName )

	array<string> mods = GetWeaponMods( weapon )
	array<string> foundMods
	array<string> installedMods

	foreach ( mod in mods )
	{
		if ( ShouldDropOpticForKittedWeapon() )
		{
			if ( !CanAttachToWeapon( mod, weaponName ) )
				foundMods.append( mod )
			else
				installedMods.append( mod )
		}
		else
		{
			if ( !CanAttachToWeapon( mod, weaponName ) || isAttachmentLocked )
				foundMods.append( mod )
			else
				installedMods.append( mod )
		}
	}

	VerifyToggleMods( foundMods )

	return foundMods
}

array<string> function GetNonInstallableTrackableWeaponMods( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( weapon.GetNetworkedClassName() != "prop_survival" && !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return weapon.GetMods()

	bool isAttachmentLocked = SURVIVAL_Weapon_IsAttachmentLocked( weaponName )

	array<string> mods = GetWeaponMods( weapon )
	array<string> trackedMods

	foreach ( mod in mods )
	{
		if ( ( !CanAttachToWeapon( mod, weaponName ) || isAttachmentLocked ) && file.nonInstalledModsTracked.contains( mod ) )
			trackedMods.append( mod )
	}

	return trackedMods
}

string function GetWeaponClassName( entity weaponOrProp )
{
	string weaponName
	if ( weaponOrProp.GetNetworkedClassName() == "prop_survival" )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( weaponOrProp.GetSurvivalInt() )
		weaponName = data.ref
	}
	else
	{
		weaponName = weaponOrProp.GetWeaponClassName()
	}

	return weaponName
}

array<string> function GetWeaponMods( entity weaponOrProp )
{
	array<string> mods
	if ( weaponOrProp.GetNetworkedClassName() == "prop_survival" )
		mods = weaponOrProp.GetWeaponMods()
	else
		mods = weaponOrProp.GetMods()

	return mods
}

int function GetSlotForWeapon( entity player, entity weapon )
{

		array<int> slots = [ WEAPON_INVENTORY_SLOT_PRIMARY_0, WEAPON_INVENTORY_SLOT_PRIMARY_1, SLING_WEAPON_SLOT, WEAPON_INVENTORY_SLOT_ANTI_TITAN, WEAPON_INVENTORY_SLOT_DUALPRIMARY_0, WEAPON_INVENTORY_SLOT_DUALPRIMARY_1, SLING_AKIMBO_WEAPON_SLOT ]




	foreach ( slot in slots )
	{
		if ( player.GetNormalWeapon( slot ) == weapon )
			return slot
	}

	return -1
}


bool function CanAttachToWeapon( string attachment, string weaponName )
{
	if ( weaponName == "" )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( attachment ) )
		return false

	
	if ( !IsValidAttachment( attachment ) )
		return false

	bool isValidMode = true




	if ( SURVIVAL_Weapon_IsAttachmentLocked( weaponName ) && isValidMode )
	{
		if ( SURVIVAL_IsAttachmentPointLocked( weaponName, GetAttachPointForAttachmentOnWeapon( weaponName, attachment ) ) )
			return false

		weaponName = GetBaseWeaponRef( weaponName )
	}

	AttachmentData aData = GetAttachmentData( attachment )

	return (aData.compatibleWeapons.contains( weaponName ))
}

string function GetBaseWeaponRef( string weaponRef )
{
	if ( SURVIVAL_Loot_IsRefValid( weaponRef ) )
	{
		LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
		return weaponData.baseWeapon != "" ? weaponData.baseWeapon : weaponRef 
	}
	return weaponRef
}



array<string> function GetLockedSetsDisabledByCrafting()
{
	array<string> sets

	sets.append( WEAPON_LOCKEDSET_SUFFIX_WHITESET )
	sets.append( WEAPON_LOCKEDSET_SUFFIX_BLUESET )
	sets.append( WEAPON_LOCKEDSET_SUFFIX_PURPLESET )
	sets.append( WEAPON_LOCKEDSET_SUFFIX_GOLD )

	return sets
}

bool function AttachmentPointSupported( string attachmentPoint, string weaponName )
{
	LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponName )

	array<string> allAttachPoints = weaponData.supportedAttachments
	return allAttachPoints.contains( attachmentPoint )
}

string function GetAttachmentPointStyle( string attachmentPoint, string weaponName )
{
	switch ( attachmentPoint )
	{
		case "sight":
			break

		case "grip":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, "grip" ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				return attachmentData.attachmentStyle
			}
			break

		case "barrel":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, "barrel" ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				return attachmentData.attachmentStyle
			}

			break

		case "mag":
			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponName )
			if ( weaponData.ammoType == BULLET_AMMO )
				return "mag_straight"
			if ( weaponData.ammoType == SPECIAL_AMMO || weaponData.ammoType == ARROWS_AMMO )
				return "mag_energy"
			if ( weaponData.ammoType == SHOTGUN_AMMO )
				return "mag_shotgun"
			if ( weaponData.ammoType == SNIPER_AMMO )
				return "mag_sniper"
			if ( weaponData.ref == "mp_weapon_car" )
				return "mag_car"

			break

		case "hopup":
		case "hopupMulti_a":
		case "hopupMulti_b":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			string attachmentStyle = ""
			bool moreThanOneHopup = false
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, attachmentPoint ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				if ( attachmentStyle != "" && !attachmentData.lootTags.contains( "FakeHopup" ) )
				{
					moreThanOneHopup = true
					break
				}

				if ( !attachmentData.lootTags.contains( "FakeHopup" ) )
					attachmentStyle = attachmentData.attachmentStyle
			}

			if ( moreThanOneHopup )
				return attachmentPoint
			else if ( attachmentStyle != "" )
				return attachmentStyle

			break
	}

	return attachmentPoint
}

array<string> function GetAttachmentsForPoint( string attachmentPoint, string weaponName )
{
	array<string> attachmentRefs
	switch ( attachmentPoint )
	{
		case "hopup":
		case "hopupMulti_a":
		case "hopupMulti_b":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, attachmentPoint ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				if ( attachmentData.lootTags.contains ( "FakeHopup" ) )
					continue

				attachmentRefs.append( attachmentData.ref )
			}
			break

		default:
			Assert( false, "attachmentPoint " + attachmentPoint + " is not supported, but could be." )
	}

	return attachmentRefs
}

bool function HasWeapon( entity ent, string weaponClassName, array<string> mods = [], bool checkMods = true )
{
	Assert( ent.IsPlayer() || ent.IsNPC() )

	array<entity> weaponArray = ent.GetMainWeapons()
	foreach ( weapon in weaponArray )
	{
		if ( weapon.GetWeaponClassName() == weaponClassName )
		{
			if ( !checkMods )
				return true

			if ( WeaponHasSameMods( weapon, mods ) )
				return true
		}
	}

	return false
}

bool function WeaponHasSameMods( entity weapon, array<string> mods = [] )
{
	array hasMods = clone mods
	foreach ( mod in weapon.GetMods() )
	{
		hasMods.removebyvalue( mod )
	}

	
	return hasMods.len() == 0
}

int function GetWeaponIndex( entity player, entity weapon )
{
	array<int> primarySlots          = [ WEAPON_INVENTORY_SLOT_PRIMARY_0, WEAPON_INVENTORY_SLOT_PRIMARY_1 ]
	foreach ( slot in primarySlots )
	{
		if ( player.GetNormalWeapon( slot ) == weapon )
			return slot
	}
	return -1
}

bool function SimpleShouldNotBlockReloadCallback( entity player, entity ent )
{
	return false
}