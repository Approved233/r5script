global function MpAbilityGibraltarShield_Init

global function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield
global function OnWeaponPrimaryAttack_ability_gibraltar_shield
global function OnWeaponChargeBegin_ability_gibraltar_shield
global function OnWeaponChargeEnd_ability_gibraltar_shield
global function OnWeaponOwnerChanged_ability_gibraltar_shield


global function OnCreateChargeEffect_ability_gibraltar_shield


global function IsGibraltarGunShieldEnt
global function GibraltarShield_RegisterNetworkFunctions






global const string GIBRALTAR_GUN_SHIELD_NAME = "gibraltar_gun_shield"

const vector SHIELD_ANGLE_OFFSET = <0, -90, 0>
const vector FX_GUN_SHILED_COLOR_1P = <125, 180, 255>
const vector FX_BUFFED_GUN_SHILED_COLOR_1P = <222, 157, 18> 
const asset FX_GUN_SHIELD_WALL = $"P_gun_shield_gibraltar_3P"
const asset FX_GUN_SHIELD_BREAK = $"P_gun_shield_gibraltar_break_CP_3P"
const asset FX_GUN_SHIELD_BREAK_FP = $"P_gun_shield_gibraltar_break_CP_FP"
const asset FX_GUN_SHIELD_SHIELD_COL = $"mdl/fx/gibralter_gun_shield.rmdl"

const string SOUND_PILOT_GUN_SHIELD_3P = "Gibraltar_GunShield_Sustain_3P"
const string SOUND_PILOT_GUN_SHIELD_1P = "Gibraltar_GunShield_Sustain_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_1P = "Gibraltar_GunShield_Destroyed_1P"
const string SOUND_PILOT_GUN_SHIELD_BREAK_3P = "Gibraltar_GunShield_Destroyed_3P"

const bool PILOT_GUN_SHIELD_DRAIN_AMMO = false
const float PILOT_GUN_SHIELD_DRAIN_AMMO_RATE = 1.0

const PLAYER_GUN_SHIELD_WALL_RADIUS = 18
const PLAYER_GUN_SHIELD_WALL_HEIGHT = 32
const PLAYER_GUN_SHIELD_WALL_FOV = 85

const int PILOT_SHIELD_OFFHAND_INDEX = OFFHAND_EQUIPMENT

struct
{
	var shieldRegenRui



} file

bool function IsGibraltarGunShieldEnt( entity ent )
{
	return ent.GetScriptName() == GIBRALTAR_GUN_SHIELD_NAME
}

void function MpAbilityGibraltarShield_Init()
{
	PrecacheWeapon( $"mp_ability_gibraltar_shield" )
	PrecacheScriptString( GIBRALTAR_GUN_SHIELD_NAME )

	PrecacheModel( FX_GUN_SHIELD_SHIELD_COL )

	PrecacheParticleSystem( FX_GUN_SHIELD_WALL )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK_FP )
	PrecacheParticleSystem( FX_GUN_SHIELD_BREAK )

	RegisterSignal( "GibraltarShieldDeactivate" )


		RegisterConCommandTriggeredCallback( "+scriptCommand5", GunShieldTogglePressed )

















}

void function GibraltarShield_RegisterNetworkFunctions()
{
	Remote_RegisterServerFunction( "ClientCallback_ToggleGibraltarShield" )
}


void function GunShieldTogglePressed( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return


		if ( !WeaponAllowsShield(activeWeapon))
			return


	if ( activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds() )
		Remote_ServerCallFunction( "ClientCallback_ToggleGibraltarShield" )
}
































































bool function WeaponAllowsShield( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	
	var allowShield = weapon.GetWeaponInfoFileKeyField( "allow_gibraltar_shield" )
	if ( allowShield != null && allowShield == 0 )
		return false


		if ( weapon.IsAkimboAvailable() && !weapon.IsAkimboDisabled() )
			return false


	return true
}


