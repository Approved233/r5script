global function RTKRankedMatchSummary_InitMetaData
global function RTKRankedMatchSummary_OnInitialize
global function RTKRankedMatchSummary_OnDestroy
global function BuildRankedMatchSummaryDataModel
global function BuildRankedBadgeDataModel
global function AnimateRankedProgressBar
global function StartRankUpAnimation
global function SetContinueButtonRegistration
global function RTKRankedMatchSummary_UpdateTweenDataModel
global function InitRTKRankedMatchSummary

global struct RTKRankedMatchSummary_Properties
{
	rtk_behavior progressBarAnimator
	rtk_behavior tweenStagger
}

global struct BonusBreakdownInfo
{
	string bonusName 	 = ""
	string bonusStat 	 = ""
	int bonusValue 		 = 0
	bool crossOut		 = false
	bool isInfo		 	 = false

	string tooltipTitle	 = ""
	string tooltipBody   = ""
}

global struct ConditionalElement
{
	int 	alternatingBGOffset = 0
	string 	stringL = ""
	int 	stringR = 0
	vector 	colorL = <1.0, 1.0, 1.0>
	vector 	colorR = <1.0, 1.0, 1.0>
	vector	bgColor = <0.16, 0.16, 0.16>

	string tooltipTitle	 = ""
	string tooltipBody   = ""
}

global struct RankedPromoTrial
{
	bool active
	string description
	int statGoal
	int statCurrent
	vector progressBarColor
}

global struct RankedProgressBarTweenData
{
	int minRankScore
	int maxRankScore
	int startScore
	int endScore

	float progressFracStart
	float progressFracEnd

	bool isDoubleBadge = false
	bool hasPromoTrialAtEnd = false
	asset promoTrialCapImage

	RTKRankedBadgeModel& badge1
	RTKRankedBadgeModel& badge2

	
	int adjustedMinRankScore
	int adjustedMaxRankScore
	int adjustedStartScore
	int adjustedEndScore
}

global struct RankedProgressBarData
{
	int startScore
	int endScore
	int totalRanks

	int currentTweenIndex = 0
	RankedProgressBarTweenData& currentTween
	array< RankedProgressBarTweenData > tweens = []
}

global struct PromoTrialsData
{
	bool hasTrial = false

	int trialsAttempts = 0
	int maxTrialsAttempts = 1
	int trialsCount = 0
	array< RankedPromoTrial > trials = []
	string trialsInfoString = ""

	vector trialsStatusColor = <1, 1, 1>
	vector trialsStatusBannerColor = <1, 1, 1>
	float trialsStatusBannerAlpha = 0.0
	string trialsStatusMessage = ""
}

global struct RankedMatchSummaryExtraInfo
{
	int entryCost = 0
	int totalBonus = 0
	int baseKillValue = 0
	int numPlacementMatches = 0
	bool isPlacement = false
	array< BonusBreakdownInfo > breakdownBonuses = []
	array< ConditionalElement > conditionals = []
	array< BonusBreakdownInfo > stats = []
	array< BonusBreakdownInfo > placementBonuses = []
	array< BonusBreakdownInfo > headers = []

	RankedProgressBarData& progressData

	string lastPlayedTime = "0m"
	string lastGameMode = ""

	PromoTrialsData& trialsData

	bool showProtection = false
	int protectionCurrent = 0
	int protectionMax = 0
}

global struct RankedMatchSummaryScreenData
{
	bool isProgressPanelVisible = true
	bool isRankUpAnimationInProgress = false

	vector themeColor = <1, 1, 1>
	vector titleTextColor = <1, 1, 1>
}

struct PrivateData
{
	rtk_struct rankedMatchSummaryModel
	rtk_struct rankedMatchSummaryScreenDataModel
	rtk_struct summaryBreakdownModel
	rtk_struct summaryExtraInfoModel
	rtk_struct progressModel

	int numRanksEarned = 0
	int scoreStart = 0
	int scoreEnd = 0
	int ladderPosition
	bool hasLPBarAnimationStarted = false
	bool callbacksRegistered = false
}

struct
{
	bool isFirstTime = false
} file

const string POSTGAME_XP_INCREASE = "UI_Menu_MatchSummary_Ranked_XPBar_Increase"
const string POSTGAME_RANKED_MENU_NAME = "PostGameRankedMenu"

void function RTKRankedMatchSummary_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_SetAllowedBehaviorTypes( structType, "progressBarAnimator", [ "Animator" ] )
	RTKMetaData_SetAllowedBehaviorTypes( structType, "tweenStagger", [ "TweenStagger" ] )

	RegisterSignal( "OnRankedMatchSummaryDestroyed" )

	file.isFirstTime = true
}

void function RTKRankedMatchSummary_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	SetContinueButtonRegistration( self, true )

	BuildRankedMatchSummaryDataModel( self )
	BuildRankedBadgeDataModel( self )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "ranked", true, [ "postGame" ] ) )

	
	AnimateRankedProgressBar( self )

	
	if ( file.isFirstTime )
	{
		rtk_behavior ornull tweenStagger = self.PropGetBehavior( "tweenStagger" )
		if ( tweenStagger != null )
		{
			expect rtk_behavior( tweenStagger )
			tweenStagger.SetActive( true )
		}
	}
}

void function RTKRankedMatchSummary_OnDestroy( rtk_behavior self )
{
	Signal( self, "OnRankedMatchSummaryDestroyed" )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "ranked", ["postGame"] )
	SetContinueButtonRegistration( self, false )
}

void function BuildRankedMatchSummaryDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	p.rankedMatchSummaryModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "ranked", "", [ "postGame" ] )

	entity player = GetLocalClientPlayer()

	RankLadderPointsBreakdown scoreBreakdown
	LoadLPBreakdownFromPersistance ( scoreBreakdown, player )

	RankedMatchSummaryExtraInfo extraInfo


		extraInfo.entryCost = -1 * scoreBreakdown.entryCost




	extraInfo.totalBonus = 0

	int elapsedTime = GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" )
	extraInfo.lastPlayedTime = GetFormattedIntByType( elapsedTime, eNumericDisplayType.TIME_MINUTES_LONG )

	string lastGameMode = expect string( GetPersistentVar( "lastGameMode" ) )
	extraInfo.lastGameMode = lastGameMode

	










	BonusBreakdownInfo highSkillKillBonus
	highSkillKillBonus.bonusName	= "#RANKED_SKILL_KILL_BONUS"
	highSkillKillBonus.bonusStat	= string( scoreBreakdown.highSkillKill )
	highSkillKillBonus.bonusValue	= scoreBreakdown.highSkillKillBonusValue
	highSkillKillBonus.tooltipTitle = "#RANKED_SKILL_KILL_BONUS"
	highSkillKillBonus.tooltipBody  = Localize ( "#RANKED_SKILL_KILL_BONUS_DESC" , int ( Ranked_GetHighSkillKillBonusValue () * scoreBreakdown.killValueModifierByPlacement ) , scoreBreakdown.highSkillKill , scoreBreakdown.highSkillKillBonusValue )
	highSkillKillBonus.crossOut		= scoreBreakdown.wasAbandoned
	extraInfo.totalBonus		+= scoreBreakdown.highSkillKillBonusValue
	extraInfo.breakdownBonuses.push(highSkillKillBonus)

	
	
	
	
	
	
	
	

	BonusBreakdownInfo streakBonus
	streakBonus.bonusName	= "#RANKED_STREAK_BONUS"
	streakBonus.bonusValue	= scoreBreakdown.top5StreakBonusValue
	streakBonus.bonusStat    = Localize ( "#X/Y", string( minint ( scoreBreakdown.top5Streak,  Ranked_GetTop5StreakMax() ) ) , string ( Ranked_GetTop5StreakMax() ) )
	streakBonus.tooltipTitle = "#RANKED_STREAK_BONUS"
	streakBonus.tooltipBody  = Localize ( "#RANKED_STREAK_BONUS_DESC" , Ranked_GetTop5StreakBonusValue () ,  scoreBreakdown.top5Streak , scoreBreakdown.top5StreakBonusValue,  Ranked_GetTop5StreakMax()  )
	streakBonus.crossOut		= scoreBreakdown.wasAbandoned
	extraInfo.totalBonus		+= scoreBreakdown.top5StreakBonusValue
	extraInfo.breakdownBonuses.push(streakBonus)


	if (scoreBreakdown.provisionalMatchBonus > 0)
	{
		BonusBreakdownInfo tempBonusBreakdownInfo
		tempBonusBreakdownInfo.bonusName	= "#RANKED_PROVISIONAL_BONUS"
		tempBonusBreakdownInfo.bonusValue	= scoreBreakdown.provisionalMatchBonus
		tempBonusBreakdownInfo.tooltipTitle = "#RANKED_PROVISIONAL_BONUS"
		tempBonusBreakdownInfo.tooltipBody  = "#RANKED_PROVISIONAL_BONUS_DESC"
		tempBonusBreakdownInfo.crossOut		= scoreBreakdown.wasAbandoned
		extraInfo.totalBonus				+= scoreBreakdown.provisionalMatchBonus
		extraInfo.breakdownBonuses.push(tempBonusBreakdownInfo)
	}

	if (scoreBreakdown.promotionBonus > 0)
	{
		BonusBreakdownInfo tempBonusBreakdownInfo
		tempBonusBreakdownInfo.bonusName	= "#RANKED_TIER_PROMOTION_BONUS"
		tempBonusBreakdownInfo.bonusValue	= scoreBreakdown.promotionBonus
		tempBonusBreakdownInfo.tooltipTitle = "#RANKED_TIER_PROMOTION_BONUS"
		tempBonusBreakdownInfo.tooltipBody  = Localize ( "#RANKED_TIER_PROMOTION_BONUS_DESC", scoreBreakdown.promotionBonus )
		tempBonusBreakdownInfo.crossOut		= scoreBreakdown.wasAbandoned
		extraInfo.totalBonus				+= scoreBreakdown.promotionBonus
		extraInfo.breakdownBonuses.push(tempBonusBreakdownInfo)
	}

	
	int altBgOffset = IsOdd( extraInfo.breakdownBonuses.len() ) ? 1 : 0

	
	if (scoreBreakdown.penaltyPointsForAbandoning > 0)
	{
		ConditionalElement tempCondEle
		tempCondEle.stringL	= "#RANKED_ABANDON_PENALTY"
		tempCondEle.stringR	= scoreBreakdown.penaltyPointsForAbandoning * -1
		tempCondEle.colorL	= <1, 0.26, 0.26>
		tempCondEle.colorR	= <1, 0.26, 0.26>
		tempCondEle.alternatingBGOffset = altBgOffset
		tempCondEle.tooltipTitle = "#RANKED_ABANDON_PENALTY"
		tempCondEle.tooltipBody  = Localize( "#RANKED_ABANDON_PENALTY_DESC", scoreBreakdown.penaltyPointsForAbandoning )
		extraInfo.totalBonus	 -= scoreBreakdown.penaltyPointsForAbandoning
		extraInfo.conditionals.push(tempCondEle)
	}

	if (scoreBreakdown.lossProtectionAdjustment > 0)
	{
		ConditionalElement tempCondEle
		tempCondEle.stringL	= "#RANKED_LOSS_FORGIVENESS"
		tempCondEle.stringR	= scoreBreakdown.lossProtectionAdjustment
		tempCondEle.alternatingBGOffset = altBgOffset
		tempCondEle.tooltipTitle = "#RANKED_LOSS_FORGIVENESS"
		tempCondEle.tooltipBody  = Localize( "#RANKED_LOSS_FORGIVENESS_DESC", tempCondEle.stringR )
		extraInfo.totalBonus	 += scoreBreakdown.lossProtectionAdjustment
		extraInfo.conditionals.push(tempCondEle)
	}

	if (scoreBreakdown.demotionPenality > 0)
	{
		ConditionalElement tempCondEle
		tempCondEle.stringL	= "#RANKED_TIER_DERANKING"
		tempCondEle.stringR	= scoreBreakdown.demotionPenality * -1
		tempCondEle.colorL	= <1, 0.26, 0.26>
		tempCondEle.colorR	= <1, 0.26, 0.26>
		tempCondEle.alternatingBGOffset = altBgOffset
		tempCondEle.tooltipTitle = "#RANKED_TIER_DERANKING"
		tempCondEle.tooltipBody  = Localize( "#RANKED_TIER_DERANKING_DESC", scoreBreakdown.demotionPenality )
		extraInfo.totalBonus	 -= scoreBreakdown.demotionPenality
		extraInfo.conditionals.push(tempCondEle)
	}

	if (scoreBreakdown.demotionProtectionAdjustment > 0)
	{
		ConditionalElement tempCondEle
		tempCondEle.stringL	= "#RANKED_DEMOTION_PROTECTION"
		tempCondEle.stringR	= scoreBreakdown.demotionProtectionAdjustment
		tempCondEle.tooltipTitle = "#RANKED_DEMOTION_PROTECTION"
		int tierDemotionPenalty =  GetCurrentPlaylistVarInt ( "ranked_tier_demotion_penality", RANKED_LP_DEMOTION_PENALITY )
		int playerDemotionProtectionCount = GetDemotionProtectionBuffer ( player )
		tempCondEle.tooltipBody  = Localize( "#RANKED_DEMOTION_PROTECTION_DESC", scoreBreakdown.demotionProtectionAdjustment, playerDemotionProtectionCount, tierDemotionPenalty )
		tempCondEle.alternatingBGOffset = altBgOffset
		extraInfo.totalBonus += scoreBreakdown.demotionProtectionAdjustment
		extraInfo.conditionals.push(tempCondEle)
	}

	
	int participationPercentage = 0
	float participationsScaled = float( scoreBreakdown.participationUnique )
	int killCapPercentage = 0
	float killCapValue = 0

	participationPercentage = int( Ranked_GetParticipationMutlipler() * 100 )
	participationsScaled = scoreBreakdown.participationUnique * Ranked_GetParticipationMutlipler()
	killCapPercentage = int( Ranked_GetSoftKillCapMod() * 100 )
	killCapValue = scoreBreakdown.killValueModifierByPlacement - (scoreBreakdown.killValueModifierByPlacement * Ranked_GetSoftKillCapMod())

	extraInfo.baseKillValue = scoreBreakdown.killValueModifierByPlacement
	extraInfo.numPlacementMatches = Ranked_GetNumProvisionalMatchesRequired()
	extraInfo.isPlacement = !Ranked_HasCompletedProvisionalMatches( player )
























	BonusBreakdownInfo killsNew
	killsNew.bonusName = "#SCOREBOARD_KILLS"
	killsNew.bonusStat = string( scoreBreakdown.killsUnique )
	killsNew.bonusValue =  scoreBreakdown.killsUnique * scoreBreakdown.killValueModifierByPlacement
	killsNew.tooltipTitle = "#SCOREBOARD_KILLS"
	killsNew.tooltipBody = Localize( "#SCOREBOARD_KILLS_DESC_DETAILED", scoreBreakdown.killsUnique, scoreBreakdown.killValueModifierByPlacement , killsNew.bonusValue )
	extraInfo.stats.push(killsNew)

	BonusBreakdownInfo assistsNew
	assistsNew.bonusName = "#SCOREBOARD_ASSISTS"
	assistsNew.bonusStat = string( scoreBreakdown.assistUnique )
	assistsNew.bonusValue =  scoreBreakdown.assistUnique * scoreBreakdown.killValueModifierByPlacement
	assistsNew.tooltipTitle = "#SCOREBOARD_ASSISTS"
	assistsNew.tooltipBody = Localize( "#SCOREBOARD_ASSISTS_DESC_DETAILED", scoreBreakdown.assistUnique, scoreBreakdown.killValueModifierByPlacement,  assistsNew.bonusValue )
	extraInfo.stats.push(assistsNew)

	BonusBreakdownInfo participationsNew
	participationsNew.bonusName = "#SCOREBOARD_PARTICIPATION"
	participationsNew.bonusStat = Localize( "#RANKED_PARTICIPATION_DISPLAY", string( scoreBreakdown.participationUnique ), string( participationPercentage ), LocalizeAndShortenNumber_Float( participationsScaled, 3, 1 ) )
	participationsNew.bonusValue = int( participationsScaled * scoreBreakdown.killValueModifierByPlacement )
	participationsNew.tooltipTitle = "#SCOREBOARD_PARTICIPATION"
	participationsNew.tooltipBody = Localize( "#RANKED_PARTICIPATION_DESC_DETAILED", string( 100 - participationPercentage ), LocalizeAndShortenNumber_Float( participationsScaled, 3, 1 ) , participationsNew.bonusValue ,  scoreBreakdown.killValueModifierByPlacement )
	extraInfo.stats.push(participationsNew)

	BonusBreakdownInfo softCapAdjustment
	softCapAdjustment.bonusName = "#RANKED_SOFT_CAP_ADJUSTMENT"
	int totalEarned =  int( ( scoreBreakdown.killsUnique +  scoreBreakdown.assistUnique + participationsScaled ) * scoreBreakdown.killValueModifierByPlacement )
	int killCapAdjustment =  scoreBreakdown.killBonus - totalEarned
	int killCap = Ranked_GetSoftKillCapStartCount()
	softCapAdjustment.bonusValue = killCapAdjustment
	softCapAdjustment.tooltipTitle = "#RANKED_SOFT_CAP_ADJUSTMENT"
	softCapAdjustment.tooltipBody = Localize( "#RANKED_SOFT_CAP_ADJUSTMENT_DESC_OLD", killCap, LocalizeAndShortenNumber_Float( killCapValue, 3, 1 ), string( 100 - killCapPercentage ) )
	extraInfo.stats.push(softCapAdjustment)


	
	BonusBreakdownInfo placementBonus
	placementBonus.bonusName = "#RANKED_PLACEMENT_BONUS"
	placementBonus.bonusStat = Localize( "#DEATH_SCREEN_SUMMARY_PLACEMENT", string( GetPersistentVarAsInt( "lastGameRank" ) ) )
	placementBonus.bonusValue = scoreBreakdown.placementScore
	placementBonus.tooltipTitle = "#RANKED_PLACEMENT_BONUS"
	placementBonus.tooltipBody = Localize ( "#RANKED_PLACEMENT_BONUS_DESC", scoreBreakdown.placementScore )
	extraInfo.placementBonuses.push(placementBonus)

	BonusBreakdownInfo costOfEntry
	costOfEntry.bonusName = "#RANKED_COST_OF_ENTRY"
	costOfEntry.bonusStat = GetCurrentRankedDivisionFromScoreAndLadderPosition( scoreBreakdown.startingLP, Ranked_GetLadderPosition( player ) ).divisionName
	costOfEntry.bonusValue = extraInfo.entryCost
	costOfEntry.tooltipTitle = "#RANKED_COST_OF_ENTRY"
	costOfEntry.tooltipBody = Localize ( "#RANKED_COST_OF_ENTRY_DESC", extraInfo.entryCost )
	extraInfo.placementBonuses.push(costOfEntry)

	
	BonusBreakdownInfo combat
	combat.bonusName = "#RANKED_COMBAT_SUBHEADER"
	combat.bonusValue = scoreBreakdown.killBonus
	combat.tooltipTitle = "#RANKED_COMBAT_SUBHEADER"
	combat.tooltipBody = "#RANKED_COMBAT_SUBHEADER_DESC"
	extraInfo.headers.push(combat)

	BonusBreakdownInfo bonus
	bonus.bonusName = "#RANKED_BONUS_SUBHEADER"
	bonus.bonusValue = extraInfo.totalBonus
	bonus.tooltipTitle = "#RANKED_BONUS_SUBHEADER"
	bonus.tooltipBody = "#RANKED_BONUS_SUBHEADER_DESC"
	extraInfo.headers.push(bonus)

	BonusBreakdownInfo placement
	placement.bonusName = "#RANKED_PLACEMENT_SUBHEADER"
	placement.bonusValue = scoreBreakdown.placementScore + extraInfo.entryCost
	placement.tooltipTitle = "#RANKED_PLACEMENT_SUBHEADER"
	placement.tooltipBody = "#RANKED_PLACEMENT_SUBHEADER_DESC"
	extraInfo.headers.push(placement)

	
	extraInfo.trialsData.trials.clear()

	int trialState = RankedTrials_GetTrialState( player )
	extraInfo.trialsData.hasTrial = RankedTrials_PlayerHasAssignedTrial( player )

	if ( extraInfo.trialsData.hasTrial )
	{
		
		ItemFlavor currentTrial = RankedTrials_GetAssignedTrial( player )

		extraInfo.trialsData.trialsAttempts = RankedTrials_GetGamesPlayedInTrialsState( player )
		extraInfo.trialsData.maxTrialsAttempts = RankedTrials_GetGamesAllowedInTrialsState( player, currentTrial )

		
		int trialsCount = RankedTrials_GetTrialsCountForTrial( currentTrial )
		extraInfo.trialsData.trialsCount = trialsCount

		
		foreach ( int statIdx in eRankedTrialGoalIdx )
		{
			RankedPromoTrial trial

			if ( trialsCount > statIdx )
			{
				trial.active	  		= true
				string unlocalizedDesc 	= RankedTrials_GetDescription( currentTrial, statIdx )

				bool usesComboStats 	= statIdx > eRankedTrialGoalIdx.PRIMARY && RankedTrials_SecondaryTrialRequiresSingleMatchPerformance( currentTrial )
				trial.statGoal 			= usesComboStats ? RankedTrials_GetSecondaryTrialSingleMatchComboCount( currentTrial ) : RankedTrials_GetTrialStatGoalByIndex( currentTrial, statIdx )
				trial.statCurrent 		= usesComboStats ? RankedTrials_GetSecondaryStatMatchComboStatProgress( player ) : RankedTrials_GetProgressValueForStatByIndex( player, statIdx )
				trial.description 		= Localize( unlocalizedDesc, trial.statGoal )

				
				if ( usesComboStats )
				{
					int statOne 		= RankedTrials_GetTrialStatGoalByIndex( currentTrial, eRankedTrialGoalIdx.SECONDARY_ONE )
					int statTwo 		= RankedTrials_GetTrialStatGoalByIndex( currentTrial, eRankedTrialGoalIdx.SECONDARY_TWO )
					trial.description 	= Localize( unlocalizedDesc, statOne, statTwo )
				}

				
				
				SharedRankedDivisionData ornull nextRank 		= GetNextRankedDivisionFromScore( scoreBreakdown.finalLP )
				if ( trialState != eRankedTrialState.SUCCESS && nextRank != null )
				{
					expect SharedRankedDivisionData( nextRank )
					vector rankColor 							= GetKeyColor( COLORID_RANKED_BORDER_COLOR_ROOKIE, nextRank.tier.index ) / 255
					trial.progressBarColor 						= rankColor
				}
				else
				{
					int ladderPosition                   		= Ranked_GetLadderPosition( player  )
					SharedRankedDivisionData currentRank 		= GetCurrentRankedDivisionFromScoreAndLadderPosition( scoreBreakdown.finalLP, ladderPosition )
					vector rankColor 							= GetKeyColor( COLORID_RANKED_BORDER_COLOR_ROOKIE, currentRank.tier.index ) / 255
					trial.progressBarColor 						= rankColor
				}
			}
			else
			{
				trial.active	  = false
				trial.description = ""
				trial.statCurrent = 0
				trial.statGoal 	  = 1
				trial.progressBarColor = GetKeyColor( COLORID_RANKED_BORDER_COLOR_ROOKIE ) / 255
			}

			extraInfo.trialsData.trials.push( trial )
		}

		
		switch ( trialState )
		{
			case eRankedTrialState.INCOMPLETE:
				int attemptsRemaining = extraInfo.trialsData.maxTrialsAttempts - extraInfo.trialsData.trialsAttempts
				extraInfo.trialsData.trialsInfoString = Localize( "#RANKED_PROMOTION_ATTEMPTS_REMAINING", attemptsRemaining )
				extraInfo.trialsData.trialsStatusColor = <0.7, 0.7, 0.7>
				extraInfo.trialsData.trialsStatusBannerColor =  <0.7, 0.7, 0.7>
				extraInfo.trialsData.trialsStatusBannerAlpha =  0.0
				extraInfo.trialsData.trialsStatusMessage = Localize( "#X/Y_STYLED", extraInfo.trialsData.trialsAttempts, extraInfo.trialsData.maxTrialsAttempts )
				break
			case eRankedTrialState.SUCCESS:
				extraInfo.trialsData.trialsInfoString = Localize( "#RANKED_PROMOTION_SUCCESS_DESCRIPTION", scoreBreakdown.promotionBonus )
				extraInfo.trialsData.trialsStatusColor = <1, 0.86, 0.24>
				extraInfo.trialsData.trialsStatusBannerColor = <1, 0.86, 0.24>
				extraInfo.trialsData.trialsStatusBannerAlpha = 0.25
				extraInfo.trialsData.trialsStatusMessage = Localize( "#RANKED_PROMOTION_SUCCESS" )
				break
			case eRankedTrialState.FAILURE:
				int lpToRetry = 0
				extraInfo.trialsData.trialsInfoString = ""
				int currentScore                     		= scoreBreakdown.finalLP
				SharedRankedDivisionData ornull nextRank 	= GetNextRankedDivisionFromScore( currentScore )
				if ( nextRank != null )
				{
					expect SharedRankedDivisionData( nextRank )
					lpToRetry = nextRank.scoreMin - currentScore
					if ( lpToRetry > 0 )
					{
						extraInfo.trialsData.trialsInfoString = Localize( "#RANKED_PROMOTION_FAILED_DESCRIPTION", lpToRetry )
					}
				}
				extraInfo.trialsData.trialsStatusColor = <1, 0.18, 0.05>
				extraInfo.trialsData.trialsStatusBannerColor = <0.5, 0.07, 0.01>
				extraInfo.trialsData.trialsStatusBannerAlpha = 0.65
				extraInfo.trialsData.trialsStatusMessage = Localize( "#RANKED_PROMOTION_FAILED" )
				break
			case eRankedTrialState.NOT_IN_TRIAL:
			default:
				extraInfo.trialsData.trialsInfoString = ""
				break;
		}
	}
	else
	{
		
		foreach ( int statIdx in eRankedTrialGoalIdx )
		{
			RankedPromoTrial trial
			trial.active = false
			trial.description = ""
			trial.statGoal = 1
			trial.statCurrent = 0
			extraInfo.trialsData.trials.push( trial )
		}
	}

	foreach(int index, conditional in extraInfo.conditionals)
	{
		if ( index % 2 == 0 )
			conditional.bgColor = <0.16, 0.16, 0.16>
		else
			conditional.bgColor = <0.35, 0.35, 0.35>
	}

	
	RankedMatchSummaryScreenData screenData

	
	screenData.isProgressPanelVisible = !file.isFirstTime
	screenData.isRankUpAnimationInProgress = false

	SeasonStyleData seasonStyle = GetSeasonStyle()
	screenData.titleTextColor = seasonStyle.titleTextColor
	screenData.themeColor = seasonStyle.seasonColor

	
	p.rankedMatchSummaryScreenDataModel = RTKStruct_GetOrCreateScriptStruct( p.rankedMatchSummaryModel, "screen", "RankedMatchSummaryScreenData" )
	p.summaryBreakdownModel = RTKStruct_GetOrCreateScriptStruct( p.rankedMatchSummaryModel, "breakdown", "RankLadderPointsBreakdown" )
	p.summaryExtraInfoModel = RTKStruct_GetOrCreateScriptStruct( p.rankedMatchSummaryModel, "extraInfo", "RankedMatchSummaryExtraInfo" )

	bool isProvisional = Ranked_GetNumProvisionalMatchesCompleted( player ) < Ranked_GetNumProvisionalMatchesRequired()
	SharedRankedDivisionData currentRank = GetCurrentRankedDivisionFromScoreAndLadderPosition( scoreBreakdown.finalLP, Ranked_GetLadderPosition( player ) )
	int tierFloor = currentRank.tier.scoreMin
	extraInfo.showProtection = (scoreBreakdown.finalLP - tierFloor) <= abs( extraInfo.entryCost ) && currentRank.tier.allowsDemotion && !isProvisional
	if ( extraInfo.showProtection )
	{
		extraInfo.protectionCurrent = GetDemotionProtectionBuffer ( player )
		extraInfo.protectionMax = DEMOTION_BUFFER_MAX
	}

	RTKStruct_SetValue( p.rankedMatchSummaryScreenDataModel, screenData )
	RTKStruct_SetValue( p.summaryBreakdownModel, scoreBreakdown )
	RTKStruct_SetValue( p.summaryExtraInfoModel, extraInfo )
}

