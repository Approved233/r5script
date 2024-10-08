global function InitHudOptionsPanel
global function RestoreHUDDefaults
global function GameplayPanel_GetConVarData
global function IsUserHudOptionsDisplayed
global function GetCrossplaySettingButton
global function ToggleCrossplaySettingThread




struct
{
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var				   panel
	var                detailsPanel
	var                itemDescriptionBox
	var                	crossplayButton
	bool				crossplayEnabled

	array<ConVarData>    conVarDataList

	bool isPanelDisplayed = false
} file

string  function  GetSwchChatSpeechToTextHint()
{
	if( GetConVarBool( "speechtotext_disable_expire_logic") )
		return Localize( "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_DESC_OLD") 

	string SwchChatSpeechToText_hint = Localize( "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_DESC" , Accesibility_STTFormatDurationDays( true ) ) 
	string highlightText =	Localize( "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_ADD1" , Accesibility_STTFormatDurationDays( false ) )

	if( GetConVarBool("speechtotext_enabled") && IsConnected())
	{
		int remaining =  GetConVarInt( "speechtotext_disable_time") - GetUnixTimestamp()  
		if(  remaining > 1 )
  			highlightText = Localize( "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_ADD2", Accesibility_FormatDuration( remaining ) )
	}

	SwchChatSpeechToText_hint = SwchChatSpeechToText_hint + highlightText
	return  SwchChatSpeechToText_hint
}

void function RefreshSwchChatSpeechToTextHint()
{
	SpeechToTextUpdateSettings()

	var contentPanel = Hud_GetChild( file.panel , "ContentPanel" )
	string SwchChatSpeechToText_hint = GetSwchChatSpeechToTextHint()
	SettingsButton_SetDescriptionAndChildren(Hud_GetChild( contentPanel, "SwchChatSpeechToText" ) ,  SwchChatSpeechToText_hint )
}

void function SwchChatSpeechToTextChanged( var button )
{
	SetConVarBool( "speechtotext_new_userSetting", true )
	RefreshSwchChatSpeechToTextHint();
}

