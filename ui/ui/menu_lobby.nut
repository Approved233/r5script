global function InitLobbyMenu

global function Lobby_IsInputBlocked
global function SetActiveLobbyPopup
global function ClearActiveLobbyPopup
global function HasActiveLobbyPopup
global function SetNewsButtonTooltip
global function PostGameFlow
global function LobbyMenu_OpenDefaultTab
global function LobbyMenu_IsDefaultTabOpen

global function Lobby_UpdateSelectedPlaylistUsingUISlot
global function GetLobbyMenuOpenedTime
global function UpdateEventTabVisibility
global function UpdateSeasonTabVisibility


global function Lobby_EnableMinimapCoordsOnConnect


global function Lobby_AdjustScreenFrameToMaxSize
global function Lobby_AdjustBlackBarsFrameToMaxSize
global const int LOBBY_MENU_MAX_WIDTH = 2700
global const int LOBBY_STORE_MENU_MAX_WIDTH = 2224


global const int LOBBY_PLAY_TAB_WIDTH = 145
global const int LOBBY_EVENT_TAB_WIDTH = 170
global const int LOBBY_SEASONAL_TAB_WIDTH = 235

global struct LobbyPopup
{
	bool functionref( int inputID ) checkBlocksInput
	bool functionref( int inputID ) handleInput
	void functionref()              onClose
}

struct
{
	var  menu
	bool updatingLobbyUI = false
	bool inputsRegistered = false
	bool tabsInitialized = false
	bool newnessInitialized = false
	bool hasFocusedNews = false

	var postGameButton
	var newsButton
	var newsButtonStatusIcon
	var socialButton
	var gameMenuButton
	var bonusXp
	var socialEventPopup
	var serverDebugID
	var dx12BetaText

	int nextRotationTime = -1



	bool hasNewGifts = false

	bool firstSessionEntry = true
	string lastPlayedAudioPlaylist = ""

	LobbyPopup ornull  activeLobbyPopup = null
	table< int, bool > isInputBlocked

	TabDef& playPanelTabDef
	TabDef& eventsPanelTabDef
	TabDef& seasonalPanelTabDef

	float lobbyMenuOpenTime
} file


void function Lobby_EnableMinimapCoordsOnConnect( string name )
{
	int forceWatermarkInLobby = GetCurrentPlaylistVarInt( "force_watermark_in_lobby", 0 ) 
	int forceHiddenWatermarkInLobby = GetCurrentPlaylistVarInt( "force_hidden_watermark_in_lobby", 0 ) 
	if ( (forceWatermarkInLobby == 0 && IsTakeHomeBuild()) || forceWatermarkInLobby == 1 )
	{
		var minimapCoords = Hud_GetChild( file.menu, "MinimapCoords" )
		Hud_SetVisible( minimapCoords, true )
		Hud_SetEnabled( minimapCoords, true )

		var minimapCoordsRui = Hud_GetRui( minimapCoords )
		InitializeMinimapCoords( minimapCoordsRui, true )
		RuiSetString( minimapCoordsRui, "name", name )

		float watermarkTextScale = GetCurrentPlaylistVarFloat( "watermark_text_scale", 0.5 )
		float watermarkAlphaScale = GetCurrentPlaylistVarFloat( "watermark_alpha_scale", 0.2 )
		RuiSetFloat( minimapCoordsRui, "watermarkTextScale", watermarkTextScale )
		RuiSetFloat( minimapCoordsRui, "watermarkAlphaScale", watermarkAlphaScale )
	}
	if ( (forceHiddenWatermarkInLobby == 0 && IsTakeHomeBuild()) || forceHiddenWatermarkInLobby == 1 )
	{
		var minimapID = Hud_GetChild( file.menu, "MinimapID" )
		Hud_SetVisible( minimapID, true )
		Hud_SetEnabled( minimapID, true )

		var minimapIDRui = Hud_GetRui( minimapID )
		RuiSetString( minimapIDRui, "name", GetPlayerName() )
		RuiSetString( minimapIDRui, "uid", GetUIDHex() )
	}
}

