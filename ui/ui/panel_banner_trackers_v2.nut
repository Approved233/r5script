global function InitCardTrackersPanel
global function GetTrackerUIContext
global function SortTrackerArtFlavors

enum eTrackerSortCategory {
	OTHER,
	SEASONAL,
	THREE_STACK,
}

enum eStackOrder {
	BOTTOM,
	MIDDLE,
	TOP,
}

const string SORT_KEY = "sortCategory"
const string STACK_POSITION = "stackPosition"
const string SUFFIX_TOP = "_top"
const string SUFFIX_MID = "_mid"
const string SUFFIX_BOT = "_bot"

const table<int,string> TRACKER_CATEGORY_NAMES =
{
	[ eTrackerSortCategory.OTHER ] = "#MENU_TRACKER_OTHER",
	[ eTrackerSortCategory.SEASONAL ]  = "#MENU_TRACKER_SEASONAL",
	[ eTrackerSortCategory.THREE_STACK ]  = "#MENU_TRACKER_THREE_STACK",
}

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      cardTrackerList
	array<ItemFlavor>	   cachedArtList
	bool                   showArt
	bool                   showAll
	var                    selectedTab
	ItemFlavor ornull 	   lastNewnessCharacter
	array<int>			   trackerCategoryIndices
	table<int,int>         trackerCategoryCount
	table<int,int>         trackerCategoryUnlockCount
} file


void function InitCardTrackersPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "TrackerList" )

	SetPanelTabTitle( panel, "#TRACKERS" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardTrackersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardTrackersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardTrackersPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	
	
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	
	
	
	

	file.showArt = false
	file.showAll = true
	var toggleSeasonFilterButton = Hud_GetChild( file.panel, "ToggleSeasonFilter" )
	Hud_SetVisible( toggleSeasonFilterButton, false ) 
	HudElem_SetRuiArg( toggleSeasonFilterButton, "showAll", file.showAll )
	HudElem_SetRuiArg( toggleSeasonFilterButton, "unlockedLabel", "#MENU_SEASON_ONLY" )
	HudElem_SetRuiArg( toggleSeasonFilterButton, "showLockIcon", false )
	Hud_AddEventHandler( toggleSeasonFilterButton, UIE_CLICK, ToggleSeasonFilter )

	var tabStats = Hud_GetChild( file.panel, "TabStats" )
	HudElem_SetRuiArg( tabStats, "categoryName", Localize( "#TRACKERS_STATS" ).toupper() )
	Hud_AddEventHandler( tabStats, UIE_CLICK, ToggleStats )

	var tabArt = Hud_GetChild( file.panel, "TabArt" )
	HudElem_SetRuiArg( tabArt, "categoryName", Localize( "#TRACKERS_ART" ).toupper() )
	Hud_AddEventHandler( tabArt, UIE_CLICK, ToggleArt )

	file.selectedTab = tabStats
}


int function GetTrackerUIContext()
{
	return file.showArt ? eTrackerType.ART : eTrackerType.STAT
}


void function CardTrackersPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
}


void function CardTrackersPanel_OnHide( var panel )
{
	RemoveNewnessCallbacks()
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	if ( file.cardTrackerList.len() > 0 )
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
	CardTrackersPanel_ClearArtData()
}

void function CardTrackersPanel_ClearArtData()
{
	file.cachedArtList.clear()
	file.trackerCategoryCount.clear()
	file.trackerCategoryUnlockCount.clear()
	file.trackerCategoryIndices.clear()
}

