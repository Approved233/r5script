global function Cl_Survival_InventoryInit

global function Survival_SwapPrimary
global function Survival_SwapToMelee
global function Survival_SwapToOrdnance

global function ServerCallback_TryCloseInventory
global function ServerCallback_RefreshInventory
global function ResetInventoryMenu
global function OpenSurvivalInventory
global function OpenSurvivalGroundList

global function Survival_IsInventoryOpen
global function Survival_IsGroundlistOpen
global function Survival_GetDeathBox
global function Survival_GetDeathBoxItems
global function Survival_GetGroundListBehavior

global function BackpackAction
global function EquipmentAction
global function DispatchLootAction

global function GroundItemUpdate
global function OpenSwapForItem
global function UIToClient_UpdateInventoryDpadTooltipText

global function UICallback_BackpackOpened
global function UICallback_BackpackClosed

global function UIToClient_GroundlistOpened
global function UIToClient_GroundlistClosed


global function UIToClient_PingUpgrade
global function UICallback_UpdateUpgradeButton
global function UICallback_UpdateUpgradeInfo
global function UICallback_OnUpgradeButtonAction
global function UICallback_PingUpgrade


global function UICallback_UpdateInventoryButton
global function UICallback_OnInventoryButtonAction
global function UICallback_PingInventoryItem

global function UICallback_UpdateEquipmentButton
global function UICallback_OnEquipmentButtonAction
global function UICallback_PingEquipmentItem

global function UICallback_PingRequestButton
global function UICallback_UpdateRequestButton


global function UICallback_PingIsMyUltimateReady


global function UICallback_UpdateQuickSwapItem
global function UICallback_OnQuickSwapItemClick
global function UICallback_OnQuickSwapItemClickRight

global function UICallback_UpdateQuickSwapItemButton

global function UICallback_GetLootDataFromButton
global function UICallback_GetMouseDragAllowedFromButton
global function UICallback_OnInventoryMouseDrop

global function UIToClient_WeaponSwap
global function UICallback_UpdatePlayerInfo
global function UICallback_UpdateTeammateInfo
global function UICallback_UpdateUltimateInfo


global function UICallback_UpdateTeammateUpgrades


global function UICallback_BlockPingForDuration

global function UICallback_EnableTriggerStrafing
global function UICallback_DisableTriggerStrafing

global function UpdateHealHint
global function GroundListResetNextFrame
global function GetCountForLootType
global function TryUpdateGroundList
global function TryResetGroundList
global function OnLocalPlayerPickedUpItem

global function IsOrdnanceEquipped
global function SetShowUnitFrameAmmoTypeIcons
global function GetShowUnitFrameAmmoTypeIcons
global function EquipmentButton_SlingWarningMessage

global enum eGroundListBehavior
{
	CONTENTS,
	NEARBY,
}

global enum eGroundListType
{
	DEATH_BOX,
	GRABBER,
	VENDINGMACHINE,



	_COUNT
}

struct CurrentGroundListData
{
	entity deathBox
	int    behavior
	int    listType
}

struct GroundLootData
{
	LootData&         lootData
	array<int>        guids
	int               count
	bool              isUpgrade
	bool              isRelevant
	bool              isHeader
}

const float ULT_HINT_COOLDOWN = 90.0




struct {
	table<string, void functionref( entity, string )>         itemUseFunctions
	table<string, void functionref( entity, string, string )> specialItemUseFunctions
	table<int, void functionref( entity, string )>            itemTypeUseFunctions
	table<int, void functionref( entity, string, string )>    specialItemTypeUseFunctions

	array<GroundLootData> allGroundItems = []
	array<GroundLootData> filteredGroundItems = []


	bool backpackOpened = false
	bool groundlistOpened = false
	bool shouldResetGroundItems = true
	bool shouldUpdateGroundItems = false
	bool shouldShowUnitFrameAmmoTypeIcons = true

	string                swapString
	CurrentGroundListData currentGroundListData

	float                 lastHealHintDisplayTime
	float				  lastUltHintDisplayTime



	table<string, string> triggerBinds
	var 				  slingButtonRui
	array<entity> lastLoot
	array<int>    visibleItemIndices
} file


void function Cl_Survival_InventoryInit()
{
	
	



	file.itemTypeUseFunctions[ eLootType.HEALTH ] <- UseHealthPickupRefFromInventory
	file.itemTypeUseFunctions[ eLootType.ORDNANCE ] <- EquipOrdnance
	file.itemTypeUseFunctions[ eLootType.GADGET ] <- EquipGadget
	file.specialItemTypeUseFunctions[ eLootType.ATTACHMENT ] <- EquipAttachment

	file.lastUltHintDisplayTime = Time() - ULT_HINT_COOLDOWN




	RegisterSignal( "OpenSwapForItem" )
	RegisterSignal( "ResetInventoryMenu" )
	RegisterSignal( "BackpackClosed" )
	RegisterSignal( "GroundListClosed" )

	AddCallback_OnUpdateTooltip( eTooltipStyle.LOOT_PROMPT, OnUpdateLootPrompt )
	AddCallback_OnUpdateTooltip( eTooltipStyle.WEAPON_LOOT_PROMPT, OnUpdateLootPrompt )

	AddCallback_LocalPlayerPickedUpLoot( OnLocalPlayerPickedUpItem )

	AddLocalPlayerTookDamageCallback( TryCloseSurvivalInventoryFromDamage )
	AddLocalPlayerTookDamageCallback( ShowHealHint )
	AddCallback_OnPlayerConsumableInventoryChanged( ResetInventoryMenu )
}

void function ServerCallback_TryCloseInventory( )
{
	RunUIScript( "TryCloseSurvivalInventory", null )
}

void function ServerCallback_RefreshInventory()
{
	ResetInventoryMenu( GetLocalClientPlayer() )
}


void function ResetInventoryMenu( entity player )
{
	thread ResetInventoryMenuInternal( player )
}


void function ResetInventoryMenuInternal( entity player )
{
	clGlobal.levelEnt.Signal( "ResetInventoryMenu" )
	clGlobal.levelEnt.EndSignal( "ResetInventoryMenu" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	WaitEndFrame()

	if ( IsWatchingReplay() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	PerfStart( PerfIndexClient.InventoryRefreshTotal )

	PerfStart( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_BeginUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimit", SURVIVAL_GetInventoryLimit( player ) )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimitMax", SURVIVAL_GetMaxInventoryLimit( player ) )
	PerfStart( PerfIndexClient.InventoryRefreshEnd )
	RunUIScript( "SurvivalInventoryMenu_EndUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshEnd )

	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
		UpdateHealHint( player )

	RunUIScript( "SurvivalInventoryMenu_SetSpaceForSling", DoesPlayerHaveWeaponSling( player ) )

	PerfEnd( PerfIndexClient.InventoryRefreshTotal )
}


void function Survival_UseInventoryItem( string ref, string secondRef )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	int type      = data.lootType

	if ( ref in file.itemUseFunctions )
	{
		file.itemUseFunctions[ ref ]( GetLocalViewPlayer(), ref )
	}
	else if ( ref in file.specialItemUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}
	else if ( type in file.itemTypeUseFunctions )
	{
		file.itemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref )
	}
	else if ( type in file.specialItemTypeUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}

	ResetInventoryMenu( GetLocalViewPlayer() )
}


bool function Survival_DropInventoryItem( string ref, int num )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return false

	entity deathbox = null
	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS ) 
	{
		deathbox = file.currentGroundListData.deathBox
	}

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )

	if ( IsValid( deathbox ) )
	{
		Remote_ServerCallFunction( "ClientCallback_Sur_DropBackpackItem_Box", data.index, num, deathbox.GetEncodedEHandle() )
	}
	else
	{
		Remote_ServerCallFunction( "ClientCallback_Sur_DropBackpackItem", data.index, num )
	}

	ResetInventoryMenu( player )

	return true
}


bool function Survival_DropEquipment( string ref )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return false

	EquipmentSlot e = Survival_GetEquipmentSlotDataByRef( ref )
	Remote_ServerCallFunction( "ClientCallback_Sur_DropEquipment", e.type )
	ResetInventoryMenu( player )

	return true
}


bool function BackpackAction( int lootAction, string slotIndexString )
{
	int slotIndex = int( slotIndexString )

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	int foundIndex                                 = -1

	foreach ( index, item in playerInventory )
	{
		if ( item.slot != slotIndex )
			continue

		foundIndex = index
		break
	}

	if ( foundIndex < 0 )
	{
		RunUIScript( "SurvivalMenu_AckAction" )
		return false
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( playerInventory[foundIndex].type )

	switch ( lootAction )
	{
		case eLootAction.DROP:
			int numToDrop = 1
			if ( lootData.lootType == eLootType.AMMO )
				numToDrop = minint( lootData.countPerDrop, playerInventory[foundIndex].count )
			return Survival_DropInventoryItem( lootData.ref, numToDrop )
			break

		case eLootAction.DROP_ALL:
			return Survival_DropInventoryItem( lootData.ref, playerInventory[foundIndex].count )
			break

			

		case eLootAction.ATTACH_TO_ACTIVE:
		case eLootAction.ATTACH_TO_STOWED:
			
			
			
			Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", lootData.index, -1 )
			
			break

		case eLootAction.EQUIP:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break

		case eLootAction.USE:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break










	}

	return true
}

bool function EquipmentAction( int lootAction, string equipmentSlot )
{
	switch ( lootAction )
	{
		case eLootAction.EQUIP:
			entity player = GetLocalClientPlayer()
			if ( player == GetLocalViewPlayer() )
			{
				string equipRef = EquipmentSlot_GetLootRefForSlot( player, equipmentSlot )
				if( SURVIVAL_Loot_GetLootDataByRef( equipRef ).lootType == eLootType.GADGET )
				{
					EquipGadget(player, equipRef)
					RunUIScript( "SurvivalMenu_AckAction" )
				}

				if ( EquipmentSlot_IsMainWeaponSlot( equipmentSlot ) )
				{
					EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
					int slot         = es.weaponSlot
					player.ClientCommand( "weaponSelectPrimary" + slot )
					return true
				}

				if( equipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
				{
					if( !IsPlayerWeaponSlingEmpty( player ) && !IsPlayerHoldingSlingWeapon( player ) )
					{
						player.ClientCommand( "weaponSelectSlingWeapon" )
						return true
					}
				}
			}
			break

		case eLootAction.DROP:
			entity player = GetLocalClientPlayer()
			if( player != GetLocalViewPlayer())
				return false

			if( equipmentSlot == SLING_EQUIPMENT_SLOT_NAME && IsBallisticUltActive( player ) )
			{
				return false
			}

			return Survival_DropEquipment( equipmentSlot )
			break

		case eLootAction.REMOVE_TO_GROUND:
		case eLootAction.REMOVE:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				return Survival_UnequipAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot, lootAction == eLootAction.REMOVE_TO_GROUND )
			}
			break

		case eLootAction.WEAPON_TRANSFER:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				return Survival_TransferAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot )
			}
			break

		case eLootAction.PRIMARY_SWAP:
			if( equipmentSlot != SLING_EQUIPMENT_SLOT_NAME )
				Remote_ServerCallFunction( "ClientCallback_Sur_SwapPrimaryPositions" )
			break

		case eLootAction.TRANSFER_SLING_MAIN:
			entity player = GetLocalClientPlayer()
			if ( player != GetLocalViewPlayer() )
				break

			int slot
			if( equipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
			{
				if( IsBallisticUltActive( player ) )
					break

				entity weapon0 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				if ( IsValid( weapon0 ) && !CanPlayerEquipWeaponRefToSling( player, GetWeaponClassNameWithLockedSet( weapon0 ), false ) )
					break

				slot = WEAPON_INVENTORY_SLOT_PRIMARY_0
			}
			else
			{
				string weaponRef = EquipmentSlot_GetLootRefForSlot( player, equipmentSlot )
				if( weaponRef != "" && !CanPlayerEquipWeaponRefToSling( player, weaponRef ) )
					break

				slot = Survival_GetEquipmentSlotDataByRef( equipmentSlot ).weaponSlot
			}

			Remote_ServerCallFunction( "ClientCallback_Sur_SlingToMainWeaponSlot", slot )
			return true

			break

		case eLootAction.TRANSFER_SLING_ALT:
			entity player = GetLocalClientPlayer()
			if ( player != GetLocalViewPlayer() )
				break

			if( IsBallisticUltActive( player ) )
				break

			if( equipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
			{
				entity weapon1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
				if ( IsValid( weapon1 ) && !CanPlayerEquipWeaponRefToSling( player, GetWeaponClassNameWithLockedSet( weapon1 ), false ) )
					break

				Remote_ServerCallFunction( "ClientCallback_Sur_SlingToMainWeaponSlot", WEAPON_INVENTORY_SLOT_PRIMARY_1 )
				return true
			}

			break
	}

	return false
}

