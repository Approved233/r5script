
global function InitChallengesPanel
global function RTKChallengesPanel_OnInitialize
global function JumpToChallenges
global function OpenChallengesMenu

global const string NEW_PLAYER_PASS_TUTORIAL = "newplayerpasstutorial"
global const string NOT_FIRST_TIME_NEW_PLAYER_PASS = "notFirstTimeNewPlayerPass"
global struct RTKChallengesPanel_Properties
{
	rtk_panel tilesGrid
}

global struct RTKChallengesPanelModel
{
	string title
}

global struct RTKChallengeTileType1Info
{
	int currentProgress
	int maxProgress
	string format
}

global struct RTKChallengeTileType2Info
{
	array<bool> challengeCompletion
	string title
}

struct PrivateData
{
	int highlightedTiles = 0
}

struct
{
	InputDef& aButtonDef
	var panel
} file



struct
{
	string menuName = "ChallengesPanel"
	int openTimestamp
	int openDuration
	string fromId
	string clickType = "button"
	string challenge_tile

} fileTelemetry

void function InitChallengesPanel( var panel )
{
	SetPanelTabTitle( panel, "#MENU_CHALLENGES" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ChallengesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ChallengesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, ChallengesPanel_OnFocusChanged )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	file.aButtonDef = AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "", "" )
	AddCallback_UI_FeatureTutorialDialog_PopulateTabsForMode( ChallengesPanel_PopulateNewPlayerPassTutorialAboutText, NEW_PLAYER_PASS_TUTORIAL )
	AddCallback_UI_FeatureTutorialDialog_SetTitle( ChallengesPanel_PopulateNewPlayerPassTutorialTitle, NEW_PLAYER_PASS_TUTORIAL )

}

array<featureTutorialTab> function ChallengesPanel_PopulateNewPlayerPassTutorialAboutText()
{
	array<featureTutorialTab> tabs
	featureTutorialTab tab1
	array<featureTutorialData> tab1Rules

	tab1.tabName = 	"#MENU_CHALLENGES"
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#NEWPLAYER_CHALLENGES_TUTORIAL_TITLE_1", "#NEWPLAYER_CHALLENGES_TUTORIAL_DESC_1", $"rui/menu/ftue/new_player_pass/npp_challenges" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#NEWPLAYER_CHALLENGES_TUTORIAL_TITLE_2", "#NEWPLAYER_CHALLENGES_TUTORIAL_DESC_2", $"rui/menu/ftue/new_player_pass/npp_rewards" ) )
	tab1Rules.append( UI_FeatureTutorialDialog_BuildDetailsData( "#NEWPLAYER_CHALLENGES_TUTORIAL_TITLE_3", "#NEWPLAYER_CHALLENGES_TUTORIAL_DESC_3", $"rui/menu/ftue/new_player_pass/npp_skills" ) )
	tab1.rules = tab1Rules

	featureTutorialFooterData footerButton1
	footerButton1.title = "#REGEN_DIALOG_VIEW_CHALLENGES"
	footerButton1.titleGamepad = "#REGEN_DIALOG_VIEW_CHALLENGES"
	footerButton1.callbackFunc = ViewChallengesButton_Activate
	tab1.footerData.append( footerButton1 )

	featureTutorialFooterData footerButton2
	footerButton2.title = "#VIEW_NEW_PLAYER_PASS"
	footerButton2.titleGamepad = "#VIEW_NEW_PLAYER_PASS"
	footerButton2.callbackFunc = ViewPlayerPassButton_Activate
	tab1.footerData.append( footerButton2 )

	tabs.append( tab1 )

	return tabs
}

string function ChallengesPanel_PopulateNewPlayerPassTutorialTitle()
{
	return "#WELCOME_TO_THE_APEX_GAMES"
}

void function ChallengesPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	bool hasSeenChallengesInfoDialog =  bool( player.GetPersistentVar( "hasSeenChallengesInfoDialog" ) )
	if ( !hasSeenChallengesInfoDialog )
	{
		OpenChallengesInfo()
	}
}

void function ChallengesPanel_OnHide( var panel )
{
	fileTelemetry.openDuration = int( UITime() ) - fileTelemetry.openTimestamp
	RTKChallengesPanel_SendPageView()
	fileTelemetry.clickType = "button"
}

void function ChallengesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{

}

void function RTKChallengesPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct challengesPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "challengesPanel", "RTKChallengesPanelModel" )

	RTKChallengesPanel_BuildTilesDataModel( challengesPanel )

	RTKChallengesPanelModel challengesModel
	challengesModel.title = "TITLE"
	RTKStruct_SetValue( challengesPanel, challengesModel )

	RTKChallengesPanel_SetUpTilesButtons( self )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "challengesPanel", true ) )
	fileTelemetry.openTimestamp = int( UITime() )
}

void function RTKChallengesPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "challengesPanel" )
}