void function Lobby_RefreshMinimapCoords()
{
	if ( IsLobby() && IsFullyConnected() )
	{
		Lobby_EnableMinimapCoordsOnConnect( GetPlayerName() )
	}
}


void function InitLobbyMenu( var newMenuArg )

{
	var menu = GetMenu( "LobbyMenu" )
	file.menu = menu

	RegisterSignal( "LobbyMenuUpdate" )


	AddUICallback_OnResolutionChanged( Lobby_RefreshMinimapCoords )


	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLobbyMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnLobbyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnLobbyMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnLobbyMenu_GetTopLevel )
	

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnLobbyMenu_NavigateBack )

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )






		AddMenuVarChangeHandler( "ORIGIN_isEnabled", UpdateFooterOptions )
		AddMenuVarChangeHandler( "ORIGIN_isJoinable", UpdateFooterOptions )




	var postGameButton = Hud_GetChild( menu, "PostGameButton" )
	file.postGameButton = postGameButton
	ToolTipData postGameToolTip
	postGameToolTip.descText = "#MATCH_SUMMARY"
	Hud_SetToolTipData( postGameButton, postGameToolTip )
	HudElem_SetRuiArg( postGameButton, "icon", $"rui/menu/lobby/postgame_icon" )
	HudElem_SetRuiArg( postGameButton, "shortcutText", "%[BACK|TAB]%" )
	Hud_AddEventHandler( postGameButton, UIE_CLICK, PostGameButton_OnActivate )

	var newsButton = Hud_GetChild( menu, "NewsButton" )
	file.newsButton = newsButton
	file.newsButtonStatusIcon = Hud_GetChild( menu, "NewsButtonStatusIcon" )
	ToolTipData newsToolTip
	newsToolTip.descText = "#NEWS"
	Hud_SetToolTipData( newsButton, newsToolTip )
	HudElem_SetRuiArg( newsButton, "icon", $"rui/menu/lobby/news_inbox_icon" )
	HudElem_SetRuiArg( newsButton, "shortcutText", "%[R_TRIGGER|ESCAPE]%" )
	Hud_AddEventHandler( newsButton, UIE_CLICK, NewsButton_OnActivate )
	Hud_AddEventHandler( newsButton, UIE_GET_FOCUS, NewsButton_OnHover )
	UpdatePromoToast()

	var socialButton = Hud_GetChild( menu, "SocialButton" )
	file.socialButton = socialButton
	ToolTipData socialToolTip
	socialToolTip.descText = "#MENU_TITLE_FRIENDS"
	Hud_SetToolTipData( socialButton, socialToolTip )
	HudElem_SetRuiArg( socialButton, "icon", $"rui/menu/lobby/friends_icon" )
	HudElem_SetRuiArg( socialButton, "shortcutText", "%[STICK2|]%" )
	Hud_AddEventHandler( socialButton, UIE_CLICK, SocialButton_OnActivate )

	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	file.gameMenuButton = gameMenuButton
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "#GAME_MENU"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "%[START|ESCAPE]%" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, GameMenuButton_OnActivate )

	var socialEventPopup = Hud_GetChild( menu, "SocialPopupPanel" )
	file.socialEventPopup = socialEventPopup

	var serverDebugID = Hud_GetChild( menu, "LobbyServerIDText" )
	file.serverDebugID = serverDebugID

	var dx12BetaText = Hud_GetChild( menu, "DirectX12BetaText" )
	file.dx12BetaText = dx12BetaText

	InitSocialEventPopup( socialEventPopup )

	UpdatePromoToast()

	PerfInitLabel( 1, "1" )
	PerfInitLabel( 2, "2" )
	PerfInitLabel( 3, "3" )
	PerfInitLabel( 4, "4" )
	PerfInitLabel( 5, "5" )
	PerfInitLabel( 6, "6" )
}


