global function InitRTKApexCupsOverview
global function RTKApexCupsOverview_InitMetaData
global function RTKApexCupsOverview_OnInitialize
global function RTKApexCupsOverview_OnDestroy
global function RTKApexCupsOverview_OnRegisterPressed
global function RTKApexCupsOverview_SetCup
global function RTKApexCupsOverview_GetCupID

global struct RTKApexCupsOverview_Properties
{
	rtk_behavior optInButton
	rtk_behavior matchHistoryButton
	rtk_behavior infoButton
}

global struct RTKCupRulesModel
{
	string	bulletpointText
	string	textArgs
	bool	visible
}

global struct RTKGameTagModel
{
	string	tagText
}

global struct RTKOptInDataToolTipModel
{
	string	titleText
	string	bodyText
	bool	tooltipActive
}

global struct RTKRewardTiersData
{
	string 				tier
	asset 				iconPath
	bool 				showQuantity
	int					quantity
	int					level
	bool 				isOwned
	bool 				isCurrentTier
	bool 				isTall
	bool 				isRumble
	int 				rarity
	SettingsAssetGUID 	flavGUID
	int					badgeTier
}

global struct RTKRewardTiersModel
{
	array< RTKRewardTiersData >	rewardList
}

global struct RTKOptInData
{
	string	buttonText
	bool	showButton
	bool	showMatchHistoryButton
	bool	buttonActive

	array< RTKCupRulesModel >	rulesList
	array< RTKGameTagModel >	tagsList
	RTKOptInDataToolTipModel&	tooltipData
}

global struct RTKCupOverview
{
	int					state
	SettingsAssetGUID 	calEvent
	SettingsAssetGUID 	cupID
}

struct
{
	SettingsAssetGUID cupId = 0
	array<string> squadSizeRule = [ "#CUP_RULES_SOLO", "#CUP_RULES_DUO", "#CUP_RULES_TRIO" ]
	CupEntry& entry

}file

void function RTKApexCupsOverview_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_SetAllowedBehaviorTypes( structType, "optInButton", [ "Button" ] )
	RTKMetaData_SetAllowedBehaviorTypes( structType, "matchHistoryButton", [ "Button" ] )
	RTKMetaData_SetAllowedBehaviorTypes( structType, "infoButton", [ "Button" ] )
}

void function RTKApexCupsOverview_OnInitialize( rtk_behavior self )
{	
	RTKCupOverviewInit()
	RTKRewardTiersInit()
	RTKOptInDataInit( self )

	rtk_behavior ornull optInButton = self.PropGetBehavior( "optInButton" )
	rtk_behavior ornull matchHistoryButton = self.PropGetBehavior( "matchHistoryButton" )
	rtk_behavior ornull infoButton = self.PropGetBehavior( "infoButton" )

	if ( optInButton != null )
	{
		self.AutoSubscribe( optInButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			thread RTKApexCupsOverview_OnRegisterPressed( self, GetLocalClientPlayer(),  file.cupId )
		} )
	}

	if ( matchHistoryButton != null )
	{
		self.AutoSubscribe( matchHistoryButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			ApexCupMenu_JumpToMatchHistory()
		} )
	}

	if ( infoButton != null )
	{
		self.AutoSubscribe( infoButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			UI_OpenCupInfoDialog()
		} )
	}
}

void function RTKCupOverviewInit()
{
	rtk_struct cupOverview = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "cupOverview", "RTKCupOverview" )
	RTKCupOverview cupOverviewModel

	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
	ItemFlavor cupItemFlav = cupData.containerItemFlavor

	cupOverviewModel.calEvent = cupItemFlav.guid
	cupOverviewModel.cupID = cupData.itemFlavor.guid

	
	if ( CalEvent_HasFinished( cupItemFlav, GetUnixTimestamp() ) )
		cupOverviewModel.state = CUP_STATE_FINISHED
	else if ( CalEvent_HasStarted( cupItemFlav, GetUnixTimestamp() ) )
		cupOverviewModel.state = CUP_STATE_IN_PROGESS
	else
		cupOverviewModel.state = CUP_STATE_STARTING

	RTKStruct_SetValue( cupOverview, cupOverviewModel )
}

