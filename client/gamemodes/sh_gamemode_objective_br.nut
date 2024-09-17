





global function ObjectiveBR_Init





















global function ServerCallback_ObjectiveBR_DisplayMessageToClient
global function ServerCallback_ObjectiveBR_TriggerLocalEliminationEffectsOnPlayer
global function ObjectiveBR_SetRoundInfo
global function ObjectiveBR_SetRoundInfoWarning
global function ObjectiveBR_SetRoundInfoImages
global function ObjectiveBR_SetSuddenDeath
global function ObjectiveBR_ScoreHud_SetSuddenDeathString
global function ObjectiveBR_ScoreHud_SetupObjectiveScoreTrackers
global function ObjectiveBR_ScoreHud_SetObjectiveVisible
global function ObjectiveBR_ScoreHud_SetObjectiveScore
global function ObjectiveBR_ScoreHud_SetObjectiveIcon
global function ObjectiveBR_ScoreHud_SetObjectiveIsProgressBarVersion
global function ObjectiveBR_ScoreHud_SetObjectiveProgressSubstring
global function ObjectiveBR_ScoreHud_SetObjectiveProgressCurrentScore
global function ObjectiveBR_ScoreHud_SetObjectiveProgressMaxScore
global function ObjectiveBR_ScoreHud_SetEliminationThreshold
global function ObjectiveBR_ScoreHud_SetTotalTeamCount
global function ObjectiveBR_ScoreHud_UpdateTeamMemberIndex
global function ObjectiveBR_ScoreHud_SetLowTimeFlag
global function ObjectiveBR_ScoreHud_SetScoreSnapshots

global function ObjectiveBR_Markers_RegisterInWorldRui
global function ObjectiveBR_Markers_RegisterMinimapRui
global function ObjectiveBR_Markers_RegisterFullmapRui
global function ObjectiveBR_Markers_SetObjectiveType
global function ObjectiveBR_Markers_GetObjectiveRuiDataForWaypoint
global function ObjectiveBR_Markers_GetObjectivesByType

global function ObjectiveBR_Markers_RemoveWaypointRuis
global function ObjectiveBR_Markers_ClearRuis

global function ObjectiveBR_Markers_RemoveObjectiveTypeFromShowClosestFilter
global function ObjectiveBR_Markers_AddObjectiveTypeToShowClosestFilter

global function ObjectiveBR_InWorldMarkers_GetClosestOfType
global function ObjectiveBR_InWorldMarkers_ForceShowClosestN
global function ObjectiveBR_Minimap_SetMinimapRuiClampEdge
global function ObjectiveBR_Markers_SetIgnoreDistanceScaling














































































































const string OBJECTIVE_BR_SFX_SCORE_GAINED = "ObjBR_UI_InGame_ScoreGained_OneShot_1P"
const string OBJECTIVE_BR_SFX_SCORE_MESSAGE = "ObjBR_UI_InGame_PointsAwarded_1P"
const string OBJECTIVE_BR_SFX_TEAM_SAFE = "ObjBR_UI_InGame_ScoreThreshold_ToSafe_1P"
const string OBJECTIVE_BR_SFX_TEAM_NOT_SAFE = "ObjBR_UI_InGame_ScoreThreshold_ToDanger_1P"
const string OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_10_SECS = "ObjBR_UI_InGame_Timer_10seconds_1P"
const string OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_3_SECS = "ObjBR_UI_InGame_Timer_3Seconds_1P"
const string OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_DONE = "ObjBR_UI_InGame_Timer_Finished_1p"
const string OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT = "GlobalLTM_UI_SkydiveBanner_1P"
const string OBJECTIVE_BR_SFX_ANNOUNCEMENT = "Ctrl_Zone_Capture_1p"
const string OBJECTIVE_BR_SFX_ROUND_END_WARNING_UNSAFE = "ObjBR_UI_InGame_Banner_Warning"
const string OBJECTIVE_BR_SFX_ROUND_END_WARNING_SAFE = "ObjBR_UI_InGame_Banner_Safe"
const string OBJECTIVE_BR_SFX_REDPLOY_BANNER = "ObjBR_UI_InGame_Banner_SuddenDeath"
const string OBJECTIVE_BR_SFX_ELIM_DEATH_1P = "ObjBR_DeathFlow_WarpOut_1P"
const float OBJECTIVE_BR_DEATH_EFFECTS_MAX_DURATION = 2.0
const string OBJECTIVE_BR_SFX_ROUND_ENDING_PULSE = "ObjBR_UI_InGame_Timer_Pulse_1P"


const asset OBJECTIVE_BR_VFX_ELIM_DEATH_SCREEN_EFECT =  $"P_BR_execution_burst_FP"


const string OBJECTIVE_BR_MUSIC_ELIM_ROUND_1 = "Music_ObjectiveBR_Elim1" 
const string OBJECTIVE_BR_MUSIC_ELIM_ROUND_2 = "Music_ObjectiveBR_Elim2" 
const string OBJECTIVE_BR_MUSIC_ELIM_ROUND_3 = "Music_ObjectiveBR_Elim3" 
const string OBJECTIVE_BR_MUSIC_ELIM_END = "Music_ObjectiveBR_Elim_End" 
const float ELIM_MUSIC_CODE_VAL_NO_LAYER = 0.0 
const float ELIM_MUSIC_CODE_VAL_UNSAFE_LAYER = 50.0 
const float ELIM_MUSIC_CODE_VAL_SAFE_LAYER = 100.0 
const float ELIM_END_MUSIC_CODE_VAL_ELIMINATED = 50.0 
const float ELIM_END_MUSIC_CODE_VAL_SAFE = 100.0 
const float ROUND_ELIM_MUSIC_INTRO_DURATION = 30.0 
const float ROUND_ELIM_MUSIC_TOTAL_DURATION = 90.0 
const float ELIMINATIONS_REMINDER_TIME = ROUND_ELIM_MUSIC_TOTAL_DURATION - ROUND_ELIM_MUSIC_INTRO_DURATION 


const float OBJECTIVE_ICON_MAX_DRAW_DIST = 250.0 * METERS_TO_INCHES 
const float OBJECTIVE_ICON_MAX_DRAW_DIST_SKYDIVE = -1 


const asset MAPKEY_CAPTURE_ICON = $"rui/hud/gametype_icons/objectivebr/mapkey_capture_icon"
const asset MAPKEY_SEARCH_ICON = $"rui/hud/gametype_icons/objectivebr/mapkey_search_icon"
const asset MAPKEY_EVAC_ICON = $"rui/hud/gametype_icons/objectivebr/mapkey_evac_icon"
const asset MAPKEY_DELIVER_ICON = $"rui/hud/gametype_icons/objectivebr/mapkey_deliver_icon"


const float SCORE_UPDATE_DELAY = 0.5
const string OBJECTIVE_BR_SCORING_HUD_RUI = $"ui/objectivebr_scoring_hud.rpak"
const string OBJECTIVE_BR_RESPAWN_TOKEN_HUD_RUI = $"ui/survival_respawn_token.rpak"

const int OBJECTIVE_BR_SCORETRACKER_RESCUE_INDEX = 1
const int OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX = 2
const int OBJECTIVE_BR_SCORETRACKER_EVO_INDEX = 3
const asset OBJECTIVE_BR_SCORETRACKER_ICON_CAPTURE = $"rui/hud/gametype_icons/objectivebr/objectivebr_scoretracker_capture"
const asset OBJECTIVE_BR_SCORETRACKER_ICON_RESCUE = $"rui/hud/gametype_icons/objectivebr/objectivebr_scoretracker_rescue"
const asset OBJECTIVE_BR_SCORETRACKER_ICON_EVO = $"rui/rui_screens/lgnd_upgrades/level_up/lgnd_upgrades_evo_station_active_icon"

const asset OBJECTIVE_BR_ROUNDINFO_ICON_RESCUE_1 = $"rui/hud/gametype_icons/objectivebr/icon_objectivebr_spectre"
const asset OBJECTIVE_BR_ROUNDINFO_ICON_RESCUE_2 = $"rui/hud/gametype_icons/objectivebr/icon_objectivebr_evac"
const asset OBJECTIVE_BR_ROUNDINFO_ICON_CAPTURE = $"rui/hud/gametype_icons/objectivebr/objectivebr_scoretracker_capture"

const vector OBJECTIVEBR_SNAPSHOT_SAFE_COLOR = <0.18, 0.95, 0.87> * 255.0
const vector OBJECTIVEBR_SNAPSHOT_UNSAFE_COLOR = <1, 0.31, 0.12> * 255.0


const int OBJECTIVE_BR_FORCE_SHOW_CLOSEST_N_OBJECTIVES = 1
const float OBJECTIVE_BR_OBJECTIVE_DISTANCE_CHECK_INTERVAL = 1.0


const float SPLASH_TEXT_DURATION = 4.0




const int OBJECTIVE_BR_FIRST_ROUND = 1
const int OBJECTIVE_BR_FINAL_OBJECTIVE_RING_STAGE = 4
const int OBJECTIVE_BR_FINAL_ROUND = 5
const int OBJECTIVE_BR_REDEPLOY_RING_STAGE = 3
const float RING_TIMER_ADJUSTMENT = MARGIN_WAIT_TIME
const int MAX_SCORE_PER_SCORING_EVENT = 500
const float OBJECTIVE_INCOMING_START_OFFSET = 5.0 
const float OBJECTIVE_LIFETIME_OFFSET = 1.6 
const float ELIMINATIONS_WARNING_TIME = 90.0
const float OBJECTIVEBR_TEAMSORT_CACHE_INTERVAL = 0.5


const string OBJECTIVE_BR_MUSIC_REDEPLOY_DROP = "Music_ObjectiveBR_FinalRound_Jump" 


const float DEFAULT_REDEPLOY_PLANE_SPEED = 575.0
const float DEFAULT_REDEPLOY_PLANE_HEIGHT_MULTIPLIER = 0.5
const int REDEPLOY_PLANE_COUNT = 1
const float DEFAULT_REDEPLOY_PLANE_JUMP_DELAY = 8.0
const float REDEPLOY_FADE_TIME = 3.0


const float DEFAULT_OBJECTIVE_INCOMING_DURATION = 30.0
const float DEFAULT_OBJECTIVE_MINIMUM_ACTIVE_TIME_REMAINING_FOR_GOOD_CLASSIFICATION = 40.0
const float PER_TEAMMATE_CAPTURE_PROGRESS_MULTIPLIER = 0.1


const float CAPTURE_ZONE_DEFAULT_CAPTURE_DURATION = 86.0


const float DEFAULT_ANNOUNCEMENT_DURATION = 4.0
const float SCORE_MESSAGING_DELAY = 1.0


const array<string> OBJECTIVE_BR_DISABLED_BATTLE_CHATTER_EVENTS = [
	"bc_circleTimerStart",
	"bc_circleMoving",
	"bc_circleTimerStartFinal",
	"bc_circleClosingFinal",
	"bc_circleMovesNag1Min",
	"bc_circleMovesNag45Sec",
	"bc_circleMovesNag30Sec",
	"bc_circleMovesNag10Sec",
	"bc_insideNextCircle",
	"bc_championDoubleKill",
	"bc_championTripleKill",
	"bc_championEliminated",
	"bc_challengerEliminated",
	"bc_championDiedToCircle",
	"bc_challengerDiedToCircle",
	"bc_killLeaderDiedToCircle",
	"bc_wildCardDiedToCircle",
	"bc_playerDiedToCircle_early",
	"bc_playerDiedToCircle_late",
	"bc_squadmateDiedToCircle",
	"bc_circleMoving_alreadyInside"
]


const int OBJECTIVE_BR_FINAL_OBJECTIVE_ROUND = 3

const int DEFAULT_SCORE_EVO = 5
const int DEFAULT_EVO_THRESHOLD_FOR_SCORE = 800

const int DEFAULT_SCORE_CAPTURE_PROGRESS = 5
const int DEFAULT_SCORE_CAPTURE_COMPLETE = 20


global enum eObjectiveBRGameplayPhase
{
	MATCH_INTRO,
	ROUND_END_BUFFER,
	OBJECTIVES_INCOMING,
	PRIMARY_OBJECTIVE,
	PRE_SUDDEN_DEATH_ROUND,
	REDEPLOY,
	SUDDEN_DEATH,

	CAPTURE_OBJ_INCOMING,
	PRIMARY_OBJ_CAPTURE,









	_count
}

















global enum eObjectiveBRMessageIndex
{
	INVALID,
	SCORE_EVO,
	SKYDIVE_MATCH_START,
	SKYDIVE_LAND_MATCH_START,
	REDEPLOY_WARNING,
	SKYDIVE_REDEPLOY,












	SCORE_CAPTURE_HOLD,
	SCORE_CAPTURE_COMPLETE,
	CAPTURE_ROUND_START,
	SKYDIVE_INCOMING_CAP,
	SKYDIVE_CAPTURE,
	SKYDIVE_LAND_MATCH_START_CAPTURE,

	MIXED_ROUND_START,
	SKYDIVE_INCOMING_MIXED,
	SKYDIVE_MIXED_OBJ,
	NO_OBJECTIVES_REMAIN,
	SKYDIVE_NO_OBJECTIVES_REMAIN,
	ELIMINATIONS_SOON,
	SKYDIVE_ELIMINATIONS_SOON,
	ALL_SQUADS_PROGRESSING,
	ALL_SQUADS_PROGRESSING_REDEPLOY,
	YOUR_SQUAD_PROGRESSING,
	YOUR_SQUAD_PROGRESSING_REDEPLOY,
	YOUR_SQUAD_ELIMINATED,
	_count
}

