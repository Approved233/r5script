global function InitPromoData
global function GetPromoImage
global function OpenPromoLink
global function IsValidUMAction

#if DEV
global function DEV_PrintUMPromoData
#endif


global const string UM_LOCATION_PROMO_UM   = ""
global const string UM_LOCATION_PROMO_MINI = ""
global const string UM_LOCATION_BATTLEPASS = "battlepass"
global const string UM_LOCATION_NEW_PLAYER_BATTLEPASS = "new_player_battlepass"

global enum eBattlepassUMType
{
	NONE = 0,
	MESSAGE = 1,
	DEEPLINK = 2
}

struct
{
	table<string, asset> imageMap
} file


void function InitPromoData()
{
	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDataTableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title_blue"

	return image
}

void function OpenPromoLink( string linkType, string link, string fromPageId = "" )
{
#if DEV
	printt( "### OpenPromoLink - linkType:", linkType, "- link:", link, "- fromPageId:", fromPageId )
#endif

	switch ( linkType )
	{














		case "battlepass":
			EmitUISound( "UI_Menu_Accept" )
			JumpToSeasonTab( "RTKBattlepassPanel" )
			break

		case "battlepass_milestone":
			EmitUISound( "UI_Menu_Accept" )
			JumpToSeasonTab( "RTKBattlepassPanel" )
			OpenBattlePassMilestoneDialog()
			break

		case "battlepass_level":
			EmitUISound( "UI_Menu_Accept" )
			JumpToSeasonTab( "RTKBattlepassPanel" )
			BattlePass_PurchaseButton_OnActivate( null )
			break

		case "progression_modifiers":
			EmitUISound( "UI_Menu_Accept" )
			OpenProgressionModifiersMenu()
			break

		case "battlepass_purchase_premium":
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.PREMIUM )
			break

		case "battlepass_purchase_plus":
			OpenBattlepassPurchaseMenu( ePassPurchaseTab.PREMIUMPLUS )
			break



		case "newplayerpass":
			if ( NPP_IsNPPActive( GetLocalClientPlayer() ) )
			{
				EmitUISound( "UI_Menu_Accept" )
				JumpToSeasonTab( "RTKNewplayerpassPanel" )
			}
			break

		case "challenges":
			EmitUISound( "UI_Menu_Accept" )
			JumpToChallenges( link )
			break

		case "playapex":
			EmitUISound( "UI_Menu_Accept" )
			OpenGameModeSelectDialog()
			break

		case "heirloom":
			EmitUISound( "UI_Menu_Accept" )
			JumpToMythicOfferScreen( link, eMythicType.HEIRLOOM )
			break

		case "prestigeskin":
			EmitUISound( "UI_Menu_Accept" )
			JumpToMythicOfferScreen( link, eMythicType.PRESTIGE_SKIN )
			break

		case "storecharacter":
			EmitUISound( "UI_Menu_Accept" )
			entity player = GetLocalClientPlayer()
			if ( IsValidItemFlavorCharacterRef( link ) )
			{
				ItemFlavor character = GetItemFlavorByCharacterRef( link )
				if ( GRX_IsInventoryReady( player ) && Loadout_IsCharacterUnlockedForPlayer( player, character )  )
					JumpToCharactersTab()
				else
					JumpToCharacterCustomize( character )
			}
			else if ( IsValidItemFlavorGUID( ConvertItemFlavorGUIDStringToGUID( link ) ) )
			{
				ItemFlavor character = GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( link ) )
				if ( GRX_IsInventoryReady( player ) && Loadout_IsCharacterUnlockedForPlayer( player, character ) )
					JumpToCharactersTab()
				else
					JumpToCharacterCustomize( character )
			}
			else
			{
				JumpToCharactersTab()
			}
			break

		case "themedstoreskin":
			EmitUISound( "UI_Menu_Accept" )
			ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
			if ( activeThemedShopEvent != null )
			{
				if ( link != "" )
					JumpToThemeShopOffer( link )
				else
					JumpToEventTab( "ThemedShopPanel" )
			}
			else
				JumpToStoreTab()
			break

		case "collectionevent":
			EmitUISound( "UI_Menu_Accept" )
			ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
			if ( activeCollectionEvent != null )
				JumpToEventTab( "CollectionEventPanel" )
			else
				JumpToStoreTab()
			break

		case "url":
			EmitUISound( "UI_Menu_Accept" )
			LaunchExternalWebBrowser( link, WEBBROWSER_FLAG_NONE )
			break

		case "storeoffer":
			EmitUISound( "UI_Menu_Accept" )
			JumpToStoreOffer( FEATURED_STORE_PANEL, link )
			break

		case "monthlystoreoffer":
			EmitUISound( "UI_Menu_Accept" )
			JumpToStoreOffer( SEASONAL_STORE_PANEL, link )
			break

		case "whatsnew":
			EmitUISound( "UI_Menu_Accept" )
			JumpToSeasonTab( "WhatsNewPanel" )
			break

		case "storyevent":
			EmitUISound( "UI_Menu_Accept" )
			array<ItemFlavor> storyChallengeEvents = GetActiveStoryChallengeEvents( GetUnixTimestamp() )
			if ( storyChallengeEvents.len() <= 0 )
				return
			StoryEventAboutDialog_SetEvent( storyChallengeEvents[0] )
			AdvanceMenu( GetMenu( "StoryEventAboutDialog" ) )
			break

		case "storespecials":
			EmitUISound( "UI_Menu_Accept" )
			JumpToStoreOffer( SPECIALS_STORE_PANEL, link )
			break

		case "personalizedstore":
			EmitUISound( "UI_Menu_Accept" )
			JumpToStorePanel( PERSONALIZED_STORE_PANEL )
			break

		case "milestoneevent":
			ItemFlavor ornull milestoneEvent = GetActiveEventTabMilestoneEvent( GetUnixTimestamp() )
			if ( milestoneEvent != null )
			{
				switch ( link )
				{
					case "landingpage":
						EventsPanel_SetOpenPageIndex( eEventsPanelPage.LANDING )
						break

					case "purchasepack":
						EventsPanel_SetOpenPageIndex( eEventsPanelPage.MILESTONES )
						break

					case "collection":
						EventsPanel_SetOpenPageIndex( eEventsPanelPage.COLLECTION )
						break

					case "freerewards":
						ItemFlavor ornull activeEventShop = EventShop_GetCurrentActiveEventShop()
						if ( activeEventShop == null )
							return
						EventsPanel_SetOpenPageIndex( eEventsPanelPage.EVENT_SHOP )
						break
				}
				JumpToEventTab( "RTKEventsPanel" )
			}
			break

		case "storemilestoneevent":
			array<ItemFlavor> storeMilestoneEvents = GetActiveStoreOnlyMilestoneEvents( GetUnixTimestamp() )
			if ( storeMilestoneEvents.len() > 0 )
			{
				JumpToStoreMilestoneEventsMenu( link, fromPageId )
			}
			break

		case "storeOfferShop":
			EmitUISound( "UI_Menu_Accept" )
			JumpToStoreSection( link )
			break

		case "storeMythicShop":
			EmitUISound( "UI_Menu_Accept" )
			JumpToMythicSection( link )
			break

		case "rumble":
			EmitUISound( "UI_Menu_Accept" )
			GamemodeSelect_JumpToCups( null )
			break

		case "rankedrumble":

			EmitUISound( "UI_Menu_Accept" )
			RankedRumble_JumpToRumblePage()

			break


		case "newplayerpasstutorial":
			UI_OpenFeatureTutorialDialog( NEW_PLAYER_PASS_TUTORIAL )
			break

		case "newplayerpassinfo":
			OpenNewPlayerPassInfo()
			break

		case "newplayerchallengeinfo":
			OpenChallengesInfo()
			break

	}
}

string function GetLocationFromUMAction( UMAction action )
{
	foreach ( UMItem item in action.items )
	{
		if ( item.name == "Location" )
		{
			return item.value
		}
	}

	return ""
}

bool function IsValidUMAction( UMAction action, string uiLocation )
{
	if ( GetLocationFromUMAction( action ) == uiLocation )
	{
		return true
	}

	return false
}

#if DEV
void function DEV_PrintUMPromoData()
{
	UMData um = EADP_UM_GetPromoData()
	printt( "triggerId:", um.triggerId )
	printt( "triggerName:", um.triggerName )
	foreach( int i, UMAction action in um.actions )
	{
		printt( i, "action name:", action.name )
		printt( i, "action trackingId:", action.trackingId )
		foreach( int j, UMItem item in action.items )
		{
			printt( j, "item type:", item.type, "- name:", item.name )
			printt( j, "item value:", item.value )
			foreach( int k, UMAttribute attr in item.attributes )
			{
				printt( k, "attr key:", attr.key )
				printt( k, "attr value:", attr.value )
			}
		}
	}
}
#endif
