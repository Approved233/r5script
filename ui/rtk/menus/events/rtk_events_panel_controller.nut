global function RTKEventsPanel_OnInitialize
global function RTKEventsPanel_OnDestroy
global function InitRTKEventsPanel
global function EventsPanel_SetOpenPageIndex
global function EventsPanel_GoToPage
global function EventsPanel_GetCurrentPageIndex
global function EventsPanel_CanStartCarouselThreads
global function GetEventGiftButtonState
global function GetEventPurchaseButtonState
global function EventsPanel_SaveDeepLink

global function RTKEventsPanelController_SendPageViewEventOffer
global function RTKEventsPanelController_SendPageViewInfoPage
global function RTKEventsPanelController_SendPageViewPurchaseDialog

global const string FEATURE_EVENT_SHOP_TUTORIAL = "event_shop"

global struct RTKEventsPanel_Properties
{
	rtk_panel verticalContainerContext
	rtk_behavior paginationBehavior
}

global struct RTKBaseEventModel
{
	string name
	string remainingDays
	int titleEndTimestamp
	string titleCounterLocalizationString
	vector titleCounterColor
	asset mainIcon
	string nextSection
	string prevSection
	SettingsAssetGUID calEventBase
}

global struct RTKEventShopInfoModel
{
	string currentPageTitle
	string eventTitleText
	string name
	string remainingDays
	int titleEndTimestamp
	string titleCounterLocalizationString
	vector titleCounterColor
	asset mainIcon
	int currencyInWallet
	asset currencyIcon
	string currencyShortName
	string currencyLongName
	vector barsColor
	vector tooltipsColor
	SettingsAssetGUID calEventShop
}











global enum eEventsPanelPage
{
	LANDING = 0
	MILESTONES = 1
	COLLECTION = 2
	EVENT_SHOP = 3
}


global enum eEventGiftingButtonState
{
	AVAILABLE,
	UNAVAILABLE,
	GIFTING_EXCEEDED,
	NOT_ENOUGH_LEVEL,
	TWO_FACTOR_DISABLED
}

global enum eEventPackPurchaseButtonState
{
	AVAILABLE,
	COMPLETED,
	UNAVAILABLE
}

global const string NAV_TYPE_CLICK = "click"
global const string NAV_TYPE_DEEPLINK = "deeplink"

struct PrivateData
{
	string rootCommonPath = ""
}

struct
{
	ItemFlavor ornull baseEvent



	ItemFlavor ornull activeEventShop
	ItemFlavor ornull milestoneEvent
	var               panel
	bool              registeredSweepstakesFooterCallback
	bool              registeredSweepstakesKeyboardCallback
	bool              didInitialize = false
	int               currentPage = 0
	int               previousPage = 0
	rtk_behavior ornull paginationBehavior
	InputDef& secondFooter
	InputDef& thirdFooter

	table<int,int> enumToInstantiatedPage
	table<int,int> indexToInstantiatedPage

} file

struct
{
	string pageName
	string prevPage

	int prevPageDuration
	int prevPageTimeStamp
	int pageNum
	int sectionNum
	string linkName
	string clickType

	string eventName
} fileTelemetry

const string LANDING_PAGE_NAME = "Landing Page"
const string MILESTONE_PAGE_NAME = "Tracking Page"
const string COLLECTION_PAGE_NAME = "Collection Page"
const string EVENT_SHOP_NAME = "Event Shop Page"





bool function EventsPanel_IsPlaylistVarEnabled()
{
	return GetCurrentPlaylistVarBool( "enable_events_panel", true )
}

