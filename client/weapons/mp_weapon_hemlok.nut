global function OnWeaponActivate_hemlok
global function OnWeaponDeactivate_hemlok
global function OnWeaponReload_weapon_hemlok

const string HEMLOK_CLASS_NAME = "mp_weapon_hemlok"

void function OnWeaponActivate_hemlok( entity weapon )
{
		if ( weapon.HasMod( "hopup_smart_reload" ) )
		{
			SmartReloadSettings settings
			settings.OverloadedAmmo				 = GetWeaponInfoFileKeyField_GlobalInt( HEMLOK_CLASS_NAME, OVERLOAD_AMMO_SETTING )
			settings.LowAmmoFrac				 = GetWeaponInfoFileKeyField_GlobalFloat( HEMLOK_CLASS_NAME, SMART_RELOAD_LOW_AMMO_FRAC_SETTING )

			OnWeaponActivate_Smart_Reload ( weapon, settings )
		}
		else
		{




		}
}

void function OnWeaponDeactivate_hemlok( entity weapon )
{
	OnWeaponDeactivate_Smart_Reload ( weapon )
}

void function OnWeaponReload_weapon_hemlok ( entity weapon, int milestoneIndex )
{
	OnWeaponReload_Smart_Reload ( weapon, milestoneIndex )
}


