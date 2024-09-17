global function InitWeaponCharmsPanel
global function GetCurrentActiveWeaponCharmSlot

struct PanelData
{
	var panel
	var ownedRui
	var listPanel
	var charmsButton

	array<ItemFlavor> weaponCharmList
}


struct
{
	table<var, PanelData> panelDataMap

	var         currentPanel = null
	ItemFlavor& currentWeapon
	ItemFlavor& currentWeaponSkin
	bool charmsMenuActive = false
	array< ItemFlavor > weaponCharmListCache
	table< ItemFlavor, ItemFlavor > charmToWeaponMap
	string collectedCountString = ""
	bool grxCallbackAdded = false
	LoadoutEntry& currentActiveEntry
} file












void function InitWeaponCharmsPanel( var panel )
{
	Assert( !(panel in file.panelDataMap) )
	PanelData pd
	file.panelDataMap[ panel ] <- pd

	pd.ownedRui = Hud_GetRui( Hud_GetChild( panel, "Owned" ) )
	RuiSetString( pd.ownedRui, "title", Localize( "#CHARMS_OWNED" ).toupper() )

	pd.listPanel = Hud_GetChild( panel, "WeaponCharmList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, WeaponCharmsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, WeaponCharmsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, WeaponCharmsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )

#if PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
		AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
		AddPanelFooterOption( panel, RIGHT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
#endif

	void functionref( var ) func = (
			void function( var button ) : ()
			{
				var listPanel = file.panelDataMap[ file.currentPanel ].listPanel
				SetOrClearFavoriteFromFocus( listPanel )
			}
	)

	if ( !file.grxCallbackAdded )
	{
		AddUICallback_OnLevelInit(  AddLevelInitUICallback_ClearCharmListCache ) 
		file.grxCallbackAdded = true 
	}

#if PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
#endif
}

LoadoutEntry function GetCurrentActiveWeaponCharmSlot()
{
	return file.currentActiveEntry
}

void function WeaponCharmsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CHARMS )

	file.currentPanel = panel

	file.charmToWeaponMap.clear()
	foreach ( ItemFlavor weaponFlav in GetAllWeaponItemFlavors() )
	{
		LoadoutEntry entry   = Loadout_WeaponCharm( weaponFlav )
		ItemFlavor charmFlav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )
		if ( !WeaponCharm_IsTheEmpty( charmFlav ) )
		{
			charmFlav.loadoutSortPriority = charmFlav.loadoutSortPriority | eLoadoutSortPriority.EQUIPPED
			file.charmToWeaponMap[ charmFlav ] <- weaponFlav
		}
	}

	thread TrackIsOverScrollBar( file.panelDataMap[panel].listPanel )
	WeaponCharmsPanel_Update( panel )
	Hud_ScrollToTop( file.panelDataMap[panel].listPanel )

	if( Hud_GetButtonCount( file.panelDataMap[panel].listPanel ) > 0 )
	{
		var button0 = Hud_GetButton( file.panelDataMap[panel].listPanel, 0 )
		Hud_HandleEvent( button0, UIE_CLICK )
	}
}

void function WeaponCharmsPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )

	WeaponCharmsPanel_Update( panel )

	
	
	
	PanelData pd    = file.panelDataMap[panel]
	Hud_InitGridButtons( pd.listPanel, 0 )
}

void function WeaponCharmsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}