void function RTKOptInDataInit( rtk_behavior self )
{
	rtk_struct optInData = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "optInData", "RTKOptInData" )
	RTKOptInData optInModel

	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
	ItemFlavor cupItemFlav = cupData.containerItemFlavor
	bool IsRegisteredForCup = Cups_GetPlayersPCupData( GetLocalClientPlayer(), file.cupId ).registered
	CupEntryRestrictions restriction = cupData.entryRestrictions

	
	
	if( !CalEvent_IsActive( cupItemFlav, GetUnixTimestamp() ) )
	{
		RTKApexCupsOverview_ButtonState( false, false )
	}
	else 
	{
		if ( IsPartyLeader() || !CupEvent_GetLimitSquadSize( cupItemFlav ) )
		{
			
			if (  !IsRegisteredForCup  )
			{
				RTKApexCupsOverview_ButtonState( true, true, "#APEX_CUPS_ENTER_CUP" )
				RTKApexCupsOverview_ToolTip( false )

				
				int rankScore = GetPlayerRankScore( GetLocalClientPlayer() )
				
				if ( restriction.hasMinRankLimit && ( rankScore < restriction.minRankScore ) )
				{
					RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP" )
					RTKApexCupsOverview_ToolTip( true, "#CUP_REQUIREMENTS_NOT_MET", "#CUP_REQUIREMENTS_NOT_MET_DESC" )
				}
				
				if ( restriction.hasMaxRankLimit && ( rankScore < restriction.maxRankScore ) )
				{
					RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP" )
					RTKApexCupsOverview_ToolTip( true, "#CUP_REQUIREMENTS_NOT_MET", "#CUP_REQUIREMENTS_NOT_MET_DESC" )
				}

				if ( cupData.isLimitSquadSize )
				{
					
					if ( GetPartySize() != cupData.squadSize )
					{
						RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP" )
						RTKApexCupsOverview_ToolTip( true, "#CUP_SQUAD_AMOUNT_INCORRECT", "#CUP_SQUAD_AMOUNT_INCORRECT_DESC" )
					}
				}

				
				int playerLevel = GetAccountLevelForXP( GetLocalClientPlayer().GetXP() ) + 1 
				if ( restriction.hasMinLevelLimit && ( playerLevel < restriction.minEntryLevel ) )
				{
					RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP" )
					RTKApexCupsOverview_ToolTip( true, "#CUP_REQUIREMENTS_NOT_MET", "#CUP_REQUIREMENTS_NOT_MET_DESC" )
				}

				
				if ( !CrossplayUserOptIn() )
				{
					RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP" )
					RTKApexCupsOverview_ToolTip( true, "#CUP_ENABLE_CROSSPLAY", "#CUP_ENABLE_CROSSPLAY_DESC" )
				}
			}
			else 
			{
				if ( Cups_HasParticipated( cupItemFlav ) )
				{
					RTKApexCupsOverview_ButtonState( false, false, "#CUPS_MATCH_HISTORY", true )
					RTKApexCupsOverview_ToolTip( true, "#CUPS_MATCH_HISTORY", "#CUPS_MATCH_HISTORY_DESC" )
				}
				else
				{
					RTKApexCupsOverview_ButtonState( true, false, "#CUP_ENTERED" )
					RTKApexCupsOverview_ToolTip( true, "#CUP_ENTERED", "#CUP_ENTERED_DESC" )
				}
			}
		}
		else 
		{
			RTKApexCupsOverview_ButtonState( true, false, "#APEX_CUPS_ENTER_CUP"  )
			RTKApexCupsOverview_ToolTip( true, "#CUPS_SQUAD_LEADER", "#CUPS_SQUAD_LEADER_DESC" )
		}
	}

	RTKStruct_GetValue( optInData, optInModel )

	
	
	int gamemode = GameModeVariant_GetByDevName( CupEvent_GetGameMode( cupItemFlav ) )
	if ( GameModeVariant_IsDefined( gamemode ) )
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_2"
		rule.visible         = true
		rule.textArgs        = Localize( GameModeVariant_GetName( gamemode ) )
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule

		if ( RankedRumble_IsCupRankedRumble( cupData.itemFlavor ) )
		{
			rule.bulletpointText = "#CUP_RULES_RANKED_SQUAD"
		}
		else

		{
			rule.bulletpointText = "#CUP_RULES_3"
			rule.textArgs        = Localize( file.squadSizeRule[cupData.squadSize - 1] )
		}
		rule.visible         = true
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_4"
		rule.visible         = restriction.hasMinLevelLimit
		rule.textArgs        = (restriction.minEntryLevel).tostring()
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule

		if ( RankedRumble_IsCupRankedRumble( cupData.itemFlavor ) )
		{
			if ( CalEvent_HasFinished( cupData.containerItemFlavor, GetUnixTimestamp() ) && Cups_GetSquadCupData( file.cupId ) == null )
			{
				rule.bulletpointText = "#CUP_RULES_RANKED_NOT_ENTERED"
			}else
			{
				rule.bulletpointText = "#CUP_RULES_RANKED_DIVISION"
				rule.textArgs = Localize( restriction.maxRankString )
			}
		}
		else

		{
			rule.bulletpointText = "#CUP_RULES_5"
			rule.textArgs        = Localize( restriction.minRankString )
		}
		rule.visible         = restriction.hasMinRankLimit
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_6"
		rule.visible         = restriction.hasMaxRankLimit
		rule.textArgs        = Localize( restriction.maxRankString )
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_1"
		rule.visible         = true
		optInModel.rulesList.append( rule )
	}

	RTKStruct_SetValue( optInData, optInModel )
}

