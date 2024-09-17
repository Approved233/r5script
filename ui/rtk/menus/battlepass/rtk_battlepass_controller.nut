global function RTKBattlepass_InitializeMenuPanel
global function RTKBattlepassControllerPanel_InitMetaData
global function RTKBattlepassControllerPanel_OnInitialize
global function RTKBattlepassControllerPanel_OnDestroy
global function GetPassModelName
global function GetPassModel

global struct RTKBattlepassControllerPanel_Properties
{
	rtk_behavior badgeViewButton
	rtk_behavior purchaseButton
	rtk_behavior challengeButton
	rtk_behavior pagination
	rtk_behavior motdCursorInteract
	rtk_behavior trackSelectorCursorInteract
	rtk_behavior carousel
	rtk_behavior selectorDirectionalNav
	rtk_behavior trackDirectionalNav
	rtk_panel inspectDetails
	rtk_panel trackItemsGrid
	rtk_panel trackItemsGrid2
	rtk_panel trackSelectorsGrid
	rtk_behavior trackSelectorsListBinder
	rtk_panel prizeTrackContainer
	bool expandingEnabledController = false
	bool expandingEnabledDnavOnly = false
	bool expandingEnabledKeyboard = false
	bool directionalNavEnabled = false
	int passType = -1 
}

global enum ePassType
{
	INVALID = -1,
	BATTLEPASS = 0,
	NEWPLAYER = 1,
	EVENT = 2,
	RETURNING_PLAYER = 3,
	_COUNT,
}

global enum eBattlepassViewMode
{
	FREE = 0,
	PREMIUM = 1,
	ELITE = 2,
	BATTLEPASS_BADGE = 3,
	NEWPLAYER = 4,
	NEWPLAYER_BADGE = 5,
	EVENT = 6,
	RETURNING_PLAYER = 7,
	_COUNT,
}

global enum eBattlepassNavigationRoot
{
	TRACK_SELECTION = 0,
	PRIZE_TRACK = 1,
	_COUNT,
}

global struct RTKBattlepassSummaryStruct
{
	asset badgeAssetPath = $""
	int currentLevel = 0
	string description = ""
	float progress = 0.0
	string statusLabel = ""
	string XPLabel = ""
	
	asset levelStarAsset = $""
	int levelStarSize = 24
	bool enableBadges = false
	bool enablePurchaseState = false
}

global struct RTKBattlepassTrackSelectorPrizeStruct
{
    asset assetPath = $"" 
    int assetHeight = 132
    int assetWidth = 178
    string description = ""
    bool exists = false
    asset frameAssetPath = $""
	vector assetIconPivot = <0.5, 0.5, 0>
    vector frameColor = <1.0, 1.0, 1.0>
    float frameLightness = 0.0
    float frameSaturation = 1.0
    bool isFocused = false
    bool isFront = true
    bool isSelected = false
    bool isEliteItem = false
	bool isPremiumItem = false
	bool isFreeItem = false
	bool showFreeIndicator = false
    SettingsAssetGUID itemGUID
    bool levelReached = false
    bool locked = false
    bool owned = false
    float progress = 0
    int quantity = 0
    int quality = 0
    asset secondaryIconAssetPath = $"" 
    int itemType = -1
}

global struct RTKBattlepassTrackSelectorStruct
{
	int index = -1
	bool isSelected = false
	bool exists = false
	RTKBattlepassTrackSelectorPrizeStruct& frontPrize
	RTKBattlepassTrackSelectorPrizeStruct& backPrize
}

global struct RTKBattlepassTrackItemStruct
{
    int assetHeight = 124
    int assetWidth = 104
    asset badgeRuiAsset = $"" 
    int badgeTier = -1
    bool checked = false
    asset decorationAssetPath = $"" 
    string description = ""
    asset eliteFrameAssetPath = $"" 
    bool expanded = false
    asset frameAssetPath = $"" 
    int assetIconPositionY = 0
    vector frameColor = <1.0, 1.0, 1.0>
    float frameLightness = 0.0
    float frameSaturation = 1.0
    asset image = $"" 
    int index = 0
    bool isBadge = false
    bool isChaseItem = false
    bool isEliteItem = false
    bool isPremiumItem = false
    bool isFreeItem = false
    bool showFreeIndicator = false
    bool isFocused = false
    int itemDisplayType = 0
    SettingsAssetGUID itemGUID
    bool levelReached = false
	int level = -1
    bool locked = false
    int quantity = 0
    int quality = 0
    int reverseIndex = 0
    int spacing = 0
    asset secondaryIconAsset = $""
    int itemType = -1
}

global struct RTKBattlepassTrackLevelStruct
{
    int chaseItemCount
    bool expanded
    bool isBadge
    bool isChaseItem
    bool isCurrentLevel
    bool isNextLevel
    bool isOwned
	bool pagesToRight
	array< RTKBattlepassTrackItemStruct > items
	int itemCount = 0
    int level = 0
    int width = 0
    string levelText
    float progress = 0.0
}

global struct RTKBattlepassControllerPanel_ModelStruct
{
	int endTime = 0
	int navigationRoot = 0
	bool isControllerActive = false
	bool isDpadActive = false
	bool isExpanded = false
	bool viewMode = false
	bool showRightContentHints = true
	string description = ""
	string trackNavHintText = ""
	string trackNavRewardsText = ""
	string motdSubtext = ""
	int trackVisibleChaseItems = 2
	int trackVisibleLevels = 9
	int viewingTrack = -1
	RTKBattlepassCarouselInfo& carouselInfo
	asset prefabItemTrack = $""
	asset prefabItemChase = $""
	array< RTKBattlepassTrackLevelStruct > trackLevels
	array< RTKBattlepassTrackItemStruct > trackItems
	array< RTKBattlepassTrackLevelStruct > chaseLevels
	array< RTKBattlepassTrackItemStruct > chaseItems
	array< RTKBattlepassTrackItemStruct > trackItemsBadge
	array< RTKBattlepassTrackItemStruct > chaseItemsBadge
	vector bpv2bgsliceColor1
	vector bpv2bgsliceColor2
	
	bool enableBadges = false
	bool enableTrackExplanation = false
	bool enablePurchaseButton = false
	string purchaseButtonText = ""
	bool enableChallengesButton = false
	string trackExplanation = ""
	int passType = -1
}

struct PrivateData
{
	void functionref() OnGRXStateChanged
	void functionref( var button ) backFunc
	void functionref( var button ) toggleEliteFunc
	void functionref( bool input ) inputChangedFunc
	void functionref( var input ) trackUpFunc
	void functionref( var input ) trackDownFunc
	int viewingTrack = -1
	int viewMode = -1
	int navigationRoot = eBattlepassNavigationRoot.TRACK_SELECTION
	bool expanded = false
	rtk_behavior ornull itemDetailsControllerBehavior
	array< RTKBattlepassTrackLevelStruct > badgeLevels
	array< RTKBattlepassTrackLevelStruct > trackLevels
	bool callbacksInitialised = false
	bool inputCBsInitialised = false
	bool grxInitComplete = false
	bool isControllerActive = false
	bool isDpadActive = false
	table <int, array<BattlePassReward> > passLevelRewardsCache
	SettingsAssetGUID focusedItemGUID
	int focusedLevel = -1
	int focusedIndex = -1
	bool focusedTrackSelector = false
	bool focusedTrack = false
	int openedAtTime = -1
	float lastUpdate = -1.0
	float updateDelay = 0.3
	int paginationStartPage = -1
	int paginationCurrentPage = -1
	bool paginationAutoScroll = false
	rtk_behavior ornull lastActiveCursorInteract = null
	
	int TRACK_PAGE_SIZE = 10
	int MAX_TRACKS = 6
	int MAX_CHASE_ITEMS = 2
	int XP_PER_LEVEL = 10
	int PASS_MAX_LEVELS = 110
}

struct FileStruct_SessionPersistence
{
	table< int, int > passTypeToViewingTrack 
	table< int, int > passTypeToViewingPage
	table< int, int > passTypeToViewingMode
	table< int, string > passTypeToPanelName
	table< int, rtk_behavior ornull > passTypeToPass 
}
FileStruct_SessionPersistence& file

const float inactiveTrackSelectorLightness = -0.75
const float blurredTrackSelectorLightness = -0.15
const float blurredTrackPrizeLightness = -0.15
const float ownedTrackPrizeLightness = -0.4
const float unownedTrackPrizeLightness = -0.10


const table< int, vector > battlepassRarityColorsDim = { [0] = <0.4157, 0.4157, 0.4157>, [1] = <0.2431, 0.5647, 0.8667>, [2] = <0.7137, 0.2431, 0.8667>, [3] = <0.8667, 0.7137, 0.2431>, [4] = < 0.989, 0.294, 0.102>, [5] = < 0, 0.977, 0.780 >  }
const table< int, vector > battlepassRarityColorsBright = { [0] = <0.5529, 0.5529, 0.5529>, [1] = <0.3529, 0.6745, 0.9765>, [2] = <0.8471, 0.3961, 0.9922>, [3] = <0.9843, 0.8431, 0.4000>, [4] = < 0.989, 0.294, 0.102>, [5] = < 0, 0.977, 0.780 >  }


vector function GetBattlepassRarityColor( int quality, bool brightColor = true )
{
	if ( brightColor && quality in battlepassRarityColorsBright)
		return battlepassRarityColorsBright[quality]
	if ( !brightColor && quality in battlepassRarityColorsDim)
		return battlepassRarityColorsDim[quality]
	return <1.0, 1.0, 1.0>
}

string function GetPassPanelName( int passType = -1 )
{
	if ( passType in file.passTypeToPanelName )
		return file.passTypeToPanelName[passType]
	return "invalidpasspanel"
}

ItemFlavor ornull function GetPass( int passType = -1 )
{
	ItemFlavor ornull activePass

	if ( passType == ePassType.BATTLEPASS )
	{

			activePass = GetActiveBattlePassV2()

	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			activePass = NPP_GetAssignedNPP( GetLocalClientPlayer() )

	}
	return activePass
}

string function GetPassModelName( int passType = -1 )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return "battlepass"
	}
	else if ( passType == ePassType.NEWPLAYER )
	{
		return "newplayerpass"
	}
	return "invalidpass"
}

rtk_struct function GetPassModel( int passType = -1 )
{
	rtk_struct passModelStruct = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, GetPassModelName( passType ), "RTKBattlepassControllerPanel_ModelStruct" )
	return passModelStruct
}

int function GetPassXPProgress( EHI playerEHI, ItemFlavor activePass, int passType, bool getPreviousProgress = false, bool includeChallengeStars = false )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		int currentXP = GetPlayerBattlePassXPProgress( playerEHI, activePass, getPreviousProgress )
		if ( includeChallengeStars && BattlePass_UseStarsToProgress( activePass ) )
		{
			ItemFlavor ornull starChallenge = GetBattlePassRecurringStarChallenge( activePass )

			if ( starChallenge != null )
			{
				expect ItemFlavor( starChallenge )

				entity player = GetLocalClientPlayer()

				if ( Challenge_IsAssigned( player, starChallenge ) )
				{
					int tier     = Challenge_GetCurrentTier( player, starChallenge )
					int progress = Challenge_GetProgressValue( player, starChallenge, tier )
					currentXP += progress
				}
			}
		}
		return currentXP
	}
	else if ( passType == ePassType.NEWPLAYER )
	{
		return NPP_GetCurrentLevelProgress( GetLocalClientPlayer() )
	}
	return 0
}

int function GetPassLevelForXP( ItemFlavor pass, int xp, int passType )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return GetBattlePassLevelForXP( pass, xp )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{
		Warning( "Called GetPassLevelForXP on a New Player Pass, a Battle Pass Item Flavor that doesn't use XP." )
		return 0
	}
	return 0
}

int function GetPassXPForLevel( ItemFlavor pass, int goalLevel, int passType )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return GetBattlePassXPForLevel( pass, goalLevel )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			return 0

	}
	return 0
}

int function GetPassMaxPurchaseLevels( ItemFlavor pass, int passType )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return GetBattlePassMaxPurchaseLevels( pass )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			return 0

	}
	return 0
}

int function GetPassLevel( entity player, ItemFlavor pass, int passType, bool getPreviousLevel = false )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return GetPlayerBattlePassLevel( player, pass, getPreviousLevel )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			Assert( getPreviousLevel == false, "Called GetPassLevel on New Player Pass with getPreviousLevel = true, this is incompatable with NPP." )
			return NPP_GetPlayerBattlePassLevel( player, pass )

	}
	return 0
}

int function GetPassMaxLevelIndex( ItemFlavor pass, int passType )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		return GetBattlePassMaxLevelIndex( pass )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			return NPP_GetBattlePassMaxLevelIndex( pass )

	}
	return 0
}

bool function IsPassComplete(  ItemFlavor pass, int passType )
{
	if ( passType == ePassType.BATTLEPASS )
	{
		int battlePassLevel = GetPassLevel( GetLocalClientPlayer(), pass, passType, false )
		int battlePassMaxLevel = GetPassMaxLevelIndex( pass, passType )
		bool battlePassCompleted = battlePassLevel >= battlePassMaxLevel
		return battlePassCompleted
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

			return NPP_IsNPPComplete( GetLocalClientPlayer() )

	}
	return false
}