enum eObjectiveBRCatchupLevel
{
	NONE,
	UNSAFE_RANKING,
	MISSING_1_PLAYER,
	MISING_2_PLAYERS,
	_count
}

































































global enum eObjectiveBRObjectiveType
{
	NONE = -1,
	CAPTURE,
	RESCUE_MEDBAY,
	RESCUE_EVAC
}



global struct ObjectiveRuiData
{
	entity 	waypoint
	var 	objectiveRui
	var		minimapRui
	var		fullmapRui
	int		objectiveType = -1
	float 	distance = FLT_MAX
}


struct
{































		
		entity musicEntity 

		bool nestedHudElementsCreated = false
		var nestedScoreHudRui
		var nestedScoreHudFullmapRui
		var nestedRespawnTokenRui
		var nestedRespawnTokenFullmapRui

		table< entity, ObjectiveRuiData > objectiveRuiMap
		array<int> pinClosestObjectiveTypeFilter

		int lastGameplayPhase = -1
		bool isLocalPlayerTeamSafe = true

		table < int, int > scoringMsgTypeToAmountAwardedDuringMsgInterval

		float lastTeamSortCacheTime = -1
		array< int > teamsSortedByEliminationAndScoreCache = []

		float lastNonEliminatedTeamsCacheTime = -1
		array< int > nonEliminatedTeamsCache = []



		table< int, int > teamToCatchupLevelTable

}file

void function ObjectiveBR_Init()
{





























































		AddCreateCallback( "player", ObjectiveBR_OnPlayerCreated_Client )
		ObjectiveBR_OverrideGameState()
		ObjectiveBR_SetupScoreboard()
		AddCallback_GameStateEnter( eGameState.Playing, ObjectiveBR_OnGameStatePlaying_Client )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, ObjectiveBR_OnGameStateWinnerDetermined_Client )
		AddCallback_OnPlayerLifeStateChanged( ObjectiveBR_OnPlayerLifeStateChanged_Client )
		Survival_SetCustomRingAnnouncementCallback( ObjectiveBR_RoundStartAnnouncement )
		Survival_SetCustomRingClosingAnnouncementCallback( ObjectiveBR_RoundEndAnnouncement )
		SetCustomScreenFadeAsset( $"ui/screen_fade_sudden_death.rpak" )

		SetChatHUDPosition( DEFAULT_TEXTCHAT_VERTICAL_OFFSET + 120 )

		float yScale = float( GetScreenSize().height ) / 1080.0
		float obituaryYOffset = 80 * yScale
		Obituary_SetVerticalOffset( int( obituaryYOffset ) )
		ScoreObit_SetRuiAssetForMessageType( eScoreEventMessageType.SPECIAL, $"ui/objectivebr_score_info.rpak" )
		ScoreObit_SetMessageScaleForMessageType( eScoreEventMessageType.SPECIAL, 1.1 )

		PrecacheParticleSystem( OBJECTIVE_BR_VFX_ELIM_DEATH_SCREEN_EFECT )
#if DEV
			AddCreateCallback( "prop_script", DEV_OnPropScriptCreated )
#endif




		
		

		
		
		ObjectiveManager_AddCallback_OnRegisterObjectiveType( ObjectiveBR_OnRegisterObjectiveType )

		

		Survival_SetCallback_GetDropshipCount( ObjectiveBR_GetDropshipCount )
		Survival_SetCallback_GetPlaneHeightMultiplier( ObjectiveBR_GetPlaneHeightMultiplier )
		Survival_SetCallback_IsDropshipClampedToRing( ObjectiveBR_IsDropshipClampedToRing )
		Survival_SetCallback_GetPlaneMoveSpeed( ObjectiveBR_GetPlaneMoveSpeed )
		Survival_SetCallback_GetMusicForJump( ObjectiveBR_GetMusicForJump )
		Survival_SetCallback_GetPlaneJumpDelay( ObjectiveBR_GetPlaneJumpDelay )

		ObjectiveBR_RegisterNetworking()
		PrecacheScriptString( "ObjectiveBR_SetUsableVehicleBase" )

		RegisterDisabledBattleChatterEvents( OBJECTIVE_BR_DISABLED_BATTLE_CHATTER_EVENTS )







			ScoreEvent_SetMessagingDelay( GetScoreEvent( "Evo_Cap_Progress" ), SCORE_MESSAGING_DELAY )
			ScoreEvent_SetMessagingDelay( GetScoreEvent( "Evo_Cap" ), SCORE_MESSAGING_DELAY )


}


void function ObjectiveBR_RegisterNetworking()
{
	Remote_RegisterClientFunction( "ServerCallback_ObjectiveBR_DisplayMessageToClient", "int", 0, eObjectiveBRMessageIndex._count, "int", 0, MAX_SCORE_PER_SCORING_EVENT )
	Remote_RegisterClientFunction( "ServerCallback_ObjectiveBR_TriggerLocalEliminationEffectsOnPlayer" )

	RegisterNetworkedVariable( "objective_br_round", SNDC_GLOBAL, SNVT_INT, 0 )
	RegisterNetworkedVariable( "objective_br_gameplay_phase", SNDC_GLOBAL, SNVT_INT, eObjectiveBRGameplayPhase.MATCH_INTRO )
	RegisterNetworkedVariable( "objective_br_playerteam_evo_earned", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "objective_br_round_evo_score", SNDC_PLAYER_GLOBAL, SNVT_INT, 0 )

		RegisterNetworkedVariable( "objective_br_round_capture_score", SNDC_PLAYER_GLOBAL, SNVT_INT, 0 )




	RegisterNetworkedVariable( "round_end_time", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "round_start_time", SNDC_GLOBAL, SNVT_TIME, -1 )


		RegisterNetVarIntChangeCallback ( "objective_br_gameplay_phase", ObjectiveBR_OnGameplayPhaseChanged_CL )
		RegisterNetVarIntChangeCallback ( "objective_br_playerteam_evo_earned", ObjectiveBR_OnPlayerTeamEvoAmountChanged_CL )
		RegisterNetVarIntChangeCallback ( "objective_br_round_evo_score", ObjectiveBR_OnPlayerEvoScoreChanged_CL )

		RegisterNetVarIntChangeCallback ( "objective_br_round_capture_score", ObjectiveBR_OnPlayerCaptureScoreChanged_CL )

		RegisterNetVarTimeChangeCallback( "round_end_time", ObjectiveBR_OnRoundEndTimeChanged_CL )




}
















































int function ObjectiveBR_GetSquadThresholdForRound( int objectiveBRRound, bool shouldReturnThresholdWithTiedScoreAdjustment )
{
	int defaultThreshold = GetCurrentPlaylistVarInt( "objective_br_squad_target_round_" + objectiveBRRound, 0 )

	if ( !shouldReturnThresholdWithTiedScoreAdjustment )
		return defaultThreshold

	int maxThresholdAdjustment = ObjectiveBR_GetMaxSquadThresholdAdjustmentForRound( objectiveBRRound )
	if ( maxThresholdAdjustment <= 0 )
		return defaultThreshold

	array <int> teamsSortedByScore = GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true )
	if ( teamsSortedByScore.len() <= defaultThreshold )
		return defaultThreshold

	int lowestSafeScore = GamemodeUtility_GetTeamOrAllianceScore( teamsSortedByScore[ defaultThreshold - 1 ] )
	if ( lowestSafeScore == 0 )
		return defaultThreshold

	int thresholdAdjustment = 0

	for ( int index = defaultThreshold; index < teamsSortedByScore.len() && thresholdAdjustment < maxThresholdAdjustment; index++ )
	{
		if ( GamemodeUtility_GetTeamOrAllianceScore( teamsSortedByScore[ index ] ) == lowestSafeScore )
		{
			thresholdAdjustment++
		}
	}

	return defaultThreshold + thresholdAdjustment
}





int function ObjectiveBR_GetMaxSquadThresholdAdjustmentForRound( int objectiveBRRound )
{
	return GetCurrentPlaylistVarInt( "objective_br_max_squad_target_adjustment_round_" + objectiveBRRound, 0 )
}





int function ObjectiveBR_GetScoreAmountForCaptureZoneHold()
{
	return GetCurrentPlaylistVarInt( "objective_br_score_capture_progress", DEFAULT_SCORE_CAPTURE_PROGRESS )
}




int function ObjectiveBR_GetScoreAmountForCaptureZoneComplete()
{
	return GetCurrentPlaylistVarInt( "objective_br_score_capture_complete", DEFAULT_SCORE_CAPTURE_COMPLETE )
}












float function ObjectiveBR_GetCaptureZoneCaptureDuration()
{
	return GetCurrentPlaylistVarFloat( "objective_br_capture_duration", CAPTURE_ZONE_DEFAULT_CAPTURE_DURATION )
}




int function ObjectiveBR_GetCaptureZoneFortifyLevels()
{
	return GetCurrentPlaylistVarInt( "objective_br_capture_fortify_levels", CAPTURE_OBJ_DEFAULT_FORTIFY_LEVELS )
}









































int function ObjectiveBR_GetEvoRequirementForScore()
{
	return GetCurrentPlaylistVarInt( "objective_br_evo_score_requirement", DEFAULT_EVO_THRESHOLD_FOR_SCORE )
}




int function ObjectiveBR_GetScoreAmountForEvoGained( int team )
{
	return GetCurrentPlaylistVarInt( "objective_br_evo_score_catchup_" + ObjectiveBR_GetCatchupLevelForTeam( team ), DEFAULT_SCORE_EVO )
}





































































































































































































float function ObjectiveBR_GetRedeployPlaneMoveSpeed()
{
	return GetCurrentPlaylistVarFloat( "objective_br_redeploy_plane_move_speed", DEFAULT_REDEPLOY_PLANE_SPEED )
}




float function ObjectiveBR_GetRedeployMultiPlaneHeightMultiplier()
{
	return GetCurrentPlaylistVarFloat( "objective_br_redeploy_multi_plane_height_multiplier", DEFAULT_REDEPLOY_PLANE_HEIGHT_MULTIPLIER )
}












float function ObjectiveBR_GetRedeployPlaneJumpDelay()
{
	return GetCurrentPlaylistVarFloat( "objective_br_redeploy_survival_plane_jump_delay", DEFAULT_REDEPLOY_PLANE_JUMP_DELAY )
}






























































































































void function ObjectiveBR_OnGameStatePlaying_Client()
{
	ObjectiveBR_CreateNestedHudElements()

	
	if ( GetGlobalNetInt( "objective_br_gameplay_phase" ) == eObjectiveBRGameplayPhase.SUDDEN_DEATH )
		ObjectiveBR_RespawnToken_SetInfiniteRespawnsRuiStatus( false )
	else
		ObjectiveBR_RespawnToken_SetInfiniteRespawnsRuiStatus( true )

	
	entity localClientPlayer = GetLocalClientPlayer()
	if ( IsValid( localClientPlayer ) )
		ObjectiveBR_UpdateTeamCatchupLevel( localClientPlayer.GetTeam() )

	
	ObjectiveBR_ScoreHud_SetupObjectiveScoreTrackers()
	ObjectiveBR_ScoreHud_SetTotalTeamCount( GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true ).len() )
}






























void function ObjectiveBR_OnPlayerCreated_Client( entity player )
{
	if ( IsValid( player ) && player == GetLocalClientPlayer() )
	{
		thread ObjectiveBR_ManageObjectiveUI_Thread()
		thread ObjectiveBR_InWorldMarkers_ShowClosest_Thread()
		print_dev( "OBJECTIVE BR: local player ",  player, " created in round ", ObjectiveBR_GetCurrentRound() )
	}
}




void function ObjectiveBR_OnGameStateWinnerDetermined_Client()
{
	print_dev( "OBJECTIVE BR: ", FUNC_NAME(), " in round ", ObjectiveBR_GetCurrentRound() )
}



































































































































bool function ObjectiveBR_IsGameplayPhaseObjectiveIncomingPhase( int gameplayPhase )
{
	switch ( gameplayPhase )
	{

		case eObjectiveBRGameplayPhase.CAPTURE_OBJ_INCOMING:







		case eObjectiveBRGameplayPhase.OBJECTIVES_INCOMING:
			return true
		default:
			return false
	}

	unreachable
}




bool function ObjectiveBR_IsGameplayPhaseObjectivePhase( int gameplayPhase )
{
	switch ( gameplayPhase )
	{

		case eObjectiveBRGameplayPhase.PRIMARY_OBJ_CAPTURE:







		case eObjectiveBRGameplayPhase.PRIMARY_OBJECTIVE:
			return true
		default:
			return false
	}

	unreachable
}