void function CardTrackersPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	var selectedTab = Hud_GetChild( file.panel, file.showArt ? "TabArt" : "TabStats" )
	HudElem_SetRuiArg( file.selectedTab, "isSelected", false )
	HudElem_SetRuiArg( selectedTab, "isSelected", true )
	file.selectedTab = selectedTab

	var currentList = Hud_GetChild( file.panel, file.showArt ? "TrackerListTwoColumn" : "TrackerList" )
	Hud_SetVisible( file.listPanel, false )
	Hud_SetVisible( currentList, true )
	file.listPanel = currentList

	
	foreach ( int flavIdx, ItemFlavor unused in file.cardTrackerList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardTrackerList.clear()

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER_STAT, trackerIndex, null )

	
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i=0; i<GLADIATOR_CARDS_NUM_BADGES; i++ )
		{
			entry   = file.showArt ? Loadout_GladiatorCardStatTrackerArt( character, i ) : Loadout_GladiatorCardStatTracker( character, i )
			entries.append( entry )
		}

		if ( file.showArt ) 
		{
			if ( file.cachedArtList.len() == 0 )
				FilterAndSortTrackersForDisplay( entries )

			foreach( ItemFlavor tracker in file.cachedArtList )
				tracker.loadoutSortPriority = tracker.loadoutSortPriority & ~eLoadoutSortPriority.EQUIPPED

			EHI playerEHI = LocalClientEHI()
			foreach ( loadoutEntry in entries )
			{
				if ( LoadoutSlot_IsReady( playerEHI, loadoutEntry ) )
				{
					ItemFlavor flav = LoadoutSlot_GetItemFlavor( playerEHI, loadoutEntry, true )
					flav.loadoutSortPriority = flav.loadoutSortPriority | eLoadoutSortPriority.EQUIPPED
				}
			}

			file.cardTrackerList = clone file.cachedArtList
		}
		else
		{
			file.cardTrackerList = GetLoadoutItemsSortedForMenu( entries, GladiatorCardStatTracker_GetSortOrdinal, GladiatorCardTracker_IsTheEmpty, [] )
		}

		Hud_InitGridButtons( file.listPanel, file.cardTrackerList.len() )
		if ( file.showArt )
			Hud_InitGridButtonsCategories( file.listPanel, file.trackerCategoryIndices )

		scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
		int lastUsedEvenIndex = -2 
		int lastUsedOddIndex = -1 
		int prevButtonIdx = -1 
		string prevLocKey = ""
		foreach ( int flavIdx, ItemFlavor flav in file.cardTrackerList )
		{
			int buttonIdx = prevButtonIdx + 1
			int sortKey = eTrackerSortCategory[ GetGlobalSettingsString( ItemFlavor_GetAsset( flav ), SORT_KEY ) ]
			if ( file.showArt && sortKey == eTrackerSortCategory.THREE_STACK ) 
			{
				string currLocKey = ItemFlavor_GetLongName( flav ).slice( 0, -4 )
				if ( currLocKey != prevLocKey )
				{
					if ( lastUsedEvenIndex < lastUsedOddIndex )
						buttonIdx = lastUsedEvenIndex + 2
					else
						buttonIdx = lastUsedOddIndex + 2

					prevLocKey = currLocKey
				}
				
				else if ( file.trackerCategoryIndices.len() > 1 && file.trackerCategoryIndices[1] != buttonIdx + 1 &&
								( file.trackerCategoryIndices[1] > buttonIdx + 2 || ( prevButtonIdx % 2 == 1 && lastUsedEvenIndex > lastUsedOddIndex ) || ( prevButtonIdx % 2 == 0 && lastUsedEvenIndex < lastUsedOddIndex ) ) )
				{
					buttonIdx = prevButtonIdx + 2
				}
			}

			Assert( buttonIdx < file.cardTrackerList.len() )
			if ( buttonIdx >= file.cardTrackerList.len() )
				break 

			var button = Hud_GetChild( scrollPanel, "GridButton" + buttonIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewCardTracker, CanEquipCanBuyCharacterItemCheck, true )

			prevButtonIdx = buttonIdx
			if ( buttonIdx % 2 == 0 )
				lastUsedEvenIndex = buttonIdx
			else
				lastUsedOddIndex = buttonIdx

			
			ToolTipData toolTipData
			string descText = file.showArt ? ItemFlavor_GetLongName( flav ) : ItemFlavor_GetShortName( flav )
			toolTipData.descText = Localize( descText )
			asset parentAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( flav ), "parentItemFlavor" )
			if ( !file.showArt && parentAsset != $"" && IsValidItemFlavorSettingsAsset( parentAsset ) )
				toolTipData.titleText = Localize( ItemFlavor_GetShortName( GetItemFlavorByAsset( parentAsset ) ) )

			Hud_SetToolTipData( button, toolTipData )

			if ( file.showArt )
			{
				for ( int i = 0; i < file.trackerCategoryIndices.len(); ++i )
				{
					if ( file.trackerCategoryIndices[i] == flavIdx )
					{
						string cat = Localize( TRACKER_CATEGORY_NAMES[ sortKey ] )
						string lockUnlock = " " + file.trackerCategoryUnlockCount[sortKey] + " / " + file.trackerCategoryCount[sortKey]
						var category = Hud_GetChild( scrollPanel, "GridCategory" + i )
						HudElem_SetRuiArg( category, "label", cat )
						HudElem_SetRuiArg( category, "display", lockUnlock )
					}
				}
			}
		}

		RefreshTabNewness( eTrackerType.STAT )
		RefreshTabNewness( eTrackerType.ART )
		AddNewnessCallbacks()
	}
}