void function InitHudOptionsPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnHudOptionsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHudOptionsPanel_Hide )

	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.panel = panel

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchLootPromptStyle" ), "#HUD_SETTING_LOOTPROMPTYSTYLE", "#HUD_SETTING_LOOTPROMPTYSTYLE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchShotButtonHints" ), "#HUD_SHOW_BUTTON_HINTS", "#HUD_SHOW_BUTTON_HINTS_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchDamageIndicatorStyle" ), "#HUD_SETTING_HITINDICATORSTYLE", "#HUD_SETTING_HITINDICATORSTYLE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchDamageTextStyle" ), "#HUD_SETTING_DAMAGETEXTSTYLE", "#HUD_SETTING_DAMAGETEXTSTYLE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchPingOpacity" ), "#HUD_SETTING_PINGOPACITY", "#HUD_SETTING_PINGOPACITY_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchShowObituary" ), "#HUD_SHOW_OBITUARY", "#HUD_SHOW_OBITUARY_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchRotateMinimap" ), "#HUD_ROTATE_MINIMAP", "#HUD_ROTATE_MINIMAP_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchWeaponAutoCycle" ), "#SETTING_WEAPON_AUTOCYCLE", "#SETTING_WEAPON_AUTOCYCLE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchAutoSprint" ), "#SETTING_AUTOSPRINT", "#SETTING_AUTOSPRINT_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchHoldToSprint" ), "#SETTING_HOLDTOSPRINT", "#SETTING_HOLDTOSPRINT_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchStickySprintForward" ), "#SETTING_STICKYSPRINTFORWARD", "#SETTING_STICKYSPRINTFORWARD_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchJetpackControl" ), "#SETTING_JETPACKCONTROL", "#SETTING_JETPACKCONTROL_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchPilotDamageIndicators" ), "#HUD_PILOT_DAMAGE_INDICATOR_STYLE", "#HUD_PILOT_DAMAGE_INDICATOR_STYLE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchDamageClosesDeathBoxMenu" ), "#SETTING_DAMAGE_CLOSES_DEATHBOX_MENU", "#SETTING_DAMAGE_CLOSES_DEATHBOX_MENU_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchOffscreenPortraits" ), "#SETTING_OFFSCREEN_PORTRAITS", "#SETTING_OFFSCREEN_PORTRAITS_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchHopupPopup" ), "#SETTING_HOPUP_POPUP", "#SETTING_HOPUP_POPUP_DESC", $"rui/menu/settings/settings_hud" )



	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchStreamerMode" ), "#HUD_STREAMER_MODE", "#HUD_STREAMER_MODE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchAnonymousMode" ), "#HUD_ANON_MODE", "#HUD_ANON_MODE_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchAnalytics" ), "#HUD_PIN_OPT_IN", "#HUD_PIN_OPT_IN_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchNetGraph" ), "#HUD_NET_GRAPH", "#HUD_NET_GRAPH_DESC", $"rui/menu/settings/settings_hud" )



	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchCommsFilter" ), "#HUD_CHAT_FILTER", "#HUD_CHAT_FILTER_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchFirstPersonReticleOptions" ), "#HUD_RETICLE", "#HUD_RETICLE_DESC", $"rui/menu/settings/settings_hud" )

	UpdateReticleOption()
	UpdateLaserOption()

	var reticle = Hud_GetChild( contentPanel, "SwitchFirstPersonReticleOptions" )
	AddButtonEventHandler( reticle, UIE_CHANGE, OnFirstPersonReticleSettingChanged )

	SetupSettingsButton( Hud_GetChild( contentPanel, "LaserSightOptions" ), "#HUD_LASER_SIGHT", "#HUD_LASER_SIGHT_DESC", $"rui/menu/settings/settings_hud" )
	var laserSight = Hud_GetChild( contentPanel, "LaserSightOptions" )
	AddButtonEventHandler( laserSight, UIE_CHANGE, OnLaserSightSettingChanged )


	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchEnemyHealthBar" ), "#HUD_SETTING_ENEMYHEALTHBAR", "#HUD_SETTING_ENEMYHEALTHBAR_DESC", $"rui/menu/settings/settings_hud" )



	SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchEnemyHighlight" ), "#HUD_SETTING_ENEMYHIGHLIGHT", "#HUD_SETTING_ENEMYHIGHLIGHT_DESC", $"rui/menu/settings/settings_hud" )
	var enemyHighlightingOnOFF = Hud_GetChild( contentPanel, "SwitchEnemyHighlight" )
	AddButtonEventHandler( enemyHighlightingOnOFF, UIE_CHANGE, OnEnemyHighlightingOnOffChanged )



		SetConVarBool( "CrossPlay_user_optin", true )












		{
			file.crossplayButton = SetupSettingsButton( Hud_GetChild( contentPanel, "SwitchCrossplay" ), "#HUD_CROSSPLAY_OPT_IN", "#HUD_CROSSPLAY_OPT_IN_DESC", $"rui/menu/settings/settings_hud" )
		}
		AddButtonEventHandler( file.crossplayButton, UIE_CHANGE, CrossplayButton_OnChanged )


	var autoSprint = Hud_GetChild( contentPanel, "SwitchAutoSprint" )
	AddButtonEventHandler( autoSprint, UIE_CHANGE, OnAutoSprintChanged )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchColorBlindMode" ), "#COLORBLIND_MODE", "#OPTIONS_MENU_COLORBLIND_TYPE_DESC", $"rui/menu/settings/settings_hud", true )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSubtitles" ), "#SUBTITLES", "#OPTIONS_MENU_SUBTITLES_DESC", $"rui/menu/settings/settings_hud" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSubtitlesSize" ), "#SUBTITLE_SIZE", "#OPTIONS_MENU_SUBTITLE_SIZE_DESC", $"rui/menu/settings/settings_hud" )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchAccessibility" ), "#MENU_CHAT_ACCESSIBILITY", "#OPTIONS_MENU_ACCESSIBILITY_DESC", $"rui/menu/settings/settings_hud" )
	Hud_SetVisible( Hud_GetChild( contentPanel, "SwchAccessibility" ), IsAccessibilityAvailable() )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), "#MENU_CHAT_SPEECH_TO_TEXT", GetSwchChatSpeechToTextHint() , $"rui/menu/settings/settings_hud" )
	AddButtonEventHandler( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), UIE_CHANGE, SwchChatSpeechToTextChanged   )

	Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), IsAccessibilityAvailable() )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), "#MENU_CHAT_TEXT_TO_SPEECH", "#OPTIONS_MENU_CHAT_TEXT_TO_SPEECH_DESC", $"rui/menu/settings/settings_hud" )
	Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), IsAccessibilityAvailable() )