bool function ObjectiveBR_IsScoringGameplayPhase( int gameplayPhase )
{
	
	
	switch ( gameplayPhase )
	{
		case eObjectiveBRGameplayPhase.ROUND_END_BUFFER:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJECTIVE:









		case eObjectiveBRGameplayPhase.CAPTURE_OBJ_INCOMING:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJ_CAPTURE:

		case eObjectiveBRGameplayPhase.OBJECTIVES_INCOMING:
			return true
		case eObjectiveBRGameplayPhase.MATCH_INTRO:
		case eObjectiveBRGameplayPhase.PRE_SUDDEN_DEATH_ROUND:
		case eObjectiveBRGameplayPhase.REDEPLOY:
		case eObjectiveBRGameplayPhase.SUDDEN_DEATH:
			return false
		default:
			Assert( false, "OBJECTIVE BR: " + FUNC_NAME() + " was run with an Invalid or gameplay phase: " + gameplayPhase + " , we will return the default false in the live game." )
			break
	}
	return false
}



bool function ObjectiveBR_IsRedeployingForSuddenDeath()
{
	if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_OBJECTIVE_BR ) && GetGameState() == eGameState.Playing && ( GetGlobalNetInt( "objective_br_gameplay_phase" ) == eObjectiveBRGameplayPhase.REDEPLOY || GetGlobalNetInt( "objective_br_gameplay_phase" ) == eObjectiveBRGameplayPhase.SUDDEN_DEATH ) )
		return true

	return false
}



int function ObjectiveBR_GetDropshipCount()
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return REDEPLOY_PLANE_COUNT

	return GetCurrentPlaylistVarInt( "multi_survival_plane_count", 1 )
}




float function ObjectiveBR_GetPlaneHeightMultiplier()
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return ObjectiveBR_GetRedeployMultiPlaneHeightMultiplier()

	return GetCurrentPlaylistVarFloat( "multi_survival_plane_height_multiplier", DEFAULT_PLANE_HEIGHT_MULTIPLIER )
}




bool function ObjectiveBR_IsDropshipClampedToRing()
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return true

	return GetCurrentPlaylistVarBool( "dropship_bounds_clamp_to_ring", false )
}




float function ObjectiveBR_GetPlaneMoveSpeed()
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return ObjectiveBR_GetRedeployPlaneMoveSpeed()

	return GetCurrentPlaylistVarFloat( "survival_plane_move_speed", DEFAULT_PLANE_MOVE_SPEED )
}




string function ObjectiveBR_GetMusicForJump( entity player )
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return OBJECTIVE_BR_MUSIC_REDEPLOY_DROP

	return MusicPack_GetSkydiveMusic( GetMusicPackForPlayer( player ) )
}















float function ObjectiveBR_GetPlaneJumpDelay()
{
	if ( ObjectiveBR_IsRedeployingForSuddenDeath() )
		return ObjectiveBR_GetRedeployPlaneJumpDelay()

	return GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", DEFAULT_PLANE_JUMP_DELAY )
}




float function ObjectiveBR_GetRoundTimeRemaining()
{
	return max( GetGlobalNetTime( "round_end_time" ) - Time(), 0.0 )
}



















int function ObjectiveBR_GetTeamRanking( int team, array <int> teamsSortedByScore )
{
	return teamsSortedByScore.find( team ) + 1
}




bool function ObjectiveBR_GetIsTeamInSafeRanking( int team )
{
	int squadThreshold = ObjectiveBR_GetSquadThresholdForRound( ObjectiveBR_GetCurrentRound(), true )
	array <int> teamsSortedByScore = GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true )

	if ( teamsSortedByScore.len() <= squadThreshold )
		return true

	int teamRank = ObjectiveBR_GetTeamRanking( team, teamsSortedByScore )
	return teamRank <= squadThreshold
}



























































const int NUM_OBJECTIVES_OFFSET = 1 
void function ObjectiveBR_OnRegisterObjectiveType( int objectiveType )
{
	switch ( objectiveType )
	{

		case eObjectiveSystem_ObjectiveType.CAPTURE_ZONE:
		{










			break
		}














		default:
		{
			break
		}
	}






































}































































































void function ObjectiveBR_SetObjectiveVariables( int stage )
{
	float roundDuration = GetGlobalNetTime( "round_end_time" ) - GetGlobalNetTime( "round_start_time" )
	



		float lifetime = Cl_GetDeathFieldStage( stage + 1 ).preShrinkDuration


	
	float lifetimeOffset = RING_TIMER_ADJUSTMENT
	lifetimeOffset += stage > 0  ? OBJECTIVE_INCOMING_START_OFFSET : RING_START_WAIT_TIME
	lifetime += lifetimeOffset
	float incomingDuration = max( roundDuration - lifetime, 0.0 )
	lifetime -= OBJECTIVE_LIFETIME_OFFSET 


		if ( ObjectiveCaptureZone_IsObjectiveEnabled() )
		{
			float captureDuration = ObjectiveBR_GetCaptureZoneCaptureDuration()
			Assert( lifetime > captureDuration, "OBJECTIVE BR: " + FUNC_NAME() + " trying to set the lifetime for the objective to: " + lifetime + " which is less than the capture duration: " + captureDuration )
			ObjectiveCaptureZone_SetCaptureZoneSpawnDelayTime( incomingDuration )
			ObjectiveCaptureZone_SetCaptureZoneCaptureTime( captureDuration )
			ObjectiveCaptureZone_SetCaptureZoneFortifyLevels( ObjectiveBR_GetCaptureZoneFortifyLevels() )
			ObjectiveCaptureZone_SetCaptureZoneLifetime( lifetime )
		}











}












































































































































































































































































































































































































































































































































































































































































void function ObjectiveBR_ObjectivePhaseStart_Client()
{
	int currentRound = ObjectiveBR_GetCurrentRound()
	
	if ( currentRound <= OBJECTIVE_BR_FINAL_OBJECTIVE_ROUND )
	{
		
		thread ManageMusicRampLevelForRound_Thread()

		ObjectiveBR_ScoreHud_SetTotalTeamCount( GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true ).len() )
	}
}





























































































void function ObjectiveBR_IncomingPhaseStart_Client( )
{
	int currentRound = ObjectiveBR_GetCurrentRound()

	int stage = maxint( SURVIVAL_GetCurrentDeathFieldStage(), 0 )
	
	if ( currentRound < OBJECTIVE_BR_FINAL_OBJECTIVE_ROUND )
	{
		ObjectiveBR_SetObjectiveVariables( stage )
		ObjectiveBR_ScoreHud_SetTotalTeamCount( GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true ).len() )
	}
}










int function ObjectiveBR_GetCurrentRound()
{
	return GetGlobalNetInt( "objective_br_round" )
}

































































































































































































































































































































































































































































































































































































































void function ObjectiveBR_OnPlayerLifeStateChanged_Client( entity player, int oldState, int newState )
{
	if ( !IsValid( player ) )
		return

	entity localClientPlayer = GetLocalClientPlayer()
	if ( !IsValid( localClientPlayer ) )
		return

	int playerTeam = player.GetTeam()
	
	if ( newState == LIFE_DEAD && playerTeam == localClientPlayer.GetTeam() )
	{
		int oldCatchupLevel = ObjectiveBR_GetCatchupLevelForTeam( playerTeam )
		ObjectiveBR_UpdateTeamCatchupLevel( playerTeam )

		
		if ( oldCatchupLevel != ObjectiveBR_GetCatchupLevelForTeam( playerTeam ) )
		{
			ObjectiveBR_ScoreHud_SetObjectiveProgressSubstring( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, Localize( "#GAMEMODE_OBJECTIVE_BR_HUD_EVO_CONVERSION_RATE", ObjectiveBR_GetEvoRequirementForScore(), ObjectiveBR_GetScoreAmountForEvoGained( playerTeam ) ) )
		}
	}
}































































































int function ObjectiveBR_GetEarnedEVOForTeamOrAlliance( int teamOrAlliance )
{
	array < entity > teamOrAlliancePlayers = GamemodeUtility_GetPlayerArrayOfTeamOrAlliance( teamOrAlliance, false )
	foreach( teamOrAlliancePlayer in teamOrAlliancePlayers )
	{
		if ( IsValid( teamOrAlliancePlayer ) )
			return teamOrAlliancePlayer.GetPlayerNetInt( "objective_br_playerteam_evo_earned" )
	}

	return 0
}




int function ObjectiveBR_GetEarnedEvoScoreForTeamOrAlliance( int teamOrAlliance )
{
	array < entity > teamOrAlliancePlayers = GamemodeUtility_GetPlayerArrayOfTeamOrAlliance( teamOrAlliance, false )
	foreach( teamOrAlliancePlayer in teamOrAlliancePlayers )
	{
		if ( IsValid( teamOrAlliancePlayer ) )
			return teamOrAlliancePlayer.GetPlayerNetInt( "objective_br_round_evo_score" )
	}

	return 0
}





int function ObjectiveBR_GetEarnedCaptureScoreForTeamOrAlliance( int teamOrAlliance )
{
	array < entity > teamOrAlliancePlayers = GamemodeUtility_GetPlayerArrayOfTeamOrAlliance( teamOrAlliance, false )
	foreach( teamOrAlliancePlayer in teamOrAlliancePlayers )
	{
		if ( IsValid( teamOrAlliancePlayer ) )
			return teamOrAlliancePlayer.GetPlayerNetInt( "objective_br_round_capture_score" )
	}

	return 0
}












































































































































const int HIGHEST_MISSING_PLAYER_COUNT_FOR_CATCHUP = 2
void function ObjectiveBR_UpdateTeamCatchupLevel( int team )
{
	
	if ( GetGameState() != eGameState.Playing )
		return

	int teamCatchupLevel = eObjectiveBRCatchupLevel.NONE
	
	file.teamToCatchupLevelTable[ team ] <- teamCatchupLevel

	
	int currentRound = ObjectiveBR_GetCurrentRound()
	if ( currentRound > OBJECTIVE_BR_FINAL_OBJECTIVE_ROUND )
		return

	
	int teamPlayerCount = GetPlayerArrayOfTeam( team ).len()
	int expectedTeamPlayerCount = GetCurrentPlaylistVarInt( "max_players", 60 ) / GetCurrentPlaylistVarInt( "max_teams", 20 )
	int missingPlayerCount = maxint( expectedTeamPlayerCount - teamPlayerCount, 0 )

	if ( missingPlayerCount > 0 )
		teamCatchupLevel = missingPlayerCount >= HIGHEST_MISSING_PLAYER_COUNT_FOR_CATCHUP ? eObjectiveBRCatchupLevel.MISING_2_PLAYERS : eObjectiveBRCatchupLevel.MISSING_1_PLAYER

	
	if ( teamCatchupLevel == eObjectiveBRCatchupLevel.NONE )
	{
		array <int> teamsSortedByScore = GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true )
		int minSafeRankingTeamIndex = minint( ( ObjectiveBR_GetSquadThresholdForRound( currentRound, true ) - 1 ), ( teamsSortedByScore.len() - 1 ) )
		int minSafeRankingScore = GamemodeUtility_GetTeamOrAllianceScore( teamsSortedByScore[ minSafeRankingTeamIndex ] )
		
		if ( GamemodeUtility_GetTeamOrAllianceScore( team ) < minSafeRankingScore )
		{
			teamCatchupLevel = eObjectiveBRCatchupLevel.UNSAFE_RANKING
		}
	}

	
	file.teamToCatchupLevelTable[ team ] = teamCatchupLevel
}




int function ObjectiveBR_GetCatchupLevelForTeam( int team )
{
	if ( team in file.teamToCatchupLevelTable )
		return file.teamToCatchupLevelTable[ team ]

	return eObjectiveBRCatchupLevel.NONE
}










void function ObjectiveBR_OverrideGameState()
{
	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_objectivebr.rpak" )
	ClGameState_RegisterGameStateFullmapAsset( $"ui/gamestate_info_fullmap_objectivebr.rpak" )
}


























































































































var function ObjectiveBR_GetOrCreateScoreHud()
{
	if ( file.nestedScoreHudRui != null && RuiIsAlive( file.nestedScoreHudRui ) )
		return file.nestedScoreHudRui
	else
	{
		var rui = ClGameState_GetRui()
		if ( rui != null )
		{
			RuiDestroyNestedIfAlive( rui, "objectivebrScoreHudHandle" )
			var nestedScoreHudRui = RuiCreateNested( rui, "objectivebrScoreHudHandle", OBJECTIVE_BR_SCORING_HUD_RUI )
			file.nestedScoreHudRui = nestedScoreHudRui
			return nestedScoreHudRui
		}
		return null
	}

}



var function ObjectiveBR_GetOrCreateScoreFullmapHud()
{
	if ( file.nestedScoreHudFullmapRui != null && RuiIsAlive( file.nestedScoreHudFullmapRui ) )
		return file.nestedScoreHudFullmapRui
	else
	{
		var rui = GetFullmapGamestateRui()
		if ( rui != null )
		{
			RuiDestroyNestedIfAlive( rui, "objectivebrScoreHudHandle" )
			var nestedScoreHudRui = RuiCreateNested( rui, "objectivebrScoreHudHandle", OBJECTIVE_BR_SCORING_HUD_RUI )
			file.nestedScoreHudFullmapRui = nestedScoreHudRui
			return nestedScoreHudRui
		}
		return null
	}

}





























































































