

const string CONTROL_MODE_MOVER_SCRIPTNAME = "control_mover"

global function Control_Init
global function Control_RegisterNetworking

























































































global function Control_PopulateAboutText


global function Control_IsSpawningOnObjectiveBAllowed
global function Control_IsPointAnFOB
global function Control_IsSpawnWaypointIndexAnObjective
global function Control_IsSpawnWaypointFOBForAlliance
global function Control_IsSpawnWaypointHomebaseForAlliance

































































#if DEV
	const bool CONTROL_SPAWN_DEBUGGING = false
	const bool CONTROL_DISPLAY_DEBUG_DRAWS = false 
	const float CONTROL_DEBUG_DRAW_DISPLAY_TIME = 1000.0
#endif






global const CONTROL_DROPPOD_SCRIPTNAME = "control_droppod"
global const CONTROL_OBJECTIVE_SCRIPTNAME = "control_objective"


global const CONTROL_INT_OBJ_ALLIANCE_OWNER = 0
const FLOAT_CAP_PERC = 1
const FLOAT_BOUNTY_AMOUNT = 2
const FLOAT_AVG_BOUNDARY_RADIUS = 3
const INT_CAPTURING_ALLIANCE = 3
global const INT_CONTROL_WAYPOINT_TYPE_INDEX = 4
const INT_ALLIANCE_A_PLAYERSONOBJ = 5
const INT_ALLIANCE_B_PLAYERSONOBJ = 6
const CONTROL_INT_OBJ_NEUTRAL_ALLIANCE_OWNER = 7

const float CONTROL_INTRO_DELAY = 2.2

const INT_ALLIANCE_A_SCORE = 4
const INT_ALLIANCE_B_SCORE = 5

const asset CONTROL_OBJ_DIAMOND_EMPTY = $"rui/hud/gametype_icons/winter_express/team_diamond_empty"
const asset CONTROL_OBJ_DIAMOND_YOURS = $"rui/hud/gametype_icons/winter_express/team_a_diamond"
const asset CONTROL_OBJ_DIAMOND_ENEMY = $"rui/hud/gametype_icons/winter_express/team_b_diamond"
const asset TEAMMATE_DEATH_ICON = $"rui/rui_screens/icon_skull_postdeath"
const asset TEAMMATE_SPAWN_ICON = $"rui/hud/pve/extraction_dropship"
const asset AIRDROP_LANDED_ICON = $"rui/hud/ping/icon_ping_loot"
const float CONTROL_TEAMMATE_DEATH_ICON_LIFETIME = 12.0 
const float TEAMMATE_SPAWN_ICON_DURATION = 10.0

const SPAWN_DIST = 1000
const float SPAWN_MIN_RADIUS = 128
const float SPAWN_MIN_RADIUS_NEAR_SQUAD = 712
const float SPAWN_MAX_RADIUS_BASE = 1028
const float SPAWN_MAX_RADIUS_NEAR_SQUAD = 1400
const SPAWN_MAX_TRY_COUNT = 60
const SPAWN_VIEW_DISTANCE_CHECK = 150


const int CONTROL_WAYPOINT_ALLIANCE_OWNER_INDEX = 5
const int CONTROL_MRB_SPAWN_WAYPOINT_ENDTIME = 6
const float CONTROL_DEFAULT_MRB_LIFETIME = 120.0
const float CONTROL_DEFAULT_MRB_AIRDROP_DELAY = 15.0
global const string MRB_WEAPON_REF_NAME = "mp_ability_mobile_respawn_beacon" 
global const string MRB_SUPPLY_DROP_NAME = "mp_ability_mobile_supply_drop" 
const string PLAYER_WITH_MRB_NET_NAME = "control_MrbTimedEventPlayerWithMrb"
const string WAYPOINT_CONTROL_MRB = "waypoint_control_mrb"
const int CONTROL_WAYPOINT_TRIGGER_ENTITY_INDEX = 1


const string WAYPOINT_CONTROL_PLAYERLOC = "waypoint_control_playerloc"
global const int CONTROL_PLAYERLOC_WAYPOINT_PLAYERENTITY_INDEX = 0

global const asset CONTROL_WAYPOINT_FLARE_ASSET = $"P_control_flare"

