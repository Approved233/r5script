


global function SurvivalGroundList_LevelInit



global function InitSurvivalGroundList
global function OpenSurvivalGroundListMenu

global function ClientToUI_SurvivalGroundList_OpenQuickSwap
global function ClientToUI_SurvivalGroundList_RefreshQuickSwap
global function ClientToUI_SurvivalGroundList_CloseQuickSwap
global function ClientToUI_RestrictedLootConfirmDialog_Open

















































































struct FileStruct_LifetimeLevel
{
	table signalDummy




























}




FileStruct_LifetimeLevel& fileLevel 

struct {
	var menu

	var quickSwapBacker
	var quickSwapGrid
	var quickSwapHeader
	var inventorySwapIcon
} fileVM 




void function SurvivalGroundList_LevelInit()
{

		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel



















}




void function InitSurvivalGroundList( var menu )
{
	fileVM.menu = menu

	Survival_RegisterInventoryMenu( menu )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMenuNavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMenuShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	Survival_AddPassthroughCommandsToMenu( menu )
	AddMenuFooterOption( menu, LEFT, KEY_TAB, true, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )
	AddMenuFooterOption( menu, RIGHT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )






	fileVM.quickSwapBacker = Hud_GetChild( menu, "QuickSwapBacker" )
	fileVM.inventorySwapIcon = Hud_GetChild( menu, "SwapIcon" )
	fileVM.quickSwapHeader = Hud_GetChild( menu, "QuickSwapHeader" )
	fileVM.quickSwapGrid = Hud_GetChild( menu, "QuickSwapGrid" )
	RuiSetString( Hud_GetRui( fileVM.quickSwapHeader ), "headerText", "#PROMPT_QUICK_SWAP" )
	RuiSetImage( Hud_GetRui( fileVM.inventorySwapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )
	GridPanel_Init( fileVM.quickSwapGrid, INVENTORY_ROWS, INVENTORY_COLS, OnQuickSwapItemBind, GetInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( fileVM.quickSwapGrid, UIE_CLICK, OnQuickSwapItemClick )
	GridPanel_SetButtonHandler( fileVM.quickSwapGrid, UIE_CLICKRIGHT, OnQuickSwapItemClickRight )
	RegisterButtonPressedCallback( MOUSE_LEFT, OnMouseLeftPressed )

	RegisterStickMovedCallback( ANALOG_RIGHT_Y, HandleAnalogStickScroll )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnMouseWheelScrollUp )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnMouseWheelScrollDown )

}




void function OnMenuOpen()
{
	RunClientScript( "UIToClient_SurvivalGroundListOpened", fileVM.menu )
}




void function OnMenuNavBack()
{
	if ( Hud_IsVisible( fileVM.quickSwapGrid ) )
	{
		RunClientScript( "UIToClient_CloseQuickSwapIfOpen" )
		return
	}

	CloseActiveMenu()
}




void function OnMenuShow()
{
	SetMenuReceivesCommands( fileVM.menu, true )
	SetBlurEnabled( false )

	RunClientScript( "UICallback_UpdatePlayerInfo", Hud_GetChild( fileVM.menu, "PlayerInfo" ) )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( fileVM.menu, "TeammateInfo0" ), false )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( fileVM.menu, "TeammateInfo1" ), false )




}




void function OnMenuClose()
{
	SetBlurEnabled( false )
	RunClientScript( "UIToClient_SurvivalGroundListClosed" )
}



void function OpenSurvivalGroundListMenu()
{
	CloseAllMenus()
	AdvanceMenu( fileVM.menu )
}























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