var function ObjectiveBR_GetOrCreateRespawnTokenHud()
{
	if ( file.nestedRespawnTokenRui != null && RuiIsAlive( file.nestedRespawnTokenRui ) )
		return file.nestedRespawnTokenRui
	else
	{
		var rui = ClGameState_GetRui()
		if ( rui != null )
		{
			RuiDestroyNestedIfAlive( rui, "respawnTokenHudHandle" )
			var nestedRespawnTokenRui = RuiCreateNested( rui, "respawnTokenHudHandle", OBJECTIVE_BR_RESPAWN_TOKEN_HUD_RUI )
			file.nestedRespawnTokenRui = nestedRespawnTokenRui
			return nestedRespawnTokenRui
		}
		return null
	}

}



var function ObjectiveBR_GetOrCreateRespawnTokenFullmapHud()
{
	if ( file.nestedRespawnTokenFullmapRui != null && RuiIsAlive( file.nestedRespawnTokenFullmapRui ) )
		return file.nestedRespawnTokenFullmapRui
	else
	{
		var rui = GetFullmapGamestateRui()
		if ( rui != null )
		{
			RuiDestroyNestedIfAlive( rui, "respawnTokenHudHandle" )
			var nestedRespawnTokenRui = RuiCreateNested( rui, "respawnTokenHudHandle", OBJECTIVE_BR_RESPAWN_TOKEN_HUD_RUI )
			file.nestedRespawnTokenFullmapRui = nestedRespawnTokenRui
			return nestedRespawnTokenRui
		}
		return null
	}
}



void function ObjectiveBR_CreateNestedHudElements()
{
	file.nestedHudElementsCreated = false

	
	ObjectiveBR_GetOrCreateScoreHud()
	ObjectiveBR_GetOrCreateScoreFullmapHud()

	
	ObjectiveBR_GetOrCreateRespawnTokenHud()
	ObjectiveBR_GetOrCreateRespawnTokenFullmapHud()

	file.nestedHudElementsCreated = true
}



void function ObjectiveBR_SetupScoreboard()
{
	Teams_AddCallback_ScoreboardData( ObjectiveBR_GetScoreboardData )
	Teams_AddCallback_Header( ObjectiveBR_ScoreboardUpdateHeader )
	Teams_AddCallback_GetTeamColor( ObjectiveBR_GetTeamColor )
	Teams_AddCallback_PlayerScores( ObjectiveBR_GetPlayerScores )
	Teams_AddCallback_GetTeamSortOrder( ObjectiveBR_ScoreboardGetTeamSortOrder )

	RunUIScript( "UI_SetScoreboardVerticalOffset", 60 )

	Teams_AddCallback_DoModeSpecificWork( ObjectiveBR_ModeSpecificScoreboardWork )
}



ScoreboardData function ObjectiveBR_GetScoreboardData()
{
	ScoreboardData data
	data.numScoreColumns = 0

	return data
}



array< string > function ObjectiveBR_GetPlayerScores( entity player )
{
	array< string > scores
	int totalScore = 0
	totalScore += player.GetPlayerNetInt( "objective_br_round_evo_score" )

		totalScore += player.GetPlayerNetInt( "objective_br_round_capture_score" )




	scores.append( string( totalScore ) )
	return scores
}



vector function ObjectiveBR_GetTeamColor( int team )
{
	if ( !ObjectiveBR_GetTeamsSortedByEliminationAndScore().contains( team ) )
		return <0.1, 0.1, 0.1>
	else
		return Survival_GetTeamColor( team )

	unreachable
}



array< int > function ObjectiveBR_ScoreboardGetTeamSortOrder()
{
	array <int> teamsSortedByScore = ObjectiveBR_GetTeamsSortedByEliminationAndScore()
	return teamsSortedByScore
}



void function ObjectiveBR_ScoreboardUpdateHeader( var headerRui, var frameRui, int team )
{
	if ( headerRui != null )
	{
		if ( team < TEAM_IMC )
		{
			RuiSetString( headerRui, "headerText", "" )
			RuiSetBool( headerRui, "isInDanger", false )
			RuiSetBool( headerRui, "isEliminated", true )
			return
		}

		int squadIndex = Squads_GetSquadUIIndex( team )
		int adjustedTeamIndex = AllianceProximity_IsUsingAlliances() ? AllianceProximity_GetAllianceFromTeam( team ) : team
		int teamPlacement = 0
		bool isTeamSafe = true
		bool isTeamEliminated = false

		int currentRoundForSquadThreshold = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
		int eliminationThreshold = ObjectiveBR_GetSquadThresholdForRound( currentRoundForSquadThreshold, true )
		array < int > teamsOrAlliancesSortedByScore = ObjectiveBR_GetTeamsSortedByEliminationAndScore()
		int totalTeamCount = teamsOrAlliancesSortedByScore.len()
		int nonEliminatedTeamCount = ObjectiveBR_GetNonEliminatedTeams().len()

		for ( int index = 0; index < totalTeamCount; index++ )
		{
			int rankNumber = index + 1
			int teamId = teamsOrAlliancesSortedByScore[ index ]

			if ( teamId == team )
			{
				isTeamSafe = rankNumber <= eliminationThreshold
				isTeamEliminated = rankNumber > nonEliminatedTeamCount
				teamPlacement = rankNumber
				break
			}
		}

		string teamName = Localize( Teams_GetTeamName( squadIndex ) )
		int teamScore = GamemodeUtility_GetTeamOrAllianceScore( adjustedTeamIndex )
		string headerText = Localize( "#GAMEMODE_OBJECTIVE_BR_SCOREBOARD_TEAM_HEADER", teamPlacement, teamName, teamScore )

		RuiSetString( headerRui, "headerText", headerText )
		RuiSetBool( headerRui, "isInDanger", !isTeamSafe )
		RuiSetBool( headerRui, "isEliminated", isTeamEliminated )
	}
}



void function ObjectiveBR_ModeSpecificScoreboardWork( var scoreboardPanel )
{
	RunUIScript( "UI_SetScoreboardVerticalOffset", 60 )

	var scoreboardHudElement = Hud_GetChild( scoreboardPanel, "ScoreboardTitle" )
	float scaleFrac = GetScreenScaleFrac()
	Hud_SetY( scoreboardHudElement, -125 * scaleFrac )
	var scoreboardTitleRui = Hud_GetRui( scoreboardHudElement )
	if ( RuiIsAlive( scoreboardTitleRui ) )
	{
		float timeRemaining = ObjectiveBR_GetRoundTimeRemaining()
		string titleString = "#GAMEMODE_OBJECTIVE_BR_SCOREBOARD_ELIMS_IN"
		string timeRemainingString = ""
		if ( timeRemaining > 0 )
		{
			
			timeRemainingString = TimeToString( timeRemaining, false, false )
		}
		else
		{
			titleString = ""
			timeRemainingString = ""
		}

		if ( timeRemainingString != "" )
			RuiSetString( scoreboardTitleRui, "titleText", Localize( titleString, timeRemainingString ).toupper() )
		else
			RuiSetString( scoreboardTitleRui, "titleText", Localize( titleString ).toupper() )
	}
}



void function ObjectiveBR_RespawnToken_SetInfiniteRespawnsRuiStatus( bool infiniteRespawns )
{
	var respawnTokenRui = ObjectiveBR_GetOrCreateRespawnTokenHud()
	RuiSetBool( respawnTokenRui, "infiniteRespawns", infiniteRespawns )

	var respawnTokenFullmapRui = ObjectiveBR_GetOrCreateRespawnTokenFullmapHud()
	RuiSetBool( respawnTokenFullmapRui, "infiniteRespawns", infiniteRespawns )
}



void function ObjectiveBR_SetupMapLegend( int gameplayPhase )
{
	switch ( gameplayPhase )
	{

		case eObjectiveBRGameplayPhase.CAPTURE_OBJ_INCOMING:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJ_CAPTURE:
			SetMapFeatureItem( 1500, "#GAMEMODE_OBJECTIVE_BR_MAPKEY_CAPTURE", "#GAMEMODE_OBJECTIVE_BR_MAPKEY_CAPTURE_DESC", MAPKEY_CAPTURE_ICON )







			break



























		case eObjectiveBRGameplayPhase.OBJECTIVES_INCOMING:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJECTIVE:

				SetMapFeatureItem( 1500, "#GAMEMODE_OBJECTIVE_BR_MAPKEY_CAPTURE", "#GAMEMODE_OBJECTIVE_BR_MAPKEY_CAPTURE_DESC", MAPKEY_CAPTURE_ICON )








			break
		case eObjectiveBRGameplayPhase.MATCH_INTRO:
		case eObjectiveBRGameplayPhase.ROUND_END_BUFFER:
		default:

				RemoveMapFeatureItemByName( "#GAMEMODE_OBJECTIVE_BR_MAPKEY_CAPTURE" )








			break
	}
}




void function ObjectiveBR_OnPlayerEvoScoreChanged_CL( entity player, int newScore )
{
	if ( !IsValid( player ) )
		return

	entity localPlayer = GetLocalClientPlayer()

	
	if ( !IsValid( localPlayer ) || player != localPlayer )
		return

	ObjectiveBR_ScoreHud_SetObjectiveScore( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, newScore )
}





void function ObjectiveBR_OnPlayerCaptureScoreChanged_CL( entity player, int newScore )
{
	if ( !IsValid( player ) )
		return

	entity localPlayer = GetLocalClientPlayer()

	
	if ( !IsValid( localPlayer ) || player != localPlayer )
		return

	ObjectiveBR_ScoreHud_SetObjectiveScore( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, newScore )
}

























void function ObjectiveBR_OnPlayerTeamEvoAmountChanged_CL( entity player, int newEvoVal )
{
	if ( !IsValid( player ) )
		return

	entity localPlayer = GetLocalClientPlayer()

	
	if ( !IsValid( localPlayer ) || player != localPlayer )
		return

	ObjectiveBR_ScoreHud_SetObjectiveProgressCurrentScore( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, newEvoVal )
}





void function ObjectiveBR_OnGameplayPhaseChanged_CL( entity player, int newPhase )
{
	print_dev( "OBJECTIVE BR: Gameplay phase changed to ", GetEnumString( "eObjectiveBRGameplayPhase", newPhase ), " in round ", ObjectiveBR_GetCurrentRound() )
	switch ( newPhase )
	{

		case eObjectiveBRGameplayPhase.CAPTURE_OBJ_INCOMING:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJ_CAPTURE:
			ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, true )
			ObjectiveBR_Markers_AddObjectiveTypeToShowClosestFilter( eObjectiveBRObjectiveType.CAPTURE )




			break












		case eObjectiveBRGameplayPhase.OBJECTIVES_INCOMING:
		case eObjectiveBRGameplayPhase.PRIMARY_OBJECTIVE:

			ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, true )
			ObjectiveBR_Markers_AddObjectiveTypeToShowClosestFilter( eObjectiveBRObjectiveType.CAPTURE )





			break
		case eObjectiveBRGameplayPhase.PRE_SUDDEN_DEATH_ROUND:
			
			ObjectiveBR_DisplayMessageToClient( eObjectiveBRMessageIndex.REDEPLOY_WARNING, 0 )
		case eObjectiveBRGameplayPhase.REDEPLOY:
			
			if ( newPhase == eObjectiveBRGameplayPhase.REDEPLOY )
			{
				thread ObjectiveBR_PlaySuddenDeathTransitionAudioDelayed_Thread()
			}
		case eObjectiveBRGameplayPhase.SUDDEN_DEATH:

			ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, false )
			ObjectiveBR_Markers_RemoveObjectiveTypeFromShowClosestFilter( eObjectiveBRObjectiveType.CAPTURE )





			ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, false )
			ObjectiveBR_SetSuddenDeath( true )
			ObjectiveBR_ScoreHud_SetSuddenDeathString( newPhase == eObjectiveBRGameplayPhase.PRE_SUDDEN_DEATH_ROUND ? "#GAMEMODE_OBJECTIVE_BR_PRE_SUDDENDEATH_PHASE_TITLE" : "#GAMEMODE_OBJECTIVE_BR_SUDDENDEATH_PHASE_TITLE" )
			ObjectiveBR_RespawnToken_SetInfiniteRespawnsRuiStatus( false )
			break
		case eObjectiveBRGameplayPhase.MATCH_INTRO:
		case eObjectiveBRGameplayPhase.ROUND_END_BUFFER:
		default:

			ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, false )
			ObjectiveBR_Markers_RemoveObjectiveTypeFromShowClosestFilter( eObjectiveBRObjectiveType.CAPTURE )





			break
	}

	if ( ObjectiveBR_IsGameplayPhaseObjectiveIncomingPhase( newPhase ) )
		ObjectiveBR_IncomingPhaseStart_Client( )
	else if ( ObjectiveBR_IsGameplayPhaseObjectivePhase( newPhase ) )
		ObjectiveBR_ObjectivePhaseStart_Client()

	ObjectiveBR_SetupMapLegend( newPhase )
}



