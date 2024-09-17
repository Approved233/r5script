

global function ObjectiveCaptureZone_Init



















global function ServerCallback_ObjectiveCaptureZone_DisplayMessageToClient



global function ObjectiveCaptureZone_SetCaptureZoneLifetime
global function ObjectiveCaptureZone_GetCaptureZoneLifetime
global function ObjectiveCaptureZone_SetCaptureZoneCaptureTime
global function ObjectiveCaptureZone_GetCaptureZoneCaptureTime
global function ObjectiveCaptureZone_SetCaptureZoneFortifyLevels
global function ObjectiveCaptureZone_GetCaptureZoneFortifyLevels
global function ObjectiveCaptureZone_SetCaptureZoneSpawnDelayTime
global function ObjectiveCaptureZone_GetCaptureZoneSpawnDelayTime




















global const OBJECTIVE_CAPTURE_ZONE_SCRIPTNAME = "objective_capture_zone"
global const vector OBJECTIVE_LOCATION_ORIGIN_INVALID = <FLT_MAX, FLT_MAX, FLT_MAX>
global const float OBJECTIVE_LOCATION_RADIUS_INVALID = -1



















































const int INVALID_OBJ_INDEX_DEFAULT = -1
const int INVALID_OBJ_INDEX_OBJ_COMPLETE = -2
const int OBJECTIVE_CAPTURE_ZONE_OBJECTIVE_TYPE = eObjectiveSystem_ObjectiveType.CAPTURE_ZONE


const int CAPTURE_OBJ_WAYPOINT_FLOAT_IDX_START_TIME = 0
const int CAPTURE_OBJ_WAYPOINT_FLOAT_IDX_CAPTURE_PROGRESS_TIME = 1
const int CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_INDEX = 3
const int CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_STATE = 4
const int CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_OWNER = 5

const float DELAYED_MESSAGE_DELAY = 2.5 
const float CAPTURE_OBJ_DEFAULT_LIFETIME = 120.0
const float CAPTURE_OBJ_DEFAULT_CAPTURE_TIME = 60.0
global const int CAPTURE_OBJ_DEFAULT_FORTIFY_LEVELS = 1
const float CAPTURE_OBJ_DEFAULT_TAKEOVER_ACCELERATION_RATE = 0.0
const float CAPTURE_OBJ_INCOMING_DURATION = 30.0 


const int OBJECTIVE_CAPTURE_ZONE_WAYPOINT_TYPE = eWaypoint.OBJECTIVE_CAPTURE_ZONE
const vector OBJECTIVE_CAPTURE_ZONE_TRACEBLOCKER_BOXMINS =  < -50, -50, 0>
const vector OBJECTIVE_CAPTURE_ZONE_TRACEBLOCKER_BOXMAXS = < 50, 50, 55 >
const vector OBJECTIVE_CAPTURE_ZONE_PING_OFFSET = ZERO_VECTOR




const string OBJECTIVE_CAPTUREZONE_SFX_ZONE_ENTER = "FreeDM_UI_InGame_Zone_Enter_1p"
const string OBJECTIVE_CAPTUREZONE_SFX_ZONE_EXIT = "FreeDM_UI_InGame_Zone_Exit_1p"
const string OBJECTIVE_CAPTUREZONE_SFX_SUDDEN_DEATH = "FreeDM_UI_InGame_Zone_SuddenDeath_1P"
const string OBJECTIVE_CAPTUREZONE_SFX_CONTESTED = "FreeDM_UI_InGame_Zone_Contested_1P"
const string OBJECTIVE_CAPTUREZONE_SFX_CAPTURING_LOOP = "ObjBR_UI_Zone_ScoringLoop_1P"


const asset CAPTURE_OBJECTIVE_MAP_ICON = $"rui/hud/gametype_icons/control/capture_point_bg"


const string ZONE_COLOR_CORRECTION = "materials/correction/mode_BR_capturing.raw_hdr"
const string ZONE_CONTESTED_COLOR_CORRECTION = "materials/correction/mode_br_contested.raw_hdr"
const int INVALID_COLOR_CORRECTION_INDEX = -1

const int MAX_CAPTURE_ZONE_LIMIT = 100 



