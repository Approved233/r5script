global function InitSurvivalQuickInventoryPanel

global function InitSquadPanelInventory
global function InitCharacterDetailsPanel
global function InitLegendPanelInventory
global function InitInventoryFooter
global function InitSquadFooter

global function SurvivalGroundItem_SetGroundItemCount
global function SurvivalGroundItem_SetGroundItemHeader
global function SurvivalGroundItem_IsHeader

global function SurvivalQuickInventory_OnUpdate

global function SurvivalQuickInventory_NavigateBack

global function SurvivalQuickInventory_SetEmptyTooltipForSlot
global function SurvivalQuickInventory_SetClientUpdateDefaultTooltipData

global function ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed
global function ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged
global function SurvivalQuickInventory_UpdateEquipmentForActiveWeapon
global function SurvivalQuickInventory_UpdateWeaponSlot
global function SurvivalInventoryMenu_SetSpaceForSling

global function SurvivalInventoryMenu_SetEquipmentButtonFxState


global function OnUpgradeTreeEnableNavigation



global function ClientToUI_UpdateInventoryUltimateTooltip


global function GetGroundItemCount
global function Survival_CommonButtonInit
global function GetInventoryItemCount
global function ClientToUI_UpdateInventoryDpadTooltip
global function TranslateBackpackGridPosition

global function ClientCallback_SetTempButtonRef
global function ClientCallback_SetTempButtonIcon
global function ClientCallback_SetTempBoolMouseDragAllowed
global function ClientCallback_StartEquipmentExtendedUse

global function ConvertCursorToScreenPos

const float INACTIVE_WEAPON_SCALE = 0.8

global const int INVENTORY_ROWS = 2
global const int INVENTORY_COLS = 8

const float MOUSE_DRAG_BUFFER = 25.0
const float MOUSE_DRAG_BUFFER_TIME = 1.0

table<int, string> clickStringForLoot
table<int, string> clickRightStringForLoot

struct CommonButtonData
{
	int useCount
	int pingCount
}

struct
{
	var mainPanel

	var inventoryGridStatic

	var mainInventoryPanel

	var characterDetailsPanel
	var characterDetailsRui

	var overlay
	var holdToUseElem

	bool compactModeEnabled = false

	bool isSwappingWeapons = false

	int groundItemCount = 0

	array<bool>    groundItemHeaders = []

	table< string, var > equipmentButtons = {}

	table< string, var > requestButtons = {}

	table<var, CommonButtonData> useDataForButtons = {}

	string tempButtonRef
	bool   tempBoolMouseDragAllowed
	asset tempButtonIcon = $""

	table<var, void functionref( var, var, var, int ) > onMouseDropCallbacks
	array<var>                                          allDropSlots
} file

void function Survival_CommonButtonInit( var button )
{
	CommonButtonData bd
	file.useDataForButtons[button] <- bd
}


void function ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged( var button )
{
	CommonButtonData bd = file.useDataForButtons[button]
	bd.pingCount += 1
	var rui = Hud_GetRui( button )
	RuiSetInt( rui, "pingCounter", bd.pingCount )
}


void function ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed( var button )
{
	CommonButtonData bd = file.useDataForButtons[button]
	bd.useCount += 1
	var rui = Hud_GetRui( button )
	RuiSetInt( rui, "useCounter", bd.useCount )
}


void function InitSurvivalQuickInventoryPanel( var panel )
{
	file.mainPanel = panel

	RegisterSignal( "StopMouseDrag" )
	RegisterSignal( "StartEquipmentExtendedUse" )
	RegisterSignal( "EquipmentSlingDecorations" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSurvivalQuickInventoryPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSurvivalQuickInventoryPanel_Hide )

	InitInventoryFooter( panel )

	file.mainInventoryPanel = Hud_GetChild( panel, "MainInventory" )
	InitMainInventoryPanel( file.mainInventoryPanel )

	array<var> dropSlots = GetElementsByClassname( GetParentMenu( panel ), "DropSlot" )

	foreach ( slot in dropSlots )
	{
		RegisterDropSlot( slot, null )
		if ( Hud_GetScriptID( slot ) == "ground" )
		{
			var rui = Hud_GetRui( slot )
			RuiSetBool( rui, "isAlwaysVisible", true )
			RuiSetString( rui, "optionalText", "#INVENTORY_SLOT_GROUND" )
		}
	}

	var reskin0 = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin0" )
	Hud_AddEventHandler( reskin0, UIE_CLICK, OnReskinButtonClick )

	var reskin1 = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin1" )
	Hud_AddEventHandler( reskin1, UIE_CLICK, OnReskinButtonClick )

	file.inventoryGridStatic = Hud_GetChild( file.mainInventoryPanel, "BackpackGrid" )
	GridPanel_Init( file.inventoryGridStatic, INVENTORY_ROWS, INVENTORY_COLS, OnBindBackpackItem, GetMaxInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_CLICK, OnBackpackItemClick )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_CLICKRIGHT, OnBackpackItemClickRight )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_GET_FOCUS, OnBackpackItemGetFocus )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_LOSE_FOCUS, OnBackpackItemLoseFocus )
	GridPanel_SetKeyPressHandler( file.inventoryGridStatic, OnBackpackItemKeyPress )
	GridPanel_SetCommandHandler( file.inventoryGridStatic, OnBackpackItemCommand )

	var elem = Hud_GetChild( panel, "MouseDragIcon" )
	Hud_Hide( elem )

	file.holdToUseElem = Hud_GetChild( Hud_GetParent( panel ), "HoldToUseElem" )

	AddUICallback_OnResolutionChanged( OnSurvivalQuickInventoryPanel_Refresh )
	AddUICallback_LevelShutdown( OnLevelShutdown )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "basicImage", $"rui/menu/inventory/backpack_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketL", "basicImage", $"rui/menu/inventory/backpack_container_side_bracket", eRuiArgType.IMAGE )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "imageRotation", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketL", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "basicImage", $"rui/menu/inventory/gear_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketL", "basicImage", $"rui/menu/inventory/gear_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "imageRotation", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketL", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImageColor", <0.0, 0.0, 0.0>, eRuiArgType.VECTOR )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImageAlpha", 0.65, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "maskImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "textureImage", $"rui/menu/inventory/backpack_container_texture", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "basicImageAlpha", 0.25, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "maskImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "textureImage", $"rui/menu/inventory/backpack_container_texture", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "basicImageAlpha", 0.25, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "imageRotation", 0.5, eRuiArgType.FLOAT )


	if ( !(uiGlobal.uiShutdownCallbacks.contains( Inventory_Shutdown )) )
		AddUICallback_UIShutdown( Inventory_Shutdown )

	AddUICallback_InputModeChanged( Inventory_OnInputChanged )
}