void function CardTrackersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCardTracker( ItemFlavor flav )
{
	SendMenuGladCardPreviewCommand( file.showArt ? eGladCardPreviewCommandType.TRACKER_ART : eGladCardPreviewCommandType.TRACKER_STAT, GetCardPropertyIndex(), flav )
}

void function ToggleArt( var button )
{
	if ( file.showArt == true )
		return

	file.showArt = true
	CardTrackersPanel_Update( Hud_GetParent( button ) )
	Hud_ScrollToTop( file.listPanel )
}

void function ToggleStats( var button )
{
	if ( file.showArt == false )
		return

	file.showArt = false
	CardTrackersPanel_Update( Hud_GetParent( button ) )
	Hud_ScrollToTop( file.listPanel )
}

void function ToggleSeasonFilter( var button )
{
	file.showAll = !file.showAll

	var toggleSeasonFilterButton = Hud_GetChild( file.panel, "ToggleSeasonFilter" )
	HudElem_SetRuiArg( toggleSeasonFilterButton, "showAll", file.showAll )

	CardTrackersPanel_Update( Hud_GetParent( button ) )
	Hud_ScrollToTop( file.listPanel )
}

void function AddNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	RemoveNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[character], OnNewnessUpdated, file.panel )
	file.lastNewnessCharacter = character
}


void function RemoveNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GCardTrackersSectionButton[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessUpdated, file.panel )
	file.lastNewnessCharacter = null
}

void function OnNewnessUpdated( int newCount, var panel )
{
	int trackerType = GetTrackerUIContext()
	RefreshTabNewness( trackerType )
}

void function RefreshTabNewness( int trackerType )
{
	ItemFlavor character = GetTopLevelCustomizeContext()

	array<LoadoutEntry> entries = []
	string tabName = ""
	switch( trackerType )
	{
		case eTrackerType.STAT:
			entries.append( Loadout_GladiatorCardStatTracker( character, 0 ) )
			tabName = "TabStats"
			break;

		case eTrackerType.ART:
			entries.append( Loadout_GladiatorCardStatTrackerArt( character, 0 ) )
			tabName = "TabArt"
			break;
	}

	bool hasNew = false
	array<ItemFlavor> flavors = GetLoadoutItemsSortedForMenu( entries, null, GladiatorCardTracker_IsTheEmpty, [] )
	foreach ( int flavIdx, ItemFlavor flav in flavors )
	{
		if ( Newness_IsItemFlavorNew( flav ) )
		{
			hasNew = true
			break
		}
	}

	var tab = Hud_GetChild( file.panel, tabName )
	Hud_SetNew( tab, hasNew )
}

