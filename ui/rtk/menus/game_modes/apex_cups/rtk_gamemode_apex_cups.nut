global function InitRTKGameModeSelectApexCups
global function RTKGameModeSelectApexCups_OnInitialize
global function RTKGameModeSelectApexCups_OnDestroy
global function RTKGameModeSelectApexCups_GetLockState

global struct RTKGameModeSelectApexCups_Properties
{
	rtk_behavior infoButton
}

global struct RTKApexCupCard
{
	SettingsAssetGUID apexCup
	SettingsAssetGUID calEvent
	int		state
	int		lockState
	asset	rankIcon
	bool 	rankTextOffset
}

global struct RTKSummaryBreakdownRowModel
{
	int		index
	string	leftText
	string	rightText
	string	textArgs
}

global struct RTKApexCupsModel
{
	array< RTKApexCupCard > activeList
	array< RTKApexCupCard > finishedList
	bool loading = true
}

struct {
	var panel
} file

const GAMEMODE_APEX_RUMBLE = "apex_rumble"

void function RTKGameModeSelectApexCups_OnInitialize( rtk_behavior self )
{
	thread RTKGameModeSelectApexCups_OnInitializeAsync( self )

	
	if( RTKGameModeSelectApexCups_ShowAboutDialog() )
	{
		RTKGameModeSelectApexCups_OpenAboutDialog()
		Remote_ServerCallFunction( "ClientCallback_ViewedCupsAboutDialog" )
	}

	rtk_behavior ornull infoButton = self.PropGetBehavior( "infoButton" )
	if ( infoButton != null )
	{
		self.AutoSubscribe( infoButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RTKGameModeSelectApexCups_OpenAboutDialog()
		} )
	}
}

void function InitRTKGameModeSelectApexCups( var panel )
{
	file.panel = panel

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK_TO_MODE_SELECT", "#B_BUTTON_BACK_TO_MODE_SELECT" )
	AddCallback_UI_FeatureTutorialDialog_PopulateTabsForMode( RTKGameModeSelectApexCups_PopulateAboutText, GAMEMODE_APEX_RUMBLE )
	AddCallback_UI_FeatureTutorialDialog_SetTitle( RTKGameModeSelectApexCups_PopulateAboutTitle, GAMEMODE_APEX_RUMBLE )
}

