global function RTKMeleeCustomizationScreen_OnInitialize
global function RTKMeleeCustomizationScreen_OnDestroy
global function InitMeleeCustomizationMenu
global function InitMeleeCustomizationPanel
global function MeleeCustomizationScreen_ClientToUI_UpdateDeathboxEquipState
global function GetMeleeCustomizationItemModel
global function RTKMutator_ShowCustomizationItem
global function RTKMutator_ShowOnlyArtifactSet
global function RTKMutator_HideEmptyActivationEmote
global function RTKMutator_CelestialOutline

global enum eMeleeCustomizationItemState
{
	LOCKED,
	AVAILABLE,
	SELECTED,
	EQUIPPED,
	SELECTED_AND_EQUIPPED,
	SELECTED_AND_LOCKED,
	_COUNT,
}

global enum eMeleeCustomizationTab
{
	SETS,
	BLADE,
	THEME,
	POWER_SOURCE,
	DEATHBOX,
	_COUNT,
}

global struct RTKMeleeCustomizationScreen_Properties
{
	rtk_behavior actionButton
	rtk_panel sets
}

global struct RTKMeleeCustomizationItemModel
{
	SettingsAssetGUID guid
	string name
	string description
	int setTheme
	int type
	int state
	asset icon
	bool equipped
	bool locked
	bool selected
	vector mainColor
	vector secondaryColor
	bool isEmpty
	bool isVisible
}

global struct RTKMeleeCustomizationSetModel
{
	string title
	int setTheme
	RTKMeleeCustomizationItemModel& blade
	RTKMeleeCustomizationItemModel& theme
	RTKMeleeCustomizationItemModel& powerSource
	RTKMeleeCustomizationItemModel& activationEmote
	RTKMeleeCustomizationItemModel& deathbox
}

global struct RTKMeleeCustomizationVideoModel
{
	string title
	string description
	string assetPath
}

global struct RTKMeleeCustomizationModel
{
	int selectedTab
	RTKMeleeCustomizationVideoModel& video
	array<RTKMeleeCustomizationSetModel> sets
	RTKMeleeCustomizationSetModel& equippedItems
	array<asset> equippedToLegendIcons
	int heirloomShards
}

struct
{
	var menu = null
	array<ItemFlavor> blades = []
	array<ItemFlavor> themes = []
	array<ItemFlavor> powerSources = []
	array<ItemFlavor> activationEmotes = []
	array<ItemFlavor> deathboxSkins = []
	int focusedIndex = -1
	int focusedItemGUID = -1
	int previewIndex = -1
	rtk_struct meleeCustomization = null
	string meleeCustomizationPath = ""
} file

struct PrivateData
{
	int menuGUID = -1
}

const int ARTIFACT_CONFIG_BASE = 0 

void function RTKMeleeCustomizationScreen_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RunClientScript( "UIToClient_ClearMeleeSkinPreview" )
	UI_SetPresentationType( ePresentationType.MELEE_INSPECT )

	file.meleeCustomization = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", "RTKMeleeCustomizationModel", ["legend"] )
	file.meleeCustomizationPath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "meleeCustomization", true, ["legend"] )

	self.GetPanel().SetBindingRootPath( file.meleeCustomizationPath )

	if ( IsCustomizingArtifactConfiguration() )
	{
		file.blades 	   		= GetSelectableArtifactComponentsOfType( eArtifactComponentType.BLADE )
		file.powerSources  		= GetSelectableArtifactComponentsOfType( eArtifactComponentType.POWER_SOURCE )
		file.themes		   		= GetSelectableArtifactComponentsOfType( eArtifactComponentType.THEME )
		file.activationEmotes   = GetSelectableArtifactComponentsOfType( eArtifactComponentType.ACTIVATION_EMOTE )
		file.deathboxSkins   	= GetSelectableArtifactComponentsOfType( eArtifactComponentType.DEATHBOX )
	}
	else
	{
		file.deathboxSkins 		= GetSelectableDeathboxSkins()
	}

	
	
	RTKMeleeCustomizationScreen_CreateArtifactSets()
	RTKMeleeCustomizationScreen_AddEvents( self )
	RTKCustomizationScreen_SetEquippedItems()
	RTKCustomizationScreen_SetHeirloomShards()

	
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin != null )
	{
		expect ItemFlavor(selectedMeleeSkin)

		rtk_array equippedToLegendIcons = RTKStruct_GetArray( file.meleeCustomization, "equippedToLegendIcons" )
		FillLegendMeleeEquippedIcons( equippedToLegendIcons, selectedMeleeSkin )
	}

	
	p.menuGUID = AssignMenuGUID()
	RTKFooters_Add( p.menuGUID, LEFT, BUTTON_B, "#B_BUTTON_BACK", BUTTON_INVALID, "#B_BUTTON_BACK", ExitCustomization )
	if ( !IsCustomizingArtifactConfiguration() )
	{
		RTKFooters_Add( p.menuGUID, LEFT, BUTTON_X, "#X_BUTTON_EVENT_SHOP", BUTTON_INVALID, "#X_BUTTON_EVENT_SHOP", EquipFocusedDeathbox, CanUnlockFocusedEventShop )
	}
	RTKFooters_Add( p.menuGUID, LEFT, BUTTON_A, "#MELEE_CUSTOMIZATION_PREVIEW_ACTION", BUTTON_INVALID, "#MELEE_CUSTOMIZATION_PREVIEW_ACTION", null, CanPreviewFocusedItem )
	RTKFooters_Add( p.menuGUID, LEFT, BUTTON_X, "#MELEE_CUSTOMIZATION_EQUIP_ACTION", BUTTON_INVALID, "#MELEE_CUSTOMIZATION_EQUIP_ACTION", null, CanEquipFocusedItem )
	RTKFooters_Add( p.menuGUID, LEFT, BUTTON_X, "#X_BUTTON_UNLOCK", BUTTON_INVALID, "#X_BUTTON_UNLOCK", null, CanUnlockFocusedItem )
	RTKFooters_Update()
}

