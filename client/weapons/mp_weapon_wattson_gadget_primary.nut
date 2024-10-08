global function MpWeaponWattsonGadgetPrimary_Init

global function OnWeaponActivate_weapon_wattson_gadget_primary
global function OnWeaponDeactivate_weapon_wattson_gadget_primary

const asset watt_rod_amb = $"P_watt_heir_rod_amb"
const asset watt_rod_amb_3P = $"P_watt_heir_rod_amb_3P"
const asset watt_rod_front_amb = $"P_watt_heir_frnt_amb"
const asset watt_rod_front_amb_3P = $"P_watt_heir_frnt_amb_3P"
const asset watt_screen_dlight = $"P_watt_heir_dlight"
const asset watt_screen_dlight_3P = $"P_watt_heir_dlight_3P"





void function MpWeaponWattsonGadgetPrimary_Init()
{
	PrecacheParticleSystem( watt_rod_amb )
	PrecacheParticleSystem( watt_rod_front_amb )
	PrecacheParticleSystem( watt_rod_front_amb_3P )
	PrecacheParticleSystem( watt_rod_amb_3P )
	PrecacheParticleSystem( watt_screen_dlight )
	PrecacheParticleSystem( watt_screen_dlight_3P )


		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged_Callback )






}


void function OnSpectatorTargetChanged_Callback( entity player, entity prevTarget, entity newTarget )
{
	if( !IsValid( newTarget ) )
		return

	if( !newTarget.IsPlayer() )
		return

	entity weapon = newTarget.GetActiveWeapon( eActiveInventorySlot.mainHand  )
	if( IsValid( weapon ) && weapon.GetWeaponClassName() == "mp_weapon_wattson_gadget_primary")
		PlayEffects( weapon )
}


void function PlayEffects( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "gadget" )
	{
		weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_l_arm_bot", true )
		weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_r_arm_bot", true )
		weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_l_arm_top", true )
		weapon.PlayWeaponEffect( watt_rod_amb, watt_rod_amb_3P, "fx_r_arm_top", true )
		weapon.PlayWeaponEffect( watt_rod_front_amb, watt_rod_front_amb_3P, "fx_center_rod_tip", true )
		weapon.PlayWeaponEffect( watt_screen_dlight, watt_screen_dlight_3P, "fx_top", true )
	}







}

void function StopEffects( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "gadget" )
	{
		weapon.StopWeaponEffect( watt_rod_amb, watt_rod_amb_3P )
		weapon.StopWeaponEffect( watt_rod_front_amb, watt_rod_front_amb_3P )
		weapon.StopWeaponEffect( watt_screen_dlight, watt_screen_dlight_3P )
	}







}

void function OnWeaponActivate_weapon_wattson_gadget_primary( entity weapon )
{
	
	StopAttackEffects_melee_wattson_gadget( weapon )
	StopEffects( weapon )

	PlayEffects( weapon )
}

void function OnWeaponDeactivate_weapon_wattson_gadget_primary( entity weapon )
{
	StopEffects( weapon )
}