void function Inventory_OnInputChanged( bool isController )
{
	if( !IsPanelActive( file.mainPanel ) )
		return

	foreach ( button in file.equipmentButtons )
	{
		Hud_ClearToolTipData( button )
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_UpdateEquipmentButton", button )
	}
}

void function InitInventoryFooter( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "", "", SurvivalMenuSwapWeapon, IsSurvivalMenuEnabled )

	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, false, "", "", TryToggleMap )

	AddPanelFooterOption( panel, LEFT, KEY_M, false, "", "", TryToggleMap, PROTO_ShouldInventoryFooterHack )
	AddPanelFooterOption( panel, LEFT, KEY_TAB, false, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, RIGHT, BUTTON_START, true, "#HINT_SYSTEM_MENU_GAMEPAD", "#HINT_SYSTEM_MENU_KB", TryOpenSystemMenu )

#if DEV
		AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, true, "#LEFT_STICK_DEV_MENU", "#DEV_MENU", OpenDevMenu )
#endif
}

void function InitSquadFooter( var panel )
{
	var parentMenu = GetParentMenu( panel )

	if( parentMenu != GetMenu( "DeathScreenMenu" ) ) 
	{
		AddPanelFooterOption( panel, LEFT, BUTTON_BACK, false, "", "", TryToggleMap )

		AddPanelFooterOption( panel, LEFT, KEY_M, false, "", "", TryToggleMap, PROTO_ShouldInventoryFooterHack )
		AddPanelFooterOption( panel, LEFT, KEY_TAB, false, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )

		AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
#if DEV
			AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, true, "#LEFT_STICK_DEV_MENU", "#DEV_MENU", OpenDevMenu )
#endif
		AddPanelFooterOption( panel, RIGHT, BUTTON_START, true, "#HINT_SYSTEM_MENU_GAMEPAD", "#HINT_SYSTEM_MENU_KB", TryOpenSystemMenu )
	}
	else
	{
		InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SQUAD)
	}
}


void function RegisterDropSlot( var button, void functionref( var, var, var, int ) dropFunc )
{
	file.allDropSlots.append( button )
	file.onMouseDropCallbacks[ button ] <- dropFunc
	Hud_SetAboveBlur( button, false )
}


void function InitCharacterDetailsPanel( var panel )
{
	file.characterDetailsPanel = panel
	file.characterDetailsRui = Hud_GetRui( file.characterDetailsPanel )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowCharacterDetails )

	InitInventoryFooter( panel )
}


void function OnShowCharacterDetails( var panel )
{
	SurvivalInventory_SetBGVisible( true )
}


void function OnSurvivalQuickInventoryPanel_Show( var panel )
{
	var menu = GetParentMenu( panel )

	UISize screenSize = GetScreenSize()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

	file.compactModeEnabled = false

	SurvivalQuickInventory_OnUpdate()

	Hud_Show( file.mainInventoryPanel )
	SurvivalInventory_SetBGVisible( true )




		Hud_SetVisible( Hud_GetChild( panel, "IngameTextChatHistory" ), IsAccessibilityChatToSpeech() )


	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_BackpackOpened" )


		int numUpgradeSlots = UPGRADE_CORE_NUM_EXPECTED_UPGRADES / UPGRADE_CORE_NUM_EXPECTED_UPGRADES_PER_LEVEL
		for( int playerId = 0; playerId < 2; playerId++ )
		{
			for( int upgradeId = 0; upgradeId < numUpgradeSlots; upgradeId++ )
			{
				RunClientScript( "UICallback_UpdateTeammateUpgrades", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo" + playerId ), upgradeId )
			}
		}


	var smallPlayerInfo   = Hud_GetChild( file.mainInventoryPanel, "smallPlayerInfo" )
	var largePlayerInfo   = Hud_GetChild( file.mainInventoryPanel, "PlayerInfo" )
	var TeammateInfo0     = Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" )
	float screenSizeYFrac =  GetScreenSize().height / 1080.0

	bool showPlayerInfo   = false
	int TeammateInfo0YPos = Hud_GetBaseY( TeammateInfo0 )



	if( GetMaxTeamSizeForPlaylist( GetCurrentPlaylistName() ) > 3 )
	{
		RunClientScript( "UICallback_UpdateTeammateInfo", smallPlayerInfo, false )
		TeammateInfo0YPos +=  int( -110 * screenSizeYFrac ) 
	}
	else
	{
		RunClientScript( "UICallback_UpdatePlayerInfo", largePlayerInfo )
		showPlayerInfo = true
	}

	Hud_SetVisible( smallPlayerInfo, !showPlayerInfo )
	Hud_SetVisible( largePlayerInfo, showPlayerInfo )
	Hud_SetY( TeammateInfo0, TeammateInfo0YPos )

	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ), false )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ), false )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo2" ), false )
	RunClientScript( "UICallback_UpdateUltimateInfo", Hud_GetChild( file.mainInventoryPanel, "PlayerUltimate" ) )

	UpdateMouseDropGroundSizes()
}


void function UpdateMouseDropGroundSizes()
{

		var mouseDropGroundLeft = Hud_GetChild( file.mainInventoryPanel, "MouseDropGroundLeft" )
		var mouseDropGroundRight = Hud_GetChild( file.mainInventoryPanel, "MouseDropGroundRight" )

		int mouseDropGroundLeftWidth = Hud_GetBaseWidth( mouseDropGroundLeft )
		int mouseDropGroundRightWidth = Hud_GetBaseWidth( mouseDropGroundRight )

		int targetLeftWidth = mouseDropGroundLeftWidth
		int targetRightWidth = mouseDropGroundRightWidth
		if( UpgradeCore_IsEnabled() )
		{
			UIScaleFactor scaleFactor = GetContentFixedScaleFactor( file.mainInventoryPanel )
			targetLeftWidth = int( 640.0 * scaleFactor.x )
			targetRightWidth = int( 180.0 * scaleFactor.x )
		}
		Hud_SetWidth( mouseDropGroundLeft, targetLeftWidth )
		Hud_SetWidth( mouseDropGroundRight, targetRightWidth )

}


