
global function InitChallengesGenericInspectMenu
global function RTKChallengesGenericInspectPanel_OnInitialize
global function RTKChallengesGenericInspectPanel_OnDestroy
global function OpenChallengesGenericInspectPanel
global function RTKChallengeGenericInspectPanel_OnBackPressed
global function RTKChallengesPanel_BuildBaseDataModel
global function RTKChallengesPanel_GetTimerDisplayTimestamp
global function RTKChallengesPanel_GetTimerDisplayString

global struct RTKChallengesGenericInspectPanel_Properties
{
	rtk_behavior slidingListInspectBehavior

	rtk_panel blocksParent
	rtk_behavior itemListPrefabInstantiator
	rtk_panel paginationNav
	rtk_behavior deeplinkButton

	rtk_behavior blocksScrollView
}

global struct RTKChallengesPaginationPip
{
	bool isActive
	bool isCompleted
	bool isLocked
}

global struct RTKChallengesGenericInspectPanelModel
{
	string title
	int endTime
	int displayType
	int challengeBlockIndex
	string linkType
	string link
	string deeplinkLabel
	asset deeplinkIcon
	string timerDisplayString
	string currentBlockProgress
	bool showTimer

	array<RTKChallengesPaginationPip> navPipArray
}

struct
{
	InputDef& returnDef
	InputDef& aButtonDef
	InputDef& yButtonDef
	InputDef& xButtonDef

	var menu
	var loadscreenPreviewBox
	int category
	bool blockEscKey

	int                  lastHighlightedBlockIndex = -1
	bool                 wasInspectingChallengeList
	bool                 isInstantChallengeListView
	rtk_behavior ornull slidingListBehavior
	ChallengeTile ornull tileData
	bool                 isOverAReRollButton = false
	float                lastBlockScrollViewStep
	float                lastChallengeScrollViewStep
} file

struct
{
	string menuName
	int openTimestamp
	int openDuration
	string fromId
	string clickType = "button"
	string challenge_tile
	string challenge_block
	string challenge_id
	bool is_narrative_challenge

} fileTelemetry

struct PrivateData
{
	int blockIndexPropertyListener
	int highlightedItems = 0
	rtk_behavior ornull challengesScrollView
	void functionref() OnTileUpdate
	rtk_struct panelStruct
}

enum eChallengesBlockDisplayTemplate
{
	CHALLENGES_SIMPLE_LIST_TEMPLATE
}
const table<int, string> CHALLENGES_BLOCK_DISPLAY_TYPE_LIST_TYPE_MAP =
{
	[ eChallengesBlockDisplayTemplate.CHALLENGES_SIMPLE_LIST_TEMPLATE ] = "ChallengesSimpleListTemplate"
}

const string CHALLENGES_GENERIC_INSPECT_MODEL_NAME = "challengesGenericInspectPanel"



void function InitChallengesGenericInspectMenu( var menu )
{
	file.menu = menu
	file.loadscreenPreviewBox = Hud_GetChild( menu, "LoadscreenPreviewBox" )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, ChallengesTileGenericInspectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, ChallengesTileGenericInspectMenu_OnHide )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ChallengesTileGenericInspectMenu_OnNavigateBack )
	file.returnDef = AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", RTKChallengeGenericInspectPanel_OnBackPressed )
	file.aButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "", "" )
	file.yButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "", "" )
	file.xButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "", "" )
	RegisterSignal( "OnChallengeBlockIdle" )
}

void function ChallengesTileGenericInspectMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )

	
	switch ( file.category )
	{
		case eChallengeTileCategory.BEGINNER:
			return
		case eChallengeTileCategory.EVENT:
		case eChallengeTileCategory.TRACKED:
		case eChallengeTileCategory.DAILY:
		case eChallengeTileCategory.WEEKLY:
			return
	}
}

void function ChallengesTileGenericInspectMenu_OnHide()
{

}

void function ChallengesTileGenericInspectMenu_OnNavigateBack()
{
	RTKChallengeGenericInspectPanel_OnBackPressed( null )
}

void function RTKChallengeGenericInspectPanel_OnBackPressed( var button )
{
	if ( file.slidingListBehavior == null )
		return

	rtk_behavior slidingListBehavior = expect rtk_behavior ( file.slidingListBehavior )

	if ( !file.blockEscKey || file.isInstantChallengeListView )
	{
		RunClientScript( "ClearBattlePassItem" )
		RTKChallengesPanel_CloseMenuAndSendPin()
	}
	else if ( RTKSlidingListInspect_IsInspectingItemList( slidingListBehavior ) )
	{
		RTKSlidingListInspect_OnBlockListInspect( slidingListBehavior )
	}

	file.wasInspectingChallengeList = false
}

void function RTKChallengesGenericInspectPanel_OnInitialize( rtk_behavior self )
{
	if ( file.tileData == null )
		return

	PrivateData p
	self.Private( p )

	p.panelStruct = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, CHALLENGES_GENERIC_INSPECT_MODEL_NAME, "RTKChallengesGenericInspectPanelModel" )
	string pathToPanelModel = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, CHALLENGES_GENERIC_INSPECT_MODEL_NAME, true )
	self.GetPanel().SetBindingRootPath( pathToPanelModel )
	RTKChallengesPanel_BuildBaseDataModel( p.panelStruct, pathToPanelModel )

	p.blockIndexPropertyListener = RTKStruct_AddPropertyListener( p.panelStruct, "challengeBlockIndex", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKChallengesGenericInspectPanel_OnBlockIndexUpdated( self, expect int( propValue ) )
	} )

	p.OnTileUpdate = void function() : ( self ) {
		RTKChallengesGenericInspectPanel_OnTileUpdate( self )
		RTKChallengesPanel_RestoreMenuState( self )
	}

	RTKChallengesPanel_SetSlidingListBehavior( self )
	RTKChallengesPanel_SetBlockButtons( self )
	RTKChallengesPanel_SetChallengeItemButtons( self )
	RTKChallengesPanel_SetDeeplinkButton( self )
	RTKChallengesPanel_SetBreadcrumbHeader( self )
	RTKChallengesPanel_HandleInstantViewBlocks()
	RTKChallengesPanel_RestoreMenuState( self )

	AddCallback_OnChallengeTileAdded( p.OnTileUpdate )
	fileTelemetry.openTimestamp = int( UITime() )
}