void function RTKEventsPanel_OnInitialize( rtk_behavior self )
{
	SetStoreOnlyEventsFilter( false )

	if ( EventsPanel_IsPlaylistVarEnabled() == false )
	{
		
		file.didInitialize = false
		return
	}


	if ( EventShop_GetCurrentActiveEventShop() == null )
	{
		
		Warning("RTKEventsPanel_OnInitialize: no active event shop")
		file.didInitialize = false
		return
	}









	if ( !GRX_AreOffersReady() )
	{
		return
	}

	file.didInitialize = true

	rtk_struct activeEvents = RTKDataModelType_CreateStruct( RTK_MODELTYPE_COMMON, "activeEvents" )
	BuildBaseModel( self, activeEvents )
	BuildEventShopModel( self, activeEvents )

	InstantiateActiveEventsPanels( self )
	SetUpPaginationBehavior( self )

	UpdateVGUIFooterButtons()
	UpdatePaginationButtonText( self )
	RegisterButtonPressedCallback( KEY_H, OpenCurrentPanelAdditionalInfo )

	RTKEventsPanelController_SaveTelemetryData( self )

	if ( fileTelemetry.linkName != "" )
	{
		fileTelemetry.clickType = NAV_TYPE_DEEPLINK
	}

	RTKEventsPanelController_SendPageViewEvent( self )
	fileTelemetry.linkName = ""
}

void function RTKEventsPanel_OnDestroy( rtk_behavior self )
{
	if ( file.didInitialize == false )
	{
		
		return
	}

	file.didInitialize = false

	DeregisterButtonPressedCallback( KEY_H, OpenCurrentPanelAdditionalInfo )

	if ( file.registeredSweepstakesKeyboardCallback )
	{
		DeregisterButtonPressedCallback( KEY_E, OpenSweepstakesRules )
		file.registeredSweepstakesKeyboardCallback = false
	}
	rtk_behavior ornull pagination = self.PropGetBehavior( "paginationBehavior" )
	if ( pagination != null )
	{
		expect rtk_behavior( pagination )
		file.currentPage = RTKPagination_GetCurrentPage( pagination ) 
	}
	RunClientScript( "ClearBattlePassItem" )
}


void function InitRTKEventsPanel( var panel )
{
	AddCallback_UI_FeatureTutorialDialog_PopulateTabsForMode( EventShop_PopulateAboutText, FEATURE_EVENT_SHOP_TUTORIAL )
	AddCallback_UI_FeatureTutorialDialog_SetTitle( EventShop_PopulateAboutTitle, FEATURE_EVENT_SHOP_TUTORIAL )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

#if PC_PROG_NX_UI
		file.secondFooter = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#EVENTS_EVENT_SHOP_GET_CURRENCY", "#EVENTS_EVENT_SHOP_GET_CURRENCY", OpenEventShopTutorial )
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#GIFT_INFO_TITLE", "#X_GIFT_INFO_TITLE", OpenGiftInfoPopUpWithEventTabTelemetry )
#else
		file.secondFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#EVENTS_EVENT_SHOP_GET_CURRENCY", "#EVENTS_EVENT_SHOP_GET_CURRENCY", OpenEventShopTutorial )
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#GIFT_INFO_TITLE", "#Y_GIFT_INFO_TITLE", OpenGiftInfoPopUpWithEventTabTelemetry )
#endif
	file.panel = panel

		InitRTKMilestoneEventMainPanel( panel )

}

void function BuildBaseModel( rtk_behavior self, rtk_struct activeEvents )
{
	rtk_struct baseEventModelStruct = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "baseEvent", "RTKBaseEventModel" )

	ItemFlavor ornull event = GetActiveBaseEvent( GetUnixTimestamp() )
	if ( event == null )
	{
		Warning("BuildBaseModel: no active base event")
		return
	}

	expect ItemFlavor( event )

	DisplayTime dt = SecondsToDHMS( maxint( 0, CalEvent_GetFinishUnixTime( event ) - GetUnixTimestamp() ) )

	RTKBaseEventModel infoModel
	infoModel.calEventBase = event.guid
	infoModel.name = ItemFlavor_GetShortName( event )
	infoModel.mainIcon = $""
	infoModel.remainingDays = Localize( GetDaysHoursRemainingLoc( dt.days, dt.hours ), dt.days, dt.hours )
	infoModel.titleEndTimestamp = CalEvent_GetFinishUnixTime( event )
	infoModel.titleCounterLocalizationString =  "#TIME_REMAINING"
	infoModel.titleCounterColor = <0.88, 0.79, 0.49>
	infoModel.nextSection = GetPaginationButtonText( false )
	infoModel.prevSection = GetPaginationButtonText( true )

	RTKStruct_SetValue( baseEventModelStruct, infoModel )
}

