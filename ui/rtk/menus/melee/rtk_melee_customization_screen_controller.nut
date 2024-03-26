global function RTKMeleeCustomizationScreen_InitMetaData
global function RTKMeleeCustomizationScreen_OnInitialize
global function RTKMeleeCustomizationScreen_OnDestroy

global function InitMeleeCustomizationMenu
global function InitMeleeCustomizationPanel
global function MeleeCustomizationScreen_ClientToUI_UpdateDeathboxEquipState

global struct RTKMeleeCustomizationScreen_Properties
{
	rtk_behavior equipButton

	rtk_panel deathboxList

	rtk_panel bladeList
	rtk_panel powerSourceList
	rtk_panel themeList

}

global struct MeleeCustomizationItemModel
{
	string name
	int quality
	asset eventIcon
	bool equipped
	bool locked
	bool selected
	string actionText
}

global struct MeleeCustomizationModel
{
	MeleeCustomizationItemModel& previewItem
	string videoAsset

	array<MeleeCustomizationItemModel> listDeathboxes

	array<MeleeCustomizationItemModel> listBlades
	array<MeleeCustomizationItemModel> listPowerSources
	array<MeleeCustomizationItemModel> listThemes

}

struct
{
	bool isVisible = false
	array<ItemFlavor> deathboxSkins = []


	array<ItemFlavor> powerSources = []
	array<ItemFlavor> blades = []
	array<ItemFlavor> themes = []


	int focusedIndex = -1
	int previewIndex = -1
} file

struct PrivateData
{
	int menuGUID = -1
}


const int ARTIFACT_CONFIG_BASE = 0 


void function RTKMeleeCustomizationScreen_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorIsRuiBehavior( behaviorType, true )
}

void function RTKMeleeCustomizationScreen_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )











		MeleeCustomizationScreen_OnInitialize( self )


	
	int menuGUID = AssignMenuGUID()
	p.menuGUID = menuGUID
	RTKFooters_Add( menuGUID, LEFT, BUTTON_B, "#B_BUTTON_BACK", BUTTON_INVALID, "#B_BUTTON_BACK", ExitCustomization )

	if ( !IsCustomizingArtifactConfiguration() )

	{
		RTKFooters_Add( menuGUID, LEFT, BUTTON_X, "#X_BUTTON_EVENT_SHOP", BUTTON_INVALID, "#X_BUTTON_EVENT_SHOP", EquipFocusedDeathbox, CanUnlockFocusedEventShop )
	}
	RTKFooters_Add( menuGUID, LEFT, BUTTON_X, "#X_BUTTON_SELECT", BUTTON_INVALID, "#X_BUTTON_SELECT", EquipFocusedDeathbox, CanEquipFocusedDeathbox )
	RTKFooters_Update()

	file.isVisible = true

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "meleeCustomization", true, ["legend"] ) )
}

void function RTKMeleeCustomizationScreen_OnDestroy( rtk_behavior self )
{
	file.isVisible = false

	PrivateData p
	self.Private( p )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", ["legend"] )

	file.deathboxSkins.clear()

	file.blades.clear()
	file.powerSources.clear()


	RTKFooters_RemoveAll( p.menuGUID )
	RTKFooters_Update()
}