void function RTKChallengesGenericInspectPanel_OnTileUpdate( rtk_behavior self )
{
	if ( file.tileData == null )
		return
	PrivateData p
	self.Private( p )

	p.panelStruct = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, CHALLENGES_GENERIC_INSPECT_MODEL_NAME, "RTKChallengesGenericInspectPanelModel" )
	string pathToPanelModel = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, CHALLENGES_GENERIC_INSPECT_MODEL_NAME, true )

	ChallengeTile tileData = expect ChallengeTile(file.tileData)
	array<ChallengeTile> activeTileData = ChallengeTile_GetActiveTilesSorted()
	foreach ( ChallengeTile newTile in activeTileData )
	{
		if ( tileData.tileId == newTile.tileId )
		{
			file.tileData = newTile
			break
		}
	}

	rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
	if ( RTKSlidingListInspect_IsInspectingItemList( slidingListInspect ) )
		RTKBreadcrumbHeader_RemoveStep()

	p.blockIndexPropertyListener = RTKStruct_AddPropertyListener( p.panelStruct, "challengeBlockIndex", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKChallengesGenericInspectPanel_OnBlockIndexUpdated( self, expect int( propValue ) )
	} )

	RTKChallengesPanel_BuildBaseDataModel( p.panelStruct, pathToPanelModel )
}

void function RTKChallengesGenericInspectPanel_OnBlockIndexUpdated( rtk_behavior self, int blockIndex )
{
	PrivateData p
	self.Private( p )

	rtk_array pipArray = RTKStruct_GetArray( p.panelStruct, "navPipArray" )

	for ( int i = 0; i < RTKArray_GetCount( pipArray ); i++ )
	{
		rtk_struct pipStruct = RTKArray_GetStruct( pipArray, i )
		RTKStruct_SetBool( pipStruct, "isActive", i == blockIndex )
	}

	if ( file.blockEscKey ) 
	{
		string blockTitle = RTKChallengesPanel_GetCurrentBlockTitle( self, p.panelStruct )
		RTKChallengesPanel_SetPageTitle( self, blockTitle )

		rtk_array blockListArray = RTKStruct_GetArray( p.panelStruct, "blockList" )
		rtk_struct blockStruct = RTKArray_GetStruct( blockListArray, blockIndex )
		rtk_array challengesData = RTKStruct_GetArray( blockStruct, "challengeData" )
		string progressionText = RTKStruct_GetBool( blockStruct, "isMetaBlock" ) ? "#CHALLENGES_PANEL_META_BLOCK_PROGRESS_TEXT" : "#CHALLENGES_PANEL_BLOCK_PROGRESS_TEXT"
		string blockProgressString = Localize( progressionText , RTKChallengesPanel_GetCompletedChallengeCountFromModel( challengesData ), RTKArray_GetCount( challengesData ) )
		RTKStruct_SetString( p.panelStruct, "currentBlockProgress", blockProgressString )
		RTKStruct_SetBool( p.panelStruct, "showTimer", false )

		if ( !file.wasInspectingChallengeList )
		{
			RTKBreadcrumbHeader_RemoveStep()
			RTKBreadcrumbStepModel blockStep
			blockStep.title = blockTitle
			RTKBreadcrumbHeader_PushStep( blockStep )
		}
	}
	else
	{
		rtk_behavior pagController = self.PropGetPanel( "paginationNav" ).FindBehaviorByTypeName( "PaginationNavController" )
		RTKPaginationNavController_SetInitPageIndex( pagController, blockIndex )
	}

	rtk_behavior blockScrollView = self.PropGetBehavior( "blocksScrollView" )
	if ( p.challengesScrollView != null )
	{
		rtk_behavior challengesScrollView = expect rtk_behavior( p.challengesScrollView )
		RTKScrollView_ScrollTo( challengesScrollView, 0 )
	}


	string blockID = fileTelemetry.challenge_tile + "_block_" + blockIndex
	fileTelemetry.openDuration = int( UITime() ) - fileTelemetry.openTimestamp
	fileTelemetry.challenge_block = blockID
	fileTelemetry.menuName = blockID
	RTKChallengesPanel_SendPageViewBlock()

	fileTelemetry.fromId = fileTelemetry.menuName
	fileTelemetry.openTimestamp = int( UITime() )
}

void function RTKChallengesGenericInspectPanel_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	RemoveCallback_OnChallengeTileAdded( p.OnTileUpdate )

	RTKStruct_RemovePropertyListener( p.panelStruct, "challengeBlockIndex", p.blockIndexPropertyListener )
	RTKBreakcrumbHeader_RemoveAllSteps()
	p.highlightedItems = 0
	RTKChallengesPanel_HideVGUIFooterButtons( self )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, CHALLENGES_GENERIC_INSPECT_MODEL_NAME )
}