void function ObjectiveBR_ManageObjectiveUI_Thread()
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	if ( GetGameState() > eGameState.Playing )
		return

	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EndSignal( localPlayer, "OnDestroy" )

	
	ClWaittillGameStateOrHigher( eGameState.Playing )

	int localPlayerTeam = localPlayer.GetTeam()
	int gameplayPhase
	
	int currentRoundForSquadThreshold = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
	int eliminationThreshold = ObjectiveBR_GetSquadThresholdForRound( currentRoundForSquadThreshold, true )
	ObjectiveBR_ScoreHud_SetEliminationThreshold( eliminationThreshold )

	array < int > teamsOrAlliancesSortedByScore = ObjectiveBR_GetTeamsSortedByEliminationAndScore()

	
	for ( int index = 0; index < teamsOrAlliancesSortedByScore.len(); index++ )
	{
		int team = teamsOrAlliancesSortedByScore[ index ]

		if ( team == localPlayerTeam )
		{
			int rankNumber = index + 1
			file.isLocalPlayerTeamSafe = rankNumber <= eliminationThreshold
			break
		}
	}

	while ( GetGameState() == eGameState.Playing )
	{
		gameplayPhase = GetGlobalNetInt( "objective_br_gameplay_phase" )
		teamsOrAlliancesSortedByScore = ObjectiveBR_GetTeamsSortedByEliminationAndScore()
		string roundInfoString = ""
		asset roundInfoIcon1 = $""
		asset roundInfoIcon2 = $""
		int currentRound = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
		string roundNumberString = Localize( "#GAMEMODE_OBJECTIVE_BR_ROUND_NUM_TITLE", currentRound )

		switch ( gameplayPhase )
		{








			case eObjectiveBRGameplayPhase.PRE_SUDDEN_DEATH_ROUND:
				roundNumberString = ""
				roundInfoString = "#GAMEMODE_OBJECTIVE_BR_PRE_SUDDENDEATH_PHASE_TITLE"
				break
			case eObjectiveBRGameplayPhase.SUDDEN_DEATH:
				roundNumberString = ""
				roundInfoString = "#GAMEMODE_OBJECTIVE_BR_SUDDENDEATH_PHASE_TITLE"
				break

			case eObjectiveBRGameplayPhase.CAPTURE_OBJ_INCOMING:
			case eObjectiveBRGameplayPhase.PRIMARY_OBJ_CAPTURE:
				roundInfoString = "#GAMEMODE_OBJECTIVE_BR_INC_CAP_PHASE_TITLE"
				roundInfoIcon1 = OBJECTIVE_BR_ROUNDINFO_ICON_CAPTURE
				break









			case eObjectiveBRGameplayPhase.MATCH_INTRO:
			case eObjectiveBRGameplayPhase.ROUND_END_BUFFER:
			default:
				break
		}

		if ( gameplayPhase != file.lastGameplayPhase )
		{
			ObjectiveBR_SetRoundInfo( roundNumberString, Localize( roundInfoString ) )
			ObjectiveBR_SetRoundInfoWarning( "", false )
			ObjectiveBR_SetRoundInfoImages( roundInfoIcon1, roundInfoIcon2 )
			file.lastGameplayPhase = gameplayPhase
		}

		currentRoundForSquadThreshold = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
		int currentEliminationThreshold = ObjectiveBR_GetSquadThresholdForRound( currentRoundForSquadThreshold, true )

		
		if ( currentEliminationThreshold != eliminationThreshold )
		{
			ObjectiveBR_ScoreHud_SetEliminationThreshold( currentEliminationThreshold )
			eliminationThreshold = currentEliminationThreshold
		}

		int nonEliminatedTeamCount = ObjectiveBR_GetNonEliminatedTeams().len()
		for ( int index = 0; index < teamsOrAlliancesSortedByScore.len(); index++ )
		{
			int rankNumber = index + 1
			int team = teamsOrAlliancesSortedByScore[ index ]

			if ( team == localPlayerTeam )
			{
				bool isTeamSafe = rankNumber <= eliminationThreshold

				int slot1Team = TEAM_UNASSIGNED
				int slot1Place = -1
				int slot1Score = -1
				bool slot1IsLocal = false
				string slot1TeamName = ""

				int slot2Team = TEAM_UNASSIGNED
				int slot2Place = -1
				int slot2Score = -1
				bool slot2IsLocal = false
				string slot2TeamName = ""

				int slot3Team = TEAM_UNASSIGNED
				int slot3Place = -1
				int slot3Score = -1
				bool slot3IsLocal = false
				string slot3TeamName = ""

				
				if ( rankNumber == 1 )
				{
					if ( nonEliminatedTeamCount >= 3 )
					{
						if ( nonEliminatedTeamCount > eliminationThreshold )
						{
							slot1Place = rankNumber
							slot2Place = rankNumber + 1
							slot3Place = eliminationThreshold + 1
							slot1IsLocal = true
						}
						else
						{
							slot1Place = rankNumber
							slot2Place = rankNumber + 1
							slot3Place = rankNumber + 2
							slot1IsLocal = true
						}
					}
					else
					{
						
						
						slot1Place = -1 
						slot2Place = rankNumber
						slot3Place = rankNumber + 1
						slot2IsLocal = true
					}
				}
				
				else if ( rankNumber == nonEliminatedTeamCount )
				{
					
					if ( nonEliminatedTeamCount > eliminationThreshold )
					{
						
						int abovePlace = rankNumber - 1
						if ( abovePlace > eliminationThreshold )
						{
							slot1Place   = eliminationThreshold
							slot2Place   = rankNumber - 1
							slot3Place   = rankNumber
							slot3IsLocal = true
						}
						else if ( abovePlace == eliminationThreshold ) 
						{
							slot1Place   = eliminationThreshold - 1
							slot2Place   = eliminationThreshold
							slot3Place   = rankNumber
							slot3IsLocal = true
						}
					}
					else 
					{
						if ( nonEliminatedTeamCount >= 3 )
						{
							slot1Place   = rankNumber - 2
							slot2Place   = rankNumber - 1
							slot3Place   = rankNumber
							slot3IsLocal = true
						}
						else
						{
							slot1Place   = rankNumber - 1
							slot2Place   = rankNumber
							slot3Place   = -1 
							slot2IsLocal = true
						}
					}
				}
				else
				{
					
					if ( nonEliminatedTeamCount > eliminationThreshold )
					{
						if ( isTeamSafe )
						{
							slot1Place = rankNumber - 1
							slot2Place = rankNumber
							slot3Place = eliminationThreshold + 1
						}
						else
						{
							slot1Place = eliminationThreshold
							slot2Place = rankNumber
							slot3Place = rankNumber + 1
						}
						slot2IsLocal = true
					}
					else 
					{
						slot1Place = rankNumber - 1
						slot2Place = rankNumber
						slot3Place = rankNumber + 1
						slot2IsLocal = true
					}
				}

				slot1Team = nonEliminatedTeamCount > slot1Place - 1 && slot1Place > 0 ? teamsOrAlliancesSortedByScore[ slot1Place - 1 ] : TEAM_UNASSIGNED
				slot2Team = nonEliminatedTeamCount > slot2Place - 1 && slot2Place > 0 ? teamsOrAlliancesSortedByScore[ slot2Place - 1 ] : TEAM_UNASSIGNED
				slot3Team = nonEliminatedTeamCount > slot3Place - 1 && slot3Place > 0 ? teamsOrAlliancesSortedByScore[ slot3Place - 1 ] : TEAM_UNASSIGNED

				slot1TeamName = slot1Team != TEAM_UNASSIGNED ? Localize( Teams_GetTeamName( Squads_GetSquadUIIndex( slot1Team ) ) ) : ""
				slot2TeamName = slot2Team != TEAM_UNASSIGNED ? Localize( Teams_GetTeamName( Squads_GetSquadUIIndex( slot2Team ) ) ) : ""
				slot3TeamName = slot3Team != TEAM_UNASSIGNED ? Localize( Teams_GetTeamName( Squads_GetSquadUIIndex( slot3Team ) ) ) : ""

				slot1Score = slot1Team != TEAM_UNASSIGNED ? GamemodeUtility_GetTeamOrAllianceScore( slot1Team ) : -1
				slot2Score = slot2Team != TEAM_UNASSIGNED ? GamemodeUtility_GetTeamOrAllianceScore( slot2Team ) : -1
				slot3Score = slot3Team != TEAM_UNASSIGNED ? GamemodeUtility_GetTeamOrAllianceScore( slot3Team ) : -1

				
				ObjectiveBR_ScoreHud_SetScoreSnapshots( slot1Score, slot1Place, slot1TeamName, slot1IsLocal, slot2Score, slot2Place, slot2TeamName, slot2IsLocal, slot3Score, slot3Place, slot3TeamName, slot3IsLocal )
				ObjectiveBR_ScoreHud_SetTotalTeamCount( nonEliminatedTeamCount )
				ObjectiveBR_ScoreHud_UpdateTeamMemberIndex() 

				
				if ( gameplayPhase != eObjectiveBRGameplayPhase.ROUND_END_BUFFER && ObjectiveBR_IsScoringGameplayPhase( gameplayPhase ) )
				{
					
					bool didSafeStatusChange = file.isLocalPlayerTeamSafe != isTeamSafe
					file.isLocalPlayerTeamSafe = isTeamSafe

					
					if ( didSafeStatusChange )
						ObjectiveBR_PlayTeamSafeStatusAudioUpdate()
				}
			}
		}
		wait SCORE_UPDATE_DELAY
	}
}



array< int > function ObjectiveBR_GetTeamsSortedByEliminationAndScore()
{
	float timeSinceLastSortCache = ClientTime() - file.lastTeamSortCacheTime
	if ( timeSinceLastSortCache >= OBJECTIVEBR_TEAMSORT_CACHE_INTERVAL )
	{
		file.teamsSortedByEliminationAndScoreCache = GamemodeUtility_GetAlliancesOrTeamsSortedByEliminationAndScore()
		file.lastTeamSortCacheTime = ClientTime()
	}

	return file.teamsSortedByEliminationAndScoreCache
}



array< int > function ObjectiveBR_GetNonEliminatedTeams()
{
	float timeSinceLastCache = ClientTime() - file.lastNonEliminatedTeamsCacheTime
	if ( timeSinceLastCache >= OBJECTIVEBR_TEAMSORT_CACHE_INTERVAL )
	{
		file.nonEliminatedTeamsCache = GamemodeUtility_GetAlliancesOrTeamsSortedByScore( true )
		file.lastNonEliminatedTeamsCacheTime = ClientTime()
	}

	return file.nonEliminatedTeamsCache
}



void function ObjectiveBR_SetRoundInfo( string roundNumberString, string roundInfoString )
{
	var rui = ClGameState_GetRui()
	if ( rui != null )
	{
		RuiSetString( rui, "currentRoundNumber", roundNumberString )
		RuiSetString( rui, "currentRoundString", roundInfoString )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetString( fullmapRui, "currentRoundNumber", roundNumberString )
		RuiSetString( fullmapRui, "currentRoundString", roundInfoString )
	}
}



void function ObjectiveBR_OnRoundEndTimeChanged_CL( entity player, float time )
{
	var rui = ClGameState_GetRui()
	if ( rui != null )
	{
		RuiSetGameTime( rui, "roundEndTime", time )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetGameTime( fullmapRui, "roundEndTime", time )
	}
}



void function ObjectiveBR_SetRoundInfoWarning( string warningString, bool isVisible )
{
	var rui = ClGameState_GetRui()
	if ( rui != null )
	{
		RuiSetString( rui, "roundInfoWarningText", warningString )
		RuiSetBool( rui, "showRoundInfoWarning", isVisible )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetString( fullmapRui, "roundInfoWarningText", warningString )
		RuiSetBool( fullmapRui, "showRoundInfoWarning", isVisible )
	}
}



void function ObjectiveBR_SetRoundInfoImages( asset icon1, asset icon2 )
{
	var rui = ClGameState_GetRui()
	if ( rui != null )
	{
		RuiSetAsset( rui, "roundIcon1", icon1 )
		RuiSetAsset( rui, "roundIcon2", icon2 )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetAsset( fullmapRui, "roundIcon1", icon1 )
		RuiSetAsset( fullmapRui, "roundIcon2", icon2 )
	}
}



void function ObjectiveBR_SetSuddenDeath( bool isSuddenDeath )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetBool( scoreHud, "isSuddenDeath", isSuddenDeath )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetBool( scoreHudFullmap, "isSuddenDeath", isSuddenDeath )

	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui != null )
	{
		RuiSetBool( gamestateRui, "isSuddenDeath", isSuddenDeath )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetBool( fullmapRui, "isSuddenDeath", isSuddenDeath )
	}
}



void function ObjectiveBR_ScoreHud_SetSuddenDeathString( string suddenDeathString )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetString( scoreHud, "suddenDeathString", suddenDeathString )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetString( scoreHudFullmap, "suddenDeathString", suddenDeathString )
}













void function ObjectiveBR_RoundStartAnnouncement( int roundNumber )
{
	
	
}



void function ObjectiveBR_RoundEndAnnouncement( int roundNumber )
{
	
	
}








void function ObjectiveBR_ScoreHud_SetupObjectiveScoreTrackers()
{
	entity localClientPlayer = GetLocalClientPlayer()
	if ( !IsValid( localClientPlayer ) )
		return

	ObjectiveBR_ScoreHud_SetObjectiveIcon( OBJECTIVE_BR_SCORETRACKER_CAPTURE_INDEX, OBJECTIVE_BR_SCORETRACKER_ICON_CAPTURE )
	ObjectiveBR_ScoreHud_SetObjectiveIcon( OBJECTIVE_BR_SCORETRACKER_RESCUE_INDEX, OBJECTIVE_BR_SCORETRACKER_ICON_RESCUE )

	
	ObjectiveBR_ScoreHud_SetObjectiveIcon( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, OBJECTIVE_BR_SCORETRACKER_ICON_EVO )
	ObjectiveBR_ScoreHud_SetObjectiveIsProgressBarVersion( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, true )
	int pointsPerEvo = ObjectiveBR_GetScoreAmountForEvoGained( localClientPlayer.GetTeam() )
	int evoThreshold = ObjectiveBR_GetEvoRequirementForScore()
	ObjectiveBR_ScoreHud_SetObjectiveProgressCurrentScore( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, 0 )
	ObjectiveBR_ScoreHud_SetObjectiveProgressMaxScore( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, evoThreshold )
	ObjectiveBR_ScoreHud_SetObjectiveProgressSubstring( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, Localize( "#GAMEMODE_OBJECTIVE_BR_HUD_EVO_CONVERSION_RATE", evoThreshold, pointsPerEvo ) )
	ObjectiveBR_ScoreHud_SetObjectiveVisible( OBJECTIVE_BR_SCORETRACKER_EVO_INDEX, true )
}



