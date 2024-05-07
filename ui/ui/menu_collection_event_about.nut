global function CollectionEventAboutPage_Init
global function OpenCollectionEventAboutPage
global function OpenCollectionEventAboutPageWithEventTabTelemetry
global function OpenCollectionEventAboutPageWithMilestoneStoreTelemetry
global function SetCollectionEventAboutPageEvent
struct {
	var menu
	var infoPanel
	ItemFlavor ornull event
} file

void function CollectionEventAboutPage_Init( var menu )
{
	file.menu = menu
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CollectionEventAboutPage_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CollectionEventAboutPage_OnClose )

	file.infoPanel = Hud_GetChild( file.menu, "InfoPanel" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function CollectionEventAboutPage_OnOpen()
{
	ItemFlavor ornull eventToUse
	if ( file.event != null )
	{
		eventToUse = file.event
	}
	else
	{
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		ItemFlavor ornull milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
		eventToUse = activeCollectionEvent != null ? activeCollectionEvent : milestoneEvent
	}

	if ( eventToUse == null )
		return

	expect ItemFlavor( eventToUse )

	bool isCollectionEvent = eventToUse.typeIndex == eItemType.calevent_collection
	bool isMilestoneEvent = eventToUse.typeIndex == eItemType.calevent_milestone

	string eventName = ""
	asset bgPatternImage
	asset headerIcon
	vector specialTextCol
	array<string> aboutLines

	if ( isCollectionEvent )
	{
		eventName = ItemFlavor_GetLongName( eventToUse )
		bgPatternImage = CollectionEvent_GetBGPatternImage( eventToUse )
		headerIcon = CollectionEvent_GetHeaderIcon( eventToUse )
		specialTextCol = SrgbToLinear( CollectionEvent_GetAboutPageSpecialTextCol( eventToUse ) )
		aboutLines = CollectionEvent_GetAboutText( eventToUse, GRX_IsOfferRestricted() )
	}
	else if ( isMilestoneEvent )
	{
		eventName = ItemFlavor_GetLongName( eventToUse )
		headerIcon = MilestoneEvent_GetEventIcon( eventToUse )
		specialTextCol = SrgbToLinear( MilestoneEvent_GetDisclaimerBoxColor( eventToUse ) )
		aboutLines = MilestoneEvent_GetAboutText( eventToUse, GRX_IsOfferRestricted() )
	}

	Assert( aboutLines.len() < 8, "Rui about_collection_event does not support more than 8 lines." )
	HudElem_SetRuiArg( file.infoPanel, "eventName", eventName )
	HudElem_SetRuiArg( file.infoPanel, "bgPatternImage", bgPatternImage )
	HudElem_SetRuiArg( file.infoPanel, "headerIcon", headerIcon )
	HudElem_SetRuiArg( file.infoPanel, "specialTextCol", specialTextCol )

	foreach ( int lineIdx, string line in aboutLines )
	{
		if ( line == "" )
			continue

		string aboutLine = "%@embedded_bullet_point%" + Localize( line )
		HudElem_SetRuiArg( file.infoPanel, "aboutLine" + lineIdx, aboutLine )
	}
}


void function CollectionEventAboutPage_OnClose()
{
	RunClientScript( "UIToClient_StopBattlePassScene" )
}

void function OpenCollectionEventAboutPage( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	AdvanceMenu( GetMenu( "CollectionEventAboutPage" ) )
}

void function OpenCollectionEventAboutPageWithEventTabTelemetry( var button )
{
	RTKEventsPanelController_SendPageViewInfoPage( "aboutMilestoneDialog" )
	OpenCollectionEventAboutPage( button )
}

void function OpenCollectionEventAboutPageWithMilestoneStoreTelemetry( var button )
{
	StoreMilestoneEvents_SendPageViewInfoPage( "aboutMilestoneDialog" )
	OpenCollectionEventAboutPage( button )
}

void function SetCollectionEventAboutPageEvent( ItemFlavor ornull event )
{
	file.event = event
}