void function RTKChallengeGenericInspectPanel_OnChallengeListInspect( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKChallengeBlockModel blockModel
	rtk_array blockListArray = RTKStruct_GetArray( p.panelStruct, "blockList" )
	int currentBlockIndex   = RTKStruct_GetInt( p.panelStruct, "challengeBlockIndex" )
	rtk_struct blockData = RTKArray_GetStruct( blockListArray, currentBlockIndex )
	rtk_array challengesData = RTKStruct_GetArray( blockData, "challengeData" )

	if ( RTKArray_GetCount( challengesData ) < 0 )
		return

	rtk_struct challengeData = RTKArray_GetStruct( challengesData, 0 ) 
	int defaultRewardGUID = RTKStruct_GetInt( challengeData, "rewardItemGUID" )
	RTKChallengeGenericInspectPanel_PreviewItem( defaultRewardGUID )

	if ( !file.isInstantChallengeListView )
		file.blockEscKey = true

	RTKChallengesPanel_DisplayNavigation( self, true )
	RTKChallengesPanel_SetPageTitle( self, RTKStruct_GetString( blockData, "title" ) )

	RTKBreadcrumbStepModel blockStep
	blockStep.title = RTKStruct_GetString( blockData, "title" )
	if ( !file.isInstantChallengeListView )
		RTKBreadcrumbHeader_PushStep( blockStep )

	string progressionText = RTKStruct_GetBool( blockData, "isMetaBlock" ) ? "#CHALLENGES_PANEL_META_BLOCK_PROGRESS_TEXT" : "#CHALLENGES_PANEL_BLOCK_PROGRESS_TEXT"
	string blockProgressString = Localize( progressionText , RTKChallengesPanel_GetCompletedChallengeCountFromModel( challengesData ), RTKArray_GetCount( challengesData ) )
	RTKStruct_SetString( p.panelStruct, "currentBlockProgress", blockProgressString )
	RTKStruct_SetBool( p.panelStruct, "showTimer", false )

	
	
	
	
}

void function RTKChallengeGenericInspectPanel_OnBlockListInspect( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	rtk_struct panelStruct = p.panelStruct
	RunClientScript( "ClearBattlePassItem" )
	file.blockEscKey = false

	RTKChallengesPanel_DisplayNavigation( self, false )
	if ( file.tileData != null )
	{
		ChallengeTile tileData = expect ChallengeTile(file.tileData)
		RTKChallengesPanel_SetPageTitle( self, tileData.title )
	}
	RTKBreadcrumbHeader_RemoveStep()
	RTKStruct_SetString( panelStruct, "currentBlockProgress", "" )
	RTKStruct_SetBool( panelStruct, "showTimer", RTKStruct_GetString( panelStruct, "timerDisplayString") != "" )

	rtk_behavior blockScrollView = self.PropGetBehavior( "blocksScrollView" )
	RTKScrollView_ScrollTo( blockScrollView, file.lastBlockScrollViewStep )

	
	
	
	
}


void function RTKChallengesGenericInspectPanel_OnRewardInspect( rtk_behavior self, rtk_behavior challengeItem )
{
	PrivateData p
	self.Private( p )
	int currentBlockIndex  = RTKStruct_GetInt( p.panelStruct, "challengeBlockIndex" )

	rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
	bool isInspectingChallengeList = RTKSlidingListInspect_IsInspectingItemList( slidingListInspect )

	if ( isInspectingChallengeList )
	{
		RTKBreadcrumbHeader_RemoveStep()
	}

	RTKChallengesPanel_SaveScrollViewStepPosition( self )
	file.lastHighlightedBlockIndex = currentBlockIndex
	file.wasInspectingChallengeList = isInspectingChallengeList

	
	string blockID = fileTelemetry.challenge_tile + "_block_" + currentBlockIndex
	fileTelemetry.menuName = "inspect_menu"
	fileTelemetry.challenge_block = blockID
	fileTelemetry.openDuration = int( UITime() ) - fileTelemetry.openTimestamp

	rtk_behavior button = challengeItem.PropGetBehavior( "buttonBehavior" )
	string itemPath = button.GetPanel().GetBindingRootPath()
	rtk_struct itemData = RTKDataModel_GetStruct( itemPath )
	fileTelemetry.challenge_id = string( RTKStruct_GetInt( itemData, "challengeGUID" ) )
	fileTelemetry.is_narrative_challenge = RTKStruct_GetInt( itemData, "challengeItemType" ) == eChallengeListItemButtonType.NARRATIVE

	RTKChallengesPanel_SendPageViewInspectChallenge()
}

void function OpenChallengesGenericInspectPanel( ChallengeTile tileData )
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	file.tileData = tileData
	fileTelemetry.fromId = GetLastMenuIDForPIN()
	fileTelemetry.challenge_tile = tileData.title
	AdvanceMenu( file.menu )
}

void function RTKChallengeGenericInspectPanel_PreviewItem( int guid )
{
	bool isNxHH = false
#if PC_PROG_NX_UI
		isNxHH = IsNxHandheldMode()
#endif
	if ( !IsValidItemFlavorGUID( guid ) )
		return

	ItemFlavor item = GetItemFlavorByGUID( guid )
	RunClientScript( "UIToClient_ItemPresentation", guid , -1, 1, Battlepass_ShouldShowLow( GetItemFlavorByGUID( guid ) ), GetChallengesLoadscreenPreviewBox(), true, "battlepass_right_ref", isNxHH, false, false, true )
}

var function GetChallengesLoadscreenPreviewBox()
{
	return file.loadscreenPreviewBox
}

