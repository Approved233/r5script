global function OnWeaponActivate_weapon_semipistol
global function OnWeaponDeactivate_weapon_semipistol
global function OnWeaponReload_weapon_semipistol
global function OnProjectileCollision_weapon_semipistol



global function OnWeaponAkimboStateChanged_weapon_semipistol


void function OnWeaponActivate_weapon_semipistol( entity weapon )
{














}

void function OnWeaponDeactivate_weapon_semipistol( entity weapon )
{



}

void function OnWeaponReload_weapon_semipistol ( entity weapon, int milestoneIndex )
{



}


void function OnProjectileCollision_weapon_semipistol( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{



}


void function OnWeaponAkimboStateChanged_weapon_semipistol( entity weapon, entity player, int currentAkimboState )
{

		if ( player != GetLocalViewPlayer() || weapon.IsAkimboAlthand() )
			return

		UpdateHudDataForMainWeapons( player, weapon )

		var weaponRui = GetWeaponRui()
		OnPrimaryWeaponStatusUpdate_Akimbo( weapon, weaponRui )

}










































































































