void function UICallback_BackpackOpened()
{
	file.backpackOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		Remote_ServerCallFunction( "ClientCallback_BackpackOpened" )
}


void function UICallback_BackpackClosed()
{
	if ( !IsValidSignal( "BackpackClosed" ) ) 
			return

	entity oldDeathBoxEnt = file.currentGroundListData.deathBox
	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false

	if ( !IsLobby() )
		clGlobal.levelEnt.Signal( "BackpackClosed" )

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		Remote_ServerCallFunction( "ClientCallback_BackpackClosed" )

	if ( file.currentGroundListData.listType == eGroundListType.GRABBER && IsValid( oldDeathBoxEnt ) )
	{
		Remote_ServerCallFunction( BLACK_MARKET_CLOSE_CMD, oldDeathBoxEnt )
	}

		else if ( file.currentGroundListData.listType == eGroundListType.VENDINGMACHINE && IsValid( oldDeathBoxEnt ) )
		{
			Remote_ServerCallFunction( VENDING_MACHINE_CLOSE_CMD, oldDeathBoxEnt )
		}







}


void function UIToClient_GroundlistOpened()
{
	file.shouldResetGroundItems = true
	file.groundlistOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
	{

		entity deathbox = Survival_GetDeathBox()
		if ( IsValid( deathbox ) && deathbox.GetNetworkedClassName() == "prop_death_box" && !IsPlayerWithinStandardDeathBoxUseDistance( player, deathbox ) )
		{
			Remote_ServerCallFunction( "ClientCallback_DeathboxOpenedRemotely", deathbox )
		}
		else

		{
			Remote_ServerCallFunction( "ClientCallback_DeathboxOpened" )
		}
	}
}


void function UIToClient_GroundlistClosed()
{
	entity oldDeathBoxEnt = file.currentGroundListData.deathBox
	clGlobal.levelEnt.Signal( "GroundListClosed" )

	file.shouldResetGroundItems = true
	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false
	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
		Remote_ServerCallFunction( "ClientCallback_BackpackClosed" )

	if ( file.currentGroundListData.listType == eGroundListType.GRABBER && IsValid( oldDeathBoxEnt ) )
	{
		Remote_ServerCallFunction( BLACK_MARKET_CLOSE_CMD, oldDeathBoxEnt )
	}

		else if ( file.currentGroundListData.listType == eGroundListType.VENDINGMACHINE && IsValid( oldDeathBoxEnt ) )
		{
			Remote_ServerCallFunction( VENDING_MACHINE_CLOSE_CMD, oldDeathBoxEnt )
		}







}


bool function Survival_UnequipAttachment( string ref, int weaponSlot, bool removeToGround )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return false

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )

	Remote_ServerCallFunction( "ClientCallback_Sur_UnequipAttachment", data.index, weaponSlot, removeToGround )
	return true
}


bool function Survival_TransferAttachment( string ref, int weaponSlot )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return false

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	Remote_ServerCallFunction( "ClientCallback_Sur_TransferAttachment", data.index, weaponSlot )
	return true
}


void function Survival_SwapPrimary()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	thread WeaponCycle( player )
}


void function WeaponCycle( entity player )
{
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}


void function Survival_SwapToMelee()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "+ability 10" )
}


void function Survival_SwapToOrdnance()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "weaponSelectOrdnance" )
}


bool function CanSwapWeapons( entity player )
{
	if ( player.IsTitan() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( !CanOpenInventoryInCurrentGameState() )
		return false

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function OpenSurvivalInventory( entity player, entity deathBox = null )
{
	if ( !player.GetPlayerNetBool( "inventoryEnabled" ) )
		return
	SurvivalMenu_Internal( player, "OpenSurvivalInventoryMenu", deathBox )
}


void function SurvivalMenu_Internal( entity player, string uiScriptFuncName, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS, int groundListType = eGroundListType.DEATH_BOX )
{
	if ( !CanOpenInventory( player ) )
		return

	if ( IsEventFinale() && !IsValid(deathBox) && !player.IsWeaponTypeEnabled( WPT_GRENADE ))
		return

	ResetInventoryMenu( player )

	ServerCallback_ClearHints()
	player.ClientCommand( "-zoom" )

	if ( !Crafting_IsPlayerCrafting() && !Crafting_Access_Inventory_Enabled() )
	{
		CommsMenu_Shutdown( false )
	}

	file.currentGroundListData.deathBox = deathBox
	file.currentGroundListData.behavior = groundListBehavior
	file.currentGroundListData.listType = groundListType

	RunUIScript( uiScriptFuncName )

	if ( IsValid( deathBox ) )
	{

		if ( uiScriptFuncName != "OpenSurvivalGroundListMenu" )
		{
			thread TrackCloseDeathBoxConditions( player, deathBox )
		}
	}
}

bool function CanOpenInventoryInCurrentGameState( )
{
	if( GamePlaying() || GetGameState() == eGameState.Epilogue )
		return true

	if( GetGameState() == eGameState.WaitingForPlayers )
		return true

	if(	GetGameState() == eGameState.Prematch && GetCurrentPlaylistVarBool( "allow_inventory_in_prematch", false ) )
		return true

	return false
}

bool function CanOpenInventory( entity player )
{
	if ( IsWatchingReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( CharacterSelect_MenuIsOpen() )
		return false

	if ( !CanOpenInventoryInCurrentGameState() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function TrackCloseDeathBoxConditions( entity player, entity deathBox )
{
	player.EndSignal( "OnDeath" )
	deathBox.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( Survival_IsGroundlistOpen() )
			{
				RunUIScript( "TryCloseSurvivalInventory", null )
			}
		}
	)

	wait 0.5

	while ( Survival_IsGroundlistOpen() )
	{
		if ( Distance( player.GetOrigin(), deathBox.GetOrigin() ) > DEATH_BOX_MAX_DIST )
			return

		if ( file.currentGroundListData.behavior != eGroundListBehavior.NEARBY && file.filteredGroundItems.len() == 0 )
			return






		WaitFrame()
	}
}

void function OpenSurvivalGroundList( entity player, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS, int groundListType = eGroundListType.DEATH_BOX )
{
	string funcName = "OpenSurvivalGroundListMenu"
	SurvivalMenu_Internal( player, funcName, deathBox, groundListBehavior, groundListType )
}


void function UICallback_UpdateUpgradeButton( var button, int position )
{
	if( !UpgradeCore_IsEnabled() )
		return

	entity player = GetLocalClientPlayer()

	var rui = Hud_GetRui( button )

	Hud_SetEnabled( button, true )
	Hud_SetSelected( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	Hud_ClearToolTipData( button )
	Hud_SetLocked( button, false )

	if ( IsLobby() )
		return

	UpgradeCoreChoice upgrade = UpgradeCore_GetUpgradeChoiceStructByIndex( player, position )

	int tier = position / 2 + 1
	string actionStr
	if( UpgradeCore_IsUpgradeSelected( player, position ) || UpgradeCore_IsUpgradeSelectable( player, position ) )
	{

		RuiSetInt( rui, "lootTier", tier + 1 )
		RuiSetImage( rui, "iconImage", upgrade.icon )
		RuiSetBool( rui, "isInactive", false )
		actionStr = "HOLD %[A_BUTTON|MOUSE1]% SELECT UPGRADE"
	}
	else
	{
		RuiSetInt( rui, "lootTier", 0 )
		RuiSetImage( rui, "iconImage", UPGRADE_CORE_ICON )
		RuiSetBool( rui, "isInactive", true )
		actionStr = "UPGRADE LOCKED"
	}

	RuiSetInt( rui, "count", 1 )
	RuiSetInt( rui, "maxCount", 1 )

	RuiSetBool( rui, "isInfinite", true )
	RuiSetInt( rui, "numPerPip", 1 )

	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

	ToolTipData dt
	dt.tooltipStyle = eTooltipStyle.DEFAULT
	dt.descText = upgrade.desc
	dt.titleText = "`1" + upgrade.title
	dt.actionHint1 = actionStr
	dt.rarity = tier - 1
	dt.image = upgrade.icon

	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
}

void function UICallback_UpdateUpgradeInfo()
{
	if( !UpgradeCore_ShowUpgradeTreeInventory() )
		return

	if ( !IsLocalClientEHIValid() )
		return

	RunUIScript( "RTKLegendUpgradeTree_SetCharacterByGUID", LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() ).guid, true )
	RunUIScript( "RTKLegendUpgradeTree_IsInteractable", true )
	RunUIScript( "RTKLegendUpgradeTree_SetTitleVisibility", false )
	RunUIScript( "RTKLegendUpgradeTree_SetDescriptionVisibility", false )
}

void function UICallback_OnUpgradeButtonAction( var button, int position )
{
	entity player = GetLocalClientPlayer()
	if( !UpgradeCore_IsUpgradeSelectable( player, position ) )
	{
		EmitSoundOnEntity( player, "UI_Survival_LootPickupDeny" )
		return
	}

	UpgradeCore_SelectOption( position )
}

void function UICallback_PingUpgrade( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	int level = UpgradeCore_GetPlayerLevel( player )
	if( level >= 4 )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )
	Remote_ServerCallFunction( "ClientCallback_QuickchatSubject_Player", eCommsAction.PING_XP_LEVEL_UP_ABILITY, eCommsFlags.NONE, player )
}
void function UIToClient_PingUpgrade( int upgradeIndex )
{
	entity player    = GetLocalClientPlayer()
	bool isSelected = UpgradeCore_IsUpgradeSelected( player, upgradeIndex )
	if( isSelected )
	{
		Remote_ServerCallFunction( "ClientCallback_QuickchatSubject_Player", eCommsAction.PING_HAS_UPGRADE_0 + upgradeIndex, eCommsFlags.NONE, GetLocalClientPlayer() )
	}
	else if( UpgradeCore_IsUpgradeSelectable( player, upgradeIndex ) )
	{
		Remote_ServerCallFunction( "ClientCallback_QuickchatSubject_Player", eCommsAction.PING_XP_LEVEL_UP_ABILITY, eCommsFlags.NONE, GetLocalClientPlayer() )
	}
}



void function UICallback_UpdateInventoryButton( var button, int position )
{
	entity player = GetLocalClientPlayer()

	var rui = Hud_GetRui( button )

	Hud_SetEnabled( button, true )
	Hud_SetSelected( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	Hud_ClearToolTipData( button )
	Hud_SetLocked( button, false )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_SetEnabled( button, false )
		return
	}

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	int maxCount = SURVIVAL_GetInventorySlotCountForPlayer( player, lootData )
	RuiSetInt( rui, "maxCount", maxCount )
	RuiSetInt( rui, "ordinaryMaxCount", lootData.lootType == eLootType.AMMO ? lootData.inventorySlotCount : maxCount )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	UpdateLockStatusForBackpackItem( button, player, lootData )

	Hud_SetSelected( button, IsOrdnanceEquipped( player, lootData.ref ) )

	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.LOOT_PROMPT )

	ToolTipData dt
	dt.tooltipStyle = eTooltipStyle.LOOT_PROMPT
	dt.lootPromptData.count = item.count
	dt.lootPromptData.index = item.type
	dt.lootPromptData.lootContext = eLootContext.BACKPACK
	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
}


void function UICallback_PingInventoryItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	if ( playerInventory.len() <= position )
		return

	if ( IsLobby() )
		return

	int commsAction = GetCommsActionForBackpackItem( button, position )
	if ( commsAction != eCommsAction.BLANK )
	{
		EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
		RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )
		Remote_ServerCallFunction( "ClientCallback_Quickchat", commsAction, eCommsFlags.NONE )
	}
}


