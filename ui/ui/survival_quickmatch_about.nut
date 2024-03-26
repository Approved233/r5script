
global function Survival_Quickmatch_PopulateAboutText

string function GetPlaylist()
{
	if ( IsLobby() )
		return LobbyPlaylist_GetSelectedPlaylist()
	else
		return GetCurrentPlaylistName()

	unreachable
}

array< featureTutorialTab > function Survival_Quickmatch_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules
	featureTutorialTab tab2
	array< featureTutorialData > tab2Rules

	
	tab1.tabName = 	"#BATTLE_RUSH_TITLE"

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_1_HEADER", "#BATTLE_RUSH_1_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_high_speed" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_2_HEADER", "#BATTLE_RUSH_2_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_grab_go" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_3_HEADER", "#BATTLE_RUSH_3_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_droppin" ) )
	tab1.rules = tab1Rules
	tabs.append( tab1 )

	if ( GetPlaylistVarBool( GetPlaylist(), "matchmake_from_match", false ) )
	{
		
		tab2.tabName = "#BATTLE_RUSH_REQUEUE_TITLE"

		tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_4_HEADER", "#BATTLE_RUSH_4_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_no_dull_moment" ) )

		if ( GetConVarBool( "matchSquadRequeue_enabled" ) )
			tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_5_HEADER", "#BATTLE_RUSH_5_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_band_together" ) )

		tab2Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BATTLE_RUSH_6_HEADER", "#BATTLE_RUSH_6_BODY", $"rui/hud/gametype_icons/ltm/about_quickmatch_lobby_friends" ) )
		tab2.rules = tab2Rules
		tabs.append( tab2 )
	}

	return tabs
}


