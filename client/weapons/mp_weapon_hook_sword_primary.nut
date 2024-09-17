
global function MpWeaponHookSwordPrimary_Init
global function OnWeaponActivate_weapon_hook_sword_primary
global function OnWeaponDeactivate_weapon_hook_sword_primary
global function OnWeaponOwnerChanged_weapon_hook_sword_primary

global function HookSword_ScriptAnimWindowStartCallback
global function HookSword_ScriptAnimWindowStopCallback

global function HookSword_ManageClientRuiVfx


global const string HOOK_SWORD_MP_WEAPON = "mp_weapon_hook_sword_primary"
global const string HOOK_SWORD_MELEE_WEAPON = "melee_hook_sword"
global const int HOOK_SWORD_KILL_COUNTER_ITEMFLAVOR_GUID = 1262292042
global const int HOOK_SWORD_WEAPON_ITEMFLAVOR_GUID = 575121714


const asset FX_RUI_SPINE = $"P_hooksword_holo_spine" 
const asset FX_RUI_KL = $"P_hooksword_holo_KL"  
const asset FX_TIP_DRAW_ELEC = $"P_hooksword_tip_draw_elec"


void function MpWeaponHookSwordPrimary_Init()
{


		PrecacheParticleSystem( FX_RUI_SPINE )
		PrecacheParticleSystem( FX_RUI_KL )
		PrecacheParticleSystem( FX_TIP_DRAW_ELEC )
		RegisterScriptAnimWindowCallbacks( "HookSword_PlayFX", HookSword_ScriptAnimWindowStartCallback, HookSword_ScriptAnimWindowStopCallback )

}

void function OnWeaponActivate_weapon_hook_sword_primary( entity weapon )
{
	Melee_SetModsForLegendAbilities( weapon.GetWeaponOwner() )


		HookSword_ManageClientRuiVfx( weapon, true )

}

void function OnWeaponDeactivate_weapon_hook_sword_primary( entity weapon )
{
	Melee_RemoveModsForLegendAbilities( weapon.GetWeaponOwner() )


		HookSword_ManageClientRuiVfx( weapon, false )

}

void function OnWeaponOwnerChanged_weapon_hook_sword_primary( entity weapon, WeaponOwnerChangedParams params )
{
	entity owner = params.newOwner
	if( !IsValid( owner ) || owner.IsBot() )
		return

	ItemFlavor killCounter   = GetItemFlavorByGUID( HOOK_SWORD_KILL_COUNTER_ITEMFLAVOR_GUID )
	ItemFlavor swordItemFlav = GetItemFlavorByGUID( HOOK_SWORD_WEAPON_ITEMFLAVOR_GUID )
	if ( Loadout_GetEquippedMeleeAddOnsForWeapon( ToEHI( owner ), swordItemFlav ).contains( killCounter ) == false )
		return


		if ( owner == GetLocalClientPlayer() ) 
		{
			RegisterNetVarEntityChangeCallback( "killLeader", void function( entity player, entity new ) : ( owner, weapon ) {
				if ( IsValid( weapon ) )
					MeleeAddons_SetIsKillLeader( weapon, owner )
			} )


			if( GameMode_IsActive( eGameModes.CONTROL ) )
			{
				Control_AddExpLeaderChangedCallback( void function( entity player ) : ( owner, weapon ) {
					if ( IsValid( weapon ) )
						MeleeAddons_SetIsMixtapeLeader( weapon, ( player == owner ) )
				} )
			}

		}










}


void function HookSword_ManageClientRuiVfx( entity weapon, bool start )
{
	if ( start )
	{
		int flags = weapon.GetScriptFlags0()
		if ( IsBitFlagSet( flags, MELEE_ADDONS_IS_OWNED ) )
			weapon.PlayWeaponEffect( FX_RUI_SPINE, $"", "FX_base", true )
		if ( bool ( weapon.GetScriptClientInt0() ) )
			weapon.PlayWeaponEffect( FX_RUI_KL, $"", "FX_blade_pivot", true )
	}
	else
	{
		weapon.StopWeaponEffect( FX_RUI_SPINE, $"" )
		weapon.StopWeaponEffect( FX_RUI_KL, $"" )
	}
}

void function HookSword_ScriptAnimWindowStartCallback( entity ent, string parameter )
{
	if ( ent.IsCloaked( true ) )
		return

	StartParticleEffectOnEntity( ent, GetParticleSystemIndex( FX_TIP_DRAW_ELEC ), FX_PATTACH_POINT_FOLLOW, ent.LookupAttachment( "FX_Blade_3" ) )
}

void function HookSword_ScriptAnimWindowStopCallback( entity ent, string parameter )
{
}

















                                                  