void function BuildEventShopModel( rtk_behavior self, rtk_struct activeEvents )
{
	PrivateData p
	self.Private( p )

	ItemFlavor ornull activeEventShop = EventShop_GetCurrentActiveEventShop()
	file.activeEventShop = activeEventShop

	if ( activeEventShop == null )
	{
		return
	}

	rtk_array eventsArray   = RTKStruct_GetOrCreateScriptArrayOfStructs(activeEvents, "events", "RTKEventShopInfoModel")

	if ( RTKArray_GetCount( eventsArray ) > 0 )
		RTKArray_Clear( eventsArray )

	expect ItemFlavor( activeEventShop )

	
	
	array<ItemFlavor> eventSections = [ activeEventShop ]

	foreach (ItemFlavor ornull event in eventSections)
	{
		if (event != null)
		{
			expect ItemFlavor( event )

			rtk_struct eventArrayItem = RTKArray_PushNewStruct( eventsArray )

			DisplayTime dt = SecondsToDHMS( maxint( 0, CalEvent_GetFinishUnixTime( event ) - GetUnixTimestamp() ) )

			array<int> resetTimestamps = EventShop_GetWeeklyResetsTimestamps( activeEventShop )

			RTKEventShopInfoModel infoModel
			infoModel.calEventShop = event.guid
			infoModel.currentPageTitle = Localize("#EVENTS_EVENT_SHOP")
			infoModel.eventTitleText = ItemFlavor_GetShortName( event )
			infoModel.name = ItemFlavor_GetShortName( event )
			infoModel.remainingDays = Localize( GetDaysHoursRemainingLoc( dt.days, dt.hours ), dt.days, dt.hours )
			infoModel.titleEndTimestamp = resetTimestamps.len() > 0 ? resetTimestamps[0] : 0
			infoModel.titleCounterLocalizationString =  resetTimestamps.len() > 1 ? "#NEW_ITEMS_IN" : "#TIME_REMAINING"
			infoModel.titleCounterColor = resetTimestamps.len() > 1 ? <0.88, 0.79, 0.49> : <0.62, 0.62, 0.62>
			infoModel.mainIcon = EventShop_GetEventMainIcon( event )
			infoModel.currencyInWallet = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), EventShop_GetEventShopGRXCurrency() )
			infoModel.currencyIcon = ItemFlavor_GetIcon( EventShop_GetEventShopCurrency( event ) )
			infoModel.currencyShortName = ItemFlavor_GetShortName( EventShop_GetEventShopCurrency( event ) )
			infoModel.currencyLongName = ItemFlavor_GetLongName( EventShop_GetEventShopCurrency( event ) )
			infoModel.barsColor = EventShop_GetBarsColor( event )
			infoModel.tooltipsColor = EventShop_GeTooltipsColor( event )

			RTKStruct_SetValue( eventArrayItem, infoModel )
		}
	}

	if ( EventShop_HasSweepstakesOffers( activeEventShop ) )
	{
		if ( file.registeredSweepstakesFooterCallback == false )
		{
#if PC_PROG_NX_UI
				AddPanelFooterOption( file.panel, LEFT, BUTTON_X, true, "#EVENTS_EVENT_SHOP_SWEEPSTAKES_RULES", "#EVENTS_EVENT_SHOP_SWEEPSTAKES_RULES", OpenSweepstakesRules )
#else
				AddPanelFooterOption( file.panel, LEFT, BUTTON_Y, true, "#EVENTS_EVENT_SHOP_SWEEPSTAKES_RULES", "#EVENTS_EVENT_SHOP_SWEEPSTAKES_RULES", OpenSweepstakesRules )
#endif
			file.registeredSweepstakesFooterCallback = true
		}

		if ( file.registeredSweepstakesKeyboardCallback == false )
		{
			RegisterButtonPressedCallback( KEY_E, OpenSweepstakesRules )
			file.registeredSweepstakesKeyboardCallback = true
		}
	}
}

