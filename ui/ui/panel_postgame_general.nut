global function InitPostGameGeneralPanel

global function InitXPEarnedDisplay
global function PostGameGeneral_CanNavigateBack
global function PostGameGeneral_SetDisableNavigateBack
global function PostGameGeneral_SetSkippableWait

const PROGRESS_BAR_FILL_TIME = 2.0
const REWARD_AWARD_TIME = 2
const int MAX_XP_LINES = 7
const float CHALLENGE_FILL_DURATION = 1.5
const float CHALLENGE_POST_FILL_DELAY = 0.75
const string POSTGAME_LINE_ITEM = "ui_menu_matchsummary_xpbreakdown"

struct RewardStruct
{
	float delay
	asset image1
	asset image2
	bool  characterReward
}

struct PinnedXPAndStarsProgressBar
{
	var         rui
	ItemFlavor& progressBarFlavor
	int         tierStart
	int         startingPoints
	int         pointsToAddTotal
	int         challengesCompleted
	int         battlePassLevelsEarned
	int         challengeStarsAndXpEarned
	int         currentPassLevel
}

global table<string, array< array< int > > > xpDisplayGroups = {
	survival = [
		[
			eXPType.WIN_MATCH,
			eXPType.TOP_FIVE,
			eXPType.SURVIVAL_DURATION,
			eXPType.KILL,
			eXPType.DAMAGE_DEALT,
			eXPType.REVIVE_ALLY,
			eXPType.RESPAWN_ALLY,
		],

		[
			eXPType.BONUS_FIRST_GAME,
			eXPType.BONUS_FIRST_KILL,
			eXPType.KILL_CHAMPION_MEMBER,
			eXPType.KILL_LEADER,
			eXPType.BONUS_CHAMPION,
			eXPType.BONUS_FRIEND,
			eXPType.BONUS_FIRST_TOP_FIVE,
		],

		[
			eXPType.TOTAL_MATCH,
			eXPType.CHALLENGE_COMPLETED,
		],
	],

























		control = [
		[
			eXPType.MATCH_COMPLETED,
			eXPType.MATCH_COMPLETED_JOINED_IN_PROGRESS,
			eXPType.WIN_MATCH,
			eXPType.SURVIVAL_DURATION,
			eXPType.OBJECTIVE_CAPTURE_DURATION,
			eXPType.KILL,
		],

		[
			eXPType.RATINGS_LEADER,
			eXPType.BONUS_FRIEND,
			eXPType.BONUS_OBJECTIVES_COMPLETED,
		],

		[
			eXPType.TOTAL_MATCH,
			eXPType.CHALLENGE_COMPLETED,
		],
	],



		freedm = [
		[
			eXPType.MATCH_COMPLETED,
			eXPType.MATCH_COMPLETED_JOINED_IN_PROGRESS,
			eXPType.WIN_MATCH,
			eXPType.SURVIVAL_DURATION,
			eXPType.KILL,
			eXPType.DAMAGE_DEALT,
			eXPType.OBJECTIVE_CAPTURE_DURATION, 
		],

		[
			eXPType.BONUS_FRIEND,
			eXPType.BONUS_FIRST_KILL,
			eXPType.BONUS_FINAL_KILL, 
		],

		[
			eXPType.TOTAL_MATCH,
			eXPType.CHALLENGE_COMPLETED,
		],
	],



		survival_solos = [
			[
				eXPType.WIN_MATCH,
				eXPType.TOP_FIVE,
				eXPType.SURVIVAL_DURATION,
				eXPType.KILL,
				eXPType.DAMAGE_DEALT,
				
				
			],

			[
				eXPType.BONUS_FIRST_GAME,
				eXPType.BONUS_FIRST_KILL,
				eXPType.KILL_CHAMPION_MEMBER,
				eXPType.KILL_LEADER,
				eXPType.BONUS_CHAMPION,
				eXPType.BONUS_FIRST_TOP_FIVE,
			],

			[
				eXPType.TOTAL_MATCH,
				eXPType.CHALLENGE_COMPLETED,
			],
		],

}

