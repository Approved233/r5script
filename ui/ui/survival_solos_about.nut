

global function Survival_Solos_PopulateAboutText


array< featureTutorialTab > function Survival_Solos_PopulateAboutText()
{
	array< featureTutorialTab > tabs

	string playlistUiRules = GetPlaylist_UIRules()
	if ( playlistUiRules != GAMEMODE_SURVIVAL_SOLOS )
		return tabs

	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = 	"#SURVIVAL_MODE_SOLOS_TAB_NAME"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_SOLOS_HEADER_1", "#SURVIVAL_MODE_SOLOS_BODY_1", $"rui/hud/gametype_icons/ltm/survival_solos/about_survival_solos_1" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_SOLOS_HEADER_2", "#SURVIVAL_MODE_SOLOS_BODY_2", $"rui/hud/gametype_icons/ltm/survival_solos/about_survival_solos_2" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#SURVIVAL_MODE_SOLOS_HEADER_3", "#SURVIVAL_MODE_SOLOS_BODY_3", $"rui/hud/gametype_icons/ltm/survival_solos/about_survival_solos_3" ) )
	tab1.rules = tab1Rules
	tabs.append( tab1 )

	GameMode_AboutDialog_AppendRequeueTab(tabs)

	return tabs
}


      