void function RTKMeleeCustomizationScreen_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "meleeCustomization", ["legend"] )

	file.meleeCustomization = null
	file.meleeCustomizationPath = ""

	file.blades.clear()
	file.themes.clear()
	file.powerSources.clear()
	file.activationEmotes.clear()
	file.deathboxSkins.clear()

	RTKFooters_RemoveAll( p.menuGUID )
	RTKFooters_Update()
}

RTKMeleeCustomizationItemModel function GetMeleeCustomizationItemModel( ItemFlavor meleeItemFlav, int itemType )
{
	LoadoutEntry loadoutSlot = IsCustomizingArtifactConfiguration() ? Artifacts_Loadouts_GetEntryForConfigIndexAndType( ARTIFACT_CONFIG_BASE, itemType ) : Loadout_Deathbox( GetTopLevelCustomizeContext() )

	RTKMeleeCustomizationItemModel meleeItemModel
	meleeItemModel.name = Localize( ItemFlavor_GetLongName( meleeItemFlav ) )
	meleeItemModel.description = Localize( ItemFlavor_GetLongDescription( meleeItemFlav ) )
	meleeItemModel.type = Artifacts_GetComponentType( meleeItemFlav )
	meleeItemModel.setTheme = Artifacts_GetSetIndex( meleeItemFlav )
	meleeItemModel.guid = ItemFlavor_GetGUID( meleeItemFlav )
	meleeItemModel.icon = Artifacts_GetComponentIcon( meleeItemFlav )
	meleeItemModel.mainColor = Artifacts_GetComponentMainColor( meleeItemFlav )
	meleeItemModel.secondaryColor = Artifacts_GetComponentSecondaryColor( meleeItemFlav )
	meleeItemModel.isEmpty = Artifacts_IsEmptyComponent( meleeItemFlav )
	meleeItemModel.isVisible = IsValidItemFlavorGUID( meleeItemFlav.guid )
	meleeItemModel.locked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), loadoutSlot, meleeItemFlav )
	meleeItemModel.equipped = IsComponentEquipped( meleeItemFlav )
	meleeItemModel.selected = meleeItemModel.equipped

	if ( meleeItemModel.locked )
	{
		meleeItemModel.state = eMeleeCustomizationItemState.LOCKED
	}
	else if ( meleeItemModel.equipped && meleeItemModel.selected )
	{
		meleeItemModel.state = eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED
	}
	else if ( meleeItemModel.equipped )
	{
		meleeItemModel.state = eMeleeCustomizationItemState.EQUIPPED
	}
	else
	{
		meleeItemModel.state = eMeleeCustomizationItemState.AVAILABLE
	}

	
	if ( meleeItemModel.setTheme == ULTIMATE_SET_INDEX && meleeItemModel.locked )
	{
		meleeItemModel.description = CelestialSetDescription( meleeItemModel.type )
	}

	return meleeItemModel
}