struct
{
	var panel

	var continueButton

	var combinedCard

	bool wasPartyMember = false 
	bool disableNavigateBack = false

	bool skippableWaitSkipped = false

	int xpChallengeTier = -1
	int xpChallengeValue = -1
} file

void function InitPostGameGeneralPanel( var panel )
{
	file.panel = panel

	file.combinedCard = Hud_GetChild( panel, "CombinedCard" )


	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnPostGameGeneralPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnPostGameGeneralPanel_Hide )
}

void function OnPostGameGeneralPanel_Show( var panel )
{
	file.wasPartyMember = AmIPartyMember()

	bool isFirstTime = GetPersistentVarAsInt( "showGameSummary" ) != 0

	thread DisplayPostGameSummary( isFirstTime )
}

void function OnPostGameGeneralPanel_Hide( var panel )
{
	Signal( uiGlobal.signalDummy, "PGDisplay" )
}

int function InitXPEarnedDisplay( var xpEarnedRui, array<int> xpTypes, string headerText, string subHeaderText, bool isBattlePass, vector sectionColor )
{
	entity player = GetLocalClientPlayer()

	RuiSetGameTime( xpEarnedRui, "startTime", ClientTime() )
	RuiSetString( xpEarnedRui, "headerText", headerText )
	RuiSetString( xpEarnedRui, "subHeaderText", subHeaderText )

	RuiSetColorAlpha( xpEarnedRui, "sectionColor", sectionColor, 1.0 )

	int lineIndex = 0
	foreach ( index, xpType in xpTypes )
	{
		int eventValue = isBattlePass ? 1 : GetXPEventValue( player, xpType )
		if ( XpEventTypeData_DisplayEmpty( xpType ) || eventValue > 0 )
		{
			lineIndex++
			if ( lineIndex <= MAX_XP_LINES )
			{
				RuiSetString( xpEarnedRui, "line" + lineIndex + "KeyString", GetXPEventNameDisplay( player, xpType ) )

				string valueDisplay = isBattlePass ? "0" : GetXPEventValueDisplay( player, xpType )
				RuiSetString( xpEarnedRui, "line" + lineIndex + "ValueString", valueDisplay )
				vector lineColor = (xpType == eXPType.TOTAL_MATCH) ? <1.0, 1.0, 1.0> : sectionColor
				RuiSetColorAlpha( xpEarnedRui, "line" + lineIndex + "Color", lineColor, 1.0 )
			}
		}
	}

	int numDisplayedLines = lineIndex

	RuiSetInt( xpEarnedRui, "numLines", lineIndex )

	for ( lineIndex++ ; lineIndex <= MAX_XP_LINES; lineIndex++ )
	{
		RuiSetString( xpEarnedRui, "line" + lineIndex + "KeyString", "" )
		RuiSetString( xpEarnedRui, "line" + lineIndex + "ValueString", "" )
	}

	return numDisplayedLines
}


void function ResetSkippableWait()
{
	file.skippableWaitSkipped = false
}


bool function IsSkippableWaitSkipped()
{
	return file.skippableWaitSkipped || !file.disableNavigateBack
}


bool function SkippableWait( float waitTime, string uiSound = "" )
{
	if ( IsSkippableWaitSkipped() )
		return false

	if ( uiSound != "" )
		EmitUISound( uiSound )

	float startTime = UITime()
	while ( UITime() - startTime < waitTime )
	{
		if ( IsSkippableWaitSkipped() )
			return false

		WaitFrame()
	}

	return true
}

void function UpdatePostGameSummaryDisplayData()
{
	UpdateXPEvents()
}