array<featureTutorialTab> function RTKGameModeSelectApexCups_PopulateAboutText()
{
	array<featureTutorialTab> tabs
	featureTutorialTab tab1
	array<featureTutorialData> tab1Rules

	
	tab1.tabName = 	"#APEX_CUPS_OVERVIEW_TAB"

	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CUPS_MORE_INFO_OVERVIEW", "#CUPS_MORE_INFO_OVERVIEW_DESC", $"rui/menu/apex_rumble/about_rumble_enter" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#CUPS_MORE_INFO_POINTS", "#CUPS_MORE_INFO_POINTS_DESC", $"rui/menu/apex_rumble/about_rumble_points" ) )

	bool currentActiveMatchIsBest10 = Cups_IsCupContainerUseBestTen( Cups_GetActiveCupContainerIDsFromBakery() )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( currentActiveMatchIsBest10 ? "#BEST_TEN_CUPS_REWARDS": "#CUPS_MORE_INFO_REWARDS", currentActiveMatchIsBest10 ? "#BEST_TEN_CUPS_MORE_INFO_REWARDS_DESC": "#CUPS_MORE_INFO_REWARDS_DESC", $"rui/menu/apex_rumble/about_rumble_rewards" ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	return tabs
}

string function RTKGameModeSelectApexCups_PopulateAboutTitle()
{
	return "#CUPS_MORE_INFO_TITLE"
}

bool function RTKGameModeSelectApexCups_ShowAboutDialog()
{
	return !( bool( GetPersistentVar( "seenCupsPopup" ) ) )
}

void function RTKGameModeSelectApexCups_OpenAboutDialog()
{
	if ( !IsFullyConnected() )
		return

	UI_OpenFeatureTutorialDialog( GAMEMODE_APEX_RUMBLE )
}

void function RTKGameModeSelectApexCups_OnDestroy( rtk_behavior self )
{
	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexCups" )
}

void function RTKGameModeSelectApexCups_OnInitializeAsync( rtk_behavior self )
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	rtk_struct apexCups = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexCups", "RTKApexCupsModel" )
	rtk_array activeList = RTKStruct_GetArray( apexCups, "activeList" )
	rtk_array finishedList = RTKStruct_GetArray( apexCups, "finishedList" )

	Cups_WaitForResponse()

	int unixTime = GetUnixTimestamp()
	foreach ( ItemFlavor cupEvent in Cups_GetAllEvents() )
	{
		if ( !CalEvent_IsVisible( cupEvent, unixTime ) && !Cups_HasParticipated( cupEvent ) )
			continue


		if ( RankedRumble_IsContainerRankedRumble( cupEvent ) && !GetConVarBool( RANKED_RUMBLE_CONVAR ) )
			continue


		ItemFlavor ornull cup = Cups_GetEligbleCup( cupEvent )
		if ( cup == null )
			continue
		expect ItemFlavor( cup )

		RTKApexCupCard apexCupCardsModel
		apexCupCardsModel.apexCup	= cup.guid
		apexCupCardsModel.calEvent	= cupEvent.guid
		apexCupCardsModel.lockState	= RTKGameModeSelectApexCups_GetLockState( cupEvent )

		
		if ( apexCupCardsModel.lockState == CUP_LOCK_NONE && CalEvent_IsActive( cupEvent, unixTime ) && IsPersistenceAvailable() )
		{
			int persistenceDataIndex = Cups_GetPlayersPDataIndexForCupID( GetLocalClientPlayer(), cup.guid )
			if ( persistenceDataIndex >= 0 )
			{
				bool cupSeen = expect bool( GetPersistentVar( format( "cups[%d].uiSeen", persistenceDataIndex ) ) )
				if ( !cupSeen )
				{
					Remote_ServerCallFunction( "ClientCallback_ViewedActiveCup", cup.guid )

					
					SetPanelTabNew( file.panel, false )
				}
			}
		}


		if ( RankedRumble_IsCupRankedRumble( cup ) )
		{
			if ( CalEvent_HasFinished( cupEvent, unixTime ) && Cups_GetSquadCupData( cup.guid ) == null ) 
			{
				apexCupCardsModel.rankIcon = $""
			}
			else
			{
				CupBakeryAssetData cupData          = Cups_GetCupBakeryAssetDataFromGUID( ItemFlavor_GetGUID( cup ) )
				RankedRumbleContainerInfo info      = RankedRumble_GetContainerInfo( cupData.containerItemFlavor )
				SharedRankedTierData rankedTierData = RankedRumble_GetPlayerHistoricalRankedTier( cupData, info.rankedPeriod )
				apexCupCardsModel.rankIcon = rankedTierData.icon
				SharedRankedDivisionData divisionData = GetCurrentRankedDivisionFromScoreAndLadderPosition( rankedTierData.scoreMin, rankedTierData.isLadderOnlyTier ? 1 : SHARED_RANKED_INVALID_LADDER_POSITION )
				apexCupCardsModel.rankTextOffset = (divisionData.emblemDisplayMode != emblemDisplayMode.DISPLAY_DIVISION)
			}
		}


		if ( CalEvent_HasFinished( cupEvent, unixTime ) )
			apexCupCardsModel.state = CUP_STATE_FINISHED
		else if ( CalEvent_HasStarted( cupEvent, unixTime ) )
			apexCupCardsModel.state = CUP_STATE_IN_PROGESS
		else
			apexCupCardsModel.state = CUP_STATE_STARTING

		if ( apexCupCardsModel.state == CUP_STATE_FINISHED )
			RTKArray_PushValue( finishedList, apexCupCardsModel )
		else
			RTKArray_PushValue( activeList, apexCupCardsModel )
	}

	RTKStruct_SetBool( apexCups, "loading", false )
}

int function RTKGameModeSelectApexCups_GetLockState( ItemFlavor cupEvent )
{

		if ( RankedRumble_IsContainerRankedRumble( cupEvent ) )
		{
			if( !GetConVarBool( "ranked_rumble_skip_training" ) )
			{
				if ( !IsLocalPlayerExemptFromTraining() && !HasLocalPlayerCompletedTraining() )
					return CUP_LOCK_TRAINING
			}

			if ( ( !GetCurrentPlaylistVarBool( RANKED_DEV_PLAYTEST_PLAYLIST_VAR, false ) ) && GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) ) < Ranked_GetRankedLevelRequirement() )
				return CUP_LOCK_LEVELS

			if ( CalEvent_IsActive( cupEvent, GetUnixTimestamp() ) && !Cups_IsCupEventRegistered( cupEvent ) )
			{
				if ( !RankedRumble_IsRankedScorePositionValid() )
					return CUP_LOCK_NO_POSITION
				else
					return CUP_LOCK_NOT_REGISTERED
			}
		}

	return CUP_LOCK_NONE
}