void function MeleeCustomizationScreen_OnInitialize( rtk_behavior self )
{
	
	file.deathboxSkins = GetSelectableDeathboxSkins()

	
	rtk_struct rtkModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", "MeleeCustomizationModel", ["legend"] )
	rtk_array listItems = RTKStruct_GetArray( rtkModel, "listDeathboxes" )
	foreach (int index, ItemFlavor itemFlav in file.deathboxSkins)
	{
		rtk_struct listItemEntry = RTKArray_PushNewStruct( listItems )

		MeleeCustomizationItemModel listItem
		listItem.name = Localize( ItemFlavor_GetLongName( itemFlav ) )
		listItem.quality = ItemFlavor_GetQuality( itemFlav )
		listItem.eventIcon = ItemFlavor_GetSourceIcon( itemFlav )
		listItem.equipped = IsDeathboxEquipped( itemFlav )
		listItem.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), itemFlav )
		listItem.selected = false

		if ( !listItem.locked )
			listItem.actionText = "#SELECT"
		else
			listItem.actionText = IsRewardForActiveEvent( itemFlav ) ? "#MENU_STORE_PANEL_EVENT_SHOP" : "#UNLOCK"

		RTKStruct_SetValue( listItemEntry, listItem )
	}

	
	PreviewDeathbox( 0 )

	
	rtk_panel ornull itemList = self.PropGetPanel( "deathboxList" )
	if ( itemList != null )
	{
		expect rtk_panel( itemList )
		self.AutoSubscribe( itemList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ){
			array< rtk_behavior > itemListButtons = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in itemListButtons )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
					if ( keycode == MOUSE_RIGHT )
						EquipDeathboxToCharacter( newChildIndex )
					else
						EmitUISound( "UI_Menu_Banner_Preview" )

					PreviewDeathbox( newChildIndex )
				} )

				self.AutoSubscribe( button, "onDoublePressed", function( rtk_behavior button, int keycode ) : ( self, newChildIndex ) {
					if ( keycode == MOUSE_LEFT )
						EquipDeathboxToCharacter( newChildIndex )
				} )

				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex ) {
					file.focusedIndex = newChildIndex
					RTKFooters_Update()
				} )

				self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
					file.focusedIndex = -1
					RTKFooters_Update()
				} )
			}
		} )
	}

	
	rtk_behavior ornull equipButton = self.PropGetBehavior( "equipButton" )
	if ( equipButton != null )
	{
		expect rtk_behavior( equipButton )
		self.AutoSubscribe( equipButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			EquipDeathboxAtIndex( file.previewIndex )
		} )
	}
}