void function BuildRankedBadgeDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	p.progressModel 							= RTKStruct_GetOrCreateScriptStruct( p.summaryExtraInfoModel, "progressData", "RankedProgressBarData" )
	RankedProgressBarData progressData
	PromoTrialsData trialsData

	entity player 						 		= GetLocalClientPlayer()
	bool inProvisionals					 		= !Ranked_HasCompletedProvisionalMatches( player )
	int currentScore                     		= RTKStruct_GetInt( p.summaryBreakdownModel, "finalLP" ) 
	int previousScore 							= RTKStruct_GetInt( p.summaryBreakdownModel, "startingLP" )
	int ladderPosition                   		= Ranked_GetLadderPosition( player  )
	SharedRankedDivisionData currentRank 		= GetCurrentRankedDivisionFromScoreAndLadderPosition( currentScore, ladderPosition )
	SharedRankedDivisionData ornull nextRank 	= GetNextRankedDivisionFromScore( currentScore )
	SharedRankedDivisionData previousRank 		= GetCurrentRankedDivisionFromScore( previousScore )

	p.numRanksEarned 							= ( currentRank.index - previousRank.index )
	p.scoreStart 								= previousScore
	p.scoreEnd									= currentScore
	p.ladderPosition							= ladderPosition

	if ( ( p.numRanksEarned > 0 ) && currentRank.isLadderOnlyDivision ) 
	{
		if( !(GetNextRankedDivisionFromScore( previousScore ) == null) ) 
			p.numRanksEarned = 2 
	}

	bool useProvisionalBadgeAsset 				= inProvisionals

	
	progressData.startScore 					= previousScore
	progressData.endScore 						= currentScore
	progressData.totalRanks 					= p.numRanksEarned
	progressData.currentTweenIndex 				= 0

	int currentAnimScore = previousScore
	for ( int i = 0; i <= abs( p.numRanksEarned ); i++ )
	{
		RankedProgressBarTweenData tween

		SharedRankedDivisionData thisDivision 	= GetCurrentRankedDivisionFromScoreAndLadderPosition( currentAnimScore, ladderPosition )
		SharedRankedDivisionData ornull nextDivision = GetNextRankedDivisionFromScore( currentAnimScore )

		tween.isDoubleBadge 					= !inProvisionals && !thisDivision.isLadderOnlyDivision && nextDivision != null
		bool hasPromoTrial				 	= RankedTrials_PlayerHasIncompleteTrial( player )
		tween.isDoubleBadge 				= !inProvisionals && !thisDivision.isLadderOnlyDivision && nextDivision != null && !hasPromoTrial
		useProvisionalBadgeAsset			= inProvisionals || hasPromoTrial

		if ( nextDivision != null )
		{
			expect SharedRankedDivisionData( nextDivision )
			tween.hasPromoTrialAtEnd = RankedTrials_NextRankHasTrial( thisDivision, nextDivision ) && !RankedTrials_IsKillswitchEnabled()
			tween.promoTrialCapImage = nextDivision.tier.promotionalMetallicImage
		}

		tween.badge1.divisionName				= thisDivision.divisionName
		tween.badge1.rankColor					= GetKeyColor( COLORID_RANKED_BORDER_COLOR_ROOKIE, thisDivision.tier.index ) / 255
		tween.badge1.badgeRuiAsset 				= useProvisionalBadgeAsset ? RANKED_PLACEMENT_BADGE : thisDivision.tier.iconRuiAsset
		tween.badge1.rankedIcon 				= string( thisDivision.tier.icon )
		tween.badge1.emblemDisplayMode 			= thisDivision.emblemDisplayMode

		
		tween.badge1.isLadderOnlyRank			= thisDivision.isLadderOnlyDivision || thisDivision.emblemDisplayMode == emblemDisplayMode.DISPLAY_LADDER_POSITION || thisDivision.emblemDisplayMode == emblemDisplayMode.DISPLAY_RP

		switch ( thisDivision.emblemDisplayMode )
		{
			case emblemDisplayMode.DISPLAY_DIVISION:
				tween.badge1.emblemText 		= thisDivision.emblemText
				break
			case emblemDisplayMode.DISPLAY_RP:
				string rankScoreShortened 		= FormatAndLocalizeNumber( "1", float( currentScore ), IsTenThousandOrMore( currentScore ) )
				tween.badge1.emblemText 		= Localize( "#RANKED_POINTS_GENERIC", rankScoreShortened )
				break
			case emblemDisplayMode.DISPLAY_LADDER_POSITION:
				string ladderPosShortened
				if ( ladderPosition == SHARED_RANKED_INVALID_LADDER_POSITION )
					ladderPosShortened 			= ""
				else
					ladderPosShortened 			= Localize( "#RANKED_LADDER_POSITION_DISPLAY", FormatAndLocalizeNumber( "1", float( ladderPosition ), IsTenThousandOrMore( ladderPosition ) ) )
				tween.badge1.emblemText 		= ladderPosShortened
				break;
			case emblemDisplayMode.NONE:
			default:
				tween.badge1.emblemText			= ""
				break;
		}

		tween.badge1.ladderPosition 			= ladderPosition
		tween.badge1.rankScore 					= currentScore

		
		tween.badge1.badgeLabel					= useProvisionalBadgeAsset ? "" : tween.badge1.emblemText

		bool isPlacementMode 					= inProvisionals
		bool useDynamicPips						= false
		isPlacementMode 					= inProvisionals || hasPromoTrial
		tween.badge1.isPromotional			= hasPromoTrial
		useDynamicPips 						= !inProvisionals && hasPromoTrial
		tween.badge1.isPlacementMode 			= isPlacementMode

		tween.badge1.tooltipTitle 				= inProvisionals ? Localize( "#RANKED_PROVISIONAL_TITLE" ) : thisDivision.divisionName
		tween.badge1.tooltipBody 				= inProvisionals ? Localize( "#RANKED_PROVISIONAL_DESC" ) : ""

		int badge1MatchesCompleted 				= 0
		int badge1MaxMatches 					= 10
		if ( inProvisionals )
		{
			badge1MatchesCompleted 				= Ranked_GetNumProvisionalMatchesCompleted( player )
		}
		else if ( hasPromoTrial )
		{
			ItemFlavor currentTrial 			= RankedTrials_GetAssignedTrial( player )
			badge1MatchesCompleted 				= RankedTrials_GetGamesPlayedInTrialsState( player )
			badge1MaxMatches 					= RankedTrials_GetGamesAllowedInTrialsState( player, currentTrial )
		}

		tween.badge1.completedMatches 			= badge1MatchesCompleted
		tween.badge1.maxMatches 				= badge1MaxMatches
		tween.badge1.useDynamicPips				= useDynamicPips
		tween.badge1.startPip 					= 0

		if ( inProvisionals )
		{
			for ( int idx = 0; idx < badge1MatchesCompleted; idx++ )
			{
				tween.badge1.wonMatches.push( true )
			}
		}

		if ( tween.isDoubleBadge )
		{
			expect SharedRankedDivisionData( nextDivision )
			tween.badge2.divisionName			= nextDivision.divisionName
			tween.badge2.rankColor				= GetKeyColor( COLORID_RANKED_BORDER_COLOR_ROOKIE, nextDivision.tier.index ) / 255
			tween.badge2.badgeRuiAsset 			= inProvisionals ? RANKED_PLACEMENT_BADGE : nextDivision.tier.iconRuiAsset
			tween.badge2.rankedIcon 			= string( nextDivision.tier.icon )
			tween.badge2.emblemDisplayMode 		= nextDivision.emblemDisplayMode
			
			tween.badge2.isLadderOnlyRank		= nextDivision.isLadderOnlyDivision || nextDivision.emblemDisplayMode == emblemDisplayMode.DISPLAY_LADDER_POSITION || nextDivision.emblemDisplayMode == emblemDisplayMode.DISPLAY_RP
			tween.badge2.emblemText 			= ""

			switch ( nextDivision.emblemDisplayMode )
			{
				case emblemDisplayMode.DISPLAY_DIVISION:
					tween.badge2.emblemText = nextDivision.emblemText
					break

				case emblemDisplayMode.DISPLAY_RP:
					string rankScoreShortened = FormatAndLocalizeNumber( "1", float( nextDivision.scoreMin ), IsTenThousandOrMore( nextDivision.scoreMin ) )
					tween.badge2.emblemText = Localize( "#RANKED_POINTS_GENERIC", rankScoreShortened )
					break

				case emblemDisplayMode.DISPLAY_LADDER_POSITION:
					string ladderPosShortened
					if ( ladderPosition == SHARED_RANKED_INVALID_LADDER_POSITION )
						ladderPosShortened = ""
					else
						ladderPosShortened = Localize( "#RANKED_LADDER_POSITION_DISPLAY", FormatAndLocalizeNumber( "1", float( ladderPosition ), IsTenThousandOrMore( ladderPosition ) ) )
					tween.badge2.emblemText = ladderPosShortened
					break;

				case emblemDisplayMode.NONE:
				default:
					tween.badge2.emblemText = ""
					break;
			}

			
			tween.badge2.badgeLabel				= useProvisionalBadgeAsset ? "" : tween.badge2.emblemText
			tween.badge2.ladderPosition 		= ladderPosition
			tween.badge2.rankScore 				= currentScore
			tween.badge2.isPlacementMode 		= inProvisionals
			int badge2matchesCompleted 			= Ranked_GetNumProvisionalMatchesCompleted( player )
			tween.badge2.completedMatches 		= badge2matchesCompleted
			tween.badge2.useDynamicPips			= false
			tween.badge2.startPip 				= 0
		}

		if ( nextDivision != null)
		{
			expect SharedRankedDivisionData( nextDivision )
			tween.minRankScore = thisDivision.scoreMin
			tween.maxRankScore = nextDivision.scoreMin

			tween.startScore = currentAnimScore

			if ( currentScore > previousScore )
				tween.endScore = minint( currentScore, nextDivision.scoreMin )
			else
				tween.endScore = maxint( currentScore, thisDivision.scoreMin )

			tween.progressFracStart = float( tween.startScore - tween.minRankScore ) / float( tween.maxRankScore - tween.minRankScore )
			tween.progressFracEnd = float( tween.endScore - tween.minRankScore ) / float( tween.maxRankScore - tween.minRankScore )

			
			tween.adjustedMinRankScore = 0
			tween.adjustedMaxRankScore = tween.maxRankScore - tween.minRankScore
			tween.adjustedStartScore = tween.startScore - tween.minRankScore
			tween.adjustedEndScore = tween.endScore - tween.minRankScore
		}
		else
		{
			tween.minRankScore = thisDivision.scoreMin
			tween.endScore = currentScore

			tween.adjustedMinRankScore = 0
			tween.adjustedEndScore = tween.endScore - tween.minRankScore
		}

		
		
		currentAnimScore = ( p.numRanksEarned > 0 ) ? tween.endScore : tween.endScore - 1

		
		progressData.tweens.push( tween )
	}

	progressData.currentTween 					= progressData.tweens[0]

	RTKStruct_SetValue( p.progressModel, progressData )
}