enum eObjectiveCaptureZoneCaptureZoneState
{
	INCOMING,
	NEUTRAL,
	CAPTURING,
	DRAINING,
	CONTESTED,
	SUDDEN_DEATH,

	_count,
}

enum eObjectiveCaptureZoneMessageIndex
{
	OBJECTIVE_ENTERS_CONTESTED_STATE,
	OBJECTIVE_ENTERS_SUDDEN_DEATH,
	_count
}
























struct
{

		float captureZoneLifetime = CAPTURE_OBJ_DEFAULT_LIFETIME
		float captureZoneCaptureTime = CAPTURE_OBJ_DEFAULT_CAPTURE_TIME
		int captureZoneFortifyLevels = CAPTURE_OBJ_DEFAULT_FORTIFY_LEVELS
		float captureZoneSpawnDelay = CAPTURE_OBJ_INCOMING_DURATION































		array < entity > objectiveWaypoints 
		array < var > objectiveWaypointRuis 
		int colorCorrection = INVALID_COLOR_CORRECTION_INDEX

}file

void function ObjectiveCaptureZone_Init()
{

		ObjectiveSystem_Interface objectiveInterface
		objectiveInterface.isEnabled = ObjectiveCaptureZone_IsObjectiveEnabled





		ObjectiveManager_RegisterObjectiveType( OBJECTIVE_CAPTURE_ZONE_OBJECTIVE_TYPE, objectiveInterface )


	if ( !ObjectiveCaptureZone_IsObjectiveEnabled() )
		return



















		file.objectiveWaypointRuis.resize( MAX_CAPTURE_ZONE_LIMIT, null )
		file.objectiveWaypoints.resize( MAX_CAPTURE_ZONE_LIMIT, null )

		if ( !ObjectiveCaptureZone_AreObjectivePingsEnabled() )
		{
			AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, ObjectiveCaptureZone_OnPlayerWaypointCreated )
		}

		RegisterSignal( "ObjectiveCaptureZone_PlayerExitedZone" )


	

		ObjectivePing_Interface captureZoneObjectivePingInterface
		captureZoneObjectivePingInterface.waypointType = OBJECTIVE_CAPTURE_ZONE_WAYPOINT_TYPE

		
		captureZoneObjectivePingInterface.pingSettings.objectiveScriptName = OBJECTIVE_CAPTURE_ZONE_SCRIPTNAME
		captureZoneObjectivePingInterface.pingSettings.traceBlockerBoxMins = OBJECTIVE_CAPTURE_ZONE_TRACEBLOCKER_BOXMINS
		captureZoneObjectivePingInterface.pingSettings.traceBlockerBoxMaxs = OBJECTIVE_CAPTURE_ZONE_TRACEBLOCKER_BOXMAXS
		captureZoneObjectivePingInterface.pingSettings.debugDraw = false


			captureZoneObjectivePingInterface.getObjectiveWaypointsArray = ObjectiveCaptureZone_GetObjectiveWaypointsArray
			captureZoneObjectivePingInterface.onUpdatePingCount = ObjectiveCaptureZone_OnUpdatePingCount
			captureZoneObjectivePingInterface.getObjectiveName = ObjectiveCaptureZone_GetObjectiveName
			captureZoneObjectivePingInterface.onObjectiveWaypointCreated = ObjectiveCaptureZone_OnObjectiveWaypointCreated






		Ping_AddObjectiveWaypointType( captureZoneObjectivePingInterface )


	ObjectiveCaptureZone_RegisterNetworking()
}

void function ObjectiveCaptureZone_RegisterNetworking()
{
	if ( !ObjectiveCaptureZone_IsObjectiveEnabled() )
		return


		Remote_RegisterClientFunction( "ServerCallback_ObjectiveCaptureZone_DisplayMessageToClient", "int", 0, eObjectiveCaptureZoneMessageIndex._count, "int", 0, GetScoreLimit_FromPlaylist() + 1 )
		RegisterNetworkedVariable( "captureZone_OccupiedObjectiveID", SNDC_PLAYER_GLOBAL, SNVT_INT, INVALID_OBJ_INDEX_DEFAULT )
		RegisterNetworkedVariable( "captureZone_PlayerTimeOnObjectives", SNDC_PLAYER_GLOBAL, SNVT_TIME, 0.0 )







		RegisterNetVarIntChangeCallback ( "captureZone_OccupiedObjectiveID", OnCaptureZoneOccupiedObjectiveIDChanged_Client )


}