void function ClientToUI_RestrictedLootConfirmDialog_Open( bool isBlackMarketOwner, int restrictedLootType )
{
	ConfirmDialogData data
	array<string> dialogArray = SURVIVAL_Loot_GetRestrictedDialogArray( restrictedLootType )
	data.headerText = Localize( dialogArray[0] )


	if ( isBlackMarketOwner && restrictedLootType != eRestrictedLootTypes.SPECTRE_SHACK )



	{
		data.messageText = Localize( dialogArray[1] )

		data.resultCallback = void function( int result ) {
			if ( result == eDialogResult.YES )
				RunClientScript( "UIToClient_RestrictedLootConfirmDialog_DoIt" )
		}
		OpenConfirmDialogFromData( data )
	}
	else
	{
		data.messageText = Localize( dialogArray[2] )
		OpenOKDialogFromData( data )
	}
}










































































































































































































































































































void function ClientToUI_SurvivalGroundList_RefreshQuickSwap()
{
	GridPanel_Refresh( fileVM.quickSwapGrid )
}




void function ClientToUI_SurvivalGroundList_OpenQuickSwap( var itemButton )
{
	GridPanel_Refresh( fileVM.quickSwapGrid )

	Hud_Show( fileVM.quickSwapGrid )
	Hud_Show( fileVM.quickSwapHeader )
	Hud_Show( fileVM.inventorySwapIcon )
	Hud_Show( fileVM.quickSwapBacker )

	int buttonY    = Hud_GetY( itemButton ) + (Hud_GetHeight( itemButton ) / 2)
	int gridHeight = Hud_GetHeight( fileVM.quickSwapGrid )
	int gridOffset = -buttonY + (gridHeight / 2)
	Hud_SetY( fileVM.quickSwapGrid, gridOffset )

	int gridWidth = Hud_GetWidth( fileVM.quickSwapGrid )
	Hud_SetSize( fileVM.quickSwapHeader, gridWidth + ContentScaledXAsInt( 18 ), ContentScaledYAsInt( 64 ) )
	Hud_SetSize( fileVM.quickSwapBacker, gridWidth + ContentScaledXAsInt( 18 ), gridHeight - ContentScaledYAsInt( 14 ) )

	var firstGridButton  = Hud_GetChild( fileVM.quickSwapGrid, "GridButton0x0" )
	var secondGridButton = Hud_GetChild( fileVM.quickSwapGrid, "GridButton1x0" )
	Hud_SetNavRight( itemButton, firstGridButton )
	Hud_SetNavLeft( secondGridButton, itemButton )
	Hud_SetNavLeft( secondGridButton, itemButton )
	if ( GetDpadNavigationActive() )
		Hud_SetFocused( firstGridButton )
}




void function ClientToUI_SurvivalGroundList_CloseQuickSwap( var itemButton )
{
	Hud_Hide( fileVM.quickSwapGrid )
	Hud_Hide( fileVM.quickSwapHeader )
	Hud_Hide( fileVM.inventorySwapIcon )
	Hud_Hide( fileVM.quickSwapBacker )
}




void function OnQuickSwapItemBind( var panel, var button, int index )
{
	Hud_ClearToolTipData( button )
	RunClientScript( "UIToClient_SurvivalGroundList_UpdateQuickSwapItem", button, TranslateBackpackGridPosition( index ) )
}















































void function OnQuickSwapItemClick( var panel, var button, int index )
{
	RunClientScript( "UIToClient_SurvivalGroundList_OnQuickSwapItemClick", button, TranslateBackpackGridPosition( index ), false )
}




void function OnQuickSwapItemClickRight( var panel, var button, int index )
{
	RunClientScript( "UIToClient_SurvivalGroundList_OnQuickSwapItemClick", button, TranslateBackpackGridPosition( index ), true )
}





























































void function OnMouseLeftPressed( var _ )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_SurvivalGroundList_OnMouseLeftPressed" )
}



void function OnMouseWheelScrollUp( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_OnMouseWheelScrollUp", button )
}



void function OnMouseWheelScrollDown( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_OnMouseWheelScrollDown", button )
}



void function HandleAnalogStickScroll( entity player, float val )
{
	if ( CanRunClientScript() )
		RunClientScript( "UIToClient_DeathBoxListPanel_HandleAnalogStickScroll", player, val )
}

























void function OnWeaponSwapButtonClick( var button )
{
	RunClientScript( "UIToClient_WeaponSwap" )
}











