void function UICallback_OnInventoryButtonAction( var button, int position, int actionType, bool fromExtendedUse = false )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
		return

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	bool didSomething = DispatchLootAction( eLootContext.BACKPACK, SURVIVAL_GetActionForBackpackItem( player, lootData, actionType ).action, position )
	if ( didSomething )
		RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
}

void function UpdateLockStatusForBackpackItem( var button, entity player, LootData lootData )
{
	if ( !SURVIVAL_Loot_IsRefValid( lootData.ref ) )
		return

	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}

bool function IsItemEquipped_Gadget( entity player, string ref )
{
	if ( !player.IsTitan() )
	{
		entity ordnance = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
		if( IsValid( ordnance ) && ordnance.GetWeaponClassName() == ref )
			return true

		entity gadget = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if( IsValid( gadget ) && gadget.GetWeaponClassName() == ref )
			return true
	}

	return false
}

bool function IsOrdnanceEquipped( entity player, string ref )
{
	if ( !player.IsTitan() && IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ) ) )
	{
		return player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ).GetWeaponClassName() == ref
	}

	return false
}


bool function DispatchLootAction( int lootContext, int lootAction, var param, bool isAltAction = false, bool actionFromMenu = true )
{
	if ( lootAction == eLootAction.NONE )
		return false

	switch ( lootContext )
	{
		case eLootContext.BACKPACK:
			return BackpackAction( lootAction, string( param ) )

		case eLootContext.EQUIPMENT:
			return EquipmentAction( lootAction, string( param ) )
	}

	return false
}


int function GetCommsActionForBackpackItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( ( position < playerInventory.len() ) && ( position >= 0 ) )
	{
		ConsumableInventoryItem item = playerInventory[ position ]
		LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )

		if (lootData.lootType == eLootType.AMMO)
		{
			switch ( AmmoType_GetTypeFromRef( lootData.ref ) )
			{
				case eAmmoPoolType.bullet:
					return eCommsAction.INVENTORY_NEED_AMMO_BULLET

				case eAmmoPoolType.special:
					return eCommsAction.INVENTORY_NEED_AMMO_SPECIAL

				case eAmmoPoolType.highcal:
					return eCommsAction.INVENTORY_NEED_AMMO_HIGHCAL

				case eAmmoPoolType.shotgun:
					return eCommsAction.INVENTORY_NEED_AMMO_SHOTGUN

				case eAmmoPoolType.sniper:
					return eCommsAction.INVENTORY_NEED_AMMO_SNIPER
				case eAmmoPoolType.arrows:
					return eCommsAction.INVENTORY_NEED_AMMO_ARROWS
			}
		}
	}

	return eCommsAction.BLANK
}

void function UICallback_UpdateRequestButton( var button )
{
	if ( IsLobby() )
		return

	entity player        = GetLocalClientPlayer()
	var rui              = Hud_GetRui( button )
	string requestButton = Hud_GetScriptID( button )

	LootData loot = EquipmentSlot_GetEquippedLootDataForSlot ( player, requestButton )


	Hud_Hide( button )
	Hud_ClearToolTipData( button )

	if ( !SURVIVAL_Loot_IsRefValid( loot.ref ) )
		return

	string weaponName = loot.baseWeapon
	float scaleFrac = GetScreenScaleFrac()







	if ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault ( weaponName, "has_energized", 0 ) == 1 )
	{
		string energizedConsumableData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable" )
		string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_ping_string" )
		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )

		LootData ordanenceData = SURVIVAL_Loot_GetLootDataByRef ( energizedConsumableData )

		RuiSetImage( rui, "iconImage", ordanenceData.hudIcon )
		RuiSetString( rui, "iconName", Localize ( pingStringData ) )
		RuiSetImage( rui, "borderImage", $"rui/menu/inventory/border_ThermitePing" )
		Hud_SetX( button, -12 * scaleFrac )
		Hud_SetY( button, -40 * scaleFrac )
		Hud_SetWidth( button, 84 * scaleFrac )
		Hud_SetHeight( button, 84 * scaleFrac )
		Hud_Show( button )

		ToolTipData dt
		PopulateTooltipWithTitleAndDesc( ordanenceData, dt )

		dt.commsAction = eCommsAction[ commsData ]

		dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

		Hud_SetToolTipData( button, dt )
		RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

	}


	EquipmentSlot e = Survival_GetEquipmentSlotDataByRef( requestButton )
	bool weaponCanRequestPair = false

	if( e.weaponSlot >= 0 )
	{
		entity weapon = player.GetNormalWeapon( e.weaponSlot )
		bool weaponCanAkimbo = GetWeaponInfoFileKeyField_GlobalBool( weapon.GetWeaponClassName(), "is_akimbo_weapon" )
		bool weaponIsLockedSet = SURVIVAL_Weapon_IsAttachmentLocked( GetWeaponClassNameWithLockedSet( weapon ) )
		weaponCanRequestPair = weaponCanAkimbo && !weaponIsLockedSet && !weapon.IsAkimboAvailable()
	}

	if ( weaponCanRequestPair )
	{
		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "akimbo_comms" )

		RuiSetImage( rui, "iconImage", $"" )
		RuiSetImage( rui, "borderImage", $"rui/menu/inventory/border_weapon_request" )
		Hud_SetX( button, -265 * scaleFrac )
		Hud_SetY( button, -24 * scaleFrac )
		Hud_SetWidth( button, 160 * scaleFrac )
		Hud_SetHeight( button, 128 * scaleFrac )
		Hud_Show( button )

		ToolTipData dt
		PopulateTooltipWithTitleAndDesc( loot, dt )

		dt.commsAction = eCommsAction[ commsData ]

		dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

		Hud_SetToolTipData( button, dt )
		RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )
	}

}


int function GetWeaponCurrentAmmo( entity weapon )
{
	int ammoCount = 0

	if ( IsValid( weapon ) )
	{
		if(  weapon.UsesClipsForAmmo() )
		{

			entity owner = weapon.GetWeaponOwner()

			
			bool showAkimboCount = weapon.IsAkimboAvailable() && !weapon.IsAkimboDisabled() && owner.GetAkimboState() != AKIMBO_STATE_OFFHAND;
			ammoCount = ( showAkimboCount ) ? weapon.GetAkimboSharedClipCount() :  weapon.GetWeaponPrimaryClipCount()




		}
		else
		{
			ammoCount = weapon.GetWeaponPrimaryAmmoCount( weapon.GetActiveAmmoSource() )
		}
	}

	return ammoCount
}

void function UICallback_UpdateEquipmentButton( var button )
{
	entity player        = GetLocalClientPlayer()
	var rui              = Hud_GetRui( button )
	string equipmentSlot = Hud_GetScriptID( button )

	if ( !EquipmentSlot_IsValidForPlayer( equipmentSlot, player ) )
	{
		Hud_Hide( button )
		return
	}

	Hud_Show( button )
	LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	string equipment = data.ref

	RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetString( rui, "passiveText", "" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	Hud_ClearToolTipData( button )
	RuiSetBool( rui, "hasAltAmmo", false )
	RuiSetImage( rui, "altAmmoIcon", $"" )
	RuiSetInt( rui, "altMaxAmmo", 0 )
	if ( IsLobby() )
		return

	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

	if ( es.weaponSlot >= 0 )
		RuiSetImage( rui, "iconImage", $"" )

	if ( equipment == "" )
	{
		int tooltipFlags = IsPingEnabledForPlayer( player ) && !GetCurrentPlaylistVarBool( "disable_empty_slot_ping", false ) ? 0 : eToolTipFlag.PING_DISSABLED
		RunUIScript( "SurvivalQuickInventory_SetEmptyTooltipForSlot", button, Localize( "#TOOLTIP_EMPTY_PROMPT", Localize( es.title ) ), eCommsAction.BLANK, tooltipFlags )
	}
	else
	{
		EquipmentButtonInit( button, equipmentSlot, data, 0 )
	}

	LootData gadgetLootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "gadgetslot" )
	string equipRef         = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	if( equipment == equipRef )
	{
		entity gadgetWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if( IsValid( gadgetWeapon ) && SURVIVAL_Loot_IsRefValid( gadgetLootData.ref ) )
		{
			if ( gadgetWeapon.GetWeaponPrimaryClipCount() > 0 && gadgetWeapon.GetWeaponPrimaryClipCountMax() > 1 ) 
			{
				RuiSetInt( rui, "maxCount", gadgetWeapon.GetWeaponPrimaryClipCountMax() )
				RuiSetInt( rui, "count", gadgetWeapon.GetWeaponPrimaryClipCount() )
				RuiSetInt( rui, "numPerPip", 1 )
			}
		}
	}

	if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
	{
		string attachmentPoint = EquipmentSlot_GetAttachmentPointForSlot( equipmentSlot )
		EquipmentSlot esWeapon = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )
		entity weapon          = player.GetNormalWeapon( esWeapon.weaponSlot )

		LootData wData = SURVIVAL_GetLootDataFromWeapon( weapon )
		
		RuiSetBool( rui, "isFullyKitted", SURVIVAL_IsAttachmentPointLocked( wData.ref, attachmentPoint ) )
		RuiSetBool( rui, "showBrackets", true )

		if ( IsValid( weapon ) && SURVIVAL_Loot_IsRefValid( wData.ref ) && AttachmentPointSupported( attachmentPoint, wData.ref ) )
		{
			Hud_SetEnabled( button, true )
			Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
			if ( equipment == "" )
			{
				string attachmentStyle = GetAttachmentPointStyle( attachmentPoint, wData.ref )
				RuiSetImage( rui, "iconImage", emptyAttachmentSlotImages[attachmentStyle] )
			}
			else
			{
				RuiSetInt( rui, "count", 1 )

				if ( SURVIVAL_IsAttachmentPointLocked( wData.ref, attachmentPoint ) )
				{
					RuiSetInt( rui, "lootTier", wData.tier )
				}
			}
		}
		else
		{
			RuiSetImage( rui, "iconImage", $"" )
			RuiSetInt( rui, "lootTier", 0 )
			Hud_SetWidth( button, 0 )
			Hud_SetEnabled( button, false )
			RunUIScript( "ClientToUI_Tooltip_Clear", button )
		}
	}

	if ( es.weaponSlot >= 0 )
	{
		int slot = SURVIVAL_GetActiveWeaponSlot( player, true )
		if ( slot < WEAPON_INVENTORY_SLOT_PRIMARY_0 )
			slot = WEAPON_INVENTORY_SLOT_PRIMARY_0
		else if( slot > WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			slot = player.GetLastCycleSlot()

		RuiSetString( rui, "weaponSlotString", "#MENU_WEAPON_SLOT" + es.weaponSlot )
		RuiSetString( rui, "weaponSlotStringConsole", "#MENU_WEAPON_SLOT_CONSOLE" + es.weaponSlot )

		RuiSetString( rui, "weaponName", "" )
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "skinTier", 0 )
		RuiSetInt( rui, "count", 0 )

		ClearWeaponBrand( rui )

		entity weapon = player.GetNormalWeapon( es.weaponSlot )

		int skinTier    = 0
		string skinName = ""

		string charmName = ""

		if ( IsValid( weapon ) )
		{
			int ammountCount = GetWeaponCurrentAmmo( weapon )


				if ( TitanSword_WeaponIsTitanSword( weapon ) )
					ammountCount = 0


			RuiSetInt( rui, "count", ammountCount )

			RuiSetString( rui, "weaponName", data.pickupString )


				TrySetWeaponBrand_Paintball( rui, weapon )





			ItemFlavor ornull weaponItemOrNull = GetWeaponItemFlavorByClass( weapon.GetWeaponClassName() )
			if ( weaponItemOrNull != null )
			{
				expect ItemFlavor(weaponItemOrNull)

				if ( IsValidItemFlavorGUID( weapon.GetItemFlavorGUID(), eValidation.DONT_ASSERT ) )
				{
					ItemFlavor weaponSkin = GetItemFlavorByGUID( weapon.GetItemFlavorGUID() )
					RuiSetString( rui, "skinName", ItemFlavor_GetLongName( weaponSkin ) )
					if ( ItemFlavor_HasQuality( weaponSkin ) )
						RuiSetInt( rui, "skinTier", ItemFlavor_GetQuality( weaponSkin ) + 1 )

					ItemFlavor ornull weaponSkinOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponSkin( weaponItemOrNull ) )
					if ( weaponSkinOrNull != null && weaponSkinOrNull != weaponSkin )
					{
						expect ItemFlavor( weaponSkinOrNull )
						if ( ItemFlavor_HasQuality( weaponSkinOrNull ) )
						{
							skinTier = ItemFlavor_GetQuality( weaponSkinOrNull ) + 1
							skinName = ItemFlavor_GetLongName( weaponSkinOrNull )
						}
					}
				}

				if ( IsValidItemFlavorGUID( weapon.GetWeaponCharmOrArtifactBladeGUID(), eValidation.DONT_ASSERT ) )
				{
					ItemFlavor weaponCharm              = GetItemFlavorByGUID( weapon.GetWeaponCharmOrArtifactBladeGUID() )
					ItemFlavor ornull weaponCharmOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponCharm( weaponItemOrNull ) )
					if ( weaponCharmOrNull != null && weaponCharmOrNull != weaponCharm )
					{
						expect ItemFlavor( weaponCharmOrNull )
						charmName = ItemFlavor_GetLongName( weaponCharmOrNull )
					}
				}
			}

			RunUIScript( "SurvivalQuickInventory_UpdateEquipmentForActiveWeapon", slot )
			RunUIScript( "SurvivalQuickInventory_UpdateWeaponSlot", es.weaponSlot, skinTier, skinName, charmName )
		}
	}

	if ( equipmentSlot == "sling_weapon" )
	{
		file.slingButtonRui = rui
		entity weapon = player.GetNormalWeapon( SLING_WEAPON_SLOT )
		LootData wData = SURVIVAL_GetLootDataFromWeapon( weapon )

		RuiSetString( rui, "weaponSlotString", "#SLING_WEAPON_TITLE" )
		RuiSetString( rui, "weaponSlotStringConsole", "#SLING_WEAPON_TITLE_CONSOLE" )
		RuiSetString( rui, "weaponName", "" )
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "lootTier", wData.tier )
		RuiSetBool( rui, "isAltWeaponSlot", true )
		RuiSetInt( rui, "count", 0 )
		RuiSetBool( rui, "isAltWeapon", true )

		if ( IsValid( weapon ) )
		{
			RuiSetInt( rui, "count", GetWeaponCurrentAmmo( weapon ) )
		}
	}


	if( equipmentSlot == "armor" && UpgradeCore_IsEquipmentArmorCore( data.ref ) )
	{
		int shieldHealth = player.GetShieldHealth() + GetPlayerExtraShields( player )
		int shieldTier = GetShieldTierFromShieldAmount( shieldHealth )
		RuiSetInt( rui, "lootTier", shieldTier )

		asset shieldCoreImage = GetShieldCoreIconFromShieldAmount( shieldHealth )
		RuiSetImage( rui, "iconImage", shieldCoreImage )
	}

}

