
global function MeleeHookSword_Init

global function OnWeaponActivate_melee_hook_sword
global function OnWeaponDeactivate_melee_hook_sword
global function OnWeaponOwnerChanged_melee_hook_sword

void function MeleeHookSword_Init() {}

void function OnWeaponActivate_melee_hook_sword( entity weapon )
{

		HookSword_ManageClientRuiVfx( weapon, true )

}

void function OnWeaponDeactivate_melee_hook_sword( entity weapon )
{

		HookSword_ManageClientRuiVfx( weapon, false )

}

void function OnWeaponOwnerChanged_melee_hook_sword( entity weapon, WeaponOwnerChangedParams params )
{
	OnWeaponOwnerChanged_weapon_hook_sword_primary( weapon, params ) 
}
                                                  