void function OnLobbyMenu_Open()
{
	if ( !file.tabsInitialized )
	{
		{
			var panel = Hud_GetChild( file.menu, "PlayPanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			file.playPanelTabDef = tab
			tab.isBannerLogoSmall = false
			SetTabBaseWidth( tab, 125 )
		}
		{
			var panel = Hud_GetChild( file.menu, "EventPanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			file.eventsPanelTabDef = tab
			tab.isBannerLogoSmall = false
			SetTabBaseWidth( tab, 170 )
		}
		{
			var panel = Hud_GetChild( file.menu, "ChallengesPanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			tab.isBannerLogoSmall = false
			SetTabBaseWidth( tab, 235 )
		}
		{
			var panel = Hud_GetChild( file.menu, "SeasonPanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			file.seasonalPanelTabDef = tab
			tab.isBannerLogoSmall = false
			SetTabBaseWidth( tab, 225 )
		}
		{
			var panel = Hud_GetChild( file.menu, "ArmoryPanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 260 )
		}
		{
			var panel = Hud_GetChild( file.menu, "StorePanel" )
			TabDef tab = AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 160 )
			tab.new = HasNewPersonalisedOffers()
		}








		TabData tabData = GetTabDataForPanel( file.menu )

		tabData.customFirstTabButton = false
		tabData.activeTabIdx = GetLobbyDefaultTabIndex()
		tabData.centerTabs = true
		tabData.useGRXData = true
		tabData.initialFirstTabButtonXPos = GetNearestAspectRatio( GetScreenSize().width, GetScreenSize().height ) <= 2.0? 80: 0
#if PC_PROG_NX_UI
			tabData.callToActionWidth = 180
#else
			tabData.callToActionWidth = 210
#endif
		SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.CAPSTONE )
		AddCallback_OnTabChanged( Lobby_OnTabChanged )
		file.tabsInitialized = true
	}

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, GetLobbyDefaultTabIndex() )
	}
	else
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, tabData.activeTabIdx )
	}

	UpdateNewnessCallbacks()

	thread UpdateLobbyUI()

	Lobby_ResetAreLobbyButtonsUpdating()
	Lobby_UpdatePlayPanelPlaylists()

	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )

	file.hasFocusedNews = false
}

void function Lobby_AdjustScreenFrameToMaxSize( var elm, bool center = false )
{
	UISize screenSize = GetScreenSize()
	if( elm != null )
	{
		if( IsLobby() )
		{
			int maxWidth = ( UI_GetPresentationType() == ePresentationType.STORE_INSPECT )? LOBBY_STORE_MENU_MAX_WIDTH: LOBBY_MENU_MAX_WIDTH
			float widthToUse =  min( ContentScaledXAsInt( maxWidth ) , screenSize.width )
			float leftOverWidth = screenSize.width - widthToUse

			Hud_SetWidth( elm, widthToUse )
			if( center && leftOverWidth > 0 )
				Hud_SetX(elm, leftOverWidth / 2 )
			else
				Hud_SetX(elm, 0 )
		}
		else
		{
			Hud_SetWidth( elm, screenSize.width )
		}
	}
}

void function Lobby_AdjustBlackBarsFrameToMaxSize( var menu )
{
	if( Hud_HasChild(menu, "SideBars" ) )
	{
		var sideBars = Hud_GetChild( menu, "SideBars" )
		int maxWidth = ( UI_GetPresentationType() == ePresentationType.STORE_INSPECT )? LOBBY_STORE_MENU_MAX_WIDTH: LOBBY_MENU_MAX_WIDTH

		Hud_SetVisible( sideBars, IsLobby() )
		HudElem_SetRuiArg( sideBars, "safeWidth", float( maxWidth ), eRuiArgType.FLOAT )
	}
}

void function OnLobbyMenu_Show()
{
	thread LobbyMenuUpdate()
	SocialEventUpdate()
	RegisterInputs()
	Chroma_Lobby()

	if ( GetCurrentPlaylistVarBool( "grx_inbox_enabled", true ) )
	{
		HudElem_SetRuiArg( file.newsButton, "icon", $"rui/menu/lobby/news_inbox_icon" )
	}
	else
	{
		HudElem_SetRuiArg( file.newsButton, "icon", $"rui/menu/lobby/news_icon" )
	}

}

void function Lobby_OnTabChanged()
{
	if ( GetActiveMenu() != file.menu )
		return

	UpdateCornerButtons()
}

