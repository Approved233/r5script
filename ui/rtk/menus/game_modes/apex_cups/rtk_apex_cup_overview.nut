global function InitRTKApexCupsOverview
global function RTKApexCupsOverview_InitMetaData
global function RTKApexCupsOverview_OnInitialize
global function RTKApexCupsOverview_OnDestroy
global function RTKApexCupsOverview_OnRegisterPressed
global function RTKApexCupsOverview_SetCup
global function RTKApexCupsOverview_GetCupID
global function RTKApexCupsOverview_HideButton

global struct RTKApexCupsOverview_Properties
{
	rtk_behavior optInButton
	rtk_behavior reRollButton
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
	bool 				isTall
	int 				rarity
	SettingsAssetGUID 	flavGUID
}

global struct RTKRewardTiersModel
{
	array< RTKRewardTiersData >	rewardList
}

global struct RTKOptInData
{
	string	buttonText
	bool	showButton
	bool	showRerollButton
	bool	buttonActive

	array< RTKCupRulesModel >	rulesList
	array< RTKGameTagModel >	tagsList
	RTKOptInDataToolTipModel&	tooltipData
}

global struct RTKCupOverview
{
	int					state
	SettingsAssetGUID 	calEvent
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
	RTKMetaData_SetAllowedBehaviorTypes( structType, "reRollButton", [ "Button" ] )
	RTKMetaData_SetAllowedBehaviorTypes( structType, "infoButton", [ "Button" ] )
}

void function RTKApexCupsOverview_OnInitialize( rtk_behavior self )
{	
	RTKCupOverviewInit()
	RTKRewardTiersInit()
	RTKOptInDataInit( self )

	rtk_behavior ornull optInButton = self.PropGetBehavior( "optInButton" )
	rtk_behavior ornull reRollButton = self.PropGetBehavior( "reRollButton" )
	rtk_behavior ornull infoButton = self.PropGetBehavior( "infoButton" )

	if ( optInButton != null )
	{
		self.AutoSubscribe( optInButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			thread RTKApexCupsOverview_OnRegisterPressed( self, GetLocalClientPlayer(),  file.cupId )
		} )
	}

	if ( reRollButton != null )
	{
		self.AutoSubscribe( reRollButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
			if ( IsValidItemFlavorGUID( assetData.reRollToken.guid ) )
				OpenApexCupPurchaseRerollDialog( assetData.reRollToken, Localize ( assetData.name ), file.entry )
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
		
		if ( IsPartyLeader() )
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
					thread RTKApexCupsOverview_ReRollSetUp( self )
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

	
	
	string gamemode = CupEvent_GetGameMode( cupItemFlav )
	if ( LimitedTimeMode_IsDefined( gamemode ) )
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_2"
		rule.visible         = true
		rule.textArgs        = Localize( LimitedTimeMode_GetName( gamemode ) )
		optInModel.rulesList.append( rule )
	}

	
	{
		RTKCupRulesModel rule
		rule.bulletpointText = "#CUP_RULES_3"
		rule.visible         = true
		rule.textArgs        = Localize( file.squadSizeRule[cupData.squadSize - 1] )
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
		rule.bulletpointText = "#CUP_RULES_5"
		rule.visible         = restriction.hasMinRankLimit
		rule.textArgs        = Localize( restriction.minRankString )
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
			rewardTier.tier = Localize("#CUPS_REWARDS_TOP", tData.bound.tostring() )
		}
		else
		{
			relativeTier++
			rewardTier.tier = Localize ( LocalizeNumeral( relativeTier ) )
		}

		rewardTier.iconPath = CustomizeMenu_GetRewardButtonImage( flav )

		rewardTier.showQuantity = tData.rewardData[0].quantity > 1
		rewardTier.quantity 	= tData.rewardData[0].quantity
		rewardTier.level 	= ( cupData.tiers.len() - 1 ) - i
		rewardTier.isOwned 	= hasParticipated && currentRewardTier <= i
		rewardTier.isTall 	= true
		rewardTier.flavGUID = ItemFlavor_GetGUID( flav )

		apexCupsRewards.rewardList.append( rewardTier )
	}
	apexCupsRewards.rewardList.reverse()

	RTKStruct_SetValue( apexRewards, apexCupsRewards )
}

void function RTKApexCupsOverview_ReRollSetUp( rtk_behavior self )
{
	EndSignal( self, RTK_ON_DESTROY_SIGNAL )

	while ( Cups_GetSquadCupData( file.cupId ) == null && ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() ) )
	{
		WaitFrame()
	}

	if ( Cups_GetSquadCupData( file.cupId ) != null )
	{
		CupBakeryAssetData assetData = Cups_GetCupBakeryAssetDataFromGUID( file.cupId )
		file.entry = expect CupEntry ( Cups_GetSquadCupData( file.cupId ) )

		bool active = ( assetData.maximumNumberOfReRolls > file.entry.reRollCount ) && ( assetData.maximumNumberOfReRolls > 0 ) && ( file.entry.matchSummaryData.len() > 0 )

		if ( !active )
		{
			RTKApexCupsOverview_HideButton()
			return
		}

		ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( assetData.reRollToken )

		Assert( ifpi.isPurchasableAtAll )
		array <GRXScriptOffer> offers

		if ( ifpi.craftingOfferOrNull != null )
			offers.append( GRX_ScriptOfferFromCraftingOffer( expect GRXScriptCraftingOffer(ifpi.craftingOfferOrNull) ) )

		foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
			foreach ( GRXScriptOffer locationOffer in locationOfferList )
				if ( locationOffer.offerType != GRX_OFFERTYPE_BUNDLE && locationOffer.output.flavors.len() == 1 )
					offers.append( locationOffer )

		RTKApexCupsOverview_ButtonState( false, false, Localize( "#CUPS_REROLL_BUTTON", GRX_GetFormattedPrice(offers[0].prices[0], 1 ) ), active )
		RTKApexCupsOverview_ToolTip( false )
	}
	else
	{
		RTKApexCupsOverview_HideButton()
	}
}

void function RTKApexCupsOverview_ToolTip( bool tooltipActive, string titleText = "", string bodyText = "" )
{
	rtk_struct tooltipData = RTKDataModel_GetStruct( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "tooltipData", true, ["optInData"] ) )

	RTKStruct_SetString( tooltipData, "titleText", titleText )
	RTKStruct_SetString( tooltipData, "bodyText", bodyText )
	RTKStruct_SetBool( tooltipData, "tooltipActive", tooltipActive )
}

void function RTKApexCupsOverview_ButtonState( bool showButton, bool buttonActive, string buttonText = "", bool showReRollButton = false )
{
	rtk_struct optInData = RTKDataModel_GetStruct( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "optInData" ) )

	RTKStruct_SetBool( optInData, "showButton", showButton )
	RTKStruct_SetBool( optInData, "showReRollButton", showReRollButton )
	RTKStruct_SetBool( optInData, "buttonActive", buttonActive )
	RTKStruct_SetString( optInData, "buttonText", buttonText )
}

void function RTKApexCupsOverview_HideButton()
{
	RTKApexCupsOverview_ButtonState( false, false )
	RTKApexCupsOverview_ToolTip( false )
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
	if( cupID != file.cupId )
		return

	ClearUserFullCupDataCache()
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