void function Delayed_SetCursorToOffsetInventoryPosition( float offset )
{
	wait 0.01

	float width  = 1920
	float height = 1080

#if DEV
	if( !IsControllerModeActive() )
	{
		float screenSizeYFrac = GetScreenSize().height / 1080.0
		
		WarpMouseCursorDEV( <((width * 0.5) + offset) * screenSizeYFrac, (height * 0.5) * screenSizeYFrac, 0> )
	}
	else
#endif
	{
		SetCursorPosition( <(width * 0.5) + offset, height * 0.5, 0> )
	}
}



void function ClientToUI_UpdateInventoryUltimateTooltip( var button, string ultName )
{
	if ( ultName == "" )
	{
		Hud_ClearToolTipData( button )
		return
	}

	ToolTipData ttd
	ttd.titleText = ultName
	ttd.descText = "#INVENTORY_LABEL_ULTIMATE_READY"
	ttd.commsPromptDefault = IsControllerModeActive() ? "#PING_PROMPT_ULTIMATE_STATUS_GAMEPAD" : "#PING_PROMPT_ULTIMATE_STATUS"
	ttd.tooltipFlags = eToolTipFlag.SOLID
	ttd.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, ttd )
}


void function OnSurvivalQuickInventoryPanel_Refresh()
{
	SurvivalQuickInventory_OnUpdate()
}


void function OnSurvivalQuickInventoryPanel_Hide( var panel )
{
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ) ) )
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ) ) )

	SurvivalMenu_AckAction()

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	CloseCharacterDetails()

	RunClientScript( "UICallback_BackpackClosed" )
}


void function SurvivalQuickInventory_OnUpdate()
{
	GridPanel_Refresh( file.inventoryGridStatic )

	if ( !IsFullyConnected() )
		return

	if ( GetActiveMenu() != GetParentMenu( file.mainPanel ) )
		return

	if ( IsLobby() )
		return


		entity localPlayer = GetLocalClientPlayer()
		if( UpgradeCore_IsEnabled() && IsValid( localPlayer) && UpgradeCore_PlayerHasUpgradesDefined( localPlayer ) )
		{
			UpdatePlayerUpgradeInfo()
		}


	foreach ( button in file.equipmentButtons )
	{
		Hud_ClearToolTipData( button )
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_UpdateEquipmentButton", button )
	}

	foreach ( button in file.requestButtons )
	{
		Hud_ClearToolTipData( button )
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_UpdateRequestButton", button )
	}


	UpdateArmorCoreEquipmentButtonPosition()

	var rtkUpgradeTree = Hud_GetChild( file.mainInventoryPanel, "RTKPlayerUpgradeInfo" )
	Hud_SetVisible( rtkUpgradeTree, UpgradeCore_ArmorTiedToUpgrades() && UpgradeCore_ShowUpgradeTreeInventory() )


	UpdateBackpackDpadNav()

	
	
	
	array<string> attachmentSuffix =
	[
		"Barrel",
		"Mag",
		"Sight",
		"Grip",
		"Hopup",
		"HopupMulti_a",
		"HopupMulti_b",
	]

	for ( int i = 0; i < 2; i++ )
	{
		string prefix       = "MainWeapon" + i
		bool didDpadMapping = false

		var prevButton = null
		foreach ( suffix in attachmentSuffix )
		{
			var button = Hud_GetChild( file.mainInventoryPanel, prefix + "_" + suffix )

			Hud_SetX( button, Hud_GetBaseX( button ) )

			if ( prevButton != null )
			{
				if ( Hud_GetWidth( prevButton ) == 0 )
				{
					Hud_SetX( button, 0 )
				}
				else if ( !didDpadMapping )
				{
					
					var mainWeapon = Hud_GetChild( file.mainInventoryPanel, prefix )
					Hud_SetNavUp( mainWeapon, prevButton )
					didDpadMapping = true
				}
			}

			prevButton = button
		}
	}
	
}


void function Callback_PlayerInventoryChanged()
{
	GridPanel_Refresh( file.inventoryGridStatic )
}


void function SurvivalGroundItem_AddItem( int lootIndex, string guid, int count, bool TEMP_hasMods )
{
}


string function GetEquipmentSlotTypeForButton( var button )
{
	string scriptID = Hud_GetScriptID( button )
	return scriptID
}


void function InitMainInventoryPanel( var panel )
{
	array<var> buttons = GetElementsByClassname( GetParentMenu( panel ), "SurvivalEquipment" )
	foreach ( button in buttons )
	{
		string equipmentType = GetEquipmentSlotTypeForButton( button )

		Hud_AddEventHandler( button, UIE_CLICK, OnEquipmentButtonClick )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnEquipmentItemGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnEquipmentItemLoseFocus )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, OnEquipmentButtonClickRight )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, OnEquipmentButtonMiddleClick )
		Hud_AddKeyPressHandler( button, OnEquipmentKeyPress )
		Hud_SetCommandHandler( button, OnEquipmentCommand )

		file.equipmentButtons[equipmentType] <- button

		Survival_CommonButtonInit( button )
	}

	array<var> requestButtons = GetElementsByClassname( GetParentMenu( panel ), "RequestButton" )
	foreach ( button in requestButtons )
	{

		string equipmentType = GetEquipmentSlotTypeForButton( button )

		Hud_AddEventHandler( button, UIE_CLICK, OnRequestButtonClick )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnRequestButtonGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnRequestButtonLoseFocus )
		Hud_AddKeyPressHandler( button, OnRequestKeyPress )
		Hud_SetCommandHandler( button, OnRequestButtonCommand )

		file.requestButtons[equipmentType] <- button

		Survival_CommonButtonInit( button )
	}


	{
		var button = Hud_GetChild( file.mainInventoryPanel, "PlayerUltimate" )
		
		
		
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnPlayerUltimateGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnPlayerUltimateLoseFocus )
		Hud_AddKeyPressHandler( button, OnPlayerUltimateKeyPress )
		Hud_SetCommandHandler( button, OnPlayerUltimateCommand )
		Survival_CommonButtonInit( button )
	}

}


void function OnPlayerUltimateGetFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )
}
void function OnPlayerUltimateLoseFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )
}
bool function OnPlayerUltimateKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingIsMyUltimateReady", button )
		return true
	}

	return false
}

