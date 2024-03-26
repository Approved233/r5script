global function InitSoundPanel
global function RestoreSoundDefaults
global function SoundPanel_GetConVarData

global function InitProcessingDialog


global function UICodeCallback_RefreshSoundOptions

array<string> navItems = 
[
	"SldMasterVolume",
	"SwchOutputDevice",
	"NoDeviceWarningText",
	"SwchSpatialAudio",
	"SwchSpeakerConfig",
	"VoiceChatHeader",

	

	"SwchSoundWithoutFocus",
	"SwchVipTelemetry",
]









struct
{
	bool active

	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var				   contentPanel
	var                itemDescriptionBox

	var 			   audioLanguageButton

	var 			   voiceSensitivityButton
	var 			   voiceSensitivitySliderRui


	array<ConVarData>    conVarDataList

	string miles_language

	var processingDialog
} file


void function SoundPanelSetButtonVisible( var contentPanel, string buttonName, bool visible )
{
	int prevVisibleNavItem = -1

	for ( int i = 0; i < navItems.len() - 1; i++ )
	{
		var elem = Hud_GetChild( contentPanel, navItems[i] )

		if ( navItems[i] == buttonName )
		{
			if ( visible )
			{
				Hud_Show( elem )

				if ( i < navItems.len() - 1 )
					Hud_SetPinSibling( Hud_GetChild( contentPanel, navItems[i + 1] ), buttonName )

				if ( prevVisibleNavItem >= 0 )
					Hud_SetPinSibling( elem, navItems[prevVisibleNavItem] )
			}
			else
			{
				Hud_Hide( elem )

				if ( i < navItems.len() - 1 && prevVisibleNavItem >= 0 )
					Hud_SetPinSibling( Hud_GetChild( contentPanel, navItems[i + 1] ), navItems[prevVisibleNavItem] )
			}

			Hud_SetEnabled( elem, visible )
			return
		}

		if ( Hud_IsVisible( elem ) )
			prevVisibleNavItem = i
	}
}

void function InitSoundPanel( var panel )
{
	RegisterSignal( "UpdateVoiceMeter" )
	RegisterSignal( "EndRebootMiles" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSoundPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSoundPanel_Hide )

	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMasterVolume" ), "#MASTER_VOLUME", "#OPTIONS_MENU_MASTER_VOLUME_DESC", $"rui/menu/settings/settings_audio" )

	file.audioLanguageButton = Hud_GetChild( contentPanel, "SwchAudioLanguage" )
	SetupSettingsButton( file.audioLanguageButton, "#AUDIO_LANGUAGE", "#OPTIONS_MENU_AUDIO_LANGUAGE_DESC", $"rui/menu/settings/settings_audio" )
	AddButtonEventHandler( file.audioLanguageButton, UIE_CHANGE, OnAudioLanguageControlChanged )

	file.miles_language = GetConVarString( "miles_language" )

	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldDialogueVolume" ), "#MENU_DIALOGUE_VOLUME_CLASSIC", "#OPTIONS_MENU_DIALOGUE_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSFXVolume" ), "#MENU_SFX_VOLUME_CLASSIC", "#OPTIONS_MENU_SFX_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMusicVolume" ), "#MENU_MUSIC_VOLUME_CLASSIC", "#OPTIONS_MENU_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldLobbyMusicVolume" ), "#MENU_LOBBY_MUSIC_VOLUME", "#OPTIONS_MENU_LOBBY_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSpatialAudio" ), "#AUDIO_SPATIAL", "#AUDIO_SPATIAL_DESC", $"rui/menu/settings/settings_audio" )


		file.voiceSensitivityButton = Hud_GetChild( contentPanel, "SldOpenMicSensitivity" )
		file.voiceSensitivitySliderRui = Hud_GetRui( Hud_GetChild( file.voiceSensitivityButton, "PrgValue" ) )

		HudElem_SetRuiArg( Hud_GetChild( file.voiceSensitivityButton, "PnlDefaultMark" ), "heightScale", 0.7 )

		var button = Hud_GetChild( contentPanel, "SwchInputDevice" )
		SetupSettingsButton( button, "#VOICECHAT_INPUT_DEVICE", "#VOICECHAT_INPUT_DEVICE_DESC", $"rui/menu/settings/settings_audio" )

		button = Hud_GetChild( contentPanel, "SwchOutputDevice" )
		SetupSettingsButton( button, "#AUDIO_OUTPUT_DEVICE", "#AUDIO_OUTPUT_DEVICE_DESC", $"rui/menu/settings/settings_audio" )

		SetupSettingsSlider( Hud_GetChild( contentPanel, "SldOpenMicSensitivity" ), "#OPEN_MIC_SENS", "#OPEN_MIC_SENS_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchPushToTalk" ), "#OPTIONS_MENU_VOICE_CHAT_MIC", "#OPTIONS_MENU_VOICE_CHAT_MIC_DESC", $"rui/menu/settings/settings_audio" )
		var slider = Hud_GetChild( contentPanel, "SldVoiceChatVolume" )
		SetupSettingsSlider( slider, "#VOICE_CHAT_VOLUME", "#OPTIONS_MENU_VOICE_CHAT_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSoundWithoutFocus" ), "#SOUND_WITHOUT_FOCUS", "#OPTIONS_MENU_SOUND_WITHOUT_FOCUS", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSpeakerConfig" ), "#AUDIO_CHANNEL_CONFIGURATION", "#AUDIO_CHANNEL_CONFIGURATION_DESC", $"rui/menu/settings/settings_audio" )

		AddButtonEventHandler( Hud_GetChild( contentPanel, "SwchOutputDevice" ), UIE_CHANGE, OnOutputDeviceChanged )


	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchVipTelemetry" ), "#OPTIONS_MENU_AUDIO_VIP_TELEMETRY", "#OPTIONS_MENU_AUDIO_VIP_TELEMETRY_DESC", $"rui/menu/settings/settings_audio" )

	SettingsPanel_SetContentPanelHeight( contentPanel )
	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreSoundDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
	
	
	

	file.conVarDataList.append( CreateSettingsConVarData( "TalkIsStream", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "miles_occlusion", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "closecaption", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "speechtotext_enabled", eConVarType.INT ) )


		if ( HasConVar( "miles_spatial" ) )
		{
			file.conVarDataList.append( CreateSettingsConVarData( "miles_spatial", eConVarType.INT ) )
		}



		file.conVarDataList.append( CreateSettingsConVarData( "voice_input_device", eConVarType.STRING ) )
		file.conVarDataList.append( CreateSettingsConVarData( "hudchat_play_text_to_speech", eConVarType.INT ) )
		file.conVarDataList.append( CreateSettingsConVarData( "miles_output_device", eConVarType.STRING ) )
		file.conVarDataList.append( CreateSettingsConVarData( "miles_channels", eConVarType.INT ) )

}


