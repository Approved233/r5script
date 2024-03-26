global function RTKEventsPanel_OnInitialize
global function RTKEventsPanel_OnDestroy
global function InitRTKEventsPanel
global function EventsPanel_SetOpenPageIndex
global function EventsPanel_GoToPage
global function EventsPanel_GetCurrentPageIndex
global function EventsPanel_CanStartCarouselThreads

global const string FEATURE_EVENT_SHOP_TUTORIAL = "event_shop"

global struct RTKEventsPanel_Properties
{
	rtk_panel verticalContainerContext
	rtk_behavior paginationBehavior
}

global struct RTKEventInfoModel
{
	string currentPageTitle
	string name
	string remainingDays
	int titleEndTimestamp
	string titleCounterLocalizationString
	vector titleCounterColor
	asset mainIcon
	asset leftCornerHeaderBg
	bool leftCornerHeaderBgBlur
	float leftCornerHeaderBGDarkening
	asset rightPanelBg
	vector rightPanelBgColor
	bool rightPanelBgBlur
	asset gridItemsBg
	int currencyInWallet
	asset currencyIcon
	string currencyShortName
	string currencyLongName
	vector leftCornerTitleColor
	vector leftCornerEventNameColor
	vector leftCornerTimeRemainingColor
	float backgroundDarkening
	float rightPanelDarkening
	float leftPanelDarkening
	bool leftPanelBlur
	vector barsColor
	vector tooltipsColor
	string nextSection
	string prevSection
}











global enum eEventsPanelPage
{
	LANDING = 0
	MILESTONES = 1
	COLLECTION = 2
	EVENT_SHOP = 3
}



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





void function RTKEventsPanel_OnInitialize( rtk_behavior self )
{
	if ( MilestoneEvent_IsEnabled() == false )
	{
		
		file.didInitialize = false
		return
	}

	if ( EventShop_GetCurrentActiveEventShop() == null )
	{
		
		file.didInitialize = false
		return
	}

	if ( !GRX_AreOffersReady() )
	{
		return
	}

	file.didInitialize = true

	rtk_struct activeEvents = RTKDataModelType_CreateStruct( RTK_MODELTYPE_COMMON, "activeEvents" )
	EventShop_BuildCommonModel( self, activeEvents )

	InstantiateActiveEventsPanels( self )
	SetUpPaginationBehavior( self )

	UpdateVGUIFooterButtons()
	UpdatePaginationButtonText( self )
	RegisterButtonPressedCallback( KEY_H, OpenCurrentPanelAdditionalInfo )
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
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#GIFT_INFO_TITLE", "#X_GIFT_INFO_TITLE", OpenGiftInfoPopUp )
#else
		file.secondFooter = AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#EVENTS_EVENT_SHOP_GET_CURRENCY", "#EVENTS_EVENT_SHOP_GET_CURRENCY", OpenEventShopTutorial )
		file.thirdFooter = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#GIFT_INFO_TITLE", "#Y_GIFT_INFO_TITLE", OpenGiftInfoPopUp )
#endif
	file.panel = panel

		InitRTKMilestoneEventMainPanel( panel )

}