void function OnPlayerUltimateCommand( var button, string command )
{
	if ( IsLobby() )
		return

	if ( command == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingIsMyUltimateReady", button )
	}
}


void function OnEquipmentItemGetFocus( var button )
{
	if ( GetMouseFocus() != button && !GetDpadNavigationActive() )
		return

	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )

	if ( Hud_HasToolTipData( button ) && GetDpadNavigationActive() )
	{
		LootData ld          = GetLootDataFromButton( button, -1 )
		ToolTipData ttd      = Hud_GetToolTipData( button )
		string equipmentSlot = Hud_GetScriptID( button )
		RunClientScript( "UIToClient_UpdateInventoryDpadTooltipText", ld.ref, ttd.titleText, equipmentSlot )
	}
	else
	{
		SetInventoryDpadTooltipVisible( false )
	}
}


void function OnEquipmentItemLoseFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )

	if ( !GetDpadNavigationActive() )
		SetInventoryDpadTooltipVisible( false )
}


void function OnEquipmentButtonClick( var button )
{
	if ( IsLobby() )
		return

	if ( !IsFullyConnected() )
		return

	if ( InputIsButtonDown( MOUSE_LEFT ) )
	{
		thread TrackMouseDrag( file.mainInventoryPanel, button, -1, OnEquipmentButtonClickAction )
		return
	}

	OnEquipmentButtonClickAction( file.mainInventoryPanel, button, -1 )
}

bool function OnRequestButtonPressed ( var button )
{
	if ( IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	RunClientScript( "UICallback_PingRequestButton", button )
	return true
}



void function OnRequestButtonClick( var button )
{
	string weaponButtonName = "MainWeapon0"
	if ( Hud_GetHudName( button ) == "MainWeaponChargeUp1" )
	{
		weaponButtonName = "MainWeapon1"
	}

	array<var> buttons = GetElementsByClassname( GetParentMenu( Hud_GetParent( button ) ), "SurvivalEquipment" )
	foreach( equipButton in buttons )
	{
		if ( Hud_GetHudName( equipButton ) == weaponButtonName )
			OnEquipmentButtonClick( equipButton )
	}
}

void function OnRequestButtonCommand( var button, string command )
{
	if ( IsLobby() )
		return

	if ( command == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingRequestButton", button )
	}
}

void function OnRequestButtonGetFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )
}

void function OnRequestButtonLoseFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )
}

bool function OnRequestKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		return OnRequestButtonPressed( button )
	}
	return false
}


void function OnEquipmentButtonClickAction( var panel, var button, int index )
{
	EmitUISound( "UI_InGame_Inventory_Select" )
	RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.PRIMARY_ACTION )
}

void function OnEquipmentButtonMiddleClick( var button )
{
	RunClientScript( "UICallback_PingEquipmentItem", button )
}

void function OnEquipmentButtonClickRight( var button )
{
	if ( IsLobby() )
		return

	if ( IsFullyConnected() )
	{
		EmitUISound( "UI_InGame_Inventory_Drop" )
		RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.ALT_ACTION )
	}
}


bool function OnEquipmentKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( IsLobby() )
		return false

	if ( !IsControllerModeActive() )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingEquipmentItem", button )
		return true
	}

	if ( keyId == BUTTON_SHOULDER_LEFT )
	{
		if ( IsFullyConnected() )
		{
			EmitUISound( "UI_InGame_Inventory_Select" )
			RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.PRIMARY_SWAP )
		}
		return true
	}

	if( keyId == BUTTON_TRIGGER_LEFT )
	{
		if ( IsFullyConnected() )
		{
			EmitUISound( "UI_InGame_Inventory_Select" )
			RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.CHARACTER_ACTION1 )
		}
		return true
	}

	if( keyId == BUTTON_TRIGGER_RIGHT )
	{
		if ( IsFullyConnected() )
		{
			EmitUISound( "UI_InGame_Inventory_Select" )
			RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.CHARACTER_ACTION2 )
		}
		return true
	}

	return false
}

void function OnEquipmentCommand( var button, string command )
{
	if ( IsLobby() || !IsFullyConnected() )
		return

	if ( command == "+ping" )
	{
		RunClientScript( "UICallback_PingEquipmentItem", button )
	}

	if ( command == "+melee" )
	{
		EmitUISound( "UI_InGame_Inventory_Select" )
		RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.PRIMARY_SWAP )
	}

	else if( command == "+offhand1" )
	{
		EmitUISound( "UI_InGame_Inventory_Select" )
		RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.CHARACTER_ACTION1 )
	}

	else if( command == "+use" )
	{
		EmitUISound( "UI_InGame_Inventory_Select" )
		RunClientScript( "UICallback_OnEquipmentButtonAction", button, eLootActionType.CHARACTER_ACTION2 )
	}
}


void function SurvivalQuickInventory_UpdateEquipmentForActiveWeapon( int activeWeaponSlot )
{
	array<int> allSlots = [ 0, 1 ]
	foreach ( slot in allSlots )
	{
		bool selected   = (activeWeaponSlot == slot)
		string slotName = "main_weapon" + slot

		Hud_SetSelected( file.equipmentButtons[slotName], selected )

		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
}

void function SurvivalQuickInventory_UpdateWeaponSlot( int weaponSlot, int skinTier, string skinName, string charmName )
{
	var reskin     = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin" + weaponSlot )
	bool isVisible = (skinTier > 0 && skinName != "") || (charmName != "")
	Hud_SetVisible( reskin, isVisible )

	ToolTipData toolTipData
	toolTipData.titleText = Localize( "#LOOT_APPLY_LOADOUT" )
	toolTipData.descText = skinName

	Hud_SetToolTipData( reskin, toolTipData )
}

void function OnReskinButtonClick( var button )
{
	int weaponSlot = int( Hud_GetScriptID( button ) )
	Hud_SetVisible( button, false )

	Remote_ServerCallFunction( "ClientCallback_WeaponCosmeticsApply", weaponSlot )
}


void function ScaleButton( string equipmentSlot, float scale )
{
	var button = file.equipmentButtons[equipmentSlot]
	Hud_SetWidth( button, Hud_GetBaseWidth( button ) * scale )
	Hud_SetHeight( button, Hud_GetBaseHeight( button ) * scale )
	Hud_SetX( button, Hud_GetBaseX( button ) * scale )
	Hud_SetY( button, Hud_GetBaseY( button ) * scale )
}


void function SurvivalGroundItem_SetGroundItemCount( int count )
{
	file.groundItemCount = count
	file.groundItemHeaders = []
	file.groundItemHeaders.resize( count, false )
}


int function GetGroundItemCount( var panel )
{
	return file.groundItemCount
}


void function SurvivalGroundItem_SetGroundItemHeader( int index, bool isHeader )
{
	file.groundItemHeaders[index] = isHeader
}


bool function SurvivalGroundItem_IsHeader( int index )
{
	if ( !file.groundItemHeaders.isvalidindex( index ) )
		return false

	return file.groundItemHeaders[index]
}


void function SurvivalQuickInventory_SetClientUpdateDefaultTooltipData( var button )
{
	ToolTipData dt
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	dt.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, dt )
}

