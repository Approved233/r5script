global function RTKLegendMeleeScreen_OnInitialize
global function RTKLegendMeleeScreen_OnDestroy

global function InitRTKLegendMeleePanel
global function GetLegendMeleeCustomizeItem
global function FillLegendMeleeEquippedIcons
global function OnMeleeCustomizationClosed
global function RTKMutator_ShowMeleeItemUpgradeButton

global enum eMeleeItemState
{
	LOCKED,
	AVAILABLE,
	SELECTED,
	EQUIPPED,
	SELECTED_AND_EQUIPPED,
	SELECTED_AND_LOCKED,
	_COUNT,
}

global struct RTKLegendMeleeScreen_Properties
{
	rtk_panel itemList
	rtk_behavior equipButton
	rtk_behavior customizeButton
	rtk_behavior upgradeButton
	rtk_panel equippedItems
	rtk_panel addons
}

global struct RTKMeleeItemModel
{
	string name
	int quality
	asset eventIcon
	bool equipped
	bool locked
	bool selected
	string actionText
	bool hasUpgrades
	int state
}

global struct RTKMeleeModel
{
	array<RTKMeleeItemModel> listItems
	RTKMeleeItemModel& previewItem
	string listHeader
	bool inCustomization

	
	bool isDefault
	string videoPreview
	asset deathboxImage
	string deathboxName
	string deathboxDesc
	RTKMeleeCustomizationSetModel& equippedItems
	bool showEquippedItems
	array<RTKMeleeCustomizationItemModel> addons
	bool showAddons
	array<asset> equippedToLegendIcons
	bool isLegendLocked
	int heirloomShards
}

struct
{
	bool isVisible = false
	array<ItemFlavor> meleeSkins = []
	int focusedIndex = -1
	int previewIndex = -1
	int customizeIndex = -1
} file