void function ArtifactConfigurationCustomizationScreen_OnInitialize( rtk_behavior self )
{
	Artifacts_Loadouts_CheckAndFixMisconfigurations( LocalClientEHI(), GetTopLevelCustomizeContext() )

	rtk_struct rtkModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", "MeleeCustomizationModel", ["legend"] )

	file.blades 	   = GetSelectableArtifactComponentsOfType( eArtifactComponentType.BLADE )
	file.powerSources  = GetSelectableArtifactComponentsOfType( eArtifactComponentType.POWER_SOURCE )
	file.themes		   = GetSelectableArtifactComponentsOfType( eArtifactComponentType.THEME )
	file.deathboxSkins = GetSelectableDeathboxSkins()

	LoadoutEntry loadoutSlot

	
	rtk_array listBlades = RTKStruct_GetArray( rtkModel, "listBlades" )
	loadoutSlot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( ARTIFACT_CONFIG_BASE, eArtifactComponentType.BLADE )
	foreach ( int index, ItemFlavor blade in file.blades )
	{
		Assert( !Artifacts_IsEmptyComponent( blade ) )

		rtk_struct listItemEntry = RTKArray_PushNewStruct( listBlades )

		MeleeCustomizationItemModel listItem
		listItem.name = "Blade - " + Localize( Artifacts_GetSetNameLocalized( blade ) )
		listItem.quality = ItemFlavor_HasQuality( blade ) ? ItemFlavor_GetQuality( blade ) : 0
		listItem.eventIcon = ItemFlavor_GetSourceIcon( blade )
		listItem.equipped = IsComponentEquipped( blade )
		listItem.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), loadoutSlot, blade )
		listItem.selected = false

		RTKStruct_SetValue( listItemEntry, listItem )
	}

	rtk_panel ornull itemList = self.PropGetPanel( "bladeList" )
	SubscribeToEvents( self, itemList, eArtifactComponentType.BLADE )

	
	rtk_array listThemes = RTKStruct_GetArray( rtkModel, "listThemes" )
	loadoutSlot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( ARTIFACT_CONFIG_BASE, eArtifactComponentType.THEME )
	foreach ( int index, ItemFlavor theme in file.themes )
	{
		rtk_struct listItemEntry = RTKArray_PushNewStruct( listThemes )

		MeleeCustomizationItemModel listItem
		listItem.name = "Theme - " + Localize( Artifacts_GetSetNameLocalized( theme ) )
		listItem.quality = ItemFlavor_HasQuality( theme ) ? ItemFlavor_GetQuality( theme ) : 0
		listItem.eventIcon = ItemFlavor_GetSourceIcon( theme )
		listItem.equipped = IsComponentEquipped( theme )
		listItem.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), loadoutSlot, theme )
		listItem.selected = false

		RTKStruct_SetValue( listItemEntry, listItem )
	}

	itemList = self.PropGetPanel( "themeList" )
	SubscribeToEvents( self, itemList, eArtifactComponentType.THEME )

	
	rtk_array listPowerSources = RTKStruct_GetArray( rtkModel, "listPowerSources" )
	loadoutSlot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( ARTIFACT_CONFIG_BASE, eArtifactComponentType.POWER_SOURCE )
	foreach ( int index, ItemFlavor powerSource in file.powerSources ) 
	{
		rtk_struct listItemEntry = RTKArray_PushNewStruct( listPowerSources )

		MeleeCustomizationItemModel listItem
		listItem.name = "Power Source - " + Localize( Artifacts_GetSetNameLocalized( powerSource ) )
		listItem.quality = ItemFlavor_HasQuality( powerSource ) ? ItemFlavor_GetQuality( powerSource ) : 0
		listItem.eventIcon = ItemFlavor_GetSourceIcon( powerSource )
		listItem.equipped = IsComponentEquipped( powerSource )
		listItem.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), loadoutSlot, powerSource )
		listItem.selected = false

		RTKStruct_SetValue( listItemEntry, listItem )
	}

	itemList = self.PropGetPanel( "powerSourceList" )
	SubscribeToEvents( self, itemList, eArtifactComponentType.POWER_SOURCE )

	
	rtk_array listDeathboxes = RTKStruct_GetArray( rtkModel, "listDeathboxes" )
	loadoutSlot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( ARTIFACT_CONFIG_BASE, eArtifactComponentType.DEATHBOX )
	foreach ( int index, ItemFlavor deathbox in file.deathboxSkins ) 
	{
		rtk_struct listItemEntry = RTKArray_PushNewStruct( listDeathboxes )

		MeleeCustomizationItemModel listItem
		listItem.name = ItemFlavor_GetLongName( deathbox ) != "" ? Localize( ItemFlavor_GetLongName( deathbox ) ) : "Deathbox - " + Localize( Artifacts_GetSetNameLocalized( deathbox ) )
		listItem.quality = ItemFlavor_HasQuality( deathbox ) ? ItemFlavor_GetQuality( deathbox ) : 0
		listItem.eventIcon = ItemFlavor_GetSourceIcon( deathbox )
		listItem.equipped = IsComponentEquipped( deathbox )
		listItem.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), loadoutSlot, deathbox )
		listItem.selected = false

		RTKStruct_SetValue( listItemEntry, listItem )
	}

	itemList = self.PropGetPanel( "deathboxList" )
	SubscribeToEvents( self, itemList, eArtifactComponentType.DEATHBOX )
}


bool function CanUnlockFocusedDeathbox()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.deathboxSkins.len() )
		return false

	return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), file.deathboxSkins[ file.focusedIndex ] ) && !IsRewardForActiveEvent( file.deathboxSkins[ file.focusedIndex ] )
}

bool function CanEquipFocusedDeathbox()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.deathboxSkins.len() )
		return false

	if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), file.deathboxSkins[ file.focusedIndex ] ) )
		return false

	return !IsDeathboxEquipped( file.deathboxSkins[ file.focusedIndex ] )
}

bool function CanUnlockFocusedEventShop()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.deathboxSkins.len() )
		return false

	return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), file.deathboxSkins[ file.focusedIndex ] ) && IsRewardForActiveEvent( file.deathboxSkins[ file.focusedIndex ] )
}

void function InitMeleeCustomizationMenu( var menu )
{
	SetDialog( menu, true )
	SetClearBlur( menu, false )
}

void function InitMeleeCustomizationPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, MeleeCustomizationPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, MeleeCustomizationPanel_OnHide )
}