global const asset CONTROL_WAYPOINT_BASE_ICON = $"rui/hud/gametype_icons/survival/sur_hovertank_minimap"
global const asset CONTROL_WAYPOINT_PLAYER_ICON = $"rui/hud/gamestate/player_count_icon"

const string WAYPOINT_CONTROL_AIRDROP = "waypoint_control_airdrop"
const int AIRDROP_WAYPOINT_LOOTTIER_INT = 0
const asset HOVER_VEHICLE_SPAWN_BASE = $"mdl/olympus/olympus_vehicle_base.rmdl"
const asset FX_VEHICLE_SPAWN_POINT = $"P_veh_vh1_spawnpoint"
const int	VEHICLE_LIMIT = 6
const vector ANNOUNCEMENT_RED = <235, 65, 65>
const asset DEATH_SCREEN_RUI = $"ui/control_squad_summary_header_data.rpak"

global const string CONTROL_SCORINGEVENT_CAPTURED = "Control_CapturedObjective"
global const string CONTROL_EXPEVENT_GUNRACK_PURCHASE = "Control_Exp_GunRackUse"
global const string CONTROL_EXPEVENT_EXPRESET = "Control_Exp_ExpReset"

const string CONTROL_PIN_VICTORYCONDITION_UNKNOWN = "unknown"
const string CONTROL_PIN_VICTORYCONDITION_SCORE = "score_limit_reached"
const string CONTROL_PIN_VICTORYCONDITION_LOCKOUT = "lockout"
const string CONTROL_PIN_VICTORYCONDITION_FORFEIT = "team_forfeit"

global const int CONTROL_MAX_EXP_TIER = 4
global const int CONTROL_MAX_LOOT_TIER = 3

global const int CONTROL_TEAMSCORE_LOCKOUTBROKEN = 50





















































































































#if DEV
const float SPAWNPOINT_RADIUS = 20
const float SPAWNPOINT_HEIGHT = 128
const float SPAWNPOINT_DISPLAY_TIME = 60
#endif

global const array<string> CONTROL_DISABLED_BATTLE_CHATTER_EVENTS = [
	"bc_anotherSquadAttackingUs",
	"bc_squadsLeft2 ",
	"bc_squadsLeft3 ",
	"bc_squadsLeftHalf",
	"bc_twoSquaddiesLeft",
	"bc_championEliminated",
	"bc_killLeaderNew",
	"bc_podLeaderLaunch",
	"bc_imJumpmaster",
	"bc_firstBlood",
	"bc_weTookFirstBlood",
]

global const array<int> CONTROL_DISABLED_COMMS_ACTIONS = [

	eCommsAction.INVENTORY_NO_AMMO_BULLET,
	eCommsAction.INVENTORY_NO_AMMO_ARROWS,
	eCommsAction.INVENTORY_NO_AMMO_HIGHCAL,
	eCommsAction.INVENTORY_NO_AMMO_SHOTGUN,
	eCommsAction.INVENTORY_NO_AMMO_SNIPER,
	eCommsAction.INVENTORY_NO_AMMO_SPECIAL,

]

global enum eControlPointObjectiveState
{
	CONTESTED,
	CONTROLLED,
}


global enum eControlWaypointTypeIndex
{
	
	OBJECTIVE_A,
	OBJECTIVE_B,
	OBJECTIVE_C,
	
	HOMEBASE_ALLIANCE_A,
	HOMEBASE_ALLIANCE_B,
	MRB_SPAWN,
	SQUAD_SPAWN,
	_count
}



global enum eControlSpawnWaypointUsage
{
	ENEMY_TEAM,
	NOT_USABLE,
	FRIENDLY_TEAM
}


enum eControlSpawnAlertCode
{
	SPAWN_FAILED,
	SPAWN_CANCELLED,
	SPAWN_LOST_SPAWNPOINT,
	SPAWN_LOST_MRB,
	_count
}

enum eControlIconIndex
{
	DEATH_ICON,
	SPAWN_ICON,

	_count
}


enum eControlTimedEventType
{
	LOCKOUT,
	AIRDROP,
	MRB,
	BOUNTY,
	_count
}













































































































struct ControlAnnouncementData
{
	bool isInitialized = false

	entity 		wp
	bool 		shouldTerminateIfWPDies = false
	bool		shouldForcePushAnnouncement = false
	bool		shouldUseTimer