void function EquipmentButton_SlingWarningMessage( bool show )
{
	if (file.slingButtonRui != null)
	{
		RuiSetBool( file.slingButtonRui, "isTryingToAttachNonSlingWeapon", show )
	}
}

void function EquipmentButtonInit( var button, string equipmentSlot, LootData lootData, int count )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )
	RuiSetBool( rui, "dimIcon", SURVIVAL_EquipmentPretendsToBeBlank( lootData.ref ) )

	
	
	
	RuiSetString( rui, "passiveText", "" ) 

	bool isMainWeapon = EquipmentSlot_IsMainWeaponSlot( equipmentSlot )
	if ( isMainWeapon || equipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
	{
		asset icon      = lootData.fakeAmmoIcon == $"" ? $"rui/hud/gametype_icons/survival/sur_ammo_unique" : lootData.fakeAmmoIcon
		int slot 		= isMainWeapon ? Survival_GetEquipmentSlotDataByRef( equipmentSlot ).weaponSlot : SLING_WEAPON_SLOT
		entity weapon   = player.GetNormalWeapon( slot )

		bool weaponEntIsValid = IsValid( weapon )
		Assert( weaponEntIsValid, "Weapon entity must be valid if the equipment slot data is valid as well" )

		string ammoTypeRef = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )
		if ( GetWeaponInfoFileKeyField_GlobalBool( lootData.baseWeapon, "uses_ammo_pool" ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoTypeRef )
			icon = ammoData.hudIcon
		}

		RuiSetImage( rui, "ammoTypeImage", icon )
		if( weaponEntIsValid )
			Weapon_UpdateAltAmmoRui( rui, player, weapon, false )
	}
	ToolTipData dt
	PopulateTooltipWithTitleAndDesc( lootData, dt )
	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.PRIMARY_ACTION, true, equipmentSlot )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
	LootActionStruct asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.ALT_ACTION, true, equipmentSlot )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )
	LootActionStruct asPrimarySwap = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.PRIMARY_SWAP, true, equipmentSlot )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asPrimarySwap, lootRef )
	LootActionStruct asCharacter1 = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.CHARACTER_ACTION1, true, equipmentSlot )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asCharacter1, lootRef )
	LootActionStruct asCharacter2 = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.CHARACTER_ACTION2, true, equipmentSlot )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asCharacter2, lootRef )

	dt.actionHint1 = Localize( asMain.displayString ).toupper()
	dt.actionHint2 = Localize( asAlt.displayString ).toupper()
	dt.actionHint3 = Localize( asCharacter1.displayString ).toupper()

	if ( equipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
	{
		dt.actionHint4 = Localize( asCharacter2.displayString ).toupper()
	}
	else
	{
		dt.actionHint4 = Localize( asPrimarySwap.displayString ).toupper()
	}

	dt.commsAction = GetCommsActionForEquipmentSlot( equipmentSlot )

	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )
}


void function PopulateTooltipWithTitleAndDesc( LootData lootData, ToolTipData dt )
{
	entity localPlayer = GetLocalViewPlayer()
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.SOLID
	dt.titleText = SURVIVAL_Loot_GetPickupString( lootData, GetLocalViewPlayer() )
	dt.descText = SURVIVAL_Loot_GetDesc( lootData, localPlayer )


	if( UpgradeCore_IsEquipmentArmorCore( lootData.ref ) && IsValid( localPlayer ) )
	{
		dt.descText = Localize( lootData.desc, localPlayer.GetShieldHealth() + GetPlayerExtraShields( localPlayer ) )
	}

}

void function UICallback_OnEquipmentButtonAction( var button, int actionType, bool fromExtendedUse = false )
{
	if( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	string equipmentType = Hud_GetScriptID( button )
	LootData data        = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentType )
	string equipmentRef  = data.ref
	if ( equipmentRef == "" || SURVIVAL_EquipmentPretendsToBeBlank( equipmentRef ) )
		return

	LootData lootData   = SURVIVAL_Loot_GetLootDataByRef( equipmentRef )
	LootActionStruct as = SURVIVAL_GetActionForEquipment( player, lootData, actionType )
	LootRef lootRef     = SURVIVAL_CreateLootRef( lootData, null )

	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentType, as, lootRef )
	if ( ShouldStartExtendedUseForEquipmentAction( player, as.action, lootData.lootType, fromExtendedUse, equipmentType, equipmentRef ) )
	{
		RunUIScript( "ClientCallback_StartEquipmentExtendedUse", button, 0.4, actionType, true, DoesPlayerHaveWeaponSling( player ) )
	}
	else
	{
		RunUIScript( "ClientCallback_StartEquipmentExtendedUse", button, 0.4, actionType, false, DoesPlayerHaveWeaponSling( player ) )
		bool didSomething = DispatchLootAction( eLootContext.EQUIPMENT, as.action, equipmentType )
		if ( didSomething )
			RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}

bool function ShouldStartExtendedUseForEquipmentAction( entity player, int action, int lootType, bool fromExtendedUse, string equipmentType, string equipmentRef )
{
	if( fromExtendedUse )
		return false

	if( lootType == eLootType.MAINWEAPON )
	{
		if( action == eLootAction.DROP && Survival_PlayerCanDrop( player ) )
		{
			if( equipmentType == SLING_EQUIPMENT_SLOT_NAME && IsBallisticUltActive( player ) )
				return false

			return true
		}
		else if( action == eLootAction.TRANSFER_SLING_MAIN )
		{
			if ( IsBallisticUltActive( player ) && !IsPlayerWeaponSlingEmpty( player ) )
				return false

			if ( equipmentType == SLING_EQUIPMENT_SLOT_NAME )
			{
				entity weapon0 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				if( IsValid( weapon0 ) && !CanPlayerEquipWeaponRefToSling( player, GetWeaponClassNameWithLockedSet( weapon0 ), false ) )
					return false
			}
			else
			{
				if( !CanPlayerEquipWeaponRefToSling( player, equipmentRef, false ) )
					return false
			}

			return true
		}
		else if( action == eLootAction.TRANSFER_SLING_ALT )
		{
			if( equipmentType != SLING_EQUIPMENT_SLOT_NAME || ( IsBallisticUltActive( player ) ) )
				return false

			entity weapon1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			if( IsValid( weapon1 ) && !CanPlayerEquipWeaponRefToSling( player, GetWeaponClassNameWithLockedSet( weapon1 ), false ) )
				return false

			return true
		}









	}

	return false
}


void function UICallback_PingIsMyUltimateReady( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	int commsAction = GetCommsActionForUltReady( player )
	if ( commsAction == eCommsAction.BLANK )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )

	PIN_UltimateReadyPing( player, GetEnumString( "eCommsAction", commsAction ).tolower(), IsValid( player.GetOffhandWeapon( OFFHAND_ULTIMATE ) ) )

	
	Quickchat( commsAction, null )
}


void function UICallback_PingRequestButton ( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	string requestButton = Hud_GetScriptID( button )

	LootData loot = EquipmentSlot_GetEquippedLootDataForSlot ( player, requestButton )


	if ( !SURVIVAL_Loot_IsRefValid( loot.ref ) )
		return

	string weaponName = loot.baseWeapon

	if ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault ( weaponName, "has_energized", 0 ) == 1 )
	{
		EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )

		Quickchat( eCommsAction [ commsData ], null )
	}


		if ( GetWeaponInfoFileKeyField_GlobalBool ( weaponName, "is_akimbo_weapon" ) )
		{
			EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
			string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "akimbo_comms" )

			Quickchat( eCommsAction [ commsData ], null )
		}



}

void function UICallback_PingEquipmentItem( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	string equipSlot = Hud_GetScriptID( button )
	int commsAction  = GetCommsActionForEquipmentSlot( equipSlot )
	if ( commsAction == eCommsAction.BLANK )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )

	EquipmentSlot e = Survival_GetEquipmentSlotDataByRef( equipSlot )
	Remote_ServerCallFunction( "ClientCallback_Quickchat_UI", commsAction, eCommsFlags.NONE, e.type )
}


int function GetCommsActionForEquipmentSlot( string equipSlot )
{
	entity player       = GetLocalClientPlayer()
	LootData data       = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
	string equipmentRef = data.ref
	bool isEmpty        = (equipmentRef == "" || SURVIVAL_EquipmentPretendsToBeBlank( equipmentRef ) )

	return Survival_GetCommsActionForEquipmentSlot( equipSlot, equipmentRef, isEmpty )
}


int function SortByAmmoThenTierThenPriority( GroundLootData a, GroundLootData b )
{
	if ( a.lootData.lootType == eLootType.AMMO && b.lootData.lootType != eLootType.AMMO )
		return -1
	else if ( a.lootData.lootType != eLootType.AMMO && b.lootData.lootType == eLootType.AMMO )
		return 1

	if ( a.lootData.lootType == eLootType.MAINWEAPON && b.lootData.lootType != eLootType.MAINWEAPON )
		return -1
	else if ( a.lootData.lootType != eLootType.MAINWEAPON && b.lootData.lootType == eLootType.MAINWEAPON )
		return 1

	return SortByTierThenPriority( a, b )
}