void function AnimateRankedProgressBar( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	
	
	if ( p.hasLPBarAnimationStarted )
		return

	p.hasLPBarAnimationStarted = true

	entity player 			= GetLocalClientPlayer()
	bool inProvisionals 	= !Ranked_HasCompletedProvisionalMatches( player )
	bool hasPromoTrial	= RankedTrials_PlayerHasIncompleteTrial( player )
	bool animateProgressBar  = !inProvisionals && file.isFirstTime && !hasPromoTrial

	
	RTKStruct_SetBool( p.rankedMatchSummaryScreenDataModel, "isProgressPanelVisible", true )

	
	rtk_behavior ornull barAnimator = self.PropGetBehavior( "progressBarAnimator" )
	if ( barAnimator == null )
		return

	expect rtk_behavior( barAnimator )

	
	if ( animateProgressBar )
	{
		
		RTKStruct_SetInt( p.progressModel, "currentTweenIndex", 0 )

		
		RTKRankedMatchSummary_UpdateTweenDataModel( self )

		
		self.AutoSubscribe( barAnimator, "onAnimationFinished", function ( rtk_behavior barAnimator, string animName ) : ( self, inProvisionals ) {
			file.isFirstTime = false
			StopUISoundByName( POSTGAME_XP_INCREASE )
			if ( !RTKAnimator_IsPlaying( barAnimator ) )
			{
				if ( RTKRankedMatchSummary_UpdateTweenDataModel( self, true ) )
				{
					RTKAnimator_PlayAnimation( barAnimator, "AnimateBar" )
				}
				else
				{
					PrivateData p
					self.Private( p )

					bool hasProgressedOutOfProvisional = Ranked_GetXProgMergedPersistenceData( GetLocalClientPlayer(), RANKED_PROVISIONAL_MATCH_HAS_PROGRESSED_OUT_PERSISTENCE_VAR_NAME ) != 0
					bool isProvisionalGraduation = ( !inProvisionals && !hasProgressedOutOfProvisional && !GetConVarBool( RANKED_PROVISIONAL_MATCH_CONVAR_KILL_SWITCH ) )

					if ( p.numRanksEarned > 0 || isProvisionalGraduation )
					{
						thread StartRankUpAnimation( self, isProvisionalGraduation )
					}
					else if ( p.numRanksEarned < 0 )
					{
						PlayLobbyCharacterDialogue( "glad_rankDown"  )
					}
				}
			}
		} )

		self.AutoSubscribe( barAnimator, "onAnimationStarted", function ( rtk_behavior animator, string animName ) : ( ) {
			EmitUISound( POSTGAME_XP_INCREASE )
		} )

		
		RTKAnimator_PlayAnimation( barAnimator, "AnimateBar" )
	}
	else 
	{
		rtk_array tweens = RTKStruct_GetArray( p.progressModel, "tweens" )
		int tweensCount = RTKArray_GetCount( tweens )
		RTKStruct_SetInt( p.progressModel, "currentTweenIndex", tweensCount - 1 )
		RTKRankedMatchSummary_UpdateTweenDataModel( self )
	}
}