void function RTKMeleeCustomizationScreen_CreateArtifactSets()
{
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )

	if ( IsCustomizingArtifactConfiguration() )
	{
		foreach ( int theme in ARTIFACT_CUSTOMIZATION_SET_ORDER )
		{
			array< ItemFlavor > components = Artifacts_GetSetItems( theme )

			RTKMeleeCustomizationSetModel meleeSkinSetModel

			meleeSkinSetModel.setTheme = theme

			foreach ( int index, ItemFlavor component in components )
			{
				if ( !IsValidItemFlavorGUID( component.guid ) )
					continue

				int type = Artifacts_GetComponentType( component )

				if ( type == eArtifactComponentType.BLADE && Artifacts_IsEmptyComponent( component ) )
					continue 

				int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
				LoadoutEntry entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )

				bool shouldHideIfLocked = MeleeCustomization_ShouldHideIfLocked( component )
				bool isLocked = !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, component )
				bool isActiveEventReward = MeleeSkin_IsRewardForActiveEvent( component )

				
				
				if ( isLocked && shouldHideIfLocked && !isActiveEventReward )
					continue

				switch ( type )
				{
					case eArtifactComponentType.BLADE:
						meleeSkinSetModel.blade = GetMeleeCustomizationItemModel( component, type )
						break

					case eArtifactComponentType.THEME:
						meleeSkinSetModel.theme = GetMeleeCustomizationItemModel( component, type )
						break

					case eArtifactComponentType.POWER_SOURCE:
						meleeSkinSetModel.powerSource = GetMeleeCustomizationItemModel( component, type )
						break

					case eArtifactComponentType.ACTIVATION_EMOTE:
						meleeSkinSetModel.activationEmote = GetMeleeCustomizationItemModel( component, type )
						break

					case eArtifactComponentType.DEATHBOX:
						meleeSkinSetModel.title = Localize( Artifacts_GetSetNameLocalized( component ) )
						meleeSkinSetModel.deathbox = GetMeleeCustomizationItemModel( component, type )
						break
				}
			}

			
			
			if ( meleeSkinSetModel.deathbox.guid != 0 )
			{
				rtk_struct meleeSetStruct = RTKArray_PushNewStruct( sets )
				RTKStruct_SetValue( meleeSetStruct, meleeSkinSetModel )
			}
		}
	}
	else
	{
		for ( int i = 0; i < file.deathboxSkins.len(); i++ )
		{
			rtk_struct meleeSetStruct = RTKArray_PushNewStruct( sets )

			RTKMeleeCustomizationSetModel meleeSkinSetModel
			meleeSkinSetModel.title = Localize( Artifacts_GetSetNameLocalized( file.deathboxSkins[ i ] ) )
			meleeSkinSetModel.setTheme = Artifacts_GetSetIndex( file.deathboxSkins[ i ] )
			meleeSkinSetModel.deathbox = GetMeleeCustomizationItemModel( file.deathboxSkins[ i ], eArtifactComponentType.DEATHBOX )
			RTKStruct_SetValue( meleeSetStruct, meleeSkinSetModel )
		}
	}
}

void function RTKMeleeCustomizationScreen_AddEvents( rtk_behavior self )
{
	rtk_panel ornull sets = self.PropGetPanel( "sets" )

	if ( sets == null )
		return

	expect rtk_panel( sets )
	self.AutoSubscribe( sets, "onChildAdded", function ( rtk_panel newSet, int newSetIndex ) : ( self ) {
		array< rtk_panel > components = newSet.FindChildByName( "Set" ).GetChildren()
		foreach( int componentIndex, rtk_panel component in components )
		{
			rtk_behavior ornull button = component.FindBehaviorByTypeName( "Button" )

			if ( button == null )
				return

			
			int type
			switch( component.GetName() )
			{
				case "Blade":
					type = eArtifactComponentType.BLADE
					break
				case "Theme":
					type = eArtifactComponentType.THEME
					break
				case "PowerSource":
					type = eArtifactComponentType.POWER_SOURCE
					break
				case "ActivationEmote":
					type = eArtifactComponentType.ACTIVATION_EMOTE
					break
				case "Deathbox":
					type = eArtifactComponentType.DEATHBOX
					break
				default:
					return
			}

			expect rtk_behavior( button )
			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newSetIndex, type ) {
				rtk_struct componentModel = GetComponentSetDataModelStruct( newSetIndex, type )
				if ( keycode == MOUSE_RIGHT || keycode == BUTTON_X )
				{
					if ( !RTKStruct_GetBool( componentModel, "locked" ) )
					{
						PreviewArtifactComponent( newSetIndex, type )

						if ( IsCustomizingArtifactConfiguration() )
						{
							EquipArtifactComponent( newSetIndex, type )
						}
						else
						{
							EquipDeathboxToCharacter( newSetIndex )
						}
						RTKCustomizationScreen_SetEquippedItems()
						EmitUISound( "UI_Menu_Banner_Equip_Legendary" )
					}
					else
					{
						OpenStoreInspectForArtifactItem( RTKStruct_GetInt( componentModel, "setTheme" ), type, newSetIndex )

						EmitUISound( "UI_Menu_Deny" )
					}
				}
				else
				{
					PreviewArtifactComponent( newSetIndex, type )
					EmitUISound( "UI_Menu_Banner_Preview" )
				}
				RTKFooters_Update()
			} )

			self.AutoSubscribe( button, "onDoublePressed", function( rtk_behavior button, int keycode ) : ( self, newSetIndex, type ) {
				rtk_struct componentModel = GetComponentSetDataModelStruct( newSetIndex, type )
				if ( keycode == MOUSE_LEFT )
				{
					if ( !RTKStruct_GetBool( componentModel, "locked" ) )
					{
						if ( IsCustomizingArtifactConfiguration() )
						{
							EquipArtifactComponent( newSetIndex, type )
						}
						else
						{
							EquipDeathboxToCharacter( newSetIndex )
						}
						RTKCustomizationScreen_SetEquippedItems()
						EmitUISound( "UI_Menu_Banner_Equip_Legendary" )
					}
				}
				RTKFooters_Update()
			} )

			self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self, newSetIndex, type ) {
				file.focusedIndex = newSetIndex
				file.focusedItemGUID = RTKStruct_GetInt( GetComponentSetDataModelStruct( newSetIndex, type ), "guid" )
				RTKFooters_Update()
			} )

			self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self, newSetIndex, type ) {
				file.focusedIndex = -1
				file.focusedItemGUID = -1
				RTKFooters_Update()
			} )
		}
	} )

	rtk_behavior ornull actionButton = self.PropGetBehavior( "actionButton" )

	if ( actionButton != null )
	{
		expect rtk_behavior( actionButton )
		self.AutoSubscribe( actionButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			RunClientScript( "UIToClient_ClearMeleeSkinPreview" )
			EmitUISound( "UI_Menu_WeaponClass_Select" )
			UICodeCallback_NavigateBack()
		} )
	}
}