#if PC_PROG_NX_UI
		var button = Hud_GetChild( contentPanel, "SwchMuteVoiceChat" )
		SetupSettingsButton( button, "#OPTIONS_MENU_VOICE_CHAT_DISABLE", "#OPTIONS_MENU_VOICE_CHAT_DISABLE_DESC", $"rui/menu/settings/settings_hud" )
		AddButtonEventHandler( button, UIE_CHANGE, OnDisableVoiceChatSettingChanged )
#endif


	SetupSettingsSlider( Hud_GetChild( contentPanel, "ObserverSlowSpeed" ), "#OPTIONS_MENU_OBSERVER_SLOW_SPEED", "#OPTIONS_MENU_OBSERVER_SLOW_SPEED_DESC", $"rui/menu/settings/settings_hud")
	SetupSettingsSlider( Hud_GetChild( contentPanel, "ObserverBaseSpeed" ), "#OPTIONS_MENU_OBSERVER_BASE_SPEED", "#OPTIONS_MENU_OBSERVER_BASE_SPEED_DESC", $"rui/menu/settings/settings_hud")
	SetupSettingsSlider( Hud_GetChild( contentPanel, "ObserverFastSpeed" ), "#OPTIONS_MENU_OBSERVER_FAST_SPEED", "#OPTIONS_MENU_OBSERVER_FAST_SPEED_DESC", $"rui/menu/settings/settings_hud")


	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreHUDDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#BUTTON_SHOW_CREDITS", "#SHOW_CREDITS", ShowCredits, CreditsVisible )
	AddPanelFooterOption( panel, RIGHT, -1, false, "#FOOTER_CHOICE_HINT", "" )



	
	
	
	SettingsPanel_SetContentPanelHeight( contentPanel )
	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_showButtonHints", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_accessibleChat", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_damageIndicatorStyle", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_showEnemyHealthBar", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_showEnemyHighlight", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_damageTextStyle", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_pingAlpha", eConVarType.FLOAT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_minimapRotate", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_streamerMode", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "hud_setting_anonymousMode", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "colorblind_mode", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "cc_text_size", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "damage_indicator_style_pilot", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "speechtotext_enabled", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "net_netGraph2", eConVarType.INT ) )



	file.conVarDataList.append( CreateSettingsConVarData( "cl_comms_filter", eConVarType.INT ) )

	file.conVarDataList.append( CreateSettingsConVarData( "hudchat_play_text_to_speech", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "CrossPlay_user_optin", eConVarType.BOOL ) )


	file.conVarDataList.append( CreateSettingsConVarData( "roamingcam_forwardSpeed", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "roamingcam_forwardSpeed_slow", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "roamingcam_forwardSpeed_fast", eConVarType.INT ) )
























}

void function OpenConfirmRestoreHUDDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_HUD_DEFAULTS"
	data.messageText = "#RESTORE_HUD_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreHUDDefaults()
	}
}