bool function PassCanEquipReward( ItemFlavor item )
{
	int itemType                     = ItemFlavor_GetType( item )
	array<LoadoutEntry> loadoutSlots = GetAppropriateLoadoutSlotsForItemFlavor( item )

	if ( loadoutSlots.len() == 0 )
		return false

	foreach ( loadoutSlot in loadoutSlots)
	{
		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutSlot ) == item)
		if ( isEquipped )
			return false
	}

	return GRX_IsItemOwnedByPlayer_AllowOutOfDateData( item )
}

void function PassEquipReward( SettingsAssetGUID itemGUID )
{
	if ( !IsValidItemFlavorGUID( itemGUID ) )
		return

	ItemFlavor item = GetItemFlavorByGUID( itemGUID )

	if ( !PassCanEquipReward(item) )
		return

	array<LoadoutEntry> entry = GetAppropriateLoadoutSlotsForItemFlavor( item )

	if ( entry.len() == 0 )
		return

	if ( entry.len() == 1 )
	{
		EmitUISound( "UI_Menu_Equip_Generic" )
		RequestSetItemFlavorLoadoutSlot( ToEHI( GetLocalClientPlayer() ), entry[ 0 ], item )
	}
	else
	{
		OpenSelectSlotDialog( entry, item, GetItemFlavorAssociatedCharacterOrWeapon( item ),
					(void function( int index ) : ( entry, item )
			{
				EmitUISound( "UI_Menu_Equip_Generic" )
				RequestSetItemFlavorLoadoutSlot_WithDuplicatePrevention( ToEHI( GetLocalClientPlayer() ), entry, item, index )
			})
		)
	}
}

bool function PassCanBuyUpToLevel( int passType )
{
	if ( !GRX_IsInventoryReady() )
		return false

	if ( !GRX_AreOffersReady() )
		return false

	if ( GetSelf( passType ) == null )
		return false

	ItemFlavor ornull activePass = GetPass( passType )

	if ( activePass == null )
		return false

	expect ItemFlavor( activePass )

	if ( !DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM ) )
		return false

	int level = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false ) + 1 
	int maxPurchaseLevels = GetPassMaxPurchaseLevels( activePass, passType )

	if ( level > maxPurchaseLevels )
		return false

	return true
}

void function PassBuyUpToLevel( int passType )
{
	ItemFlavor ornull activePass = GetPass( passType )

	if ( activePass == null )
		return

	expect ItemFlavor( activePass )

	if ( !DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM ) )
		return

	BattlePass_Purchase( null, 1 )
}

bool function PassCanEquipFocusedReward( int passType )
{
	if ( GetSelf( passType ) == null )
		return false

	rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
	PrivateData p
	self.Private( p )

	if ( !p.focusedTrack )
		return false

	if ( !IsValidItemFlavorGUID( p.focusedItemGUID ) )
		return false

	ItemFlavor focusedItem = GetItemFlavorByGUID( p.focusedItemGUID )
	return PassCanEquipReward( focusedItem )
}

bool function PassIsPackFocused( int passType )
{
	if ( GetSelf( passType ) == null )
		return false

	rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
	PrivateData p
	self.Private( p )

	if ( p.focusedTrackSelector )
		return false

	if ( !IsValidItemFlavorGUID( p.focusedItemGUID ) )
		return false

	ItemFlavor focusedItem = GetItemFlavorByGUID( p.focusedItemGUID )
	return ( ItemFlavor_GetType( focusedItem ) == eItemType.account_pack )
}


rtk_behavior ornull function GetSelf( int passType = -1 )
{
	if ( passType in file.passTypeToPass )
		return file.passTypeToPass[passType]
	return null
}

void function OnPanelShow( var panel )
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
}

void function OnPanelHide( var panel )
{
	RunClientScript( "ClearBattlePassItem" )
	Signal( uiGlobal.signalDummy, "RTKBattlepassOnHide" )
}

void function RTKBattlepass_InitializeMenuPanel( var panel, int passType = -1 )
{
	file.passTypeToPanelName[passType] <- Hud_GetHudName( panel ) 

	
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, void function( var vguiPanel ) : ( panel, passType )
	{
		OnPanelShow( vguiPanel )
		if ( GetSelf( passType ) != null )
		{
			rtk_struct battlepassModelStruct = GetPassModel( passType )
			RTKBattlepassControllerPanel_RegisterInput( expect rtk_behavior(GetSelf( passType )), battlepassModelStruct, passType )
		}
	})

	
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, void function( var vguiPanel ) : ( panel, passType )
	{
		OnPanelHide( vguiPanel )
		if ( GetSelf( passType ) != null )
		{
			rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
			RTKBattlepassControllerPanel_DeregisterInput( self )
			RTKPagination_DeregisterGlobalInput( self.PropGetBehavior( "pagination" ) )
			RTKDirectionalNavigation_SetEnabled( self.PropGetBehavior( "trackDirectionalNav" ), false )
			RTKDirectionalNavigation_SetEnabled( self.PropGetBehavior( "selectorDirectionalNav" ), false )
		}
		Menus_SetNavigateBackDisabled( false )
	})

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", void function( var button ) : ( panel, passType )
	{
		rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
		RTKBattlepassControllerPanel_OnBack( self, true )
	} )

	if ( passType == ePassType.BATTLEPASS )
	{
		SetPanelTabTitle( panel, "#PASS" )

		

		AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#FOOTER_MORE_INFO", "#FOOTER_MORE_INFO_MOUSE",
			OpenBattlepassMoreInfo
		)

		AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#FOOTER_BUTTON_BUY_UP_TO", "#FOOTER_BUTTON_BUY_UP_TO_MOUSE",
			void function( var button ) : ( panel, passType )
			{
				PassBuyUpToLevel( passType )
			},
			bool function( ) : ( panel, passType )
			{
				return PassCanBuyUpToLevel( passType )
			}
		)

		AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#FOOTER_BUTTON_BUY_PASS", "#FOOTER_BUTTON_BUY_PASS_MOUSE",
			void function( var button ) : ( panel, passType )
			{
				CloseActiveMenu()
				SetCurrentTabForPIN( "PassPanel" )
				OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE_PLUS )
			},
			bool function( ) : ( panel, passType )
			{
				if ( GetSelf( passType ) == null )
					return false

				if ( !GRX_IsInventoryReady() )
					return false

				if ( !GRX_AreOffersReady() )
					return false

				ItemFlavor ornull activePass = GetPass( passType )

				if ( activePass == null )
					return false

				expect ItemFlavor( activePass )

				return !DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM )
			}
		)
	}
	else if ( passType == ePassType.NEWPLAYER )
	{
		SetPanelTabTitle( panel,  "#NEWPLAYERPASS" )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#FOOTER_MORE_INFO", "#FOOTER_MORE_INFO_MOUSE", void function( var button ) : (  )
		{
			OpenNewPlayerPassInfo()
		})
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, true, "#BATTLEPASS_FOOTER_PACK_INFO", "#BATTLEPASS_FOOTER_PACK_INFO_MOUSE",
		OpenPackInfoDialog,
		bool function( ) : ( panel, passType )
		{
			return !PassCanEquipFocusedReward ( passType ) && PassIsPackFocused( passType ) 
		}
	)

	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, true, "#FOOTER_BUTTON_EQUIP", "#FOOTER_BUTTON_EQUIP",
		void function( var button ) : ( panel, passType )
		{
			if ( GetSelf( passType ) == null )
				return

			rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
			PrivateData p
			self.Private( p )

			if ( !p.focusedTrack )
				return

			PassEquipReward( p.focusedItemGUID )
		},
		bool function( ) : ( panel, passType )
		{
			return PassCanEquipFocusedReward ( passType )
		}
	)

	AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT",
		null, 
		bool function( ) : ( panel, passType )
		{
			if ( GetSelf( passType ) == null )
				return false

			rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
			PrivateData p
			self.Private( p )

			if ( !p.focusedTrack )
				return false

			if ( !IsValidItemFlavorGUID( p.focusedItemGUID ) )
				return false

			ItemFlavor focusedItem = GetItemFlavorByGUID( p.focusedItemGUID )
			return (ItemFlavor_GetType( focusedItem ) == eItemType.loadscreen || InspectItemTypePresentationSupported( focusedItem ))
		}
	)

	AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#FOOTER_VIEW_PRIZE_TRACK", "#FOOTER_VIEW_PRIZE_TRACK",
		null, 
		bool function( ) : ( panel, passType )
		{
			if ( GetSelf( passType ) == null )
				return false

			rtk_behavior self = expect rtk_behavior( GetSelf( passType ) )
			PrivateData p
			self.Private( p )

			return p.focusedTrackSelector
		}
	)
}


void function RTKBattlepassControllerPanel_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "RTKBattlepassOnHide" )
	RegisterSignal( "RTKBattlepassOnUpdate" )
	RegisterSignal( "RTKBattlepassOnPrizesInstantiated" )
}

void function RTKBattlepassControllerPanel_OnInitialize( rtk_behavior self )
{
	int passType = self.PropGetInt( "passType" )
	string passModelName = GetPassModelName( passType )
	rtk_struct battlepassModelStruct = GetPassModel( passType )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, passModelName, true ) )
	file.passTypeToPass[passType] <- self

	thread function() : ( self, battlepassModelStruct )
	{
		RTK_DevAssert( IsFullyConnected(), "RTKBattlepassControllerPanel_OnInitialize called while not connected to a server")

		while ( !IsFullyConnected() )
			WaitFrame()

		RTKBattlepassControllerPanel_OnInitializedAndConnected( self, battlepassModelStruct )
	}()
}

void function RTKBattlepassControllerPanel_OnInitializedAndConnected( rtk_behavior self, rtk_struct battlepassModelStruct )
{
	int passType = self.PropGetInt( "passType" )

	ItemFlavor ornull activePass = GetPass( passType )
	if ( passType == ePassType.BATTLEPASS )
	{
		RTK_DevAssert( activePass != null, "RTKBattlepassControllerPanel_OnInitialize called with null pass" )
		int activePassType = BattlePassV2_GetBPV2Type( expect ItemFlavor( activePass ) )
		RTK_DevAssert( activePassType == eBattlePassV2Type.SEASONAL, "RTKBattlepassControllerPanel_OnInitialize called with a pass type mismatch")
	}
	else if ( passType == ePassType.NEWPLAYER )
	{
		RTK_DevAssert( activePass != null, "RTKBattlepassControllerPanel_OnInitialize called with null pass" )
		int activePassType = BattlePassV2_GetBPV2Type( expect ItemFlavor( activePass ) )
		RTK_DevAssert( activePassType == eBattlePassV2Type.NPP, "RTKBattlepassControllerPanel_OnInitialize called with a pass type mismatch")
	}

	RTKBattlepassControllerPanel_RegisterInput( self, battlepassModelStruct, passType )

	expect ItemFlavor( activePass )

	asset passAsset = ItemFlavor_GetAsset( activePass )

	RTKStruct_SetFloat3(battlepassModelStruct, "bpv2bgsliceColor1", GetGlobalSettingsVector( passAsset, "bpv2bgsliceColor1" ) )
	RTKStruct_SetFloat3(battlepassModelStruct, "bpv2bgsliceColor2", GetGlobalSettingsVector( passAsset, "bpv2bgsliceColor2" ) )

	PrivateData p
	self.Private( p )
	p.OnGRXStateChanged = (void function() : (self, battlepassModelStruct, activePass, passAsset, passType)
		{
			if ( !GRX_IsInventoryReady() )
				return

			if ( !GRX_AreOffersReady() )
				return

			PrivateData p
			self.Private( p )
			p.passLevelRewardsCache.clear()

			entity player = GetLocalClientPlayer()
			bool hasPremiumPass = passType == ePassType.BATTLEPASS && DoesPlayerOwnBattlePassTier( player, activePass, eBattlePassV2OwnershipTier.PREMIUM )

			bool expanded = !((self.PropGetBool( "expandingEnabledController" ) && IsControllerModeActive() && (!self.PropGetBool( "expandingEnabledDnavOnly" ) || GetDpadNavigationActive()) ) || (self.PropGetBool( "expandingEnabledKeyboard" ) && !IsControllerModeActive() ))

			RTKBattlepassControllerPanel_SetUpInspectDetails( self, battlepassModelStruct, activePass )

			if ( !p.grxInitComplete )
			{
				if ( passType in file.passTypeToViewingMode)
				{
					int viewMode = file.passTypeToViewingMode[passType]
					RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, viewMode, expanded, false )
				}
				else
				{
					RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct,
						passType == ePassType.RETURNING_PLAYER ? eBattlepassViewMode.RETURNING_PLAYER
						: passType == ePassType.EVENT ? eBattlepassViewMode.EVENT
						: passType == ePassType.NEWPLAYER ? eBattlepassViewMode.NEWPLAYER
						: DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS ) ? eBattlepassViewMode.ELITE : eBattlepassViewMode.PREMIUM,
						expanded, false
					)
				}
				RTKBattlepassControllerPanel_SetViewTrack( self, battlepassModelStruct, activePass, -1 )
			}

			RTKBattlepassControllerPanel_BuildSummaryModelInfo( self, battlepassModelStruct, activePass )
			if ( passType == ePassType.BATTLEPASS )
			{
				RTKBattlepassControllerPanel_BuildBadgeModelInfo( self, battlepassModelStruct, activePass )
			}
			RTKBattlepassControllerPanel_BuildTrackSelectorModelInfo( self, battlepassModelStruct, activePass )
			RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )

			RTKBattlepassControllerPanel_SetUpPurchaseButton( self, battlepassModelStruct, activePass )

			if ( !p.grxInitComplete )
			{
				RTKBattlepassControllerPanel_SetUpTrackSelectorButtons( self, battlepassModelStruct, activePass )
				RTKBattlepassControllerPanel_SetUpTrackItemButtons( self, battlepassModelStruct, activePass )
				RTKBattlepassControllerPanel_SetUpChallengeButton( self, battlepassModelStruct, activePass )
				RTKBattlepassControllerPanel_SetUpMOTDInput( self )
				RTKBattlepassControllerPanel_SetUpModeChangeInput( self )
				RTKBattlepassControllerPanel_SetUpPaginationPINCallbacks( self )
				RTKBattlepassControllerPanel_SetNavigationRoot( self, eBattlepassNavigationRoot.TRACK_SELECTION )

				thread RTKBattlepassControllerPanel_WaitRecoverLastViewedPage( self, activePass )

				thread RTKBattlepassControllerPanel_WaitShowPass( self )

				p.openedAtTime = int( UITime() )
			}

			p.grxInitComplete = true

			if ( passType == ePassType.NEWPLAYER )
			{
				if ( !player.GetPersistentVar( "hasSeenNPPInfoDialog" ) )
				{
					OpenNewPlayerPassInfo()
				}
				else if ( NPP_IsNPPComplete( player ) && !player.GetPersistentVar( "hasSeenCompletedNPPInfoDialog" ) )
				{
					OpenNewPlayerPassInfo()
				}
			}
			else if ( passType == ePassType.BATTLEPASS )
			{
				ItemFlavor currentSeason = GetLatestSeason( GetUnixTimestamp() )
				string seasonString = ItemFlavor_GetCalEventRef( currentSeason )
				bool isNewSeason = player.GetPersistentVar( "lastHubResetSeason" ) != seasonString
				if ( isNewSeason )
				{
					Remote_ServerCallFunction( "ClientCallback_SetSeasonalHubButtonClickedSeason" )
					if ( !hasPremiumPass )
					{
						OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE_PLUS )
					}
				}

				if ( !Battlepass_TryShowInstantGrants( void function ( int result ) { thread TryDisplayBattlePassAwards( true ) } ) )
				{
					thread TryDisplayBattlePassAwards( true )
				}
			}
		})

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )

	p.inputChangedFunc = void function( bool input ) : ( self ) {
		RTKBattlepassControllerPanel_OnInputModeUpdated( self, true )
	}
	AddUICallback_InputModeChanged( p.inputChangedFunc ) 
	RTKBattlepassControllerPanel_OnInputModeUpdated( self, true )

	p.callbacksInitialised = true
}