int function SortByTierThenPriority( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.guids.len() > b.guids.len() )
		return -1
	if ( a.guids.len() < b.guids.len() )
		return 1

	return 0
}


int function SortByPriorityThenTierForGroundLoot( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1


	return 0
}


void function UICallback_EnableTriggerStrafing()
{
	
	
	
	
	
}


void function UICallback_DisableTriggerStrafing()
{
	
	
	
	
	
}

bool function IsGroundLootPinged( GroundLootData grounLootData, entity player = null )
{
	foreach ( guid in grounLootData.guids )
	{
		entity ent = GetEntityFromEncodedEHandle( guid )
		if ( IsValid( ent ) )
		{
			if ( player == null )
			{
				if ( Waypoint_LootItemIsBeingPingedByAnyone( ent ) )
					return true
			}
			else
			{
				entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedByPlayer( ent, player )
				if ( IsValid( pingWaypoint ) )
					return true
			}
		}
	}

	return false
}

void function UICallback_UpdateQuickSwapItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )

	Hud_SetSelected( button, false )
	Hud_SetLocked( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_ClearToolTipData( button )
		Hud_SetEnabled( button, false )
		return
	}

	Hud_SetEnabled( button, true )

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[position]

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	int maxCount = SURVIVAL_GetInventorySlotCountForPlayer( player, lootData )
	RuiSetInt( rui, "maxCount", maxCount )
	RuiSetInt( rui, "ordinaryMaxCount", lootData.lootType == eLootType.AMMO ? lootData.inventorySlotCount : maxCount )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	ToolTipData toolTipData
	toolTipData.titleText = lootData.pickupString
	toolTipData.descText = SURVIVAL_Loot_GetDesc( lootData, player )
	toolTipData.actionHint1 = Localize( "#LOOT_SWAP", file.swapString ).toupper()
	toolTipData.tooltipFlags = IsPingEnabledForPlayer( player ) ? toolTipData.tooltipFlags : toolTipData.tooltipFlags | eToolTipFlag.PING_DISSABLED

	if ( Survival_PlayerCanDrop( player ) )
		toolTipData.actionHint2 = Localize( "#LOOT_ALT_DROP" ).toupper()

	Hud_SetToolTipData( button, toolTipData )
	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

	Hud_SetSelected( button, IsOrdnanceEquipped( player, lootData.ref ) )
	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}


void function UICallback_OnQuickSwapItemClick( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	int slot = -1
	if ( playerInventory.len() > position )
	{
		slot = position
	}

	int deathBoxEntIndex = -1
	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		deathBoxEntIndex = file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	RunUIScript( "SurvivalQuickSwapMenu_DoQuickSwap", slot, deathBoxEntIndex )
}


void function UICallback_OnQuickSwapItemClickRight( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		return
	}

	BackpackAction( eLootAction.DROP, string( position ) )
}


void function UICallback_UpdateQuickSwapItemButton( var button, int guid )
{
	if ( guid < 0 )
		return

	entity loot = GetEntityFromEncodedEHandle( guid )

	if ( !IsValid( loot ) )
		return

	if ( loot.GetNetworkedClassName() != "prop_survival" )
		return

	int lootIdx = loot.GetSurvivalInt()

	if ( !SURVIVAL_Loot_IsLootIndexValid( lootIdx ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootIdx )

	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	string passiveName
	string passiveDesc

	int count = loot.GetClipCount()

	file.swapString = Localize( lootData.pickupString )

	bool isMainWeapon = (lootData.lootType == eLootType.MAINWEAPON)

	RuiSetString( rui, "buttonText", SURVIVAL_Loot_GetDesc( lootData, player ) )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )
	RuiSetInt( rui, "lootType", lootData.lootType )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	RuiSetImage( rui, "ammoTypeImage", $"" )

	if ( isMainWeapon )
	{
		string ammoType = lootData.ammoType
		asset icon      = lootData.fakeAmmoIcon
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) && loot.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}
}


void function OpenSwapForItem( string ref, string guid )
{
	Signal( clGlobal.levelEnt, "OpenSwapForItem" )
	EndSignal( clGlobal.levelEnt, "OpenSwapForItem" )

	if ( !CanOpenInventory( GetLocalClientPlayer() ) )
		return

	RunUIScript( "SurvivalQuickInventory_OpenSwapForItem", guid )
}

bool function FilteredGroundItemsContains( string ref )
{
	for ( int i = 0; i < file.filteredGroundItems.len(); i++ )
	{
		GroundLootData item = file.filteredGroundItems[i]
		if ( item.lootData.ref == ref )
			return true
	}

	return false
}


void function OnUpdateLootPrompt( int style, ToolTipData dt )
{
	UpdateLootTooltip( dt )
}


void function UpdateLootTooltip( ToolTipData dt )
{
	int index       = dt.lootPromptData.index
	int count       = dt.lootPromptData.count
	int entIndex    = dt.lootPromptData.guid
	int lootContext = dt.lootPromptData.lootContext
	int property    = dt.lootPromptData.property

	entity ent
	if ( entIndex != -1 )
		ent = GetEntityFromEncodedEHandle( entIndex )

	LootData data   = SURVIVAL_Loot_GetLootDataByIndex( index )
	LootRef lootRef = SURVIVAL_CreateLootRef( data, ent )
	lootRef.count = count
	lootRef.lootProperty = property


	if ( data.lootType == eLootType.MAINWEAPON )
		data.hudIcon = GetWeaponLootIcon_WeaponLootHint( GetLocalClientPlayer(), data )


	entity player = GetLocalViewPlayer()

	var rui = GetTooltipRui()
	RuiSetBool( rui, "isInDeathBox", dt.lootPromptData.isInDeathBox )
	RuiSetBool( rui, "isTooltip", true )
	RuiSetBool( rui, "isPinged", dt.lootPromptData.isPinged )
	RuiSetBool( rui, "isPingedByUs", dt.lootPromptData.isPingedByUs )

	UpdateLootRuiWithData( player, rui, data, lootContext, lootRef, true )

	RuiSetBool( rui, "canPing", ( lootContext == eLootContext.GROUND ) || ( data.lootType == eLootType.AMMO ) && IsPingEnabledForPlayer( player ) )
	RuiSetBool( rui, "isVisible", (dt.tooltipFlags & eToolTipFlag.HIDDEN) == 0 )
}


void function UIToClient_UpdateInventoryDpadTooltipText( string ref, string emptySlotText, string equipmentSlot )
{
	entity player = GetLocalViewPlayer()

	if ( SURVIVAL_Loot_IsRefValid( ref ) )
	{
		LootActionStruct asMain
		LootActionStruct asAlt
		LootActionStruct asPrimarySwap
		LootActionStruct asCharacter1
		LootActionStruct asCharacter2
		LootData lootData = SURVIVAL_Loot_GetLootDataByRef( ref )
		LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, null )
		LootTypeData lt   = GetLootTypeData( lootData.lootType )

		string itemTitle                = ""
		string backpackAction           = ""
		string backpackAltAction	    = ""
		string backpackPrimarySwapAction= ""
		string backpackCharacterAction1 = ""
		string backpackCharacterAction2 = ""
		string specialPrompt            = ""
		string commsPrompt              = ""

		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.PRIMARY_ACTION, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.ALT_ACTION, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )
			asPrimarySwap = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.PRIMARY_SWAP, true, equipmentSlot )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asPrimarySwap, lootRef )
			asCharacter1 = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.CHARACTER_ACTION1, true, equipmentSlot )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asCharacter1, lootRef )
			asCharacter2 = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.CHARACTER_ACTION2, true, equipmentSlot )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asCharacter2, lootRef )

			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

			if ( es.weaponSlot == 0 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE0" ) + " - "
			else if ( es.weaponSlot == 1 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE1" ) + " - "

			if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
				specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )
		}
		else
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, eLootActionType.PRIMARY_ACTION, true )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, eLootActionType.ALT_ACTION, true )
			asPrimarySwap = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, eLootActionType.PRIMARY_SWAP, true, equipmentSlot )
			asCharacter1 = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, eLootActionType.CHARACTER_ACTION1, true, equipmentSlot )
			asCharacter2 = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, eLootActionType.CHARACTER_ACTION2, true, equipmentSlot )
		}

		backpackAction = asMain.displayString
		backpackAltAction = asAlt.displayString
		backpackPrimarySwapAction = asPrimarySwap.displayString
		backpackCharacterAction1 = asCharacter1.displayString
		backpackCharacterAction2 = asCharacter2.displayString
		itemTitle += lootData.pickupString

		if ( lootData.lootType == eLootType.MAINWEAPON )
		{
			specialPrompt = Localize( "#INVENTORY_MANAGE_ATTACHMENTS" )
			commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_AMMO_GAMEPAD" : "#PING_PROMPT_REQUEST_AMMO"
			commsPrompt = Localize( commsPrompt )
		}

		RunUIScript( "ClientToUI_UpdateInventoryDpadTooltip", itemTitle, backpackAction, backpackAltAction, commsPrompt, specialPrompt, backpackPrimarySwapAction, backpackCharacterAction1, backpackCharacterAction2 )
	}
	else 
	{
		string specialPrompt = ""
		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) && EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
			specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )

		string commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_GAMEPAD" : "#PING_PROMPT_REQUEST"
		commsPrompt = Localize( commsPrompt )
		RunUIScript( "ClientToUI_UpdateInventoryDpadTooltip", emptySlotText, "", "", commsPrompt, specialPrompt )
	}
}


void function GroundItemUpdate( entity player, array<entity> loot )
{
	loot.sort()
	if ( file.shouldResetGroundItems )
	{
		GroundItemsInit( player, loot )

		if ( GetCurrentPlaylistVarBool( "deathbox_diff_enabled", true ) )
		{
			file.shouldResetGroundItems = false
		}

		file.shouldUpdateGroundItems = true
	}
	else
	{
		
		if ( file.lastLoot.len() == loot.len() )
		{
			int length = loot.len()
			for ( int i = 0; i < length; i++ )
			{
				if ( file.lastLoot[i] != loot[i] )
				{
					file.shouldUpdateGroundItems = true
					break
				}
			}
		}
		else
		{
			file.shouldUpdateGroundItems = true
		}

		if ( file.shouldUpdateGroundItems )
		{
			GroundItemsDiff( player, loot )
		}
	}

	file.lastLoot = loot

	if ( file.shouldUpdateGroundItems )
	{
		RunUIScript( "SurvivalGroundItem_SetGroundItemCount", file.filteredGroundItems.len() )
		foreach ( index, item in file.filteredGroundItems )
		{
			RunUIScript( "SurvivalGroundItem_SetGroundItemHeader", index, item.isHeader )
		}
	}

	file.visibleItemIndices.clear()
	file.shouldUpdateGroundItems = false
}


void function GroundItemsDiff( entity player, array<entity> loot )
{
	IntSet indicesInList

	foreach ( index, gd in file.filteredGroundItems )
	{
		gd.guids.clear()

		bool found       = false
		int currentCount = 0
		foreach ( item in loot )
		{
			if ( item.GetNetworkedClassName() != "prop_survival" )
				continue

			if ( gd.lootData.index == item.GetSurvivalInt() )
			{
				currentCount += item.GetClipCount()
				found = true
				gd.guids.append( item.GetEncodedEHandle() )
			}
		}

		gd.count = currentCount
		indicesInList[gd.lootData.index] <- IN_SET
	}

	table<string, GroundLootData> extras
	bool showUpgrades = GetCurrentPlaylistVarBool( "deathbox_show_upgrades", false )

	foreach ( item in loot )
	{
		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		if ( !(item.GetSurvivalInt() in indicesInList) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
			GroundLootData gd
			gd.lootData = data

			if ( data.ref in extras )
				gd = extras[ data.ref ]
			else
			{
				extras[ data.ref ] <- gd

				if ( showUpgrades && SURVIVAL_IsLootAnUpgrade( player, item, gd.lootData, eLootContext.GROUND ) )
				{
					gd.isRelevant = true
					gd.isUpgrade = true
				}
				else if ( SURVIVAL_IsLootIrrelevant( player, item, gd.lootData, eLootContext.GROUND ) )
				{
					gd.isRelevant = false
					gd.isUpgrade = false
				}
				else
				{
					gd.isRelevant = true
					gd.isUpgrade = false
				}
			}


			gd.count += item.GetClipCount()
			gd.guids.append( item.GetEncodedEHandle() )
		}
	}

	foreach ( gd in extras )
		file.filteredGroundItems.append( gd )
}