void function RTKLegendMeleeScreen_OnInitialize( rtk_behavior self )
{
	RunClientScript( "EnableModelTurn" )
	RunMenuClientFunction( "ClearAllCharacterPreview" )
	UI_SetPresentationType( ePresentationType.MELEE_INSPECT )

	
	file.meleeSkins = GetSelectableMeleeSkins()

	
	rtk_struct rtkModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "melee", "RTKMeleeModel", ["legend"] )
	rtk_array meleeSkinItems = RTKStruct_GetArray( rtkModel, "listItems" )
	ItemFlavor equippedSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ) )
	int ownedCount = 0
	foreach (int index, ItemFlavor meleeSkinItemFlav in file.meleeSkins)
	{
		rtk_struct meleeSkinItemStruct = RTKArray_PushNewStruct( meleeSkinItems )

		RTKMeleeItemModel meleeSkinItemModel
		meleeSkinItemModel.name = Localize( ItemFlavor_GetLongName( meleeSkinItemFlav ) )
		meleeSkinItemModel.quality = ItemFlavor_GetQuality( meleeSkinItemFlav )
		meleeSkinItemModel.eventIcon = ItemFlavor_GetSourceIcon( meleeSkinItemFlav )
		meleeSkinItemModel.equipped = meleeSkinItemFlav == equippedSkin
		meleeSkinItemModel.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), meleeSkinItemFlav )
		meleeSkinItemModel.selected = false

		if ( !meleeSkinItemModel.locked )
		{
			ownedCount++
			meleeSkinItemModel.actionText = "#EQUIP"
		}
		else
		{
			meleeSkinItemModel.actionText = MeleeSkin_IsRewardForActiveEvent( meleeSkinItemFlav ) ? "#MENU_STORE_PANEL_EVENT_SHOP" : "#UNLOCK"
		}

		if ( Artifacts_Loadouts_IsConfigPointerItemFlavor( meleeSkinItemFlav ) )
		{
			meleeSkinItemModel.name = !meleeSkinItemModel.locked ? Localize( ItemFlavor_GetLongName( meleeSkinItemFlav ), Artifacts_Loadouts_GetConfigIndex( meleeSkinItemFlav ) + 1 ) :  Localize( "#MELEE_SKIN_ARTIFACT_DAGGER_NAME" )
		}


		int meleeSkinTheme = UniversalMelee_GetTheme( meleeSkinItemFlav )
		if ( UniversalMelee_IsItemFlavorUniversalMelee( meleeSkinItemFlav ) )
		{
			meleeSkinItemModel.hasUpgrades = UniversalMelee_GetAddons( meleeSkinItemFlav ).len() > 0
		}


		if ( meleeSkinItemModel.locked )
		{
			meleeSkinItemModel.state = eMeleeItemState.LOCKED
		}
		else if ( meleeSkinItemModel.equipped && meleeSkinItemModel.selected )
		{
			meleeSkinItemModel.state = eMeleeItemState.SELECTED_AND_EQUIPPED
		}
		else if ( meleeSkinItemModel.equipped )
		{
			meleeSkinItemModel.state = eMeleeItemState.EQUIPPED
		}
		else
		{
			meleeSkinItemModel.state = eMeleeItemState.AVAILABLE
		}

		RTKStruct_SetValue( meleeSkinItemStruct, meleeSkinItemModel )
	}

	RTKStruct_SetString( rtkModel, "listHeader", Localize( "#OWNED_COLLECTED", ownedCount, file.meleeSkins.len() ) )
	RTKStruct_SetBool( rtkModel, "isLegendLocked", !Character_IsCharacterOwnedByPlayer(GetTopLevelCustomizeContext() ) )

	
	PreviewItem( 0, true )

	
	rtk_panel ornull itemList = self.PropGetPanel( "itemList" )
	if ( itemList != null )
	{
		expect rtk_panel( itemList )
		self.AutoSubscribe( itemList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ){
			array< rtk_behavior > itemListButtons = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in itemListButtons )
			{
				rtk_struct meleeStruct = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )

				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, meleeStruct ) {
					bool equipSuccess = false
					bool equipFail = false
					if ( keycode == MOUSE_RIGHT || keycode == BUTTON_X )
					{

							ItemFlavor character = GetTopLevelCustomizeContext()
							Assert( ItemFlavor_GetType( character ) == eItemType.character )
							if ( NPP_ShouldDisableGRXForNPPLegend( GetLocalClientPlayer(), character ) )
							{
								EmitUISound( "menu_deny" )
								return
							}

						if ( RTKStruct_GetBool( meleeStruct, "isLegendLocked" ) )
						{
							OpenUnlockLegendDialog()
						}
						else
						{
							equipSuccess = EquipItem( newChildIndex )
							equipFail = !equipSuccess
						}
					}

					else if ( keycode == MOUSE_MIDDLE )
						CustomizeItem( newChildIndex )

					else
						EmitUISound( "UI_Menu_Banner_Preview" )

					if ( !equipFail )
						PreviewItem( newChildIndex, equipSuccess )
				} )

				self.AutoSubscribe( button, "onDoublePressed", function( rtk_behavior button, int keycode ) : ( self, newChildIndex, meleeStruct ) {
					if ( keycode == MOUSE_LEFT )
					{

							ItemFlavor character = GetTopLevelCustomizeContext()
							Assert( ItemFlavor_GetType( character ) == eItemType.character )
							if ( NPP_ShouldDisableGRXForNPPLegend( GetLocalClientPlayer(), character ) )
							{
								EmitUISound( "menu_deny" )
								return
							}

						if ( RTKStruct_GetBool( meleeStruct, "isLegendLocked" ) )
						{
							OpenUnlockLegendDialog()
						}
						else
						{
							EquipItem( newChildIndex )
						}
					}
				} )

				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex ) {
					file.focusedIndex = newChildIndex
					UpdateFooterOptions()
				} )

				self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
					file.focusedIndex = -1
					UpdateFooterOptions()
				} )
			}
		} )
	}

	
	rtk_behavior ornull equipButton = self.PropGetBehavior( "equipButton" )
	if ( equipButton != null )
	{
		expect rtk_behavior( equipButton )
		self.AutoSubscribe( equipButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			EquipItemAtIndex( file.previewIndex )
		} )
	}

	
	rtk_behavior ornull customizeButton = self.PropGetBehavior( "customizeButton" )
	if ( customizeButton != null )
	{
		expect rtk_behavior( customizeButton )
		self.AutoSubscribe( customizeButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			CustomizeItem( file.previewIndex )
		} )
	}

	
	rtk_behavior ornull upgradeButton = self.PropGetBehavior( "upgradeButton" )
	if ( upgradeButton != null )
	{
		expect rtk_behavior( upgradeButton )
		self.AutoSubscribe( upgradeButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			UpgradeItem( file.previewIndex )
		} )
	}

	
	rtk_panel ornull equippedItems = self.PropGetPanel( "equippedItems" )
	if ( equippedItems != null )
	{
		expect rtk_panel( equippedItems )

		array< rtk_panel > components = equippedItems.FindChildByName( "Set" ).GetChildren()
		foreach( rtk_panel component in components )
		{
			rtk_behavior ornull button = component.FindBehaviorByTypeName( "Button" )

			if ( button != null )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
					CustomizeItem( file.previewIndex )
				} )
			}
		}
	}


	
	rtk_panel ornull addons = self.PropGetPanel( "addons" )
	if ( addons != null )
	{
		expect rtk_panel( addons )

		rtk_panel set = addons.FindChildByName( "Set" )

		self.AutoSubscribe( set, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {
			rtk_behavior ornull button = newChild.FindBehaviorByTypeName( "Button" )

			if ( button != null )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
					
					
					if ( newChildIndex == 1 )
					{
						rtk_struct meleeModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )
						RTKStruct_SetString( meleeModel, "videoPreview", UniversalMelee_GetVideo( UniversalMelee_GetAddons( file.meleeSkins[ file.previewIndex ] )[0] ) )
						RunClientScript( "UIToClient_ClearMeleeSkinPreview" )
						UpdateFooterOptions()
					}
					else {
						PreviewItem( file.previewIndex, false )
					}
				} )
			}
		} )
	}


	file.isVisible = true
	RTKLegendMeleeScreen_SetEquippedItems()
	UpdateHeirloomShards()
}