void function RestoreHUDDefaults()
{
	SetConVarToDefault( "hud_setting_showButtonHints" )
	SetConVarToDefault( "hud_setting_showTips" )
	SetConVarToDefault( "hud_setting_showWeaponFlyouts" )
	SetConVarToDefault( "hud_setting_adsDof" )
	SetConVarToDefault( "hud_setting_damageIndicatorStyle" )
	SetConVarToDefault( "hud_setting_showEnemyHealthBar" )
	SetConVarToDefault( "hud_setting_showEnemyHighlight" )
	SetConVarToDefault( "hud_setting_damageTextStyle" )
	SetConVarToDefault( "hud_setting_pingAlpha" )
	SetConVarToDefault( "hud_setting_streamerMode" )
	SetConVarToDefault( "hud_setting_anonymousMode" )

	SetConVarToDefault( "hud_setting_showCallsigns" )
	SetConVarToDefault( "hud_setting_showLevelUp" )
	SetConVarToDefault( "hud_setting_showMedals" )
	SetConVarToDefault( "hud_setting_showMeter" )
	SetConVarToDefault( "hud_setting_showObituary" )
	SetConVarToDefault( "hud_setting_minimapRotate" )
	SetConVarToDefault( "damage_indicator_style_pilot" )

	SetConVarToDefault( "weapon_setting_autocycle_on_empty" )
	SetConVarToDefault( "player_setting_autosprint" )
	SetConVarToDefault( "player_setting_holdtosprint" )
	SetConVarToDefault( "player_setting_stickysprintforward" )
	SetConVarToDefault( "player_setting_damage_closes_deathbox_menu" )
	SetConVarToDefault( "hud_setting_showOffscreenPortrait" )
	SetConVarToDefault( "hud_setting_showHopUpPopUp" )
	SetConVarBool( "toggle_on_jump_to_deactivate", IsControllerModeActive() ? true : false )
	SetConVarToDefault( "toggle_on_jump_to_deactivate_changed" )

	SetConVarToDefault( "colorblind_mode" )
	SetConVarToDefault( "reticle_color" )
	SetConVarToDefault( "laserSightColorCustomized" )
	SetConVarToDefault( "laserSightColor" )
	SetConVarToDefault( "closecaption" )
	SetConVarToDefault( "cc_text_size" )
	SetConVarToDefault( "hud_setting_accessibleChat" )
	SetConVarToDefault( "speechtotext_enabled" )
	SetConVarToDefault( "net_netGraph2" )



	SetConVarToDefault( "CrossPlay_user_optin" )
	SetConVarToDefault( "cl_comms_filter" )
	SetConVarToDefault( "hudchat_play_text_to_speech" )


		SetConVarToDefault( "hudchat_visibility" )



	SetConVarToDefault( "roamingcam_forwardSpeed" )
	SetConVarToDefault( "roamingcam_forwardSpeed_slow" )
	SetConVarToDefault( "roamingcam_forwardSpeed_fast" )


	SaveSettingsConVars( file.conVarDataList )

	EmitUISound( "menu_advocategift_open" )
}

void function HudOptionsShowButton( var contentPanel, string buttonName, string prevButtonName, string nextButtonName )
{
	
	var button = Hud_GetChild( contentPanel, buttonName )

	
	Hud_Show( button )

	
	var prevElem = Hud_GetChild( contentPanel, prevButtonName )
	var nextElem = Hud_GetChild( contentPanel, nextButtonName )

	
	Hud_SetPinSibling( nextElem, buttonName )

	
	Hud_SetNavUp( nextElem, button )
	Hud_SetNavDown( prevElem, button )
}

void function HudOptionsHideButton( var contentPanel, string buttonName, string prevButtonName, string nextButtonName )
{
	
	Hud_Hide( Hud_GetChild( contentPanel, buttonName ) )

	
	var prevElem = Hud_GetChild( contentPanel, prevButtonName )
	var nextElem = Hud_GetChild( contentPanel, nextButtonName )

	
	Hud_SetPinSibling( nextElem, prevButtonName )

	
	Hud_SetNavUp( nextElem, prevElem )
	Hud_SetNavDown( prevElem, nextElem )
}

void function OnHudOptionsPanel_Show( var panel )
{
#if PC_PROG_NX_UI
	ScrollPanel_Refresh( panel )
#endif

	ScrollPanel_SetActive( panel, true )

	UpdateCrossplaySettingAvailable()
	file.crossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )

#if !PC_PROG_NX_UI
		HudOptionsHideButton( contentPanel, "SwitchCrossplay", "SwitchAnalytics", "SwitchNetGraph" )
#else
		if( CustomMatch_IsInCustomMatch() )
		{
			HudOptionsHideButton( contentPanel, "SwitchCrossplay", "SwitchAnalytics", "SwitchNetGraph" )
		}
		else
		{
			HudOptionsShowButton( contentPanel, "SwitchCrossplay", "SwitchAnalytics", "SwitchNetGraph" )
		}