void function ObjectiveBR_ScoreHud_SetObjectiveVisible( int objectiveIndex, bool isVisible )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetBool( scoreHud, "score" + objectiveIndex + "Visible", isVisible )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetBool( scoreHudFullmap, "score" + objectiveIndex + "Visible", isVisible )
}



void function ObjectiveBR_ScoreHud_SetObjectiveScore( int objectiveIndex, int score )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "score" + objectiveIndex, score )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "score" + objectiveIndex, score )
}



void function ObjectiveBR_ScoreHud_SetObjectiveIcon( int objectiveIndex, asset icon )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetImage( scoreHud, "score" + objectiveIndex + "Icon", icon )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetImage( scoreHudFullmap, "score" + objectiveIndex + "Icon", icon )
}



void function ObjectiveBR_ScoreHud_SetObjectiveIsProgressBarVersion( int objectiveIndex, bool isProgressBarVersion )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetBool( scoreHud, "score" + objectiveIndex + "IsProgressVersion", isProgressBarVersion )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetBool( scoreHudFullmap, "score" + objectiveIndex + "IsProgressVersion", isProgressBarVersion )
}



void function ObjectiveBR_ScoreHud_SetObjectiveProgressSubstring( int objectiveIndex, string progressSubstring )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetString( scoreHud, "score" + objectiveIndex + "ProgressSubstring", progressSubstring )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetString( scoreHudFullmap, "score" + objectiveIndex + "ProgressSubstring", progressSubstring )
}



void function ObjectiveBR_ScoreHud_SetObjectiveProgressCurrentScore( int objectiveIndex, int currentProgress )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "score" + objectiveIndex + "CurrentProgress", currentProgress )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "score" + objectiveIndex + "CurrentProgress", currentProgress )
}



void function ObjectiveBR_ScoreHud_SetObjectiveProgressMaxScore( int objectiveIndex, int maxProgress )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "score" + objectiveIndex + "MaxProgress", maxProgress )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "score" + objectiveIndex + "MaxProgress", maxProgress )
}



void function ObjectiveBR_ScoreHud_SetEliminationThreshold( int eliminationThreshold )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "eliminationThreshold", eliminationThreshold )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "eliminationThreshold", eliminationThreshold )
}



void function ObjectiveBR_ScoreHud_SetTotalTeamCount( int totalTeamCount )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "totalTeamCount", totalTeamCount )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "totalTeamCount", totalTeamCount )
}



void function ObjectiveBR_ScoreHud_UpdateTeamMemberIndex()
{
	int teamMemberIndex = GetLocalViewPlayer().GetTeamMemberIndex()

	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "teamMemberIndex", teamMemberIndex )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "teamMemberIndex", teamMemberIndex )
}



void function ObjectiveBR_ScoreHud_SetLowTimeFlag( bool isLowTime )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetBool( scoreHud, "isLowTime", isLowTime )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetBool( scoreHudFullmap, "isLowTime", isLowTime )

	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui != null )
	{
		RuiSetBool( gamestateRui, "isLowTime", isLowTime )
	}

	var fullmapRui = GetFullmapGamestateRui()
	if ( fullmapRui != null )
	{
		RuiSetBool( fullmapRui, "isLowTime", isLowTime )
	}
}



void function ObjectiveBR_ScoreHud_SetScoreSnapshots( int slot1Score, int slot1Place, string slot1TeamName, bool slot1IsLocal, int slot2Score, int slot2Place, string slot2TeamName, bool slot2IsLocal, int slot3Score, int slot3Place, string slot3TeamName, bool slot3IsLocal )
{
	var scoreHud = ObjectiveBR_GetOrCreateScoreHud()
	RuiSetInt( scoreHud, "slot1Score", slot1Score )
	RuiSetInt( scoreHud, "slot1Place", slot1Place )
	RuiSetString( scoreHud, "slot1TeamName", slot1TeamName )
	RuiSetBool( scoreHud, "slot1IsLocal", slot1IsLocal )

	RuiSetInt( scoreHud, "slot2Score", slot2Score )
	RuiSetInt( scoreHud, "slot2Place", slot2Place )
	RuiSetString( scoreHud, "slot2TeamName", slot2TeamName )
	RuiSetBool( scoreHud, "slot2IsLocal", slot2IsLocal )

	RuiSetInt( scoreHud, "slot3Score", slot3Score )
	RuiSetInt( scoreHud, "slot3Place", slot3Place )
	RuiSetString( scoreHud, "slot3TeamName", slot3TeamName )
	RuiSetBool( scoreHud, "slot3IsLocal", slot3IsLocal )

	var scoreHudFullmap = ObjectiveBR_GetOrCreateScoreFullmapHud()
	RuiSetInt( scoreHudFullmap, "slot1Score", slot1Score )
	RuiSetInt( scoreHudFullmap, "slot1Place", slot1Place )
	RuiSetString( scoreHudFullmap, "slot1TeamName", slot1TeamName )
	RuiSetBool( scoreHudFullmap, "slot1IsLocal", slot1IsLocal )

	RuiSetInt( scoreHudFullmap, "slot2Score", slot2Score )
	RuiSetInt( scoreHudFullmap, "slot2Place", slot2Place )
	RuiSetString( scoreHudFullmap, "slot2TeamName", slot2TeamName )
	RuiSetBool( scoreHudFullmap, "slot2IsLocal", slot2IsLocal )

	RuiSetInt( scoreHudFullmap, "slot3Score", slot3Score )
	RuiSetInt( scoreHudFullmap, "slot3Place", slot3Place )
	RuiSetString( scoreHudFullmap, "slot3TeamName", slot3TeamName )
	RuiSetBool( scoreHudFullmap, "slot3IsLocal", slot3IsLocal )
}



void function ObjectiveBR_Markers_RegisterInWorldRui( entity waypoint, var rui )
{
	if ( !( waypoint in file.objectiveRuiMap ) )
	{
		ObjectiveRuiData ruiData
		ruiData.waypoint = waypoint
		ruiData.objectiveRui = rui
		file.objectiveRuiMap[ waypoint ] <- ruiData
	}
	else
	{
		file.objectiveRuiMap[ waypoint ].objectiveRui = rui
	}
}



void function ObjectiveBR_Markers_RegisterMinimapRui( entity waypoint, var rui )
{
	if ( !( waypoint in file.objectiveRuiMap ) )
	{
		ObjectiveRuiData ruiData
		ruiData.waypoint = waypoint
		ruiData.minimapRui = rui
		file.objectiveRuiMap[ waypoint ] <- ruiData
	}
	else
	{
		file.objectiveRuiMap[ waypoint ].minimapRui = rui
	}
}



void function ObjectiveBR_Markers_RegisterFullmapRui( entity waypoint, var rui )
{
	if ( !( waypoint in file.objectiveRuiMap ) )
	{
		ObjectiveRuiData ruiData
		ruiData.waypoint = waypoint
		ruiData.fullmapRui = rui
		file.objectiveRuiMap[ waypoint ] <- ruiData
	}
	else
	{
		file.objectiveRuiMap[ waypoint ].fullmapRui = rui
	}
}



void function ObjectiveBR_Markers_SetObjectiveType( entity waypoint, int objectiveType )
{
	if ( !( waypoint in file.objectiveRuiMap ) )
	{
		ObjectiveRuiData ruiData
		ruiData.waypoint = waypoint
		ruiData.objectiveType = objectiveType
		file.objectiveRuiMap[ waypoint ] <- ruiData
	}
	else
	{
		file.objectiveRuiMap[ waypoint ].objectiveType = objectiveType
	}
}



ObjectiveRuiData ornull function ObjectiveBR_Markers_GetObjectiveRuiDataForWaypoint( entity waypoint )
{
	if ( waypoint in file.objectiveRuiMap )
		return file.objectiveRuiMap[ waypoint ]

	return null
}



table< entity, ObjectiveRuiData > function ObjectiveBR_Markers_GetObjectivesByType( int objectiveType )
{
	table< entity, ObjectiveRuiData > objectivesOfType
	foreach ( waypoint, ruiData in file.objectiveRuiMap )
	{
		if ( ruiData.objectiveType == objectiveType )
		{
			objectivesOfType[ waypoint ] <- ruiData
		}
	}
	return objectivesOfType
}



void function ObjectiveBR_Markers_RemoveWaypointRuis( entity waypoint )
{
	if ( waypoint in file.objectiveRuiMap )
		delete file.objectiveRuiMap[ waypoint ]
}



void function ObjectiveBR_Markers_ClearRuis()
{
	file.objectiveRuiMap.clear()
}



void function ObjectiveBR_Markers_AddObjectiveTypeToShowClosestFilter( int objectiveType )
{
	if ( !file.pinClosestObjectiveTypeFilter.contains( objectiveType ) )
		file.pinClosestObjectiveTypeFilter.append( objectiveType )
}



void function ObjectiveBR_Markers_RemoveObjectiveTypeFromShowClosestFilter( int objectiveType )
{
	if ( file.pinClosestObjectiveTypeFilter.contains( objectiveType ) )
		file.pinClosestObjectiveTypeFilter.fastremovebyvalue( objectiveType )
}



ObjectiveRuiData ornull function ObjectiveBR_InWorldMarkers_GetClosestOfType( int objectiveType )
{
	if ( file.objectiveRuiMap.len() <= 0 )
		return null

	ObjectiveRuiData ornull closestObjective = null
	table< entity, ObjectiveRuiData > objectives = ObjectiveBR_Markers_GetObjectivesByType( eObjectiveBRObjectiveType.RESCUE_EVAC )

	if ( objectives.len() == 0 )
		return null

	foreach ( objective in objectives )
	{
		if ( closestObjective == null )
			closestObjective = objective
		else
		{
			expect ObjectiveRuiData( closestObjective )
			if ( objective.distance < closestObjective.distance )
				closestObjective = objective
		}
	}

	return closestObjective
}



void function ObjectiveBR_InWorldMarkers_ForceShowClosestN( int closestN, bool inWorldOnly = false, bool ignoreDistanceScaling = false )
{
	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) )
		return

	if ( file.objectiveRuiMap.len() <= 0 )
		return

	vector playerPos = player.GetOrigin()

	array< ObjectiveRuiData > objectiveRuiDatas

	
	foreach ( wp, objectiveRuiData in file.objectiveRuiMap )
	{
		objectiveRuiData.distance = DistanceSqr( wp.GetOrigin(), playerPos )
		objectiveRuiDatas.append( objectiveRuiData )
	}

	objectiveRuiDatas.sort( int function ( ObjectiveRuiData a, ObjectiveRuiData b ) {
		if ( a.distance > b.distance )
			return 1
		if ( a.distance < b.distance )
			return -1
		return 0
	} )

	
	
	
	int numForceShown = 0
	array< entity > visibleObjectiveWaypoints = []
	foreach ( ObjectiveRuiData objectiveRuiData in objectiveRuiDatas )
	{
		bool isFilteredOut = false
		
		if ( file.pinClosestObjectiveTypeFilter.len() > 0 )
			if ( !file.pinClosestObjectiveTypeFilter.contains( objectiveRuiData.objectiveType ) )
				isFilteredOut = true

		
		bool isClosestN = visibleObjectiveWaypoints.len() < closestN
		bool shouldForceShow = numForceShown < closestN && !isFilteredOut

		float maxDistance = shouldForceShow ? OBJECTIVE_ICON_MAX_DRAW_DIST_SKYDIVE : OBJECTIVE_ICON_MAX_DRAW_DIST
		SetWaypointRuiMaxDrawDistance( objectiveRuiData.objectiveRui, maxDistance )

		if ( !inWorldOnly )
		{
			ObjectiveBR_Minimap_SetMinimapRuiClampEdge( objectiveRuiData.minimapRui, shouldForceShow )
		}

		
		ObjectiveBR_Markers_SetIgnoreDistanceScaling( objectiveRuiData.objectiveRui, shouldForceShow && ignoreDistanceScaling )

		float maxDistanceSqr = maxDistance * maxDistance
		bool isInRange = objectiveRuiData.distance < maxDistanceSqr
		bool isDesiredVisible = shouldForceShow || isInRange

		if ( isDesiredVisible )
		{
			visibleObjectiveWaypoints.append( objectiveRuiData.waypoint )
		}

		if ( shouldForceShow )
			numForceShown++
	}

	
	
	bool isUsingAlliances = AllianceProximity_IsUsingAlliances()
	int playerAllianceOrTeam = isUsingAlliances ? AllianceProximity_GetAllianceFromTeam( player.GetTeam() ) : player.GetTeam()
	array< entity > objectivePings = Ping_GetStarterPingsArray()
	foreach ( entity objectivePing in objectivePings )
	{
		if ( !IsValid( objectivePing ) )
			continue

		int objectivePingAllianceOrTeam = isUsingAlliances ? AllianceProximity_GetAllianceFromTeam( objectivePing.GetTeam() ) : objectivePing.GetTeam()
		if ( objectivePingAllianceOrTeam != playerAllianceOrTeam )
			continue

		if ( !IsValid( objectivePing.GetParent() ) || !IsValid( objectivePing.GetParent().GetOwner() ) )
			continue

		entity objectivePingWaypointOwner = objectivePing.GetParent().GetOwner()
		bool isDesiredVisible = visibleObjectiveWaypoints.contains( objectivePingWaypointOwner ) || (null != objectivePing.wp.ruiFullmap)
		bool isCurrentlyVisible = !Waypoint_IsHiddenFromLocalHud( objectivePing )

		if ( isDesiredVisible == isCurrentlyVisible )
			continue

		if ( isDesiredVisible )
		{
			Waypoint_ShowOnLocalHud( objectivePing )
		}
		else
		{
			Waypoint_HideOnLocalHud( objectivePing )
		}
	}
}