void function RTKChallengesPanel_BuildBaseChallengeListItemInfo( rtk_struct challengeStruct, ItemFlavor challenge, ChallengeBlock block )
{
	entity player = GetLocalClientPlayer()
	if ( !Challenge_IsAssigned( player, challenge ) )
		return

	RTKChallengeItemModel challengeModel
	int activeTier = Challenge_GetActiveTier( player, challenge )
	ItemFlavorBag rewards = Challenge_GetRewards( challenge, activeTier )
	ItemFlavor rewardFlav = rewards.flavors[0] 
	challengeModel.rewardItemGUID = rewardFlav.guid
	challengeModel.currentProgress = Challenge_GetProgressValue( player, challenge, activeTier )
	challengeModel.maxProgress = Challenge_GetGoalVal( challenge, activeTier )
	challengeModel.description = Challenge_GetDescription( challenge, activeTier )
	challengeModel.title = ItemFlavor_GetLongName( challenge )
	challengeModel.rewardIcon = ItemFlavor_GetChallengeRewardButtonImage( rewards.flavors[0] )
	challengeModel.challengeItemType = RTKChallenges_GetChallengeListItemButtonDisplayType( challenge )
	challengeModel.challengeGUID = challenge.guid
	challengeModel.isTracked = IsFavoriteChallenge( challenge )
	challengeModel.isBRMode = Challenge_isBRChallenge( challenge )
	challengeModel.isNBRMode = Challenge_isNBRChallenge( challenge )
	challengeModel.currentTier = activeTier
	challengeModel.maxTier = Challenge_GetTierCount( challenge )
	challengeModel.isCompleted = Challenge_IsComplete( player, challenge )
	challengeModel.isInfinite = Challenge_LastTierIsInfinite( challenge )
	challengeModel.progressText = block.isMetaBlock ? "#CHALLENGES_META_BLOCK_PROGRESS_TEXT" : "#CHALLENGES_BLOCK_PROGRESS_TEXT"

	if ( ItemFlavor_GetType( rewardFlav ) == eItemType.voucher )
	{
		int bpStars = Voucher_GetEffectBattlepassStars( rewardFlav )
		if ( bpStars > 0 )
		{
			challengeModel.rewardQuantity = bpStars
		}
		else if ( Voucher_GetEffectStatRef(rewardFlav) != null )
		{
			challengeModel.rewardQuantity = Voucher_GetEffectStatAmount( rewardFlav )
		}
		else if ( rewards.quantities[0] > 1 )
		{
			challengeModel.rewardQuantity = rewards.quantities[0]
		}
	}
	RTKStruct_SetValue( challengeStruct, challengeModel )
}

void function RTKChallengesPanel_BuildIndividualChallengeListItemInfo( rtk_struct challengeStruct, ItemFlavor challenge )
{
	int displayType = RTKChallenges_GetChallengeListItemButtonDisplayType( challenge )
	switch ( displayType )
	{
		case eChallengeListItemButtonType.EITHER:
			entity player = GetLocalClientPlayer()
			if (IsValid(player))
			{
				int activeTier = Challenge_GetActiveTier( player, challenge )
				RTKStruct_SetInt( challengeStruct, "altCurrentProgress", Challenge_GetProgressValue( player, challenge, activeTier, true ) )
				RTKStruct_SetInt( challengeStruct, "altMaxProgress", Challenge_GetGoalVal( challenge, activeTier, true ) )
				RTKStruct_SetString( challengeStruct, "altDescription", Challenge_GetDescription( challenge, activeTier, true ) )
				RTKStruct_SetBool( challengeStruct, "isBRMode", Challenge_isBRChallenge( challenge, true ) )
				RTKStruct_SetBool( challengeStruct, "isNBRMode", Challenge_isNBRChallenge( challenge, true ) )
			}
			return
		case eChallengeListItemButtonType.NARRATIVE:
			RTKStruct_SetString( challengeStruct, "altDescription", Narrative_GetDescription( challenge ) )
			RTKStruct_SetAssetPath( challengeStruct, "previewImage", Narrative_GetPreviewImage( challenge ) )
			return
	}
	unreachable
}

void function RTKChallengesPanel_BuildBaseDataModel( rtk_struct panelStruct, string pathToPanelModel )
{
	ChallengeTile tileData = expect ChallengeTile( file.tileData )
	RTKChallengesGenericInspectPanelModel panelModel
	panelModel.title = tileData.title
	panelModel.endTime = RTKChallengesPanel_GetTimerDisplayTimestamp( tileData )
	panelModel.timerDisplayString = RTKChallengesPanel_GetTimerDisplayString( tileData )
	panelModel.showTimer = panelModel.timerDisplayString != ""
	panelModel.displayType = 0
	panelModel.challengeBlockIndex = 0
	panelModel.linkType = tileData.deepLinkConfig.linkType
	panelModel.link = tileData.deepLinkConfig.link
	panelModel.deeplinkLabel = tileData.deepLinkConfig.label
	panelModel.deeplinkIcon = tileData.deepLinkConfig.icon

	rtk_array blockListModel = RTKStruct_GetOrCreateScriptArrayOfStructs( panelStruct, "blockList", "RTKChallengeBlockModel" )
	array<ChallengeBlock> activeBlockData = tileData.blocks
	foreach( int i, block in activeBlockData )
	{
		rtk_struct blockDataStruct 	= RTKArray_PushNewStruct( blockListModel )
		RTKChallengeBlockModel blockData
		int completedChallengeCount = ChallengeBlock_GetCompletedChallengeCount( block, GetLocalClientPlayer() )
		int challengeCount = ChallengeBlock_GetChallengeCount( block )
		bool isCompleted = (challengeCount == completedChallengeCount) && challengeCount != 0
		bool hasNarratives = false

		blockData.title = block.title
		blockData.endTime = block.endDate == UNIX_TIME_FALLBACK_2038 ? 0 : block.endDate
		blockData.startTime = block.startDate
		blockData.rewards = block.rewards
		blockData.progressText = RTKChallengesPanel_GetBlockProgressString( tileData, block )
		blockData.index = i
		blockData.pathToPanelModel = pathToPanelModel
		blockData.isShortBlock = RTKChallengesPanel_IsShortBlock( tileData, i )
		blockData.isTracked = ChallengeBlock_HasTrackedChallenges( block )
		blockData.isBRMode = ChallengeBlock_HasBRChallenges( block )
		blockData.isNBRMode = ChallengeBlock_HasNBRChallenges( block )
		blockData.isLocked = block.locked
		blockData.isMetaBlock = block.isMetaBlock
		if ( block.locked )
		{
			array<ChallengeBlockLockReason> lockReasons = ChallengeBlock_GetLockReasons( block )
			Assert( lockReasons.len() <= 2, "Only a maximum of 2 reasons are supported" )
			foreach( ChallengeBlockLockReason lockReason in lockReasons )
			{
				blockData.lockReason.append( lockReason.reason )
				blockData.lockReasonAvailable.append( lockReason.state == eChallengeBlockLockReasonState.PROGRESSABLE || lockReason.state == eChallengeBlockLockReasonState.COMPLETED )
				blockData.lockReasonCompleted.append( lockReason.state == eChallengeBlockLockReasonState.COMPLETED )
			}
		}
		blockData.isCompleted = isCompleted

		rtk_array challengeArray = RTKStruct_AddArrayOfStructsProperty( blockDataStruct, "challengeData", "RTKChallengeItemModel" )
		foreach( challenge in block.challenges )
		{
			rtk_struct baseChallengeStruct
			baseChallengeStruct = RTKArray_PushNewStruct( challengeArray )
			RTKChallengesPanel_BuildBaseChallengeListItemInfo( baseChallengeStruct, challenge, block )
			int challengeListType = RTKChallenges_GetChallengeListItemButtonDisplayType( challenge )
			if ( challengeListType != eChallengeListItemButtonType.BASIC && challengeListType != eChallengeListItemButtonType.META )
			{
				rtk_struct challengeStruct = RTKStruct_AddStructProperty( baseChallengeStruct, "individualData", RTKChallenges_GetChallengeDataModelStructName( challengeListType ) )
				RTKChallengesPanel_BuildIndividualChallengeListItemInfo( challengeStruct, challenge )
				if ( challengeListType == eChallengeListItemButtonType.NARRATIVE )
					hasNarratives = true
			}
		}
		blockData.hasNarratives = hasNarratives
		RTKStruct_SetValue( blockDataStruct, blockData )

		RTKChallengesPaginationPip pip
		pip.isCompleted = (challengeCount == completedChallengeCount) && challengeCount != 0
		pip.isLocked = block.locked
		panelModel.navPipArray.append( pip )
	}
	RTKStruct_SetValue( panelStruct, panelModel )
}