array<featureTutorialTab> function EventShop_PopulateAboutText()
{
	array<featureTutorialTab> tabs
	featureTutorialTab tab1
	array<featureTutorialData> tab1Rules

	
	tab1.tabName = 	"#GAMEMODE_RULES_OVERVIEW_TAB_NAME"

	ItemFlavor ornull activeEventShop = EventShop_GetCurrentActiveEventShop()
	if ( activeEventShop != null )
		foreach ( EventShopTutorialData tutorial in EventShop_GetTutorials( expect ItemFlavor( activeEventShop ) ) )
			tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( tutorial.title, tutorial.desc, tutorial.icon ) )

	tab1.rules = tab1Rules
	tabs.append( tab1 )

	return tabs
}

string function EventShop_PopulateAboutTitle()
{
	return "#EVENTS_EVENT_SHOP"
}

void function OpenEventShopTutorial( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	UI_OpenFeatureTutorialDialog( FEATURE_EVENT_SHOP_TUTORIAL )
}

void function OpenSweepstakesRules( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	UI_OpenEventShopSweepstakesRulesDialog()
}

void function EventsPanel_SetOpenPageIndex( int page )
{
	UpdateMilestoneInstantiatedEnumMap()
	file.currentPage = file.enumToInstantiatedPage[page]
}

int function EventsPanel_GetCurrentPageIndex()
{
	return file.currentPage
}

void function ClearItemPreviewOnStart_Thread()
{
	WaitFrame()
	UpdateDefaultItemPreviews()
}

void function InstantiateActiveEventsPanels( rtk_behavior self )
{
	rtk_panel ornull context = self.PropGetPanel( "verticalContainerContext" )
	if ( context != null )
	{
		expect rtk_panel( context )
		file.baseEvent = GetActiveBaseEvent( GetUnixTimestamp() )
		int count = -1
		
		if ( file.baseEvent != null && BaseEvent_IsEnabled() )
		{
			RTKPanel_Instantiate( $"ui_rtk/menus/events/base_event_landing.rpak", context, LANDING_PAGE_NAME )
			count++
			file.enumToInstantiatedPage[ eEventsPanelPage.LANDING ] <- count
			file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.LANDING
		}












			file.milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
			
			if ( file.milestoneEvent != null && MilestoneEvent_IsPlaylistVarEnabled() )
			{
				if ( !MilestoneEvent_UseOriginalEventTabLayout() )
				{
					RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_panel.rpak", context, "Milestone Event" )
					count++
					file.enumToInstantiatedPage[ eEventsPanelPage.MILESTONES ] <- count
					file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.MILESTONES
				}
				else
				{
					RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_main_panel.rpak", context, MILESTONE_PAGE_NAME )
					RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_collection_panel.rpak", context, COLLECTION_PAGE_NAME )
					count++
					file.enumToInstantiatedPage[ eEventsPanelPage.MILESTONES ] <- count
					file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.MILESTONES
					count++
					file.enumToInstantiatedPage[ eEventsPanelPage.COLLECTION ] <- count
					file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.COLLECTION
				}

				thread ClearItemPreviewOnStart_Thread()
			}

		file.activeEventShop = EventShop_GetCurrentActiveEventShop()
		
		if ( file.activeEventShop != null && EventShop_IsPlaylistVarEnabled()  )
		{
			RTKPanel_Instantiate( $"ui_rtk/menus/events/events_event_shop.rpak", context, EVENT_SHOP_NAME )
			count++
			file.enumToInstantiatedPage[ eEventsPanelPage.EVENT_SHOP ] <- count
			file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.EVENT_SHOP
		}
	}
}