void function SoundPanel_UpdateChannelConfigOption()
{
	int numChannelOptions = SoundOptions_SetupChannelConfigOptions( file.contentPanel, "SwchSpeakerConfig" )
	bool presentChannelsOption = GetConVarBool( "miles_channels_menuoption") && numChannelOptions > 2 && !SoundOptions_IsBadDevice()
	SoundPanelSetButtonVisible( file.contentPanel, "SwchSpeakerConfig", presentChannelsOption )
}

void function SoundPanel_UpdateDriverOptions()
{
	SoundOptions_SetupVoiceInputDeviceOptions( file.contentPanel, "SwchInputDevice" )
	SoundOptions_SetupOutputDeviceOptions( file.contentPanel, "SwchOutputDevice" )

	bool invalidDevice = SoundOptions_IsBadDevice()
	bool presentOutputOption = SoundOptions_DeviceSwitchingAvailable() && !invalidDevice

	var warning = Hud_GetChild( file.contentPanel, "NoDeviceWarningText" )
	Hud_SetVisible( warning, invalidDevice)

	
	SoundPanelSetButtonVisible( file.contentPanel, "SwchOutputDevice", presentOutputOption )

	bool presentSpatialOption = HasConVar( "miles_spatial_menuoption" ) && GetConVarBool( "miles_spatial_menuoption" ) && !invalidDevice
	SoundPanelSetButtonVisible( file.contentPanel, "SwchSpatialAudio", presentSpatialOption )

	SoundPanel_UpdateChannelConfigOption()
}


void function OnSoundPanel_Show( var panel )
{
	file.active = true

	ScrollPanel_SetActive( panel, true )
	Hud_SetEnabled( file.audioLanguageButton, IsAudioLanguageChangeAllowed() )


	thread UpdateVoiceMeter()

	SoundPanel_UpdateDriverOptions()











	const string aboveElem = "SwchSoundWithoutFocus"




	var vipButton = Hud_GetChild( file.contentPanel, "SwchVipTelemetry" )
	if (GetConVarString( "XLOG_TLS_hostname" ).len() != 0 )
	{
		Hud_Show( vipButton )
		Hud_SetEnabled( vipButton, true )
		Hud_SetNavDown( Hud_GetChild( file.contentPanel, aboveElem ), vipButton )
	}
	else
	{
		Hud_Hide( vipButton )
		Hud_SetEnabled( vipButton, false )
		Hud_SetNavDown( Hud_GetChild( file.contentPanel, aboveElem ), null )
	}
	SettingsPanel_SetContentPanelHeight( file.contentPanel )
	ScrollPanel_Refresh( panel )
}