void function WeaponCharmsPanel_Update( var panel )
{
	PanelData pd    = file.panelDataMap[panel]
	var scrollPanel = Hud_GetChild( pd.listPanel, "ScrollPanel" )

	
	foreach ( int flavIdx, ItemFlavor unused in pd.weaponCharmList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponCharmList.clear()

	CustomizeMenus_SetActionButton( null )

	
	string ownedText ="#CHARMS_OWNED"

	RuiSetString( pd.ownedRui, "title", Localize( ownedText ).toupper() )

	
	ItemFlavor ornull weaponOrNull = CategoryWeaponPanel_GetWeapon( Hud_GetParent( panel )  )

	if ( IsPanelActive( panel ) && weaponOrNull != null )
	{
		file.currentWeapon = expect ItemFlavor( weaponOrNull )
		LoadoutEntry entry
		array<ItemFlavor> itemList
		void functionref( ItemFlavor ) previewFunc
		void functionref( ItemFlavor, var ) customButtonUpdateFunc
		void functionref( ItemFlavor, void functionref() ) confirmationFunc
		bool ignoreDefaultItemForCount
		bool shouldIgnoreOtherSlots

		entry = Loadout_WeaponCharm( file.currentWeapon )
		file.currentActiveEntry = entry

		if ( file.weaponCharmListCache.len() == 0 )
			file.weaponCharmListCache = clone GetLoadoutItemsSortedForMenu( [entry], WeaponCharm_GetSortOrdinal, null, [] )

		if ( file.collectedCountString == "" )
			file.collectedCountString = CustomizeMenus_GetCollectedString( entry, file.weaponCharmListCache, true, true )

		pd.weaponCharmList = clone file.weaponCharmListCache

		ItemFlavor emptyCharm = entry.defaultItemFlavor
		Assert ( WeaponCharm_IsTheEmpty( emptyCharm ) )
		emptyCharm.loadoutSortPriority = emptyCharm.loadoutSortPriority & ~eLoadoutSortPriority.EQUIPPED 
		pd.weaponCharmList.removebyvalue( emptyCharm )

		ItemFlavor equippedCharm = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )
		pd.weaponCharmList.removebyvalue( equippedCharm )
		equippedCharm.loadoutSortPriority = equippedCharm.loadoutSortPriority | eLoadoutSortPriority.EQUIPPED

		foreach ( charm, weapon in file.charmToWeaponMap )
		{
			pd.weaponCharmList.removebyvalue( charm )
			if ( weapon != file.currentWeapon )
				pd.weaponCharmList.insert( 0, charm )
		}

		pd.weaponCharmList.insert( 0, emptyCharm )
		if ( equippedCharm != emptyCharm )
			pd.weaponCharmList.insert( 0, equippedCharm )

		itemList = pd.weaponCharmList
		previewFunc = PreviewWeaponCharm
		customButtonUpdateFunc = (void function( ItemFlavor charmFlav, var rui )
		{
			
			asset img = $""

			if ( charmFlav in file.charmToWeaponMap )
			{
				ItemFlavor weaponFlavorThatCharmIsEquippedTo = file.charmToWeaponMap[ charmFlav ]
				if ( weaponFlavorThatCharmIsEquippedTo != file.currentWeapon )
				{
					img = WeaponItemFlavor_GetHudIcon( weaponFlavorThatCharmIsEquippedTo )
					RuiSetBool( rui, "isEquipped", false ) 
				}
			}

			RuiSetAsset( rui, "equippedCharmWeaponAsset", img )
		})
		confirmationFunc = (void function( ItemFlavor charmFlav, void functionref() proceedCb ) {
			
			ItemFlavor ornull charmCurrentWeaponFlav = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( LocalClientEHI(), charmFlav )
			if ( charmCurrentWeaponFlav == null || charmCurrentWeaponFlav == file.currentWeapon )
			{
				proceedCb()
				return
			}
			expect ItemFlavor(charmCurrentWeaponFlav)
			string localizedEquippedWeaponName = Localize( ItemFlavor_GetShortName( charmCurrentWeaponFlav ) )
			string localizedCurrentWeaponName = Localize( ItemFlavor_GetShortName( file.currentWeapon ) )

			ConfirmDialogData data
			data.headerText = Localize( "#CHARM_DIALOG", localizedEquippedWeaponName )
			data.messageText = Localize( "#CHARM_DIALOG_DESC", localizedCurrentWeaponName, localizedEquippedWeaponName )
			data.resultCallback = (void function( int result ) : ( charmFlav, charmCurrentWeaponFlav, proceedCb )
			{
				if ( result != eDialogResult.YES )
					return

				
				delete file.charmToWeaponMap[ charmFlav ]
				RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_WeaponCharm( charmCurrentWeaponFlav ), GetItemFlavorByAsset( $"settings/itemflav/weapon_charm/none.rpak" ) )

				proceedCb()
			})
			OpenConfirmDialogFromData( data )
		})

		RuiSetString( pd.ownedRui, "collected", file.collectedCountString )

		Hud_InitGridButtons( pd.listPanel, itemList.len() )

		foreach ( int flavIdx, ItemFlavor flav in itemList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, previewFunc, null, false, customButtonUpdateFunc, confirmationFunc )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
	}
}

void function PreviewWeaponCharm( ItemFlavor charmFlavor )
{
#if DEV
		if ( InputIsButtonDown( KEY_LSHIFT ) )
		{
			string locedName = Localize( ItemFlavor_GetLongName( charmFlavor ) )
			printt( "\"" + locedName + "\" grx ref is: " + GetGlobalSettingsString( ItemFlavor_GetAsset( charmFlavor ), "grxRef" ) )
			printt( "\"" + locedName + "\" charm model is: " + WeaponCharm_GetCharmModel( charmFlavor ) )
		}
#endif

	ItemFlavor charmWeaponSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_WeaponSkin( file.currentWeapon ) )
	int weaponSkinId           = ItemFlavor_GetGUID( charmWeaponSkin )
	int weaponCharmId          = ItemFlavor_GetGUID( charmFlavor )
	bool shouldHighlightWeapon = file.currentWeaponSkin == charmWeaponSkin ? false : true
	file.currentWeaponSkin = charmWeaponSkin

	
	if( file.currentPanel != null )
	{
		var blurbPanel = Hud_GetChild( file.currentPanel, "SkinBlurb" )

		if ( WeaponCharm_HasStoryBlurb( charmFlavor ) )
		{
			Hud_SetVisible( blurbPanel, true )
			int quality = 0
			if ( ItemFlavor_HasQuality( charmFlavor ) )
				quality = ItemFlavor_GetQuality( charmFlavor )

			var rui = Hud_GetRui( blurbPanel )
			RuiSetString( rui, "characterName", ItemFlavor_GetShortName( charmFlavor ) )
			RuiSetString( rui, "skinNameText", ItemFlavor_GetLongName( charmFlavor ) )
			RuiSetString( rui, "bodyText", WeaponCharm_GetStoryBlurbBodyText( charmFlavor ) )
			RuiSetFloat3( rui, "characterColor", SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, quality + 1 ) / 255.0 ) )
			RuiSetGameTime( rui, "startTime", ClientTime() )
		}
		else
		{
			Hud_SetVisible( blurbPanel, false )
		}
	}
	RunClientScript( "UIToClient_PreviewWeaponSkin", weaponSkinId, weaponCharmId, shouldHighlightWeapon )
}

void function AddLevelInitUICallback_ClearCharmListCache()
{
	AddCallback_OnGRXInventoryStateChanged( ClearCharmListCache )
}

void function ClearCharmListCache()
{
	file.weaponCharmListCache.clear()
	file.collectedCountString = ""
}