void function SetUpPaginationBehavior( rtk_behavior self )
{
	rtk_behavior ornull pagination = self.PropGetBehavior( "paginationBehavior" )
	if ( pagination != null )
	{
		expect rtk_behavior( pagination )
		file.paginationBehavior = pagination
		






		pagination.PropSetInt( "startPageIndex", file.currentPage )
		self.AutoSubscribe( pagination, "onScrollStarted", function () : ( self, pagination ) {

			int targetPageIndex = RTKPagination_GetTargetPage( pagination )
			if (targetPageIndex < file.indexToInstantiatedPage.len())
			{
				file.currentPage = file.indexToInstantiatedPage[ targetPageIndex ]
			}

			int currentPageIndex = RTKPagination_GetCurrentPage( pagination )
			if (currentPageIndex < file.indexToInstantiatedPage.len())
			{
				file.previousPage = file.indexToInstantiatedPage[ currentPageIndex ]
			}

			UpdateDefaultItemPreviews()
			UpdateVGUIFooterButtons()
			UpdatePaginationButtonText( self )
		} )

		self.AutoSubscribe( pagination, "onScrollFinished", function () : ( self, pagination ) {
			UpdateDefaultItemPreviews()
			RTKMilestoneEvent_OnScrollFinished( self )
		} )
	}
}

void function RTKMilestoneEvent_OnScrollFinished( rtk_behavior self )
{
	rtk_behavior pagination = self.PropGetBehavior( "paginationBehavior" )

	
	fileTelemetry.clickType = RTKPagination_GetLastNavType( pagination )
	fileTelemetry.linkName = ""
	RTKEventsPanelController_SaveTelemetryData( self )
	RTKEventsPanelController_SendPageViewEvent( self )
}

void function RTKEventsPanelController_SaveTelemetryData( rtk_behavior self )
{
	int pageNum = file.currentPage
	string pageName = self.GetPanel().GetName()

	fileTelemetry.prevPage = fileTelemetry.pageName
	fileTelemetry.pageName = GetEnumString( "eEventsPanelPage", file.currentPage )
	fileTelemetry.prevPageDuration = int( UITime() ) - fileTelemetry.prevPageTimeStamp
	fileTelemetry.prevPageTimeStamp = int ( UITime() )
	fileTelemetry.sectionNum = pageNum 
	fileTelemetry.pageNum = 0

	fileTelemetry.eventName = ""
	ItemFlavor ornull currentMilestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( currentMilestoneEvent != null )
	{
		expect ItemFlavor( currentMilestoneEvent )

		fileTelemetry.eventName = ItemFlavor_GetLongName( currentMilestoneEvent )
	}

	ItemFlavor ornull currentCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
	if ( currentCollectionEvent != null )
	{
		expect ItemFlavor( currentCollectionEvent )

		fileTelemetry.eventName = ItemFlavor_GetLongName( currentCollectionEvent )
	}
}

void function RTKEventsPanelController_SendPageViewEvent( rtk_behavior self )
{
	PIN_PageView_EventsTab( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.sectionNum, fileTelemetry.pageNum, fileTelemetry.linkName, fileTelemetry.clickType,
		fileTelemetry.eventName )
}

void function RTKEventsPanelController_SendPageViewEventOffer( rtk_behavior self, int buttonIndex, string offerName, bool isReward = false  )
{
	PIN_PageView_EventsTabOffer( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		buttonIndex, fileTelemetry.linkName, fileTelemetry.clickType, fileTelemetry.eventName, offerName, isReward )
}

void function RTKEventsPanelController_SendPageViewInfoPage( string infoPageName )
{
	PIN_PageView_EventsTabMilestoneInfoPage( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.pageNum, infoPageName, fileTelemetry.clickType, fileTelemetry.eventName )
}

void function RTKEventsPanelController_SendPageViewPurchaseDialog( bool asGift )
{
	PIN_PageView_EventsTabMilestoneViewPurchasePanel( fileTelemetry.pageName, fileTelemetry.prevPageDuration, fileTelemetry.prevPage,
		fileTelemetry.pageNum, fileTelemetry.clickType, fileTelemetry.eventName, asGift )
}

void function EventsPanel_GoToPage( int page )
{
	if ( file.paginationBehavior != null )
	{
		rtk_behavior ornull pagination =  file.paginationBehavior
		expect rtk_behavior( pagination )

		UpdateMilestoneInstantiatedEnumMap()
		RTKPagination_GoToPage( pagination, file.enumToInstantiatedPage[page], NAV_TYPE_CLICK )
	}
}

