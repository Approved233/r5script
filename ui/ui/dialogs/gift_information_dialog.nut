global function InitGiftInformationDialog
global function OpenGiftInfoPopUp
global function OpenGiftInfoPopUpWithEventTabTelemetry
global function OpenGiftInfoPopUpWithMilestoneStoreTelemetry
global function InitTwoFactorInformationDialog
global function OpenTwoFactorInfoDialog
struct {
	var menu
	var infoPanel
}giftFile

struct
{
	var menu
	var infoPanel
}factorFile

const string twoFactorUrl = "https://help.ea.com/ihi/azib1OsUic"

void function InitGiftInformationDialog( var newMenuArg )
{
	var menu = newMenuArg
	giftFile.menu = menu

	giftFile.infoPanel = Hud_GetChild( menu, "InfoPanel" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	SetDialog( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, GiftInformationDialog_OnOpen )
}

void function GiftInformationDialog_OnOpen()
{
	int minAccountLevel = GetConVarInt( "mtx_giftingMinAccountLevel" )
	int minFriendshipTenure = ( GetConVarInt( "mtx_giftingMinFriendshipInDays" ) + DAYS_PER_WEEK - 1 ) / DAYS_PER_WEEK 
	int maxGiftsPerDay = GetConVarInt( "mtx_giftingLimit" )

	HudElem_SetRuiArg( giftFile.infoPanel, "playerDescription", Localize( "#GIFT_INFO_PLAYER_DESC", minAccountLevel, minFriendshipTenure, maxGiftsPerDay ) )
}

void function OpenGiftInfoPopUp( var button )
{
	if ( GetActiveMenu() != giftFile.menu )
		AdvanceMenu( GetMenu( "GiftInfoDialog" ) )
}

void function OpenGiftInfoPopUpWithEventTabTelemetry( var button )
{
	RTKEventsPanelController_SendPageViewInfoPage( "giftingInfoDialog" )
	OpenGiftInfoPopUp( button )
}

void function OpenGiftInfoPopUpWithMilestoneStoreTelemetry( var button )
{
	StoreMilestoneEvents_SendPageViewInfoPage( "giftingInfoDialog" )
	OpenGiftInfoPopUp( button )
}

void function InitTwoFactorInformationDialog( var newMenuArg )
{
	var menu = newMenuArg
	factorFile.menu = menu

	factorFile.infoPanel = Hud_GetChild( menu, "InfoPanel" )


	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, TwoFactorInfo_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#GO_TO_LINK", "#GO_TO_LINK", GoToLink_OnClick )

	SetDialog( menu, true )
}

void function GoToLink_OnClick( var button )
{
	LaunchExternalWebBrowser( twoFactorUrl, WEBBROWSER_FLAG_NONE )
}

void function OpenTwoFactorInfoDialog( var button )
{
	if ( GetActiveMenu() != factorFile.menu )
		AdvanceMenu( GetMenu( "TwoFactorInfoDialog" ) )
}

void function TwoFactorInfo_OnClose()
{
	RefreshTwoFactorAuthenticationStatus()
}