var function DisplayPostGameSummary( bool isFirstTime )
{

		PostGame_EnableWeaponsTab( false )

	EndSignal( uiGlobal.signalDummy, "PGDisplay" )

	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned1" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned2" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned3" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPProgressBarBattlePass" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPProgressBarAccount" ), false )
	PostGame_ToggleVisibilityContinueButton( false )

	bool showRankedSummary = Ranked_GetXProgMergedPersistenceData( GetLocalClientPlayer(), RANKED_SHOW_RANKED_SUMMARY_PERSISTENCE_VAR_NAME ) != 0
	string postMatchSurveyMatchId = string( GetPersistentVar( "postMatchSurveyMatchId" ) )
	float postMatchSurveySampleRateLowerBound = expect float( GetPersistentVar( "postMatchSurveySampleRateLowerBound" ) )
	if ( GetActiveBattlePass() == null && !showRankedSummary && isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME, postMatchSurveyMatchId, postMatchSurveySampleRateLowerBound ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
			WaitFrame()
	}

	WaitEndFrame()

	while ( !IsFullyConnected() )
	{
		WaitFrame()
	}

	entity player = GetLocalClientPlayer()
	if ( !player )
		return

	string lastGameMode = expect string( GetPersistentVar( "lastGameMode" ) )
	string lastGameUIRules = expect string( GetPersistentVar( "lastGameUIRules" ) )

	if ( lastGameUIRules in xpDisplayGroups )
	{
		lastGameMode = lastGameUIRules
	}
	else if (!( lastGameMode in xpDisplayGroups ))
	{
		lastGameMode = SURVIVAL
	}

	EmitUISound( "UI_Menu_MatchSummary_Appear" )
	UpdatePostGameSummaryDisplayData()

	PostGame_ToggleVisibilityContinueButton( isFirstTime )
	Hud_SetVisible( file.combinedCard, true ) 

	file.disableNavigateBack = isFirstTime
	ResetSkippableWait()
	OnThreadEnd(
		function() : ()
		{
			file.disableNavigateBack = false
			UpdateFooterOptions()
		}
	)

	
	int characterGUID = GetPersistentVarAsInt( "lastGameCharacter" )
	ItemFlavor ornull character
	if ( !IsValidItemFlavorGUID( characterGUID ) )
	{
		Warning( "Cannot display post-game summary banner because character \"" + string(characterGUID) + "\" is not registered right now." ) 
		character = null
	}
	else
	{
		character = GetItemFlavorByGUID( characterGUID )
		expect ItemFlavor( character )

		RunMenuClientFunction( "UpdateMenuCharacterModel", ItemFlavor_GetGUID( character ) )

		SetupMenuGladCard( file.combinedCard, "card", true )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.CHARACTER, 0, character )

		
		Ranked_SetupMenuGladCardForUIPlayer()

			ArenasRanked_SetupMenuGladCardForUIPlayer()

	}

	
	int previousAccountXP = GetPersistentVarAsInt( "previousXP" )
	int currentAccountXP  = GetPersistentVarAsInt( "xp" )
	int totalXP           = currentAccountXP - previousAccountXP

	


	
	
	
	string lastPlaylist = string( GetPersistentVar( "lastPlaylist" ) )
	bool visible = GetPlaylistVarBool( lastPlaylist, "visible", false )
	bool optInOnly = GetPlaylistVarBool( lastPlaylist, "opt_in_only", false )
	string playlistName = visible && !optInOnly ? GetPlaylistVarString( lastPlaylist, "name", "" ) : ""

	
	
	

	const vector COLOR_MATCH = <255, 255, 255> / 255.0
	const vector COLOR_BONUS = <142, 250, 255> / 255.0
	
	vector COLOR_BP_PREMIUM               = SrgbToLinear( <255, 90, 40> / 255.0 )
	vector COLOR_BP_PINNED_CHALLENGE      = SrgbToLinear( <255, 215, 55> / 255.0 )
	vector COLOR_BP_PINNED_CHALLENGE_TEXT = SrgbToLinear( <254, 227, 113> / 255.0 )

	const float LINE_DISPLAY_TIME = 0.25

	float baseDelay = isFirstTime ? 1.0 : 0.0

	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned1" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned2" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned3" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPProgressBarBattlePass" ), false )
	Hud_SetVisible( Hud_GetChild( file.panel, "XPProgressBarAccount" ), false )
	PostGame_ToggleVisibilityContinueButton( false )

	while ( !Hud_IsVisible( file.panel ) )
		WaitFrame()

	if ( character != null && isFirstTime )
	{
		expect ItemFlavor( character )
		table<ItemFlavor, GladCardBadgeTierData> unlockedBadgeMap

		table<int, int> grxPostGameRewardGUIDToPersistenceIdx = GRX_GetPostGameRewards()
		foreach ( int guid, int _ in grxPostGameRewardGUIDToPersistenceIdx )
		{
			if ( !IsValidItemFlavorGUID( guid ) )
				continue

			ItemFlavor item = GetItemFlavorByGUID( guid )
			if ( ItemFlavor_GetType( item ) != eItemType.gladiator_card_badge )
				continue

			unlockedBadgeMap[ item ] <- GladiatorCardBadge_GetTierDataList( item )[0]
			GRX_MarkRewardAcknowledged( guid, grxPostGameRewardGUIDToPersistenceIdx[ guid ] )
		}

		foreach ( BadgeDisplayData displayData in GladiatorCardBadge_GetPostGameStatUnlockBadgesDisplayData() )
			unlockedBadgeMap[ displayData.badge ] <- displayData.tierData

		if ( unlockedBadgeMap.len() > 0 )
		{
			baseDelay = 0.0
			wait 0.5
		}

		const float BADGE_CEREMONY_DURATION = 4.0
		var badgeRui = Hud_GetRui( Hud_GetChild( file.panel, "BadgeEarned" ) )
		foreach ( badge, tierData in unlockedBadgeMap )
		{
			RuiDestroyNestedIfAlive( badgeRui, "badgeHandle" )
			CreateNestedGladiatorCardBadge( badgeRui, "badgeHandle", ToEHI( player ), badge, 0, character )

			RuiSetString( badgeRui, "badgeName", ItemFlavor_GetLongName( badge ) )

			string categoryName = GetBadgeCategoryName( badge )
			string badgeType = GladiatorCardBadge_IsCharacterBadge( badge ) ? Localize( "#CHARACTER_BADGE", Localize( ItemFlavor_GetLongName( character ) ) ) : Localize( "#ACCOUNT_BADGE", categoryName )
			RuiSetString( badgeRui, "badgeType", badgeType )

			array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badge )
			float unlockRequirement                   = tierData.unlocksAt
			if ( tierDataList.len() > 1 )
				RuiSetString( badgeRui, "badgeDesc", Localize( ItemFlavor_GetShortDescription( badge ), format( "`2%s`0", string(unlockRequirement) ) ) )
			else
				RuiSetString( badgeRui, "badgeDesc", ItemFlavor_GetShortDescription( badge ) )

			RuiSetGameTime( badgeRui, "displayStartTime", ClientTime() )
			RuiSetFloat( badgeRui, "displayDuration", BADGE_CEREMONY_DURATION )

			EmitUISound( "UI_Menu_Badge_Earned" )

			Hud_SetVisible( Hud_GetChild( file.panel, "BadgeEarned" ), true )

			ResetSkippableWait()
			SkippableWait( BADGE_CEREMONY_DURATION )

			StopUISound( "UI_Menu_Badge_Earned" )
		}

		Hud_SetVisible( Hud_GetChild( file.panel, "BadgeEarned" ), false )
		wait 0.25
	}

	{
		var xpEarned1Rui = Hud_GetRui( Hud_GetChild( file.panel, "XPEarned1" ) )
		var xpEarned2Rui = Hud_GetRui( Hud_GetChild( file.panel, "XPEarned2" ) )

		Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned1" ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "XPEarned2" ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "XPProgressBarAccount" ), true )
		PostGame_ToggleVisibilityContinueButton( true )

		RuiSetFloat( xpEarned1Rui, "startDelay", baseDelay )
		int numLines = InitXPEarnedDisplay( xpEarned1Rui, xpDisplayGroups[ lastGameMode ][0], "#EOG_MATCH_XP", "", false, COLOR_MATCH )
		RuiSetFloat( xpEarned1Rui, "lineDisplayTime", LINE_DISPLAY_TIME )

		RuiSetFloat( xpEarned2Rui, "startDelay", baseDelay + (numLines * LINE_DISPLAY_TIME) )
		numLines += InitXPEarnedDisplay( xpEarned2Rui, xpDisplayGroups[ lastGameMode ][1], "", "", false, COLOR_BONUS )
		RuiSetFloat( xpEarned2Rui, "lineDisplayTime", LINE_DISPLAY_TIME )

		
		
		

		
		int start_accountLevel = GetAccountLevelForXP( previousAccountXP )
		Assert( start_accountLevel >= 0 )
		int start_accountXP          = GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 )
		int start_nextAccountLevelXP = GetTotalXPToCompleteAccountLevel( start_accountLevel )
		Assert( previousAccountXP >= start_accountXP )
		Assert( previousAccountXP < start_nextAccountLevelXP )

		float start_accountLevelFrac = GraphCapped( previousAccountXP, start_accountXP, start_nextAccountLevelXP, 0.0, 1.0 )

		
		int ending_accountLevel       = GetAccountLevelForXP( currentAccountXP )
		int ending_accountXP          = GetTotalXPToCompleteAccountLevel( ending_accountLevel - 1 )
		int ending_nextAccountLevelXP = GetTotalXPToCompleteAccountLevel( ending_accountLevel )
		Assert( currentAccountXP >= ending_accountXP )
		Assert( currentAccountXP < ending_nextAccountLevelXP )
		float ending_accountLevelFrac = GraphCapped( currentAccountXP, ending_accountXP, ending_nextAccountLevelXP, 0.0, 1.0 )

		
		var accountProgressRUI = Hud_GetRui( Hud_GetChild( file.panel, "XPProgressBarAccount" ) )
		RuiSetString( accountProgressRUI, "displayName", GetPlayerName() )
		RuiSetColorAlpha( accountProgressRUI, "oldProgressColor", <196 / 255.0, 151 / 255.0, 41 / 255.0>, 1 )
		RuiSetColorAlpha( accountProgressRUI, "newProgressColor", <255 / 255.0, 182 / 255.0, 0 / 255.0>, 1 )
		RuiSetString( accountProgressRUI, "totalEarnedXPText", FormatAndLocalizeNumber( "1", float( totalXP ), IsTenThousandOrMore( totalXP ) ) )
		RuiSetBool( accountProgressRUI, "largeFormat", true )
		RuiSetInt( accountProgressRUI, "startLevel", start_accountLevel )
		RuiSetFloat( accountProgressRUI, "startLevelFrac", start_accountLevelFrac )
		RuiSetInt( accountProgressRUI, "endLevel", start_accountLevel )
		RuiSetFloat( accountProgressRUI, "endLevelFrac", 1.0 )
		RuiSetGameTime( accountProgressRUI, "startTime", RUI_BADGAMETIME )
		RuiSetFloat( accountProgressRUI, "startDelay", 0.0 )
		RuiSetString( accountProgressRUI, "headerText", "#EOG_XP_HEADER_MATCH" )
		RuiSetFloat( accountProgressRUI, "progressBarFillTime", PROGRESS_BAR_FILL_TIME )
		RuiSetInt( accountProgressRUI, format( "displayLevel1XP", start_accountLevel + 1 ), GetTotalXPToCompleteAccountLevel( start_accountLevel ) - GetTotalXPToCompleteAccountLevel( start_accountLevel - 1 ) )

		
		

		
		

		var currentBadgeHandle = CreateNestedAccountDisplayBadge( accountProgressRUI, "currentBadgeHandle", start_accountLevel )
		var nextBadgeHandle = CreateNestedAccountDisplayBadge( accountProgressRUI, "nextBadgeHandle", start_accountLevel + 1 )

		array<RewardData> accountRewardArray = GetRewardsForAccountLevel( start_accountLevel )
		RuiSetImage( accountProgressRUI, "rewardImage1", accountRewardArray.len() >= 1 ? GetImageForReward( accountRewardArray[0] ) : $"" )
		RuiSetImage( accountProgressRUI, "rewardImage2", accountRewardArray.len() >= 2 ? GetImageForReward( accountRewardArray[1] ) : $"" )
		RuiSetString( accountProgressRUI, "reward1Value", accountRewardArray.len() >= 1 ? GetStringForReward( accountRewardArray[0] ) : "" )
		RuiSetString( accountProgressRUI, "reward2Value", accountRewardArray.len() >= 2 ? GetStringForReward( accountRewardArray[1] ) : "" )

		ResetSkippableWait()
		SkippableWait( baseDelay )

		for ( int lineIndex = 0; lineIndex < numLines; lineIndex++ )
		{
			if ( IsSkippableWaitSkipped() )
				continue

			SkippableWait( LINE_DISPLAY_TIME, POSTGAME_LINE_ITEM )
		}

		RuiSetFloat( xpEarned1Rui, "startDelay", -50.0 )
		RuiSetGameTime( xpEarned1Rui, "startTime", ClientTime() - 50.0 )
		RuiSetFloat( xpEarned2Rui, "startDelay", -50.0 )
		RuiSetGameTime( xpEarned2Rui, "startTime", ClientTime() - 50.0 )

		int accountLevelsToPopulate = minint( (ending_accountLevel - start_accountLevel) + 1, 5 )
		for ( int index = 0; index < accountLevelsToPopulate; index++ )
		{
			int currentLevel = start_accountLevel + index
			int xpForLevel   = GetTotalXPToCompleteAccountLevel( currentLevel ) - GetTotalXPToCompleteAccountLevel( currentLevel - 1 )
			RuiSetInt( accountProgressRUI, format( "displayLevel1XP", index + 1 ), xpForLevel )

			int startLevel    = currentLevel
			int endLevel      = currentLevel
			float startXPFrac = index == 0 ? start_accountLevelFrac : 0.0
			float endXPFrac   = currentLevel == ending_accountLevel ? ending_accountLevelFrac : 1.0
			float startDelay  = index == 0 ? 0.0 : 0.5

			RuiSetInt( accountProgressRUI, "startLevel", startLevel )
			RuiSetFloat( accountProgressRUI, "startLevelFrac", startXPFrac )
			RuiSetInt( accountProgressRUI, "endLevel", endLevel )
			RuiSetFloat( accountProgressRUI, "endLevelFrac", endXPFrac )
			RuiSetGameTime( accountProgressRUI, "startTime", RUI_BADGAMETIME )
			RuiSetFloat( accountProgressRUI, "progressBarFillTime", PROGRESS_BAR_FILL_TIME )
			RuiSetFloat( accountProgressRUI, "startDelay", startDelay )
			RuiSetString( accountProgressRUI, "headerText", "#EOG_XP_HEADER_MATCH" )

			RuiSetInt( currentBadgeHandle, "tier", startLevel )
			RuiSetInt( nextBadgeHandle, "tier", startLevel + 1 )

			
			

			
			

			array<RewardData> rewardsArray = GetRewardsForAccountLevel( startLevel )
			RuiSetImage( accountProgressRUI, "rewardImage1", rewardsArray.len() >= 1 ? GetImageForReward( rewardsArray[0] ) : $"" )
			RuiSetImage( accountProgressRUI, "rewardImage2", rewardsArray.len() >= 2 ? GetImageForReward( rewardsArray[1] ) : $"" )
			RuiSetString( accountProgressRUI, "reward1Value", rewardsArray.len() >= 1 ? GetStringForReward( rewardsArray[0] ) : "" )
			RuiSetString( accountProgressRUI, "reward2Value", rewardsArray.len() >= 2 ? GetStringForReward( rewardsArray[1] ) : "" )

			float waitTime = startDelay + (PROGRESS_BAR_FILL_TIME * (endXPFrac - startXPFrac))

			RuiSetGameTime( accountProgressRUI, "startTime", ClientTime() )
			
			SkippableWait( waitTime, "UI_Menu_MatchSummary_XPBar" )
			StopUISoundByName( "UI_Menu_MatchSummary_XPBar" )
			RuiSetGameTime( accountProgressRUI, "startTime", -50.0 )
			RuiSetFloat( accountProgressRUI, "progressBarFillTime", 0.0 )
			RuiSetFloat( accountProgressRUI, "startDelay", 0.0 )

			if ( currentLevel < ending_accountLevel && isFirstTime )
			{
				var rewardDisplayRui = Hud_GetRui( Hud_GetChild( file.panel, "RewardDisplay" ) )
				RuiSetAsset( rewardDisplayRui, "rewardImage1", rewardsArray.len() >= 1 ? GetImageForReward( rewardsArray[0] ) : $"" )
				RuiSetAsset( rewardDisplayRui, "rewardImage2", rewardsArray.len() >= 2 ? GetImageForReward( rewardsArray[1] ) : $"" )
				RuiSetString( rewardDisplayRui, "reward1Value", rewardsArray.len() >= 1 ? GetStringForReward( rewardsArray[0] ) : "" )
				RuiSetString( rewardDisplayRui, "reward2Value", rewardsArray.len() >= 2 ? GetStringForReward( rewardsArray[1] ) : "" )

				RuiSetString( rewardDisplayRui, "headerText", "#EOG_LEVEL_UP_HEADER" )
				RuiSetString( rewardDisplayRui, "rewardHeaderText", rewardsArray.len() > 1 ? "#EOG_REWARDS_LABEL" : "#EOG_REWARD_LABEL" )
				

				

				var accountBadge = CreateNestedAccountDisplayBadge( rewardDisplayRui, "accountBadgeHandle", (startLevel + 1) )

				EmitUISound( "ui_menu_matchsummary_levelup" )

				RuiSetFloat( rewardDisplayRui, "rewardsDuration", REWARD_AWARD_TIME )

				RuiSetGameTime( rewardDisplayRui, "rewardsStartTime", ClientTime() )
				RuiSetFloat( rewardDisplayRui, "rewardsDuration", REWARD_AWARD_TIME )

				wait REWARD_AWARD_TIME - 0.5
			}
		}

		SkippableWait( baseDelay )
	}

	Remote_ServerCallFunction( "ClientCallback_ViewedGameSummary" )

		PostGame_EnableWeaponsTab( true )

}

float function CalculateAccountLevelingUpDuration( int start_accountLevel, int ending_accountLevel, float start_accountLevelFrac, float ending_accountLevelFrac )
{
	float totalDelay

	int displayLevel = start_accountLevel
	while( displayLevel < ending_accountLevel + 1 )
	{
		float startFrac  = (displayLevel == start_accountLevel) ? start_accountLevelFrac : 0.0
		float endFrac    = (displayLevel == ending_accountLevel) ? ending_accountLevelFrac : 1.0
		float timeToFill = (endFrac - startFrac) * PROGRESS_BAR_FILL_TIME

		totalDelay += timeToFill
		displayLevel++
	}

	return totalDelay
}

void function PostGameGeneral_SetDisableNavigateBack( bool disableNavigateBack )
{
	file.disableNavigateBack = disableNavigateBack
}

bool function PostGameGeneral_CanNavigateBack()
{
	return file.disableNavigateBack != true
}

void function PostGameGeneral_SetSkippableWait( bool skippableWaitSkipped = false)
{
	file.skippableWaitSkipped = skippableWaitSkipped
}

bool function PartyStatusUnchangedDuringPostGameMenu()
{
	return file.wasPartyMember == AmIPartyMember()
}