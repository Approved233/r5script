global function MpWeaponGrenadeCreepingBombardmentWeapon_Init
global function OnProjectileCollision_WeaponCreepingBombardmentWeapon

const asset CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_FX = $"P_smokescreen_FD"
const asset CREEPING_BOMBARDMENT_SMOKE_FX = $"P_bBomb_smoke"   

const float CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_DURATION = 15.0

const float CREEPING_BOMBARDMENT_WEAPON_DETONATION_DELAY = 6.0

const asset CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL = $"mdl/weapons_r5/misc_bangalore_rockets/bangalore_rockets_projectile.rmdl"

const CREEPING_BOMBARDMENT_WEAPON_NAME = "mp_weapon_creeping_bombardment_weapon"
const CREEPING_BOMBARDMENT_WEAPON_BOMB_IMPACT_TABLE = "exp_creeping_barrage_detonation"
global const CREEPING_BOMBARDMENT_TARGETNAME = "creeping_bombardment_projectile"

















void function MpWeaponGrenadeCreepingBombardmentWeapon_Init()
{




		AddTargetNameCreateCallback( CREEPING_BOMBARDMENT_TARGETNAME, OnCreepingBombardmentBombSpawned_Client )


	PrecacheParticleSystem( CREEPING_BOMBARDMENT_WEAPON_SMOKESCREEN_FX )


	PrecacheModel( CREEPING_BOMBARDMENT_WEAPON_BOMB_MODEL )
}

void function OnProjectileCollision_WeaponCreepingBombardmentWeapon( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
















}


























































































void function OnCreepingBombardmentBombSpawned_Client( entity bomb )
{
	SetAllowForKillreplayProjectileCam( bomb )
	SetCustomKillreplayChaseCamFromWeaponClass( bomb, CREEPING_BOMBARDMENT_WEAPON_NAME )

	
	entity player = GetLocalViewPlayer()
	ShowGrenadeArrow( player, bomb, 350, 0.0 )
}