void function RTKCustomizationScreen_SetEquippedItems()
{
	rtk_struct equippedStruct = RTKStruct_GetStruct( file.meleeCustomization, "equippedItems" )

	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )
	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct set = RTKArray_GetStruct( sets, i )

		foreach ( string propertyName, int _ in ARTIFACT_COMPONENT_SETTINGS_KEYS )
		{
			rtk_struct component = RTKStruct_GetStruct( set, propertyName )
			bool isEquipped = RTKStruct_GetBool( component, "equipped" )
			int type = RTKStruct_GetInt( component, "type" )

			if ( isEquipped )
			{
				RTKStruct_SetStruct( equippedStruct, GetSetPropertyName ( type ), component )
			}
		}
	}
}

void function RTKCustomizationScreen_SetHeirloomShards()
{
	RTKStruct_SetInt( file.meleeCustomization, "heirloomShards", GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ) )
}


bool function CanEquipFocusedItem()
{
	if ( file.focusedItemGUID == -1 || !IsValidItemFlavorGUID( file.focusedItemGUID ) )
		return false

	LoadoutEntry entry
	ItemFlavor component = GetItemFlavorByGUID( file.focusedItemGUID )

	if ( IsCustomizingArtifactConfiguration() )
	{
		int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
		entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, Artifacts_GetComponentType( component ) )
	}
	else
	{
		entry = Loadout_Deathbox( GetTopLevelCustomizeContext() )
	}

	return IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, component )
}

bool function CanUnlockFocusedItem()
{
	if ( file.focusedItemGUID == -1 || !IsValidItemFlavorGUID( file.focusedItemGUID ) )
		return false

	ItemFlavor component = GetItemFlavorByGUID( file.focusedItemGUID )

	if ( Artifacts_GetSetIndex( component ) == ULTIMATE_SET_INDEX ||  MeleeCustomization_ShouldHideIfLocked( component ) || MeleeSkin_IsRewardForActiveEvent( component ) )
		return false

	return !CanEquipFocusedItem()
}

bool function CanPreviewFocusedItem()
{
	return file.focusedItemGUID != -1 || IsValidItemFlavorGUID( file.focusedItemGUID )
}

bool function CanUnlockFocusedDeathbox()
{
	if ( file.focusedIndex < 0 || file.focusedIndex >= file.deathboxSkins.len() )
		return false

	return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), file.deathboxSkins[ file.focusedIndex ] ) && !MeleeSkin_IsRewardForActiveEvent( file.deathboxSkins[ file.focusedIndex ] )
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

	return !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Deathbox( GetTopLevelCustomizeContext() ), file.deathboxSkins[ file.focusedIndex ] ) && MeleeSkin_IsRewardForActiveEvent( file.deathboxSkins[ file.focusedIndex ] )
}

void function ExitCustomization( var unused )
{
	UICodeCallback_NavigateBack()
}


void function InitMeleeCustomizationMenu( var menu )
{
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, MeleeCustomizationMenu_OnShow )
	AddCallback_OnTabChanged( MeleeCustomizationPanel_OnTabsChanged )
}

void function MeleeCustomizationMenu_OnShow()
{
	
	
	ClearTabs( file.menu )
	var panel = Hud_GetChild( file.menu, "ArtifactCustomizationPanel" )

	if ( IsCustomizingArtifactConfiguration() )
	{
		
		{
			TabDef tab = AddTab( file.menu, panel, "MELEE_CUSTOMIZATION_NAV_SETS" )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 180 )
		}
		{
			TabDef tab = AddTab( file.menu, panel, "MELEE_CUSTOMIZATION_NAV_BLADE" )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 180 )
		}
		{
			TabDef tab = AddTab( file.menu, panel, "MELEE_CUSTOMIZATION_NAV_THEME" )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 180 )
		}
		{
			TabDef tab = AddTab( file.menu, panel, "MELEE_CUSTOMIZATION_NAV_POWER" )
			tab.isBannerLogoSmall = true
			SetTabBaseWidth( tab, 260 )
		}
	}

	
	{
		TabDef tab = AddTab( file.menu, panel, "MELEE_CUSTOMIZATION_NAV_DEATHBOX" )
		tab.isBannerLogoSmall = true
		SetTabBaseWidth( tab, 220 )
	}

	
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return

	expect ItemFlavor(selectedMeleeSkin)

	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	tabData.bannerTitle = IsCustomizingArtifactConfiguration() ? Localize( ItemFlavor_GetLongName( selectedMeleeSkin ), Artifacts_Loadouts_GetConfigIndex( selectedMeleeSkin ) + 1 ).toupper() : Localize( ItemFlavor_GetLongName( selectedMeleeSkin ) ).toupper()
	tabData.bannerLogoImage = ItemFlavor_GetIcon( selectedMeleeSkin )
	tabData.bannerLogoScale = 0.5
	tabData.callToActionWidth = 210

	SetTabBackground( tabData, Hud_GetChild( file.menu, "TabsBackground" ), eTabBackground.CAPSTONE )
	SetTabDefsToSeasonal( tabData )
	ActivateTab( tabData, 0 )
}


