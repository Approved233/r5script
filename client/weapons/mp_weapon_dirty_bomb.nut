global function MpWeaponDirtyBomb_Init

global function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb
global function OnWeaponTossPrep_weapon_dirty_bomb






global const string DIRTY_BOMB_TARGETNAME = "caustic_trap"
global const string CAUSTIC_DIRTY_BOMB_WEAPON_CLASS_NAME = "mp_weapon_dirty_bomb"

const asset DIRTY_BOMB_CANISTER_MODEL = $"mdl/props/caustic_gas_tank/caustic_gas_tank.rmdl"
const asset DIRTY_BOMB_CANISTER_FRIENDLY_MODEL = $"mdl/props/caustic_gas_tank/caustic_gas_tank_friendly.rmdl"


const asset DIRTY_BOMB_CANISTER_MODEL_BIG = $"mdl/props/caustic_gas_tank/caustic_gas_tank_big.rmdl"


const asset DIRTY_BOMB_CANISTER_EXP_FX = $"P_meteor_trap_EXP"
const asset DIRTY_BOMB_CANISTER_FX_ALL = $"P_gastrap_start"

const int DIRTY_BOMB_MAX_GAS_CANISTERS = 6

const string DIRTY_BOMB_WARNING_SOUND = "weapon_vortex_gun_explosivewarningbeep"

global const string DIRTY_BOMB_CLOUD_HOST_TARGETNAME = "caustic_trap_cloud_host"
const int DIRTY_BOMB_HEALTH = 150
const float DIRTY_BOMB_CLOUD_LINGER_TIME = 2.0
const asset DIRTY_BOMB_CANISTER_EXPLODE_FX = $"P_gastrap_destroyed"
const string DIRTY_BOMB_CANISTER_EXPLODE_SOUND = "GasTrap_Destroyed_Explo"
const float DIRTY_BOMB_GAS_DURATION = 11.0
const float DIRTY_BOMB_GAS_DURATION_NO_HEALTH = 12.5
const float DIRTY_BOMB_GAS_RADIUS = 256.0
const float DIRTY_BOMB_DETECTION_RADIUS = 140.0

const float DIRTY_BOMB_THROW_POWER = 1.0
const float DIRTY_BOMB_GAS_FX_HEIGHT = 45.0
const float DIRTY_BOMB_GAS_CLOUD_HEIGHT = 48.0


const float DIRTY_BOMB_ACTIVATE_DELAY = 0.2
const float DIRTY_BOMB_PLACEMENT_RANGE_MAX = 64
const float DIRTY_BOMB_PLACEMENT_RANGE_MIN = 32
const vector DIRTY_BOMB_BOUND_MINS = <-8, -8, -8>
const vector DIRTY_BOMB_BOUND_MAXS = <8, 8, 8>
const vector DIRTY_BOMB_PLACEMENT_TRACE_OFFSET = <0, 0, 128>
const float DIRTY_BOMB_ANGLE_LIMIT = 0.55
const float DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA = 20.0
const float DIRTY_BOMB_TRACE_HEIGHT_END_OFFSET = 36

const bool CAUSTIC_DEBUG_DRAW_PLACEMENT = false

struct DirtyBombPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool   doDeployAnim = true

	entity originalProjectile
}

struct
{






	bool causticTrapHealthEnabled
} file

void function MpWeaponDirtyBomb_Init()
{
	file.causticTrapHealthEnabled = GetCurrentPlaylistVarBool( "enable_caustic_trap_health", true )
	DirtyBombPrecache()







		AddCreateCallback( "prop_script", DirtyBomb_OnPropScriptCreated )

		AddCallback_MinimapEntShouldCreateCheck_Scriptname( DIRTY_BOMB_TARGETNAME, Minimap_DontCreateRuisForEnemies )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.DIRTY_BOMB, MINIMAP_OBJECT_RUI, MinimapPackage_DirtyBomb, FULLMAP_OBJECT_RUI, MinimapPackage_DirtyBomb )


		if( Perk_QuickPackup_RemoteInteractEnabled() )
		{
			

		}


}