void function ObjectiveCaptureZone_SetCaptureZoneLifetime( float captureZoneLifetime )
{






	printt( "Objective Capture Zone: Setting Zone Life Time to: ", captureZoneLifetime )
	file.captureZoneLifetime = captureZoneLifetime
}




float function ObjectiveCaptureZone_GetCaptureZoneLifetime()
{
	return file.captureZoneLifetime
}



void function ObjectiveCaptureZone_SetCaptureZoneSpawnDelayTime( float captureZoneSpawnDelay )
{






	printt( "Objective Capture Zone: Setting Zone Spawn Delay Time to: ", captureZoneSpawnDelay )
	file.captureZoneSpawnDelay = captureZoneSpawnDelay
}



float function ObjectiveCaptureZone_GetCaptureZoneSpawnDelayTime()
{
	return file.captureZoneSpawnDelay
}



void function ObjectiveCaptureZone_SetCaptureZoneCaptureTime( float captureZoneCaptureTime )
{






	printt( "Objective Capture Zone: Setting Zone Capture Time to: ", captureZoneCaptureTime )
	file.captureZoneCaptureTime = captureZoneCaptureTime
}




float function ObjectiveCaptureZone_GetCaptureZoneCaptureTime()
{
	return file.captureZoneCaptureTime
}



void function ObjectiveCaptureZone_SetCaptureZoneFortifyLevels( int captureZoneFortifyLevels )
{
	printt( "Objective Capture Zone: Setting Zone Fortify Levels to: ", captureZoneFortifyLevels )
	file.captureZoneFortifyLevels = captureZoneFortifyLevels
}



int function ObjectiveCaptureZone_GetCaptureZoneFortifyLevels()
{
	return file.captureZoneFortifyLevels
}


































































































































bool function ObjectiveCaptureZone_AreObjectivePingsEnabled()
{
	return GetCurrentPlaylistVarBool( "capture_zone_are_objective_pings_enabled", true )
}















































































































































































































bool function GetIsWaypointCaptureZoneObjectiveWaypoint( entity waypoint )
{
	return IsValid( waypoint ) && waypoint.GetNetworkedClassName() == PLAYER_WAYPOINT_CLASSNAME && waypoint.GetWaypointType() == eWaypoint.OBJECTIVE_CAPTURE_ZONE
}




bool function ObjectiveCaptureZone_IsValidObjectiveIndex( int objectiveIndex )
{
	return objectiveIndex != INVALID_OBJ_INDEX_DEFAULT && objectiveIndex != INVALID_OBJ_INDEX_OBJ_COMPLETE
}

































int function ObjectiveCaptureZone_GetCaptureProgressAsInt( entity objectiveWaypoint )
{
	
	if ( !GetIsWaypointCaptureZoneObjectiveWaypoint( objectiveWaypoint ) )
		return -1

	
	float captureProgressTime = objectiveWaypoint.GetWaypointFloat( CAPTURE_OBJ_WAYPOINT_FLOAT_IDX_CAPTURE_PROGRESS_TIME )
	if ( captureProgressTime <= 0.0 )
		return 0

	float captureProgress = captureProgressTime / ObjectiveCaptureZone_GetCaptureZoneCaptureTime()
	return GamemodeUtility_GetObjectiveProgressPercentIntFromFloat( captureProgress )
}
















































































































































































































































































































































const vector ZONE_NORMAL_COLOR = COLOR_DARK_GRAY
const vector ZONE_CAPTURING_COLOR_FRIENDLY = COLOR_CYAN
const vector ZONE_CAPTURING_COLOR_ENEMY = COLOR_RED
const vector ZONE_CONTESTED_COLOR = COLOR_PURPLE
const vector ZONE_SUDDENDEATH_COLOR = COLOR_ORANGE





















































































































































































































































































































































































































































































































































































































