void function StartRankUpAnimation( rtk_behavior self, bool isProvisionalGraduation = false )
{
	PrivateData p
	self.Private( p )

	
	OnThreadEnd(
		function() : ( self )
		{
			if ( self == null )
				return

			PrivateData p
			self.Private( p )

			RTKStruct_SetBool( p.rankedMatchSummaryScreenDataModel, "isRankUpAnimationInProgress", false )
			SetContinueButtonRegistration( self, true )
		}
	)

	
	EndSignal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )
	EndSignal( self, "OnRankedMatchSummaryDestroyed" )

	
	wait 1

	
	SetContinueButtonRegistration( self, false )
	if ( GetNextRankedDivisionFromScore( p.scoreStart ) != null )
		RTKStruct_SetBool( p.rankedMatchSummaryScreenDataModel, "isRankUpAnimationInProgress", true )

	
	wait 0.1
	RankUpAnimation( GetTopNonDialogMenu(), p.numRanksEarned, p.scoreStart, p.ladderPosition, p.scoreEnd, isProvisionalGraduation )
	wait 0.1
}

bool function RTKRankedMatchSummary_UpdateTweenDataModel( rtk_behavior self, bool incrementTween = false )
{
	PrivateData p
	self.Private( p )

	
	int currentTweenIndex = RTKStruct_GetInt( p.progressModel, "currentTweenIndex" )

	if ( incrementTween )
		currentTweenIndex++

	rtk_array tweens = RTKStruct_GetArray( p.progressModel, "tweens" )
	int tweensCount = RTKArray_GetCount( tweens )

	if ( currentTweenIndex < tweensCount )
	{
		rtk_struct tween = RTKArray_GetStruct( tweens, currentTweenIndex )
		RTKStruct_SetStruct( p.progressModel, "currentTween", tween )
		RTKStruct_SetInt( p.progressModel, "currentTweenIndex", currentTweenIndex )
		return true
	}

	return false
}