void function MeleeCustomizationPanel_OnShow( var panel )
{

		if ( IsCustomizingArtifactConfiguration() )
		{
			EHI lcEHI = LocalClientEHI()
			LoadoutEntry slot
			for ( int i = 0; i < eArtifactComponentType.COUNT; i++ )
			{
				int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
				slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, i )
				AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( lcEHI, slot, ArtifactComponentLoadoutChangeCallback )
			}
		}


	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
}

void function MeleeCustomizationPanel_OnHide( var panel )
{

		if ( IsCustomizingArtifactConfiguration() )
		{
			EHI lcEHI = LocalClientEHI()
			LoadoutEntry slot
			for ( int i = 0; i < eArtifactComponentType.COUNT; i++ )
			{
				int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
				slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, i )
				RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( lcEHI, slot, ArtifactComponentLoadoutChangeCallback )
			}
		}


	OnMeleeCustomizationClosed()
}

array<ItemFlavor> function GetSelectableDeathboxSkins()
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	LoadoutEntry entry = Loadout_Deathbox( character )


	if ( IsCustomizingArtifactConfiguration() )
	{
		int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
		entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, eArtifactComponentType.DEATHBOX )
	}


	EHI playerEHI = LocalClientEHI()
	array<ItemFlavor> allDeathboxSkins = clone GetValidItemFlavorsForLoadoutSlot( playerEHI, entry )

	array<ItemFlavor> selectableDeathboxSkins
	foreach ( ItemFlavor deathboxSkin in allDeathboxSkins )
	{
		if ( ItemFlavor_GetGRXMode( deathboxSkin ) == eItemFlavorGRXMode.NONE && deathboxSkin != Deathbox_GetDefaultItemFlavor() )
			continue

		bool shouldHideIfLocked = MeleeCustomization_ShouldHideIfLocked( deathboxSkin )
		bool isLocked = !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, deathboxSkin )
		bool isActiveEventReward = IsRewardForActiveEvent( deathboxSkin )

		
		if ( isLocked && (shouldHideIfLocked || !isActiveEventReward ) )
			continue

		selectableDeathboxSkins.append( deathboxSkin )
	}

	
	selectableDeathboxSkins.sort( int function( ItemFlavor a, ItemFlavor b ) : () {
		
		bool aIsEquipped = IsDeathboxEquipped( a )
		bool bIsEquipped = IsDeathboxEquipped( b )
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

		
		return SortStringAlphabetize( Localize( ItemFlavor_GetLongName( a ) ), Localize( ItemFlavor_GetLongName( b ) ) )
	} )

	return selectableDeathboxSkins
}

bool function IsRewardForActiveEvent( ItemFlavor item )
{
	if ( ItemFlavor_GetGRXMode( item ) == eItemFlavorGRXMode.NONE )
		return false

	ItemFlavor ornull activeEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
	if ( activeEvent != null )
	{
		expect ItemFlavor( activeEvent )
		return MilestoneEvent_IsMilestoneGrantReward( activeEvent, ItemFlavor_GetGRXIndex( item ) )
	}

	return false
}

void function PreviewDeathbox( int index )
{
	if ( index < 0 || index >= file.deathboxSkins.len() )
		return

	file.previewIndex = index

	asset videoAsset = GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( file.deathboxSkins[ index ] ), "video" )
	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", true, [ "legend" ] ) )
	RTKStruct_SetString( rtkModel, "videoAsset", string( videoAsset ) )

	
	rtk_array listItems = RTKStruct_GetArray( rtkModel, "listDeathboxes" )
	int listItemCount = RTKArray_GetCount( listItems )
	for ( int i = 0; i < listItemCount; i++ )
	{
		bool selected = ( i == index )

		rtk_struct entry = RTKArray_GetStruct( listItems, i )
		RTKStruct_SetBool( entry, "selected", selected )
		if ( selected )
			RTKStruct_SetStruct( rtkModel, "previewItem", entry )
	}
}

