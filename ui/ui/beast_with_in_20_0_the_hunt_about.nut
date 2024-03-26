
global function BeastWithIn_20_0_The_Hunt_PopulateAboutText

string function GetPlaylist() 
{
	if ( IsLobby() )
		return LobbyPlaylist_GetSelectedPlaylist()
	else
		return GetCurrentPlaylistName()

	unreachable
}

array< featureTutorialTab > function BeastWithIn_20_0_The_Hunt_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = 	"#HUNT_20_0_TAB_NAME"

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HUNT_ABOUT_OVERVIEW_1_HEADER", "#HUNT_ABOUT_OVERVIEW_1_BODY", $"rui/hud/gametype_icons/ltm/about_hunt_1" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HUNT_ABOUT_OVERVIEW_2_HEADER", "#HUNT_ABOUT_OVERVIEW_2_BODY", $"rui/hud/gametype_icons/ltm/about_hunt_2" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HUNT_ABOUT_OVERVIEW_3_HEADER", "#HUNT_ABOUT_OVERVIEW_3_BODY", $"rui/hud/gametype_icons/ltm/about_hunt_3" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	return tabs
}


