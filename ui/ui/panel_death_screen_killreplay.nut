global function InitDeathScreenKillreplayPanel

struct
{
	var panel
} file

void function InitDeathScreenKillreplayPanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, KillreplayOnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, KillreplayOnClosePanel )

	SetPanelClearBlur( panel, true )

	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.KILLREPLAY )
}


void function KillreplayOnOpenPanel( var panel )
{
	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )

	RegisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	RegisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )

		RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, DeathScreenTryToggleUpgradesOnGladCard )
		RegisterButtonPressedCallback( KEY_V, DeathScreenTryToggleUpgradesOnGladCard )

	RegisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	RegisterButtonPressedCallback( GetPCReportKey(), DeathScreenOnReportButtonClick )
	RegisterButtonPressedCallback( KEY_TAB, DeathScreenSkipDeathCam )
	UpdateFooterOptions()

	DeathScreenUpdateCursor()
}

void function KillreplayOnClosePanel( var panel )
{
	DeathScreenSkipDeathCam( null )

	DeregisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	DeregisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )

		DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, DeathScreenTryToggleUpgradesOnGladCard )
		DeregisterButtonPressedCallback( KEY_V, DeathScreenTryToggleUpgradesOnGladCard )

	DeregisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	DeregisterButtonPressedCallback( GetPCReportKey(), DeathScreenOnReportButtonClick )
	DeregisterButtonPressedCallback( KEY_TAB, DeathScreenSkipDeathCam )
}