void function RTKChallengesPanel_DisplayNavigation( rtk_behavior self, bool shouldShow )
{
	rtk_panel paginationNav = self.PropGetPanel( "paginationNav" )
	paginationNav.SetVisible( shouldShow )
	paginationNav.SetActive( shouldShow )
}

void function RTKChallengesPanel_SetPageTitle( rtk_behavior self, string title )
{
	string modelPath = self.GetPanel().GetBindingRootPath()
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_struct baseModel = RTKDataModel_GetStruct( modelPath )
		RTKStruct_SetString( baseModel, "title", title )
	}
}

void function RTKChallengesPanel_SetDeeplinkButton( rtk_behavior self )
{
	rtk_behavior ornull deeplinkButton = self.PropGetBehavior( "deeplinkButton" )
	if ( deeplinkButton != null )
	{
		expect rtk_behavior(deeplinkButton)
		self.AutoSubscribe( deeplinkButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : () {
			
			file.lastHighlightedBlockIndex = -1
			file.wasInspectingChallengeList = false
			file.blockEscKey = false
		} )
	}
}

void function RTKChallengesPanel_SetChallengeItemButtons( rtk_behavior self )
{
	rtk_behavior listBinder = self.PropGetBehavior( "itemListPrefabInstantiator" )
	self.AutoSubscribe( listBinder, "onPrefabInstantiated", function ( int index, rtk_panel newInstance ) : ( self ) {
		if ( index == eChallengesBlockDisplayTemplate.CHALLENGES_SIMPLE_LIST_TEMPLATE )
		{
			PrivateData p
			self.Private ( p )
			p.challengesScrollView = newInstance.FindChildByName( "View" ).FindBehaviorByTypeName( "ScrollView" )
			rtk_behavior challengeListBehavior = newInstance.FindBehaviorByTypeName( CHALLENGES_BLOCK_DISPLAY_TYPE_LIST_TYPE_MAP[ index ] )
			RTKChallengesPanel_RestoreChallengeListPrefabScrollBarPosition( p.challengesScrollView )
			rtk_panel itemsParent = challengeListBehavior.PropGetPanel( "itemsParentPanel" )
			self.AutoSubscribe( itemsParent, "onChildAdded", function( rtk_panel newChild, int newChildIndex ) : ( self ) {
				rtk_panel itemContent = newChild.FindChildByName( "ItemContent" )
				rtk_behavior challengeItem = itemContent.FindBehaviorByTypeName( "ChallengeListItem" )
				RTKChallengesPanel_SetChallengeItem( self, challengeItem )

				
				
				rtk_behavior prefabInstantiator = newChild.FindBehaviorByTypeName( "PrefabInstantiator" )
				self.AutoSubscribe( prefabInstantiator, "onPrefabInstantiated", function ( int index, rtk_panel newInstance ) : ( self ) {
					rtk_behavior challengeItem = newInstance.FindBehaviorByTypeName( "ChallengeListItem" )
					RTKChallengesPanel_SetChallengeItem( self, challengeItem )
				})
			} )
		}
	} )
}