void function OnCaptureZoneOccupiedObjectiveIDChanged_Client( entity player, int newOccupiedObjectiveID )
{
	
	if ( player == GetLocalViewPlayer() )
	{
		
		if ( ObjectiveCaptureZone_IsValidObjectiveIndex( newOccupiedObjectiveID ) )
		{
			ObjectiveCaptureZone_PlayCaptureZoneEnterExitSFX( true )
			thread ObjectiveCaptureZone_ManageInsideZoneEffects_Thread( newOccupiedObjectiveID, player )
		}
		else if( newOccupiedObjectiveID == INVALID_OBJ_INDEX_DEFAULT )
		{
			ObjectiveCaptureZone_PlayCaptureZoneEnterExitSFX( false )
			player.Signal( "ObjectiveCaptureZone_PlayerExitedZone" )
		}
		else
		{
			
			
			player.Signal( "ObjectiveCaptureZone_PlayerExitedZone" )
		}
	}
}




const float ZONE_EFFECTS_UPDATE_DELAY = 0.5
const float COLOR_CORRECTION_LERP_DURATION = 1.0
void function ObjectiveCaptureZone_ManageInsideZoneEffects_Thread( int objectiveIndex, entity player )
{
	Assert( IsNewThread(), "Must be threaded off" )
	if ( objectiveIndex < 0 || objectiveIndex >= file.objectiveWaypoints.len() )
		return

	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath", "OnDestroy", "ObjectiveCaptureZone_PlayerExitedZone" )

	entity waypoint = file.objectiveWaypoints[ objectiveIndex ]
	if ( !IsValid( waypoint ) )
		return

	waypoint.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( file.colorCorrection != INVALID_COLOR_CORRECTION_INDEX )
			{
				ColorCorrection_Release( file.colorCorrection )
				file.colorCorrection = INVALID_COLOR_CORRECTION_INDEX
			}

			StopUISoundByName( OBJECTIVE_CAPTUREZONE_SFX_CAPTURING_LOOP )
		}
	)

	
	wait ZONE_EFFECTS_UPDATE_DELAY

	
	int zoneState = -1
	int currentZoneState
	while( GetGameState() == eGameState.Playing )
	{
		currentZoneState = waypoint.GetWaypointInt( CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_STATE )

		
		if ( currentZoneState != zoneState )
		{
			
			
			if ( zoneState != eObjectiveCaptureZoneCaptureZoneState.CAPTURING && zoneState != eObjectiveCaptureZoneCaptureZoneState.DRAINING )
			{
				if ( currentZoneState == eObjectiveCaptureZoneCaptureZoneState.CAPTURING || currentZoneState == eObjectiveCaptureZoneCaptureZoneState.DRAINING )
					EmitUISound( OBJECTIVE_CAPTUREZONE_SFX_CAPTURING_LOOP )
			}
			else 
			{
				if ( currentZoneState != eObjectiveCaptureZoneCaptureZoneState.CAPTURING && currentZoneState != eObjectiveCaptureZoneCaptureZoneState.DRAINING )
					StopUISoundByName( OBJECTIVE_CAPTUREZONE_SFX_CAPTURING_LOOP )
			}

			
			if ( zoneState != -1 )
			{
				zoneState = currentZoneState
				waitthread ColorCorrection_LerpWeight_Thread( player, 1.0, 0.0 )
			}
			else
			{
				zoneState = currentZoneState
			}

			
			
			if ( file.colorCorrection != INVALID_COLOR_CORRECTION_INDEX)
			{
				ColorCorrection_Release( file.colorCorrection )
				file.colorCorrection = INVALID_COLOR_CORRECTION_INDEX
			}

			
			if ( currentZoneState == eObjectiveCaptureZoneCaptureZoneState.CONTESTED || currentZoneState == eObjectiveCaptureZoneCaptureZoneState.SUDDEN_DEATH )
				file.colorCorrection = ColorCorrection_Register( ZONE_CONTESTED_COLOR_CORRECTION )
			else
				file.colorCorrection = ColorCorrection_Register( ZONE_COLOR_CORRECTION )

			
			waitthread ColorCorrection_LerpWeight_Thread( player, 0.0, 1.0 )
		}
		else
		{
			wait ZONE_EFFECTS_UPDATE_DELAY
		}
	}
}