void function SurvivalInventoryMenu_SetSpaceForSling( bool hasSling )
{
	int weaponOffset = hasSling ? 50 : 0
	var weapon0 = Hud_GetChild( file.mainInventoryPanel, "MainWeapon0" )
	Hud_SetY( weapon0, Hud_GetBaseY(weapon0) + ContentScaledYAsInt( weaponOffset ) )
	Hud_SetVisible(Hud_GetChild( file.mainInventoryPanel, "SlingDecorations" ), hasSling)
}


int function GetUpgradesCount( var panel )
{
	return 6
}

void function OnBindUpgrades( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	if( index >= 4 )
	{
		thread OnBindUpgrades_Hide_Delayed( button )
		return
	}

	Hud_ClearToolTipData( button )

	RunClientScript( "UICallback_UpdateUpgradeButton", button, index )
}

void function OnBindUpgrades_Hide_Delayed( var button )
{
	
	WaitFrame()
	Hud_SetVisible( button, false )
	Hud_SetEnabled( button, false )
}

void function OnUpgradeButtonClick( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	EmitUISound( "UI_InGame_Inventory_Select" )

	if ( !IsFullyConnected() )
		return

	float duration = 0.4
	StartMenuExtendedUse( button, file.holdToUseElem, duration, true, false, void function( bool success ) : (button, index) {
		if ( success )
			RunClientScript( "UICallback_OnUpgradeButtonAction", button, index )
	}, "UI_Survival_PickupTicker", "" )
}

bool function OnUpgradeKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	if ( !isDown )
		return false

	if ( IsLobby() )
		return false

	if ( !IsControllerModeActive() )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingUpgrade", button )
		return true
	}

	return false
}

void function OnUpgradeCommand( var panel, var button, int index, string command )
{
	if ( IsLobby() || !IsFullyConnected() )
		return

	if ( command == "+ping" )
	{
		RunClientScript( "UICallback_PingUpgrade", button )
	}
}

void function UpdatePlayerUpgradeInfo()
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_UpdateUpgradeInfo" )
}

void function OnUpgradeTreeEnableNavigation( bool isNavigationEnabled )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), isNavigationEnabled )
}


void function OnBindBackpackItem( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )
	Hud_ClearToolTipData( button )

	RunClientScript( "UICallback_UpdateInventoryButton", button, position )
}


void function OnBackpackItemClick( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )

	if ( InputIsButtonDown( MOUSE_LEFT ) )
	{
		thread TrackMouseDrag( panel, button, position, OnBackpackItemClickAction )
		return
	}

	OnBackpackItemClickAction( panel, button, position )
}


void function OnBackpackItemClickAction( var panel, var button, int index )
{
	EmitUISound( "UI_InGame_Inventory_Select" )

	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_OnInventoryButtonAction", button, index, eLootActionType.PRIMARY_ACTION )
}

void function OnBackpackItemClickRight( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return


	int position = TranslateBackpackGridPosition( index )
	EmitUISound( "UI_InGame_Inventory_Drop" )
	RunClientScript( "UICallback_OnInventoryButtonAction", button, position, eLootActionType.ALT_ACTION )
}


void function OnBackpackItemGetFocus( var panel, var button, int position )
{
	if ( GetMouseFocus() != button && !GetDpadNavigationActive() )
		return

	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )

	if ( Hud_HasToolTipData( button ) && GetDpadNavigationActive() )
	{
		int newPos           = TranslateBackpackGridPosition( position )
		LootData ld          = GetLootDataFromButton( button, newPos )
		ToolTipData ttd      = Hud_GetToolTipData( button )
		string equipmentSlot = Hud_GetScriptID( button )
		RunClientScript( "UIToClient_UpdateInventoryDpadTooltipText", ld.ref, ttd.titleText, equipmentSlot )
	}
	else
	{
		SetInventoryDpadTooltipVisible( false )
	}
}


void function OnBackpackItemLoseFocus( var panel, var button, int position )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )

	if ( !GetDpadNavigationActive() )
		SetInventoryDpadTooltipVisible( false )
}


bool function OnBackpackItemKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	int position = TranslateBackpackGridPosition( index )

	if ( !isDown )
		return false

	if ( IsLobby() )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		RunClientScript( "UICallback_PingInventoryItem", button, position )
		return true
	}

	if( keyId == BUTTON_TRIGGER_LEFT )
	{
		if ( IsFullyConnected() )
		{
			EmitUISound( "UI_InGame_Inventory_Select" )
			RunClientScript( "UICallback_OnInventoryButtonAction", button, position, eLootActionType.CHARACTER_ACTION1 )
		}
		return true
	}

	if( keyId == BUTTON_TRIGGER_RIGHT )
	{
		if ( IsFullyConnected() )
		{
			EmitUISound( "UI_InGame_Inventory_Select" )
			RunClientScript( "UICallback_OnInventoryButtonAction", button, position, eLootActionType.CHARACTER_ACTION2 )
		}
		return true
	}

	return false
}


void function OnBackpackItemCommand( var panel, var button, int index, string command )
{
	int position = TranslateBackpackGridPosition( index )

	if ( command == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingInventoryItem", button, position )
	}

	else if( command == "+offhand1" )
	{
		EmitUISound( "UI_InGame_Inventory_Select" )
		RunClientScript( "UICallback_OnInventoryButtonAction", button, position, eLootActionType.CHARACTER_ACTION1  )
	}

	else if( command == "+use" )
	{
		EmitUISound( "UI_InGame_Inventory_Select" )
		RunClientScript( "UICallback_OnInventoryButtonAction", button, position, eLootActionType.CHARACTER_ACTION2  )
	}
}


int function GetInventoryItemCount( var panel )
{
	return SurvivalInventoryMenu_GetInventoryLimit()
}