void function GroundItemsInit( entity player, array<entity> loot )
{
	file.filteredGroundItems.clear()

	array<GroundLootData> upgradeItems
	array<GroundLootData> unusableItems
	array<GroundLootData> relevantItems
	table<string, GroundLootData> allItems

	for ( int groundIndex = 0; groundIndex < loot.len(); groundIndex++ )
	{
		entity item = loot[groundIndex]

		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )

		GroundLootData gd

		if ( data.ref in allItems )
			gd = allItems[ data.ref ]
		else
			allItems[ data.ref ] <- gd

		gd.lootData = data
		gd.count += item.GetClipCount()
		gd.guids.append( item.GetEncodedEHandle() )
	}

	bool sortByType    = GetCurrentPlaylistVarBool( "deathbox_sort_by_type", true )
	bool showUpgrades  = !sortByType && GetCurrentPlaylistVarBool( "deathbox_show_upgrades", true )
	bool splitUnusable = !sortByType && GetCurrentPlaylistVarBool( "deathbox_split_unusable", true )

	foreach ( gd in allItems )
	{
		entity ent = GetEntFromGroundLootData( gd )

		if ( showUpgrades && SURVIVAL_IsLootAnUpgrade( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = true
			gd.isUpgrade = true
			upgradeItems.append( gd )
		}
		else if ( SURVIVAL_IsLootIrrelevant( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = false
			gd.isUpgrade = false
			if ( splitUnusable )
				unusableItems.append( gd )
			else
				relevantItems.append( gd )
		}
		else
		{
			gd.isRelevant = true
			gd.isUpgrade = false
			relevantItems.append( gd )
		}
	}

	if ( sortByType )
	{
		upgradeItems.sort( SortByPriorityThenTierForGroundLoot )
		relevantItems.sort( SortByPriorityThenTierForGroundLoot )
		unusableItems.sort( SortByPriorityThenTierForGroundLoot )
	}
	else
	{
		upgradeItems.sort( SortByAmmoThenTierThenPriority )
		relevantItems.sort( SortByAmmoThenTierThenPriority )
		unusableItems.sort( SortByAmmoThenTierThenPriority )
	}

	if ( upgradeItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UPGRADES", $"rui/pilot_loadout/kit/titan_cowboy_filled" ) )
	}
	file.filteredGroundItems.extend( upgradeItems )

	if ( splitUnusable && relevantItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_USEABLE", $"" ) )
	}
	file.filteredGroundItems.extend( relevantItems )

	if ( splitUnusable && unusableItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UNUSEABLE", $"rui/menu/common/button_unbuyable" ) )
	}
	file.filteredGroundItems.extend( unusableItems )

	if ( !splitUnusable && sortByType && file.filteredGroundItems.len() > 1 )
	{
		int lastLootCat = -1
		for ( int i = file.filteredGroundItems.len() - 1; i >= -1; i-- )
		{
			GroundLootData gd
			int cat = -1

			if ( i >= 0 )
			{
				gd = file.filteredGroundItems[i]
				cat = GetPriorityForLootType( gd.lootData )
			}

			if ( lastLootCat != cat )
			{
				if ( lastLootCat != -1 )
				{
					file.filteredGroundItems.insert( i + 1, CreateHeaderData( GetCategoryTitleFromPriority( lastLootCat ), $"" ) )
				}

				lastLootCat = cat
			}
		}
	}
}


GroundLootData function CreateHeaderData( string title, asset icon )
{
	GroundLootData gd
	gd.isHeader = true
	LootData data
	data.pickupString = title
	data.hudIcon = icon
	gd.lootData = data
	return gd
}


bool function Survival_IsInventoryOpen()
{
	return file.backpackOpened
}


bool function Survival_IsGroundlistOpen()
{
	return file.groundlistOpened
}


void function ShowHealHint( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() != GetLocalViewPlayer() )
		return

	UpdateHealHint( GetLocalClientPlayer() )
}

bool function ShouldShowAnyHint( entity player )
{

	if ( !IsLocalPlayerAlive_NonReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( GetGameState() == eGameState.WinnerDetermined || GetGameState() > eGameState.Epilogue )
		return false

	return true
}

void function UpdateHealHint( entity player )
{
	const float HINT_DURATION = 5.0
	bool allowedToShowHint = ShouldShowAnyHint( player )

	if ( allowedToShowHint && ShouldShowHealHint( player ) )
	{
		if ( Time() - file.lastHealHintDisplayTime < 10.0 )
			return

		if ( CanDeployHealDrone( player ) && player.GetHealth() < player.GetMaxHealth() && !StatusEffect_HasSeverity( player, eStatusEffect.silenced ) )
		{
			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_MEDIC_HEAL_HINT" )
			file.lastHealHintDisplayTime = Time()
			return
		}

		int kitType

		kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
		ConsumableInfo kitInfo = Consumable_GetConsumableInfo( kitType )

		if ( Consumable_IsCurrentSelectedConsumableTypeUseful() && SURVIVAL_CountItemsInInventory( player, kitInfo.lootData.ref ) > 0 )
		{
			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_HEAL_HINT_CROSSHAIR", Localize( kitInfo.lootData.pickupString ) )
			file.lastHealHintDisplayTime = Time()
		}
	}
	else if ( allowedToShowHint && ShouldShowUltHint( player ) )
	{
		float timeSinceUltHint = Time() - file.lastUltHintDisplayTime
		if ( timeSinceUltHint < ULT_HINT_COOLDOWN )
			return

		entity ultWeapon = GetLocalClientPlayer().GetOffhandWeapon( OFFHAND_ULTIMATE )

		ConsumableInfo kitInfo = Consumable_GetConsumableInfo( eConsumableType.ULTIMATE )

		float maxUltChargeFracForHint = 1.0 - ( kitInfo.ultimateAmount / 100.0 )


		if ( Consumable_CanUseUltAccel( GetLocalClientPlayer() ) )
		{
			float ultChargeFrac = ultWeapon.GetWeaponPrimaryClipCount() / float( ultWeapon.GetWeaponPrimaryClipCountMax() )

			if ( ultChargeFrac < maxUltChargeFracForHint && !GetLocalClientPlayer().Player_IsSkywardLaunching() && ( GetUltimateWeaponState() != eUltimateState.ACTIVE ) && SURVIVAL_CountItemsInInventory( GetLocalClientPlayer(), kitInfo.lootData.ref ) > 0 )
			{
				if ( IsControllerModeActive() )
					AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_ULT_ACCEL_HINT_CONTROLLER", Localize( kitInfo.lootData.pickupString ) )
				else
					AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_ULT_ACCEL_HINT_PC", Localize( kitInfo.lootData.pickupString ) )

				file.lastUltHintDisplayTime = Time()
			}
		}

	}

















	else
	{
		HidePlayerHint( "#SURVIVAL_HEAL_HINT_CROSSHAIR" )
		HidePlayerHint( "#SURVIVAL_MEDIC_HEAL_HINT" )
		HidePlayerHint( "#SURVIVAL_ULT_ACCEL_HINT_CONTROLLER" )
		HidePlayerHint( "#SURVIVAL_ULT_ACCEL_HINT_PC" )




	}
}


bool function ShouldShowHealHint( entity player )
{
	float shieldHealthFrac = GetShieldHealthFrac( player )
	float healthFrac       = GetHealthFrac( player )
	if ( (player.GetShieldHealthMax() == 0 || shieldHealthFrac > 0.25) && healthFrac > 0.5 )
		return false


	int kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
	if ( kitType == -1 )
		kitType = Consumable_GetBestConsumableTypeForPlayer( player, 0, 0 )

	if ( !Consumable_CanUseConsumable( player, kitType, false ) && !CanDeployHealDrone( player ) )
		return false

	
	






	return false
}

bool function ShouldShowUltHint( entity player )
{
	int kitType = eConsumableType.ULTIMATE

	if ( !Consumable_CanUseConsumable( player, kitType, false ) )
		return false

	if ( player.GetPlayerNetBool( "isHealing" ) )
		return false

	return true
}



























void function UseHealthPickupRefFromInventory( entity player, string ref )
{
	if ( !( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() ) )
		return

	Consumable_UseItemByRef( player, ref )
}








































void function EquipOrdnance( entity player, string ref )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	Remote_ServerCallFunction( "ClientCallback_Sur_EquipOrdnance", data.index )

	ServerCallback_ClearHints()
}

void function EquipGadget( entity player, string ref )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	Remote_ServerCallFunction( "ClientCallback_Sur_EquipGadget", data.index )

	ServerCallback_ClearHints()
}

void function EquipAttachment( entity player, string item, string weaponName )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	
	
	
	LootData data = SURVIVAL_Loot_GetLootDataByRef( item )
	Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", 	data.index, -1)
	

	ServerCallback_ClearHints()
}


entity function GetBaseWeaponEntForEquipmentSlot( string equipmentSlot )
{
	int slot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )

	if ( slot >= 0 )
		return GetLocalClientPlayer().GetNormalWeapon( slot )

	return null
}


entity function Survival_GetDeathBox()
{
	return file.currentGroundListData.deathBox
}


int function Survival_GetGroundListBehavior()
{
	return file.currentGroundListData.behavior
}


array<entity> function Survival_GetDeathBoxItems()
{
	if ( !IsValid( file.currentGroundListData.deathBox ) || file.currentGroundListData.behavior == eGroundListBehavior.NEARBY )
		return []

	return file.currentGroundListData.deathBox.GetLinkEntArray()
}


void function TryCloseSurvivalInventoryFromDamage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		if ( GetConVarBool( "player_setting_damage_closes_deathbox_menu" ) && !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
		{
			if ( IsValid( attacker ) && ( attacker.IsPlayer() || attacker.IsNPC()) )
			{
				RunUIScript( "TryCloseSurvivalInventoryFromDamage", null )
			}
		}
	}
}

entity function GetEntFromGroundLootData( GroundLootData groundLootData )
{
	entity ent
	for ( int i = 0; i < groundLootData.guids.len() && !IsValid( ent ); i++ )
	{
		ent = GetEntityFromEncodedEHandle( groundLootData.guids[i] )
	}
	return ent
}


void function UICallback_GetLootDataFromButton( var button, int position )
{
	RunUIScript( "ClientCallback_SetTempButtonRef", "" )

	entity player = GetLocalClientPlayer()
	string ref

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= position )
			return

		ConsumableInventoryItem item = playerInventory[ position ]
		LootData lootData            = SURVIVAL_Loot_GetLootDataByIndex( item.type )

		ref = lootData.ref
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )

		ref = data.ref

		RunUIScript( "ClientCallback_SetTempButtonIcon", data.hudIcon )
	}

	RunUIScript( "ClientCallback_SetTempButtonRef", ref )
}


void function UICallback_GetMouseDragAllowedFromButton( var button, int position )
{
	entity player = GetLocalClientPlayer()
	bool allowed  = true

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
		{
			allowed = false
		}
		else
		{
			array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
			if ( playerInventory.len() <= position )
				allowed = false
		}
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )
		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) && EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
			EquipmentSlot ws = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )

			LootData wData = EquipmentSlot_GetEquippedLootDataForSlot( player, ws.ref )
			if ( !SURVIVAL_Loot_IsRefValid( wData.ref ) || SURVIVAL_IsAttachmentPointLocked( wData.ref, es.attachmentPoint ) )
			{
				allowed = false
			}
		}
	}

	RunUIScript( "ClientCallback_SetTempBoolMouseDragAllowed", allowed )
}


