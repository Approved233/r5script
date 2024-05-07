
global function Survival_Quickmatch_PopulateAboutText

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

	GameMode_AboutDialog_AppendRequeueTab(tabs)

	return tabs
}