bool function EquipDeathboxToCharacter( int index )
{
	if ( index < 0 || index >= file.deathboxSkins.len() )
		return false

	ItemFlavor character = GetTopLevelCustomizeContext()
	LoadoutEntry entry = Loadout_Deathbox( character )
	EHI playerEHI = LocalClientEHI()

	if ( !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, file.deathboxSkins[ index ] ) )
	{
		
		if ( IsRewardForActiveEvent( file.deathboxSkins[ index ] ) )
		{
			EmitUISound( "ui_menu_accept" )
			EventsPanel_SetOpenPageIndex( eEventsPanelPage.MILESTONES )
			JumpToEventTab( "RTKEventsPanel" )
		}
		else
		{
			EmitUISound( "menu_deny" )
		}

		return false
	}

	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return false

	expect ItemFlavor( selectedMeleeSkin )

	if ( IsDeathboxEquipped( file.deathboxSkins[ index ] ) )
	{
		EmitUISound( "UI_Menu_Banner_Preview" )
		return false
	}

	PIN_Customization( character, selectedMeleeSkin, "deathbox_equip" )
	RequestSetDeathboxEquipForMeleeSkin( playerEHI, Loadout_MeleeSkin( character ), selectedMeleeSkin, file.deathboxSkins[ index ] )

	EmitUISound( "UI_Menu_Equip_Generic" )

	return true
}

void function EquipDeathboxAtIndex( int index )
{
	if ( index < 0 )
		return

	EquipDeathboxToCharacter( index )
}

void function EquipFocusedDeathbox( var unused )
{
	EquipDeathboxAtIndex( file.focusedIndex )
}

void function ExitCustomization( var unused )
{
	UICodeCallback_NavigateBack()
}

bool function IsDeathboxEquipped( ItemFlavor deathbox )
{
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return false

	return Deathbox_GetEquipped( GetTopLevelCustomizeContext(), expect ItemFlavor( selectedMeleeSkin ) ) == deathbox
}

void function MeleeCustomizationScreen_ClientToUI_UpdateDeathboxEquipState( int characterGUID, int meleeSkinGUID, int deathboxGUID )
{
	if ( !file.isVisible )
		return

	ItemFlavor character = GetItemFlavorByGUID( characterGUID )
	ItemFlavor meleeSkin = GetItemFlavorByGUID( meleeSkinGUID )
	ItemFlavor deathbox  = GetItemFlavorByGUID( deathboxGUID )

	if ( GetTopLevelCustomizeContext() != character )
		return

	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null || expect ItemFlavor( selectedMeleeSkin ) != meleeSkin )
		return

	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", true, [ "legend" ] ) )
	rtk_array listItems = RTKStruct_GetArray( rtkModel, "listDeathboxes" )
	int listItemCount = RTKArray_GetCount( listItems )
	for ( int i = 0; i < listItemCount && i < file.deathboxSkins.len(); i++ )
	{
		rtk_struct entry = RTKArray_GetStruct( listItems, i )
		RTKStruct_SetBool( entry, "equipped", file.deathboxSkins[ i ] == deathbox )
		RTKStruct_SetBool( entry, "locked", !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( character ), file.deathboxSkins[ i ] ) )

		
		if ( i == file.previewIndex )
			RTKStruct_SetStruct( rtkModel, "previewItem", entry )
	}

	RTKFooters_Update()
}