void function RTKLegendMeleeScreen_OnDestroy( rtk_behavior self )
{
	file.isVisible = false

	UI_SetPresentationType( ePresentationType.INACTIVE )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "melee", ["legend"] )
}

void function InitRTKLegendMeleePanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, LegendMeleePanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, LegendMeleePanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

#if PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, CanZoomMeleeItem )
#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, CanZoomMeleeItem )
#endif

	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", EquipFocusedItem, CanUnlockFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EVENT_SHOP", "#X_BUTTON_EVENT_SHOP", EquipFocusedItem, CanUnlockFocusedEventShop )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", EquipFocusedItem, CanEquipFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", EquipFocusedItem, CanUnlockLegend )
}

void function LegendMeleePanel_OnShow( var panel )
{
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )

	var parentMenu = Hud_GetParent( panel )
	Hud_SetVisible( Hud_GetChild( parentMenu, "LegendMeleePanelModelRotateMouseCapture"), true )

	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
}

void function LegendMeleePanel_OnHide( var panel )
{
	var parentMenu = Hud_GetParent( panel )
	Hud_SetVisible( Hud_GetChild( parentMenu, "LegendMeleePanelModelRotateMouseCapture"), false )
	if ( IsConnected() && IsLobby() && IsLocalClientEHIValid() && IsTopLevelCustomizeContextValid() )
		RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
}

bool function CanUnlockFocused()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.meleeSkins.len() )
		return false

	if ( CanUnlockLegend() )
		return false


		return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ file.focusedIndex ] ) && !MeleeSkin_IsRewardForActiveEvent( file.meleeSkins[ file.focusedIndex ] ) && !NPP_ShouldDisableGRXForNPPLegend( GetLocalClientPlayer(), GetTopLevelCustomizeContext() )



}

bool function CanUnlockFocusedEventShop()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.meleeSkins.len() )
		return false

	return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ file.focusedIndex ] ) && MeleeSkin_IsRewardForActiveEvent( file.meleeSkins[ file.focusedIndex ] )
}

bool function CanEquipFocused()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.meleeSkins.len() )
		return false

	if ( CanUnlockLegend() )
		return false

	if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ file.focusedIndex ] ) )
		return false

	return file.meleeSkins[ file.focusedIndex ] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ) )
}

bool function CanUnlockLegend()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.meleeSkins.len() )
		return false

	if ( !GRX_IsInventoryReady() )
		return false


		return !Character_IsCharacterOwnedByPlayer(GetTopLevelCustomizeContext() ) && !NPP_ShouldDisableGRXForNPPLegend( GetLocalClientPlayer(), GetTopLevelCustomizeContext() )



}

bool function CanCustomizeFocused()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.meleeSkins.len() )
		return false

	if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ file.focusedIndex ] ) )
		return false

	return true
}

bool function CanZoomMeleeItem()
{
	string meleePath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] )
	if ( !RTKDataModel_HasDataModel( meleePath ) )
		return false

	rtk_struct meleeStruct = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )

	return !( RTKStruct_GetString( meleeStruct, "videoPreview" ) != "" || RTKStruct_GetBool( meleeStruct, "isDefault" ) )
}