void function UICallback_OnInventoryMouseDrop( var dropButton, var sourcePanel, var sourceButton, int sourceIndex, bool initOnly )
{
	if ( initOnly )
		Hud_SetLocked( dropButton, false )

	string sourceEquipmentSlot
	if ( sourceIndex > -1 )
		sourceEquipmentSlot = "inventory"
	else
		sourceEquipmentSlot = Hud_GetScriptID( sourceButton )

	string dropEquipmentSlot = Hud_GetScriptID( dropButton )

	string sourceEquipmentWeaponSlot

	if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( sourceEquipmentSlot )
			sourceEquipmentWeaponSlot = es.attachmentWeaponSlot
		}
	}
	entity player = GetLocalClientPlayer()

	if ( EquipmentSlot_IsValidEquipmentSlot( dropEquipmentSlot ) )
	{
		EquipmentSlot des = Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

		if ( des.passiveRequired != -1 )
			Hud_SetVisible( dropButton, PlayerHasPassive( player, des.passiveRequired ) )
	}

	
	if ( dropEquipmentSlot == sourceEquipmentSlot || dropEquipmentSlot == sourceEquipmentWeaponSlot )
		return

	if ( initOnly )
		Hud_SetLocked( dropButton, true )


	LootData data

	if ( sourceIndex > -1 )
	{
		if ( sourceIndex >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= sourceIndex )
			return

		ConsumableInventoryItem item = playerInventory[ sourceIndex ]
		data = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( sourceButton )

		data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	}

	
	if ( EquipmentSlot_IsValidEquipmentSlot( dropEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( dropEquipmentSlot ) )
		{
			LootData dropSlotData = EquipmentSlot_GetEquippedLootDataForSlot( player, dropEquipmentSlot )
			EquipmentSlot es      = Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

			if ( data.lootType == eLootType.ATTACHMENT )
			{
				if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
				{
					if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
					{
						if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
						{
							if ( initOnly )
								Hud_SetLocked( dropButton, false )
							else
								EquipmentAction( eLootAction.WEAPON_TRANSFER, sourceEquipmentSlot )
						}
					}
				}
				else if ( sourceEquipmentSlot == "inventory" )
				{
					if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
					{
						if ( initOnly )
							Hud_SetLocked( dropButton, false )
						else
							Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", data.index, es.weaponSlot )
					}
				}
			}
			else if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
			{
				if ( EquipmentSlot_IsMainWeaponSlot( sourceEquipmentSlot ) )
				{
					if ( initOnly )
						Hud_SetLocked( dropButton, false )
					else
						Remote_ServerCallFunction( "ClientCallback_Sur_SwapPrimaryPositions" )
				}
				else if ( sourceEquipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
				{
					if ( initOnly )
						Hud_SetLocked( dropButton, false )
					else
					{
						if( !IsBallisticUltActive( player ) )
							Remote_ServerCallFunction( "ClientCallback_Sur_SlingToMainWeaponSlot", es.weaponSlot )
					}
				}
			}
		}
		else if ( dropEquipmentSlot == SLING_EQUIPMENT_SLOT_NAME )
		{
			EquipmentSlot des 	= Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

			if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
			{
				EquipmentSlot es 	= Survival_GetEquipmentSlotDataByRef( sourceEquipmentSlot )
				if ( EquipmentSlot_IsMainWeaponSlot( sourceEquipmentSlot ) )
				{
					if ( initOnly )
						Hud_SetLocked( dropButton, false )
					else
					{
						if( CanPlayerEquipWeaponRefToSling( player, EquipmentSlot_GetLootRefForSlot( player, es.ref ) ) )
							Remote_ServerCallFunction( "ClientCallback_Sur_SlingToMainWeaponSlot", es.weaponSlot )
					}
				}
			}
		}
	}
	else if ( dropEquipmentSlot == "inventory" )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			if ( SURVIVAL_AddToPlayerInventory( player, data.ref ) > 0 )
			{
				if ( initOnly )
					Hud_SetLocked( dropButton, false )
				else
					EquipmentAction( eLootAction.REMOVE, sourceEquipmentSlot )
			}
		}
	}
	else if ( dropEquipmentSlot == "ground" )
	{
		if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else if ( !EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
				EquipmentAction( eLootAction.DROP, sourceEquipmentSlot )
			else
				EquipmentAction( eLootAction.REMOVE_TO_GROUND, sourceEquipmentSlot )
		}
		else if ( sourceEquipmentSlot == "inventory" )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else
				BackpackAction( eLootAction.DROP_ALL, string( sourceIndex ) )
		}
	}
}


void function UIToClient_WeaponSwap()
{
	entity player = GetLocalViewPlayer()

	if ( player != GetLocalClientPlayer() )
		return

	thread WeaponSwap( player )
}


void function WeaponSwap( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}

void function OnLocalPlayerPickedUpItem( entity player, LootData data, int lootAction )
{
	TryResetGroundList( player, data, lootAction )

	if ( IsValid( player ) )
		EmitSoundOnEntity( player, data.pickupSound_1p )
}

void function TryResetGroundList( entity player, LootData data, int lootAction )
{
	if ( file.groundlistOpened )
		GroundListResetNextFrame()
}


void function TryUpdateGroundList()
{
	if ( file.groundlistOpened )
		file.shouldUpdateGroundItems = true
}


void function GroundListResetNextFrame()
{
	file.shouldResetGroundItems = true
}


void function UICallback_UpdatePlayerInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	if ( GetBugReproNum() == 54268 )
		SURVIVAL_PopulatePlayerInfoRui( player, rui )
	else
		thread TEMP_UpdatePlayerRui( rui, player )
}


void function UICallback_UpdateTeammateInfo( var elem, bool isCompact )
{
	if ( GetBugReproNum() == 54268 )
	{
		var rui           = Hud_GetRui( elem )
		int teammateIndex = int( Hud_GetScriptID( elem ) )

		entity player = GetLocalClientPlayer()

		array<entity> team = GetPlayerArrayOfTeam( player.GetTeam() )
		team.fastremovebyvalue( player )







		
		team.sort( SquadMemberIndexSort )

		if ( teammateIndex < team.len() )
		{
			Hud_SetHeight( elem, Hud_GetBaseHeight( elem ) )
			Hud_Show( elem )
		}
		else
		{
			Hud_SetHeight( elem, 0 )
			Hud_Hide( elem )
			return
		}

		entity ent = ( teammateIndex < 0 )? player: team[ teammateIndex ]

		thread SetUnitFrameDataFromOwner( rui, ent, player )
	}

	else
		thread TEMP_UpdateTeammateRui( elem, isCompact )
}


void function UICallback_UpdateTeammateUpgrades( var elem, int upgradeIndex )
{
	if( !UpgradeCore_IsEnabled() || IsLobby() )
		return

	var rui = Hud_GetRui( elem )
	int teammateIndex = int( Hud_GetScriptID( elem ) )

	entity player = GetLocalClientPlayer()

	array<entity> team = GetPlayerArrayOfTeam( player.GetTeam() )
	team.fastremovebyvalue( player )







	
	team.sort( SquadMemberIndexSort )

	if ( teammateIndex >= team.len() )
		return

	entity teammate = ( teammateIndex < 0 )? player: team[ teammateIndex ]
	array<UpgradeCoreChoice> selectedUpgrades = UpgradeCore_GetSelectedUpgrades( teammate )

	if ( upgradeIndex < selectedUpgrades.len() )
	{
		UpgradeCoreChoice upgrade = selectedUpgrades[upgradeIndex]
		RuiSetImage( rui, "slotImage" + (upgradeIndex + 1), upgrade.icon )
	}
	else
	{
		RuiSetImage( rui, "slotImage" + (upgradeIndex + 1), $"" )
	}
}



void function UICallback_UpdateUltimateInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	thread TEMP_UpdateUltimateInfo( rui, player )


	{
		entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		string ultName = (IsValid( ultWeapon ) ? string( ultWeapon.GetWeaponPrintName() ) : "")
		RunUIScript( "ClientToUI_UpdateInventoryUltimateTooltip", elem, ultName )
	}

}


void function TEMP_UpdateUltimateInfo( var rui, entity player )
{
	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	int slot = OFFHAND_INVENTORY

	float PROTO_storedAmmoRegenRate = -1.0

	while ( true )
	{
		if ( IsAlive( player ) )
		{
			entity weapon = player.GetOffhandWeapon( slot )
			if ( IsValid( weapon ) )
			{
				thread UpdateInventoryUltimateRui( rui, player, weapon )

				float currentAmmoRegenRate = weapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate )
				if ( currentAmmoRegenRate != PROTO_storedAmmoRegenRate )
				{
					RuiSetFloat( rui, "refillRate", currentAmmoRegenRate )
					PROTO_storedAmmoRegenRate = currentAmmoRegenRate
				}
			}
			else
			{
				RuiSetBool( rui, "isVisible", false )
			}
		}
		WaitFrame()
	}
}


void function UpdateInventoryUltimateRui( var rui, entity player, entity weapon )
{
	
	Assert ( IsNewThread(), "Must be threaded off." )

	UpdateOffhandRuiCommon( rui, player, weapon, OFFHAND_ULTIMATE, false )
}


void function TEMP_UpdatePlayerRui( var rui, entity player )
{
	printf( "EvoShieldDebug: Temp_UpdatePlayerRui called" )

	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	asset legendIcon      = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "playerIcon", legendIcon )
	RuiSetInt( rui, "micStatus", player.HasMic() ? 3 : -1 ) 

	while ( true )
	{
		foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( es.trackingNetInt != "" )
			{
				LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
				int tier      = data.tier
				asset hudIcon = data.hudIcon

				if ( data.lootType == eLootType.ARMOR )
				{
					bool isEvolving = EvolvingArmor_IsEquipmentEvolvingArmor( data.ref )

					if( UpgradeCore_IsEquipmentArmorCore( data.ref ) )
					{
						isEvolving = true
						tier = UpgradeCore_GetPlayerArmorTier( player, false )
					}
					RuiSetBool( rui, "showProgressMeter",  UpgradeCore_ArmorTiedToUpgrades() && UpgradeCore_ShowUpgradesUnitframe() )

					RuiSetBool( rui, "isEvolvingShield", isEvolving )
					RuiSetInt( rui, "evolvingShieldKillCounter", EvolvingArmor_GetEvolutionProgress( player ) )



						RuiSetBool( rui, "hasReducedShieldValues", false )

				}
				else if ( equipSlot == "armor" && data.ref == "" )
				{
					RuiSetBool( rui, "isEvolvingShield", false )

						RuiSetBool( rui, "showProgressMeter",  UpgradeCore_ArmorTiedToUpgrades() && UpgradeCore_ShowUpgradesUnitframe() )

				}

				if ( es.unitFrameTierVar != "" )
				RuiSetInt( rui, es.unitFrameTierVar, tier )
				if ( es.unitFrameImageVar != "" )
				RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
			}
		}

		RuiSetString( rui, "name", player.GetPlayerName() )
		RuiSetFloat( rui, "playerHealthFrac", GetHealthFrac( player ) )
		RuiSetFloat( rui, "playerShieldFrac", GetShieldHealthFrac( player ) )
		RuiSetInt( rui, "teamMemberIndex", player.GetTeamMemberIndex() )
		RuiSetInt( rui, "squadID", player.GetSquadID() )

		vector shieldFrac = < SURVIVAL_GetArmorShieldCapacity( 0 ) / 100.0,
		SURVIVAL_GetArmorShieldCapacity( 1 ) / 100.0,
		SURVIVAL_GetArmorShieldCapacity( 2 ) / 100.0 >

		RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetArmorShieldCapacity( 3 ) ) )

		RuiSetFloat( rui, "playerTargetShieldFrac", StatusEffect_GetTotalSeverity( player, eStatusEffect.target_shields ) )
		RuiSetFloat( rui, "playerTargetHealthFrac", StatusEffect_GetTotalSeverity( player, eStatusEffect.target_health ) )
		RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) )
		RuiSetBool( rui, "useShadowFormFrame", StatusEffect_HasSeverity( player, eStatusEffect.death_totem_visual_effect ) )


			RuiSetInt( rui, "playerOvershield", player.GetTempshieldHealth() )
			int arcFlashState = GetArcFlashState( player )
			RuiSetBool( rui, "playerOvershieldCharging", arcFlashState == eArcFlashState.CHARGE )


		RuiSetInt( rui, "micStatus", GetPlayerMicStatus( player ) )


			asset classIcon = CharacterClass_GetCharacterRoleImage( character )
			RuiSetAsset( rui, "customSmallIcon", classIcon )



		if( UpgradeCore_IsEnabled() )
		{
			RuiSetBool( rui, "showProgressBar", true )
			UpgradeCore_UpdateSelectedUpgradeRui( rui, player )
			UpgradeCore_UpdateXpRui( rui, player )

			
			int extraShields = GetPlayerExtraShields( player )
			RunUIScript( "SurvivalInventoryMenu_SetEquipmentButtonFxState", "armor", ( extraShields > 0 ) )
			RunUIScript( "RTKLegendUpgradesArmorCore_UpdateArmorCoreDataModel" )

			RuiSetInt( rui, "armorShieldCapacity", player.GetShieldHealthMax() )
			RuiSetInt( rui, "playerExtraShield", GetPlayerExtraShields( player ) )
			RuiSetInt( rui, "playerExtraShieldTier", GetPlayerExtraShieldsTier( player ) )
		}


		SquadLeader_UpdateUnitFrameRui( player, rui )
		Status_UpdatePlayerUnitFrameRui( player, rui )

		
		OverwriteWithCustomPlayerInfoTreatment( player, rui )

		PlayerInfo_UpdatePossibleHealTo( player, rui )

		WaitFrame()
	}
}