void function OnLobbyMenu_GetTopLevel()
{
	file.lobbyMenuOpenTime = UITime()
	thread TryRunDialogFlowThread()
}


void function OnLobbyMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	ClearActiveLobbyPopup()
	DeregisterInputs()
}


void function OnLobbyMenu_Close()
{
	ClearActiveLobbyPopup()
	ClearNewnessCallbacks()
	DeregisterInputs()

	RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
}


void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()

	array<var> panels = [
		GetPanel( "EventPanel" ),
		GetPanel( "ChallengesPanel" ),
		GetPanel( "SeasonPanel" ),
		GetPanel( "ArmoryPanel" ),
		GetPanel( "StorePanel" ),
	]

	foreach ( var panel in panels )
	{
		SetPanelTabEnabled( panel, ready )
	}

	TabData tabData = GetTabDataForPanel( file.menu )
	SetTabDefsToSeasonal(tabData)
	RefreshTabsSeasonalData()
	RefreshTabsGRXData( tabData )
	OnGRXStoreUpdate()
	OnGRXSeasonUpdate()
	OnGRXEventUpdate()

	
	
	if ( GetConVarBool( "mtx_gifting_notifications_enabled" ) )
	{
		
		
		file.hasFocusedNews = false
	}
}

void function UpdateEventTabVisibility( bool isVisible )
{
	TabData tabData = GetTabDataForPanel( file.menu )

	SetTabDefVisible(file.eventsPanelTabDef, isVisible )
	SetTabDefEnabled(file.eventsPanelTabDef, isVisible )

	
	if( !isVisible && file.eventsPanelTabDef.isActive )
		ActivateTabNext( tabData )
}


void function UpdateSeasonTabVisibility( bool isVisible )
{
	TabData tabData = GetTabDataForPanel( file.menu )

	SetTabDefVisible(file.seasonalPanelTabDef, isVisible )
	SetTabDefEnabled(file.seasonalPanelTabDef, isVisible )

	
	if( !isVisible && file.seasonalPanelTabDef.isActive )
		ActivateTabNext( tabData )
}

void function UpdateNewnessCallbacks()
{
	ClearNewnessCallbacks()


	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.ChallengesTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ChallengesPanel" ) )

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = true
}


void function ClearNewnessCallbacks()
{
	if ( !file.newnessInitialized )
		return


	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.ChallengesTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ChallengesPanel" ) )

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = false
}


void function UpdateLobbyUI()
{
	if ( file.updatingLobbyUI )
		return

	file.updatingLobbyUI = true

	thread UpdateMatchmakingStatus()

	WaitSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	file.updatingLobbyUI = false
}


void function LobbyMenuUpdate()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	thread LobbyMenuUpdateLowFrequencyElements()

	while ( true )
	{
		PlayPanelUpdate()
		TrackPlaylistRotation()
		HandleCrossplayPartyInvalid()

		WaitFrame()
	}
}





void function LobbyMenuUpdateLowFrequencyElements()
{
	EndSignal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	while ( true )
	{
		UpdateCornerButtons()
		UpdatePromoToast()
		SetPanelTabNew( GetPanel( "StorePanel" ), HasNewPersonalisedOffers() )

		Boost_LowFreqUpdate()
		wait 1.0
	}
}

void function UpdatePromoToast()
{
	array<GRXContainerInfo> inboxMessages = GetGiftingInboxMessages()
	var rui = Hud_GetRui( file.newsButton )
	file.hasNewGifts = false

	if ( inboxMessages.len() > 0 )
		file.hasNewGifts = true

	RuiSetBool( rui, "isNew", file.hasNewGifts )

	if ( !file.hasNewGifts )
	{
		RuiSetBool( rui, "isVisible", false )
		RuiSetBool( rui, "hasNeverFocused", false )
		RuiSetBool( rui, "hasGifts", false )
		return
	}

	if ( file.hasFocusedNews )
	{
		RuiSetBool( rui, "hasNeverFocused", false )
		return
	}
	else
	{
		RuiSetBool( rui, "hasNeverFocused", true )
	}

	var playPanel           = GetPanel( "PlayPanel" )
	bool isPlayPanelActive  = IsTabPanelActive( playPanel )

	if ( !isPlayPanelActive )
	{
		RuiSetBool( rui, "isVisible", true )
		return
	}

	RuiSetBool( rui, "hasGifts", file.hasNewGifts && isPlayPanelActive )
	RuiSetColorAlpha( rui, "seasonColor", GetSeasonStyle().seasonNewColor, 1 )
}