void function RTKChallengesPanel_BuildTilesDataModel( rtk_struct challengesPanel )
{
	rtk_array challengeTileModel = RTKStruct_GetOrCreateScriptArrayOfStructs( challengesPanel, "buttonData", "RTKChallengeTileModel" )
	array<ChallengeTile> activeTileData = ChallengeTile_GetActiveTilesSorted()
	foreach ( tileData in activeTileData )
	{
		rtk_struct challengeTileStruct 	= RTKArray_PushNewStruct( challengeTileModel )

		RTKChallengeTileModel challengeTile
		challengeTile.category = tileData.tileCategory
		challengeTile.title = Localize( tileData.title )
		challengeTile.progressionDisplayType = RTKChallengesPanel_GetTileProgressonInfoPrefabInstantiatorIndex( challengeTile.category )
		challengeTile.endTime = RTKChallengesPanel_GetTimerDisplayTimestamp( tileData )
		challengeTile.timerFormat = RTKChallengesPanel_GetTimerDisplayString( tileData )
		challengeTile.highlightReward = tileData.featuredRewards
		challengeTile.isTracked = ChallengeTile_HasTrackedChallenges( tileData )
		challengeTile.isPinned = false 
		challengeTile.isBRMode = ChallengeTile_HasBRChallenges( tileData )
		challengeTile.isNBRMode = ChallengeTile_HasNBRChallenges( tileData )
		challengeTile.hasNarratives = RTKChallengesPanel_DoesTileHaveNarratives( challengesPanel, tileData.blocks )
		challengeTile.backgroundImage = tileData.keyArt
		challengeTile.isCompleted = ChallengeTile_IsCompleted( tileData, GetLocalClientPlayer() )

		RTKStruct_SetValue( challengeTileStruct, challengeTile )

		rtk_struct progressionData = RTKStruct_AddStructProperty( challengeTileStruct, "progressionData", RTKChallengesPanel_GetDataModelStructNameFromCategory( challengeTile.category ) )
		RTKChallengesPanel_BuildTileProgressionInfo( progressionData, tileData )
	}
}

bool function RTKChallengesPanel_DoesTileHaveNarratives( rtk_struct challengesPanel, array<ChallengeBlock> blocks )
{
	array<ChallengeBlock> activeBlockData = blocks
	foreach( int i, block in activeBlockData )
	{
		foreach( challenge in block.challenges )
		{
			int challengeListType = RTKChallenges_GetChallengeListItemButtonDisplayType( challenge )
			if ( challengeListType == eChallengeListItemButtonType.NARRATIVE )
			{
				return true
			}
		}
	}

	return false
}

void function RTKChallengesPanel_SetUpTilesButtons( rtk_behavior self )
{
	array<ChallengeTile> activeTileData = ChallengeTile_GetActiveTilesSorted()
	rtk_panel ornull tilesGrid = self.PropGetPanel( "tilesGrid" )
	if ( tilesGrid != null )
	{
		expect rtk_panel( tilesGrid )
		self.AutoSubscribe( tilesGrid, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, activeTileData ) {
			ChallengeTile tileData = activeTileData[newChildIndex]
			rtk_behavior button = newChild.FindBehaviorInDescendantsByTypeName( "Button" )
			self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, tileData ) {
				fileTelemetry.openDuration = int( UITime() ) - fileTelemetry.openTimestamp
				fileTelemetry.clickType = "button"
				fileTelemetry.challenge_tile = tileData.title
				RTKChallengesPanel_SendPageViewTile()

				OpenChallengesInspectPanel( tileData )
				RTKChallengesPanel_HideVGUIFooterButtons( self )
			} )
			self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self ) {
				RTKChallengesPanel_UpdateVGUIFooterButtons( self )
			} )
			self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
				RTKChallengesPanel_HideVGUIFooterButtons( self )
			} )
		} )
	}
}

void function RTKChallengesPanel_HideVGUIFooterButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	p.highlightedTiles--
	if ( p.highlightedTiles <= 0 )
	{
		p.highlightedTiles = 0
		file.aButtonDef.mouseLabel = ""
		file.aButtonDef.gamepadLabel = ""
		UpdateFooterOptions()
	}
}

void function RTKChallengesPanel_UpdateVGUIFooterButtons( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	p.highlightedTiles++
	file.aButtonDef.mouseLabel = "#A_BUTTON_VIEW_CHALLENGES"
	file.aButtonDef.gamepadLabel = "#A_BUTTON_VIEW_CHALLENGES"
	UpdateFooterOptions()
}


int function RTKChallengesPanel_GetTileProgressonInfoPrefabInstantiatorIndex( int category )
{
	switch ( category )
	{
		case eChallengeTileCategory.WEEKLY:
		case eChallengeTileCategory.EVENT:
		case eChallengeTileCategory.TRACKED:
		case eChallengeTileCategory.BEGINNER:
			return 0
	}
	return 0
}