void function OnMeleeSkinChanged( EHI playerEHI, ItemFlavor flavor )
{
	if ( IsConnected() && IsLobby() && IsLocalClientEHIValid() && IsTopLevelCustomizeContextValid() )
	{
		RefreshList()
		UpdateHeirloomShards()
	}
}

void function UpdateHeirloomShards()
{
	string meleePath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] )
	if ( !RTKDataModel_HasDataModel( meleePath ) )
		return

	
	rtk_struct meleeStruct = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )
	RTKStruct_SetInt( meleeStruct, "heirloomShards", GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ) )
}

array<ItemFlavor> function GetSelectableMeleeSkins()
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	LoadoutEntry entry = Loadout_MeleeSkin( character )

	EHI playerEHI = LocalClientEHI()
	array<ItemFlavor> allMeleeSkins = clone GetValidItemFlavorsForLoadoutSlot( entry )

	
	array<ItemFlavor> availableHeirlooms
	array<GRXScriptOffer> offers = GRX_GetLocationOffers( "heirloom_set_shop" )
	foreach ( offerIndex, offer in offers )
		availableHeirlooms.append( ItemFlavorBag_GetMeleeSkinItem( offer.output ) )

	
	array<ItemFlavor> selectableMeleeSkins
	foreach ( ItemFlavor meleeSkin in allMeleeSkins )
	{
		
		if ( !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, meleeSkin ) && !MeleeSkin_IsRewardForActiveEvent( meleeSkin ) )
		{
			
			if ( MeleeSkin_ShouldHideIfLocked( meleeSkin ) )
				continue

			
			bool isHeirloom = ( GetItemFlavorAssociatedCharacterOrWeapon( meleeSkin ) != null )
			if ( isHeirloom && !availableHeirlooms.contains( meleeSkin ) )
				continue
		}

		selectableMeleeSkins.append( meleeSkin )
	}

	
	ItemFlavor equippedItem = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ) )
	selectableMeleeSkins.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedItem ) {
		
		bool aIsEquipped = ( equippedItem == a )
		bool bIsEquipped = ( equippedItem == b )
		if ( aIsEquipped && !bIsEquipped )
			return -1
		else if ( bIsEquipped && !aIsEquipped )
			return 1

		
		int aQuality = ItemFlavor_HasQuality( a ) ? ItemFlavor_GetQuality( a ) : -1
		int bQuality = ItemFlavor_HasQuality( b ) ? ItemFlavor_GetQuality( b ) : -1
		if ( aQuality > bQuality )
			return -1
		else if ( aQuality < bQuality )
			return 1

		
		string aTag = string(ItemFlavor_GetSourceIcon( a ))
		string bTag = string(ItemFlavor_GetSourceIcon( b ))
		if ( aTag > bTag )
			return -1
		else if ( aTag < bTag )
			return 1

		
		int aConfigIndex = Artifacts_Loadouts_IsConfigPointerItemFlavor( a ) ? Artifacts_Loadouts_GetConfigIndex( a ) : -1
		int bConfigIndex = Artifacts_Loadouts_IsConfigPointerItemFlavor( b ) ? Artifacts_Loadouts_GetConfigIndex( b ) : -1

		if ( aConfigIndex < bConfigIndex )
			return -1
		else if ( aConfigIndex > bConfigIndex )
			return 1

		
		return SortStringAlphabetize( Localize( ItemFlavor_GetLongName( a ) ), Localize( ItemFlavor_GetLongName( b ) ) )
	} )

	return selectableMeleeSkins
}