void function ColorCorrection_LerpWeight_Thread( entity player, float startWeight, float endWeight )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( file.colorCorrection == INVALID_COLOR_CORRECTION_INDEX )
		return

	player.EndSignal( "OnDeath", "OnDestroy", "ObjectiveCaptureZone_PlayerExitedZone" )

	float startTime = Time()
	float endTime = startTime + COLOR_CORRECTION_LERP_DURATION
	ColorCorrection_SetExclusive( file.colorCorrection, true )

	while ( Time() <= endTime && file.colorCorrection != INVALID_COLOR_CORRECTION_INDEX )
	{
		float weight = GraphCapped( Time(), startTime, endTime, startWeight, endWeight )
		ColorCorrection_SetWeight( file.colorCorrection, weight )
		WaitFrame()
	}

	if ( file.colorCorrection != INVALID_COLOR_CORRECTION_INDEX )
		ColorCorrection_SetWeight( file.colorCorrection, endWeight )
}









void function ObjectiveCaptureZone_OnObjectiveWaypointCreated( entity objectiveWaypoint, entity objectivePing )
{
	thread ObjectiveCaptureZone_CreateObjectiveIcon_Thread( objectiveWaypoint, objectivePing )
}



void function ObjectiveCaptureZone_OnPlayerWaypointCreated( entity waypoint )
{
	if ( waypoint.GetWaypointType() != eWaypoint.OBJECTIVE_CAPTURE_ZONE )
		return

	thread ObjectiveCaptureZone_CreateObjectiveIcon_Thread( waypoint, waypoint )
}




