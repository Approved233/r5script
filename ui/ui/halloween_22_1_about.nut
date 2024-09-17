
global function Halloween_22_1_PopulateAboutText


array< featureTutorialTab > function Halloween_22_1_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = 	"#HALLOWEEN_22_1_TAB_NAME"

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HALLOWEEN_22_1_HEADER_1", "#HALLOWEEN_22_1_BODY_1", $"rui/hud/gametype_icons/trick_n_treats/about_halloween_22_copycat_kit" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HALLOWEEN_22_1_HEADER_2", "#HALLOWEEN_22_1_BODY_2", $"rui/hud/gametype_icons/trick_n_treats/about_halloween_22_candy" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#HALLOWEEN_22_1_HEADER_3", "#HALLOWEEN_22_1_BODY_3", $"rui/hud/gametype_icons/trick_n_treats/about_halloween_22_rev_shell" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	GameMode_AboutDialog_AppendRequeueTab(tabs)

		GameMode_AboutDialog_AppendFreeSpawnsTab(tabs)


	return tabs
}


