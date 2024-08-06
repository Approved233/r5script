global function InitPostGameCupsMenu
global function InitPostGameCupsPanel
global function OpenCupsSummary

struct
{
	var  menu
	var  continueButton
	bool buttonsRegistered = false
} file

void function InitPostGameCupsMenu( var newMenuArg )
{
	var menu = GetMenu( "PostGameCupsMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameCupsMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameCupsMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameCupsMenu_Hide )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	file.continueButton = Hud_GetChild( file.menu, "ContinueButton" )
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )

	
	TabDef tabDef = AddTab( file.menu, Hud_GetChild( file.menu, "PostGameCupsPanel" ), "#GAMEMODE_APEX_CUPS_TAB" )
	SetTabBaseWidth( tabDef, 250 )

	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	tabData.bannerHeader = ""
	tabData.bannerTitle = "#MATCH_SUMMARY"
	tabData.callToActionWidth = 700

	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.STANDARD )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", CloseCupsSummary )

	RegisterSignal( "OnPostGameCupsMenu_Close" )

#if DEV
		AddMenuThinkFunc( file.menu, PostGameCupsMenuAutomationThink )
#endif
}

void function InitPostGameCupsPanel( var panel )
{
	
}

#if DEV
void function PostGameCupsMenuAutomationThink( var menu )
{
	if ( AutomateUi() )
	{
		printt("PostGameCupsMenuAutomationThink OnContinue_Activate()")
		OnContinue_Activate( null )
	}
}
#endif

void function OnPostGameCupsMenu_Open()
{
	Lobby_AdjustScreenFrameToMaxSize( Hud_GetChild( file.menu, "ScreenFrame" ), true )

	var matchRankRui = Hud_GetRui( Hud_GetChild( file.menu, "MatchRank" ) )
	PopulateMatchRank( matchRankRui )

	TabData tabData = GetTabDataForPanel( file.menu )
	TabDef tabDef = Tab_GetTabDefByBodyName( tabData, "PostGameCupsPanel" )
	tabDef.enabled = true
	tabDef.visible = true
	ActivateTab( tabData, 0 )
}

void function OnPostGameCupsMenu_Show()
{
	thread _Show()
}

void function _Show()
{
	printt( "[CupUI] post game cups show" )
	Signal( uiGlobal.signalDummy, "OnPostGameCupsMenu_Close" )
	EndSignal( uiGlobal.signalDummy, "OnPostGameCupsMenu_Close" )

	if ( !IsFullyConnected() )
		return

	if ( !IsPersistenceAvailable() )
		return

	Assert( GetPanelTabs( file.menu ).len() > 0, "Panel has no tabs." )
	GetPanelTabs( file.menu )[0].title = Cups_GetProperTabTitleName()
	UpdateMenuTabs()

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	float maxTimeToWaitForLoadScreen = UITime() + LOADSCREEN_FINISHED_MAX_WAIT_TIME
	while(  UITime() < maxTimeToWaitForLoadScreen && !IsLoadScreenFinished()  ) 
		WaitFrame()

	bool isFirstTime = GetPersistentVarAsInt( "showGameSummary" ) != 0

	string postMatchSurveyMatchId = string( GetPersistentVar( "postMatchSurveyMatchId" ) )
	float postMatchSurveySampleRateLowerBound = expect float( GetPersistentVar( "postMatchSurveySampleRateLowerBound" ) )
	if ( isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME, postMatchSurveyMatchId, postMatchSurveySampleRateLowerBound ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
			WaitFrame()
	}

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}
}

void function OnContinue_Activate( var button )
{
	CloseCupsSummary( null )
}

void function OnPostGameCupsMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "OnPostGameCupsMenu_Close" )

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = false
	}
}

void function OnNavigateBack()
{
	CloseCupsSummary( null )
}

void function CloseCupsSummary( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

void function OpenCupsSummary()
{
	thread OpenCupsSummaryThread()
}

void function OpenCupsSummaryThread()
{
	while ( IsDialog( GetActiveMenu() ) )
		WaitFrame()
	AdvanceMenu( file.menu )
}