void function RefreshList()
{
	if ( !file.isVisible )
		return

	string meleePath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] )
	if ( !RTKDataModel_HasDataModel( meleePath ) )
		return

	ItemFlavor equippedSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ) )

	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )
	rtk_array listItems = RTKStruct_GetArray( rtkModel, "listItems" )
	int listItemCount = RTKArray_GetCount( listItems )
	int ownedCount = 0
	for ( int i = 0; i < listItemCount && i < file.meleeSkins.len(); i++ )
	{
		rtk_struct entry = RTKArray_GetStruct( listItems, i )
		bool isEquipped = file.meleeSkins[ i ] == equippedSkin
		RTKStruct_SetBool( entry, "equipped", isEquipped )


		if ( UniversalMelee_IsItemFlavorUniversalMelee( file.meleeSkins[ i ] ) )
		{
			RTKStruct_SetBool( entry, "hasUpgrades", UniversalMelee_GetAddons( file.meleeSkins[ i ] ).len() > 0 )
		}


		bool locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ i ] )
		RTKStruct_SetBool( entry, "locked", locked )
		if ( !locked )
			ownedCount++

		bool isSelected = i == file.previewIndex
		
		if ( isSelected )
			RTKStruct_SetStruct( rtkModel, "previewItem", entry )

		int state = RTKStruct_GetInt( entry, "state" )

		if ( locked )
		{
			state = eMeleeItemState.LOCKED
		}
		else if ( isEquipped && isSelected )
		{
			state = eMeleeItemState.SELECTED_AND_EQUIPPED
		}
		else if ( isEquipped )
		{
			state = eMeleeItemState.EQUIPPED
		}
		else
		{
			state = eMeleeItemState.AVAILABLE
		}

		RTKStruct_SetInt( entry, "state", state )
	}

	RTKStruct_SetString( rtkModel, "listHeader", Localize( "#OWNED_COLLECTED", ownedCount, listItemCount ) )

	UpdateFooterOptions()
}

void function PreviewItem( int index, bool playFX )
{
	if ( index < 0 || index >= file.meleeSkins.len() )
		return

	if ( !CanRunClientScript() )
		return

	file.previewIndex = index

	string meleePath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] )
	if ( !RTKDataModel_HasDataModel( meleePath ) )
		return

	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )

	ItemFlavor defaultMeleeSkin = GetDefaultItemFlavorForLoadoutSlot( Loadout_MeleeSkin( GetTopLevelCustomizeContext() ) )
	if ( file.meleeSkins[ index ] == defaultMeleeSkin )
	{
		RTKStruct_SetBool( rtkModel, "isDefault", true )
		RTKStruct_SetString( rtkModel, "videoPreview", "" )
		RunClientScript( "UIToClient_ClearMeleeSkinPreview" )
	}
	else if ( IsItemFlavorStructValid( file.meleeSkins[ index ].guid, eValidation.DONT_ASSERT ) )
	{
		RTKStruct_SetBool( rtkModel, "isDefault", false )
		RTKStruct_SetString( rtkModel, "videoPreview", "" )
		if ( Artifacts_Loadouts_IsConfigPointerItemFlavor( file.meleeSkins[ index ] ) )
		{
			Artifacts_Loadouts_CheckAndFixMisconfigurations( LocalClientEHI(), GetTopLevelCustomizeContext() )
			RunClientScript("Artifacts_StoreLoadoutDataOnPlayerEntityStruct", null, null, false )

			array< ItemFlavor > equippedItems = Artifacts_GetEquippedSet( file.meleeSkins[ index ] )
			foreach ( ItemFlavor item in equippedItems )
			{
				RunClientScript( "Artifacts_Loadouts_StorePreviewDataOnPlayerEntityStruct", item.guid )
			}
		}
		RunClientScript( "UIToClient_PreviewMeleeSkin", ItemFlavor_GetGUID( file.meleeSkins[ index ] ) )
	}

	
	rtk_array listItems = RTKStruct_GetArray( rtkModel, "listItems" )
	int listItemCount = RTKArray_GetCount( listItems )
	for ( int i = 0; i < listItemCount; i++ )
	{
		bool selected = ( i == index )

		rtk_struct entry = RTKArray_GetStruct( listItems, i )
		RTKStruct_SetBool( entry, "selected", selected )
		if ( selected )
			RTKStruct_SetStruct( rtkModel, "previewItem", entry )
	}

	ItemFlavor equippedDeathbox = Deathbox_GetEquipped( GetTopLevelCustomizeContext(), file.meleeSkins[ index ] )
	RTKStruct_SetAssetPath( rtkModel, "deathboxImage", ItemFlavor_GetIcon( equippedDeathbox ) )
	RTKStruct_SetString( rtkModel, "deathboxName", ItemFlavor_GetLongName( equippedDeathbox ) )

	
	rtk_array equippedToLegendIcons = RTKStruct_GetArray( rtkModel, "equippedToLegendIcons" )
	FillLegendMeleeEquippedIcons( equippedToLegendIcons, file.meleeSkins[ index ] )

	RTKLegendMeleeScreen_SetEquippedItems()
}