string function RTKChallengesPanel_GetDataModelStructNameFromCategory( int category )
{
	switch ( category )
	{
		case eChallengeTileCategory.DAILY:
		case eChallengeTileCategory.WEEKLY:
		case eChallengeTileCategory.EVENT:
		case eChallengeTileCategory.TRACKED:
		case eChallengeTileCategory.BEGINNER:
		return "RTKChallengeTileType1Info"
	}
	unreachable
}

void function RTKChallengesPanel_BuildTileProgressionInfo( rtk_struct topRight, ChallengeTile tile )
{
	switch ( tile.tileCategory )
	{
		case eChallengeTileCategory.DAILY:
		case eChallengeTileCategory.WEEKLY:
		case eChallengeTileCategory.EVENT:
		case eChallengeTileCategory.BEGINNER:
		{
			RTKChallengeTileType1Info data
			data.format = "#N_SLASH_N"
			data.currentProgress = ChallengeTile_GetCompletedChallengeCount( tile, GetLocalClientPlayer() )
			data.maxProgress = tile.totalChallenges
			RTKStruct_SetValue( topRight, data )
			return
		}
		case eChallengeTileCategory.TRACKED:
		{
			RTKChallengeTileType1Info data
			data.format = "#N_SLASH_N"
			data.currentProgress = ChallengeTile_GetCompletedChallengeCount( tile, GetLocalClientPlayer() )
			data.maxProgress = ChallengeTile_GetChallengeCount( tile )
			RTKStruct_SetValue( topRight, data )
			return
		}
	}
	unreachable
}

void function OpenChallengesInspectPanel( ChallengeTile tileData )
{
	switch ( tileData.tileCategory )
	{
		case eChallengeTileCategory.DAILY:
		case eChallengeTileCategory.WEEKLY:
		case eChallengeTileCategory.EVENT:
		case eChallengeTileCategory.TRACKED:
			OpenChallengesGenericInspectPanel( tileData )
			return
		case eChallengeTileCategory.BEGINNER:
			OpenChallengesGenericInspectPanel( tileData )
			entity player = GetLocalClientPlayer()
			if ( !player.GetPersistentVar( "hasSeenNPPChallengesInfoDialog" ) )
			{
				UI_OpenFeatureTutorialDialog( NEW_PLAYER_PASS_TUTORIAL )
				Remote_ServerCallFunction( "ClientCallback_MarkNPPChallengeInfoDialogAsSeen" )
			}

			else if ( NPP_IsNPPComplete( player ) )
			{
				JumpToSeasonTab( "RTKNewplayerpassPanel" )
			}

			return
	}
	unreachable
}


void function OpenChallengesMenu()
{
	fileTelemetry.clickType = "button"
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	int index            = Tab_GetTabIndexByBodyName( lobbyTabData, "ChallengesPanel" )
	if ( lobbyTabData.activeTabIdx != index )
	{
		ActivateTab( lobbyTabData, index )
	}
}

void function JumpToChallenges( string link = "" )
{
	if ( link.len() == 0 )
	{
		OpenChallengesMenu()
		fileTelemetry.clickType = "deeplink"
		return
	}

	array<ChallengeTile> activeTileData = ChallengeTile_GetActiveTilesSorted()
	foreach( ChallengeTile tileData in activeTileData )
	{
		string tileType = GetEnumString( "eChallengeTileCategory", tileData.tileCategory ).tolower()
		int tileGUID = ConvertItemFlavorGUIDStringToGUID( link )
		if ( tileType == link )
		{
			OpenChallengesInspectPanel( tileData )

			fileTelemetry.challenge_tile = tileData.title
			fileTelemetry.openDuration = 0
			RTKChallengesPanel_SendPageViewTile()
			return
		}
		else if ( tileGUID == tileData.tileId )
		{
			OpenChallengesInspectPanel( tileData )

			fileTelemetry.challenge_tile = tileData.title
			fileTelemetry.openDuration = 0
			RTKChallengesPanel_SendPageViewTile()
			return
		}
	}
}

void function ViewChallengesButton_Activate( var button )
{
	JumpToChallenges( "beginner" )
}

void function ViewPlayerPassButton_Activate( var button )
{

		JumpToSeasonTab( "RTKNewplayerpassPanel" )

}

void function RTKChallengesPanel_SendPageViewTile()
{
	PIN_PageView_ChallegeMainMenuTile( fileTelemetry.menuName, fileTelemetry.openDuration, GetLastMenuIDForPIN(), fileTelemetry.clickType, fileTelemetry.challenge_tile )
}

void function RTKChallengesPanel_SendPageView()
{
	PIN_PageView_ChallegeMainMenu( fileTelemetry.menuName, fileTelemetry.openDuration, GetLastMenuIDForPIN(), fileTelemetry.clickType )
}
      