const int OBJECTIVE_RUI_SORTING = 301
void function ObjectiveCaptureZone_CreateObjectiveIcon_Thread( entity objectiveWaypoint, entity objectivePing )
{
	Assert( IsNewThread(), "Must be threaded off" )

	FlagWait( "EntitiesDidLoad" )

	entity localPlayer = GetLocalClientPlayer()
	if ( !IsValid( localPlayer ) || !IsValid( objectiveWaypoint ) || !IsValid( objectivePing ) )
		return

	localPlayer.EndSignal( "OnDestroy" )
	objectiveWaypoint.EndSignal( "OnDestroy" )

	vector pos = objectiveWaypoint.GetOrigin()
	vector iconColor = GetKeyColor( COLORID_HUD_LOOT_TIER5 ) * ( 1.0 / 255.0 )
	var minimapRui = Minimap_AddRuitPosition( pos, <0,90,0>, $"ui/minimap_square_capture_zone_objective_icon.rpak", 1.0, COLOR_WHITE )
	var fullmapRui = FullMap_AddRuiAtPos( pos, <0,90,0>, $"ui/fullmap_square_capture_zone_objective_icon.rpak", 1.0, COLOR_WHITE )
	var objectiveRui = CreateWaypointRui( $"ui/waypoint_survival_objective_capture_zone.rpak", OBJECTIVE_RUI_SORTING )
	ObjectiveBR_Markers_RegisterInWorldRui( objectiveWaypoint, objectiveRui )
	ObjectiveBR_Markers_RegisterMinimapRui( objectiveWaypoint, minimapRui )
	ObjectiveBR_Markers_SetObjectiveType( objectiveWaypoint, eObjectiveBRObjectiveType.CAPTURE )
	int objectiveNameIndex = objectiveWaypoint.GetWaypointInt( CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_INDEX )

	
	file.objectiveWaypoints[ objectiveNameIndex ] = objectiveWaypoint
	file.objectiveWaypointRuis[ objectiveNameIndex ] = objectiveRui

	OnThreadEnd(
		function() : ( minimapRui, fullmapRui, objectiveRui, objectiveWaypoint, objectiveNameIndex )
		{
			ObjectiveBR_Markers_RemoveWaypointRuis( objectiveWaypoint )
			Minimap_CommonCleanup( minimapRui )
			Fullmap_RemoveRui( fullmapRui )
			RuiDestroy( fullmapRui )
			RuiDestroyIfAlive( objectiveRui )
			file.objectiveWaypoints[ objectiveNameIndex ] = null
			file.objectiveWaypointRuis[ objectiveNameIndex ] = null
		}
	)

	
	
	
	RuiSetFloat2( minimapRui, "iconScale", < 0.65, 0.65, 0 > )
	RuiSetString( minimapRui, "objectiveName", CaptureObjectivePing_GetObjectiveNameFromObjectiveID_Localized( objectiveNameIndex ) )
	RuiTrackInt( minimapRui, "currentOwner", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_OWNER )
	RuiTrackInt( minimapRui, "objectiveState", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_STATE )

	
	
	
	RuiSetString( fullmapRui, "objectiveName", CaptureObjectivePing_GetObjectiveNameFromObjectiveID_Localized( objectiveNameIndex ) )
	RuiTrackInt( fullmapRui, "currentOwner", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_OWNER )
	RuiTrackInt( fullmapRui, "objectiveState", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_STATE )

	
	
	

	
	RuiKeepSortKeyUpdated( objectiveRui, true, "targetPos" )
	RuiSetFloat3( objectiveRui, "targetPos", pos )
	RuiTrackFloat3( objectiveRui, "playerAngles", localPlayer, RUI_TRACK_CAMANGLES_FOLLOW )
	RuiTrackFloat( objectiveRui, "objectiveStartTime", objectiveWaypoint, RUI_TRACK_WAYPOINT_FLOAT, CAPTURE_OBJ_WAYPOINT_FLOAT_IDX_START_TIME )
	RuiTrackFloat( objectiveRui, "captureProgressTime", objectiveWaypoint, RUI_TRACK_WAYPOINT_FLOAT, CAPTURE_OBJ_WAYPOINT_FLOAT_IDX_CAPTURE_PROGRESS_TIME )
	RuiTrackInt( objectiveRui, "objectiveState", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_STATE )
	RuiTrackInt( objectiveRui, "currentOwner", objectiveWaypoint, RUI_TRACK_WAYPOINT_INT, CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_OWNER )
	RuiSetVisible( objectiveRui, true )
	RuiSetString( objectiveRui, "objectiveName", CaptureObjectivePing_GetObjectiveNameFromObjectiveID_Localized( objectiveNameIndex ) )

	
	RuiSetFloat( objectiveRui, "objectiveLifetime", ObjectiveCaptureZone_GetCaptureZoneLifetime() )
	RuiSetFloat( objectiveRui, "incomingDuration", ObjectiveCaptureZone_GetCaptureZoneSpawnDelayTime() )
	RuiSetFloat( objectiveRui, "captureDuration", ObjectiveCaptureZone_GetCaptureZoneCaptureTime() )

	int localPlayerTeam = localPlayer.GetTeam()
	RuiSetInt( objectiveRui, "yourTeam", localPlayerTeam )
	RuiSetInt( minimapRui, "localPlayerTeam", localPlayerTeam )
	RuiSetInt( fullmapRui, "localPlayerTeam", localPlayerTeam )

	
	RuiSetInt( objectiveRui, "friendliesOnObjective", 0 )
	RuiSetInt( objectiveRui, "enemiesOnObjective", 0 )

	entity localViewPlayer = GetLocalViewPlayer()
	while ( IsValid( localViewPlayer ) && IsValid( clGlobal.signalDummy ) )
	{
		RuiTrackFloat3( objectiveRui, "playerAngles", localViewPlayer, RUI_TRACK_CAMANGLES_FOLLOW )
		WaitSignal( clGlobal.signalDummy, "ViewPlayerChanged" )
		localViewPlayer = GetLocalViewPlayer()
	}

	WaitForever()
}



array < entity > function ObjectiveCaptureZone_GetObjectiveWaypointsArray()
{
	return file.objectiveWaypoints
}