#endif






	HudOptionsShowButton( contentPanel, "LaserSightOptions", "SwitchFirstPersonReticleOptions", "SwchColorBlindMode" )

	
	Hud_SetPinSibling( Hud_GetChild( contentPanel, "SwchColorBlindMode" ), "AccessibilityHeader" )
	Hud_SetPinSibling( Hud_GetChild( contentPanel, "AccessibilityHeader" ), "LaserSightOptions" )


	CheckVoiceChatVolumeSetting()


	RefreshSwchChatSpeechToTextHint()

	
	bool autoSprintEnabled = GetConVarBool( "player_setting_autosprint" )
	var holdToSprint = Hud_GetChild( contentPanel, "SwitchHoldToSprint" )
	Hud_SetLocked( holdToSprint, autoSprintEnabled )
	Hud_SetLocked( Hud_GetChild( holdToSprint, "LeftButton" ), autoSprintEnabled )
	Hud_SetLocked( Hud_GetChild( holdToSprint, "RightButton" ), autoSprintEnabled )


	
#if DEV
		bool showObserverControls = GetCurrentPlaylistVarBool( "private_match", false ) && GetCurrentPlaylistVarBool( "has_extended_observer_controls", true );
#else
		bool showObserverControls = GetCurrentPlaylistVarBool( "private_match", false ) && GetCurrentPlaylistVarBool( "has_extended_observer_controls", false );
#endif
	Hud_SetVisible( Hud_GetChild( contentPanel, "ObserverHeader" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "ObserverHeaderText" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "ObserverSlowSpeed" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "TextEntryObserverSlowSpeed" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "ObserverBaseSpeed" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "TextEntryObserverBaseSpeed" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "ObserverFastSpeed" ), showObserverControls )
	Hud_SetVisible( Hud_GetChild( contentPanel, "TextEntryObserverFastSpeed" ), showObserverControls )


	SettingsPanel_SetContentPanelHeight( contentPanel )
	ScrollPanel_Refresh( panel )
	file.isPanelDisplayed = true
}


void function OnHudOptionsPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )

	SaveSettingsConVars( file.conVarDataList )
	SavePlayerSettings()

	
	if ( !IsLobby() && CanRunClientScript() && IsConnected() )
	{
		RunClientScript( "ClWeaponStatus_RefreshWeaponStatus", GetLocalClientPlayer() )
		RunClientScript( "Minimap_UpdateNorthFacingOnSettingChange" )
	}

	file.isPanelDisplayed = false
}

bool function IsUserHudOptionsDisplayed()
{
	return file.isPanelDisplayed
}


void function FooterButton_Focused( var button )
{
}


array<ConVarData> function GameplayPanel_GetConVarData()
{
	return file.conVarDataList
}


string function GetCreditsURL()
{
	return GetCurrentPlaylistVarString( "credits_url", "https://www.ea.com/games/apex-legends/credits" )
}


void function ShowCredits( var unused )
{
	string creditsURL = Localize( GetCreditsURL() )
	LaunchExternalWebBrowser( creditsURL, WEBBROWSER_FLAG_NONE )
}


bool function CreditsVisible()
{
	if ( !IsLobby() )
		return false

	return (GetCreditsURL().len() > 0)
}


void function OpenEULAReviewFromFooter( var button )
{
	OpenEULADialog( true, file.panel )
}


void function UpdateCrossplaySettingAvailable()
{
	var button = file.crossplayButton

	bool inMixedParty = false
	string hardware = GetPlayerHardware()
	Party myParty = GetParty()
	foreach ( p in myParty.members )
	{
		if ( hardware != p.hardware )
		{
			inMixedParty = true
			break
		}
	}





	string matchmakingStatus = GetMyMatchmakingStatus()
	bool isBusyMatchmaking = matchmakingStatus != ""

	Hud_SetLocked( file.crossplayButton, inMixedParty || isBusyMatchmaking )
	Hud_SetLocked( Hud_GetChild( file.crossplayButton, "LeftButton" ), inMixedParty || isBusyMatchmaking )
	Hud_SetLocked( Hud_GetChild( file.crossplayButton, "RightButton" ), inMixedParty || isBusyMatchmaking )

	Hud_SetVisible( file.crossplayButton, CrossplayEnabled() )
	Hud_SetVisible( Hud_GetChild( file.crossplayButton, "LeftButton" ), CrossplayEnabled() )
	Hud_SetVisible( Hud_GetChild( file.crossplayButton, "RightButton" ), CrossplayEnabled() )
}