	string 		mainText
	string		subText
	float		displayLength

	float 		displayStartTime
	float		startTime
	float		eventLength

	vector 		overrideColor
}

struct ControlTeamData
{
	int teamScoreFromPoints = 0
	int teamScoreFromBonus = 0
	int teamScorePerSec = 0
}

const ControlTeamData ControlTeamDataDefaults = {
	teamScoreFromPoints =  0
	teamScoreFromBonus = 0
	teamScorePerSec = 0
}

struct {
	entity[eControlWaypointTypeIndex._count] spawnWaypoints
	bool isLockout = false
	bool isRampUp = false

	vector cameraLocation
	vector cameraAngles


























































































































































} file





global enum eControlStat {
	RATING = 4,
	OBJECTIVES_CAPTURED = 5,
}














void function Control_Init()
{




	if ( !Control_IsModeEnabled() )
		return

	

























































































































































































































































}






















void function Control_RegisterNetworking()
{
	if ( !Control_IsModeEnabled() )
		return








	RegisterNetworkedVariable( "control_WaveStartTime", SNDC_GLOBAL, SNVT_TIME, 0.0 )
	RegisterNetworkedVariable( "control_WaveSpawnTime", SNDC_GLOBAL, SNVT_TIME, 0.0 )
	RegisterNetworkedVariable( "control_IsPlayerOnSpawnSelectScreen", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
	RegisterNetworkedVariable( "control_IsPlayerExemptFromWaveSpawn", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
	RegisterNetworkedVariable( "control_ObjectiveIndex", SNDC_PLAYER_EXCLUSIVE, SNVT_INT, -1)
	RegisterNetworkedVariable( "control_PersonalScore", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "control_CurrentExpTotal", SNDC_PLAYER_EXCLUSIVE, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "control_CurrentExpTier", SNDC_PLAYER_EXCLUSIVE, SNVT_INT, 0 )

	Remote_RegisterServerFunction( "ClientCallback_Control_ProcessRespawnChoice", "int", 0, eControlWaypointTypeIndex._count )
	Remote_RegisterServerFunction( "ClientCallback_Control_PlayerRespawningFromMenu" )

	Remote_RegisterClientFunction( "ServerCallback_Control_ShowSpawnSelection" )
	Remote_RegisterClientFunction( "ServerCallback_Control_ProcessImmediatelyOpenCharacterSelect" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateSpawnWaveTimerTime" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateSpawnWaveTimerVisibility", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DeregisterModeButtonPressedCallbacks" )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetDeathScreenCallbacks" )
	Remote_RegisterClientFunction( "ServerCallback_Control_NoVehiclesAvailable" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdatePlayerExpHUDWeaponEvo", "bool", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_ProcessObjectiveStateChange", "entity", "int", -1, 2, "int", ALLIANCE_NONE, 2, "int", ALLIANCE_NONE, 2, "int", ALLIANCE_NONE, 2, "int",ALLIANCE_NONE, 2, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayIconAtPosition", "vector", -1.0, 1.0, 32, "int", 0, eControlIconIndex._count, "int", INT_MIN, INT_MAX, "float", 0.0, FLT_MAX, 32 )
	Remote_RegisterClientFunction( "ServerCallback_Control_BountyActiveAlert", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_Control_BountyClaimedAlert", "entity", "int", INT_MIN, INT_MAX, "int",ALLIANCE_NONE, 2  )
	Remote_RegisterClientFunction( "ServerCallback_Control_AirdropNotification" )
	Remote_RegisterClientFunction( "ServerCallback_Control_UpdateExtraScoreBoardInfo", "int", 0, 2, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetIsPlayerUsingLosingExpTiers", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplaySpawnAlertMessage", "int", 0, eControlSpawnAlertCode._count )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayWaveSpawnBarStatusMessage", "bool", "int", 0, eControlWaypointTypeIndex._count )
	Remote_RegisterClientFunction( "ServerCallback_Control_TransferCameraData", "vector", -FLT_MAX, FLT_MAX, 32, "vector", -FLT_MAX, FLT_MAX, 32 )
	Remote_RegisterClientFunction( "ServerCallback_Control_SetControlGeoValidForAirdropsOnClient", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_Control_PlayAllWeaponEvoUpgradeFX", "entity", "int", 0, CONTROL_MAX_EXP_TIER + 1, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_Play3PEXPLevelUpFX", "entity", "int", 0, CONTROL_MAX_EXP_TIER + 1 )
	Remote_RegisterClientFunction( "ServerCallback_Control_PlayCaptureZoneEnterExitSFX", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_Control_NewEXPLeader", "entity", "int", INT_MIN, INT_MAX )
	Remote_RegisterClientFunction( "ServerCallback_Control_EXPLeaderKilled", "entity", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_PlayMatchEndMusic_Control", "int", 0, eWinReason._count )
	Remote_RegisterClientFunction( "ServerCallback_PlayPodiumMusic" )
	Remote_RegisterClientFunction( "ServerCallback_Control_DisplayLockoutUnavailableWarning" )

	RegisterNetworkedVariable( PLAYER_WITH_MRB_NET_NAME, SNDC_GLOBAL, SNVT_ENTITY )
	Remote_RegisterClientFunction( "ServerCallback_Control_MRBTimedEvent_OnMRBPickedUp" )

	Remote_RegisterUIFunction( "Control_RemoveAllButtonSpawnIcons" )
	Remote_RegisterUIFunction( "ControlSpawnMenu_SetLoadoutAndLegendSelectMenuIsEnabled", "bool" )

	if ( IsUsingLoadoutSelectionSystem() )
	{
		Remote_RegisterUIFunction( "ControlSpawnMenu_UpdatePlayerLoadout" )
		Remote_RegisterUIFunction( "UI_OpenControlSpawnMenu", "bool", "int", INT_MIN, INT_MAX )
	}





}









float function Control_GetDefaultExpPercentToAwardForPointSpawn()
{
	return GetCurrentPlaylistVarFloat( "exp_percent_award_spawn_on_point", -1 )
}

float function Control_GetDefaultExpPercentToAwardForBaseSpawn()
{
	return GetCurrentPlaylistVarFloat( "exp_percent_award_spawn_on_base", 1 )
}

bool function Control_ShouldUseRecoveredExpPercentIfGreaterThanDefaults()
{
	return GetCurrentPlaylistVarBool( "exp_recover_exp_percent_if_greater_than_default", true )
}

bool function Control_GetIsMRBTimedEventEnabled()
{
	return GetCurrentPlaylistVarBool( "control_enable_mrb_event", true )
}








bool function Control_IsSpawningOnObjectiveBAllowed()
{
	return GetCurrentPlaylistVarBool( "control_is_b_point_spawn_allowed", true )
}










































































































































































































































































array< featureTutorialTab > function Control_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	string playlistUiRules = GetPlaylist_UIRules()

	if ( playlistUiRules != GAMEMODE_CONTROL )
		return tabs

	featureTutorialTab tab1
	featureTutorialTab tab2
	featureTutorialTab tab3
	featureTutorialTab tab4

	array< featureTutorialData > tab1Rules
	array< featureTutorialData > tab2Rules
	array< featureTutorialData > tab3Rules
	array< featureTutorialData > tab4Rules

	int withSquadBonusEXPVal = GetCurrentPlaylistVarInt( "exp_value_playing_with_squad", 5 )

	
	tab1.tabName = "#GAMEMODE_RULES_OVERVIEW_TAB_NAME"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_CAPTURING_HEADER", "#CONTROL_RULES_CAPTURING_BODY", $"rui/hud/gametype_icons/control/about_capture" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_RATINGS_HEADER", "#CONTROL_RULES_RATINGS_BODY", $"rui/hud/gametype_icons/control/about_ratings" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_TIMEDEVENT_HEADER", "#CONTROL_RULES_TIMEDEVENT_BODY", $"rui/hud/gametype_icons/control/about_events" ) )

	
	tab2.tabName = "#CONTROL_RULES_RATINGS_TAB_NAME"
	string killRatingsBody = Localize( "#CONTROL_RULES_KILL_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_kill", 20 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_assist", 20 ) ), string( GetCurrentPlaylistVarInt( "exp_value_mrb_deployed", 50 ) ), string( withSquadBonusEXPVal ) )
	string specialKillRatingsBody = Localize( "#CONTROL_RULES_SPECIAL_KILL_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_kill_attacker", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_defender", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_high_tier", 15 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_reallyhigh_tier", 25 ) ), string( GetCurrentPlaylistVarInt( "exp_value_kill_expleader", 50 ) ) )
	string objectiveRatingsBody = Localize( "#CONTROL_RULES_OBJECTIVE_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_capturing", 5 ) ), string( GetCurrentPlaylistVarInt( "exp_value_contesting", 10 ) ), string( GetCurrentPlaylistVarInt( "exp_value_defending_active", 10 ) ), string( GetCurrentPlaylistVarInt( "exp_value_neutralize", 50 ) ), string( GetCurrentPlaylistVarInt( "exp_value_capture", 50 ) ), string( withSquadBonusEXPVal ) )
	string teamRatingsBody = Localize( "#CONTROL_RULES_TEAM_RATINGS_BODY", string( GetCurrentPlaylistVarInt( "exp_value_team_neutralize", 25 ) ), string( GetCurrentPlaylistVarInt( "exp_value_team_capture", 25 ) ), string( CONTROL_TEAMSCORE_LOCKOUTBROKEN ) )
	tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_KILL_RATINGS_HEADER", killRatingsBody, $"rui/hud/gametype_icons/control/about_kill_ratings" ) )
	tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_SPECIAL_KILL_RATINGS_HEADER", specialKillRatingsBody, $"rui/hud/gametype_icons/control/about_special_kill_ratings" ) )
	tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_OBJECTIVE_RATINGS_HEADER", objectiveRatingsBody, $"rui/hud/gametype_icons/control/about_objective_ratings" ) )
	tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_TEAM_RATINGS_HEADER", teamRatingsBody, $"rui/hud/gametype_icons/control/about_team_ratings" ) )

	
	tab3.tabName = "#CONTROL_RULES_SPAWNING_TAB_NAME"
	string baseSpawnBody = Localize( "#CONTROL_RULES_BASE_SPAWN_BODY", string( Control_GetDefaultExpPercentToAwardForBaseSpawn() * 100 ) )
	tab3Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_BASE_SPAWN_HEADER", baseSpawnBody, $"rui/hud/gametype_icons/control/about_base_spawns" ) )
	tab3Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_FORWARDBASE_SPAWN_HEADER", "#CONTROL_RULES_FORWARDBASE_SPAWN_BODY", $"rui/hud/gametype_icons/control/about_forwardbase_spawns" ) )
	tab3Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CONTROL_RULES_CENTRAL_SPAWN_HEADER", "#CONTROL_RULES_CENTRAL_SPAWN_BODY", $"rui/hud/gametype_icons/control/about_central_spawns" ) )

	tab1.rules = tab1Rules
	tab2.rules = tab2Rules
	tab3.rules = tab3Rules
	tab4.rules = tab4Rules

	tabs.append( tab1 )
	tabs.append( tab2 )
	tabs.append( tab3 )







		tabs.append( tab4 )


	return tabs
}


















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































bool function Control_IsPointAnFOB( int pointIndex )
{
	return pointIndex == eControlWaypointTypeIndex.OBJECTIVE_A || pointIndex == eControlWaypointTypeIndex.OBJECTIVE_C
}


bool function Control_IsSpawnWaypointFOBForAlliance( int waypointIndex, int alliance )
{
	return ( waypointIndex == eControlWaypointTypeIndex.OBJECTIVE_A && alliance == ALLIANCE_A ) || ( waypointIndex == eControlWaypointTypeIndex.OBJECTIVE_C && alliance == ALLIANCE_B )
}


bool function Control_IsSpawnWaypointHomebaseForAlliance( int waypointIndex, int alliance )
{
	return ( waypointIndex == eControlWaypointTypeIndex.HOMEBASE_ALLIANCE_A && alliance == ALLIANCE_A ) || ( waypointIndex == eControlWaypointTypeIndex.HOMEBASE_ALLIANCE_B && alliance == ALLIANCE_B )
}


bool function Control_IsSpawnWaypointIndexAnObjective( int waypointIndex )
{
	return waypointIndex == eControlWaypointTypeIndex.OBJECTIVE_A || waypointIndex == eControlWaypointTypeIndex.OBJECTIVE_B || waypointIndex == eControlWaypointTypeIndex.OBJECTIVE_C
}


































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