void function RTKChallengesPanel_SetChallengeItem( rtk_behavior self, rtk_behavior challengeItem )
{
	if ( challengeItem != null )
	{
		challengeItem.AutoSubscribe( challengeItem, "onRewardInspected", function() : ( self, challengeItem ) {
			RTKChallengesPanel_HideVGUIFooterButtons( self )
			RTKChallengesGenericInspectPanel_OnRewardInspect( self, challengeItem )
		} )

		rtk_behavior button = challengeItem.PropGetBehavior( "buttonBehavior" )

		self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			
			PrivateData p
			self.Private( p )
			p.highlightedItems--
		} )

		self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self ) {
			string itemPath = button.GetPanel().GetBindingRootPath()
			rtk_struct itemData = RTKDataModel_GetStruct( itemPath )
			int rewardGUID = RTKStruct_GetInt( itemData, "rewardItemGUID" )
			if ( IsValidItemFlavorGUID( rewardGUID ) )
			{
				if ( file.slidingListBehavior == null )
					return

				rtk_behavior slidingListBehavior = expect rtk_behavior ( file.slidingListBehavior )
				if ( RTKSlidingListInspect_IsInspectingItemList( slidingListBehavior ) )
				{
					RTKChallengeGenericInspectPanel_PreviewItem( rewardGUID )
				}
				int challengeItemType = RTKStruct_GetInt( itemData, "challengeItemType" )
				int challengeGUID 	  = RTKStruct_GetInt( itemData, "challengeGUID" )
				bool isTracked     	  = RTKStruct_GetBool( itemData, "isTracked" )
				RTKChallengesPanel_UpdateVGUIFooterButtons( self, challengeItemType,  rewardGUID, challengeGUID, isTracked )
			}
		} )

		self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
			RTKChallengesPanel_HideVGUIFooterButtons( self )
		} )

		rtk_panel parentPanel = challengeItem.GetPanel()
		rtk_panel ornull child = parentPanel.FindChildByName( "RerollButton" )
		if ( child != null )
		{
			expect rtk_panel( child )
			rtk_behavior RerollButton = child.FindBehaviorByTypeName( "Button" )
			self.AutoSubscribe( RerollButton, "onHighlighted", function( rtk_behavior RerollButton, int prevState ) : ( self ) {
				file.isOverAReRollButton = true
				file.yButtonDef.mouseLabel = "#Y_BUTTON_RE_ROLL"
				file.aButtonDef.mouseLabel = ""
				file.xButtonDef.mouseLabel   = ""
				file.xButtonDef.gamepadLabel = ""
				PrivateData p
				self.Private( p )
				p.highlightedItems++
				UpdateFooterOptions()
			} )
			self.AutoSubscribe( RerollButton, "onIdle", function( rtk_behavior RerollButton, int prevState ) : ( self ) {
				file.isOverAReRollButton = false
				file.yButtonDef.mouseLabel = ""
				PrivateData p
				self.Private( p )
				p.highlightedItems--
				UpdateFooterOptions()
			} )
			self.AutoSubscribe( RerollButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
				PrivateData p
				self.Private( p )
				int currentBlockIndex  = RTKStruct_GetInt( p.panelStruct, "challengeBlockIndex" )
				rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
				bool isInspectingChallengeList = RTKSlidingListInspect_IsInspectingItemList( slidingListInspect )
				file.wasInspectingChallengeList = isInspectingChallengeList
				file.lastHighlightedBlockIndex = currentBlockIndex
			})
		}
	}
}
void function RTKChallengesPanel_HideVGUIFooterButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	p.highlightedItems--
	if ( p.highlightedItems <= 0 )
	{
		p.highlightedItems = 0
		file.aButtonDef.mouseLabel      = ""
		file.aButtonDef.gamepadLabel    = ""
		file.xButtonDef.mouseLabel   	= ""
		file.xButtonDef.gamepadLabel 	= ""
		file.yButtonDef.mouseLabel   	= ""
		file.yButtonDef.gamepadLabel 	= ""
		UpdateFooterOptions()
	}
}

void function RTKChallengesPanel_UpdateVGUIFooterButtons( rtk_behavior self, int challengeItemType, int rewardGUID, int challengeGUID, bool isChallengeTracked )
{
	PrivateData p
	self.Private( p )
	p.highlightedItems++

	bool canReroll = false
	if ( IsValidItemFlavorGUID( challengeGUID ) )
	{
		canReroll = Challenge_PlayerCanRerollChallenge( GetLocalClientPlayer(), GetItemFlavorByGUID( challengeGUID ) )
	}

	switch ( challengeItemType )
	{
		case eChallengeListItemButtonType.EITHER:
		case eChallengeListItemButtonType.META:
		case eChallengeListItemButtonType.BASIC:
			file.aButtonDef.gamepadLabel    = "#A_BUTTON_VIEW_REWARD"
			file.aButtonDef.mouseLabel 		= "#A_BUTTON_VIEW_REWARD"
			file.xButtonDef.mouseLabel   	= isChallengeTracked ? "#X_BUTTON_UNTRACK_CHALLENGE" : "#X_BUTTON_TRACK_CHALLENGE"
			file.xButtonDef.gamepadLabel 	= isChallengeTracked ? "#X_BUTTON_UNTRACK_CHALLENGE" : "#X_BUTTON_TRACK_CHALLENGE"
			if ( canReroll )
			{
				file.yButtonDef.gamepadLabel = "#Y_BUTTON_RE_ROLL"
				if ( file.isOverAReRollButton )
				{
					file.aButtonDef.mouseLabel	= ""
				}
			}
			break
		case eChallengeListItemButtonType.NARRATIVE:
			file.aButtonDef.mouseLabel      = "#A_BUTTON_VIEW_REWARD"
			file.aButtonDef.gamepadLabel    = "#A_BUTTON_VIEW_REWARD"
			file.xButtonDef.mouseLabel   	= "#X_BUTTON_VIEW_STORY"
			file.xButtonDef.gamepadLabel 	= "#X_BUTTON_VIEW_STORY"
			file.yButtonDef.mouseLabel   	= ""
			file.yButtonDef.gamepadLabel 	= ""
			break
	}

	if ( !RTKChallenges_IsItemFlavForPreview( GetItemFlavorByGUID( rewardGUID ) ) )
	{
		file.aButtonDef.mouseLabel      = ""
		file.aButtonDef.gamepadLabel    = ""
	}
	UpdateFooterOptions()
}