bool function IsSameVendorPlatform( string hardware1, string hardware2 )
{
	if ( hardware1 != hardware2 )
	{
		if( hardware1 == "PS4" || hardware1 == "PS5" ) 
		{
			if( hardware2 == "PS4" || hardware2 == "PS5" )
				return true
		}
		else if( hardware1 == "X1" || hardware1 == "XB5" )
		{
			if( hardware2 == "X1" || hardware2 == "XB5" )
				return true
		}

		return false
	}
	return true
}

void function HandleCrossplayPartyInvalid()
{
	
	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return

	if ( CrossplayUserOptIn() || GetPartySize() == 1 )
		return

	if( IsDialog( GetActiveMenu() ) )
		return

	
	string hardware   = GetPlayerHardware()
	Party myParty     = GetParty()
	foreach ( p in myParty.members )
	{
		if ( !IsSameVendorPlatform( hardware , p.hardware  ) )
		{
			LeaveParty()

			ConfirmDialogData data
			data.headerText = "#CROSSPLAY_DIALOG_INVALID_PARTY_HEADER"
			data.messageText = Localize( "#CROSSPLAY_DIALOG_INVALID_PARTY_MSG" )
			OpenOKDialogFromData( data )
			break
		}
	}
}

void function Lobby_UpdateSelectedPlaylistUsingUISlot( string previousPlaylist )
{
	
	
	string ornull playlistSchedule      = GetScheduleFromPlaylist( previousPlaylist )
	string newPlaylist = playlistSchedule != null ? GetCurrentPlaylistForSchedule( expect string( playlistSchedule ) ) : ""
	if ( playlistSchedule != null )
		printf("Found new playlist '%s' for ui_slot %s", newPlaylist, playlistSchedule )

	if ( newPlaylist == "" || !Lobby_IsPlaylistAvailable( newPlaylist ) )
		newPlaylist = GetDefaultPlaylist()

	string mapChangeAlias = GetPlaylistVarString( newPlaylist, "map_change_VO_alias", "" )
	if ( mapChangeAlias != "" && file.lastPlayedAudioPlaylist != mapChangeAlias )
	{
		file.lastPlayedAudioPlaylist = mapChangeAlias
		PlayLobbyCharacterDialogue( mapChangeAlias )
	}

	LobbyPlaylist_SetSelectedPlaylist( newPlaylist )
	printf("Changed selected playlist from '%s' to '%s'", previousPlaylist, newPlaylist)
}

void function TrackPlaylistRotation()
{








	if ( file.nextRotationTime < GetSoonestPlaylistRotationTime() )

	{
		ForceRefreshVisiblePlaylists()
		file.nextRotationTime = GetSoonestPlaylistRotationTime()



		if ( IsModeSelectMenuOpen() )
		{
			
			
			if ( PrivateMatchMapSelect_IsEnabled() )
				UpdatePrivateMatchMapSelectDialog()
			else if ( GamemodeSelect_IsEnabled() )
				UpdateOpenModeSelectDialog()
		}

		string selectedPlaylist = LobbyPlaylist_GetSelectedPlaylist()
		if ( !Lobby_IsPlaylistAvailable( selectedPlaylist ) && !AreWeMatchmaking() && !uiGlobal.isLevelShuttingDown )
		{
			Lobby_UpdateSelectedPlaylistUsingUISlot( selectedPlaylist )
		}
		ServerCallback_GamemodeSelectorInitialize()
	}
}