void function FilterAndSortTrackersForDisplay( array<LoadoutEntry> entries )
{
	EHI playerEHI = LocalClientEHI()
	array< ItemFlavor > artList = clone entries[0].validItemFlavorList
	if ( GetCurrentPlaylistVarBool( "filter_uncraftable_items", true ) )
		artList = FilterItemsForGRX( playerEHI, artList )

	artList = FilterItemsForVisibility( playerEHI, artList )

	array< asset > uniqueArt
	foreach( ItemFlavor tracker in clone artList )
	{
		asset bgImage = GladiatorCardStatTracker_GetBackgroundImage( tracker )
		if ( uniqueArt.contains( bgImage ) )
			artList.fastremovebyvalue( tracker )
		else
			uniqueArt.append( bgImage )
	}

	artList.fastremovebyvalue( entries[0].defaultItemFlavor )

	artList.sort( int function( ItemFlavor a, ItemFlavor b ) {
		int ordinalA = GladiatorCardStatTrackerArt_GetSortOrdinal( a )
		int ordinalB = GladiatorCardStatTrackerArt_GetSortOrdinal( b )
		if ( ordinalA > ordinalB )
			return 1
		else if ( ordinalA < ordinalB )
			return -1

		return 0
	} )

	file.trackerCategoryIndices.clear()
	int prevSortKey = -1
	foreach ( int idx, ItemFlavor tracker in artList )
	{
		int currSortKey = eTrackerSortCategory[ GetGlobalSettingsString( ItemFlavor_GetAsset( tracker ), SORT_KEY ) ]
		if ( currSortKey != prevSortKey )
		{
			file.trackerCategoryIndices.append( idx )
			prevSortKey = currSortKey
			file.trackerCategoryCount[currSortKey] <- 1
			file.trackerCategoryUnlockCount[currSortKey] <- 0
		}
		else
		{
			file.trackerCategoryCount[currSortKey]++
		}

		if ( IsItemFlavorUnlockedForLoadoutSlot( playerEHI, entries[0], tracker ) )
			file.trackerCategoryUnlockCount[currSortKey]++
	}

	file.cachedArtList = artList
}

int function SortTrackerArtFlavors( ItemFlavor artA, ItemFlavor artB )
{
	int sortKeyA = eTrackerSortCategory[ GetGlobalSettingsString( ItemFlavor_GetAsset( artA ), SORT_KEY ) ]
	int sortKeyB = eTrackerSortCategory[ GetGlobalSettingsString( ItemFlavor_GetAsset( artB ), SORT_KEY ) ]

	if ( sortKeyA > sortKeyB )
		return -1

	if ( sortKeyB > sortKeyA )
		return 1

	ItemFlavor ornull parentFlavorA = ItemFlavor_GetParentFlavor( artA )
	ItemFlavor ornull parentFlavorB = ItemFlavor_GetParentFlavor( artB )

	if ( parentFlavorA != null && parentFlavorB == null )
		return 1

	if ( parentFlavorA == null && parentFlavorB != null )
		return -1

	if ( parentFlavorA != null && parentFlavorB != null && sortKeyA == eTrackerSortCategory.THREE_STACK )
	{
		expect ItemFlavor( parentFlavorA )
		expect ItemFlavor( parentFlavorB )

		string parentCharA = ItemFlavor_GetCharacterRef( parentFlavorA )
		string parentCharB = ItemFlavor_GetCharacterRef( parentFlavorB )

		if ( parentCharA > parentCharB )
			return 1

		if ( parentCharA < parentCharB )
			return -1
	}

	string alphaKeyA
	string alphaKeyB

	if ( sortKeyA == eTrackerSortCategory.THREE_STACK )
	{
		alphaKeyA = ItemFlavor_GetLongName( artA )
		alphaKeyB = ItemFlavor_GetLongName( artB )






		
		alphaKeyA = alphaKeyA.slice( 0, -4 )
		alphaKeyB = alphaKeyB.slice( 0, -4 )
	}
	else if ( sortKeyA == eTrackerSortCategory.SEASONAL )
	{
		alphaKeyA = string( ItemFlavor_GetSourceIcon( artA ) )
		alphaKeyB = string( ItemFlavor_GetSourceIcon( artB ) )
	}
	else
	{
		alphaKeyA = string( GladiatorCardStatTracker_GetBackgroundImage( artA ) )
		alphaKeyB = string( GladiatorCardStatTracker_GetBackgroundImage( artB ) )
	}

	if ( alphaKeyA > alphaKeyB )
		return 1

	if ( alphaKeyA < alphaKeyB )
		return -1

	if ( sortKeyA == eTrackerSortCategory.THREE_STACK )
	{
		int stackKeyA = eStackOrder[ GetGlobalSettingsString( ItemFlavor_GetAsset( artA ), STACK_POSITION ) ]
		int stackKeyB = eStackOrder[ GetGlobalSettingsString( ItemFlavor_GetAsset( artB ), STACK_POSITION ) ]

		if ( stackKeyA > stackKeyB )
			return -1

		if ( stackKeyB > stackKeyA )
			return 1
	}

	return 0
}