void function RTKBattlepassControllerPanel_WaitRecoverLastViewedPage( rtk_behavior self,  ItemFlavor activePass )
{
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassOnHide" )
	WaitSignal( uiGlobal.signalDummy, "RTKBattlepassOnPrizesInstantiated" )
	WaitFrame() 

	int passType = self.PropGetInt( "passType" )
	PrivateData p
	self.Private( p )
	p.paginationAutoScroll = true
	if ( passType in file.passTypeToViewingPage)
	{
		RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), file.passTypeToViewingPage[passType], "pagination_tracker" )
	}
	else
	{
		int battlePassLevel = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )
		RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), (battlePassLevel % p.TRACK_PAGE_SIZE) / 4, "pagination_tracker" )
	}
}

void function RTKBattlepassControllerPanel_WaitShowPass( rtk_behavior self )
{
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassOnHide" )
	WaitFrame() 
	WaitFrame() 
	string eventName = "fadeIn"
	array< rtk_behavior > animators = self.GetPanel().FindBehaviorsByTypeName( "Animator" )
	foreach( rtk_behavior animator in animators)
	{
		if ( RTKAnimator_HasAnimation( animator, eventName ) )
			RTKAnimator_PlayAnimation( animator, eventName )
	}
	RTKPagination_FadeInHint( self.PropGetBehavior("pagination") )
}

void function RTKBattlepassControllerPanel_OnDestroy( rtk_behavior self )
{
	int passType = self.PropGetInt( "passType" )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, GetPassModelName( passType ) )

	RTKBattlepassControllerPanel_DeregisterInput( self )

	PrivateData p
	self.Private( p )
	if ( p.callbacksInitialised )
	{
		RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
		RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
		RemoveUICallback_InputModeChanged( p.inputChangedFunc )
		p.callbacksInitialised = false
	}

	if ( passType in file.passTypeToPass )
		delete file.passTypeToPass[passType]

	
	file.passTypeToViewingPage[passType] <- RTKPagination_GetCurrentPage( self.PropGetBehavior( "pagination" ) )
	file.passTypeToViewingTrack[passType] <- p.viewingTrack
	file.passTypeToViewingMode[passType] <- p.viewMode
}

bool function RTKBattlepassControllerPanel_CanUpdate( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	bool canUpdate = UITime() > p.lastUpdate + p.updateDelay
	return canUpdate
}

void function RTKBattlepassControllerPanel_RegisterInput( rtk_behavior self, rtk_struct battlepassModelStruct, int passType = -1 )
{
	PrivateData p
	self.Private( p )

	if ( !p.inputCBsInitialised )
	{
		p.backFunc = void function( var button ) : ( self ) { RTKBattlepassControllerPanel_OnBack( self, false ) }
		RegisterButtonPressedCallback( BUTTON_B, p.backFunc )
		RegisterButtonPressedCallback( KEY_ESCAPE, p.backFunc )

		if ( passType == ePassType.BATTLEPASS )
		{
			p.toggleEliteFunc = void function( var button ) : ( self ) {
				RTKBattlepassControllerPanel_ToggleElite( self )
			}
			RegisterButtonPressedCallback( MOUSE_MIDDLE, p.toggleEliteFunc )
		}

		p.trackUpFunc = void function( var button ) : ( self, battlepassModelStruct ) { RTKBattlepassControllerPanel_SwitchTrack( self, battlepassModelStruct, -1 ) }
		RegisterButtonPressedCallback( STICK2_UP, p.trackUpFunc )

		p.trackDownFunc = void function( var button ) : ( self, battlepassModelStruct ) { RTKBattlepassControllerPanel_SwitchTrack( self, battlepassModelStruct, 1 ) }
		RegisterButtonPressedCallback( STICK2_DOWN, p.trackDownFunc )
	}

	p.inputCBsInitialised = true
}

void function RTKBattlepassControllerPanel_DeregisterInput( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( p.inputCBsInitialised )
	{
		DeregisterButtonPressedCallback( KEY_ESCAPE, p.backFunc )
		DeregisterButtonPressedCallback( BUTTON_B, p.backFunc )
		if ( p.toggleEliteFunc != null )
		{
			DeregisterButtonPressedCallback( MOUSE_MIDDLE, p.toggleEliteFunc )
		}
		DeregisterButtonPressedCallback( STICK2_UP, p.trackUpFunc )
		DeregisterButtonPressedCallback( STICK2_DOWN, p.trackDownFunc )
	}

	p.inputCBsInitialised = false
}

void function RTKBattlepassControllerPanel_SwitchTrack( rtk_behavior self, rtk_struct battlepassModelStruct, int direction = 0 )
{
	if ( !RTKBattlepassControllerPanel_CanUpdate( self ) )
		return

	PrivateData p
	self.Private( p )

	p.lastUpdate = UITime()

	int passType = self.PropGetInt( "passType" )
	ItemFlavor ornull activePass = GetPass( passType )

	if ( activePass == null )
		return

	expect ItemFlavor(activePass)

	int newViewPage = p.viewingTrack + direction
	if ( newViewPage < 0 )
	{
		return
	}

	rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
	if ( newViewPage >= RTKArray_GetCount( trackSelectors ) )
		return

	rtk_struct trackSelector = RTKArray_GetStruct( trackSelectors, newViewPage )

	if ( !RTKStruct_GetBool( trackSelector, "exists" ) )
		return

	RTKBattlepassControllerPanel_SetViewTrack(self, battlepassModelStruct, activePass, newViewPage)
	RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, eBattlepassViewMode.PREMIUM, true )
	RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )
	p.paginationAutoScroll = true
	RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )

	if ( !self.PropGetBool( "directionalNavEnabled" ) )
		return

	RTKBattlepassControllerPanel_SetNavigationRoot(self, eBattlepassNavigationRoot.PRIZE_TRACK)
}

void function RTKBattlepassControllerPanel_OnInputModeUpdated( rtk_behavior self, bool updateDnav )
{
	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )

	p.isControllerActive = IsControllerModeActive()
	p.isDpadActive = GetDpadNavigationActive()
	rtk_struct battlepassModelStruct = GetPassModel( passType )
	RTKStruct_SetBool(battlepassModelStruct, "isControllerActive", p.isControllerActive )
	RTKStruct_SetBool(battlepassModelStruct, "isDpadActive", p.isDpadActive )

	if ( !self.PropGetBool( "directionalNavEnabled" ) || !updateDnav )
		return

	if ( p.navigationRoot == eBattlepassNavigationRoot.TRACK_SELECTION && ( self.PropGetBool( "expandingEnabledController" ) || self.PropGetBool( "expandingEnabledKeyboard" ) ) )
	{
		if ( !RTKBattlepassControllerPanel_CanUpdate( self ) )
			return

		bool expanded = !((self.PropGetBool( "expandingEnabledController" ) && IsControllerModeActive() && (!self.PropGetBool( "expandingEnabledDnavOnly" ) || GetDpadNavigationActive()) ) || (self.PropGetBool( "expandingEnabledKeyboard" ) && !IsControllerModeActive() ))
		RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, expanded )

		ItemFlavor ornull activePass = GetPass( passType )
		if ( activePass == null )
		{
			return
		}
		expect ItemFlavor( activePass )

		RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )

		RTKBattlepassControllerPanel_SetNavigationRoot(self, p.navigationRoot)
	}
}


void function RTKBattlepassControllerPanel_SetNavigationRoot(rtk_behavior self, int navigationRoot)
{
	if ( !self.PropGetBool( "directionalNavEnabled" ) )
		return

	RTKBattlepassControllerPanel_OnInputModeUpdated( self, false ) 

	int passType = self.PropGetInt( "passType" )
	rtk_struct battlepassModelStruct = GetPassModel( passType )
	RTKStruct_SetInt(battlepassModelStruct, "navigationRoot", navigationRoot )

	if ( navigationRoot == eBattlepassNavigationRoot.TRACK_SELECTION )
	{
		rtk_panel ornull trackSelectorsGrid = self.PropGetPanel( "trackSelectorsGrid" )
		if ( trackSelectorsGrid != null )
		{
			expect rtk_panel( trackSelectorsGrid )
			array< rtk_behavior > dnavs = trackSelectorsGrid.FindBehaviorsByTypeName( "DirectionalNavigation" )
			foreach( dnav in dnavs )
			{
				RTKDirectionalNavigation_OnRootFocused(dnav, false)
				break
			}
		}
		Menus_SetNavigateBackDisabled( false )
	} else if ( navigationRoot == eBattlepassNavigationRoot.PRIZE_TRACK )
	{
		rtk_panel ornull prizeTrackContainer = self.PropGetPanel( "prizeTrackContainer" )
		if ( prizeTrackContainer != null )
		{
			expect rtk_panel( prizeTrackContainer )
			array< rtk_behavior > dnavs = prizeTrackContainer.FindBehaviorsByTypeName( "DirectionalNavigation" )
			foreach( dnav in dnavs )
			{
				RTKDirectionalNavigation_OnRootFocused(dnav, true, true)

				RTKDirectionalNavigation_SetOutOfBoundsLeftCallback(dnav, void function() : ( self )
					{
						rtk_behavior pagination = self.PropGetBehavior( "pagination" )
						RTKPagination_PrevPage( pagination, "pagination_tracker", true )
					}
				)

				RTKDirectionalNavigation_SetOutOfBoundsRightCallback(dnav, void function() : ( self )
					{
						rtk_behavior pagination = self.PropGetBehavior( "pagination" )
						RTKPagination_NextPage( pagination, "pagination_tracker", true )
					}
				)

				break
			}
		}
		Menus_SetNavigateBackDisabled( true )
	}

	PrivateData p
	self.Private( p )
	p.navigationRoot = navigationRoot
}