void function EventsPanel_SaveDeepLink( string link )
{
	fileTelemetry.linkName = link
}

bool function EventsPanel_CanStartCarouselThreads()
{
	return EventsPanel_GetCurrentPageIndex() == eEventsPanelPage.COLLECTION || EventsPanel_GetCurrentPageIndex() == eEventsPanelPage.MILESTONES
}

void function UpdateVGUIFooterButtons()
{
	file.thirdFooter.gamepadLabel = ""
	file.thirdFooter.mouseLabel = ""
	file.thirdFooter.activateFunc = null

	switch ( file.currentPage )
	{
		case eEventsPanelPage.LANDING: 
		{
			
			file.secondFooter.gamepadLabel = ""
			file.secondFooter.mouseLabel = ""
			file.secondFooter.activateFunc = null
			break
		}
		case eEventsPanelPage.MILESTONES: 
		{
			file.secondFooter.mouseLabel = "#MILESTONE_BUTTON_EVENT_INFO"
			file.secondFooter.gamepadLabel = "#MILESTONE_BUTTON_EVENT_INFO"
			file.secondFooter.activateFunc = OpenCollectionEventAboutPageWithEventTabTelemetry
#if PC_PROG_NX_UI
			file.thirdFooter.gamepadLabel = "#X_GIFT_INFO_TITLE"
			file.thirdFooter.mouseLabel = "#GIFT_INFO_TITLE"
#else
			file.thirdFooter.gamepadLabel = "#Y_GIFT_INFO_TITLE"
			file.thirdFooter.mouseLabel = "#GIFT_INFO_TITLE"
#endif
			file.thirdFooter.activateFunc = OpenGiftInfoPopUpWithEventTabTelemetry
			break
		}
		case eEventsPanelPage.COLLECTION: 
		{
			
			file.secondFooter.gamepadLabel = ""
			file.secondFooter.mouseLabel = ""
			file.secondFooter.activateFunc = null
			break
		}












		case eEventsPanelPage.EVENT_SHOP: 
		{
			file.secondFooter.mouseLabel = "#EVENTS_EVENT_SHOP_GET_CURRENCY"
			file.secondFooter.gamepadLabel = "#EVENTS_EVENT_SHOP_GET_CURRENCY"
			file.secondFooter.activateFunc = OpenEventShopTutorial
			break
		}
	}
	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )
	UpdateFooterOptions()
}

void function OpenCurrentPanelAdditionalInfo( var button )
{
	if ( file.currentPage == eEventsPanelPage.MILESTONES ) 
	{
		SetCollectionEventAboutPageEvent( file.milestoneEvent )
		OpenCollectionEventAboutPageWithEventTabTelemetry( button )
	}







	else if ( file.currentPage == eEventsPanelPage.EVENT_SHOP ) 
	{
		OpenEventShopTutorial( button )
	}
}

string function GetPaginationButtonText( bool isPrev )
{
	switch ( file.currentPage )
	{
		case eEventsPanelPage.LANDING: 
		{






			if ( GRX_IsOfferRestricted() )
			{
				return isPrev ? "" : "#S19ME01_LANDING_PAGE_BUTTON_PACKS_NAME_RESTRICTED"
			}
			else
			{
				return isPrev ? "" : "#S19ME01_LANDING_PAGE_BUTTON_PACKS_NAME"
			}
			break
		}
		case eEventsPanelPage.MILESTONES: 
		{






			return isPrev ? "#S19ME01_LANDING_PAGE_BUTTON_LANDING_NAME" : "#S19ME01_LANDING_PAGE_BUTTON_COLLECTION_NAME"
			break
		}
		case eEventsPanelPage.COLLECTION: 
		{
			if ( GRX_IsOfferRestricted() )
			{
				return isPrev ? "#S19ME01_LANDING_PAGE_BUTTON_PACKS_NAME_RESTRICTED" : "#S19ME01_LANDING_PAGE_BUTTON_SHOP_NAME"
			}
			else
			{
				return isPrev ? "#S19ME01_LANDING_PAGE_BUTTON_PACKS_NAME" : "#S19ME01_LANDING_PAGE_BUTTON_SHOP_NAME"
			}
			break
		}










		case eEventsPanelPage.EVENT_SHOP: 
		{
			return isPrev ? "#S19ME01_LANDING_PAGE_BUTTON_COLLECTION_NAME" : ""
			break
		}
	}
	return "#PLAYER_SEARCH_NOT_FOUND"
}