void function UpdateReticleOption()
{
	bool IsColorCustomized = ColorPalette_IsColorCustomized(COLORID_RETICLE)
	int option = ( IsColorCustomized )? 1: 0

	var contentPanel = Hud_GetChild( file.panel, "ContentPanel" )
	Hud_SetDialogListSelectionIndex(Hud_GetChild( contentPanel, "SwitchFirstPersonReticleOptions" ), option )
}

void function OnFirstPersonReticleSettingChanged( var btn )
{
	if(Hud_GetDialogListSelectionIndex(btn) == 0)
		SetConVarString( "reticle_color", "" )
	else if(Hud_GetDialogListSelectionIndex(btn) == 1)
		AdvanceMenu( GetMenu( "FirstPersonReticleOptionsMenu" ) )
}

void function OnLaserSightSettingChanged( var btn )
{
	if(Hud_GetDialogListSelectionIndex(btn) == 0)
	{
		if ( !IsLobby() )
			RunClientScript( "UICallback_UpdateLaserSightColor" )
	}
	else if(Hud_GetDialogListSelectionIndex(btn) == 1)
	{








		AdvanceMenu( GetMenu( "LaserSightOptionsMenu" ) )
	}
}


void function OnEnemyHighlightingOnOffChanged( var btn )
{
	int index = Hud_GetDialogListSelectionIndex( btn )

	if ( IsLobby() )
	{
		return
	}

	if ( index == 0 )
		RunClientScript( "SetEnemyHighLightOnOff", "Off" )
	else if ( index == 1 )
		RunClientScript( "SetEnemyHighLightOnOff", "On" )
}


void function OnAutoSprintChanged( var btn )
{
	var contentPanel = Hud_GetChild( file.panel, "ContentPanel" )
	var holdToSprint = Hud_GetChild( contentPanel, "SwitchHoldToSprint" )

	bool autoSprintEnabled = Hud_GetDialogListSelectionIndex( btn ) == 1
	Hud_SetLocked( holdToSprint, autoSprintEnabled )
}







void function UpdateLaserOption()
{
	bool IsColorCustomized = ColorPalette_IsColorCustomized(COLORID_LASER_SIGHT )
	int option = ( IsColorCustomized )? 1: 0

	var contentPanel = Hud_GetChild( file.panel, "ContentPanel" )
	Hud_SetDialogListSelectionIndex(Hud_GetChild( contentPanel, "LaserSightOptions" ), option )
}

var function GetCrossplaySettingButton()
{
	return file.crossplayButton
}

void function ToggleCrossplaySettingThread()
{
	WaitEndFrame()
	bool isCrossplayEnabled = GetConVarBool( "CrossPlay_user_optin" )
	SetConVarBool( "CrossPlay_user_optin", !isCrossplayEnabled )
	file.crossplayEnabled = !isCrossplayEnabled
}

void function CrossplayButton_OnChanged( var button )
{
	thread CrossplayButton_OnChangedThread()
}

void function CrossplayButton_OnChangedThread()
{
	bool selectionIsEnabled = Hud_GetDialogListSelectionIndex( file.crossplayButton ) == 1
	if ( selectionIsEnabled == file.crossplayEnabled )
		return

	WaitEndFrame()



	file.crossplayEnabled = CrossplayEnabled()
}

#if PC_PROG_NX_UI
void function OnDisableVoiceChatSettingChanged( var button )
{
	bool isVoiceChatDisabled = !GetConVarBool( "voice_enabled" )
	var contentPanel = Hud_GetChild( file.panel, "ContentPanel" )
	var speechToTextButton = Hud_GetChild( contentPanel, "SwchChatSpeechToText" )
	LockSpeechToText( isVoiceChatDisabled )
}
#endif

void function LockSpeechToText( bool shouldLock )
{
	var contentPanel = Hud_GetChild( file.panel, "ContentPanel" )
	var speechToTextButton = Hud_GetChild( contentPanel, "SwchChatSpeechToText" )
	Hud_SetLocked( speechToTextButton, shouldLock )
	if( shouldLock )
		SetConVarBool( "speechtotext_enabled", false )
}


void function CheckVoiceChatVolumeSetting()
{
	bool isVoiceVolumeZero = GetConVarFloat( "sound_volume_voice" ) == 0.0
	LockSpeechToText( isVoiceVolumeZero )
}

