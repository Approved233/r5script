
global function BotPlayground_PopulateAboutText


array< featureTutorialTab > function BotPlayground_PopulateAboutText()
{
	array< featureTutorialTab > tabs
	featureTutorialTab tab1
	featureTutorialTab tab2
	array< featureTutorialData > tab1Rules

	
	tab1.tabName = 	"#BOTPLAYGROUND_FEATURES_TABNAME"

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BOTPLAYGROUND_BOT_ROYALE_HEADER", 	"#BOTPLAYGROUND_BOT_ROYALE_BODY", 		$"rui/hud/gametype_icons/bot_playground/about_bot_playground_bot_royale" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BOTPLAYGROUND_PRACTICE_HEADER", 		"#BOTPLAYGROUND_PRACTICE_BODY", 		$"rui/hud/gametype_icons/bot_playground/about_bot_playground_practice" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#BOTPLAYGROUND_FRIENDS_HEADER", 	"#BOTPLAYGROUND_FRIENDS_BODY", 	$"rui/hud/gametype_icons/bot_playground/about_bot_playground_friends" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	return tabs
}


