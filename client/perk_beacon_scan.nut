global function Perk_BeaconScan_Init


global function SurveyBeacon_GetBeaconIcon
global function SurveyBeacon_IsSurveyBeacon
global function PlayerShouldSeeSurveyBeaconMarkers
global function SurveyBeacon_CanUseFunction
global function SurveyBeacon_CanActivate
global function HasCryptoSword
global function HasSeerBlades
global function RegisterSurveyBeaconData
global function OnDeactivate_BeaconScan


















global function SurveyBeacon_CreateHUDMarker
global function SurveyBeacon_AddSurveyBeaconMinimapPackage
global function OnSurveyBeaconCreated





global struct SurveyBeaconData
{
	bool functionref( entity, entity  ) canUseFunc
	string calloutLine
	int scanType





}

global enum eBeaconScanType
{
	DEFAULT,
	BEACON_SCAN_CIRCLE,
	BEACON_SCAN_ENEMY,



	BEACON_SCAN_DROPPOD,

	_count
}

struct
{

	table< entity, table<int, SurveyBeaconData > > surveyBeaconData











} file

void function Perk_BeaconScan_Init()
{
	Perk_NextZoneBeaconScan_Init()
	Perk_EnemyBeaconScan_Init()


	RegisterSignal( "BeaconIconReset" )






}

float function GetBaseSurveyBeaconExclusionDistance()
{
	return GetCurrentPlaylistVarFloat( "survey_beacon_exclusion_distance", 12000 )
}























asset function SurveyBeacon_GetBeaconIcon( entity beacon )
{







	if( beacon.GetScriptName() == NEXT_ZONE_SURVEY_BEACON_SCRIPTNAME )
		return Perks_GetIconForPerk( ePerkIndex.BEACON_SCAN )
	return Perks_GetIconForPerk( ePerkIndex.BEACON_ENEMY_SCAN )
}

bool function SurveyBeacon_IsSurveyBeacon( entity beacon )
{







	return beacon.GetScriptName() == ENEMY_SURVEY_BEACON_SCRIPTNAME || beacon.GetScriptName() == NEXT_ZONE_SURVEY_BEACON_SCRIPTNAME
}

bool function HasCryptoSword( entity player )
{

	string meleeSkinName




		entity meleeWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
		if ( meleeWeapon != null )
			meleeSkinName = meleeWeapon.GetWeaponClassName()


	if ( meleeSkinName == "mp_weapon_crypto_heirloom_primary" )
		return true

	return false
}

bool function HasSeerBlades( entity player )
{
	string meleeSkinName




		entity meleeWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
		if ( meleeWeapon != null )
			meleeSkinName = meleeWeapon.GetWeaponClassName()


	if ( meleeSkinName == "mp_weapon_seer_heirloom_primary" )
		return true

	return false
}

void function RegisterSurveyBeaconData( entity player, SurveyBeaconData data )
{
	if( !( player in file.surveyBeaconData ) )
	{
		table<int, SurveyBeaconData > emptyTable
		file.surveyBeaconData[player] <- emptyTable
	}
	file.surveyBeaconData[ player ][data.scanType] <- data
}

int function BeaconEntToScanType( entity beacon )
{







	string scriptName = beacon.GetScriptName()
	if( scriptName == NEXT_ZONE_SURVEY_BEACON_SCRIPTNAME )
		return eBeaconScanType.BEACON_SCAN_CIRCLE
	if( scriptName == ENEMY_SURVEY_BEACON_SCRIPTNAME )
		return eBeaconScanType.BEACON_SCAN_ENEMY
	return eBeaconScanType.DEFAULT
}

#if DEV
bool function SurveyBeacon_IgnoreCanUseCheck()
{
	return GetCurrentPlaylistVarBool( "survey_beacon_ignore_can_use_check", false )
}
#endif