void function TrackPrimaryWeapon()
{
	entity oldPrimary

	while ( file.shieldRegenRui != null )
	{
		entity player = GetLocalViewPlayer()

		if ( IsAlive( player ) )
		{
			entity newPrimary = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

			if ( newPrimary != oldPrimary )
			{
				oldPrimary = newPrimary
				RuiSetBool( file.shieldRegenRui, "weaponAllowedToUseShield", WeaponAllowsShield( newPrimary ) )
			}

			bool playerUsePrompts = GetConVarBool( "player_use_prompt_enabled" )
			RuiSetBool( file.shieldRegenRui, "showPlayerHints", playerUsePrompts )
		}

		WaitFrame()
	}
}

void function CreateShieldRegenRui( entity weapon )
{
	file.shieldRegenRui = CreateCockpitRui( $"ui/gibraltar_shield_regen.rpak" )
	RuiTrackBool( file.shieldRegenRui, "weaponIsDisabled", weapon, RUI_TRACK_WEAPON_IS_DISABLED )

	thread TrackPrimaryWeapon()
}


void function OnWeaponOwnerChanged_ability_gibraltar_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{







	if ( file.shieldRegenRui == null && changeParams.newOwner == GetLocalViewPlayer() )
	{
		CreateShieldRegenRui( weapon )
	}
	else if ( changeParams.newOwner != GetLocalViewPlayer() )
	{
		if ( file.shieldRegenRui != null )
		{
			RuiDestroy( file.shieldRegenRui )
			file.shieldRegenRui = null
		}
	}

}

bool function OnWeaponChargeBegin_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !player.IsPlayer() )
		return true






	if ( file.shieldRegenRui == null )
	{
		CreateShieldRegenRui( weapon )
	}
	if ( InPrediction() && IsFirstTimePredicted() )
	{
		if ( player.GetSharedEnergyCount() > 0 )
		{
			weapon.EmitWeaponSound_1p3p( SOUND_PILOT_GUN_SHIELD_1P, SOUND_PILOT_GUN_SHIELD_3P )
		}
	}


	return true
}

void function OnWeaponChargeEnd_ability_gibraltar_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_1P )
	weapon.StopWeaponSound( SOUND_PILOT_GUN_SHIELD_3P )
}


void function OnCreateChargeEffect_ability_gibraltar_shield( entity weapon, int fxHandle )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return

	thread GribraltarShield_1pShieldColorFX( player, fxHandle )
}

void function GribraltarShield_1pShieldColorFX( entity player, int fxHandle )
{
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )

	bool hasGunshieldGenerator = false
	if( player.GetSharedEnergyTotal() > 50 ) 
		hasGunshieldGenerator = true

	vector color
	while ( PlayerIsInADS( player ) )
	{
		if ( !IsValid( player ) )
			return

		if ( hasGunshieldGenerator )
		{
			color = FX_BUFFED_GUN_SHILED_COLOR_1P
		}
		else
		{
			color = FX_GUN_SHILED_COLOR_1P
		}

		if ( player.GetSharedEnergyCount() <= 0 )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectSetControlPointVector( fxHandle, 2, <0, 0, 0> )
		}
		else
		{
			float frac = float( player.GetSharedEnergyCount() ) / float( player.GetSharedEnergyTotal() )
			vector colorVec = GetTriLerpColor( frac, COLOR_WHITE, LerpVector( color, <255, 255, 255>, 0.5 ), color, 0.6, 0.3 )
			if ( EffectDoesExist( fxHandle ) )
				EffectSetControlPointVector( fxHandle, 2, colorVec )
		}

		WaitFrame()
	}
}


bool function OnWeaponAttemptOffhandSwitch_ability_gibraltar_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return false

	entity mainWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !WeaponAllowsShield( mainWeapon ) )
	{


				if ( file.shieldRegenRui != null )
					RuiSetBool( file.shieldRegenRui, "weaponAllowedToUseShield", false )


		return false
	}

	return PlayerHasPassive( player, ePassives.PAS_ADS_SHIELD )
}

var function OnWeaponPrimaryAttack_ability_gibraltar_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

































































































































































































































































































