void function InitMeleeCustomizationPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, MeleeCustomizationPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, MeleeCustomizationPanel_OnHide )
}

void function MeleeCustomizationPanel_OnShow( var panel )
{
	var parentMenu = Hud_GetParent( panel )
	Hud_SetVisible( Hud_GetChild( parentMenu, "CustomizeMeleePanelModelRotateMouseCapture"), true )

	if ( IsCustomizingArtifactConfiguration() )
	{
		if ( CanRunClientScript() )
			RunClientScript("Artifacts_StoreLoadoutDataOnPlayerEntityStruct", null, null, false )

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
	MeleeCustomizationPanel_OnTabsChanged()
}

void function MeleeCustomizationPanel_OnHide( var panel )
{
	var parentMenu = Hud_GetParent( panel )
	Hud_SetVisible( Hud_GetChild( parentMenu, "CustomizeMeleePanelModelRotateMouseCapture"), false )

	if ( IsCustomizingArtifactConfiguration() )
	{
		EHI lcEHI = LocalClientEHI()
		LoadoutEntry slot
		for ( int i = 0; i < eArtifactComponentType.COUNT; i++ )
		{
			int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
			slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, i )
			if ( IsConnected() && IsLobby() && IsLocalClientEHIValid() && IsTopLevelCustomizeContextValid() )
				RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( lcEHI, slot, ArtifactComponentLoadoutChangeCallback )
		}
	}
}

void function MeleeCustomizationPanel_OnTabsChanged()
{
	int tabIndex = IsCustomizingArtifactConfiguration() ? GetMenuActiveTabIndex( file.menu ) : eMeleeCustomizationTab.DEATHBOX

	if ( file.meleeCustomization == null || tabIndex < 0 )
		return

	RTKStruct_SetInt( file.meleeCustomization, "selectedTab", tabIndex )

	int type
	switch( tabIndex )
	{
		case eMeleeCustomizationTab.SETS:
		case eMeleeCustomizationTab.BLADE:
			type = eArtifactComponentType.BLADE
			break
		case eMeleeCustomizationTab.THEME:
			type = eArtifactComponentType.THEME
			break
		case eMeleeCustomizationTab.POWER_SOURCE:
			type = eArtifactComponentType.POWER_SOURCE
			break
		case eMeleeCustomizationTab.DEATHBOX:
			type = eArtifactComponentType.DEATHBOX
			break
		default:
			type = eArtifactComponentType.BLADE
	}

	int index = -1
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )
	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct componentModel = GetComponentSetDataModelStruct( i, type )
		bool isSelected = RTKStruct_GetBool( componentModel, "selected" )

		if ( isSelected )
		{
			index = i
			break
		}
	}

	if ( index == -1 )
		return

	PreviewArtifactComponent( index, type )
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
	array<ItemFlavor> allDeathboxSkins = clone GetValidItemFlavorsForLoadoutSlot( entry )

	array<ItemFlavor> selectableDeathboxSkins
	foreach ( ItemFlavor deathboxSkin in allDeathboxSkins )
	{
		if ( ItemFlavor_GetGRXMode( deathboxSkin ) == eItemFlavorGRXMode.NONE && deathboxSkin != Deathbox_GetDefaultItemFlavor() )
			continue

		bool shouldHideIfLocked = MeleeCustomization_ShouldHideIfLocked( deathboxSkin )
		bool isLocked = !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, deathboxSkin )
		bool isActiveEventReward = MeleeSkin_IsRewardForActiveEvent( deathboxSkin )

		
		
		if ( isLocked && shouldHideIfLocked && !isActiveEventReward )
			continue

		selectableDeathboxSkins.append( deathboxSkin )
	}

	selectableDeathboxSkins.sort( int function( ItemFlavor a, ItemFlavor b ) : () {
		int componentASetIndex = Artifacts_GetCustomizationSetIndex( a )
		int componentBSetIndex = Artifacts_GetCustomizationSetIndex( b )

		
		if ( componentASetIndex > componentBSetIndex )
			return 1
		else if ( componentASetIndex < componentBSetIndex )
			return -1

		return 0
	} )

	return selectableDeathboxSkins
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
		
		if ( MeleeSkin_IsRewardForActiveEvent( file.deathboxSkins[ index ] ) )
		{
			EmitUISound( "ui_menu_accept" )
			EventsPanel_SetOpenPageIndex( eEventsPanelPage.MILESTONES )
			JumpToEventTab( "RTKEventsPanel" )
		}
		else
		{
			EmitUISound( "UI_Menu_Deny" )
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
	SetComponentToEquipState( index, eArtifactComponentType.DEATHBOX )

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

bool function IsDeathboxEquipped( ItemFlavor deathbox )
{
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return false

	return Deathbox_GetEquipped( GetTopLevelCustomizeContext(), expect ItemFlavor( selectedMeleeSkin ) ) == deathbox
}

void function MeleeCustomizationScreen_ClientToUI_UpdateDeathboxEquipState( int characterGUID, int meleeSkinGUID, int deathboxGUID )
{
	ItemFlavor character = GetItemFlavorByGUID( characterGUID )
	ItemFlavor meleeSkin = GetItemFlavorByGUID( meleeSkinGUID )
	ItemFlavor deathbox  = GetItemFlavorByGUID( deathboxGUID )

	if ( GetTopLevelCustomizeContext() != character )
		return

	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null || expect ItemFlavor( selectedMeleeSkin ) != meleeSkin )
		return

	
	
	
	
	
	
	
	
	
	
	
	
	

	RTKFooters_Update()
}