int function GetMaxInventoryItemCount( var panel )
{
	return SurvivalInventoryMenu_GetMaxInventoryLimit()
}


void function SurvivalQuickInventory_NavigateBack()
{
	CloseActiveMenu()
}


bool function IsOptionsFooterValid()
{
	return IsSurvivalMenuEnabled()
}


int function TranslateBackpackGridPosition( int position )
{
	int limit = SURVIVAL_GetInventoryLimit( GetLocalClientPlayer() )
	if ( position >= limit )
	{
		return position
	}

	int rows = INVENTORY_ROWS
	int cols = INVENTORY_COLS

	int currentCol = position / rows
	int currentRow = position % rows

	int newCols = int( ceil( float( limit ) / float( rows ) ) )

	int newPos = currentCol + (currentRow * newCols)

	return newPos
}


void function SurvivalQuickInventory_SetEmptyTooltipForSlot( var button, string title, int commsAction, int tooltipFlags )
{
	ToolTipData dt
	dt.titleText = title
	dt.descText = ""
	dt.tooltipFlags = eToolTipFlag.EMPTY_SLOT | eToolTipFlag.SOLID | tooltipFlags
	dt.commsAction = commsAction

	dt.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, dt )
}


void function TryOpenOptions( var button )
{
	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function TryToggleCharacterDetails( var button )
{
	if ( !IsValid( file.characterDetailsPanel ) )
		return

	if ( !IsSurvivalMenuEnabled() )
		return

	if ( Hud_IsVisible( file.characterDetailsPanel ) )
	{
		Hud_SetVisible( file.characterDetailsPanel, false )
	}
	else
	{
		Hud_SetVisible( file.characterDetailsPanel, true )
	}
}


void function CloseCharacterDetails()
{
	if ( !IsValid( file.characterDetailsPanel ) )
		return

	if ( !IsSurvivalMenuEnabled() )
		return

	if ( Hud_IsVisible( file.characterDetailsPanel ) )
		Hud_SetVisible( file.characterDetailsPanel, false )
}


void function TryToggleMap( var button )
{
	RunClientScript( "ClientToUI_ToggleScoreboard" )
}


void function TrackMouseDrag( var panel, var button, int index, void functionref(var, var, int) clickFunc )
{
	float startTime   = UITime()
	vector mouseStart = GetCursorPosition()

	float dist
	float elapsedTime
	bool dragStarted = false

	OnThreadEnd(
		function() : ()
		{
			Signal( uiGlobal.signalDummy, "StopMouseDrag" )
		}
	)

	if ( MouseDragAllowed( panel, button, index ) )
	{
		while( InputIsButtonDown( MOUSE_LEFT ) )
		{
			vector mouseEnd = GetCursorPosition()
			dist = Length( mouseEnd - mouseStart )
			elapsedTime = UITime() - startTime

			if ( !dragStarted && (elapsedTime > MOUSE_DRAG_BUFFER_TIME || dist > MOUSE_DRAG_BUFFER) )
			{
				dragStarted = true
				thread StartMouseDrag( panel, button, index )
			}

			WaitFrame()
		}
	}

	if ( !dragStarted )
	{
		clickFunc( panel, button, index )
	}
	else
	{
		var focusElement = GetMouseFocus()
		if ( focusElement in file.onMouseDropCallbacks )
		{
			if ( file.onMouseDropCallbacks[ focusElement ] != null )
			{
				file.onMouseDropCallbacks[ focusElement ]( focusElement, panel, button, index )
			}

			RunClientScript( "UICallback_OnInventoryMouseDrop", focusElement, panel, button, index, false )
		}
	}
}


void function StartMouseDrag( var panel, var button, int index )
{
	EndSignal( uiGlobal.signalDummy, "StopMouseDrag" )

	var elem = Hud_GetChild( file.mainPanel, "MouseDragIcon" )

	var rui = Hud_GetRui( elem )

	LootData data = GetLootDataFromButton( button, index )

	if ( data.index == -1 )
		return

	array<int> size = [ Hud_GetWidth( button ), Hud_GetHeight( button ) ]
	if ( Hud_GetScriptID( button ) in file.equipmentButtons )
	{
		if ( Hud_GetScriptID( button ).len() != "main_weapon0".len() )
		{
			size = [ Hud_GetWidth( button ), Hud_GetWidth( button ) ]
		}
	}

	Hud_SetSize( elem, size[0], size[1] )
	Hud_Show( elem )

	RuiSetImage( rui, "iconImage", data.hudIcon )
	RuiSetInt( rui, "lootTier", data.tier )
	RuiSetBool( rui, "brackerGradientEnabled", false )

	foreach ( slot in file.allDropSlots )
	{
		Hud_Show( slot )
		RunClientScript( "UICallback_OnInventoryMouseDrop", slot, panel, button, index, true )
		Hud_SetEnabled( slot, true )
	}

	OnThreadEnd(
		function () : ( elem, panel, button, index )
		{
			Hud_Hide( elem )

			foreach ( slot in file.allDropSlots )
			{
				Hud_Hide( slot )
				Hud_SetEnabled( slot, false )
			}
		}
	)

	while ( true )
	{
		vector screenPos = ConvertCursorToScreenPos()
		Hud_SetPos( elem, screenPos.x - Hud_GetWidth( elem ) * 0.5, screenPos.y - Hud_GetHeight( elem ) * 0.5 )
		WaitFrame()
	}
}


vector function ConvertCursorToScreenPos()
{
	vector mousePos   = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	mousePos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	return mousePos
}


void function ClientCallback_SetTempBoolMouseDragAllowed( bool allowed )
{
	file.tempBoolMouseDragAllowed = allowed
}


void function ClientCallback_SetTempButtonRef( string ref )
{
	file.tempButtonRef = ref
}

void function ClientCallback_SetTempButtonIcon( asset icon )
{
	file.tempButtonIcon = icon
}

LootData function GetLootDataFromButton( var button, int index )
{
	LootData data

	
	RunClientScript( "UICallback_GetLootDataFromButton", button, index )

	if ( SURVIVAL_Loot_IsRefValid( file.tempButtonRef ) )
	{
		data = SURVIVAL_Loot_GetLootDataByRef( file.tempButtonRef )
	}
	if ( index <= -1 && file.tempButtonIcon != $"" )
	{
		data.hudIcon = file.tempButtonIcon
		file.tempButtonIcon = $""
	}

	return data
}


bool function MouseDragAllowed( var panel, var button, var index )
{
	
	RunClientScript( "UICallback_GetMouseDragAllowedFromButton", button, index )
	return file.tempBoolMouseDragAllowed
}


void function InitSquadPanelInventory( var panel )
{
	InitSquadPanel( panel )
	InitInventoryFooter( panel )
}


void function InitLegendPanelInventory( var panel )
{
	InitInventoryFooter( panel )
}


void function ClientCallback_StartEquipmentExtendedUse( var button, float duration, int actionType, bool canSwapWeapons, bool hasSling )
{
	if ( canSwapWeapons )
	{
		thread StartEquipmentExtendedUse( button, duration, actionType )
	}

	if( hasSling )
		thread EquipmentSlingDecorations( button, duration, actionType, canSwapWeapons )
}

void function StartEquipmentExtendedUse( var button, float duration, int actionType )
{
	Signal( uiGlobal.signalDummy, "StartEquipmentExtendedUse" )
	EndSignal( uiGlobal.signalDummy, "StartEquipmentExtendedUse" )

	var elem = file.holdToUseElem
	Hud_Show( elem )
	HideGameCursor()

	file.isSwappingWeapons = true

	var rui = Hud_GetRui( elem )
	RuiSetBool( rui, "isVisible", true )
	RuiSetGameTime( rui, "startTime", ClientTime() )
	RuiSetFloat( rui, "duration", duration )
	RuiSetString( rui, "holdButtonHint", SURVIVAL_GetButtonStringForLootActionType( actionType, true ) )
	float uiEndTime = UITime() + duration

	EmitUISound( "UI_Survival_PickupTicker" )

	OnThreadEnd(
		function() : ( rui, elem )
		{
			ShowGameCursor()
			Hud_Hide( elem )
			RuiSetBool( rui, "isVisible", false )
			StopUISound( "UI_Survival_PickupTicker" )
			file.isSwappingWeapons = false
		}
	)

	bool isButtonFocused = GetMouseFocus() == button || ( GetDpadNavigationActive() && Hud_IsFocused( button ) )
	while ( IsLootActionTypeButtonDown( actionType ) && UITime() < uiEndTime && isButtonFocused )
	{
		vector screenPos = ConvertCursorToScreenPos()
		Hud_SetPos( elem, screenPos.x - Hud_GetWidth( elem ) * 0.5, screenPos.y - Hud_GetHeight( elem ) * 0.5 )
		WaitFrame()
	}

	if ( UITime() < uiEndTime )
		return

	if ( IsLobby() )
		return

	EmitUISound( "ui_menu_store_purchase_success" )

	if ( IsConnected() )
		RunClientScript( "UICallback_OnEquipmentButtonAction", button, actionType, true )
}

void function EquipmentSlingDecorations( var button, float duration, int actionType, bool canSwapWeapons )
{
	Signal( uiGlobal.signalDummy, "EquipmentSlingDecorations" )
	EndSignal( uiGlobal.signalDummy, "EquipmentSlingDecorations" )

	var slingDecorationsRui = Hud_GetRui( Hud_GetChild( file.mainInventoryPanel, "SlingDecorations" ) )
	if( slingDecorationsRui == null )
		return

	OnThreadEnd(
		function() : ( slingDecorationsRui )
		{
			if( CanRunClientScript() )
				RunClientScript( "EquipmentButton_SlingWarningMessage", false )

			RuiSetBool( slingDecorationsRui, "highlightLeftConnector", false )
			RuiSetBool( slingDecorationsRui, "highlightRightConnector", false )
			RuiSetBool( slingDecorationsRui, "isNonSwappableWeapon", false )
		}
	)

	float uiEndTime = UITime() + duration

	switch ( Hud_GetScriptID( button ) )
	{
		case "main_weapon0":
			if ( actionType == eLootActionType.CHARACTER_ACTION1 )
			{
				RuiSetBool( slingDecorationsRui, "highlightLeftConnector", true )
				RuiSetBool( slingDecorationsRui, "isNonSwappableWeapon", !canSwapWeapons )
				RunClientScript( "EquipmentButton_SlingWarningMessage", !canSwapWeapons )
			}
			break
		case "main_weapon1":
			if ( actionType == eLootActionType.CHARACTER_ACTION1 )
			{
				RuiSetBool( slingDecorationsRui, "highlightRightConnector", true )
				RuiSetBool( slingDecorationsRui, "isNonSwappableWeapon", !canSwapWeapons )
				RunClientScript( "EquipmentButton_SlingWarningMessage", !canSwapWeapons )
			}
			break
		case "sling_weapon":
			if ( actionType == eLootActionType.CHARACTER_ACTION1 )
			{
				RuiSetBool( slingDecorationsRui, "highlightLeftConnector", true )
			}
			else if ( actionType == eLootActionType.CHARACTER_ACTION2 )
			{
				RuiSetBool( slingDecorationsRui, "highlightRightConnector", true )
			}
			RuiSetBool( slingDecorationsRui, "isNonSwappableWeapon", !canSwapWeapons )
			RunClientScript( "EquipmentButton_SlingWarningMessage", !canSwapWeapons )
			break
	}

	bool isButtonFocused = GetMouseFocus() == button || ( GetDpadNavigationActive() && Hud_IsFocused( button ) )
	bool shouldHighlight = canSwapWeapons ? true : !file.isSwappingWeapons

	while ( IsLootActionTypeButtonDown( actionType ) && isButtonFocused && shouldHighlight )
	{
		WaitFrame()
	}

	if ( UITime() < uiEndTime )
		return
}

void function SurvivalInventoryMenu_SetEquipmentButtonFxState( string equipmentType, bool fxEnabled = false )
{
	if ( file.equipmentButtons.len() <= 0 )
		return

	var button = file.equipmentButtons[ equipmentType ]
	var buttonRui = Hud_GetRui( button )
	RuiSetBool( buttonRui, "showButtonFx", fxEnabled )
}

bool function IsLootActionTypeButtonDown( int actionType )
{
	switch( actionType )
	{
		case eLootActionType.ALT_ACTION:
			if( IsControllerModeActive() )
				return InputIsButtonDown( BUTTON_X )
			else
				return InputIsButtonDown( MOUSE_RIGHT )
			break

		case eLootActionType.PRIMARY_SWAP:
			int pcKeycode = GetKeyCodeForBinding( "+melee", 0 ) - 1
			if( IsControllerModeActive() )
				return InputIsButtonDown( BUTTON_SHOULDER_LEFT )
			else
				return InputIsButtonDown( pcKeycode )
			break

		case eLootActionType.CHARACTER_ACTION1:
			int pcKeycode = GetKeyCodeForBinding( "+offhand1", 0 ) - 1
			if( IsControllerModeActive() )
				return InputIsButtonDown( BUTTON_TRIGGER_LEFT )
			else
				return InputIsButtonDown( pcKeycode )
			break

		case eLootActionType.CHARACTER_ACTION2:
			int pcKeycode = GetKeyCodeForBinding( "+use", 0 ) - 1
			if( IsControllerModeActive() )
				return InputIsButtonDown( BUTTON_TRIGGER_RIGHT )
			else
				return InputIsButtonDown( pcKeycode )
			break
	}

	return false
}


void function UpdateArmorCoreEquipmentButtonPosition()
{
	var rtkArmorCore = Hud_GetChild( file.mainInventoryPanel, "RTKArmorCore" )
	Hud_SetVisible( rtkArmorCore, UpgradeCore_IsEnabled() )

	if ( !UpgradeCore_IsEnabled() )
		return

	
	var armorButton = Hud_GetChild( file.mainInventoryPanel, "Armor" )
	var helmetButton = Hud_GetChild( file.mainInventoryPanel, "Helmet" )
	var incapShieldButton = Hud_GetChild( file.mainInventoryPanel, "IncapShield" )

	
	Hud_SetPinSibling( helmetButton, "IncapShield" )
	Hud_SetPinSibling( armorButton, "Helmet" )

	
	Hud_SetX( armorButton, 86 )

	
	Hud_SetNavLeft( armorButton, null )
	Hud_SetNavRight( armorButton, helmetButton )
	Hud_SetNavUp( armorButton, Hud_GetChild( file.inventoryGridStatic, "GridButton1x1" ) )

	Hud_SetNavLeft( helmetButton, armorButton )
	Hud_SetNavRight( helmetButton, incapShieldButton )
	Hud_SetNavUp( helmetButton, Hud_GetChild( file.inventoryGridStatic, "GridButton1x2" ) )

	Hud_SetNavLeft( incapShieldButton, helmetButton )

	
	Hud_SetVisible( rtkArmorCore, UpgradeCore_ArmorTiedToUpgrades() )
}



void function UpdateBackpackDpadNav()
{
	if ( !Hud_HasChild( file.inventoryGridStatic, "GridButton0x0" ) )
		return

	const int MAX_BACKPACK_SLOTS = 7
	var slingButton = Hud_GetChild( file.mainInventoryPanel, "SlingWeapon" )
	var navUpButton = Hud_IsVisible( slingButton ) ? slingButton : Hud_GetChild( file.mainInventoryPanel, "MainWeapon0" )

	for ( int i = 0; i < MAX_BACKPACK_SLOTS; i++ )
	{
		var gridBtn = Hud_GetChild( file.inventoryGridStatic, "GridButton0x" + i )
		Hud_SetNavUp( gridBtn, navUpButton )
	}

	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x0" ), Hud_GetChild( file.mainInventoryPanel, "Helmet" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x1" ), Hud_GetChild( file.mainInventoryPanel, "Helmet" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x2" ), Hud_GetChild( file.mainInventoryPanel, "Armor" ) )


	if ( UpgradeCore_IsEnabled() )
	{
		Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x0" ), Hud_GetChild( file.mainInventoryPanel, "Armor" ) )
		Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x1" ), Hud_GetChild( file.mainInventoryPanel, "Armor" ) )
		Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x2" ), Hud_GetChild( file.mainInventoryPanel, "Helmet" ) )
	}


	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x3" ), Hud_GetChild( file.mainInventoryPanel, "IncapShield" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ), Hud_GetChild( file.mainInventoryPanel, "BackPack" ) )





	if ( Hud_IsEnabled( Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ) ) )
		Hud_SetNavUp( Hud_GetChild( file.mainInventoryPanel, "BackPack" ), Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ) )
	else
		Hud_SetNavUp( Hud_GetChild( file.mainInventoryPanel, "BackPack" ), Hud_GetChild( file.mainInventoryPanel, "BackPack" ) )







}