void function RTKBattlepassControllerPanel_UpdateTrackModel(rtk_behavior self, rtk_struct battlepassModelStruct )
{
	

	RTKBattlepassControllerPanel_OnInputModeUpdated( self, false ) 

	int passType = self.PropGetInt( "passType" )

	PrivateData p
	self.Private( p )

	int chaseItemCount = 0
	asset itemPrefab = $"ui_rtk/menus/battlepass/battlepass_track_item.rpak"
	bool isBattlepassPrizeTrack = p.viewMode == eBattlepassViewMode.FREE || p.viewMode == eBattlepassViewMode.PREMIUM || p.viewMode == eBattlepassViewMode.ELITE || p.viewMode == eBattlepassViewMode.NEWPLAYER
	array< RTKBattlepassTrackLevelStruct > levelsSource

	if ( p.viewMode == eBattlepassViewMode.BATTLEPASS_BADGE || p.viewMode == eBattlepassViewMode.NEWPLAYER_BADGE )
	{
		levelsSource = p.badgeLevels
		itemPrefab = $"ui_rtk/menus/battlepass/battlepass_track_badge.rpak"
	} else if ( isBattlepassPrizeTrack )
	{
		levelsSource = p.trackLevels
	}

	RTKStruct_SetAssetPath(battlepassModelStruct, "prefabItemTrack", itemPrefab )
	RTKStruct_SetAssetPath(battlepassModelStruct, "prefabItemChase", itemPrefab )

	rtk_array trackLevels = RTKDataModel_GetArray( "&menus." + GetPassModelName( passType ) + ".trackLevels")
	rtk_array trackItems = RTKDataModel_GetArray( "&menus." + GetPassModelName( passType ) + ".trackItems" )
	rtk_array chaseLevels = RTKDataModel_GetArray( "&menus." + GetPassModelName( passType ) + ".chaseLevels" )
	rtk_array chaseItems = RTKDataModel_GetArray( "&menus." + GetPassModelName( passType ) + ".chaseItems" )

	RTKArray_Clear( trackLevels )
	RTKArray_Clear( trackItems )
	RTKArray_Clear( chaseLevels )
	RTKArray_Clear( chaseItems )

	array< RTKBattlepassTrackLevelStruct > trackLevelsArr
	array< RTKBattlepassTrackItemStruct > trackItemsArr
	array< RTKBattlepassTrackLevelStruct > chaseLevelsArr
	array< RTKBattlepassTrackItemStruct > chaseItemsArr

	if ( levelsSource.len() > 0 )
	{
		chaseItemCount = levelsSource[levelsSource.len() - 1].chaseItemCount
		if ( !p.expanded )
		{
			chaseItemCount = minint( chaseItemCount, 1 )
		}
		RTKStruct_SetInt(battlepassModelStruct, "trackVisibleLevels", levelsSource.len() - 1)
		RTKStruct_SetInt(battlepassModelStruct, "trackVisibleChaseItems", chaseItemCount )

		for ( int i = 0; i < levelsSource.len(); i++ )
		{
			RTKBattlepassTrackLevelStruct level = levelsSource[i]
			if ( i == levelsSource.len() - 1 )
			{
				level.width = ( level.itemCount * ( level.isBadge ? ( 202 + 14 ) : ( 202 + 14 ) ) ) - 12 
				chaseLevelsArr.push( level )
				for ( int j = 0; j < level.items.len(); j++ )
				{
					RTKBattlepassTrackItemStruct item = level.items[j]
					chaseItemsArr.push( item )
				}
			}
			else
			{
				level.width = ( level.itemCount * ( level.isBadge ? ( 134 + 6 ) : ( 104 + 6 ) ) ) 
				trackLevelsArr.push( level )
				for ( int j = 0; j < level.items.len(); j++ )
				{
					RTKBattlepassTrackItemStruct item = level.items[j]
					if ( j == level.items.len() - 1 )
					{
						item.spacing = 20
					}
					trackItemsArr.push( item )
				}
			}
		}
	}
	else
	{
		RTKStruct_SetInt(battlepassModelStruct, "trackVisibleLevels", 0)
		RTKStruct_SetInt(battlepassModelStruct, "trackVisibleChaseItems", 0 )
	}

	RTKArray_SetValue( trackLevels, trackLevelsArr )
	RTKArray_SetValue( trackItems, trackItemsArr )
	RTKArray_SetValue( chaseLevels, chaseLevelsArr )
	RTKArray_SetValue( chaseItems, chaseItemsArr )

	Signal( uiGlobal.signalDummy, "RTKBattlepassOnUpdate" )
	thread RTKBattlepassControllerPanel_InstantiateTrackItems(self, levelsSource, chaseItemCount, itemPrefab, true)
}

void function RTKBattlepassControllerPanel_InstantiateTrackItems(rtk_behavior self, array< RTKBattlepassTrackLevelStruct > levelsSource,  int chaseItemCount, asset itemPrefab, bool waitFrame = true)
{
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassOnHide" )
	EndSignal( uiGlobal.signalDummy, "RTKBattlepassOnUpdate" )

	if ( waitFrame )
	{
		WaitFrame()  
	}

	Signal( uiGlobal.signalDummy, "RTKBattlepassOnPrizesInstantiated" )
}

void function RTKBattlepassControllerPanel_SetViewMode(rtk_behavior self, rtk_struct battlepassModelStruct, int viewMode, bool expanded = false, bool isClick = true)
{
	PrivateData p
	self.Private( p )

	int passType = self.PropGetInt( "passType" )
	bool isBattlepassPrizeTrack = viewMode == eBattlepassViewMode.FREE || viewMode == eBattlepassViewMode.PREMIUM || viewMode == eBattlepassViewMode.ELITE
	bool wasBattlepassPrizeTrack = p.viewMode == eBattlepassViewMode.FREE || p.viewMode == eBattlepassViewMode.PREMIUM || p.viewMode == eBattlepassViewMode.ELITE

	RTKStruct_SetInt(battlepassModelStruct, "viewingTrack", p.viewingTrack )

	RTKStruct_SetBool(battlepassModelStruct, "enableBadges", passType == ePassType.BATTLEPASS )
	RTKStruct_SetBool(battlepassModelStruct, "enableTrackExplanation", passType == ePassType.NEWPLAYER )
	RTKStruct_SetBool(battlepassModelStruct, "showRightContentHints", viewMode != eBattlepassViewMode.BATTLEPASS_BADGE )

	if ( ( p.viewMode == eBattlepassViewMode.PREMIUM && viewMode == eBattlepassViewMode.ELITE )
		|| ( p.viewMode == eBattlepassViewMode.ELITE && viewMode == eBattlepassViewMode.PREMIUM ))
	{
		rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
		int numTrackSelectors = RTKArray_GetCount(trackSelectors)
		for ( int i = 0 ; i < numTrackSelectors ; i++ )
		{
			rtk_struct trackSelector = RTKArray_GetStruct( trackSelectors, i )
			rtk_struct frontPrize    = RTKStruct_GetStruct( trackSelector, "frontPrize" )
			rtk_struct backPrize    = RTKStruct_GetStruct( trackSelector, "backPrize" )
			RTKStruct_SetBool(trackSelector, "isSelected", p.viewingTrack == i)

			if ( RTKStruct_GetBool( backPrize, "exists" ) )
			{
				RTKBattlepassTrackSelectorPrizeStruct newFrontPrize
				RTKStruct_GetValue( backPrize, newFrontPrize )

				RTKBattlepassTrackSelectorPrizeStruct newBackPrize
				RTKStruct_GetValue( frontPrize, newBackPrize )

				RTKStruct_SetValue( frontPrize, newFrontPrize )
				RTKStruct_SetValue( backPrize, newBackPrize )

				RTKStruct_SetBool(frontPrize, "isSelected", p.viewingTrack == i)
				RTKStruct_SetBool(backPrize, "isSelected", p.viewingTrack == i)
				RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, false )
			}
		}
	}

	p.viewMode = viewMode
	p.expanded = expanded

	file.passTypeToViewingMode[passType] <- p.viewMode

	RTKStruct_SetBool(battlepassModelStruct, "isExpanded", p.expanded )
	RTKStruct_SetInt(battlepassModelStruct, "viewMode", p.viewMode )

	if ( viewMode == eBattlepassViewMode.BATTLEPASS_BADGE )
	{
		rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
		if (RTKArray_GetCount(trackSelectors) > p.viewingTrack && p.viewingTrack >= 0 )
		{
			rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, p.viewingTrack)
			rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")
			rtk_struct backPrize = RTKStruct_GetStruct(trackSelector, "backPrize")
			RTKStruct_SetBool(trackSelector, "isSelected", false)
			RTKStruct_SetBool(frontPrize, "isSelected", false)
			RTKStruct_SetBool(backPrize, "isSelected", false)
			RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, false )
		}

		PIN_UIInteraction_OnBattlepassV2TrackSelected( GetPassPanelName( passType ).tolower(), "badge_track", GetPassModelName( passType ), int( UITime() ) - p.openedAtTime, 0, "" )
	}
}

void function RTKBattlepassControllerPanel_SetViewTrack(rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass, int track = -1, bool wasClick = false)
{
	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )
	bool sendPINEvent = track >= 0

	rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )

	if (RTKArray_GetCount(trackSelectors) > p.viewingTrack && p.viewingTrack >= 0 )
	{
		rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, p.viewingTrack)
		rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")
		rtk_struct backPrize = RTKStruct_GetStruct(trackSelector, "backPrize")
		RTKStruct_SetBool(trackSelector, "isSelected", false)
		RTKStruct_SetBool(frontPrize, "isSelected", false)
		RTKStruct_SetBool(backPrize, "isSelected", false)
		RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, false )
	}

	

	if ( track < 0 )
	{
		if ( passType in file.passTypeToViewingTrack)
		{
			track = file.passTypeToViewingTrack[passType]
			RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, p.expanded )
		}
		else if ( GetLocalClientPlayer() != null )
		{
			EHI playerEHI                      = ToEHI( GetLocalClientPlayer() )
			asset passAsset = ItemFlavor_GetAsset( activePass )
			int currentXP         = GetPassXPProgress( playerEHI, activePass, passType )
			int battlePassLevel   = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )
			int currentPage 	  = minint(battlePassLevel / p.TRACK_PAGE_SIZE, p.MAX_TRACKS - 1) 
			track = currentPage
		}
		else
		{
			track = 0
		}
	}

	p.viewingTrack = track
	file.passTypeToViewingTrack[passType] <- track

	RTKStruct_SetInt(battlepassModelStruct, "viewMode", p.viewMode )
	RTKStruct_SetInt(battlepassModelStruct, "viewingTrack", track )
	RTKStruct_SetString(battlepassModelStruct, "trackNavHintText", Localize("#BATTLEPASS_TRACK_HINT", ( track * ( p.TRACK_PAGE_SIZE ) ) + 1, (track + 1) * p.TRACK_PAGE_SIZE) )
	RTKStruct_SetString(battlepassModelStruct, "trackExplanation", Localize("#NEWPLAYERPASS_TRACK_EXPLANATION_" + track) )

	string trackLevelDescription = "" 
	if (RTKArray_GetCount(trackSelectors) > track )
	{
		rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, track)
		rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")
		rtk_struct backPrize = RTKStruct_GetStruct(trackSelector, "backPrize")
		RTKStruct_SetBool(trackSelector, "isSelected", true)
		RTKStruct_SetBool(frontPrize, "isSelected", true)
		RTKStruct_SetBool(backPrize, "isSelected", true)
		RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, false )
		trackLevelDescription = RTKStruct_GetString( frontPrize, "description" )
	}

	if ( sendPINEvent )
	{
		PIN_UIInteraction_OnBattlepassV2TrackSelected( GetPassPanelName( passType ).tolower(), "prize_track", GetPassModelName( passType ), int( UITime() ) - p.openedAtTime, track, trackLevelDescription )
	}
}

void function RTKBattlepassControllerPanel_BuildBadgeModelInfo( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass)
{
	asset passAsset = ItemFlavor_GetAsset( activePass )

	ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activePass )
	GladCardBadgeDisplayData gcbdd = GetBadgeData( ToEHI( GetLocalClientPlayer() ), null, 0, bpLevelBadge, null, false )
	if ( gcbdd.ruiAsset == $"" )
	{
		gcbdd.ruiAsset = $"ui/gcard_badge_basic.rpak"
		gcbdd.imageAsset = $"rui/gladiator_cards/badge_empty"
	}

	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )

	p.badgeLevels.clear()

	int playerBattlepassLevel = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )
	int battlepassMaxLevel   = GetPassMaxLevelIndex( activePass, passType ) + 1

	for ( int badgeNumber = 1 ; badgeNumber <= battlepassMaxLevel / p.TRACK_PAGE_SIZE ; badgeNumber++ )
	{
		if ( badgeNumber > p.PASS_MAX_LEVELS )
			break

		int badgeBPLevel = badgeNumber * p.TRACK_PAGE_SIZE
		RTKBattlepassTrackLevelStruct badgeLevel
		badgeLevel.level = badgeNumber
		badgeLevel.isOwned = badgeBPLevel <= playerBattlepassLevel + 1
		badgeLevel.isCurrentLevel = badgeLevel.isOwned && ( badgeBPLevel ) + p.TRACK_PAGE_SIZE <= playerBattlepassLevel
		badgeLevel.progress = badgeLevel.isOwned ? 1.0 : playerBattlepassLevel + 10 >= ( badgeBPLevel ) ? ( ( (playerBattlepassLevel + 1) % p.TRACK_PAGE_SIZE ) / float(p.TRACK_PAGE_SIZE) ) : 0.0
		badgeLevel.expanded = false
		badgeLevel.isBadge = true
		badgeLevel.isChaseItem = badgeNumber == battlepassMaxLevel / p.TRACK_PAGE_SIZE
		badgeLevel.isNextLevel = !badgeLevel.isOwned && playerBattlepassLevel + 10 >= ( badgeBPLevel )
		badgeLevel.levelText = Localize("#BATTLEPASS_TRACK_LEVEL", badgeNumber * p.TRACK_PAGE_SIZE)
		badgeLevel.chaseItemCount = 1
		badgeLevel.itemCount = 1

		RTKBattlepassTrackItemStruct itemStruct
		itemStruct.description = ""
		itemStruct.levelReached = badgeLevel.isOwned
		itemStruct.checked = badgeLevel.isOwned
		itemStruct.locked = false
		itemStruct.isBadge = true
		itemStruct.image = $""
		itemStruct.index = badgeNumber
		itemStruct.quality = 0
		itemStruct.quantity = 0
		itemStruct.reverseIndex = 0
		itemStruct.badgeRuiAsset = gcbdd.ruiAsset
		itemStruct.badgeTier = badgeNumber * p.TRACK_PAGE_SIZE
		itemStruct.itemGUID = bpLevelBadge.guid
		itemStruct.expanded = true
		itemStruct.isChaseItem = badgeNumber == battlepassMaxLevel / p.TRACK_PAGE_SIZE
		itemStruct.itemDisplayType = itemStruct.isChaseItem ? 3 : 2
		itemStruct.assetHeight = 124
		itemStruct.assetWidth = 104
		itemStruct.frameColor = <1.0, 1.0, 1.0>
		itemStruct.frameLightness = !itemStruct.levelReached ? blurredTrackPrizeLightness : ownedTrackPrizeLightness
		itemStruct.frameSaturation = 1.0
		itemStruct.spacing = 20

		badgeLevel.items.push(itemStruct)

		p.badgeLevels.push( badgeLevel)
	}
}

