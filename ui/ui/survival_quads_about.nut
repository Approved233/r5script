

global function Survival_Quads_PopulateAboutText


array< featureTutorialTab > function Survival_Quads_PopulateAboutText()
{
	array< featureTutorialTab > tabs

	string playlistUiRules = GetCurrentPlaylist_UIRules()
	if ( playlistUiRules != GAMEMODE_SURVIVAL_QUADS )
		return tabs

	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = 	"#GAMEMODE_RULES_OVERVIEW_TAB_NAME"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_QUADS_HEADER_1", "#SURVIVAL_MODE_QUADS_BODY_1", $"rui/hud/gametype_icons/ltm/about_survival_quads1" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_QUADS_HEADER_2", "#SURVIVAL_MODE_QUADS_BODY_2", $"rui/hud/gametype_icons/ltm/about_survival_quads2" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_QUADS_HEADER_3", "#SURVIVAL_MODE_QUADS_BODY_3", $"rui/hud/gametype_icons/ltm/about_survival_quads3" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	GameMode_AboutDialog_AppendRequeueTab(tabs)

		GameMode_AboutDialog_AppendFreeSpawnsTab(tabs)


	return tabs
}


      