void function PreviewArtifactComponent( int index, int type )
{
	int componentGUID = RTKStruct_GetInt( GetComponentSetDataModelStruct( index, type ), "guid" )

	if ( !IsValidItemFlavorGUID( componentGUID ) )
		return

	ItemFlavor component = GetItemFlavorByGUID( componentGUID )

	rtk_struct video = RTKStruct_GetStruct( file.meleeCustomization, "video" )

	RunClientScript( "UIToClient_ClearMeleeSkinPreview" )
	RTKStruct_SetString( video, "assetPath", "" )
	RTKStruct_SetString( video, "title", "" )
	RTKStruct_SetString( video, "description", "" )

	if ( type == eArtifactComponentType.DEATHBOX || type == eArtifactComponentType.ACTIVATION_EMOTE )
	{
		asset videoAsset = GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( component ), "video" )
		RTKStruct_SetString( video, "assetPath", string( videoAsset ) )
		RTKStruct_SetString( video, "title", Artifacts_GetComponentType( component ) == eArtifactComponentType.DEATHBOX ? Localize( "#MELEE_CUSTOMIZATION_DEATHBOX_VIDEO_TITLE" ) : Localize( "#MELEE_CUSTOMIZATION_ACTIVATION_EMOTE_VIDEO_TITLE" ) )
		RTKStruct_SetString( video, "description", Artifacts_GetComponentType( component ) == eArtifactComponentType.DEATHBOX ? Localize( "#MELEE_CUSTOMIZATION_DEATHBOX_VIDEO_DESC" ) : Localize( "#MELEE_CUSTOMIZATION_ACTIVATION_EMOTE_VIDEO_DESC" ) )
	}
	else
	{
		if ( CanRunClientScript() )
		{
			RunClientScript( "Artifacts_Loadouts_StorePreviewDataOnPlayerEntityStruct", component.guid )
			Artifacts_PreviewSet( GetLegendMeleeCustomizeItem() )
		}
	}

	SetComponentToSelectedState( index, Artifacts_GetComponentType( component ) )
}

void function EquipArtifactComponent( int index, int type )
{
	int componentGUID = RTKStruct_GetInt( GetComponentSetDataModelStruct( index, type ), "guid" )

	if ( !IsValidItemFlavorGUID( componentGUID ) )
		return

	ItemFlavor component = GetItemFlavorByGUID( componentGUID )

	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, Artifacts_GetComponentType( component ) )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), slot, component )
	SetComponentToEquipState( index, Artifacts_GetComponentType( component ) )

	if ( type == eArtifactComponentType.ACTIVATION_EMOTE )
	{
		SetComponentToEquipState( index, eArtifactComponentType.POWER_SOURCE )
	}
	else if ( type == eArtifactComponentType.POWER_SOURCE )
	{
		SetComponentToEquipState( index, eArtifactComponentType.ACTIVATION_EMOTE )
	}
}

void function ArtifactComponentLoadoutChangeCallback( EHI playerEHI, ItemFlavor componentFlav )
{
	if ( !IsCustomizingArtifactConfiguration() || !IsValidItemFlavorGUID( componentFlav.guid ) )
		return

	int type = Artifacts_GetComponentType( componentFlav )
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry slot = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )

	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )
	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct componentModel = GetComponentSetDataModelStruct( i, type )
		int componentGUID = RTKStruct_GetInt( componentModel, "guid" )

		if ( !IsValidItemFlavorGUID( componentGUID ) )
			continue

		ItemFlavor component = GetItemFlavorByGUID( componentGUID )

		RTKStruct_SetBool( componentModel, "equipped", IsComponentEquipped( component ) )
		RTKStruct_SetBool( componentModel, "locked", !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), slot, component ) )
	}

	RTKFooters_Update()
}