void function RTKBattlepassControllerPanel_BuildSummaryModelInfo( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass)
{
	PrivateData p
	self.Private( p )

	EHI playerEHI = ToEHI( GetLocalClientPlayer() )

	asset passAsset = ItemFlavor_GetAsset( activePass )
	int passType = self.PropGetInt( "passType" )

	bool hasPremiumPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM ) : false
	bool hasUltimatePass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE ) : false
	bool hasUltimatePlusPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS ) : false
	int battlePassLevel = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )
	int currentXP = GetPassXPProgress( playerEHI, activePass, passType, false, true )
	int battlePassMaxLevel = GetPassMaxLevelIndex( activePass, passType ) + 1
	bool battlePassCompleted = IsPassComplete( activePass, passType )

	if ( passType == ePassType.BATTLEPASS )
	{
		RTKStruct_SetInt(battlepassModelStruct, "endTime", BattlePassV2_GetFinishUnixTime( activePass ) )
		RTKStruct_SetString(battlepassModelStruct, "motdSubtext", "#BATTLEPASS_MOTD_SUBTEXT" )
	}
	else if ( passType == ePassType.NEWPLAYER )
	{

		RTKStruct_SetInt(battlepassModelStruct, "endTime", 0) 
		RTKStruct_SetString(battlepassModelStruct, "motdSubtext", "#NEWPLAYERPASS_MOTD_SUBTEXT" )

	}

	RTKStruct_SetInt(battlepassModelStruct, "passType", passType )
	RTKStruct_SetString(battlepassModelStruct, "description", GetGlobalSettingsStringAsAsset( passAsset, "aboutPurchaseTitle" ) )

	rtk_struct summaryModel = RTKStruct_GetOrCreateScriptStruct( battlepassModelStruct, "summary", "RTKBattlepassSummaryStruct" )

	RTKBattlepassSummaryStruct summaryData
	summaryData.description = battlePassCompleted ? Localize("#BATTLEPASS_MAX_LEVEL") : Localize("#BATTLEPASS_NEXT_LEVEL")
	summaryData.currentLevel = battlePassLevel + 1
	summaryData.XPLabel = battlePassCompleted ? Localize( "#BATTLEPASS_LEVEL_PROGRESS", p.XP_PER_LEVEL, p.XP_PER_LEVEL ) : Localize( "#BATTLEPASS_LEVEL_PROGRESS", (currentXP % p.XP_PER_LEVEL), p.XP_PER_LEVEL )

	if ( passType == ePassType.BATTLEPASS )
	{
		ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activePass )
		GladCardBadgeDisplayData gcbdd = GetBadgeData( ToEHI( GetLocalClientPlayer() ), null, 0, bpLevelBadge, null, false )
		if ( gcbdd.ruiAsset == $"" )
		{
			gcbdd.ruiAsset = $"ui/gcard_badge_basic.rpak"
			gcbdd.imageAsset = $"rui/gladiator_cards/badge_empty"
		}
		summaryData.badgeAssetPath = gcbdd.ruiAsset
	}

	summaryData.progress = battlePassCompleted ? 1.0 : (currentXP % p.XP_PER_LEVEL) / float( p.XP_PER_LEVEL )
	summaryData.statusLabel = passType == ePassType.NEWPLAYER ? ""
		: hasUltimatePlusPass ?  Localize("#BATTLEPASS_ULTIMATE_PLUS")
		: hasUltimatePass ? Localize("#BATTLEPASS_ULTIMATE")
		: hasPremiumPass ? Localize("#BATTLEPASS_PREMIUM")
		: Localize("#BATTLEPASS_FREE")
	summaryData.levelStarAsset = passType == ePassType.NEWPLAYER ?
		$"ui_image/rui/menu/battlepass/newplayerpass/npp_points_icon.rpak" :
		$"ui_image/rui/menu/buttons/favorite_star.rpak"
	summaryData.levelStarSize = passType == ePassType.NEWPLAYER ? 32 : 24
	summaryData.enableBadges = passType == ePassType.BATTLEPASS
	summaryData.enablePurchaseState = passType == ePassType.BATTLEPASS

	RTKStruct_SetValue( summaryModel, summaryData )

	rtk_behavior ornull badgeViewButton = self.PropGetBehavior( "badgeViewButton" )
	if ( badgeViewButton != null )
	{
		expect rtk_behavior( badgeViewButton )

		self.AutoSubscribe( badgeViewButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, battlepassModelStruct, p ) {
			bool wasBattlepassPrizeTrack = p.viewMode == eBattlepassViewMode.FREE || p.viewMode == eBattlepassViewMode.PREMIUM || p.viewMode == eBattlepassViewMode.ELITE
			if ( wasBattlepassPrizeTrack )
			{
				RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, eBattlepassViewMode.BATTLEPASS_BADGE, true )
				RTKBattlepassControllerPanel_UpdateTrackModel( self, battlepassModelStruct )
				if ( IsControllerModeActive() && GetDpadNavigationActive() )
				{
					RTKBattlepassControllerPanel_SetNavigationRoot( self, eBattlepassNavigationRoot.TRACK_SELECTION )
				}
				p.paginationAutoScroll = true
				RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )
			}
		} )
	}
}

BattlePassReward function RTKBattlepassControllerPanel_GetPassRewardByGUID( rtk_behavior self, SettingsAssetGUID itemGUID, int levelIndex = -1, int prizeIndex = -1, int badgeTier = -1 )
{
	BattlePassReward out

	int passType = self.PropGetInt( "passType" )
	ItemFlavor ornull activePass = GetPass( passType )
	if ( activePass == null )
	{
		return out
	}
	expect ItemFlavor( activePass )

	table<int, array<BattlePassReward> > passRewards = RTKBattlepassControllerPanel_GetPassRewards( self, activePass )

	foreach ( int level, array<BattlePassReward> rewards in passRewards )
	{
		foreach ( int rewardIndex, BattlePassReward bpReward in rewards )
		{
			if ( bpReward.flav.guid == itemGUID )
			{
				if ( ( level == levelIndex || levelIndex == -1 ) && ( rewardIndex == prizeIndex || prizeIndex == -1 ) )
				{
					return bpReward
				}
			}
		}
	}
	return out
}

table<int, array<BattlePassReward> > function RTKBattlepassControllerPanel_GetPassRewards( rtk_behavior self, ItemFlavor pass )
{
	PrivateData p
	self.Private( p )
	if ( p.passLevelRewardsCache.len() > 0 )
		return p.passLevelRewardsCache

	Assert( ItemFlavor_GetType( pass ) == eItemType.battlepass )
	Assert( BattlePassV2_IsV2BattlePass( pass ), "BP asset must be v2 (i.e. define a v2 reward schedule) in order to get v2 rewards." )

	var scheduleDT = BattlePassV2_GetScheduleDatatable( pass )
	int rowIndex = 0
	int numRows = GetDataTableRowCount( scheduleDT )

	table<int, array<BattlePassReward> > passLevelRewards

	while ( rowIndex < numRows )
	{
		asset rewardAsset 	= GetDataTableAsset( scheduleDT, rowIndex, GetDataTableColumnByName( scheduleDT, "reward" ) )
		int rewardQty 		= GetDataTableInt( scheduleDT, rowIndex, GetDataTableColumnByName( scheduleDT, "rewardQty" ) )
		int rewardTier 		= GetDataTableInt( scheduleDT, rowIndex, GetDataTableColumnByName( scheduleDT, "rewardTier" ) )
		bool isChaseReward 	= GetDataTableBool( scheduleDT, rowIndex, GetDataTableColumnByName( scheduleDT, "isChaseReward" ) )
		int currentLevel	= GetDataTableInt( scheduleDT, rowIndex, GetDataTableColumnByName( scheduleDT, "levelIndex" ) )

		if ( currentLevel >= p.PASS_MAX_LEVELS )
			continue

		if ( rewardAsset != $"" )
		{
			if ( IsValidItemFlavorSettingsAsset( rewardAsset ) )
			{
				BattlePassReward reward

				reward.flav = GetItemFlavorByAsset( rewardAsset )
				reward.quantity = rewardQty
				reward = CheckForBattlePassRewardPlaylistOverrides( reward, pass, currentLevel )

				reward.level = currentLevel
				reward.rewardTier = rewardTier
				reward.isChaseReward = isChaseReward

				int originalGUID = ItemFlavor_GetGUID( reward.flav )
				SubstituteBattlePassRewardsForUserRestrictions( GetLocalClientPlayer(), reward )

				int itemType = ItemFlavor_GetType( reward.flav )
				if ( ItemFlavor_GetGUID( reward.flav ) == originalGUID )
				{
					reward.iconOverride = ItemFlavor_GetBattlepassIcon( reward.flav )
					if ( reward.iconOverride == $"" )
					{
						reward.iconOverride = GetGlobalSettingsAsset( rewardAsset, "icon" )
					}
				}
				else if ( itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle ) 
				{
					reward.iconOverride = $"rui/menu/common/currency_crafting"
				}

				

				if ( !(currentLevel in passLevelRewards) )
				{
					passLevelRewards[currentLevel] <- []
				}

				passLevelRewards[currentLevel].append( reward )
			}
		}

		rowIndex++
	}

	
#if DEV
		int passType = self.PropGetInt( "passType" )
		int battlePassMaxLevel = minint( GetPassMaxLevelIndex( pass, passType ), p.TRACK_PAGE_SIZE * p.MAX_TRACKS )
		for ( int i = 0; i < battlePassMaxLevel; i++ )
		{
			if ( !(i in passLevelRewards) )
			{
				Warning("Battlepass missing expected prize level: " + i)
			}
		}
#endif

	p.passLevelRewardsCache = passLevelRewards
	return passLevelRewards
}