void function ArtifactComponentLoadoutChangeCallback( EHI playerEHI, ItemFlavor flavor )
{
	if ( !file.isVisible || !IsCustomizingArtifactConfiguration() )
		return

	rtk_struct rtkModel = expect rtk_struct( RTKDataModelType_GetStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", true, [ "legend" ] ) )

	rtk_array listItems
	array<ItemFlavor> itemFlavorList
	int type = Artifacts_GetComponentType( flavor )
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )
	switch( type )
	{
		case eArtifactComponentType.DEATHBOX:
			listItems = RTKStruct_GetArray( rtkModel, "listDeathboxes" )
			itemFlavorList = file.deathboxSkins
			break

		case eArtifactComponentType.BLADE:
			listItems = RTKStruct_GetArray( rtkModel, "listBlades" )
			itemFlavorList = file.blades
			break

		case eArtifactComponentType.POWER_SOURCE:
			listItems = RTKStruct_GetArray( rtkModel, "listPowerSources" )
			itemFlavorList = file.powerSources
			break

		case eArtifactComponentType.THEME:
			listItems = RTKStruct_GetArray( rtkModel, "listThemes" )
			itemFlavorList = file.themes
			break

		default:
			return
	}

	int listItemCount = RTKArray_GetCount( listItems )
	for ( int i = 0; i < listItemCount && i < itemFlavorList.len(); i++ )
	{
		rtk_struct entry = RTKArray_GetStruct( listItems, i )
		RTKStruct_SetBool( entry, "equipped", IsComponentEquipped( itemFlavorList[ i ] ) )
		RTKStruct_SetBool( entry, "locked", !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), slot, itemFlavorList[ i ] ) )
	}

	if ( CanRunClientScript() )
	{
		ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
		if ( selectedMeleeSkin != null )
		{
			expect ItemFlavor( selectedMeleeSkin )
			RunClientScript( "UIToClient_PreviewMeleeSkin", ItemFlavor_GetGUID( selectedMeleeSkin ) )
		}
	}

	RTKFooters_Update()
}

void function SubscribeToEvents( rtk_behavior self, rtk_panel ornull itemList, int type )
{
	bool functionref( int ) func
	if ( type == eArtifactComponentType.DEATHBOX )
		func = EquipArtifactComponent_Deathbox
	else if ( type == eArtifactComponentType.BLADE )
		func = EquipArtifactComponent_Blade
	else if ( type == eArtifactComponentType.POWER_SOURCE )
		func = EquipArtifactComponent_PowerSource
	else if ( type == eArtifactComponentType.THEME )
		func = EquipArtifactComponent_Theme
	else
		return

	if ( itemList != null )
	{
		expect rtk_panel( itemList )
		self.AutoSubscribe( itemList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, func ) {
			array< rtk_behavior > itemListButtons = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in itemListButtons )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, func ) {
					func( newChildIndex )
				} )

				self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newChildIndex ) {
					file.focusedIndex = newChildIndex
					RTKFooters_Update()
				} )

				self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
					file.focusedIndex = -1
					RTKFooters_Update()
				} )
			}
		} )
	}
}

bool function EquipArtifactComponent_Deathbox( int index )
{
	if ( index < 0 || index >= file.deathboxSkins.len() )
		return false

	return EquipArtifactComponent_Internal( file.deathboxSkins[ index ] )
}

bool function EquipArtifactComponent_PowerSource( int index )
{
	if ( index < 0 || index >= file.powerSources.len() )
		return false

	return EquipArtifactComponent_Internal( file.powerSources[ index ] )
}

bool function EquipArtifactComponent_Blade( int index )
{
	if ( index < 0 || index >= file.blades.len() )
		return false

	return EquipArtifactComponent_Internal( file.blades[ index ] )
}

bool function EquipArtifactComponent_Theme( int index )
{
	if ( index < 0 || index >= file.themes.len() )
		return false

	return EquipArtifactComponent_Internal( file.themes[ index ] )
}

bool function EquipArtifactComponent_Internal( ItemFlavor component )
{
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, Artifacts_GetComponentType( component ) )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), slot, component )

	return true
}

bool function IsCustomizingArtifactConfiguration()
{
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return false

	expect ItemFlavor( selectedMeleeSkin )
	return Artifacts_Loadouts_IsConfigPointerItemFlavor( selectedMeleeSkin )
}

bool function IsComponentEquipped( ItemFlavor component )
{
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, Artifacts_GetComponentType( component ) )

	return ( component == LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) )
}

array<ItemFlavor> function GetSelectableArtifactComponentsOfType( int type )
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )

	EHI playerEHI = LocalClientEHI()
	array<ItemFlavor> allComponents = clone GetValidItemFlavorsForLoadoutSlot( playerEHI, entry )

	array<ItemFlavor> selectableComponents
	foreach ( ItemFlavor component in allComponents )
	{
		if ( Artifacts_IsEmptyComponent( component ) && Artifacts_GetComponentType( component ) == eArtifactComponentType.BLADE )
			continue 

		
		if ( !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, component ) ) 
			continue

		selectableComponents.append( component )
	}

	return selectableComponents
}