void function RTKChallengesPanel_UpdateVGUIFooterButtonsForBlocks( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	p.highlightedItems++
	file.aButtonDef.mouseLabel      = "#A_BUTTON_VIEW_DETAILS"
	file.aButtonDef.gamepadLabel    = "#A_BUTTON_VIEW_DETAILS"
	file.xButtonDef.mouseLabel   	= ""
	file.xButtonDef.gamepadLabel 	= ""

	UpdateFooterOptions()
}

void function RTKChallengesPanel_SetBlockButtons( rtk_behavior self )
{
	rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
	
	rtk_panel blockParent = self.PropGetPanel( "blocksParent" )
	self.AutoSubscribe( blockParent, "onChildAdded", function( rtk_panel newChild, int newChildIndex ) : ( slidingListInspect, self ) {
		rtk_behavior challengeBlock = newChild.FindBehaviorByTypeName( "ChallengeBlock" )

		if ( challengeBlock != null )
		{
			challengeBlock.AutoSubscribe( challengeBlock, "onClick", function() : ( slidingListInspect, self ) {
				if ( !file.blockEscKey )
				{
					RTKChallengesPanel_HideVGUIFooterButtons( self )
					RTKSlidingListInspect_OnItemListInspect( slidingListInspect )
				}
			} )

			rtk_behavior button = challengeBlock.PropGetBehavior( "buttonBehavior" )
			self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self ) {
				RTKChallengesPanel_UpdateVGUIFooterButtonsForBlocks( self )
			})
			self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
				RTKChallengesPanel_HideVGUIFooterButtons( self )
			} )
		}
	} )
}

void function RTKChallengesPanel_SetSlidingListBehavior( rtk_behavior self )
{
	rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
	file.slidingListBehavior = slidingListInspect

	self.AutoSubscribe( slidingListInspect, "onItemListInspectStarted", function() : ( self ) {
		RTKChallengeGenericInspectPanel_OnChallengeListInspect ( self )
	} )

	self.AutoSubscribe( slidingListInspect, "onBlockListInspectFinished", function() : ( self ) {
		RTKChallengeGenericInspectPanel_OnBlockListInspect ( self )
	} )
}

void function RTKChallengesPanel_RestoreMenuState( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	
	rtk_array blockListArray = RTKStruct_GetArray( p.panelStruct, "blockList" )
	if ( RTKArray_GetCount( blockListArray ) <= 0 )
	{
		file.blockEscKey = false
		file.wasInspectingChallengeList = false
		file.lastHighlightedBlockIndex = -1
		RunClientScript( "ClearBattlePassItem" )
		ChallengesTileGenericInspectMenu_OnNavigateBack()
		return
	}

	rtk_behavior slidingListInspect = self.PropGetBehavior( "slidingListInspectBehavior" )
	
	if ( file.lastHighlightedBlockIndex != -1 )
	{
		RTKStruct_SetInt( p.panelStruct, "challengeBlockIndex", file.lastHighlightedBlockIndex )

		if ( file.wasInspectingChallengeList || file.isInstantChallengeListView )
		{
			rtk_behavior pagController = self.PropGetPanel( "paginationNav" ).FindBehaviorByTypeName( "PaginationNavController" )
			RTKPaginationNavController_SetInitPageIndex( pagController, file.lastHighlightedBlockIndex )
			RTKSlidingListInspect_SetItemListInspectInstant( slidingListInspect )
		}
		else
		{
			file.blockEscKey = false
		}
		rtk_behavior blockScrollView = self.PropGetBehavior( "blocksScrollView" )
		RTKScrollView_SetStepDefault( blockScrollView, file.lastBlockScrollViewStep )
		RTKScrollView_ScrollTo( blockScrollView, file.lastBlockScrollViewStep )
	}
	else
	{
		RTKStruct_SetInt( p.panelStruct, "challengeBlockIndex", 0 )
		file.blockEscKey = false
	}
	file.lastHighlightedBlockIndex = -1
}

void function RTKChallengesPanel_HandleInstantViewBlocks()
{
	if ( file.tileData == null )
		return

	ChallengeTile tileData = expect ChallengeTile( file.tileData )
	int blockCount = tileData.blocks.len()
	file.isInstantChallengeListView = false
	if ( blockCount == 1 )
	{
		file.lastHighlightedBlockIndex = 0
		file.isInstantChallengeListView = tileData.challengeBlockDisplayBehavior == eChallengeBlockDisplayBehavior.AUTO_SKIP_TO_BLOCK
	}
}

void function RTKChallengesPanel_SetBreadcrumbHeader( rtk_behavior self )
{
	RTKBreadcrumbStepModel challengesStep
	challengesStep.title = "#CHALLENGE_FULL_MENU_TITLE"
	RTKBreadcrumbHeader_PushStep( challengesStep )

	RTKBreadcrumbStepModel tileStep
	if ( file.tileData != null )
	{
		ChallengeTile tileData = expect ChallengeTile( file.tileData )
		tileStep.title = tileData.title
		RTKBreadcrumbHeader_PushStep( tileStep )
	}
}

string function RTKChallengesPanel_GetCurrentBlockTitle( rtk_behavior self, rtk_struct panelStruct )
{
	rtk_array blockListArray = RTKStruct_GetArray( panelStruct, "blockList" )
	int currentBlockIndex   = RTKStruct_GetInt( panelStruct, "challengeBlockIndex" )
	rtk_struct blockData = RTKArray_GetStruct( blockListArray, currentBlockIndex )
	return RTKStruct_GetString( blockData, "title" )
}