void function RTKBattlepassControllerPanel_BuildTrackSelectorModelInfo( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass)
{
	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )

	rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )

	RTKArray_Clear( trackSelectors )

	bool hasPremiumPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM ) : false
	bool hasUltimatePass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE ) : false
	bool hasUltimatePlusPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS ) : false
	int playerBattlePassLevel = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )

	int trackSelectorCount = 0
	bool canInspect = true
	table<int, array<BattlePassReward> > passRewards = RTKBattlepassControllerPanel_GetPassRewards( self, activePass )

	foreach( int level, array<BattlePassReward> rewards in passRewards )
	{
		bool isChaseLevel = (level + 1) % p.TRACK_PAGE_SIZE == 0
		if ( !isChaseLevel )
			continue

		bool hasChaseReward = false
		foreach ( int rewardIndex, BattlePassReward bpReward in rewards )
		{
			if ( bpReward.isChaseReward )
			{
				hasChaseReward = true
				break
			}
		}
		if ( !hasChaseReward )
		{
			Warning("BuildTrackSelectorModelInfo - chase level does not have a chase reward: " + level + " " +  trackSelectorCount)
			continue
		}

		if ( trackSelectorCount >= p.MAX_TRACKS )
		{
			Warning("BuildTrackSelectorModelInfo - MAX_TRACKS exceeded but chase rewards are continuing. level/count: " + level + " " +  trackSelectorCount)
			break
		}

		RTKBattlepassTrackSelectorStruct trackSelector
		trackSelector.index = trackSelectorCount
		trackSelector.isSelected = p.viewingTrack == trackSelectorCount
		trackSelector.exists = true

		int chaseRewardCount = 0
		foreach ( int rewardIndex, BattlePassReward bpReward in rewards )
		{
			if ( !bpReward.isChaseReward )
			{
				Warning("BuildTrackSelectorModelInfo - chase level had a non-chase item. level/index: " + bpReward.level + " " + rewardIndex)
				continue
			}

			if ( chaseRewardCount >= p.MAX_CHASE_ITEMS )
				continue

			chaseRewardCount++

			bool canOwn = (
							(( bpReward.rewardTier == eBattlePassV2RewardTier.PREMIUM ) && hasPremiumPass) ||
							(( bpReward.rewardTier == eBattlePassV2RewardTier.ELITE ) && hasUltimatePlusPass) ||
							( bpReward.rewardTier == eBattlePassV2RewardTier.FREE )
					)
			bool isOwned = ( bpReward.level <= playerBattlePassLevel && canOwn )

			asset prizeImage = bpReward.iconOverride
			if ( prizeImage == $"" )
			{
				prizeImage = CustomizeMenu_GetRewardButtonImage( bpReward.flav )
			}
			

			RTKBattlepassTrackSelectorPrizeStruct prize
			int itemType = ItemFlavor_GetType( bpReward.flav )
			prize.itemType = itemType
			prize.owned = isOwned
			prize.locked = !canOwn
			prize.levelReached = bpReward.level <= playerBattlePassLevel
			prize.assetPath = prizeImage
			prize.frameAssetPath = (bpReward.rewardTier == eBattlePassV2RewardTier.ELITE ? $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_elite_bg.rpak" : $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_chase_bg.rpak")
			prize.assetIconPivot = ( ( itemType == eItemType.apex_coins || itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle ) ) ? <0.5, 0.57, 0> : <0.5, 0.5, 0>
			prize.isEliteItem = bpReward.rewardTier == eBattlePassV2RewardTier.ELITE
			prize.isPremiumItem = bpReward.rewardTier == eBattlePassV2RewardTier.PREMIUM
			prize.isFreeItem = bpReward.rewardTier == eBattlePassV2RewardTier.FREE
			prize.showFreeIndicator = false
			prize.quality =  GRX_GetRarityOverrideFromQuantity( bpReward.flav, maxint( 0, ItemFlavor_GetQuality( bpReward.flav ) ), bpReward.quantity ) 
			prize.quantity = bpReward.quantity

			if ( itemType == eItemType.voucher && prize.quantity <= 1)
			{
				if ( Voucher_GetEffectBattlepassStars( bpReward.flav ) > 0 )
				{
					prize.quantity = Voucher_GetEffectBattlepassStars( bpReward.flav )
				}
			}

			prize.itemGUID = bpReward.flav.guid
			prize.exists = prize.itemGUID > 0
			prize.description = string( bpReward.level + 1 )
			prize.progress = bpReward.level <= playerBattlePassLevel ? 1.0 : playerBattlePassLevel + p.TRACK_PAGE_SIZE >= bpReward.level ? ( ( (playerBattlePassLevel + 1) % p.TRACK_PAGE_SIZE ) / float(p.TRACK_PAGE_SIZE) ) : 0.0
			prize.assetHeight = 132
			prize.assetWidth = 178
			prize.isSelected = p.viewingTrack == trackSelectorCount
			prize.isFocused = false
			prize.frameColor = GetBattlepassRarityColor( prize.quality, prize.isSelected )
			prize.frameLightness = prize.isSelected ? blurredTrackSelectorLightness : inactiveTrackSelectorLightness
			prize.frameSaturation = 0.0

			
			if ( itemType == eItemType.gladiator_card_kill_quip ||
					itemType == eItemType.gladiator_card_intro_quip ||
					itemType == eItemType.character_emote ||
					itemType == eItemType.character ||
					itemType == eItemType.account_pack ||
					itemType == eItemType.gladiator_card_badge ||
					itemType == eItemType.gladiator_card_stance ||
					itemType == eItemType.music_pack
					)
			{
				prize.assetHeight = 126
				prize.assetWidth = 126
			}
			else if ( itemType == eItemType.boost_type || itemType == eItemType.voucher )
			{
				prize.assetHeight = 132
				prize.assetWidth = 111
				if ( itemType == eItemType.voucher )
				{
					if ( Voucher_GetEffectBattlepassStars( bpReward.flav ) > 0 )
					{
						prize.assetHeight = 126
						prize.assetWidth = 126
					}
				}
			}
			else if ( itemType == eItemType.skydive_emote )
			{
				prize.assetHeight = int( prize.assetHeight * 0.85 )
				prize.assetWidth = int( prize.assetWidth * 0.85 )
			}
			else if ( itemType == eItemType.apex_coins || itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle )
			{
				prize.assetHeight = 74
				prize.assetWidth = 74
			}

			prize.secondaryIconAssetPath = $""
			if ( itemType == eItemType.character_emote ||
					itemType == eItemType.gladiator_card_kill_quip ||
					itemType == eItemType.gladiator_card_stat_tracker ||
					itemType == eItemType.gladiator_card_frame ||
					itemType == eItemType.gladiator_card_stance ||
					itemType == eItemType.skydive_emote ||
					itemType == eItemType.emote_icon ||
					itemType == eItemType.gladiator_card_intro_quip)
			{
				prize.secondaryIconAssetPath = GetCharacterIconToDisplay( bpReward.flav )
			}
			else if ( itemType == eItemType.music_pack)
			{
				prize.secondaryIconAssetPath = GetGlobalSettingsAsset( ItemFlavor_GetAsset( activePass ), "smallLogo" )
			}

			if ( !trackSelector.frontPrize.exists && prize.exists )
			{
				trackSelector.frontPrize = prize
			}
			else if ( !trackSelector.backPrize.exists && prize.exists )
			{
				trackSelector.backPrize = prize
			}

			if ( p.viewMode == eBattlepassViewMode.ELITE && bpReward.rewardTier == eBattlePassV2RewardTier.ELITE )
			{
				if ( trackSelector.frontPrize.exists && trackSelector.frontPrize.isPremiumItem )
				{
					trackSelector.backPrize = trackSelector.frontPrize
				}
				trackSelector.frontPrize = prize
			}
		}

		
		if ( canInspect && playerBattlePassLevel + p.TRACK_PAGE_SIZE >= level && playerBattlePassLevel < level && trackSelector.frontPrize.exists )
		{
			RTKBattlepassControllerPanel_InspectItem( self, trackSelector.frontPrize.itemGUID, -1 )
			canInspect = false
		}

		rtk_struct newStruct = RTKArray_PushNewStruct( trackSelectors )
		RTKStruct_SetValue( newStruct, trackSelector )

		trackSelectorCount++
	}

	
	if ( canInspect && trackSelectorCount > 0 )
	{
		rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, trackSelectorCount - 1)
		rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")
		int itemGUID = RTKStruct_GetInt(frontPrize, "itemGUID")
		RTKBattlepassControllerPanel_InspectItem( self, itemGUID, -1 )
		canInspect = false
	}

	while ( trackSelectorCount < p.MAX_TRACKS )
	{
		RTKBattlepassTrackSelectorStruct trackSelector
		trackSelector.index = trackSelectorCount
		trackSelector.isSelected = false
		trackSelector.exists = false
		rtk_struct newStruct = RTKArray_PushNewStruct( trackSelectors )
		RTKStruct_SetValue( newStruct, trackSelector )
		trackSelectorCount++
	}
}

void function RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass)
{
	PrivateData p
	self.Private( p )

	p.trackLevels.clear()

	int passType = self.PropGetInt( "passType" )
	EHI playerEHI = ToEHI( GetLocalClientPlayer() )
	int currentXP = GetPassXPProgress( playerEHI, activePass, passType, false, true )
	bool hasPremiumPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.PREMIUM ) : false
	bool hasUltimatePass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE ) : false
	bool hasUltimatePlusPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS ) : false
	int playerBattlePassLevel = GetPassLevel( GetLocalClientPlayer(), activePass, passType, false )

	table<int, array<BattlePassReward> > passRewards = RTKBattlepassControllerPanel_GetPassRewards( self, activePass )

	int totalTrackRewardCount = 0

	for ( int level = 0; level < passRewards.len(); level++ )
	{
		array<BattlePassReward> rewards = passRewards[level]

		bool isVisible = ( level / p.TRACK_PAGE_SIZE ) == p.viewingTrack

		if ( isVisible )
		{
			RTKBattlepassTrackLevelStruct trackLevel
			trackLevel.level = level + 1
			trackLevel.isOwned = level <= playerBattlePassLevel
			trackLevel.isCurrentLevel = level == playerBattlePassLevel
			trackLevel.isNextLevel = level == playerBattlePassLevel + 1
			trackLevel.levelText = Localize("#BATTLEPASS_TRACK_LEVEL", trackLevel.level)
			trackLevel.progress = level - 1 == playerBattlePassLevel ? (currentXP % p.XP_PER_LEVEL) / float( p.XP_PER_LEVEL ) : trackLevel.isOwned ? 1.0 : 0.0
			trackLevel.expanded = p.expanded
			trackLevel.isBadge = false
			trackLevel.isChaseItem = trackLevel.level % p.TRACK_PAGE_SIZE == 0
			trackLevel.chaseItemCount = 0

			int chaseRewardCount = 0
			for ( int rewardIndex = 0; rewardIndex < rewards.len(); rewardIndex++ )
			{
				BattlePassReward bpReward = rewards[rewardIndex]

				if ( bpReward.isChaseReward != trackLevel.isChaseItem)
				{
					Warning("BuildTrackLevelModelInfo - chase level has non-chase reward or vice versa. level: " + level)
				}

				trackLevel.isChaseItem = trackLevel.isChaseItem || bpReward.isChaseReward

				if ( trackLevel.isChaseItem  )
				{
					if ( chaseRewardCount >= p.MAX_CHASE_ITEMS )
					{
						Warning("BuildTrackLevelModelInfo - MAX_CHASE_ITEMS exceeded but chase rewards are continuing. level/count: " + level + " " +  chaseRewardCount)
						continue
					}
					chaseRewardCount++
				}

				totalTrackRewardCount++

				bool canOwn = (
								(( bpReward.rewardTier == eBattlePassV2RewardTier.PREMIUM ) && hasPremiumPass) ||
								(( bpReward.rewardTier == eBattlePassV2RewardTier.ELITE ) && hasUltimatePlusPass) ||
								( bpReward.rewardTier == eBattlePassV2RewardTier.FREE )
						)
				bool isOwned = ( trackLevel.isOwned && canOwn )

				asset prizeImage = bpReward.iconOverride
				if ( prizeImage == $"" )
				{
					prizeImage = CustomizeMenu_GetRewardButtonImage( bpReward.flav )
				}
				

				RTKBattlepassTrackItemStruct itemStruct
				int itemType = ItemFlavor_GetType( bpReward.flav )
				itemStruct.itemType = itemType
				itemStruct.description = ""
				itemStruct.levelReached = trackLevel.isOwned
				itemStruct.checked = isOwned
				itemStruct.locked = !canOwn
				itemStruct.isBadge = false
				itemStruct.isChaseItem = trackLevel.isChaseItem
				itemStruct.itemDisplayType = trackLevel.isChaseItem ? 1 : 0
				itemStruct.isEliteItem = bpReward.rewardTier == eBattlePassV2RewardTier.ELITE
				itemStruct.isPremiumItem = bpReward.rewardTier == eBattlePassV2RewardTier.PREMIUM
				itemStruct.isFreeItem = bpReward.rewardTier == eBattlePassV2RewardTier.FREE
				itemStruct.showFreeIndicator = bpReward.rewardTier == eBattlePassV2RewardTier.FREE && passType != ePassType.NEWPLAYER && !itemStruct.isChaseItem
				itemStruct.image = prizeImage
				itemStruct.quality = GRX_GetRarityOverrideFromQuantity( bpReward.flav, maxint( 0, ItemFlavor_GetQuality( bpReward.flav ) ), bpReward.quantity ) 
				itemStruct.index = rewardIndex
				itemStruct.reverseIndex = (rewards.len() - rewardIndex) - 1
				itemStruct.badgeRuiAsset = $""
				itemStruct.badgeTier = 1
				itemStruct.expanded = p.expanded
				itemStruct.itemGUID = bpReward.flav.guid
				itemStruct.level = level
				itemStruct.quantity = bpReward.quantity

				if ( itemType == eItemType.voucher && itemStruct.quantity <= 1)
				{
					if ( Voucher_GetEffectBattlepassStars( bpReward.flav ) > 0 )
					{
						itemStruct.quantity = Voucher_GetEffectBattlepassStars( bpReward.flav )
					}
				}

				itemStruct.frameAssetPath = itemStruct.isChaseItem ? $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_chase_bg_extended.rpak"
					: ( itemType == eItemType.apex_coins || itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle ) ? $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_frame_label.rpak"
					: $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_frame_standard.rpak"
				itemStruct.assetIconPositionY = ( ( itemType == eItemType.apex_coins || itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle ) && !itemStruct.isChaseItem ) ? -10 : 0
				itemStruct.eliteFrameAssetPath = bpReward.rewardTier == eBattlePassV2RewardTier.ELITE && itemStruct.isChaseItem ? $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_elite_bg.rpak" : $""
				itemStruct.decorationAssetPath = itemStruct.isChaseItem ?  $"ui_image/rui/menu/battlepass/battlepass_new/bp_reward_chase_fg_decoration.rpak" : $""
				itemStruct.isFocused = false
				itemStruct.frameColor = GetBattlepassRarityColor( itemStruct.quality, !itemStruct.levelReached )
				itemStruct.frameLightness = itemStruct.levelReached ? -0.4 : unownedTrackPrizeLightness
				itemStruct.frameSaturation = 1.0

				itemStruct.secondaryIconAsset = $""
				if ( itemStruct.itemType == eItemType.character_emote ||
						itemType == eItemType.gladiator_card_kill_quip ||
						itemType == eItemType.gladiator_card_stat_tracker ||
						itemType == eItemType.gladiator_card_frame ||
						itemType == eItemType.gladiator_card_stance ||
						itemType == eItemType.skydive_emote ||
						itemType == eItemType.emote_icon ||
						itemType == eItemType.gladiator_card_intro_quip)
				{
					itemStruct.secondaryIconAsset = GetCharacterIconToDisplay( bpReward.flav )
				}
				else if ( itemStruct.itemType == eItemType.music_pack)
				{
					itemStruct.secondaryIconAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( activePass ), "smallLogo" )
				}

				
				itemStruct.assetHeight = trackLevel.isChaseItem ? 148 : 124
				itemStruct.assetWidth = trackLevel.isChaseItem ? 202 : 104

				if ( itemType == eItemType.gladiator_card_kill_quip ||
						itemType == eItemType.gladiator_card_intro_quip ||
						itemType == eItemType.character_emote ||
						itemType == eItemType.character ||
						itemType == eItemType.account_pack ||
						itemType == eItemType.gladiator_card_badge ||
						itemType == eItemType.gladiator_card_stance ||
						itemType == eItemType.music_pack
						)
				{
					itemStruct.assetHeight = trackLevel.isChaseItem ? 118 : 100
					itemStruct.assetWidth = trackLevel.isChaseItem ? 118 : 100
				}
				else if ( itemType == eItemType.boost_type || itemType == eItemType.voucher )
				{
					itemStruct.assetHeight = trackLevel.isChaseItem ? 140 : 119
					itemStruct.assetWidth = trackLevel.isChaseItem ? 118 : 100
					if ( itemType == eItemType.voucher )
					{
						if ( Voucher_GetEffectBattlepassStars( bpReward.flav ) > 0 )
						{
							itemStruct.assetHeight = trackLevel.isChaseItem ? 118 : 100
							itemStruct.assetWidth = trackLevel.isChaseItem ? 118 : 100
						}
					}
				}
				else if ( itemType == eItemType.skydive_emote )
				{
					itemStruct.assetHeight = int( itemStruct.assetHeight * 0.85 )
					itemStruct.assetWidth = int( itemStruct.assetWidth * 0.85 )
				}
				else if ( itemType == eItemType.apex_coins || itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle )
				{
					itemStruct.assetHeight = trackLevel.isChaseItem ? 88 : 74
					itemStruct.assetWidth = trackLevel.isChaseItem ? 88 : 74
				}

				if ( trackLevel.isChaseItem )
				{
					trackLevel.chaseItemCount++
				}

				trackLevel.itemCount++

				trackLevel.items.push( itemStruct )
			}

			p.trackLevels.push ( trackLevel )
		}
	}

	RTKStruct_SetString(battlepassModelStruct, "trackNavRewardsText", Localize("#BATTLEPASS_TRACK_REWARDS", totalTrackRewardCount ) )

	RTKBattlepassControllerPanel_UpdateTrackModel( self, battlepassModelStruct )
}