void function UpdatePaginationButtonText( rtk_behavior self )
{
	rtk_struct baseEventModelStruct = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "baseEvent", "RTKBaseEventModel" )
	RTKStruct_SetString( baseEventModelStruct, "nextSection", GetPaginationButtonText( false ) )
	RTKStruct_SetString( baseEventModelStruct, "prevSection", GetPaginationButtonText( true ) )
}

void function UpdateDefaultItemPreviews()
{
	if ( CanRunClientScript() )
	{
		if ( file.currentPage == eEventsPanelPage.MILESTONES || file.currentPage == eEventsPanelPage.COLLECTION )
		{
			if ( file.previousPage != eEventsPanelPage.MILESTONES && file.previousPage != eEventsPanelPage.COLLECTION )
			{
				Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )

				if ( MilestoneEvent_UseOriginalEventTabLayout() )
				{
					thread AutoAdvanceFeaturedItems_Tracking()
					thread AutoAdvanceFeaturedItems_Collection()
				}
			}
		}
		else if ( file.currentPage == eEventsPanelPage.EVENT_SHOP )
		{
			Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )
			EventShop_UpdatePreviewedOffer()
		}
		else
		{
			Signal( uiGlobal.signalDummy, "EndAutoAdvanceFeaturedItems" )
			RunClientScript( "UIToClient_StopBattlePassScene" )
		}
	}
}

void function UpdateMilestoneInstantiatedEnumMap()
{
	file.baseEvent = GetActiveBaseEvent( GetUnixTimestamp() )
	int count = 0
	if ( file.baseEvent != null )
	{
		file.enumToInstantiatedPage[ eEventsPanelPage.LANDING ] <- count++
	}








	file.milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( file.milestoneEvent != null )
	{
		file.enumToInstantiatedPage[ eEventsPanelPage.MILESTONES ] <- count++

		if ( MilestoneEvent_UseOriginalEventTabLayout() )
			file.enumToInstantiatedPage[ eEventsPanelPage.COLLECTION ] <- count++
	}

	file.activeEventShop = EventShop_GetCurrentActiveEventShop()
	if ( file.activeEventShop != null )
	{
		file.enumToInstantiatedPage[ eEventsPanelPage.EVENT_SHOP ] <- count++
	}
}

int function GetEventPurchaseButtonState( array<GRXScriptOffer> offers )
{
	if ( offers.len() == 0 )
		return eEventPackPurchaseButtonState.UNAVAILABLE

	if ( offers[0].ineligibilityCode == eIneligibilityCode.PURCHASE_CONDITIONS )
		return eEventPackPurchaseButtonState.COMPLETED

	if ( !GRXOffer_IsEligibleForPurchase( offers[0] ) )
		return eEventPackPurchaseButtonState.UNAVAILABLE

	return eEventPackPurchaseButtonState.AVAILABLE
}

int function GetEventGiftButtonState( array<GRXScriptOffer> offers )
{
	if ( offers.len() < 1 )
	{
		return eEventGiftingButtonState.UNAVAILABLE
	}

	if ( !IsPlayerLeveledForGifting() )
	{
		return eEventGiftingButtonState.NOT_ENOUGH_LEVEL
	}
	else if ( !IsTwoFactorAuthenticationEnabled() )
	{
		return eEventGiftingButtonState.TWO_FACTOR_DISABLED
	}
	else if ( !IsPlayerWithinGiftingLimit() )
	{
		return eEventGiftingButtonState.GIFTING_EXCEEDED
	}
	return eEventGiftingButtonState.AVAILABLE
}