void function SetContinueButtonRegistration( rtk_behavior self, bool register )
{
	PrivateData p
	self.Private( p )

	if ( register )
	{
		if ( !p.callbacksRegistered )
		{
			RegisterButtonPressedCallback( KEY_ESCAPE, OnContinueButton_Activated )
			RegisterButtonPressedCallback( KEY_SPACE, OnContinueButton_Activated )
			RegisterButtonPressedCallback( BUTTON_A, OnContinueButton_Activated )
			RegisterButtonPressedCallback( BUTTON_B, OnContinueButton_Activated )
			p.callbacksRegistered = true
		}
	}
	else
	{
		if ( p.callbacksRegistered )
		{
			DeregisterButtonPressedCallback( KEY_ESCAPE, OnContinueButton_Activated )
			DeregisterButtonPressedCallback( KEY_SPACE, OnContinueButton_Activated )
			DeregisterButtonPressedCallback( BUTTON_A, OnContinueButton_Activated )
			DeregisterButtonPressedCallback( BUTTON_B, OnContinueButton_Activated )
			p.callbacksRegistered = false
		}
	}
}

void function OnContinueButton_Activated( var button )
{
	if ( GetActiveMenuName() == POSTGAME_RANKED_MENU_NAME )
		thread CloseActiveMenu()
}

void function RankedMatchSummaryOnOpenPanel( var panel )
{
	DeathScreenUpdateCursor()
}

void function InitRTKRankedMatchSummary( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, RankedMatchSummaryOnOpenPanel )
	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.RANK)
}