bool function SurveyBeacon_CanUseFunction( entity player, entity beacon, int useFlags )
{
	if ( GetGameState() < eGameState.Playing )
		return false

	if ( !ControlPanel_CanUseFunction( player, beacon, useFlags ) )
		return false

	return true
}

bool function SurveyBeacon_CanActivate( entity player, entity beacon )
{
	if ( !PlayerShouldSeeSurveyBeaconMarkers( player, beacon ) )
	{
		return false
	}

	int beaconType = BeaconEntToScanType( beacon )
	table<int, SurveyBeaconData> usableBeacons = file.surveyBeaconData[ player ]


#if DEV
	if( !SurveyBeacon_IgnoreCanUseCheck() )
#endif
	{
		if( beaconType in usableBeacons )
		{
			SurveyBeaconData data = usableBeacons[beaconType]
			if ( data.canUseFunc != null )
			{
				if ( !data.canUseFunc( player, beacon ) )
				{
					return false
				}
			}
		}
	}

	return true
}
















bool function PlayerHasAccessToBeacons( entity player, entity beacon )
{
	if( !( player in file.surveyBeaconData ) )
		return false;
	if( beacon == null )
		return true;
	int beaconType =  BeaconEntToScanType( beacon )
	return beaconType in file.surveyBeaconData[player]
}

bool function PlayerShouldSeeSurveyBeaconMarkers( entity player, entity beacon )
{
	return PlayerHasAccessToBeacons( player, beacon ) || player.GetTeam() == TEAM_SPECTATOR
}

void function OnSurveyBeaconCreated( entity beacon )
{
	if ( !IsValid( beacon ) )
		return

	if ( SurveyBeacon_IsSurveyBeacon( beacon ) )
	{
		CreateCallback_Panel( beacon )
		ClearCallback_CanUseEntityCallback( beacon )
		SetCallback_CanUseEntityCallback( beacon, SurveyBeacon_CanUseFunction )

		string scriptName = beacon.GetScriptName()
		if( scriptName == ENEMY_SURVEY_BEACON_SCRIPTNAME )
		{
			AddAnimEvent( beacon, "PlayEffects_SurveyBeacon_Laser", PlayEffects_SurveyBeacon_Laser)
			Perks_AddMinimapEntityForPerk( ePerkIndex.BEACON_ENEMY_SCAN, beacon )
		}
		else if( scriptName == NEXT_ZONE_SURVEY_BEACON_SCRIPTNAME )
		{
			AddAnimEvent( beacon, "PlayEffects_RingConsole_Pulse", PlayEffects_RingConsole_Pulse )
			Perks_AddMinimapEntityForPerk( ePerkIndex.BEACON_SCAN, beacon )
		}







		AddEntityCallback_GetUseEntOverrideText( beacon, GetSurveyBeaconHoldUseTextOverride )

		thread SurveyBeacon_UpdateWorldspaceIconVisibility( beacon )
	}
}

string function GetSurveyBeaconHoldUseTextOverride( entity ent )
{
	string text = Localize( GetBaseHintTextOverride( ent ) )
	if( text == "" )
		return text
	asset icon = SurveyBeacon_GetBeaconIcon( ent )
	return "%$" + icon + "% " + text
}

