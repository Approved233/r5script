

global function MpWeaponDragon_LMG_Init

global function OnWeaponActivate_weapon_dragon_lmg
global function OnWeaponDeactivate_weapon_dragon_lmg
global function OnWeaponPrimaryAttack_weapon_dragon_lmg
global function OnWeaponEnergizedStart_weapon_dragon_lmg
global function OnWeaponStartEnergizing_weapon_dragon_lmg
global function OnWeaponEnergizedEnd_weapon_dragon_lmg
global function OnWeaponStartZoomIn_weapon_dragon_lmg
global function OnWeaponStartZoomOut_weapon_dragon_lmg
global function OnWeaponOwnerChanged_weapon_dragon_lmg

global const string DRAGON_LMG_ENERGIZED_MOD = "energized"

const string DRAGON_CLASS_NAME = "mp_weapon_dragon_lmg"

const string CHARGING_SOUND_3P = "weapon_rampage_thermite_charge_3p"
const string CHARGE_END_SOUND_FP = "weapon_rampage_lmg_charge_end_1p"
const string CHARGE_END_SOUND_SHOOTING_FP = "weapon_rampage_lmg_charge_end_shooting_1p"
const string CHARGE_END_SOUND_3P = "weapon_rampage_lmg_charge_end_3p"
const string EQUIPPED_WHILE_CHARGED = "weapon_rampage_thermite_charge_04_equip"

const asset EFFECT_ENHANCED_MODE_FP = $"P_drg_ignited_amb_FP"
const asset EFFECT_ENHANCED_MODE_3P = $"P_drg_ignited_amb_3P"
const asset EFFECT_CHAMBER_OPENING_FP = $"P_rampage_chamber_opening"
const asset EFFECT_ENHANCED_MODE_SHOOTING_FP = $"P_Exhaust_drg_ignited_FP"
const asset EFFECT_ENHANCED_MODE_SHOOTING_3P = $"P_Exhaust_drg_ignited_3P"

const asset ENERGIZED_CROSSHAIR_RUI = $"ui/crosshair_energize_status_sentinel.rpak"


const asset AMMO_ENERGIZED_ICON = $"rui/hud/gametype_icons/survival/sur_ammo_crate_heavy_charged"
const asset ENERGIZE_UI_CONSUMABLE_ICON = $"rui/ordnance_icons/grenade_incendiary"

const string ENERGIZED_STATE_END = "energized_state_end"




void function MpWeaponDragon_LMG_Init()
{
	PrecacheWeapon( DRAGON_CLASS_NAME )
	PrecacheParticleSystem( EFFECT_ENHANCED_MODE_FP )
	PrecacheParticleSystem( EFFECT_ENHANCED_MODE_3P )
	PrecacheParticleSystem( EFFECT_ENHANCED_MODE_SHOOTING_FP )
	PrecacheParticleSystem( EFFECT_ENHANCED_MODE_SHOOTING_3P )
	PrecacheParticleSystem( EFFECT_CHAMBER_OPENING_FP )

	RegisterSignal( ENERGIZE_STATUS_RUI_ABORT_SIGNAL )
	RegisterSignal( ENERGIZED_STATE_END )
}




void function OnWeaponActivate_weapon_dragon_lmg( entity weapon )
{
	entity player = weapon.GetWeaponOwner()


































		if ( IsValid( player ) )
		{
			int slot = GetSlotForWeapon( player, weapon )
			if ( slot >= 0 )
				weapon.w.activeOptic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
			else
				weapon.w.activeOptic = ""

			thread UpdateWeaponEnergizeRui( player, weapon, ENERGIZE_UI_CONSUMABLE_ICON, ENERGIZED_CROSSHAIR_RUI, AMMO_ENERGIZED_ICON )
		}

		if ( weapon.HasMod( DRAGON_LMG_ENERGIZED_MOD ) )
		{
			weapon.EmitWeaponSound_1p3p( EQUIPPED_WHILE_CHARGED, $"" )

		}
		else
		{
			weapon.kv.rendercolor = "0 0 0"
		}

















	HopupGunshield_OnWeaponActivate( weapon )
}

void function OnWeaponDeactivate_weapon_dragon_lmg( entity weapon )
{




	weapon.StopWeaponEffect( EFFECT_ENHANCED_MODE_FP, EFFECT_ENHANCED_MODE_3P )
	weapon.StopWeaponSound( EQUIPPED_WHILE_CHARGED )







	HopupGunshield_OnWeaponDeactivate( weapon )
}

var function OnWeaponPrimaryAttack_weapon_dragon_lmg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	return ammoPerShot
}

void function OnWeaponStartEnergizing_weapon_dragon_lmg( entity weapon, entity player )
{
	if ( !IsValid( weapon ) )
		return

	weapon.PlayWeaponEffectNoCull ( EFFECT_CHAMBER_OPENING_FP, $"", "muzzle_flash" )
	weapon.EmitWeaponSound_1p3p( $"", CHARGING_SOUND_3P )
}

void function OnWeaponEnergizedStart_weapon_dragon_lmg( entity weapon, entity player, bool costConsumable )
{
	OnWeaponEnergizedStart( weapon, player, costConsumable )

	SetEnableEmission( weapon, true )










}

void function OnWeaponEnergizedEnd_weapon_dragon_lmg( entity weapon, entity player )
{





	Stop_Thermite_Effects( weapon )
	SetEnableEmission( weapon, false )

}

void function OnWeaponStartZoomIn_weapon_dragon_lmg( entity weapon )
{
	HopupGunshield_OnWeaponStartZoomIn( weapon )
}

void function OnWeaponStartZoomOut_weapon_dragon_lmg( entity weapon )
{
	HopupGunshield_OnWeaponStartZoomOut( weapon )
}

void function OnWeaponOwnerChanged_weapon_dragon_lmg( entity weapon, WeaponOwnerChangedParams changeParams )
{

}





























void function Stop_Thermite_Effects ( entity weapon )
{
	
	entity player = weapon.GetWeaponOwner()

	if (!IsValid( player ) )
		return

	if (!IsLocalViewPlayer( player ) )
		return

	if ( weapon.IsReadyToFire() )
		weapon.EmitWeaponSound_1p3p( CHARGE_END_SOUND_FP, $"" )
	else
		weapon.EmitWeaponSound_1p3p( CHARGE_END_SOUND_SHOOTING_FP, $"" )

	weapon.StopWeaponSound( "weapon_rampage_lmg_firstshot_1p_alt" )
	weapon.StopWeaponSound( "weapon_rampage_lmg_loop_1p_alt" )
	weapon.StopWeaponEffect( EFFECT_ENHANCED_MODE_FP, EFFECT_ENHANCED_MODE_3P )
}

void function SetEnableEmission( entity weapon, bool enable )
{
	if( enable )
		weapon.kv.rendercolor = "255 255 255"
	else
		weapon.kv.rendercolor = "0 0 0"
}