void function EventShop_BuildCommonModel( rtk_behavior self, rtk_struct activeEvents )
{
	PrivateData p
	self.Private( p )

	rtk_array eventsArray   = RTKStruct_AddArrayOfStructsProperty(activeEvents, "events", "RTKEventInfoModel")

	if ( RTKArray_GetCount( eventsArray ) > 0 )
		RTKArray_Clear( eventsArray )

	ItemFlavor ornull activeEventShop = EventShop_GetCurrentActiveEventShop()
	file.activeEventShop = activeEventShop

	if ( activeEventShop == null )
		return

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

			
			RTKEventInfoModel infoModel
			infoModel.currentPageTitle = Localize("#EVENTS_EVENT_SHOP")
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
			infoModel.rightPanelBg = EventShop_GetRightPanelBackground( event )
			infoModel.rightPanelBgColor = EventShop_GetRightPanelBackgroundColor( event )
			infoModel.rightPanelBgBlur = EventShop_GetGlobalSettingsBool( event, "rightPanelBgBlur" )
			infoModel.rightPanelDarkening = EventShop_GetRightPanelOpacity( event )
			infoModel.gridItemsBg = EventShop_GetShopPageItemsBackground( event )
			infoModel.leftPanelDarkening = EventShop_GetLeftPanelOpacity( event )
			infoModel.leftPanelBlur = EventShop_GetGlobalSettingsBool( event, "leftPanelBlur" )
			infoModel.leftCornerHeaderBg = EventShop_GetLeftCornerHeaderBackground( event )
			infoModel.leftCornerHeaderBgBlur = EventShop_GetGlobalSettingsBool( event, "leftCornerHeaderBgBlur" )
			infoModel.leftCornerHeaderBGDarkening = EventShop_GetGlobalSettingsFloat( event, "leftCornerHeaderBGDarkening" )
			infoModel.leftCornerTitleColor = EventShop_GetLeftPanelTitleColor( event )
			infoModel.leftCornerEventNameColor = EventShop_GetLeftPanelEventNameColor( event )
			infoModel.leftCornerTimeRemainingColor = EventShop_GetLeftPanelTimeRemainingColor( event )
			infoModel.backgroundDarkening = EventShop_GetBackgroundDarkeningOpacity( event )
			infoModel.barsColor = EventShop_GetBarsColor( event )
			infoModel.tooltipsColor = EventShop_GeTooltipsColor( event )
			infoModel.nextSection = GetPaginationButtonText( false )
			infoModel.prevSection = GetPaginationButtonText( true )

			
			ItemFlavor ornull activeMilestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
			if ( activeMilestoneEvent )
			{
				expect ItemFlavor( activeMilestoneEvent )
				infoModel.backgroundDarkening = max(infoModel.backgroundDarkening, MilestoneEvent_GetGlobalSettingsFloat( activeMilestoneEvent, "backgroundDarkeningOpacity" ) )
			}

			
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

	p.rootCommonPath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_COMMON, "events", true, ["activeEvents"] )
	self.GetPanel().SetBindingRootPath( p.rootCommonPath + "[0]")
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
		if ( file.baseEvent != null )
		{
			RTKPanel_Instantiate( $"ui_rtk/menus/events/base_event_landing.rpak", context, LANDING_PAGE_NAME )
			count++
			file.enumToInstantiatedPage[ eEventsPanelPage.LANDING ] <- count
			file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.LANDING
		}











			file.milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
			if ( file.milestoneEvent != null )
			{
				RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_main_panel.rpak", context, MILESTONE_PAGE_NAME )
				RTKPanel_Instantiate( $"ui_rtk/menus/events/milestone/milestone_event_collection_panel.rpak", context, COLLECTION_PAGE_NAME )
				count++
				file.enumToInstantiatedPage[ eEventsPanelPage.MILESTONES ] <- count
				file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.MILESTONES
				count++
				file.enumToInstantiatedPage[ eEventsPanelPage.COLLECTION ] <- count
				file.indexToInstantiatedPage[ count ] <- eEventsPanelPage.COLLECTION

				thread ClearItemPreviewOnStart_Thread()
			}

		if ( file.activeEventShop != null )
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
		if ( file.currentPage < file.indexToInstantiatedPage.len() )
		{
			file.currentPage = file.indexToInstantiatedPage[file.currentPage]
		} 

		pagination.PropSetInt( "startPageIndex", file.currentPage )
		self.AutoSubscribe( pagination, "onScrollStarted", function () : ( self, pagination ) {
			file.currentPage = file.indexToInstantiatedPage[ RTKPagination_GetTargetPage( pagination ) ]
			file.previousPage = file.indexToInstantiatedPage[ RTKPagination_GetCurrentPage( pagination ) ]

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

void function EventsPanel_GoToPage( int page )
{
	if ( file.paginationBehavior != null )
	{
		rtk_behavior ornull pagination =  file.paginationBehavior
		expect rtk_behavior( pagination )

		UpdateMilestoneInstantiatedEnumMap()
		RTKPagination_GoToPage( pagination, file.enumToInstantiatedPage[page])
	}
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
			file.secondFooter.activateFunc = OpenCollectionEventAboutPage
#if PC_PROG_NX_UI
			file.thirdFooter.gamepadLabel = "#X_GIFT_INFO_TITLE"
			file.thirdFooter.mouseLabel = "#GIFT_INFO_TITLE"
#else
			file.thirdFooter.gamepadLabel = "#Y_GIFT_INFO_TITLE"
			file.thirdFooter.mouseLabel = "#GIFT_INFO_TITLE"
#endif
			file.thirdFooter.activateFunc = OpenGiftInfoPopUp
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
		OpenCollectionEventAboutPage( button )
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
	PrivateData p
	self.Private( p )
	rtk_struct eventsStruct = RTKDataModel_GetStruct( p.rootCommonPath + "[0]" )
	RTKStruct_SetString( eventsStruct, "nextSection", GetPaginationButtonText( false ) )
	RTKStruct_SetString( eventsStruct, "prevSection", GetPaginationButtonText( true ) )
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
				thread AutoAdvanceFeaturedItems_Tracking()
				thread AutoAdvanceFeaturedItems_Collection()
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
		file.enumToInstantiatedPage[ eEventsPanelPage.COLLECTION ] <- count++
	}

	file.activeEventShop = EventShop_GetCurrentActiveEventShop()
	if ( file.activeEventShop != null )
	{
		file.enumToInstantiatedPage[ eEventsPanelPage.EVENT_SHOP ] <- count++
	}
}