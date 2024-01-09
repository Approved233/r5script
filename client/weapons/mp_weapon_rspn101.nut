global function OnWeaponActivate_R101
global function OnWeaponDeactivate_R101
global function OnWeaponPrimaryAttack_R101






void function OnWeaponActivate_R101( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )

	OnWeaponActivate_RUIColorSchemeOverrides( weapon )










}

void function OnWeaponDeactivate_R101( entity weapon )
{

}

var function OnWeaponPrimaryAttack_R101( entity weapon, WeaponPrimaryAttackParams attackParams )
{

		if ( weapon.HasMod( "altfire_highcal" ) )
			thread PlayDelayedShellEject( weapon, RandomFloatRange( 0.03, 0.04 ) )



		GoldenHorsePurple_OnWeaponPrimaryAttack( weapon, attackParams )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

		GoldenHorsePurple_PostFire( weapon )


	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}