void function SetComponentToEquipState( int index, int type )
{
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )

	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct component = GetComponentSetDataModelStruct( i, type )
		int componentGUID = RTKStruct_GetInt( component, "guid" )

		if ( !IsValidItemFlavorGUID( componentGUID ) )
			continue

		ItemFlavor componentFlav = GetItemFlavorByGUID( componentGUID )

		int currentComponentState = GetComponentState( componentFlav )

		bool isEquipped = ( i == index )
		RTKStruct_SetBool( component, "equipped", isEquipped )

		int newState = currentComponentState
		if ( isEquipped )
		{
			switch ( currentComponentState )
			{
				case eMeleeCustomizationItemState.AVAILABLE:
				case eMeleeCustomizationItemState.SELECTED:
				case eMeleeCustomizationItemState.EQUIPPED:
					newState = eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED
					break
			}
		}
		else
		{
			switch ( currentComponentState )
			{
				case eMeleeCustomizationItemState.EQUIPPED:
				case eMeleeCustomizationItemState.SELECTED:
				case eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED:
					newState = eMeleeCustomizationItemState.AVAILABLE
					break
			}
		}
		RTKStruct_SetInt( component, "state", newState )
	}
}

void function SetComponentToSelectedState( int index, int type )
{
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )

	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct component = GetComponentSetDataModelStruct( i, type )
		int componentGUID = RTKStruct_GetInt( component, "guid" )

		if ( !IsValidItemFlavorGUID( componentGUID ) )
			continue

		ItemFlavor componentFlav = GetItemFlavorByGUID( componentGUID )

		int currentComponentState = GetComponentState( componentFlav )

		bool isSelected = ( i == index )
		RTKStruct_SetBool( component, "selected", isSelected )

		int newState = currentComponentState
		if ( isSelected )
		{
			switch ( currentComponentState )
			{
				case eMeleeCustomizationItemState.AVAILABLE:
					newState = eMeleeCustomizationItemState.SELECTED
					break
				case eMeleeCustomizationItemState.EQUIPPED:
					newState = eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED
					break
				case eMeleeCustomizationItemState.LOCKED:
					newState = eMeleeCustomizationItemState.SELECTED_AND_LOCKED
					break
			}
		}
		else
		{
			switch ( currentComponentState )
			{
				case eMeleeCustomizationItemState.SELECTED:
					newState = eMeleeCustomizationItemState.AVAILABLE
					break
				case eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED:
					newState = eMeleeCustomizationItemState.EQUIPPED
					break
				case eMeleeCustomizationItemState.SELECTED_AND_LOCKED:
					newState = eMeleeCustomizationItemState.LOCKED
					break
			}
		}

		RTKStruct_SetInt( component, "state", newState )
	}
}

bool function IsCustomizingArtifactConfiguration()
{
	ItemFlavor ornull selectedMeleeSkin = GetLegendMeleeCustomizeItem()
	if ( selectedMeleeSkin == null )
		return false

	expect ItemFlavor( selectedMeleeSkin )
	return Artifacts_Loadouts_IsConfigPointerItemFlavor( selectedMeleeSkin )
}

int function GetComponentState( ItemFlavor component )
{
	LoadoutEntry entry
	if ( !IsCustomizingArtifactConfiguration() )
	{
		entry = Loadout_Deathbox( GetTopLevelCustomizeContext() )
	}
	else
	{
		int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
		entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, Artifacts_GetComponentType( component ) )
	}
	EHI playerEHI = LocalClientEHI()

	if ( IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entry, component ) )
	{
		if ( IsComponentEquipped( component ) )
		{
			if ( IsComponentSelected( component ) )
				return eMeleeCustomizationItemState.SELECTED_AND_EQUIPPED
			else
				return eMeleeCustomizationItemState.EQUIPPED
		}
		else
		{
			if ( IsComponentSelected( component ) )
				return eMeleeCustomizationItemState.SELECTED
			else
				return eMeleeCustomizationItemState.AVAILABLE
		}
	}

	return eMeleeCustomizationItemState.LOCKED
}

bool function IsComponentSelected( ItemFlavor componentFlav )
{
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )
	for ( int i = 0; i < RTKArray_GetCount( sets ); i++ )
	{
		rtk_struct set = RTKArray_GetStruct( sets, i )
		rtk_struct component = RTKStruct_GetStruct( set, GetSetPropertyName( Artifacts_GetComponentType( componentFlav ) ) )
		if ( RTKStruct_GetInt( component, "guid" ) == componentFlav.guid )
		{
			return RTKStruct_GetBool( component, "selected" )
		}
	}
	return false
}

string function GetSetPropertyName( int type )
{
	switch ( type )
	{
		case eArtifactComponentType.BLADE:
			return "blade"
		case eArtifactComponentType.POWER_SOURCE:
			return "powerSource"
		case eArtifactComponentType.ACTIVATION_EMOTE:
			return "activationEmote"
		case eArtifactComponentType.THEME:
			return "theme"
		case eArtifactComponentType.DEATHBOX:
			return "deathbox"
	}
	return ""
}