void function TEMP_UpdateTeammateRui( var elem, bool isCompact )
{
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )
	clGlobal.levelEnt.EndSignal( "GroundListClosed" )

	var rui           = Hud_GetRui( elem )
	int teammateIndex = int( Hud_GetScriptID( elem ) )
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return


		if ( GameMode_IsActive( eGameModes.CONTROL ) )
		{
			player.EndSignal( "Control_PlayerHasChosenRespawn" )
		}


	while ( true )
	{
		array<entity> team

		if ( IsValid( player ) )
		{
			team = GetPlayerArrayOfTeam( player.GetTeam() )

			team.fastremovebyvalue( player )






		}

		
		team.sort( SquadMemberIndexSort )

		RuiSetBool( rui, "isJIP", false )

		if ( teammateIndex < team.len() )
		{
			Hud_SetHeight( elem, Hud_GetBaseHeight( elem ) )
			Hud_Show( elem )

			entity ent = ( teammateIndex < 0 )? player: team[ teammateIndex ]
			ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( ent ), Loadout_Character() )
			asset legendIcon      = CharacterClass_GetGalleryPortrait( character )
			RuiSetImage( rui, "icon", legendIcon )
			RuiSetInt( rui, "micStatus", ent.HasMic() ? 3 : -1 ) 
			RuiSetBool( rui, "compactMode", isCompact )

			if( UpgradeCore_IsEnabled() )
			{
				int numUpgradeSlots = UPGRADE_CORE_NUM_EXPECTED_UPGRADES / UPGRADE_CORE_NUM_EXPECTED_UPGRADES_PER_LEVEL
				for( int upgradeIndex = 0; upgradeIndex < numUpgradeSlots; upgradeIndex++ )
				{
					array<UpgradeCoreChoice> selectedUpgrades = UpgradeCore_GetSelectedUpgrades( ent )

					if ( upgradeIndex < selectedUpgrades.len() )
					{
						UpgradeCoreChoice upgrade = selectedUpgrades[upgradeIndex]
						RuiSetImage( rui, "slotImage" + (upgradeIndex + 1), upgrade.icon )
					}
					else
					{
						RuiSetImage( rui, "slotImage" + (upgradeIndex + 1), $"" )
					}
				}
			}


			foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
			{
				if ( es.trackingNetInt != "" )
				{
					LootData data = EquipmentSlot_GetEquippedLootDataForSlot( ent, equipSlot )
					int tier      = data.tier
					asset hudIcon = tier > 0 ? data.hudIcon : es.emptyImage

					if ( data.lootType == eLootType.ARMOR )
					{
						bool isEvolving = EvolvingArmor_IsEquipmentEvolvingArmor( data.ref )

						if( UpgradeCore_IsEquipmentArmorCore( data.ref ) )
						{
							isEvolving = true
							int playerArmorTier = UpgradeCore_GetPlayerArmorTier( ent, false )
							RuiSetInt( rui, "armorTierBarOverride", playerArmorTier )
							tier = maxint( playerArmorTier, tier )
						}
						else
						{
							RuiSetInt( rui, "armorTierBarOverride", -1 )
						}

						RuiSetBool( rui, "isEvolvingShield", isEvolving )
					}



						RuiSetBool( rui, "hasReducedShieldValues", false )


					if ( es.unitFrameTierVar != "" )
					RuiSetInt( rui, es.unitFrameTierVar, tier )
					if ( es.unitFrameImageVar != "" )
					RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
				}
			}

			RuiSetString( rui, "name", ent.GetPlayerName() )
			RuiSetFloat( rui, "healthFrac", GetHealthFrac( ent ) )
			RuiSetFloat( rui, "shieldFrac", GetShieldHealthFrac( ent ) )
			RuiSetFloat( rui, "targetHealthFrac", StatusEffect_GetTotalSeverity( ent, eStatusEffect.target_health ) )
			RuiSetFloat( rui, "targetShieldFrac", StatusEffect_GetTotalSeverity( ent, eStatusEffect.target_shields ) )
			RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( ent, eStatusEffect.camera_view ) )
			RuiSetInt( rui, "teamMemberIndex", ent.GetTeamMemberIndex() )
			RuiSetInt( rui, "squadID", ent.GetSquadID() )
			RuiSetBool( rui, "disconnected", !ent.IsConnectionActive() )


				RuiSetBool( rui, "isDriving", HoverVehicle_PlayerIsDriving( ent ) )


			SetUnitFrameConsumableData(rui, ent)

			RuiSetFloat( rui, "reviveEndTime", ent.GetPlayerNetTime( "reviveEndTime" ) )
			RuiSetInt( rui, "reviveType", ent.GetPlayerNetInt( "reviveType" ) )
			RuiSetFloat( rui, "bleedoutEndTime", ent.GetPlayerNetTime( "bleedoutEndTime" ) )
			RuiSetInt( rui, "respawnStatus", ent.GetPlayerNetInt( "respawnStatus" ) )
			RuiSetFloat( rui, "respawnStatusEndTime", ent.GetPlayerNetTime( "respawnStatusEndTime" ) )






				RuiSetInt( rui, "overshield", ent.GetTempshieldHealth() )
				int arcFlashState = GetArcFlashState( ent )
				RuiSetBool( rui, "overshieldCharging", arcFlashState == eArcFlashState.CHARGE )


			RuiSetInt( rui, "micStatus", GetPlayerMicStatus( ent ) )

			
			RuiSetGameTime( rui, "realGameTime", Time() )
			RuiSetFloat( rui, "hackStartTime", ent.GetPlayerNetTime( "hackStartTime" ) )

			SetUnitFrameAmmoTypeIcons( rui, ent )
			OverwriteWithCustomUnitFrameInfo( ent, rui )


				bool localPlayerCanCraftBanners = Perk_CanBuyBanners( player )
				RuiSetBool( rui, "bannerCraftable", localPlayerCanCraftBanners )

				asset classIcon = CharacterClass_GetCharacterRoleImage( character )
				RuiSetAsset( rui, "customSmallIcon", classIcon )
				if ( player.p.activePerks.len() > 0 )
				{
					RuiTrackBool( rui, "hasAltStatus", player, RUI_TRACK_SCRIPT_NETWORK_VAR_BOOL, GetNetworkedVariableIndex( EXPIRED_BANNER_RECOVERY_NETVAR ) )
				}



			if( UpgradeCore_IsEnabled() )
			{
				RuiSetBool( rui, "showProgressMeter",  UpgradeCore_ArmorTiedToUpgrades() && UpgradeCore_ShowUpgradesUnitframe() )







				RuiSetBool( rui, "showProgressBar", true )
				UpgradeCore_UpdateXpRui( rui, ent )

				RuiSetInt( rui, "armorShieldCapacity", ent.GetShieldHealthMax() )
				RuiSetInt( rui, "playerExtraShield", GetPlayerExtraShields( ent ) )
				RuiSetInt( rui, "playerExtraShieldTier", GetPlayerExtraShieldsTier( ent ) )

				vector shieldTierColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, GetPlayerExtraShieldsTier( player ) ) / 255.0
				RuiSetFloat3( rui, "playerShieldTierColor", shieldTierColor )
			}
			else

				RuiSetBool( rui, "showProgressMeter", false )

			bool showBleedoutTimer = true

				showBleedoutTimer = !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_STRIKEOUT )

			RuiSetBool( rui, "showBleedoutTimer", showBleedoutTimer )


		}
		else
		{
			if( GamemodeUtility_IsJIPEnabled() && !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) && !IsPrivateMatch() && !IsEventFinale() && GetMaxTeamSizeForPlaylist( GetCurrentPlaylistName() ) - 1 > teammateIndex )
			{
				Hud_SetHeight( elem, Hud_GetBaseHeight( elem ) )
				Hud_Show( elem )

				if ( IsValid( player ) )
				{
					vector playerColor = Teams_GetTeamColor( player.GetTeam() )

					RuiSetBool( rui, "useCustomCharacterColor", true )
					RuiSetColorAlpha( rui, "customCharacterColor", playerColor, 1.0 )
				}

				RuiSetBool( rui, "isJIP", true )
				RuiSetString( rui, "name", Localize( "#JIP_SEARCHING_FOR_SHORT" ))
			}
			else
			{
				Hud_SetHeight( elem, 0 )
				Hud_Hide( elem )
			}
		}

		WaitFrame()
	}
}

bool function GetShowUnitFrameAmmoTypeIcons()
{
	return file.shouldShowUnitFrameAmmoTypeIcons
}

void function SetShowUnitFrameAmmoTypeIcons( bool show = true )
{
	file.shouldShowUnitFrameAmmoTypeIcons = show
}

void function SetUnitFrameAmmoTypeIcons( var rui, entity player )
{
	for ( int i = 0; i < 2; i++ )
	{
		string ammoTypeIconBool = "showAmmoIcon0" + string( i )
		string ammoTypeIcon     = "ammoTypeIcon0" + string( i )

		asset hudIcon = $"white"

		string weaponIndexNetIntName 	= "playerPrimaryWeapon" + string( i )
		int weaponIndex   				= player.GetPlayerNetInt( weaponIndexNetIntName )
		if ( !SURVIVAL_Loot_IsLootIndexValid( weaponIndex ) )
		{
			hudIcon = $"white"

			RuiSetBool( rui, ammoTypeIconBool, false )
			RuiSetImage( rui, ammoTypeIcon, hudIcon )
		}
		else
		{
			LootData weaponData = SURVIVAL_Loot_GetLootDataByIndex( weaponIndex )
			string ammoType     = weaponData.ammoType
			if ( GetWeaponInfoFileKeyField_GlobalBool( weaponData.baseWeapon, "uses_ammo_pool" ) )
			{
				LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
				hudIcon = ammoData.hudIcon
			}
			else
				hudIcon = weaponData.fakeAmmoIcon

			RuiSetImage( rui, ammoTypeIcon, hudIcon )
			RuiSetBool( rui, ammoTypeIconBool, GetShowUnitFrameAmmoTypeIcons() )
		}
	}
}


void function UICallback_BlockPingForDuration( float duration )
{
	AddOnscreenPromptFunction( "ping", OnscreenPrompt_DoNothing, 0.5, "" )
}


void function OnscreenPrompt_DoNothing( entity player )
{

}


int function GetCountForLootType( int lootType )
{
	entity player                       = GetLocalViewPlayer()
	table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

	int typeCount = 0

	foreach ( data in allLootData )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue

		if ( data.lootType != lootType )
			continue

		if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
			continue

		typeCount++
	}

	return typeCount
}