void function UpdateCornerButtons()
{
	var playPanel           = GetPanel( "PlayPanel" )
	bool isPlayPanelActive  = GetMenuActiveTabIndex(file.menu) == 0
	bool showPostGameButton = isPlayPanelActive && IsPostGameMenuValid()

	if ( showPostGameButton )
		Hud_SetX( file.postGameButton, Hud_GetBaseX( file.postGameButton ) )
	else
		Hud_SetX( file.postGameButton, Hud_GetBaseX( file.postGameButton ) - Hud_GetWidth( file.postGameButton ) - Hud_GetBaseX( file.postGameButton ) )

	Hud_SetVisible( file.postGameButton, showPostGameButton )
	Hud_SetVisible( file.newsButton, isPlayPanelActive )
	Hud_SetVisible( file.newsButtonStatusIcon, isPlayPanelActive )
	Hud_SetVisible( file.socialButton, isPlayPanelActive )
	Hud_SetVisible( file.gameMenuButton, isPlayPanelActive )

	var accessibilityHint = Hud_GetChild( playPanel, "AccessibilityHint" )
	Hud_SetVisible( accessibilityHint, isPlayPanelActive && IsAccessibilityChatHintEnabled() && !VoiceIsRestricted() && (GetPartySize() > 1) )

	Hud_SetEnabled( file.gameMenuButton, !IsDialog( GetActiveMenu() ) )

	int count = GetOnlineFriendCount( )
	if ( count > 0 )
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" + count )
		Hud_SetWidth( file.socialButton, Hud_GetBaseWidth( file.socialButton ) * 2 )
		InitButtonRCP( file.socialButton )
	}
	else
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" )
		Hud_ReturnToBaseSize( file.socialButton )
		InitButtonRCP( file.socialButton )
	}

	string str = (( IsNetGraphEnabled() && isPlayPanelActive ) ? Localize( "#NETGRAPH_SERVERID", GetServerDebugId() ) : "")
	Hud_SetText( file.serverDebugID, str )

	Hud_SetText( file.dx12BetaText, IsDirectX12Beta() ? Localize( "#DIRECTX12_BETA" ) : "" )
}

void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	RegisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	RegisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	RegisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	RegisterButtonPressedCallback( KEY_B, KeyB_OnActivate )
	RegisterButtonPressedCallback( KEY_SPACE, KeySpace_OnActivate )

	RegisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	DeregisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	DeregisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	DeregisterButtonPressedCallback( KEY_B, KeyB_OnActivate )
	DeregisterButtonPressedCallback( KEY_SPACE, KeySpace_OnActivate )

	DeregisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = false
}


void function SeasonTab_OnActivate( var button )
{
	TabData tabData = GetTabDataForPanel( file.menu )

	if ( !IsTabIndexEnabled( tabData, Tab_GetTabIndexByBodyName( tabData, "SeasonPanel" ) ) )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	JumpToSeasonTab()
}

void function NewsButton_OnActivate( var button )
{
	if ( PromoDialog_CanShow() )
		AdvanceMenu( GetMenu( "PromoDialogUM" ) )
}

void function NewsButton_OnHover( var button )
{
	file.hasFocusedNews = true
}


void function SocialButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return


		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}


	AdvanceMenu( GetMenu( "SocialMenu" ) )
}


void function GameMenuButton_OnActivate( var button )
{
	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) ) 
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function PostGameButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	thread OnLobbyMenu_PostGameOrChat( button )
}


void function OnLobbyMenu_NavigateBack()
{
	
	
	
	
	
	

	if ( GetMenuActiveTabIndex( file.menu ) == 0 )
	{
		if ( !IsControllerModeActive() )
			AdvanceMenu( GetMenu( "SystemMenu" ) )
	}
	else
	{
		LobbyMenu_OpenDefaultTab()
	}
}

bool function LobbyMenu_IsDefaultTabOpen()
{
	return ( GetMenuActiveTabIndex( file.menu ) == 0 )
}

void function LobbyMenu_OpenDefaultTab()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, GetLobbyDefaultTabIndex() )
	UpdateMenuTabs()
}

int function GetLobbyDefaultTabIndex()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	return Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" )
}