void function UpgradeItem( int index )
{

	if ( index < 0 || index >= file.meleeSkins.len() )
		return

	ItemFlavor meleeItem = file.meleeSkins[ index ]
	if ( UniversalMelee_IsItemFlavorUniversalMelee( meleeItem ) )
	{
		array< ItemFlavor > addons = UniversalMelee_GetAddons( meleeItem )

		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( addons[ 0 ], "universal_set_shop" )

		foreach ( offerIndex, offer in offers )
		{
			UniversalMeleeInspectMenu_AttemptOpenWithOffer( offer )
			EmitUISound( "ui_menu_accept" )
		}
	}

}

bool function EquipItem( int index )
{
	if ( index < 0 || index >= file.meleeSkins.len() )
		return false

	ItemFlavor character = GetTopLevelCustomizeContext()
	LoadoutEntry entry = Loadout_MeleeSkin( character )
	EHI playerEHI = LocalClientEHI()

	
	ItemFlavor meleeSkinToEquip = file.meleeSkins[ index ]
	ItemFlavor equippedSkin = LoadoutSlot_GetItemFlavor( playerEHI, entry )
	if ( meleeSkinToEquip == equippedSkin )
	{
		PreviewItem( index, false )
		EmitUISound( "UI_Menu_Banner_Preview" )
		return false
	}

	if ( !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, meleeSkinToEquip ) )
	{
		bool isConfigPointer = Artifacts_Loadouts_IsConfigPointerItemFlavor( meleeSkinToEquip )

		bool inspectOffer = false

		
		if ( isConfigPointer )
		{
			array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( Artifacts_GetSetItems( eArtifactSetIndex.MOB )[0], "artifact_set_shop" )
			foreach ( offerIndex, offer in offers )
			{
				foreach( flav in offer.output.flavors )
				{
					if ( Artifacts_IsBaseArtifact( flav ) )
					{
						ArtifactsInspectMenu_AttemptOpenWithOffer( offer )
						EmitUISound( "ui_menu_accept" )
						inspectOffer = true
						break
					}
				}
			}
		}
		else if ( UniversalMelee_IsItemFlavorUniversalMelee( meleeSkinToEquip ) )
		{
			array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( meleeSkinToEquip, "universal_set_shop" )

			foreach ( offerIndex, offer in offers )
			{
				UniversalMeleeInspectMenu_AttemptOpenWithOffer( offer )
				EmitUISound( "ui_menu_accept" )
				inspectOffer = true
				break
			}
		}
		else
		{
			array<GRXScriptOffer> offers = GRX_GetLocationOffers( "heirloom_set_shop" )
			foreach ( offerIndex, offer in offers )
			{
				ItemFlavor offerSkin = ItemFlavorBag_GetMeleeSkinItem( offer.output )
				if ( offerSkin == meleeSkinToEquip )
				{
					StoreInspectMenu_AttemptOpenWithOffer( offer )
					EmitUISound( "ui_menu_accept" )
					inspectOffer = true
					break
				}
			}

			if ( !inspectOffer )
			{
				
				if ( MeleeSkin_IsRewardForActiveEvent( meleeSkinToEquip ) )
				{
					EmitUISound( "ui_menu_accept" )

					EventsPanel_SetOpenPageIndex( MeleeSkin_IsRewardForActiveCollectionEvent(meleeSkinToEquip) ? eEventsPanelPage.COLLECTION_EVENT : eEventsPanelPage.COLLECTION )



					JumpToEventTab( "RTKEventsPanel" )
				}
				else
				{
					EmitUISound( "menu_deny" )
				}
			}
		}

		return false
	}

	PIN_Customization( character, meleeSkinToEquip, "equip" )
	RequestSetItemFlavorLoadoutSlot( playerEHI, entry, meleeSkinToEquip )

	EmitUISound( "UI_Menu_Equip_Generic" )

	return true
}

void function CustomizeItem( int index )
{
	if ( index < 0 || index >= file.meleeSkins.len() )
		return

	if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), file.meleeSkins[ index ] ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	file.customizeIndex = index

	var menu = GetMenu( "MeleeCustomizationMenu" )
	AdvanceMenu( menu )

	EmitUISound( "ui_menu_accept" )
}

void function EquipItemAtIndex( int index )
{
	if ( index < 0 )
		return

	bool equipSuccess = EquipItem( index )
	if ( equipSuccess )
		PreviewItem( index, true )
}

void function EquipFocusedItem( var button )
{
	EquipItemAtIndex( file.focusedIndex )
}

void function CustomizeFocusedItem( var button )
{
	CustomizeItem( file.focusedIndex )
}