void function ObjectiveBR_InWorldMarkers_ShowClosest_Thread()
{
	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EndSignal( localPlayer, "OnDestroy" )

	ClWaittillGameStateOrHigher( eGameState.Playing )

	while ( GetGameState() == eGameState.Playing )
	{
		if ( IsPlayerInPlane( localPlayer) || localPlayer.Player_IsSkydiving() )
		{
			ObjectiveBR_InWorldMarkers_ForceShowClosestN( 100, true, false )
		}
		else
		{
			ObjectiveBR_InWorldMarkers_ForceShowClosestN( OBJECTIVE_BR_FORCE_SHOW_CLOSEST_N_OBJECTIVES, false, true )
		}

		wait OBJECTIVE_BR_OBJECTIVE_DISTANCE_CHECK_INTERVAL
	}
}



void function ObjectiveBR_Minimap_SetMinimapRuiClampEdge( var rui, bool shouldClamp )
{
	if ( RuiIsAlive( rui ) )
		RuiSetBool( rui, "shouldClamp", shouldClamp )
}



void function ObjectiveBR_Markers_SetIgnoreDistanceScaling( var rui, bool ignoreDistanceScaling )
{
	if ( RuiIsAlive( rui ) && RuiHasBoolArg( rui, "ignoreDistanceScaling" ) )
		RuiSetBool( rui, "ignoreDistanceScaling", ignoreDistanceScaling )
}

































































void function ServerCallback_ObjectiveBR_DisplayMessageToClient( int messageID, int pointsValue )
{
	ObjectiveBR_DisplayMessageToClient( messageID, pointsValue )
}




void function ObjectiveBR_DisplayMessageToClient( int messageID, int pointsValue )
{
	entity localPlayer = GetLocalViewPlayer()

	if (  !IsValid( localPlayer )  )
		return

	string messageText = ""
	string announcementHeader = "" 
	string announcementSubHeader = "" 
	string announcementSubtext = "" 
	vector announcementColor = COLOR_WHITE
	bool isObituaryMessage = false
	bool isAnnouncementMessage = false
	bool isBigAnnouncement = false
	bool isSkyDiveAnnouncementMessage = false
	bool isScoringMessage = false

	switch ( messageID )
	{
		








		case eObjectiveBRMessageIndex.SCORE_CAPTURE_HOLD:
		case eObjectiveBRMessageIndex.SCORE_CAPTURE_COMPLETE:

		case eObjectiveBRMessageIndex.SCORE_EVO:
			isScoringMessage = true
			break
		case eObjectiveBRMessageIndex.SKYDIVE_MATCH_START:
			announcementHeader = GetCurrentPlaylistVarString( "name", "#GAMEMODE_ANNOUNCE_NONE" )
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_SKYDIVE_SPLASH" )
			ObjectiveBR_DisplayDropshipAnnouncement( announcementHeader, announcementSubHeader )
			EmitUISound( OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT )
			return
		case eObjectiveBRMessageIndex.SKYDIVE_LAND_MATCH_START:
			isAnnouncementMessage = true
			int currentRoundForSquadThreshold = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
			int eliminationThreshold = ObjectiveBR_GetSquadThresholdForRound( currentRoundForSquadThreshold, false )
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_SKYDIVE_SPLASH_LAND", FormatNumber( "1", float( eliminationThreshold ) ) )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_SKYDIVE_SPLASH_LAND_DESC" )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.REDEPLOY_WARNING:
			thread ObjectiveBR_DisplayRedeployWarningCountdown_Thread( localPlayer )
			return
		case eObjectiveBRMessageIndex.SKYDIVE_REDEPLOY:
			announcementHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SKYDIVE_SUDDEN_DEATH" )
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SKYDIVE_SUDDEN_DEATH_SUB" )
			EmitUISound( OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT )
			ObjectiveBR_DisplayDropshipAnnouncement( announcementHeader, announcementSubHeader )
			break
































		case eObjectiveBRMessageIndex.CAPTURE_ROUND_START:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_CAPTURE" )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.SKYDIVE_INCOMING_CAP:
			isAnnouncementMessage = true
			isSkyDiveAnnouncementMessage = true
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_CAPTURE_SKYDIVE_INCOMING" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_CAPTURE_SKYDIVE_INCOMING_SUB" )
			EmitUISound( OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.SKYDIVE_CAPTURE:
			isAnnouncementMessage = true
			isSkyDiveAnnouncementMessage = true
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_CAPTURE_SKYDIVE" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_CAPTURE_SKYDIVE_SUB" )
			EmitUISound( OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.SKYDIVE_LAND_MATCH_START_CAPTURE:
			isAnnouncementMessage = true
			int currentRoundForSquadThreshold = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
			int eliminationThreshold = ObjectiveBR_GetSquadThresholdForRound( currentRoundForSquadThreshold, false )
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_SKYDIVE_SPLASH_LAND", FormatNumber( "1", float( eliminationThreshold ) ) )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_SKYDIVE_SPLASH_LAND_CAP_DESC" )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
























		case eObjectiveBRMessageIndex.NO_OBJECTIVES_REMAIN:
			isAnnouncementMessage = true
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_NO_OBJECTIVES" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_NO_OBJECTIVES_SUB" )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.SKYDIVE_NO_OBJECTIVES_REMAIN:
			isAnnouncementMessage = true
			isSkyDiveAnnouncementMessage = true
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SKYDIVE_NO_OBJECTIVES" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SKYDIVE_NO_OBJECTIVES_SUB" )
			EmitUISound( OBJECTIVE_BR_SFX_SKYDIVE_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.ELIMINATIONS_SOON:
			isAnnouncementMessage = true
			announcementHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON", string( ObjectiveBR_GetCurrentRound() ) )
			bool isTeamSafe = ObjectiveBR_GetIsTeamInSafeRanking( localPlayer.GetTeam() )
			announcementSubHeader = isTeamSafe ? Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON_SAFE_SUB" ) : Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON_UNSAFE_SUB" )
			if ( !isTeamSafe )
			{
				announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_UNSAFE_COLOR / 255.0 )
				EmitUISound( OBJECTIVE_BR_SFX_ROUND_END_WARNING_UNSAFE )
			}
			else
			{
				EmitUISound( OBJECTIVE_BR_SFX_ROUND_END_WARNING_SAFE )
			}
			
			ObjectiveBR_SetRoundInfoWarning( "#GAMEMODE_OBJECTIVE_BR_ROUNDINFO_ELIMS_SOON", true )
			int currentRound = maxint( ObjectiveBR_GetCurrentRound(), OBJECTIVE_BR_FIRST_ROUND )
			string roundNumberString = Localize( "#GAMEMODE_OBJECTIVE_BR_ROUND_NUM_TITLE", currentRound )
			string roundInfoString = Localize( "#GAMEMODE_OBJECTIVE_BR_ROUNDINFO_ELIMS_SOON" )
			ObjectiveBR_SetRoundInfo( roundNumberString, roundInfoString )
			break
		case eObjectiveBRMessageIndex.SKYDIVE_ELIMINATIONS_SOON:
			isAnnouncementMessage = true
			isSkyDiveAnnouncementMessage = true
			announcementHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON", string( ObjectiveBR_GetCurrentRound() ) )
			bool isTeamSafe = ObjectiveBR_GetIsTeamInSafeRanking( localPlayer.GetTeam() )
			announcementSubHeader = isTeamSafe ? Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON_SAFE_SUB" ) : Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMS_SOON_UNSAFE_SUB" )
			if ( !isTeamSafe )
			{
				announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_UNSAFE_COLOR / 255.0 )
				EmitUISound( OBJECTIVE_BR_SFX_ROUND_END_WARNING_UNSAFE )
			}
			else
			{
				EmitUISound( OBJECTIVE_BR_SFX_ROUND_END_WARNING_SAFE )
			}
			break
		case eObjectiveBRMessageIndex.ALL_SQUADS_PROGRESSING:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ALLSAFE_HEADER" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SAFE_DESC" )
			announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_SAFE_COLOR / 255.0 )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.ALL_SQUADS_PROGRESSING_REDEPLOY:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ALLSAFE_HEADER" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SAFE_REDEPLOY_DESC" )
			announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_SAFE_COLOR / 255.0 )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.YOUR_SQUAD_PROGRESSING:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_YOUSAFE_HEADER" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SAFE_DESC" )
			announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_SAFE_COLOR / 255.0 )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.YOUR_SQUAD_PROGRESSING_REDEPLOY:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_YOUSAFE_HEADER" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_SAFE_REDEPLOY_DESC" )
			announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_SAFE_COLOR / 255.0 )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		case eObjectiveBRMessageIndex.YOUR_SQUAD_ELIMINATED:
			isAnnouncementMessage = true
			isBigAnnouncement = true
			announcementHeader = ObjectiveBR_GetRoundStringForAnnouncement()
			announcementSubHeader = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMINATED_HEADER" )
			announcementSubtext = Localize( "#GAMEMODE_OBJECTIVE_BR_ANNOUNCE_ELIMINATED_DESC" )
			announcementColor = SrgbToLinear( OBJECTIVEBR_SNAPSHOT_UNSAFE_COLOR / 255.0 )
			EmitUISound( OBJECTIVE_BR_SFX_ANNOUNCEMENT )
			break
		default:
			Assert( false, "OBJECTIVE BR: " + FUNC_NAME() + " was run with an Invalid messageID: " + messageID + " , message will not display in Live for this event." )
			return
	}

	if ( isScoringMessage )
	{
		if ( messageID in file.scoringMsgTypeToAmountAwardedDuringMsgInterval )
		{
			int scoreAwarded = file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ messageID ]
			scoreAwarded += pointsValue
			file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ messageID ] = scoreAwarded
		}
		else
		{
			file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ messageID ] <- pointsValue
			thread ObjectiveBR_DisplayScoringMessage_Thread( messageID )
		}
	}
	else
	{
		if ( isObituaryMessage )
			Obituary_Print_Localized( messageText )

		if ( isAnnouncementMessage )
		{
			float duration = isSkyDiveAnnouncementMessage ? ANNOUNCEMENT_DURATION : DEFAULT_ANNOUNCEMENT_DURATION
			ObjectiveBR_DisplayAnnouncement( announcementHeader, announcementSubHeader, announcementSubtext, announcementColor, isBigAnnouncement, duration )
		}
	}
}



void function ObjectiveBR_DisplayAnnouncement( string header, string subheader, string subtext, vector announcementColor, bool isBigAnnouncement, float duration )
{
	AnnouncementData announcement = Announcement_Create( subheader )
	Announcement_SetHeaderText( announcement, header )
	Announcement_SetSubText( announcement, subtext )
	Announcement_SetStyle( announcement, isBigAnnouncement ? ANNOUNCEMENT_STYLE_CIRCLE_WARNING : ANNOUNCEMENT_STYLE_GENERIC_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetTitleColor( announcement, announcementColor )
	AnnouncementFromClass( GetLocalClientPlayer(), announcement )
}





void function ObjectiveBR_DisplayDropshipAnnouncement( string header, string subheader )
{
	AnnouncementData announcement = Announcement_Create( header )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subheader )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, ANNOUNCEMENT_DURATION )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	Announcement_SetIcon( announcement, $"" )
	Announcement_SetLeftIcon( announcement, GetCurrentPlaylistVarAsset( "announce_emblem_left", $"" ) )
	Announcement_SetRightIcon( announcement, GetCurrentPlaylistVarAsset( "announce_emblem_right", $"" ) )
	AnnouncementFromClass( GetLocalClientPlayer(), announcement )
}




string function ObjectiveBR_GetRoundStringForAnnouncement()
{
	int currentRound = ObjectiveBR_GetCurrentRound()
	string header
	if ( currentRound >= OBJECTIVE_BR_FINAL_ROUND )
		header = Localize( "#SURVIVAL_CIRCLE_ROUND_FINAL" )
	else
		header = Localize( "#SURVIVAL_CIRCLE_ROUND", currentRound )

	return header
}