bool function IsComponentEquipped( ItemFlavor component )
{
	if ( !IsCustomizingArtifactConfiguration() )
		return IsDeathboxEquipped( component )
	int type = Artifacts_GetComponentType( component )

	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )

	return ( component == LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) )
}

array<ItemFlavor> function GetSelectableArtifactComponentsOfType( int type )
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	int configIndex = Artifacts_Loadouts_GetConfigIndex( expect ItemFlavor( GetLegendMeleeCustomizeItem() ) )
	LoadoutEntry entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( configIndex, type )

	EHI playerEHI = LocalClientEHI()
	array<ItemFlavor> allComponents = clone GetValidItemFlavorsForLoadoutSlot( entry )

	array<ItemFlavor> selectableComponents
	foreach ( ItemFlavor component in allComponents )
	{
		if ( Artifacts_IsEmptyComponent( component ) && Artifacts_GetComponentType( component ) == eArtifactComponentType.BLADE )
			continue 

		
		if ( MeleeCustomization_ShouldHideIfLocked( component ) && !MeleeSkin_IsRewardForActiveEvent( component ) )
			continue

		if ( !( Artifacts_GetSetKey( component ) in eArtifactSetIndex ) || Artifacts_GetSetIndex( component ) == eArtifactSetIndex._EMPTY || Artifacts_GetSetIndex( component ) == eArtifactSetIndex.RAGOLD )
			continue 

		selectableComponents.append( component )
	}

	selectableComponents.sort( int function( ItemFlavor a, ItemFlavor b ) : () {
		int componentASetIndex = Artifacts_GetSetIndex( a )
		int componentBSetIndex = Artifacts_GetSetIndex( b )

		
		if ( componentASetIndex > componentBSetIndex )
			return 1
		else if ( componentASetIndex < componentBSetIndex )
			return -1

		return 0
	} )

	return selectableComponents
}

rtk_struct function GetComponentSetDataModelStruct( int index, int type )
{
	rtk_array sets = RTKStruct_GetArray( file.meleeCustomization, "sets" )
	rtk_struct set = RTKArray_GetStruct( sets, index )
	return  RTKStruct_GetStruct( set, GetSetPropertyName( type ) )
}

string function CelestialSetDescription( int type )
{
	switch( type )
	{
		case eArtifactComponentType.BLADE:
			return Localize( "#celestial_locked_blade_DESC_LONG" )
		case eArtifactComponentType.THEME:
			return Localize( "#celestial_locked_theme_DESC_LONG" )
		case eArtifactComponentType.POWER_SOURCE:
			return Localize( "#celestial_locked_powersource_DESC_LONG" )
		case eArtifactComponentType.ACTIVATION_EMOTE:
			return Localize( "#celestial_locked_activationemote_DESC_LONG" )
		case eArtifactComponentType.DEATHBOX:
			return Localize( "#celestial_locked_deathbox_DESC_LONG" )
	}

	return ""
}

void function OpenStoreInspectForArtifactItem( int theme, int type, int index )
{
	if ( theme >= eArtifactSetIndex._EMPTY )
	{
		ItemFlavor component = Artifacts_GetComponentOfTypeFromTheme( theme, type )

		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( component, "artifact_set_shop" )
		foreach ( offerIndex, offer in offers )
		{
			foreach( flav in offer.output.flavors )
			{
				if ( Artifacts_GetComponentType( flav ) == type )
				{
					ArtifactsInspectMenu_AttemptOpenWithOffer( offer )
					break
				}
			}
		}
	}

	else
	{
		int componentGUID = RTKStruct_GetInt( GetComponentSetDataModelStruct( index, type ), "guid" )

		if ( !IsValidItemFlavorGUID( componentGUID ) )
			return

		array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( GetItemFlavorByGUID( componentGUID ), "universal_set_shop" )

		foreach ( offerIndex, offer in offers )
		{
			UniversalMeleeInspectMenu_AttemptOpenWithOffer( offer )
			break
		}
	}


}


bool function RTKMutator_ShowCustomizationItem( int currentTab, int tab, bool isVisible )
{
	if ( isVisible == false )
		return false

	return currentTab == tab || currentTab == eMeleeCustomizationTab.SETS
}

bool function RTKMutator_ShowOnlyArtifactSet( int currentTab, int theme )
{
	if ( currentTab == eMeleeCustomizationTab.DEATHBOX )
		return true

	if ( currentTab == eMeleeCustomizationTab.BLADE && theme == eArtifactSetIndex._EMPTY )
		return false

	return ( theme >= eArtifactSetIndex._EMPTY ) 
}

bool function RTKMutator_HideEmptyActivationEmote( bool isVisible, bool isEmpty, int type )
{
	if ( isEmpty && type == eArtifactComponentType.ACTIVATION_EMOTE )
		return false

	return isVisible
}

vector function RTKMutator_CelestialOutline( int state, int theme, rtk_array defaultColors, rtk_array celestialColors )
{
	if ( theme == ULTIMATE_SET_INDEX )
		return RTKMutator_PickFloat3From( state, celestialColors )

	return RTKMutator_PickFloat3From( state, defaultColors )
}