void function RTKRewardTiersInit()
{
	rtk_struct apexRewards = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "rewardTiers", "RTKRewardTiersModel" )
	RTKRewardTiersModel apexCupsRewards

	CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
	ItemFlavor cupItemFlav = cupData.containerItemFlavor
	bool hasParticipated = Cups_HasParticipated( cupItemFlav )


		int playerRankTier = RankedRumble_IsCupIDRankedRumble( file.cupId ) ? RankedRumble_GetCupRankedTier( file.cupId ) : 0


	RTKStruct_GetValue( apexRewards, apexCupsRewards )

	int relativeTier = 0
	int currentRewardTier = Cups_GetPlayerTierIndexForCup( file.cupId )
	for ( int i = 0; i < cupData.tiers.len(); i++ )
	{
		RTKRewardTiersData rewardTier
		CupTierData tData = cupData.tiers[i]
		ItemFlavor flav = GetItemFlavorByAsset( tData.rewardData[0].reward )
		if ( tData.tierType == eCupTierType.ABSOLUTE )
		{
			relativeTier++
			rewardTier.tier = Localize ( LocalizeNumeral( relativeTier ) )

				if ( RankedRumble_IsCupIDRankedRumble( file.cupId ) )
				{
					int position = 101 
					if ( currentRewardTier <= i )
					{
						CupEntry ornull cupEntryData = Cups_GetSquadCupData( file.cupId )
						if ( cupEntryData != null )
						{
							expect CupEntry ( cupEntryData )
							position = cupEntryData.currSquadPosition
						}
					}
					rewardTier.badgeTier = RankedRumble_CombineBadgeTier( playerRankTier, 1, position )
				}

		}
		else
		{
			relativeTier++
			rewardTier.tier = Localize ( LocalizeNumeral( relativeTier ) )

				if ( RankedRumble_IsCupIDRankedRumble( file.cupId ) )
					rewardTier.badgeTier = RankedRumble_CombineBadgeTier( playerRankTier, tData.bound, 0 )

		}

		rewardTier.iconPath = CustomizeMenu_GetRewardButtonImage( flav )

		bool isRewardCurrency = ItemFlavor_GetType( flav ) == eItemType.account_currency
		rewardTier.showQuantity = isRewardCurrency ? false : tData.rewardData[0].quantity > 1 
		rewardTier.quantity 	= tData.rewardData[0].quantity
		rewardTier.level 	= i
		rewardTier.isOwned 	= hasParticipated && currentRewardTier <= i
		rewardTier.isCurrentTier = ( currentRewardTier == i )
		rewardTier.isTall 	= true
		rewardTier.isRumble = true
		rewardTier.flavGUID = ItemFlavor_GetGUID( flav )

		apexCupsRewards.rewardList.append( rewardTier )
	}
	apexCupsRewards.rewardList.reverse()

	RTKStruct_SetValue( apexRewards, apexCupsRewards )
}