void function RTKBattlepassControllerPanel_SetUpTrackSelectorButtons( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass )
{
	PrivateData p
	self.Private( p )

	rtk_panel ornull trackSelectorsGrid = self.PropGetPanel( "trackSelectorsGrid" )
	if ( trackSelectorsGrid != null )
	{
		expect rtk_panel( trackSelectorsGrid )

		self.AutoSubscribe( trackSelectorsGrid, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, activePass, battlepassModelStruct, p) {
			array< rtk_behavior > gridItems = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in gridItems )
			{
				self.AutoSubscribe( button, "onHighlightedOrFocused",  void function( rtk_behavior button, int prevState ) : ( self, activePass, newChildIndex, battlepassModelStruct, p ) {
					rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
					if (RTKArray_GetCount(trackSelectors) > newChildIndex )
					{
						rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, newChildIndex)
						rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")

						if ( !RTKStruct_GetBool( trackSelector, "exists" ) )
							return

						if ( !p.expanded && ((self.PropGetBool( "expandingEnabledController" ) && IsControllerModeActive() && (!self.PropGetBool( "expandingEnabledDnavOnly" ) || GetDpadNavigationActive()) ) || (self.PropGetBool( "expandingEnabledKeyboard" ) && !IsControllerModeActive() )) )
						{
							RTKBattlepassControllerPanel_SetViewTrack(self, battlepassModelStruct, activePass, newChildIndex)
							RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, p.expanded )
							RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )
							p.paginationAutoScroll = true
							RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )
						}

						SettingsAssetGUID itemGUID = RTKStruct_GetInt( frontPrize, "itemGUID" )
						RTKBattlepassControllerPanel_InspectItem( self, itemGUID, -1 )

						RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, true )

						RTKBattlepassControllerPanel_OnInputModeUpdated( self, false ) 

						p.focusedItemGUID = itemGUID
						p.focusedTrackSelector = true
					}
				})

				self.AutoSubscribe( button, "onIdle",  void function( rtk_behavior button, int prevState ) : ( self, activePass, newChildIndex, battlepassModelStruct, p ) {
					rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
					if (RTKArray_GetCount(trackSelectors) > newChildIndex )
					{
						rtk_struct trackSelector = RTKArray_GetStruct(trackSelectors, newChildIndex)
						rtk_struct frontPrize = RTKStruct_GetStruct(trackSelector, "frontPrize")

						if ( !RTKStruct_GetBool( trackSelector, "exists" ) )
							return

						RTKBattlepassControllerPanel_SetTrackSelectorColors( self, frontPrize, false )
					}
					p.focusedTrackSelector = false
				})

				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, activePass, newChildIndex, battlepassModelStruct, p ) {
					if ( !RTKBattlepassControllerPanel_CanUpdate( self ) )
						return

					p.lastUpdate = UITime()

					rtk_array trackSelectors = RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackSelectors", "RTKBattlepassTrackSelectorStruct" )
					if (RTKArray_GetCount(trackSelectors) > newChildIndex )
					{
						rtk_struct trackSelector = RTKArray_GetStruct( trackSelectors, newChildIndex )

						if ( !RTKStruct_GetBool( trackSelector, "exists" ) )
							return

						bool isDirectionalNavForward = keycode == BUTTON_A || keycode ==  KEY_ENTER
						RTKBattlepassControllerPanel_SetViewTrack( self, battlepassModelStruct, activePass, newChildIndex, true )
						bool isBattlepassPrizeTrack = p.viewMode == eBattlepassViewMode.FREE || p.viewMode == eBattlepassViewMode.PREMIUM || p.viewMode == eBattlepassViewMode.ELITE
						if ( !isBattlepassPrizeTrack )
						{
							RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, eBattlepassViewMode.PREMIUM, true )
						}
						else
						{
							RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, true )
						}
						RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )
						if ( isDirectionalNavForward && IsControllerModeActive() && GetDpadNavigationActive() )
						{
							RTKBattlepassControllerPanel_SetNavigationRoot( self, eBattlepassNavigationRoot.PRIZE_TRACK )
						}
						p.paginationAutoScroll = true
						RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )
					}
				} )
			}
		} )
	}

	rtk_behavior ornull trackSelectorsListBinder = self.PropGetBehavior( "trackSelectorsListBinder" )
	if ( trackSelectorsListBinder != null )
	{
		expect rtk_behavior( trackSelectorsListBinder )

		self.AutoSubscribe( trackSelectorsListBinder, "onUpdatedList", function (  ) : ( self, activePass, battlepassModelStruct, p) {
			RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, p.expanded )
		} )
	}
}


void function RTKBattlepassControllerPanel_SetUpTrackItemButtons( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass )
{
	array<string> itemGrids = ["trackItemsGrid", "trackItemsGrid2"]

	foreach ( int gridIndex, string gridName in itemGrids )
	{
		rtk_panel ornull trackItemsGrid = self.PropGetPanel( gridName )

		if ( trackItemsGrid != null )
		{
			expect rtk_panel( trackItemsGrid )

			self.AutoSubscribe( trackItemsGrid, "onChildAdded", function ( rtk_panel newItemChild, int newItemChildIndex ) : ( self, battlepassModelStruct, activePass, gridIndex) {

				array< rtk_behavior > gridItems = newItemChild.FindBehaviorsByTypeName( "Button" )
				foreach( button in gridItems )
				{
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newItemChildIndex, battlepassModelStruct, activePass, gridIndex ) {
						PrivateData p
						self.Private( p )
						if ( !p.expanded )
						{
							RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, true )
							RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )
							p.paginationAutoScroll = true
							RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )
						}
						else
						{
							if ( keycode == MOUSE_RIGHT )
							{
								if ( IsValidItemFlavorGUID( p.focusedItemGUID  ) && PassCanEquipReward( GetItemFlavorByGUID( p.focusedItemGUID ) ) )
								{
									PassEquipReward( p.focusedItemGUID )
								}
							}
							else
							{
								RTKBattlepassControllerPanel_FindAndInspectItem( self, newItemChildIndex, gridIndex == 1, true )
							}
						}
					} )

					self.AutoSubscribe( button, "onHighlightedOrFocused", function( rtk_behavior button, int prevState ) : ( self, newItemChildIndex, battlepassModelStruct, gridIndex ) {
						PrivateData p
						self.Private( p )
						p.focusedTrack = true
						RTKBattlepassControllerPanel_FindAndInspectItem( self, newItemChildIndex, gridIndex == 1, false )
						RTKBattlepassControllerPanel_SetFocusedTrackItem( self, newItemChildIndex, gridIndex == 1, true )

						RTKBattlepassControllerPanel_OnInputModeUpdated( self, false ) 
					} )

					self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self, newItemChildIndex, battlepassModelStruct, gridIndex ) {
						PrivateData p
						self.Private( p )
						p.focusedTrack = false
						RTKBattlepassControllerPanel_SetFocusedTrackItem( self, newItemChildIndex, gridIndex == 1, false )
					} )
				}
			})
		}
		else
		{
			Warning("SetUpTrackItemButtons: No Grid buttons for", gridName, gridIndex)
		}
	}
}

void function RTKBattlepassControllerPanel_SetUpPurchaseButton( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass )
{
	int passType = self.PropGetInt( "passType" )
	entity player = GetLocalClientPlayer()
	bool hasPremiumPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( player, activePass, eBattlePassV2OwnershipTier.PREMIUM ) : false
	bool hasUltimatePass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( player, activePass, eBattlePassV2OwnershipTier.ULTIMATE ) : false
	bool hasUltimatePlusPass = passType == ePassType.BATTLEPASS ? DoesPlayerOwnBattlePassTier( player, activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS ) : false
	bool battlePassCompleted = IsPassComplete( activePass, passType )
	bool canPurchaseLevels = !battlePassCompleted && PassCanBuyUpToLevel( passType )
	bool isRestricted = GRX_IsOfferRestricted( player )

	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	if ( purchaseButton != null )
	{
		expect rtk_behavior( purchaseButton )

		bool canUpgradePass = !isRestricted ? !hasUltimatePlusPass : !hasPremiumPass
		RTKStruct_SetBool(battlepassModelStruct, "enablePurchaseButton", passType == ePassType.BATTLEPASS && (canUpgradePass || canPurchaseLevels) )
		RTKStruct_SetString(battlepassModelStruct, "purchaseButtonText",
			Localize( !hasPremiumPass ? "#BATTLEPASS_BUY_PASS" :
			canUpgradePass ? "#BATTLEPASS_UPGRADE_PASS" :
			"#BATTLEPASS_BUY_LEVELS")
		)

		self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, isRestricted, canUpgradePass, battlePassCompleted ) {
			Menus_SetNavigateBackDisabled( false )
			if ( canUpgradePass )
			{
				CloseActiveMenu()
				SetCurrentTabForPIN( "PassPanel" )
				if ( isRestricted )
				{
					OpenBattlepassPurchaseMenu( ePassPurchaseTab.PREMIUM )
				}
				else
				{
					OpenBattlepassPurchaseMenu( ePassPurchaseTab.ULTIMATE_PLUS )
				}
			}
			else if ( !battlePassCompleted )
			{
				BattlePass_PurchaseButton_OnActivate( null )
			}
		} )
	}
}

void function RTKBattlepassControllerPanel_SetUpPaginationPINCallbacks( rtk_behavior self )
{
	int passType = self.PropGetInt( "passType" )
	PrivateData p
	self.Private( p )

	rtk_behavior ornull pagination = self.PropGetBehavior( "pagination" )
	if ( pagination != null )
	{
		expect rtk_behavior(pagination)

		self.AutoSubscribe( pagination, "onScrollStarted", function () : ( self, pagination, p, passType ) {
			p.lastUpdate = UITime()
			p.paginationStartPage =  RTKPagination_GetCurrentPage( pagination )

			bool pagesToRight = RTKPagination_GetTargetPage( pagination ) < RTKPagination_GetTotalPages( pagination ) - 1

			rtk_array chaseLevels = RTKStruct_GetOrCreateScriptArrayOfStructs( GetPassModel( passType ), "chaseLevels", "RTKBattlepassTrackLevelStruct" )
			int chaseLevelsCount = RTKArray_GetCount( chaseLevels )
			for ( int i = 0; i < chaseLevelsCount; i++ )
			{
				rtk_struct chaseLevel = RTKArray_GetStruct(chaseLevels, i)
				RTKStruct_SetBool(chaseLevel, "pagesToRight", pagesToRight )
			}
		} )

		self.AutoSubscribe( pagination, "onScrollFinished", function () : ( self, pagination, p, passType ) {
			p.paginationCurrentPage =  RTKPagination_GetCurrentPage( pagination )
			if ( !p.paginationAutoScroll )
			{
				PIN_UIInteraction_OnBattlepassV2PaginationScroll( GetPassPanelName( passType ).tolower(), GetPassModelName( passType ), p.paginationCurrentPage, int( UITime() ) - p.openedAtTime )
			}
			p.paginationAutoScroll = false
		} )
	}
}