int function RTKChallengesPanel_GetTimerDisplayTimestamp( ChallengeTile tile )
{
	switch ( tile.tileCategory )
	{
		case eChallengeTileCategory.WEEKLY:
		{
			ItemFlavor ornull activePass = GetActiveBattlePass()
			if ( activePass != null )
			{
				expect ItemFlavor( activePass )
				if ( GetCurrentBattlePassWeek() < GetNumBattlePassChallengesWeeks( activePass ) )
					return GetCurrentBattlePassWeekExpirationTime()
			}
			break
		}
		case eChallengeTileCategory.DAILY:
		{
			entity player = GetLocalClientPlayer()
			Assert( player == GetLocalClientPlayer() )
			return Challenge_GetDailyExpirationTimeWithOffset( player )
		}
		case eChallengeTileCategory.BEGINNER:
		{
			foreach ( block in tile.blocks )
			{
				if ( block.locked && block.startDate != UNIX_TIME_FALLBACK_1970 )
					return block.startDate
			}
		}
	}
	return tile.endDate
}

string function RTKChallengesPanel_GetTimerDisplayString( ChallengeTile tile )
{
	switch ( tile.tileCategory )
	{
		case eChallengeTileCategory.WEEKLY:
			ItemFlavor ornull activePass = GetActiveBattlePass()
			if ( activePass != null )
			{
				expect ItemFlavor( activePass )
				return GetCurrentBattlePassWeek() < GetNumBattlePassChallengesWeeks( activePass ) ? "#CHALLENGES_UPDATES_TIMER" : "#CHALLENGES_EXPIRES_TIMER"
			}
			break
		case eChallengeTileCategory.EVENT:
			return "#CHALLENGES_EXPIRES_TIMER"
		case eChallengeTileCategory.DAILY:
			return "#CHALLENGES_REFRESHES_TIMER"
		case eChallengeTileCategory.BEGINNER:
			foreach ( block in tile.blocks )
			{
				if ( block.locked && block.startDate != UNIX_TIME_FALLBACK_1970 )
					return "#CHALLENGES_UPDATES_TIMER"
			}
			return ""
	}
	return ""
}

int function RTKChallengesPanel_GetCompletedChallengeCountFromModel( rtk_array challenges )
{
	int count = 0
	for ( int i = 0; i < RTKArray_GetCount( challenges ); i++ )
	{
		rtk_struct challenge = RTKArray_GetStruct( challenges, i )
		if ( RTKStruct_GetBool( challenge, "isCompleted" ) )
			count++
	}
	return count
}

void function RTKChallengesPanel_SaveScrollViewStepPosition( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	rtk_behavior blockScrollView = self.PropGetBehavior( "blocksScrollView" )
	file.lastBlockScrollViewStep = RTKScrollView_GetVerticalScrollStep( blockScrollView )
	if ( p.challengesScrollView != null )
	{
		rtk_behavior challengesScrollView = expect rtk_behavior( p.challengesScrollView )
		file.lastChallengeScrollViewStep = RTKScrollView_GetVerticalScrollStep( challengesScrollView )
	}
}

void function RTKChallengesPanel_RestoreChallengeListPrefabScrollBarPosition( rtk_behavior ornull challengesScrollView )
{
	if ( challengesScrollView != null )
	{
		expect rtk_behavior( challengesScrollView )
		RTKScrollView_SetStepDefault( challengesScrollView, file.lastChallengeScrollViewStep )
	}
}

void function RTKChallengesPanel_SendPageViewBlock()
{
	PIN_PageView_ChallegeMenuBlock( fileTelemetry.menuName, fileTelemetry.openDuration, fileTelemetry.fromId,
		fileTelemetry.clickType, fileTelemetry.challenge_tile, fileTelemetry.challenge_block )
}

void function RTKChallengesPanel_SendPageViewInspectChallenge()
{
	PIN_PageView_ChallegeMenuInspectChallenge( fileTelemetry.menuName, fileTelemetry.openDuration, fileTelemetry.fromId,
		fileTelemetry.clickType, fileTelemetry.challenge_tile, fileTelemetry.challenge_block, fileTelemetry.challenge_id, fileTelemetry.is_narrative_challenge )
}

void function RTKChallengesPanel_SendPageView()
{
	PIN_PageView_ChallegeMainMenu( "ChallengesPanel", fileTelemetry.openDuration, fileTelemetry.fromId, fileTelemetry.clickType )
}

void function RTKChallengesPanel_CloseMenuAndSendPin()
{
	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
		OpenChallengesMenu()
		file.lastHighlightedBlockIndex = -1
		file.isInstantChallengeListView = false

		fileTelemetry.openDuration = int( UITime() ) - fileTelemetry.openTimestamp
		RTKChallengesPanel_SendPageView()
	}
}

bool function RTKChallengesPanel_IsShortBlock( ChallengeTile challengeTile, int currentBlockIndex )
{
	if ( challengeTile.tileCategory == eChallengeTileCategory.WEEKLY )
		return true
	else if ( challengeTile.blocks[0].isMetaBlock && currentBlockIndex != 0 )
		return true
	return false
}

bool function RTKChallengesPanel_IsInfiniteBlock( ChallengeTile parentTile, ChallengeBlock block )
{
	if ( parentTile.tileCategory == eChallengeTileCategory.DAILY )
	{
		foreach ( ItemFlavor challenge in block.challenges )
		{
			if ( Challenge_LastTierIsInfinite( challenge ) )
				return true
		}
	}
	return false
}

string function RTKChallengesPanel_GetBlockProgressString( ChallengeTile parentTile, ChallengeBlock block )
{
	int completedChallengeCount = ChallengeBlock_GetCompletedChallengeCount( block, GetLocalClientPlayer() )
	int challengeCount = ChallengeBlock_GetChallengeCount( block )

	if ( block.isMetaBlock )
		return Localize( "#CHALLENGES_META_BLOCK_PROGRESS_TEXT", string( completedChallengeCount ), string( challengeCount ) )
	else if ( RTKChallengesPanel_IsInfiniteBlock( parentTile, block ) )
		return Localize( "%$rui/menu/challenges/challenges_icon_infinity_for_string%" )
	else
		return Localize( "#CHALLENGES_BLOCK_PROGRESS_TEXT", string( completedChallengeCount ), string( challengeCount ) )
	return ""
}