void function OnSoundPanel_Hide( var panel )
{
	file.active = false

	ScrollPanel_SetActive( panel, false )

	SaveSettingsConVars( file.conVarDataList )
	Signal( uiGlobal.signalDummy, "UpdateVoiceMeter" )

	SavePlayerSettings()
}


void function OnAudioLanguageControlChanged( var button )
{
	if ( IsAudioLanguageChanged() )
		thread RebootMiles()
}


bool function IsAudioLanguageChanged()
{
	string currentVal = GetConVarString( "miles_language" )
	if ( currentVal == file.miles_language )
		return false

	file.miles_language = currentVal

	return true
}


void function RebootMiles()
{
	Signal( uiGlobal.signalDummy, "EndRebootMiles" )
	EndSignal( uiGlobal.signalDummy, "EndRebootMiles" )

	AdvanceMenu( file.processingDialog )
	
	WaitFrame() 

	ClientCommand( "miles_reboot" )
	ResetKeyRepeater()

	string checkSound = "Music_Lobby"
	var handle = null

	
	while ( handle == null || !IsSoundStillPlaying( handle ) )
	{
		WaitFrame()
		handle = EmitUISound( checkSound )
	}
	StopUISoundByName( checkSound )

	Assert( GetActiveMenu() == file.processingDialog )
	CloseActiveMenu()

	UIMusicUpdate()
}


array<ConVarData> function SoundPanel_GetConVarData()
{
	return file.conVarDataList
}


void function FooterButton_Focused( var button )
{
}



void function UpdateVoiceMeter()
{
	Signal( uiGlobal.signalDummy, "UpdateVoiceMeter" )
	EndSignal( uiGlobal.signalDummy, "UpdateVoiceMeter" )

	while ( true )
	{
		RuiSetFloat( file.voiceSensitivitySliderRui, "voiceProgress", GetConVarFloat( "speex_audio_value" ) / 10000.0 )
		RuiSetFloat( file.voiceSensitivitySliderRui, "voiceThreshhold", GetConVarFloat( "speex_quiet_threshold" ) / 10000.0 )
		WaitFrame()
	}
}


void function OnOutputDeviceChanged( var option )
{
	SoundPanel_UpdateChannelConfigOption()
}


void function OpenConfirmRestoreSoundDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_AUDIO_DEFAULTS"
	data.messageText = "#RESTORE_AUDIO_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			thread RestoreSoundDefaults()
	}
}

void function RestoreSoundDefaults()
{
	SetConVarToDefault( "speechtotext_enabled" )
	SetConVarToDefault( "sound_volume" )
	SetConVarToDefault( "sound_volume_sfx" )
	SetConVarToDefault( "sound_volume_dialogue" )
	SetConVarToDefault( "sound_volume_music_game" )
	SetConVarToDefault( "sound_volume_music_lobby" )
	SetConVarToDefault( "closecaption" )
	if ( IsAudioLanguageChangeAllowed() )
		SetConVarToDefault( "miles_language" )

		SetConVarToDefault( "miles_output_device" )
		SetConVarToDefault( "miles_channels" )
		SetConVarToDefault( "voice_input_device" )
		SetConVarToDefault( "TalkIsStream" )
		SetConVarToDefault( "hudchat_play_text_to_speech" )
		SetConVarToDefault( "sound_volume_voice" )
		SetConVarToDefault( "miles_occlusion" )
		SetConVarToDefault( "sound_without_focus" )
		SetConVarToDefault( "speex_quiet_threshold" )




	SaveSettingsConVars( file.conVarDataList )
	SavePlayerSettings()

	if ( IsAudioLanguageChangeAllowed() && IsAudioLanguageChanged() )
		waitthread RebootMiles()

	EmitUISound( "menu_advocategift_open" )
}

bool function IsAudioLanguageChangeAllowed()
{
	return Hud_IsVisible( file.audioLanguageButton ) && IsLobby()
}


void function InitProcessingDialog( var menu )
{
	file.processingDialog = menu
	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ProcessingDialog_OnNavigateBack )
}

void function ProcessingDialog_OnNavigateBack()
{
}


void function UICodeCallback_RefreshSoundOptions()
{
	if ( file.active )
	{
		SoundPanel_UpdateDriverOptions()
	}
}