const float COUNTDOWN_START_TIME = 16.0
const float COUNTDOWN_FINAL_STAGE_TIME = 3.0
const float COUNTDOWN_INTERVAL = 1.0
void function ObjectiveBR_DisplayRedeployWarningCountdown_Thread( entity localPlayer )
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	if ( GetGameState() != eGameState.Playing )
		return

	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	EndSignal( localPlayer, "OnDestroy" )

	float roundTimeRemaining = ObjectiveBR_GetRoundTimeRemaining()
	float countdownIntervalCheckpoint = COUNTDOWN_START_TIME
	
	if ( roundTimeRemaining > countdownIntervalCheckpoint )
		wait roundTimeRemaining - countdownIntervalCheckpoint

	
	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui != null )
	{
		float countdownEndTime = ClientTime() + countdownIntervalCheckpoint
		RuiSetGameTime( gamestateRui, "suddenDeathStartTime", countdownEndTime )
	}

	while ( roundTimeRemaining > 1.0 )
	{
		roundTimeRemaining = ObjectiveBR_GetRoundTimeRemaining()
		countdownIntervalCheckpoint -= COUNTDOWN_INTERVAL

		
		if ( roundTimeRemaining > COUNTDOWN_FINAL_STAGE_TIME )
			EmitUISound( OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_10_SECS )
		else
			EmitUISound( OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_3_SECS )

		wait roundTimeRemaining - countdownIntervalCheckpoint
	}

	
	EmitUISound( OBJECTIVE_BR_SFX_REDEPLOY_COUNTDOWN_DONE )
}




void function ObjectiveBR_DisplayScoringMessage_Thread( int scoreMessageID )
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	if ( !( scoreMessageID in file.scoringMsgTypeToAmountAwardedDuringMsgInterval ) )
	{
		Assert( false, "OBJECTIVE BR: " + FUNC_NAME() + " was run with a scoreMessageID: " + scoreMessageID + " that wasn't entered in the file.scoringMsgTypeToAmountAwardedDuringMsgInterval table first." )
		return
	}

	if ( GetGameState() > eGameState.Playing )
		return

	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EndSignal( localPlayer, "OnDestroy", "OnDeath" )

	OnThreadEnd(
		function() : ( scoreMessageID )
		{
			delete file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ scoreMessageID ]
		}
	)

	int currentPointsTotal = file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ scoreMessageID ]
	int updatedPointsTotal = currentPointsTotal

	
	while ( true )
	{
		EmitUISound( OBJECTIVE_BR_SFX_SCORE_GAINED )

		wait SCORE_MESSAGING_DELAY

		updatedPointsTotal = file.scoringMsgTypeToAmountAwardedDuringMsgInterval[ scoreMessageID ]

		if ( currentPointsTotal == updatedPointsTotal ) 
			break

		
		currentPointsTotal = updatedPointsTotal
	}

	string messageText = ""
	string scoreText = ""
	asset scoreImage = $""

	switch ( scoreMessageID )
	{
		case eObjectiveBRMessageIndex.SCORE_EVO:
			scoreText = Localize( "#GAMEMODE_OBJECTIVE_BR_SCORE_EVENT_POINTS", currentPointsTotal )
			messageText = Localize( "#GAMEMODE_OBJECTIVE_BR_EVO_SCORE" )
			scoreImage = OBJECTIVE_BR_SCORETRACKER_ICON_EVO
			break




















		case eObjectiveBRMessageIndex.SCORE_CAPTURE_HOLD:
			scoreText = Localize( "#GAMEMODE_OBJECTIVE_BR_SCORE_EVENT_POINTS", currentPointsTotal )
			messageText = Localize( "#GAMEMODE_OBJECTIVE_BR_CAPTURE_HOLD_SCORE" )
			scoreImage = OBJECTIVE_BR_SCORETRACKER_ICON_CAPTURE
			break
		case eObjectiveBRMessageIndex.SCORE_CAPTURE_COMPLETE:
			scoreText = Localize( "#GAMEMODE_OBJECTIVE_BR_SCORE_EVENT_POINTS", currentPointsTotal )
			messageText = Localize( "#GAMEMODE_OBJECTIVE_BR_CAPTURE_SCORE" )
			scoreImage = OBJECTIVE_BR_SCORETRACKER_ICON_CAPTURE
			break

		default:
			Assert( false, "OBJECTIVE BR: " + FUNC_NAME() + " was run with an Invalid scoreMessageID: " + scoreMessageID + " , message will not display in Live for this event." )
			return
	}

	EmitUISound( OBJECTIVE_BR_SFX_SCORE_MESSAGE )
	AddImageQueueMessage( messageText, scoreImage, SPLASH_TEXT_DURATION, eScoreEventMessageType.SPECIAL, scoreText )
}




































































































































const float MUSIC_UPDATE_DELAY = 1.0
void function ManageMusicRampLevelForRound_Thread()
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	if ( GetGameState() != eGameState.Playing )
		return

	int currentRound = ObjectiveBR_GetCurrentRound()
	string musicTrack
	
	switch( currentRound )
	{
		case 1:
			musicTrack = OBJECTIVE_BR_MUSIC_ELIM_ROUND_1
			break
		case 2:
			musicTrack = OBJECTIVE_BR_MUSIC_ELIM_ROUND_2
			break
		case 3:
			musicTrack = OBJECTIVE_BR_MUSIC_ELIM_ROUND_3
			break
		default:
			
			return
	}

	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EndSignal( localPlayer, "OnDestroy" )

	float roundTimeRemaining = ObjectiveBR_GetRoundTimeRemaining()
	float musicDelay = max( roundTimeRemaining - ROUND_ELIM_MUSIC_TOTAL_DURATION, 0.0 )

	
	if ( musicDelay > 0.0 )
	{
		wait musicDelay
		roundTimeRemaining = ObjectiveBR_GetRoundTimeRemaining()
	}

	OnThreadEnd(
		function() : ( musicTrack )
		{
			ObjectiveBR_StopRampUpMusic( musicTrack )
			ObjectiveBR_ScoreHud_SetLowTimeFlag( false )
		}
	)

	float musicDuration = min( roundTimeRemaining, ROUND_ELIM_MUSIC_TOTAL_DURATION )
	float musicEndTime = Time() + musicDuration
	if ( musicDuration > 0.0 )
	{
		
		
		bool isStartingMusicTrack = true
		float trackIntroDuration = musicDuration - ELIMINATIONS_REMINDER_TIME
		if ( trackIntroDuration > 0.0 )
		{
			SetMusicControllerValue( ELIM_MUSIC_CODE_VAL_NO_LAYER, musicTrack, isStartingMusicTrack )
			isStartingMusicTrack = false
			wait trackIntroDuration
		}

		
		bool localTeamSafeStatus = file.isLocalPlayerTeamSafe
		float controllerVal = localTeamSafeStatus ? ELIM_MUSIC_CODE_VAL_SAFE_LAYER : ELIM_MUSIC_CODE_VAL_UNSAFE_LAYER
		SetMusicControllerValue( controllerVal, musicTrack, isStartingMusicTrack )
		isStartingMusicTrack = false
		ObjectiveBR_ScoreHud_SetLowTimeFlag( true )
		if ( !( file.isLocalPlayerTeamSafe ) )
		{
			EmitUISound( OBJECTIVE_BR_SFX_ROUND_ENDING_PULSE )
		}

		wait MUSIC_UPDATE_DELAY

		while ( Time() < musicEndTime )
		{
			if ( !( file.isLocalPlayerTeamSafe ) )
			{
				EmitUISound( OBJECTIVE_BR_SFX_ROUND_ENDING_PULSE )
			}

			
			if ( localTeamSafeStatus != file.isLocalPlayerTeamSafe )
			{
				localTeamSafeStatus = file.isLocalPlayerTeamSafe
				controllerVal = localTeamSafeStatus ? ELIM_MUSIC_CODE_VAL_SAFE_LAYER : ELIM_MUSIC_CODE_VAL_UNSAFE_LAYER
				SetMusicControllerValue( controllerVal, musicTrack, false )
			}

			wait MUSIC_UPDATE_DELAY
		}
	}

	
	float controllerVal = file.isLocalPlayerTeamSafe ? ELIM_END_MUSIC_CODE_VAL_SAFE : ELIM_END_MUSIC_CODE_VAL_ELIMINATED
	SetMusicControllerValue( controllerVal, OBJECTIVE_BR_MUSIC_ELIM_END, true )
}



void function CreateMusicEntityIfNotValid()
{
	if ( !IsValid( file.musicEntity ) )
		file.musicEntity = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0,0,10000>, <0, 0, 0> )
}



void function SetMusicControllerValue( float controllerVal, string musicTrack, bool isStartingMusicTrack )
{
	
	if ( GetGameState() != eGameState.Playing )
		return

	CreateMusicEntityIfNotValid()
	if ( !IsValid( file.musicEntity ) )
		return

	
	if ( isStartingMusicTrack )
	{
		EmitSoundOnEntity( file.musicEntity, musicTrack )
		file.musicEntity.UnsetSoundCodeControllerValue()
	}

	
	file.musicEntity.SetSoundCodeControllerValue( controllerVal )
}




void function ObjectiveBR_StopRampUpMusic( string musicTrack )
{
	if ( IsValid( file.musicEntity ) )
	{
		StopSoundOnEntity( file.musicEntity, musicTrack )
		file.musicEntity.UnsetSoundCodeControllerValue()
	}
}




const float ROUND_START_NO_STATUS_UPDATE_AUDIO_BUFFER = 1.0
void function ObjectiveBR_PlayTeamSafeStatusAudioUpdate()
{
	
	if ( GetGlobalNetInt( "objective_br_gameplay_phase" ) == eObjectiveBRGameplayPhase.ROUND_END_BUFFER )
		return

	
	if ( Time() <= GetGlobalNetTime( "round_start_time" ) + ROUND_START_NO_STATUS_UPDATE_AUDIO_BUFFER )
		return

	if ( file.isLocalPlayerTeamSafe )
		EmitUISound( OBJECTIVE_BR_SFX_TEAM_SAFE )
	else
		EmitUISound( OBJECTIVE_BR_SFX_TEAM_NOT_SAFE )
}

















































































































































































void function ServerCallback_ObjectiveBR_TriggerLocalEliminationEffectsOnPlayer()
{
	thread ObjectiveBR_ManageEliminationEffects_Thread()
}




void function ObjectiveBR_ManageEliminationEffects_Thread()
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	localViewPlayer.EndSignal( "OnDeath", "OnDestroy" )

	entity cockpit = localViewPlayer.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	EmitUISound( OBJECTIVE_BR_SFX_ELIM_DEATH_1P )
	PassByReferenceInt screenFxHandle
	screenFxHandle.value = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( OBJECTIVE_BR_VFX_ELIM_DEATH_SCREEN_EFECT ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( screenFxHandle.value, true )

	OnThreadEnd(
		function() : ( screenFxHandle, localViewPlayer )
		{
			if ( EffectDoesExist( screenFxHandle.value ) )
				EffectStop( screenFxHandle.value, false, true )
		}
	)

	wait OBJECTIVE_BR_DEATH_EFFECTS_MAX_DURATION 
}



void function ObjectiveBR_PlaySuddenDeathTransitionAudioDelayed_Thread()
{
#if DEV
		Assert( IsNewThread(), "Must be threaded off" )
#endif

	if ( GetGameState() > eGameState.Playing )
		return

	if ( !IsValid( clGlobal.levelEnt ) )
		return

	EndSignal( clGlobal.levelEnt, "OnDestroy" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) )
		return

	EndSignal( localPlayer, "OnDestroy" )

	wait REDEPLOY_FADE_TIME

	EmitUISound( OBJECTIVE_BR_SFX_REDPLOY_BANNER )
}

































































































































































































































































































































































































































































































#if DEV

void function DEV_OnPropScriptCreated( entity prop )
{
	if ( prop.GetTargetName() == "debugSpawnPoint" )
	{
		thread DEV_DebugSpawnPointUI_Thread( prop )
	}
}
#endif

#if DEV

void function DEV_DebugSpawnPointUI_Thread( entity prop )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( !IsValid( prop ) )
		return

	prop.EndSignal( "OnDestroy" )

	vector pos = prop.GetOrigin()
	vector iconColor = GetKeyColor( COLORID_HUD_LOOT_TIER5 ) * ( 1.0 / 255.0 )
	var minimapRui = Minimap_AddRuitPosition( pos, <0,90,0>, $"ui/minimap_square_capture_zone_objective_icon.rpak", 1.0, COLOR_GREEN )
	var fullmapRui = FullMap_AddRuiAtPos( pos, <0,90,0>, $"ui/fullmap_square_capture_zone_objective_icon.rpak", 1.0, COLOR_GREEN )

	OnThreadEnd(
		function() : ( minimapRui, fullmapRui )
		{
			Minimap_CommonCleanup( minimapRui )
			Fullmap_RemoveRui( fullmapRui )
			RuiDestroy( fullmapRui )
		}
	)

	string spawnPointRating = format( "%.2f", prop.GetAngles().x )

	
	
	
	RuiSetFloat2( minimapRui, "iconScale", < 0.65, 0.65, 0 > )
	RuiSetString( minimapRui, "objectiveName", spawnPointRating )

	
	
	
	RuiSetString( fullmapRui, "objectiveName", spawnPointRating )

	WaitForever()
}
#endif























































































































































































































































































































































































































































      