void function OnLobbyMenu_PostGameOrChat( var button )
{
	var savedMenu = GetActiveMenu()





























	if ( IsPostGameMenuValid() && savedMenu == GetActiveMenu() )
	{
		thread PostGameFlow()
	}
}


void function PostGameFlow()
{



	bool showRankedSummary = Ranked_ShowRankedSummary()
	bool showCupSummary = Cups_ShowCupSummary()
	bool isFirstTime       = GetPersistentVarAsInt( "showGameSummary" ) != 0

		bool showOrientationMatchDialog = GetPersistentVarAsInt( "showOrientationMatchGraduationDialog" ) != 0


	OpenPostGameMenu( null )

	if ( GetActiveBattlePass() != null )
	{
		OpenPostGameBattlePassMenu( isFirstTime )
	}

	if ( showRankedSummary && !showCupSummary )
	{
		OpenRankedSummary( isFirstTime )
	}

	if ( showCupSummary && Cups_IsCupForLatestMatchActive( GetLocalClientPlayer() ) )
	{
		OpenCupsSummary()
	}










		if ( showOrientationMatchDialog )
		{
			ConfirmDialogData dialogData
			dialogData.headerText  = "#ORIENTATION_MATCH_GRADUATION_HEADER"
			dialogData.messageText = "#ORIENTATION_MATCH_GRADUATION_MESSAGE"
			dialogData.okText      = ["#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE"]
			dialogData.resultCallback = void function( int result )
			{
				Remote_ServerCallFunction( "ClientCallback_ViewedOrientationMatchDialog" )
			}
			OpenOKDialogFromData( dialogData )
		}

}


void function OnLobbyMenu_FocusChat( var panel )
{

		if ( IsDialog( GetActiveMenu() ) )
			return

		if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
			return

		if ( GetPartySize() > 1 )
		{
			var playPanel = Hud_GetChild( file.menu, "PlayPanel" )
			var textChat  = Hud_GetChild( playPanel, "ChatRoomTextChat" )
			Hud_SetFocused( Hud_GetChild( textChat, "ChatInputLine" ) )
		}

}


bool function Lobby_IsInputBlocked( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return false

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	return lobbyPopup.checkBlocksInput( inputID )
}


void function ButtonB_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_B )
}


void function KeyEscape_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_ESCAPE )
}


void function ButtonX_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_X )

	DismissGamemodeSelectorModal( button )
}


void function ButtonY_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_Y )
}


void function ButtonStickL_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_STICK_RIGHT )
}


void function KeyY_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_Y )
}


void function KeyN_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_N )
}


void function KeyB_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_B )
}

void function KeySpace_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_SPACE )

	DismissGamemodeSelectorModal( button )
}


void function DispatchLobbyPopupInput( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	lobbyPopup.handleInput( inputID )
}


void function SetActiveLobbyPopup( LobbyPopup popup )
{
	Assert( file.activeLobbyPopup == null )

	file.activeLobbyPopup = popup
}


bool function HasActiveLobbyPopup()
{
	return file.activeLobbyPopup != null
}


void function ClearActiveLobbyPopup()
{
	if ( file.activeLobbyPopup != null )
	{
		LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
		expect LobbyPopup( lobbyPopup )

		file.activeLobbyPopup = null

		lobbyPopup.onClose()
	}
}


void function SetNewsButtonTooltip( int status )
{
	ToolTipData newsToolTip
	switch( status )
	{
		case UM_RESULT_HIGH_LATENCY:
			newsToolTip.descText = "#UM_TOOLTIP_STATUS_HIGH_LATENCY"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"rui/menu/lobby/um_icon_high_latency" )
			break;
		case UM_RESULT_FAILURE:
			newsToolTip.descText = "#UM_TOOLTIP_STATUS_FAILURE"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"rui/menu/lobby/um_icon_failure" )
			break;
		default:
			newsToolTip.descText = "#NEWS"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"" )
			Hud_SetVisible( file.newsButtonStatusIcon, false )
			break;

	}
	Hud_SetToolTipData( file.newsButton, newsToolTip )
}

float function GetLobbyMenuOpenedTime()
{
	return file.lobbyMenuOpenTime
}