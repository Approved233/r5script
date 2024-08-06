

global function PlaylistVar_CRng_Spawning

global function CombatRange_Init
global function GetCombatRangeRealm

#if DEV
global function DEV_DebugSpawnPrintOn
#endif





















































global function SCB_DynDummie_Spawns_Changed







const string TARGET_SPAWNPOINT_CLASSNAME = "info_spawnpoint_combatrange_target"
const string TARGET_SPAWNPOINT_CLASSNAME_OLD = "info_spawnpoint_spectre"
const string DUMMIE_SPAWNPOINT_CR_SCRIPTNAME = "dummie_spawn_dynamic_cr"
const string DUMMIE_SPAWNPOINT_FR_SCRIPTNAME = "dummie_spawn_dynamic_fr"

const string DYNAMIC_DUMMIE_TARGETNAME = "dynamic_dummie"

const float COMBATRANGE_MAX = 10000.0
const float TARGET_SPAWN_DELAY = 1.0

const string PLV_CRNG_SPAWNING = "has_combatrange_spawning"
const string PLV_CRNG_RANDOMWEAPONS = "has_combatrange_randomweapons"
const string PLV_CRNG_ANNOUNCER = "has_combatrange_announcer"
const string PLV_DYNAMICDUMMIES_EVERYWHERE = "has_dynamicdummies_everywhere"

const int INVALID_REALM = -99


const int COMBATRANGE_SPAWNPOINT_FACING_THRESHOLD = 60
const int COMBATRANGE_SPAWNPOINT_RECENTUSE_ARRAY_LENGTH = 7

enum eCRng_DummieSpawningTypes
{
	NONE,
	FRESH_SPAWN,
	CULL_RESPAWN,
	REFRESH_RESPAWN,
	DESPAWN,
	COUNT_
}

enum eCRng_AnnounceTypes
{
	SPAWN_STARTING,
	SPAWN_ENDINGSOON,
	SPAWN_DISABLED,
	COUNT_
}

struct CRngTarget
{
	entity targetDummy
	int team
}


struct sSpawnLoc
{
	entity spawnPt
	bool isInFacing
	bool isVisible
	array< entity > spawnPts_InRanges
}

struct
{
















































#if DEV
		bool dev_PrintsOn = false
		bool dev_spawnPrintsOn = false
#endif
} file
















void function CombatRange_RegisterRemoteFunctions( )
{
	int settingTypesCount = eCRng_SettingTypes.COUNT_
	int settingChangeTypesCount = eDummieSettingChangeType.COUNT_

	Remote_RegisterServerFunction( "DynSpawns_AutoStart" )

	Remote_RegisterServerFunction( "UCB_DynSpawns_SetActive", "bool" )

	Remote_RegisterServerFunction( "UICallback_ClearAndSpawnNewDummies" )
	Remote_RegisterServerFunction( "UICallback_RespawnDummiesInPlace" )

	Remote_RegisterClientFunction ( "SCB_DynDummie_Spawns_Changed" )
}

void function CombatRange_Init()
{
	
	if( !PlaylistVar_CRng_Spawning() )
		return

	
	string mapName = GetMapName()
#if DEV
		printt( format( "%s(): Map Name == %s" , FUNC_NAME(), mapName ))
#endif

#if DEV
		DEV_CombatRangePrint( format( " ***** %s", FUNC_NAME()) )
#endif






















	CombatRange_RegisterRemoteFunctions()
}


































































































































bool function PlaylistVar_CRng_Announcer()
{
	return( GetCurrentPlaylistVarBool( PLV_CRNG_ANNOUNCER, false ) )
}

bool function PlaylistVar_CRng_Spawning()
{
	return( GetCurrentPlaylistVarBool( PLV_CRNG_SPAWNING, true ) )
}

bool function PlaylistVar_CRng_RandomWeapons()
{
	return( GetCurrentPlaylistVarBool( PLV_CRNG_RANDOMWEAPONS, false ) )
}

bool function PlaylistVar_DynamicDummiesEverywhere()
{
	return( GetCurrentPlaylistVarBool( PLV_DYNAMICDUMMIES_EVERYWHERE, false ) )
}













































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































int function GetCombatRangeRealm( entity ent )
{
	if( IsValid( ent ) || IsInvalidButMemberVarsStillValid( ent ))
	{
		return( ent.GetRealms()[0]  )
	}

	return INVALID_REALM
}





























































































































































































































































































































void function SCB_DynDummie_Spawns_Changed()
{
	
}


































































































































































































































#if DEV
void function DEV_CombatRangePrint( string printMe, bool forcePrint = false )
{
	if( file.dev_PrintsOn || forcePrint )
	{
		printt( format( "COMBATRANGE: %s", printMe ) )
	}
}

void function DEV_DebugSpawnPrint( string printMe )
{
	if( file.dev_spawnPrintsOn )
	{
		printt( format( "SPAWNING DEBUG: %s", printMe ) )
	}
}

void function DEV_DebugSpawnPrintOn( bool isOn )
{
	file.dev_spawnPrintsOn = isOn
}

#endif