void function ObjectiveCaptureZone_OnUpdatePingCount( entity objectiveWaypoint, entity objectivePing, int pingCount, bool doesPlayerHavePingOnObjective, bool isPlayerAction )
{
	Ping_CaptureObjective_OnUpdatePingCount( objectiveWaypoint, objectivePing, pingCount, doesPlayerHavePingOnObjective, isPlayerAction )

	if ( !IsValid( objectiveWaypoint ) || !file.objectiveWaypoints.contains( objectiveWaypoint ) )
		return

	entity localPlayer = GetLocalClientPlayer()

	bool isUsingAlliances = AllianceProximity_IsUsingAlliances()
	int pingTeamOrAlliance = isUsingAlliances ? AllianceProximity_GetAllianceFromTeam( objectivePing.GetTeam() ) : objectivePing.GetTeam()
	int playerTeamOrAlliance = isUsingAlliances ? AllianceProximity_GetAllianceFromTeam( localPlayer.GetTeam() ) : localPlayer.GetTeam()

	if ( playerTeamOrAlliance != pingTeamOrAlliance )
		return

	int objectiveIndex = ObjectiveCaptureZone_GetObjectiveIDFromWaypoint( objectiveWaypoint )
	var rui = file.objectiveWaypointRuis[ objectiveIndex ]
	RuiSetInt( rui, "numTeamPings", pingCount )
}



array< string > function ObjectiveCaptureZone_GetObjectiveName( entity objectiveWaypoint )
{
	int objectiveID = ObjectiveCaptureZone_GetObjectiveIDFromWaypoint( objectiveWaypoint )
	if ( objectiveID >= 0 )
	{
		return [ CaptureObjectivePing_GetObjectiveNameFromObjectiveID_Localized( objectiveID ) ]
	}

	return ["<objectiveUnkown:[" + objectiveWaypoint + "]>"]
}















































const float SPLASH_TEXT_DURATION = 4.0
void function ServerCallback_ObjectiveCaptureZone_DisplayMessageToClient( int messageID, int pointsValue )
{
	entity localPlayer = GetLocalViewPlayer()

	if (  !IsValid( localPlayer )  )
		return

	string messageText = ""

	string announcementText = ""
	string announcementSubText = ""
	bool isObituaryMessage = false
	bool isAnnouncementMessage = false
	bool isSplashText = false
	vector announcementColor = <0.8, 0.8, 0.8>

	switch ( messageID )
	{
		case eObjectiveCaptureZoneMessageIndex.OBJECTIVE_ENTERS_SUDDEN_DEATH:
			isSplashText = true
			messageText = Localize( "#OBJECTIVE_CAPTUREZONE_SUDDEN_DEATH" )
			EmitUISound( OBJECTIVE_CAPTUREZONE_SFX_SUDDEN_DEATH )
			break
		case eObjectiveCaptureZoneMessageIndex.OBJECTIVE_ENTERS_CONTESTED_STATE:
			EmitUISound( OBJECTIVE_CAPTUREZONE_SFX_CONTESTED )
			break
		default:
			Assert( false, "Objective Capture Zone: " + FUNC_NAME() + " was run with an Invalid messageID: " + messageID + " , message will not display in Live for this event." )
			return
	}

	
	if ( announcementText == "" )
		announcementText = messageText

	if ( isObituaryMessage )
		Obituary_Print_Localized( messageText )

	if ( isAnnouncementMessage )
	{
		AnnouncementData announcement = Announcement_Create( announcementText )
		announcement.subText = announcementSubText
		announcement.duration = 5.0
		announcement.titleColor = announcementColor
		announcement.priority =	0
		announcement.announcementStyle = ANNOUNCEMENT_STYLE_CIRCLE_WARNING

		AnnouncementFromClass( localPlayer, announcement )
	}

	if ( isSplashText )
		AddImageQueueMessage( messageText, $"", SPLASH_TEXT_DURATION )
}















void function ObjectiveCaptureZone_PlayCaptureZoneEnterExitSFX( bool isEnteringZone )
{
	if ( !IsValid( GetLocalViewPlayer() ) )
		return

	if ( isEnteringZone )
	{
		EmitUISound( OBJECTIVE_CAPTUREZONE_SFX_ZONE_ENTER )
	}
	else
	{
		EmitUISound( OBJECTIVE_CAPTUREZONE_SFX_ZONE_EXIT )
	}
}
















int function ObjectiveCaptureZone_GetObjectiveIDFromWaypoint( entity waypoint )
{
	return waypoint.GetWaypointInt( CAPTURE_OBJ_WAYPOINT_INT_IDX_OBJ_INDEX )
}





















































































































































































      