void function SetInventoryDpadTooltipVisible( bool isVisible )
{
	var dpadToolTip    = Hud_GetChild( Hud_GetParent( file.mainPanel ), "TooltipDpad" )
	var dpadToolTipRui = Hud_GetRui( dpadToolTip )

	Hud_SetVisible( dpadToolTip, isVisible )
}

void function ClientToUI_UpdateInventoryDpadTooltip( string itemName, string mainUsePrompt = "", string altUsePrompt = "", string pingPrompt = "", string specialPrompt = "", string primarySwapPrompt = "", string character1UsePrompt = "", string character2UsePrompt = ""  )
{
	var dpadToolTip    = Hud_GetChild( Hud_GetParent( file.mainPanel ), "TooltipDpad" )
	var dpadToolTipRui = Hud_GetRui( dpadToolTip )

	string spacer     = "      "
	string footerText = specialPrompt

	footerText += mainUsePrompt != "" ? spacer + mainUsePrompt : ""
	footerText += altUsePrompt != "" ? spacer + altUsePrompt : ""
	footerText += primarySwapPrompt != "" ? spacer + primarySwapPrompt : ""
	footerText += character1UsePrompt != "" ? spacer + character1UsePrompt : ""
	footerText += character2UsePrompt != "" ? spacer + character2UsePrompt : ""
	footerText += pingPrompt != "" ? spacer + pingPrompt : ""
	RuiSetString( dpadToolTipRui, "itemNameText", Localize( itemName ) )
	RuiSetString( dpadToolTipRui, "footerText", footerText )
	Hud_SetVisible( dpadToolTip, itemName != "" )
}


void function Inventory_Shutdown()
{
	if ( IsFullyConnected() && CanRunClientScript() )
		RunClientScript( "UICallback_BackpackClosed" )
}


void function TryOpenSystemMenu( var panel )
{
	if ( InputIsButtonDown( BUTTON_START ) )
		return

	OpenSystemMenu()
}


void function OnLevelShutdown()
{
	if ( GetBugReproNum() == 53995 )
		return

	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ) ) )
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ) ) )

	foreach ( button in file.equipmentButtons )
	{
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
	}
}