ItemFlavor ornull function GetLegendMeleeCustomizeItem()
{
	if ( file.customizeIndex < 0 || file.customizeIndex >= file.meleeSkins.len() )
		return null

	return file.meleeSkins[ file.customizeIndex ]
}

void function OpenUnlockLegendDialog()
{
	ItemFlavor character = GetTopLevelCustomizeContext()

	PurchaseDialogConfig pdc
	pdc.flav = character
	pdc.quantity = 1
	pdc.onPurchaseResultCallback = void function( bool wasPurchaseSuccessful ) : ( character ) {
		if ( wasPurchaseSuccessful )
		{
			AddCallback_OnGRXInventoryStateChanged( UpdateMeleeWhenLegendUnlocked )
		}
	}

	PurchaseDialog( pdc )
}

void function UpdateMeleeWhenLegendUnlocked()
{
	JumpToCharacterCustomize( GetTopLevelCustomizeContext() )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateMeleeWhenLegendUnlocked )
}

void function FillLegendMeleeEquippedIcons( rtk_array equippedToLegendIcons, ItemFlavor selectedMeleeSkin )
{
	RTKArray_Clear( equippedToLegendIcons )

	
	if ( !Artifacts_Loadouts_IsConfigPointerItemFlavor( selectedMeleeSkin ) )
		return

	
	array<ItemFlavor> allCharacters = clone Loadout_Character().validItemFlavorList
	RemoveNonShippingCharacters( allCharacters )
	allCharacters.sort( int function( ItemFlavor a, ItemFlavor b ) : () {
		string characterRefA = ItemFlavor_GetGUIDString( a )
		int charAGames       = GetStat_Int( GetLocalClientPlayer(), ResolveStatEntry( CAREER_STATS.character_games_played, characterRefA ) )

		string characterRefB = ItemFlavor_GetGUIDString( b )
		int charBGames       = GetStat_Int( GetLocalClientPlayer(), ResolveStatEntry( CAREER_STATS.character_games_played, characterRefB ) )

		return charBGames - charAGames  
	} )

	
	foreach ( ItemFlavor character in allCharacters )
	{
		if ( !Character_IsCharacterOwnedByPlayer( character ) )
			continue

		if ( character.guid == GetTopLevelCustomizeContext().guid )
			continue

		if ( selectedMeleeSkin.guid == LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_MeleeSkin( character ) ).guid )
		{
			asset icon = ItemFlavor_GetIcon( character )
			RTKArray_PushAssetPath( equippedToLegendIcons, icon )
		}

		
		if ( RTKArray_GetCount( equippedToLegendIcons ) == 6 )
			break
	}
}

void function OnMeleeCustomizationClosed()
{
	if ( !file.isVisible )
		return

	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )

	if ( file.previewIndex >= 0 && file.previewIndex < file.meleeSkins.len() )
	{
		ItemFlavor equippedDeathbox = Deathbox_GetEquipped( GetTopLevelCustomizeContext(), file.meleeSkins[ file.previewIndex ] )
		RTKStruct_SetAssetPath( rtkModel, "deathboxImage", ItemFlavor_GetIcon( equippedDeathbox ) )
		RTKStruct_SetString( rtkModel, "deathboxName", ItemFlavor_GetLongName( equippedDeathbox ) )
	}

	PreviewItem( file.previewIndex, true )
}