void function RTKBattlepassControllerPanel_SetUpModeChangeInput( rtk_behavior self )
{
	rtk_behavior ornull trackSelectorCursorInteract = self.PropGetBehavior( "trackSelectorCursorInteract" )
	if ( trackSelectorCursorInteract != null)
	{
		expect rtk_behavior( trackSelectorCursorInteract )

		
		RTKCursorInteract_AutoSubscribeOnHoverEnterListener( self, trackSelectorCursorInteract,
			void function() : ( self, trackSelectorCursorInteract )
			{
				PrivateData p
				self.Private( p )
				p.lastActiveCursorInteract = trackSelectorCursorInteract
				RTKPagination_DeregisterGlobalInput( self.PropGetBehavior("pagination") )
				RTKPagination_FadeOutHint( self.PropGetBehavior("pagination") )
			}
		)

		RTKCursorInteract_AutoSubscribeOnHoverLeaveListener( self, trackSelectorCursorInteract,
			void function() : ( self, trackSelectorCursorInteract )
			{
				PrivateData p
				self.Private( p )
				if ( p.lastActiveCursorInteract != trackSelectorCursorInteract)
					return
				RTKPagination_RegisterGlobalInput( self.PropGetBehavior("pagination") )
				RTKPagination_FadeInHint( self.PropGetBehavior("pagination") )
			}
		)

		RTKCursorInteract_AutoSubscribeMouseWheeledListener( self, trackSelectorCursorInteract,
			void function( float delta ) : ( self )
			{
				RTKBattlepassControllerPanel_ToggleElite( self )
			}
		)

		RTKCursorInteract_AutoSubscribeOnKeyCodePressedListener( self, trackSelectorCursorInteract,
			void function( int code ) : ( self )
			{
				if ( code == STICK2_RIGHT || code == STICK2_LEFT)
				{
					RTKBattlepassControllerPanel_ToggleElite( self )
				}
			}
		)
	}
}

void function RTKBattlepassControllerPanel_SetUpMOTDInput( rtk_behavior self )
{
	rtk_behavior ornull motdCursorInteract = self.PropGetBehavior( "motdCursorInteract" )
	rtk_behavior ornull carousel = self.PropGetBehavior( "carousel" )
	if ( motdCursorInteract != null && carousel != null )
	{
		expect rtk_behavior( motdCursorInteract )
		expect rtk_behavior( carousel )

		
		RTKCursorInteract_AutoSubscribeOnHoverEnterListener( self, motdCursorInteract,
			void function() : ( self, motdCursorInteract )
			{
				PrivateData p
				self.Private( p )
				p.lastActiveCursorInteract = motdCursorInteract
				RTKPagination_DeregisterGlobalInput( self.PropGetBehavior("pagination") )
				RTKPagination_FadeOutHint( self.PropGetBehavior("pagination") )
			}
		)

		RTKCursorInteract_AutoSubscribeOnHoverLeaveListener( self, motdCursorInteract,
			void function() : ( self, motdCursorInteract )
			{
				PrivateData p
				self.Private( p )
				if ( p.lastActiveCursorInteract != motdCursorInteract)
					return
				RTKPagination_RegisterGlobalInput( self.PropGetBehavior("pagination") )
				RTKPagination_FadeInHint( self.PropGetBehavior("pagination") )
			}
		)

		RTKCursorInteract_AutoSubscribeMouseWheeledListener( self, motdCursorInteract,
			void function( float delta ) : ( self, carousel )
			{
				RTKBattlepassCarouselController_AdvanceCarousel( carousel, int( delta * -1 ) )
			}
		)

		RTKCursorInteract_AutoSubscribeOnKeyCodePressedListener( self, motdCursorInteract,
			void function( int code ) : ( self, carousel )
			{
				if ( code == STICK2_RIGHT)
				{
					RTKBattlepassCarouselController_AdvanceCarousel( carousel, 1 )
				}
				else if ( code == STICK2_LEFT)
				{
					RTKBattlepassCarouselController_AdvanceCarousel( carousel, -1 )
				}
			}
		)
	}
}

void function RTKBattlepassControllerPanel_SetUpChallengeButton( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass )
{
	int passType = self.PropGetInt( "passType" )

	rtk_behavior ornull challengeButton = self.PropGetBehavior( "challengeButton" )
	if ( challengeButton != null )
	{
		expect rtk_behavior( challengeButton )

		RTKStruct_SetBool(battlepassModelStruct, "enableChallengesButton", passType == ePassType.NEWPLAYER )

		self.AutoSubscribe( challengeButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			Menus_SetNavigateBackDisabled( false )
			JumpToChallenges( "beginner" )
		} )
	}
}

bool function RTKBattlepassControllerPanel_OnBack( rtk_behavior self, bool isClick = false )
{
	PrivateData p
	self.Private( p )

	if ( !RTKBattlepassControllerPanel_CanUpdate( self ) )
		return false

	p.lastUpdate = UITime()

	bool expandingEnabled = (((self.PropGetBool( "expandingEnabledController" )) && IsControllerModeActive() && (!self.PropGetBool( "expandingEnabledDnavOnly" ) || GetDpadNavigationActive()) ) || (self.PropGetBool( "expandingEnabledKeyboard" ) && !IsControllerModeActive() ))
	bool directionalNavEnabled = self.PropGetBool( "directionalNavEnabled" )

	if ( ( p.expanded && expandingEnabled) || ( directionalNavEnabled && p.navigationRoot == eBattlepassNavigationRoot.PRIZE_TRACK  ) )
	{
		int passType = self.PropGetInt( "passType" )
		rtk_struct battlepassModelStruct = GetPassModel( passType )

		ItemFlavor ornull activePass = GetPass( passType )

		if ( activePass == null )
		{
			return false
		}
		expect ItemFlavor( activePass )

		RTKBattlepassControllerPanel_SetViewMode( self, battlepassModelStruct, p.viewMode, expandingEnabled ? false : p.expanded )
		RTKBattlepassControllerPanel_BuildTrackLevelModelInfo( self, battlepassModelStruct, activePass )
		RTKBattlepassControllerPanel_SetNavigationRoot( self, eBattlepassNavigationRoot.TRACK_SELECTION )
		p.paginationAutoScroll = true
		RTKPagination_GoToPage( self.PropGetBehavior( "pagination" ), 0, "pagination_tracker" )
		return true
	} else if ( isClick )
	{
		UICodeCallback_NavigateBack()
	}

	return false
}

void function RTKBattlepassControllerPanel_ToggleElite( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if ( !RTKBattlepassControllerPanel_CanUpdate( self ) )
		return

	p.lastUpdate = UITime()

	int passType = self.PropGetInt( "passType" )
	rtk_struct battlepassModelStruct = GetPassModel( passType )

	if ( p.viewMode != eBattlepassViewMode.ELITE )
	{
		RTKBattlepassControllerPanel_SetViewMode(self, battlepassModelStruct, eBattlepassViewMode.ELITE, p.expanded)
	}
	else
	{
		RTKBattlepassControllerPanel_SetViewMode(self, battlepassModelStruct, eBattlepassViewMode.PREMIUM, p.expanded)
	}
}

void function RTKBattlepassControllerPanel_FindAndInspectItem( rtk_behavior self, int newItemChildIndex, bool isChase = false, bool fullscreen = false )
{
	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )

	rtk_struct battlepassModelStruct = GetPassModel( passType )
	rtk_array trackItems = !isChase
		? RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackItems", "RTKBattlepassTrackLevelStruct" )
		: RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "chaseItems", "RTKBattlepassTrackLevelStruct" )

	if ( RTKArray_GetCount(trackItems) > newItemChildIndex )
	{
		rtk_struct item = RTKArray_GetStruct(trackItems, newItemChildIndex )
		SettingsAssetGUID itemGUID = RTKStruct_GetInt( item, "itemGUID" )
		p.focusedItemGUID = itemGUID
		p.focusedLevel = RTKStruct_GetInt(item, "level" )
		p.focusedIndex = RTKStruct_GetInt(item, "index" )
		RTKBattlepassControllerPanel_InspectItem( self, itemGUID, RTKStruct_GetInt( item, "badgeTier" ), fullscreen, p.focusedLevel, p.focusedIndex )
	}
}

void function RTKBattlepassControllerPanel_SetTrackSelectorColors( rtk_behavior self, rtk_struct trackSelector, bool isFocused = true )
{
	RTKStruct_SetBool( trackSelector, "isFocused", isFocused )

	bool isSelected = RTKStruct_GetBool( trackSelector, "isSelected" )
	bool levelReached = RTKStruct_GetBool( trackSelector, "levelReached" )
	int quality = RTKStruct_GetInt( trackSelector, "quality" )
	vector frameColor = GetBattlepassRarityColor( quality, ( isFocused || isSelected ) )

	float frameLightness = 0.0
	if ( !isFocused && !isSelected )
	{
		frameLightness = inactiveTrackSelectorLightness
	}
	else if ( !isFocused )
	{
		frameLightness = blurredTrackSelectorLightness
	}

	RTKStruct_SetFloat3( trackSelector, "frameColor", frameColor )
	RTKStruct_SetFloat( trackSelector, "frameLightness", frameLightness)
	RTKStruct_SetFloat( trackSelector, "frameSaturation", 1.0 )
}

void function RTKBattlepassControllerPanel_SetTrackItemColors( rtk_struct item, bool isFocused = false, bool isBadge = false )
{
	RTKStruct_SetBool( item, "isFocused", isFocused )

	bool levelReached = RTKStruct_GetBool( item, "levelReached" )
	int quality = RTKStruct_GetInt( item, "quality" )
	vector frameColor = GetBattlepassRarityColor( quality, ( isFocused || !levelReached ) )

	float frameLightness = 0.0
	if ( !isFocused && levelReached )
	{
		frameLightness = ownedTrackPrizeLightness
	}
	else if ( !isFocused )
	{
		frameLightness = isBadge ? blurredTrackPrizeLightness : unownedTrackPrizeLightness
	}

	RTKStruct_SetFloat3( item, "frameColor", frameColor )
	RTKStruct_SetFloat( item, "frameLightness", frameLightness)
	RTKStruct_SetFloat( item, "frameSaturation", 1.0 )
}

void function RTKBattlepassControllerPanel_SetFocusedTrackItem( rtk_behavior self, int newItemChildIndex, bool isChase = false, bool isFocused = true )
{
	PrivateData p
	self.Private( p )
	int passType = self.PropGetInt( "passType" )

	rtk_struct battlepassModelStruct = GetPassModel( passType )
	rtk_array trackItems = !isChase
		? RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "trackItems", "RTKBattlepassTrackLevelStruct" )
		: RTKStruct_GetOrCreateScriptArrayOfStructs( battlepassModelStruct, "chaseItems", "RTKBattlepassTrackLevelStruct" )

	if ( RTKArray_GetCount(trackItems) > newItemChildIndex && newItemChildIndex >= 0 )
	{
		rtk_struct item = RTKArray_GetStruct(trackItems, newItemChildIndex)
		RTKBattlepassControllerPanel_SetTrackItemColors( item, isFocused, p.viewMode == eBattlepassViewMode.BATTLEPASS_BADGE )
	}
}

void function RTKBattlepassControllerPanel_InspectItem(rtk_behavior self, int itemGUID, int badgeTier = -1, bool fullscreen = false, int levelIndex = -1, int prizeIndex = -1)
{
	if ( IsValidItemFlavorGUID( itemGUID ) )
	{
		PrivateData p
		self.Private( p )
		int passType = self.PropGetInt( "passType" )
		BattlePassReward inspectedItemReward = RTKBattlepassControllerPanel_GetPassRewardByGUID( self, itemGUID, levelIndex, prizeIndex, badgeTier )
		if ( !IsItemFlavorStructValid( inspectedItemReward.flav.guid, eValidation.DONT_ASSERT ) )
		{
			inspectedItemReward.flav = GetItemFlavorByGUID( itemGUID )
		}

		if ( fullscreen )
		{
			Menus_SetNavigateBackDisabled( false )

			ItemFlavor inspectedItem = GetItemFlavorByGUID( itemGUID )
			inspectedItemReward.flav = inspectedItem
			inspectedItemReward.tier = badgeTier
			if ( ItemFlavor_GetType( inspectedItem ) == eItemType.loadscreen )
			{
				LoadscreenPreviewMenu_SetLoadscreenToPreview( inspectedItem )
				AdvanceMenu( GetMenu( "LoadscreenPreviewMenu" ) )
			}
			else if ( InspectItemTypePresentationSupported( inspectedItem ) )
			{
				RunClientScript( "ClearBattlePassItem" )
				SetBattlePassItemPresentationModeActive( inspectedItemReward )
			}

			string passModelName = GetPassModelName( passType )
			string offerName = ItemFlavor_GetAssetShortName( inspectedItem )
			PIN_UIInteraction_OnBattlepassV2ItemSelected( GetPassPanelName( passType ).tolower(), passModelName, int( UITime() ) - p.openedAtTime, offerName )
		}
		else
		{
			bool isNxHH = false
#if PC_PROG_NX_UI
				isNxHH = IsNxHandheldMode()
#endif
			RunClientScript( "UIToClient_ItemPresentation", itemGUID , badgeTier, 1.19, Battlepass_ShouldShowLow( GetItemFlavorByGUID( itemGUID ) ), GetLoadscreenPreviewBox(), true, "battlepass_center_ref", isNxHH, false, false, true, <20, 0, 0.0> )
			RTKItemDetailsControllerPanel_SetItem( expect rtk_behavior( p.itemDetailsControllerBehavior ), inspectedItemReward, "menus", "itemDetails", passType == ePassType.BATTLEPASS )
		}
	}
}

void function RTKBattlepassControllerPanel_SetUpInspectDetails( rtk_behavior self, rtk_struct battlepassModelStruct, ItemFlavor activePass )
{
	PrivateData p
	self.Private( p )

	rtk_panel ornull inspectDetails = self.PropGetPanel( "inspectDetails" )
	if ( inspectDetails != null )
	{
		expect rtk_panel( inspectDetails )
		p.itemDetailsControllerBehavior = inspectDetails.GetBehaviorByIndex(0)
	}
	else
	{
		Warning("SetUpInspectDetails: No inspect panel")
	}
}