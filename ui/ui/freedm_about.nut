
global function FreeDM_PopulateAboutText

global function TreasureHunt_PopulateAboutText



global function AprilFools_S20_LTM_PopulateAboutText
global function AprilFools_S20_BR_PopulateAboutText


string function GetPlaylist()
{
	if ( IsLobby() )
		return LobbyPlaylist_GetSelectedPlaylist()
	else
		return GetCurrentPlaylistName()

	unreachable
}

array< featureTutorialTab > function FreeDM_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	string playlistUiRules = GetPlaylist_UIRules()
	if ( playlistUiRules != GAMEMODE_FREEDM )
		return tabs

	if( GetPlaylistVarBool( GetPlaylist(), "freedm_gun_game_active", false ) )
		return GunGame_PopulateAboutText()

	return tabs
}

array< featureTutorialTab > function GunGame_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = "#GAMEMODE_RULES_OVERVIEW_TAB_NAME"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#GUNGAME_RULES_WEAPON_HEADER", "#GUNGAME_RULES_WEAPON_BODY", $"rui/hud/gametype_icons/freedm/about_gungame_weapon" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#GUNGAME_RULES_SQUAD_HEADER", "#GUNGAME_RULES_SQUAD_BODY", $"rui/hud/gametype_icons/freedm/about_gungame_squad" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#GUNGAME_RULES_KNIFE_HEADER", "#GUNGAME_RULES_KNIFE_BODY", $"rui/hud/gametype_icons/freedm/about_gungame_knife" ) )
	tab1.rules = tab1Rules
	tabs.append( tab1 )


		AprilFools_S20_LTM_PopulateAboutText( tabs, "#APRILFOOLS_S20_ABOUT_TAB", "#APRILFOOLS_S20_ABOUT_GUNRUN_HEADER", "#APRILFOOLS_S20_ABOUT_GUNRUN_BODY" )


	return tabs
}

array< featureTutorialTab > function TreasureHunt_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1

	array< featureTutorialData > tab1Rules
	string currentPlaylist = GetPlaylist()

	
	tab1.tabName = 	"#GAMEMODE_RULES_OVERVIEW_TAB_NAME"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#FREEDM_LOCKDOWN_RULES_ABOUT_HEADER", "#FREEDM_LOCKDOWN_RULES_ABOUT_BODY", $"rui/hud/gametype_icons/ltm/treasure_hunt/about_treasurehunt_1" ) )

	table< string, string> scoringTableData = {}
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_1"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_obj_capturestart_score_amnt", 0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_2"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS_PER_SEC", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_obj_capturing_score_amnt", 0 ) ), string( GetPlaylistVarFloat( currentPlaylist, "treasure_hunt_capturing_score_interval", 0.0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_3"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_obj_captured_score_amnt", 0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_4"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_suddendeath_obj_captured_score_amnt", 0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_5"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_kill_score_amnt", 0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_6"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_kill_from_zone_score_amnt", 0 ) ) )
	scoringTableData["#FREEDM_LOCKDOWN_RULES_ITEM_7"] <- Localize( "#FREEDM_LOCKDOWN_RULES_POINTS", string( GetPlaylistVarInt( currentPlaylist, "treasure_hunt_kill_winner_score_amnt", 0 ) ) )

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#FREEDM_LOCKDOWN_RULES_STAKE_HEADER", "#FREEDM_LOCKDOWN_RULES_STAKE_BODY", $"rui/hud/gametype_icons/ltm/treasure_hunt/about_treasurehunt_2", [], scoringTableData ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#FREEDM_LOCKDOWN_RULES_REAP_HEADER", "#FREEDM_LOCKDOWN_RULES_REAP_BODY", $"rui/hud/gametype_icons/ltm/treasure_hunt/about_treasurehunt_3" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	return tabs
}



array< featureTutorialTab > function AprilFools_S20_BR_PopulateAboutText()
{
	array< featureTutorialTab > tabs

	AprilFools_S20_LTM_PopulateAboutText( tabs, "#APRILFOOLS_S20_ABOUT_TAB", "#APRILFOOLS_S20_ABOUT_TRIOS_HEADER", "#APRILFOOLS_S20_ABOUT_TRIOS_BODY" )

	return tabs
}

bool function AprilFools_S20_LTM_PopulateAboutText( array< featureTutorialTab > tabs, string tabName, string header, string body )
{
	if ( GetPlaylistVarBool( GetPlaylist(), "is_april_fools_s20", false ) && GetPlaylistVarBool( GetPlaylist(), "is_limited_mode", false ) )
	{
		featureTutorialTab tab2
		array< featureTutorialData > tab2Rules

		tab2.tabName = tabName

		tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( header, body, $"" ) )
		tab2.rules = tab2Rules
		tabs.append( tab2 )

		return true
	}

	return false
}