void function RTKLegendMeleeScreen_SetEquippedItems()
{
	ItemFlavor previewItem = file.meleeSkins[ file.previewIndex ]

	array< ItemFlavor > equippedFlavs = []

	if ( Artifacts_Loadouts_IsConfigPointerItemFlavor( previewItem ) )
	{
		equippedFlavs = Artifacts_GetEquippedSet( previewItem )
	}
	else
	{
		equippedFlavs.push( Deathbox_GetEquipped( GetTopLevelCustomizeContext(), previewItem ) )
	}

	rtk_struct meleeStruct = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "melee", true, [ "legend" ] ) )
	rtk_struct equippedStruct = RTKStruct_GetStruct( meleeStruct, "equippedItems" )
	RTKStruct_SetBool( meleeStruct, "showEquippedItems", IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), previewItem ) )

	RTKMeleeCustomizationSetModel equippedItemsModel
	foreach ( int index, ItemFlavor component in equippedFlavs )
	{
		int type = Artifacts_GetComponentType( component )

		switch ( type )
		{
			case eArtifactComponentType.BLADE:
				equippedItemsModel.blade = GetMeleeCustomizationItemModel( component, type )
				equippedItemsModel.blade.state = eMeleeCustomizationItemState.SELECTED
				break

			case eArtifactComponentType.THEME:
				equippedItemsModel.theme = GetMeleeCustomizationItemModel( component, type )
				equippedItemsModel.theme.state = eMeleeCustomizationItemState.SELECTED
				break

			case eArtifactComponentType.POWER_SOURCE:
				equippedItemsModel.powerSource = GetMeleeCustomizationItemModel( component, type )
				equippedItemsModel.powerSource.state = eMeleeCustomizationItemState.SELECTED
				break

			case eArtifactComponentType.ACTIVATION_EMOTE:
				equippedItemsModel.activationEmote = GetMeleeCustomizationItemModel( component, type )
				equippedItemsModel.activationEmote.state = eMeleeCustomizationItemState.SELECTED
				break

			case eArtifactComponentType.DEATHBOX:
				equippedItemsModel.deathbox = GetMeleeCustomizationItemModel( component, type )
				equippedItemsModel.deathbox.state = eMeleeCustomizationItemState.SELECTED
				break
		}
	}
	RTKStruct_SetValue( equippedStruct, equippedItemsModel )


		rtk_array universalMeleeViewSet = RTKStruct_GetArray( meleeStruct, "addons" )
		RTKArray_Clear( universalMeleeViewSet )
		if ( UniversalMelee_IsItemFlavorUniversalMelee( previewItem ) && UniversalMelee_GetTheme( previewItem ) == eUniversalSetIndex.HOOK_SWORD )
		{
			
			rtk_struct baseItemStruct = RTKArray_PushNewStruct( universalMeleeViewSet )
			RTKMeleeCustomizationItemModel baseItemModel = GetUniversalMeleeCustomizationItemModel( UniversalMelee_GetBaseSkin( previewItem ) )
			RTKStruct_SetValue( baseItemStruct, baseItemModel )

			
			array<ItemFlavor> addonFlavs = UniversalMelee_GetAddons( previewItem )
			if ( addonFlavs.len() > 0 )
			{
				rtk_struct meleeAddonStruct = RTKArray_PushNewStruct( universalMeleeViewSet )
				RTKMeleeCustomizationItemModel addonModel = GetUniversalMeleeCustomizationItemModel( addonFlavs[0] )
				RTKStruct_SetValue( meleeAddonStruct, addonModel )
			}
		}

		RTKStruct_SetBool( meleeStruct, "showAddons", UniversalMelee_GetTheme( previewItem ) == eUniversalSetIndex.HOOK_SWORD )


	UpdateFooterOptions()
}


RTKMeleeCustomizationItemModel function GetUniversalMeleeCustomizationItemModel( ItemFlavor itemFlav )
{
	RTKMeleeCustomizationItemModel meleeItemModel
	meleeItemModel.name = Localize( ItemFlavor_GetLongName( itemFlav ) )
	meleeItemModel.description = Localize( ItemFlavor_GetLongDescription( itemFlav ) )
	meleeItemModel.setTheme = eArtifactSetIndex.HOOK_SWORD
	meleeItemModel.mainColor = UniversalMelee_GetComponentMainColor( itemFlav )
	meleeItemModel.secondaryColor = UniversalMelee_GetComponentSecondaryColor( itemFlav )
	meleeItemModel.guid = ItemFlavor_GetGUID( itemFlav )
	meleeItemModel.icon = ItemFlavor_GetIcon( itemFlav )
	meleeItemModel.isVisible = IsValidItemFlavorGUID( itemFlav.guid )
	meleeItemModel.locked = !GRX_IsItemOwnedByPlayer( itemFlav )
	meleeItemModel.state = meleeItemModel.locked ? eMeleeCustomizationItemState.LOCKED : eMeleeCustomizationItemState.SELECTED

	return meleeItemModel
}


bool function RTKMutator_ShowMeleeItemUpgradeButton( bool hasUpgrades )
{
	if ( hasUpgrades )
	{
		ItemFlavor baseSkin = UniversalMelee_GetBaseSkin( file.meleeSkins[ file.previewIndex ] )
		if ( !GRX_IsItemOwnedByPlayer( baseSkin ) )
			return false

		array<ItemFlavor> addons = UniversalMelee_GetAddons( file.meleeSkins[ file.previewIndex ] )
		foreach ( addon in addons )
		{
			if ( !GRX_IsItemOwnedByPlayer( addon ) )
				return true
		}
	}

	return false
}