void function DirtyBombPrecache()
{
	RegisterSignal( "DirtyBomb_Detonated" )
	RegisterSignal( "DirtyBomb_PickedUp" )
	RegisterSignal( "DirtyBomb_Disarmed" )
	RegisterSignal( "DirtyBomb_Active" )
	RegisterSignal( "DirtyBomb_Ready" )

	PrecacheScriptString( DIRTY_BOMB_TARGETNAME )
	if ( HasCausticTrapHealthEnabled() )
		PrecacheScriptString( DIRTY_BOMB_CLOUD_HOST_TARGETNAME )

	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_EXP_FX )
	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_FX_ALL )
	if ( HasCausticTrapHealthEnabled() )
        PrecacheParticleSystem( DIRTY_BOMB_CANISTER_EXPLODE_FX )
	PrecacheModel( DIRTY_BOMB_CANISTER_MODEL )

	if ( GetCurrentPlaylistVarBool( "enable_caustic_friendly_traps", true ) )
		PrecacheModel( DIRTY_BOMB_CANISTER_FRIENDLY_MODEL )


		PrecacheModel( DIRTY_BOMB_CANISTER_MODEL_BIG )



        RegisterSignal( "DirtyBomb_StopPlacementProxy" )

}

bool function HasCausticTrapHealthEnabled()
{
	return file.causticTrapHealthEnabled
}


























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































void function DirtyBomb_OnGainFocus( entity ent )
{
	if ( !IsValid( ent ) )
		return

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	if ( player == ent.GetBossPlayer() && ent.GetTargetName() == DIRTY_BOMB_TARGETNAME )
	{
		CustomUsePrompt_SetText( Localize( "#QUICK_PACKUP_PROMPT" ) )
		CustomUsePrompt_Show( ent )
	}
}

void function DirtyBomb_OnLoseFocus( entity ent )
{
	CustomUsePrompt_ClearForAny()
}


void function DirtyBomb_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case DIRTY_BOMB_TARGETNAME:
			AddEntityCallback_GetUseEntOverrideText( ent, DirtyBomb_UseTextOverride )

			SetCallback_ShouldUseBlockReloadCallback( ent, Perk_QuickPackup_ShoudUseBlockReload )

			break

		case DIRTY_BOMB_CLOUD_HOST_TARGETNAME:
			SetAllowForKillreplayProjectileCam( ent )
			SetCustomKillreplayChaseCamFromWeaponClass( ent, CAUSTIC_DIRTY_BOMB_WEAPON_CLASS_NAME )

			break
	}
}

string function DirtyBomb_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()

	if ( player.IsTitan() )
		return "#WPN_DIRTY_BOMB_NO_INTERACTION"

	if ( player == ent.GetBossPlayer() )
	{
		return ""
	}

	return "#WPN_DIRTY_BOMB_NO_INTERACTION"
}






var function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	vector angularVelocity = <0,0,500>
	entity deployable = ThrowDeployable( weapon, attackParams, DIRTY_BOMB_THROW_POWER, OnDirtyBombPlanted, null, angularVelocity )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )




















	}

	return ammoReq
}


void function OnWeaponTossPrep_weapon_dirty_bomb( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}


void function RestoreDirtyBombAmmo( entity owner )
{
	if ( IsAlive( owner ) )
	{
		entity weapon = owner.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( IsValid( weapon ) && weapon.GetWeaponClassName() == CAUSTIC_DIRTY_BOMB_WEAPON_CLASS_NAME )
		{
			Weapon_AddSingleCharge( weapon )
		}
	}
}


void function OnDirtyBombPlanted( entity projectile, DeployableCollisionParams cp )
{





























}


void function MinimapPackage_DirtyBomb( entity ent, var rui )
{
#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/tactical_icons/tactical_caustic' icon to minimap" )
#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/tactical_icons/tactical_caustic" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/tactical_icons/tactical_caustic" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
}