void function RTKApexCupsOverview_ToolTip( bool tooltipActive, string titleText = "", string bodyText = "" )
{
	rtk_struct tooltipData = RTKDataModel_GetStruct( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "tooltipData", true, ["optInData"] ) )

	RTKStruct_SetString( tooltipData, "titleText", titleText )
	RTKStruct_SetString( tooltipData, "bodyText", bodyText )
	RTKStruct_SetBool( tooltipData, "tooltipActive", tooltipActive )
}

void function RTKApexCupsOverview_ButtonState( bool showButton, bool buttonActive, string buttonText = "", bool showMatchHistoryButton = false )
{
	rtk_struct optInData = RTKDataModel_GetStruct( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "optInData" ) )

	RTKStruct_SetBool( optInData, "showButton", showButton )


	if ( showButton )
	{
		CupBakeryAssetData cupData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
		ItemFlavor cupItemFlav = cupData.containerItemFlavor
		int lockState = RTKGameModeSelectApexCups_GetLockState( cupItemFlav )

#if DEV
			printt( "RTKApexCupsOverview_ButtonState", lockState )
#endif

		switch ( lockState )
		{
			case CUP_LOCK_LEVELS:
				buttonActive = false
				buttonText = Localize( "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED", Ranked_GetRankedLevelRequirement() + 1 )
				break
			case CUP_LOCK_ORIENTATION:
				buttonActive = false
				buttonText = Localize( "#PLAYLIST_STATE_COMPLETED_ORIENTATION_REQUIRED" )
				break
			case CUP_LOCK_TRAINING:
				buttonActive = false
				buttonText = Localize( "#PLAYLIST_STATE_COMPLETED_TRAINING_REQUIRED" )
				break
			case CUP_LOCK_NO_POSITION:
				buttonActive = false
				buttonText = Localize( "#PLAYLIST_STATE_NO_POSITION" )
				break
			case CUP_LOCK_NOT_REGISTERED:
				buttonActive = false
				buttonText = Localize( "#PLAYLIST_STATE_RANKED_RUMBLE_NOT_REGISTERED" )
				break
		}
	}


	RTKStruct_SetBool( optInData, "showMatchHistoryButton", showMatchHistoryButton )
	RTKStruct_SetBool( optInData, "buttonActive", buttonActive )
	RTKStruct_SetString( optInData, "buttonText", buttonText )
}

void function RTKApexCupsOverview_OnRegisterPressed( rtk_behavior self, entity player, SettingsAssetGUID cupID )
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	Cups_WaitForResponse()

	if ( Cups_RegisterForCup( cupID ) )
		RTKApexCupsOverview_ButtonState( true, false, "#CUP_ENTERED" )
}

void function RTKApexCupsOverview_SetCup( SettingsAssetGUID cupId )
{
	file.cupId = cupId
}

SettingsAssetGUID function RTKApexCupsOverview_GetCupID( )
{
	return file.cupId
}

void function RTKApexCupsOverview_OnCupsServerMessage( SettingsAssetGUID cupID, string squadID )
{
#if DEV
	printt( "RTKApexCupsOverview_OnCupsServerMessage", cupID, " ", squadID, " ", file.cupId )
#endif
	if( cupID != file.cupId )
		return

	ClearUserFullCupDataCache()
	RTKRewardTiersInit()
	RTKApexCupHistory_RegisterOrRerollComplete()
}

void function RTKApexCupsOverview_OnDestroy( rtk_behavior self )
{
	Signal( self, RTK_ON_DESTROY_SIGNAL )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "optInData")
}

void function InitRTKApexCupsOverview( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", GamemodeSelect_JumpToCups )
	Cups_RegisterOnServerMessageRecievedCallback( CupsServerMessageType.CUP_MESSAGE_TYPE_REROLL, RTKApexCupsOverview_OnCupsServerMessage )
	Cups_RegisterOnServerMessageRecievedCallback( CupsServerMessageType.CUP_MESSAGE_TYPE_REGISTRATION, RTKApexCupsOverview_OnCupsServerMessage )
}