string function GetBaseHintTextOverride( entity ent )
{
	int beaconType = BeaconEntToScanType( ent )

	entity player = GetLocalViewPlayer()
	if( !PlayerShouldSeeSurveyBeaconMarkers( player, ent ) )
	{
		entity beaconUser = GetTeamSurveyBeaconUser( player.GetTeam() )
		if ( HasActiveSurveyZone( beaconUser ) && IsValid( beaconUser ) )
		{
			bool isCircleScan = beaconType == eBeaconScanType.BEACON_SCAN_CIRCLE



			if ( isCircleScan )
			{
				return "#SURVEY_ALREADY_ACTIVE"
			}
		}
		else
		{
			if( beaconType == eBeaconScanType.BEACON_SCAN_CIRCLE )
				return "#CONTROLLER_SURVEY_TEAM_MESSAGE"




			else
				return "#SURVEY_TEAM_MESSAGE"
		}
	}
	else
	{
		if( beaconType in file.surveyBeaconData[player] )
		{
			SurveyBeaconData data = file.surveyBeaconData[ player ][beaconType]
			if ( data.canUseFunc != null )
			{
				if ( data.canUseFunc( player, ent ) )
				{
					if( beaconType == eBeaconScanType.BEACON_SCAN_CIRCLE )
						return "#RING_CONSOLE_HOLD_PROMPT"
					else
						return "#SURVEY_BEACON_HOLD_PROMPT"
				}
				else
				{
					bool isCircleScan = beaconType == eBeaconScanType.BEACON_SCAN_CIRCLE



					if( isCircleScan )
						return "#SURVEY_ALREADY_ACTIVE"
					else if ( beaconType == eBeaconScanType.BEACON_SCAN_ENEMY )
						return "#SURVEY_ENEMY_ALREADY_ACTIVE"
				}
			}
		}
	}
	return ""
}

void function SurveyBeacon_UpdateWorldspaceIconVisibility( entity beacon )
{
	beacon.EndSignal( "OnDestroy" )

	while( true )
	{
		entity player = expect entity( beacon.WaitSignal( "OnPlayerUse", "OnPlayerUseLong" ).player )
		entity localPlayer = GetLocalViewPlayer()
		if( player != localPlayer )
			continue
		beacon.Signal( "BeaconIconReset" )
		Perks_SetWorldspaceIconVisibility( beacon, false )
		thread SurveyBeacon_ResetWorldSpaceIconVisibilityEndUse( player, beacon )
		thread SurveyBeacon_ResetWorldSpaceIconVisibilityTimer( beacon )
	}
}

void function SurveyBeacon_ResetWorldSpaceIconVisibilityEndUse( entity player, entity beacon )
{
	beacon.EndSignal( "OnDestroy" )
	beacon.EndSignal( "BeaconIconReset" )
	while ( ( player.IsInputCommandHeld( IN_USE ) || player.IsInputCommandHeld( IN_USE_LONG )) && !player.IsPhaseShifted() )
		WaitFrame()
	Perks_SetWorldspaceIconVisibility( beacon, true )
	beacon.Signal( "BeaconIconReset" )
}

void function SurveyBeacon_ResetWorldSpaceIconVisibilityTimer( entity beacon )
{
	beacon.EndSignal( "OnDestroy" )
	beacon.EndSignal( "BeaconIconReset" )
	Wait( 10 )
	Perks_SetWorldspaceIconVisibility( beacon, true )
	beacon.Signal( "BeaconIconReset" )
}

var function SurveyBeacon_CreateHUDMarker( asset beaconImage, entity minimapObj )
{
	entity localViewPlayer = GetLocalViewPlayer()
	vector pos             = minimapObj.GetOrigin() + (minimapObj.GetUpVector() * 96)
	var rui                = CreateFullscreenRui( PERK_IN_WORLD_HUD_OBJECT, RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetImage( rui, "beaconImage", beaconImage )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", pos )
	RuiKeepSortKeyUpdated( rui, true, "pos" )
	return rui
}

entity function GetTeamSurveyBeaconUser( int team )
{
	array<entity> teamArray = GetPlayerArrayOfTeam_AliveConnected( team )
	foreach ( teamMember in teamArray )
	{
		if ( PlayerHasAccessToBeacons( teamMember, null ) )
			return teamMember
	}
	return null
}
































































































































































































































































void function OnDeactivate_BeaconScan( entity player )
{
	if ( !( player in file.surveyBeaconData ) )
		return

	delete file.surveyBeaconData[ player ]
}



void function SurveyBeacon_AddSurveyBeaconMinimapPackage()
{
	
}

