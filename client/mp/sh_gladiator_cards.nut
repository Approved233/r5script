global function ShGladiatorCards_LevelInit








global function CreateNestedGladiatorCard
global function CleanupNestedGladiatorCard
global function ChangeNestedGladiatorCardPresentation
global function ChangeNestedGladiatorCardOwner
global function SetNestedGladiatorCardOverrideName
global function SetNestedGladiatorCardOverrideCharacter
global function SetNestedGladiatorCardOverrideSkin
global function SetNestedGladiatorCardOverrideFrame
global function SetNestedGladiatorCardOverrideStance
global function SetNestedGladiatorCardOverrideMeleeSkin
global function SetNestedGladiatorCardOverrideBadge
global function SetNestedGladiatorCardOverrideTracker

global function SetNestedGladiatorCardIsKiller
global function SetNestedGladiatorCardDisableBlur

global function SetNestedGladiatorCardShowUpgrades
global function SetNestedGladiatorCardCanShowUpgrades


global function SetNestedGladiatorCardOverrideRankedDetails




global function PrePopulateGladiatorCardCache
global function PrePopulateGladiatorCardCache_ReducePriority
global function PrePopulateGladiatorCardCache_Abort




global function GetBadgeData
global function CreateNestedGladiatorCardBadge
global function GladiatorCardStatTracker_GetBackgroundImage












global function DisplayGladiatorCardSidePane
global function HideGladiatorCardSidePane
global function HideGladiatorCardSidePaneThreaded
global function UpdateRuiWithStatTrackerData
global function UIToClient_SetupMenuGladCard

global function UIToClient_SetupMenuGladCardRTK

global function UIToClient_HandleMenuGladCardPreviewCommand
global function UIToClient_HandleMenuGladCardPreviewString
global function OnWinnerDetermined
global function GetSituationPlayer


#if DEV
global function DEV_DumpCharacterCaptures
global function DEV_GladiatorCards_ToggleForceMoving
global function DEV_GladiatorCards_ToggleShowSafeAreaOverlay
global function DEV_GladiatorCards_ToggleCameraAlpha
global function GladCardDebug
#endif


global function Loadout_GladiatorCardFrame
global function Loadout_GladiatorCardStance
global function Loadout_GladiatorCardBadge
global function Loadout_GladiatorCardBadgeTier
global function Loadout_GladiatorCardStatTracker
global function Loadout_GladiatorCardStatTrackerValue
global function Loadout_GladiatorCardStatTrackerArt
global function GladiatorCardFrame_GetSortOrdinal
global function GladiatorCardFrame_GetCharacterFlavor
global function GladiatorCardFrame_HasStoryBlurb
global function GladiatorCardFrame_GetStoryBlurbBodyText
global function GladiatorCardFrame_ShouldHideIfLocked
global function GladiatorCardFrame_IsSharedBetweenCharacters
global function GladiatorCardStance_GetSortOrdinal
global function GladiatorCardStance_GetCharacterFlavor
global function GladiatorCardBadge_GetSortOrdinal
global function GladiatorCardBadge_GetCharacterFlavor
global function GladiatorCardBadge_GetUnlockStatRef
global function GladiatorCardBadge_IsGeneralStat
global function GladiatorCardBadge_GetStatInt
global function GladiatorCardBadge_IsValidStatRef
global function GladiatorCardStatTracker_GetSortOrdinal
global function GladiatorCardStatTrackerArt_GetSortOrdinal
global function GladiatorCardStatTracker_GetCharacterFlavor
global function GladiatorCardStatTracker_GetFormattedValueText
global function GladiatorCardStatTracker_IsSharedBetweenCharacters
global function GladiatorCardStatTracker_GetTrackerType
global function GladiatorCardBadge_ShouldHideIfLocked
global function GladiatorCardBadge_IsTheEmpty
global function GladiatorCardTracker_IsTheEmpty
global function GladiatorCardBadge_IsCharacterBadge
global function GladiatorCardBadge_GetTierCount
global function GladiatorCardBadge_GetTierData
global function GladiatorCardBadge_GetTierDataList
global function GetPlayerBadgeDataInteger


global function GladiatorCardStatTracker_GetColor0
global function GladiatorCardBadge_DoesStatSatisfyValue







global function GladiatorCardBadge_GetPostGameStatUnlockBadgesDisplayData



global function GladiatorCardBadge_HasOwnRUI
global function GladiatorCardBadge_IsOversizedImage
global function ShGladiatorCards_OnDevnetBugScreenshot



global const int GLADIATOR_CARDS_NUM_BADGES = 3
global const int GLADIATOR_CARDS_NUM_TRACKERS = 3

global const int GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS = 3

const int POST_GAME_BADGE_COUNT = 16
const string POST_GAME_BADGES_PVAR_FORMAT_STRING = "lastGameBadgeGUID[%d]"








global enum eGladCardPresentation
{
	OFF,

	_MARK_FRONT_START,
	FRONT_DETAILS,
	PROTO_FRONT_DETAILS_NO_BADGES,
	FRONT_CLEAN,
	FRONT_STANCE_ONLY,
	FRONT_FRAME_ONLY,

	_MARK_BACK_START,
	FULL_BOX,
	_MARK_FRONT_END,

	BACK,
	_MARK_BACK_END,
}


global enum eGladCardDisplaySituation
{
	
	
	_INVALID, 

	DEATH_BOX_STILL,
	APEX_SCREEN_STILL,
	SPECTATE_ANIMATED,
	GAME_INTRO_CHAMPION_SQUAD_ANIMATED,
	GAME_INTRO_CHAMPION_SQUAD_STILL,
	GAME_INTRO_MY_SQUAD_ANIMATED,
	GAME_INTRO_MY_SQUAD_STILL,
	WEAPON_INSPECT_OVERLAY_ANIMATED,
	DEATH_OVERLAY_ANIMATED,
	SQUAD_MANAGEMENT_PAGE_ANIMATED,
	EOG_SCREEN_LOCAL_SQUAD_ANIMATED,
	EOG_SCREEN_WINNING_SQUAD_ANIMATED,

	
	MENU_CUSTOMIZE_ANIMATED,
	MENU_LOOT_CEREMONY_ANIMATED,

	
	DEV_ANIMATED,

	_COUNT, 
}

table<int, bool> eGladCardDisplaySituation_IS_MOVING = {
	[eGladCardDisplaySituation.DEATH_BOX_STILL] = false,
	[eGladCardDisplaySituation.APEX_SCREEN_STILL] = false,
	[eGladCardDisplaySituation.SPECTATE_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_STILL] = false,
	[eGladCardDisplaySituation.GAME_INTRO_MY_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_MY_SQUAD_STILL] = false,
	[eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED] = true,
	[eGladCardDisplaySituation.SQUAD_MANAGEMENT_PAGE_ANIMATED] = true,
	[eGladCardDisplaySituation.EOG_SCREEN_LOCAL_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.EOG_SCREEN_WINNING_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.MENU_CUSTOMIZE_ANIMATED] = true,
	[eGladCardDisplaySituation.MENU_LOOT_CEREMONY_ANIMATED] = true,
	[eGladCardDisplaySituation.DEV_ANIMATED] = true,
}

global enum eGladCardLifestateOverride
{
	NONE = 0, 
	ALIVE = 1,
	DEAD = 2,
}

global enum eTrackerType
{
	STAT,
	ART,
	BOTH,
}

global enum eGladCardPreviewCommandType
{
	CHARACTER,
	SKIN,
	FRAME,
	STANCE,
	BADGE,
	TRACKER_STAT,
	TRACKER_ART,
	RANKED_SHOULD_SHOW,
	RANKED_DATA,

		ARENAS_RANKED_SHOULD_SHOW,
		ARENAS_RANKED_DATA,

	NAME,
	RANKED_DATA_PREV,
	MELEE_SKIN,
}


typedef OnStancePIPSlotReadyFuncType void functionref( int stancePIPSlotIndex, float movingSeqEndTime )




global struct CharacterCaptureState
{
	string             key
	EHI                playerEHI = EHI_null
	bool               isMoving = false
	ItemFlavor&        character
	ItemFlavor&        skin
	ItemFlavor ornull  frameOrNull
	ItemFlavor&        stance
	ItemFlavor ornull meleeSkin

	bool                isReady = false
	PIPSlotState ornull stancePIPSlotStateOrNull
	CaptureRoom ornull  captureRoomOrNull = null
	int                 refCount = 0
	float               startTime = 0.0

	void functionref() cleanupSceneFunc

	table<OnStancePIPSlotReadyFuncType, bool> onPIPSlotReadyFuncSet
#if DEV
		PakHandle ornull DEV_framePakHandleOrNull = null
		array<string>    DEV_culprits
		var              DEV_bgTopo = null
		var              DEV_bgRui = null
#endif

	
	entity        model
	entity        lightingRig
	entity        camera
	array<entity> lights
	array<bool>   lightDoesShadowsMap
	int           colorCorrectionLayer = -1
}



global struct NestedWidgetState
{
	var   rui
	asset ruiAsset = $""
}



global struct NestedGladiatorCardHandle
{
	var    parentRui
	string argName
	var    cardRui
	int    presentation = eGladCardPresentation.OFF
	bool   isFrontFace
	bool   isBackFace
	int    situation = eGladCardDisplaySituation._INVALID
	bool   shouldShowDetails = false
	bool   isMoving = false

	PakHandle ornull framePakHandleOrNull = null

	NestedWidgetState                             fgFrameNWS
	NestedWidgetState                             bgFrameNWS
	NestedWidgetState[GLADIATOR_CARDS_NUM_BADGES] badgeNWSList

	CharacterCaptureState ornull characterCaptureStateOrNull = null

	EHI currentOwnerEHI

	int   lifestateOverride = eGladCardLifestateOverride.NONE
	float startTime = 0.0

	string ornull                                   overrideName = null
	ItemFlavor ornull                               overrideCharacter = null
	ItemFlavor ornull                               overrideSkin = null
	ItemFlavor ornull                               overrideFrame = null
	ItemFlavor ornull                               overrideStance = null
	ItemFlavor ornull                               overrideMeleeSkin = null
	ItemFlavor ornull[GLADIATOR_CARDS_NUM_BADGES]   overrideBadgeList
	int[GLADIATOR_CARDS_NUM_BADGES]                 overrideBadgeDataIntegerList
	ItemFlavor ornull[GLADIATOR_CARDS_NUM_TRACKERS] overrideTrackerArtList
	ItemFlavor ornull[GLADIATOR_CARDS_NUM_TRACKERS] overrideTrackerList
	int[GLADIATOR_CARDS_NUM_TRACKERS]               overrideTrackerDataIntegerList

	int ornull  rankedScoreOrNull = null
	int ornull  rankedLadderPosOrNull = null
	bool ornull rankedForceShowOrNull = null

	int ornull  rankedScoreOrNullPrevSeason = null
	int ornull  rankedLadderPosOrNullPrevSeason = null


		int ornull  arenasRankedScoreOrNull = null
		int ornull  arenasRankedLadderPosOrNull = null
		bool ornull arenasRankedForceShowOrNull = null


	bool disableBlur = false
	bool isKiller = false


		bool canShowUpgrades = false
		bool showUpgrades = false


	bool updateQueued = false

	OnStancePIPSlotReadyFuncType onStancePIPSlotReadyFunc = null

#if DEV
		string DEV_culprit = ""
#endif
}



global struct GladCardBadgeTierData
{
	float unlocksAt
	asset ruiAsset = $""
	asset imageAsset = $""
	bool  isUnlocked = true
}

global struct BadgeDisplayData
{
	ItemFlavor& badge
	GladCardBadgeTierData& tierData
}

global struct GladCardBadgeDisplayData
{
	asset ruiAsset = $""
	asset imageAsset = $""
	int   dataInteger = -1 
}



struct MenuGladCardPreviewCommand
{
	int               previewType
	int               index
	ItemFlavor ornull flavOrNull
	int               dataInteger
	string            previewString
}



struct PrepopulateManager {
	int activeSingleCardThreadCount = 0
} 



struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, LoadoutEntry>         loadoutCharacterFrameSlotMap
	table<ItemFlavor, LoadoutEntry>         loadoutCharacterStanceSlotMap
	table<ItemFlavor, array<LoadoutEntry> > loadoutCharacterBadgesSlotListMap
	table<ItemFlavor, array<LoadoutEntry> > loadoutCharacterBadgesTierSlotListMap
	table<ItemFlavor, array<LoadoutEntry> > loadoutCharacterTrackersSlotListMap
	table<ItemFlavor, array<LoadoutEntry> > loadoutCharacterTrackersValueSlotListMap
	table<ItemFlavor, array<LoadoutEntry> > loadoutCharacterTrackersArtSlotListMap

	table<ItemFlavor, bool> trackerArtFlavors 

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap
	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMapArt

	table<string, var> currentMenuGladCardPanel

		table<string, NestedGladiatorCardHandle> currentMenuGladCardHandle





		var sidePaneRui = null

		
		table<EHI, array<NestedGladiatorCardHandle> > ownerNestedCardListMap

		bool                                 isCaptureThreadRunning = false
		table<string, CharacterCaptureState> ccsMap
		array<CharacterCaptureState>         ccsStillQueue
		array<CharacterCaptureState>         stillsInProgress = []

		EHI situationPlayer

#if DEV
			bool DEV_forceMoving = false
			bool DEV_showSafeAreaOverlay = false
			bool DEV_disableCameraAlpha = false
#endif

		array<MenuGladCardPreviewCommand> menuGladCardPreviewCommandQueue
		bool waitForFreePip
		PrepopulateManager ornull prepopulateManager = null

}
FileStruct_LifetimeLevel& fileLevel

















void function ShGladiatorCards_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel


		AddCallback_OnYouDied( OnYouDied )
		AddFirstPersonSpectateStartedCallback( OnSpectateStarted )
		AddThirdPersonSpectateStartedCallback( OnSpectateStarted )
		AddCallback_OnYouRespawned( OnYouRespawned ) 
		AddCallback_OnPlayerLifeStateChanged( OnPlayerLifestateChanged )
		AddCallback_PlayerClassActuallyChanged( OnPlayerClassChanged )

		RegisterNetVarIntChangeCallback( UPGRADE_CORE_SELECTED_UPGRADES, GladiatorCards_PlayerCompletedLevelChanged )

		AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnWinnerDetermined )

		RegisterSignal( "DisplayGladiatorCardSidePane" )
		RegisterSignal( "GladiatorCardShown" )
		RegisterSignal( "HideGladiatorCard" )
		RegisterSignal( "StopGladiatorCardCharacterCapture" )
		RegisterSignal( "YouMayProceedWithStillCCS" )
		RegisterSignal( "HaltMenuGladCardThread" )
		RegisterSignal( "TaskDone" )
		RegisterSignal( "PrecacheDone" )
		RegisterSignal( "PrecacheAbort" )
		fileLevel.waitForFreePip = GetConVarBool( "gladcards_wait_for_free_pip" )


	AddCallback_OnItemFlavorRegistered( eItemType.character, OnItemFlavorRegistered_Character )
	AddCallback_OnPreAllItemFlavorsRegistered( BuildTrackerArtLoadouts )












}








































NestedGladiatorCardHandle function CreateNestedGladiatorCard( var parentRui, string argName, int situation, int presentation )
{
	NestedGladiatorCardHandle handle
	handle.parentRui = parentRui
	handle.argName = argName
	handle.currentOwnerEHI = EHI_null
	handle.situation = situation
	handle.isMoving = eGladCardDisplaySituation_IS_MOVING[situation]
	
#if DEV
		handle.DEV_culprit = expect string(expect table(getstackinfos( 2 )).func)
#endif

	ChangeNestedGladiatorCardPresentation( handle, presentation )

	return handle
}




void function CleanupNestedGladiatorCard( NestedGladiatorCardHandle handle, bool isParentAlreadyDead = false )
{
	if ( handle.parentRui == null || handle.cardRui == null )
		return

	
	
	
	
	
	
	
	

	ChangeNestedGladiatorCardOwner( handle, EHI_null )

	if ( !isParentAlreadyDead && RuiIsAlive( handle.parentRui ) )
		RuiDestroyNested( handle.parentRui, handle.argName )
	handle.parentRui = null
	handle.cardRui = null

	if ( handle.framePakHandleOrNull != null )
	{
		ReleasePakFile( expect PakHandle(handle.framePakHandleOrNull) )
		handle.framePakHandleOrNull = null
	}

	
}




void function ChangeNestedGladiatorCardPresentation( NestedGladiatorCardHandle handle, int presentation )
{
	if ( handle.presentation == presentation )
		return
	handle.presentation = presentation
	handle.isFrontFace = (handle.presentation > eGladCardPresentation._MARK_FRONT_START && handle.presentation < eGladCardPresentation._MARK_FRONT_END)
	handle.isBackFace = (handle.presentation > eGladCardPresentation._MARK_BACK_START && handle.presentation < eGladCardPresentation._MARK_BACK_END)
	handle.shouldShowDetails = (handle.presentation == eGladCardPresentation.FRONT_DETAILS)

	asset ruiAsset = $""
	if ( handle.presentation == eGladCardPresentation.FULL_BOX )
		ruiAsset = $"ui/gladiator_card_full_box.rpak"
	else if ( handle.isFrontFace )
		ruiAsset = $"ui/gladiator_card_frontface.rpak"
	else if ( handle.isBackFace )
		ruiAsset = $"ui/gladiator_card_backface.rpak"

	RuiDestroyNestedIfAlive( handle.parentRui, handle.argName )
	if ( handle.cardRui != null )
	{
		handle.cardRui = null
		handle.fgFrameNWS.rui = null
		handle.bgFrameNWS.rui = null
		for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
			handle.badgeNWSList[badgeIndex].rui = null
	}
	if ( ruiAsset != $"" )
		handle.cardRui = RuiCreateNested( handle.parentRui, handle.argName, ruiAsset )

	TriggerNestedGladiatorCardUpdate( handle )
}




void function ChangeNestedGladiatorCardOwner( NestedGladiatorCardHandle handle, EHI newOwnerEHI,
float ornull startTimeOrNull = null, int lifestateOverride = eGladCardLifestateOverride.NONE )
{
	if ( handle.parentRui == null || handle.cardRui == null )
		return

	if ( handle.currentOwnerEHI != newOwnerEHI )
	{
		if ( handle.currentOwnerEHI != EHI_null )
		{
			array<NestedGladiatorCardHandle> currentOwnerNestedCardList = fileLevel.ownerNestedCardListMap[handle.currentOwnerEHI]
			currentOwnerNestedCardList.fastremovebyvalue( handle )
			if ( currentOwnerNestedCardList.len() == 0 )
				delete fileLevel.ownerNestedCardListMap[handle.currentOwnerEHI]
		}

		handle.currentOwnerEHI = newOwnerEHI

		if ( newOwnerEHI != EHI_null )
		{
			array<NestedGladiatorCardHandle> newOwnerNestedCardList
			if ( newOwnerEHI in fileLevel.ownerNestedCardListMap )
				newOwnerNestedCardList = fileLevel.ownerNestedCardListMap[newOwnerEHI]
			else
				fileLevel.ownerNestedCardListMap[newOwnerEHI] <- newOwnerNestedCardList
			newOwnerNestedCardList.append( handle )
		}
	}

	if ( handle.currentOwnerEHI != EHI_null )
	{
		handle.startTime = startTimeOrNull != null ? expect float( startTimeOrNull ) : Time()
		if ( handle.cardRui != null )
			RuiSetFloat( handle.cardRui, "startTime", handle.startTime )
	}

	handle.lifestateOverride = lifestateOverride

	TriggerNestedGladiatorCardUpdate( handle )
}




void function SetNestedGladiatorCardOverrideName( NestedGladiatorCardHandle handle, string ornull nameOrNull )
{
	handle.overrideName = nameOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideCharacter( NestedGladiatorCardHandle handle, ItemFlavor ornull characterOrNull )
{
	handle.overrideCharacter = characterOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideSkin( NestedGladiatorCardHandle handle, ItemFlavor ornull skinOrNull )
{
	handle.overrideSkin = skinOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideFrame( NestedGladiatorCardHandle handle, ItemFlavor ornull frameOrNull )
{
	handle.overrideFrame = frameOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideStance( NestedGladiatorCardHandle handle, ItemFlavor ornull stanceOrNull )
{
	handle.overrideStance = stanceOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideMeleeSkin( NestedGladiatorCardHandle handle, ItemFlavor ornull meleeSkinOrNull )
{
	handle.overrideMeleeSkin = meleeSkinOrNull
}
void function SetNestedGladiatorCardOverrideBadge( NestedGladiatorCardHandle handle, int badgeIndex, ItemFlavor ornull badgeOrNull, int dataInteger )
{
	handle.overrideBadgeList[badgeIndex] = badgeOrNull
	handle.overrideBadgeDataIntegerList[badgeIndex] = dataInteger
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideTracker( NestedGladiatorCardHandle handle, int trackerIndex, ItemFlavor ornull trackerOrNull, int dataInteger )
{
	handle.overrideTrackerList[trackerIndex] = trackerOrNull
	handle.overrideTrackerDataIntegerList[trackerIndex] = dataInteger
	TriggerNestedGladiatorCardUpdate( handle )
}

void function SetNestedGladiatorCardOverrideTrackerArt( NestedGladiatorCardHandle handle, int trackerIndex, ItemFlavor ornull trackerArtOrNull )
{
	handle.overrideTrackerArtList[trackerIndex] = trackerArtOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}


void function SetNestedGladiatorCardShowUpgrades( NestedGladiatorCardHandle handle, bool showUpgrades )
{
	handle.showUpgrades = showUpgrades
	TriggerNestedGladiatorCardUpdate( handle )
}

void function SetNestedGladiatorCardCanShowUpgrades( NestedGladiatorCardHandle handle, bool canShowUpgrades )
{
	handle.canShowUpgrades = canShowUpgrades
	TriggerNestedGladiatorCardUpdate( handle )
}


void function SetNestedGladiatorCardIsKiller( NestedGladiatorCardHandle handle, bool isKiller )
{
	handle.isKiller = isKiller
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardDisableBlur( NestedGladiatorCardHandle handle, bool disableBlur )
{
	handle.disableBlur = disableBlur
	TriggerNestedGladiatorCardUpdate( handle )
}

void function SetNestedGladiatorCardOverrideRankedShouldShow( NestedGladiatorCardHandle handle, int shouldShowData )
{
	handle.rankedForceShowOrNull = shouldShowData > 0
}


void function SetNestedGladiatorCardOverrideArenasRankedShouldShow( NestedGladiatorCardHandle handle, int shouldShowData )
{
	handle.arenasRankedForceShowOrNull = shouldShowData > 0
}


void function SetNestedGladiatorCardOverrideRankedDetails( NestedGladiatorCardHandle handle, int rankScore, int ladderPos )
{
	handle.rankedScoreOrNull = rankScore
	handle.rankedLadderPosOrNull = ladderPos
}

void function SetNestedGladiatorCardOverrideRankedDetailsPreviousSeason( NestedGladiatorCardHandle handle, int rankScore,  int ladderPos )
{
	handle.rankedScoreOrNullPrevSeason = rankScore
	handle.rankedLadderPosOrNullPrevSeason = ladderPos
}


void function SetNestedGladiatorCardOverrideArenasRankedDetails( NestedGladiatorCardHandle handle, int rankScore, int ladderPos )
{
	handle.arenasRankedScoreOrNull = rankScore
	handle.arenasRankedLadderPosOrNull = ladderPos
}






GladCardBadgeDisplayData function GetBadgeData( EHI playerEHI, ItemFlavor ornull character, int badgeIndex, ItemFlavor badge, int ornull overrideDataIntegerOrNull, bool showOneTierHigherThanIsUnlocked = false )
{
	GladCardBadgeDisplayData badgeData

	if ( overrideDataIntegerOrNull != null )
		badgeData.dataInteger = expect int(overrideDataIntegerOrNull)
	else
		badgeData.dataInteger = GetPlayerBadgeDataInteger( playerEHI, badge, badgeIndex, character, showOneTierHigherThanIsUnlocked )

	if ( badgeData.dataInteger == -1 ) 
		badgeData.dataInteger = 0

	int tierIndex = badgeData.dataInteger
	if ( GladiatorCardBadge_GetDynamicTextStatRef( badge ) != "" )
		tierIndex = 0 

	
	if ( string(ItemFlavor_GetAsset( badge )) == ACCOUNT_BADGE_ASSET_PATH_STRING )
	{
		if ( badgeData.dataInteger <= ACCOUNT_LEVEL_RUI_SWITCH_0_BASE || GetCurrentPlaylistVarInt( "account_progression_version", 3 ) == 2 )
			badgeData.ruiAsset = $"ui/gcard_badge_account_t1.rpak"
		else
			badgeData.ruiAsset = $"ui/gcard_badge_account_p1.rpak"

		return badgeData
	}

	
	array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badge )
	if ( ItemFlavor_GetGRXMode( badge ) == eItemFlavorGRXMode.REGULAR && !tierDataList.isvalidindex( tierIndex ) )
		tierIndex = 0

	if ( tierDataList.isvalidindex( tierIndex ) )
	{
		if ( GladiatorCardBadge_HasOwnRUI( badge ) )
		{
			badgeData.ruiAsset = tierDataList[tierIndex].ruiAsset
		}
		else
		{
			if ( GladiatorCardBadge_IsOversizedImage( badge ) )
				badgeData.ruiAsset = $"ui/gcard_badge_oversized.rpak"
			else
				badgeData.ruiAsset = $"ui/gcard_badge_basic.rpak"

			badgeData.imageAsset = tierDataList[tierIndex].imageAsset
		}
	}

	return badgeData
}




var function CreateNestedGladiatorCardBadge( var parentRui, string argName, EHI playerEHI, ItemFlavor badge, int badgeIndex, ItemFlavor ornull character = null, int ornull overrideDataIntegerOrNull = null, bool showOneTierHigherThanIsUnlocked = false )
{
	GladCardBadgeDisplayData gcbdd = GetBadgeData( playerEHI, character, badgeIndex, badge, overrideDataIntegerOrNull, showOneTierHigherThanIsUnlocked )

	if ( gcbdd.ruiAsset == $"" )
	{
		gcbdd.ruiAsset = $"ui/gcard_badge_basic.rpak" 
		gcbdd.imageAsset = $"rui/gladiator_cards/badge_empty"
	}

	var nestedRui = RuiCreateNested( parentRui, argName, gcbdd.ruiAsset )

	RuiSetInt( nestedRui, "tier", gcbdd.dataInteger )
	if ( gcbdd.imageAsset != $"" )
		RuiSetImage( nestedRui, "img", gcbdd.imageAsset )

	return nestedRui
}




void function DisplayGladiatorCardSidePane( int situation, int playerEHI, asset icon, string titleText, string subtitleText )
{
	Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
	EndSignal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )

	if ( GetBugReproNum() == 8675309 )
		fileLevel.sidePaneRui = CreateFullscreenPostFXRui( $"ui/gladiator_card_side_pane.rpak", RUI_SORT_GLADCARD )
	else
		fileLevel.sidePaneRui = CreateFullscreenRui( $"ui/gladiator_card_side_pane.rpak", RUI_SORT_GLADCARD )

	RuiSetImage( fileLevel.sidePaneRui, "titleIcon", icon )
	RuiSetString( fileLevel.sidePaneRui, "titleText", Localize( titleText ) ) 
	if ( EHIHasValidScriptStruct( playerEHI ) )
	{
		if ( situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED )
			RuiSetString( fileLevel.sidePaneRui, "playerName", GetKillerNameFromEHI( playerEHI ) )
		else
			RuiSetString( fileLevel.sidePaneRui, "playerName", GetDisplayablePlayerNameFromEHI( playerEHI ) )
	}

	
	
	NestedGladiatorCardHandle nestedGCHandle = CreateNestedGladiatorCard( fileLevel.sidePaneRui, "card", situation, eGladCardPresentation.FULL_BOX )
	ChangeNestedGladiatorCardOwner( nestedGCHandle, playerEHI, null, eGladCardLifestateOverride.ALIVE )
	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_Survival_Intro_Banner_Appear" )

	if ( situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED )
		fileLevel.situationPlayer = playerEHI

	OnThreadEnd( void function() : ( nestedGCHandle ) {
		CleanupNestedGladiatorCard( nestedGCHandle )
		RuiDestroyIfAlive( fileLevel.sidePaneRui )
		fileLevel.sidePaneRui = null
		fileLevel.situationPlayer = EHI_null
	} )

	WaitForever()
}




entity function GetSituationPlayer()
{
	return FromEHI( fileLevel.situationPlayer )
}




void function OnWinnerDetermined()
{
	if ( IsSpectating() )    
		HideGladiatorCardSidePane()
}




void function HideGladiatorCardSidePane( bool instant = false )
{
	if ( !instant && fileLevel.sidePaneRui != null )
	{
		thread HideGladiatorCardSidePaneThreaded()
	}
	else
	{
		Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
	}
}




void function HideGladiatorCardSidePaneThreaded( float totalWaitTime = 1.1 )
{
	
	wait totalWaitTime
	Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
}





































































const float LOADING_COVER_FADE_TIME = 0.13
const float LOADING_COVER_HOLD_TIME = 0.48
const float LOADING_COVER_OUT_TIME = LOADING_COVER_FADE_TIME + LOADING_COVER_HOLD_TIME



void function UIToClient_SetupMenuGladCard( var panel, string argName, bool isForLocalPlayer, bool isParentAlreadyDead )
{
	if ( !IsValidSignal( "HaltMenuGladCardThread" ) )
		return

	Signal( fileLevel, "HaltMenuGladCardThread" )

	string playerUID = ""
	if ( isForLocalPlayer )
	{
		playerUID = GetPlayerUID()
	}

	if ( playerUID in fileLevel.currentMenuGladCardPanel && fileLevel.currentMenuGladCardPanel[ playerUID ] != null )
	{
		CleanupNestedGladiatorCard( fileLevel.currentMenuGladCardHandle[ playerUID ], isParentAlreadyDead )
		delete fileLevel.currentMenuGladCardPanel[ playerUID ]
	}

	fileLevel.currentMenuGladCardPanel[ playerUID ] <- panel
	if ( panel != null )
	{
		Hud_SetAboveBlur( panel, true )
		var rui = Hud_GetRui( panel )

		fileLevel.currentMenuGladCardHandle[ playerUID ] <- CreateNestedGladiatorCard( rui, argName, eGladCardDisplaySituation.MENU_CUSTOMIZE_ANIMATED, eGladCardPresentation.FULL_BOX )
		thread MenuGladCardThread( isForLocalPlayer, playerUID )
	}
}


void function UIToClient_SetupMenuGladCardRTK( rtk_panel panel, string argName, bool isForLocalPlayer, string playerUID, bool isParentAlreadyDead, int situation, int presentation )
{
	if ( !IsValidSignal( "HaltMenuGladCardThread" ) )
		return

	Signal( fileLevel, "HaltMenuGladCardThread" )

	if ( playerUID == "" )
		playerUID = GetPlayerUID()

	if ( playerUID in fileLevel.currentMenuGladCardPanel && fileLevel.currentMenuGladCardPanel[ playerUID ] != null  )
	{
		CleanupNestedGladiatorCard( fileLevel.currentMenuGladCardHandle[ playerUID ], isParentAlreadyDead )
		delete fileLevel.currentMenuGladCardPanel[ playerUID ]
	}

	fileLevel.currentMenuGladCardPanel[ playerUID ] <- panel
	if ( fileLevel.currentMenuGladCardPanel[ playerUID ] != null )
	{
		var rui = RTKPanel_GetPersistentRui( panel )

		fileLevel.currentMenuGladCardHandle[ playerUID ] <- CreateNestedGladiatorCard( rui, argName, situation, presentation )
		thread MenuGladCardThread( isForLocalPlayer, playerUID )
	}
}






void function MenuGladCardThread( bool isForLocalPlayer, string playerUID )
{
	EndSignal( fileLevel, "HaltMenuGladCardThread" )

	OnThreadEnd( void function() {
		fileLevel.menuGladCardPreviewCommandQueue.clear()
	} )

	EHI playerEHI = EHI_null

	if ( !isForLocalPlayer )
	{
		if ( playerUID == "" )
		{
			playerEHI = ToEHI( clGlobal.levelEnt )
		}
		else
		{
			playerEHI = GetEHIFromUID( playerUID )
		}
	}

	if ( playerEHI == EHI_null )
		playerEHI = LocalClientEHI()

	ChangeNestedGladiatorCardOwner( fileLevel.currentMenuGladCardHandle[ playerUID ], playerEHI, Time() )
	RuiSetGameTime( fileLevel.currentMenuGladCardHandle[ playerUID ].cardRui, "menuGladCardRevealAt", Time() )

	while ( true )
	{
		while ( fileLevel.menuGladCardPreviewCommandQueue.len() == 0 )
			WaitFrame()

		bool commandsRequireFade = false
		foreach ( MenuGladCardPreviewCommand mgcpc in fileLevel.menuGladCardPreviewCommandQueue )
		{
			if ( mgcpc.previewType == eGladCardPreviewCommandType.FRAME || mgcpc.previewType == eGladCardPreviewCommandType.STANCE )
			{
				commandsRequireFade = true
				break
			}
		}

		if ( commandsRequireFade )
		{
			RuiSetGameTime( fileLevel.currentMenuGladCardHandle[ playerUID ].cardRui, "menuGladCardRevealAt", Time() + LOADING_COVER_OUT_TIME )
			float loadTime = Time() + LOADING_COVER_FADE_TIME + 0.1
			float playTime = Time() + LOADING_COVER_OUT_TIME + 0.02 - 0.5
			while ( Time() < loadTime )
				WaitFrame()

			ChangeNestedGladiatorCardOwner( fileLevel.currentMenuGladCardHandle[ playerUID ],
				fileLevel.currentMenuGladCardHandle[ playerUID ].currentOwnerEHI,
				playTime )
		}

		while ( fileLevel.menuGladCardPreviewCommandQueue.len() > 0 )
		{
			MenuGladCardPreviewCommand mgcpc = fileLevel.menuGladCardPreviewCommandQueue.pop()
			switch( mgcpc.previewType )
			{
				case eGladCardPreviewCommandType.CHARACTER:
				{
					SetNestedGladiatorCardOverrideCharacter( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.SKIN:
				{
					SetNestedGladiatorCardOverrideSkin( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.FRAME:
				{
					SetNestedGladiatorCardOverrideFrame( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.STANCE:
				{
					SetNestedGladiatorCardOverrideStance( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.MELEE_SKIN:
				{
					SetNestedGladiatorCardOverrideMeleeSkin( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.BADGE:
				{
					SetNestedGladiatorCardOverrideBadge( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.index, mgcpc.flavOrNull, mgcpc.dataInteger )
					break
				}

				case eGladCardPreviewCommandType.TRACKER_STAT:
				{
					SetNestedGladiatorCardOverrideTracker( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.index, mgcpc.flavOrNull, mgcpc.dataInteger )
					break
				}

				case eGladCardPreviewCommandType.TRACKER_ART:
				{
					SetNestedGladiatorCardOverrideTrackerArt( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.index, mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.NAME:
				{
					SetNestedGladiatorCardOverrideName( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.previewString )
					break
				}

				case eGladCardPreviewCommandType.RANKED_SHOULD_SHOW:
				{
					SetNestedGladiatorCardOverrideRankedShouldShow( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.index )
					break
				}


					case eGladCardPreviewCommandType.ARENAS_RANKED_SHOULD_SHOW:
					{
						SetNestedGladiatorCardOverrideArenasRankedShouldShow( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.index )
						break
					}


				case eGladCardPreviewCommandType.RANKED_DATA:
				{
					SetNestedGladiatorCardOverrideRankedDetails( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.dataInteger, mgcpc.index )
					break
				}
				case eGladCardPreviewCommandType.RANKED_DATA_PREV:
				{
					SetNestedGladiatorCardOverrideRankedDetailsPreviousSeason( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.dataInteger, mgcpc.index )
					break
				}


					case eGladCardPreviewCommandType.ARENAS_RANKED_DATA:
					{
						SetNestedGladiatorCardOverrideArenasRankedDetails( fileLevel.currentMenuGladCardHandle[ playerUID ], mgcpc.dataInteger, mgcpc.index )
						break
					}

			}
		}
	}
}



void function UIToClient_HandleMenuGladCardPreviewCommand( int previewType, int index, int guid, int dataInteger )
{
	ItemFlavor ornull flavOrNull
	if ( guid != 0 )
		flavOrNull = GetItemFlavorByGUID( guid )

	Assert( fileLevel.currentMenuGladCardPanel.len() > 0 )

	MenuGladCardPreviewCommand mgcpc
	mgcpc.previewType = previewType
	mgcpc.index = index
	mgcpc.flavOrNull = flavOrNull
	mgcpc.dataInteger = dataInteger
	fileLevel.menuGladCardPreviewCommandQueue.append( mgcpc )
}




void function UIToClient_HandleMenuGladCardPreviewString( int previewType, int index, string previewName )
{
	Assert( fileLevel.currentMenuGladCardPanel.len() > 0 )
	Assert( previewType == eGladCardPreviewCommandType.NAME )

	MenuGladCardPreviewCommand mgcpc
	mgcpc.previewType = previewType
	mgcpc.index = index
	mgcpc.flavOrNull = null
	mgcpc.previewString = previewName
	fileLevel.menuGladCardPreviewCommandQueue.append( mgcpc )
}









#if DEV
void function DEV_DumpCharacterCaptures()
{
	foreach ( string key, CharacterCaptureState ccs in fileLevel.ccsMap )
	{
		printf( "%s -- %s", key, DEV_ArrayConcat( ccs.DEV_culprits ) )
		printf( "%s, %s, %s, %s, %s, %s", string(FromEHI( ccs.playerEHI )), ccs.isMoving ? "moving" : "still",
			DEV_ItemFlavor_GetCleanedAssetPath( ccs.character ), DEV_ItemFlavor_GetCleanedAssetPath( ccs.skin ), ccs.frameOrNull == null ? "null" : DEV_ItemFlavor_GetCleanedAssetPath( expect ItemFlavor(ccs.frameOrNull) ), DEV_ItemFlavor_GetCleanedAssetPath( ccs.stance ) )
	}
}
#endif


#if DEV
void function DEV_GladiatorCards_ToggleForceMoving( bool ornull forceTo = null )
{
	fileLevel.DEV_forceMoving = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_forceMoving)
}
#endif


#if DEV
void function DEV_GladiatorCards_ToggleShowSafeAreaOverlay( bool ornull forceTo = null )
{
	fileLevel.DEV_showSafeAreaOverlay = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_showSafeAreaOverlay)

	foreach ( EHI unused, array<NestedGladiatorCardHandle> handleList in fileLevel.ownerNestedCardListMap )
	{
		foreach ( NestedGladiatorCardHandle handle in handleList )
		{
			TriggerNestedGladiatorCardUpdate( handle )
		}
	}
}
#endif


#if DEV
void function DEV_GladiatorCards_ToggleCameraAlpha( bool ornull forceTo = null )
{
	fileLevel.DEV_disableCameraAlpha = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_disableCameraAlpha)
}
#endif


#if DEV
void function GladCardDebug( string nameOverride = "" )
{
	printt( "GladCard:" )

	LoadoutEntry characterSlot = Loadout_Character()

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), characterSlot )

	LoadoutEntry skinSlot = Loadout_CharacterSkin( character )
	ItemFlavor skin       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), skinSlot )

	LoadoutEntry frameSlot = Loadout_GladiatorCardFrame( character )
	ItemFlavor frame       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), frameSlot )

	LoadoutEntry stanceSlot = Loadout_GladiatorCardStance( character )
	ItemFlavor stance       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), stanceSlot )

	LoadoutEntry badge1Slot = Loadout_GladiatorCardBadge( character, 0 )
	ItemFlavor badge1       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge1Slot )
	int badge1DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge1, 0, character )

	LoadoutEntry badge2Slot = Loadout_GladiatorCardBadge( character, 1 )
	ItemFlavor badge2       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge2Slot )
	int badge2DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge2, 1, character )

	LoadoutEntry badge3Slot = Loadout_GladiatorCardBadge( character, 2 )
	ItemFlavor badge3       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge3Slot )
	int badge3DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge3, 2, character )

	if ( nameOverride == "" )
		nameOverride = GetLocalClientPlayer().GetPlayerName()

	printt( nameOverride + "," + ItemFlavor_GetGUIDString( character ) + "," + ItemFlavor_GetGUIDString( skin ) + ","
	+ ItemFlavor_GetGUIDString( frame ) + "," + ItemFlavor_GetGUIDString( stance ) + "," + ItemFlavor_GetGUIDString( badge1 ) + ","
	+ badge1DataInt + "," + ItemFlavor_GetGUIDString( badge2 ) + "," + badge2DataInt + "," + ItemFlavor_GetGUIDString( badge3 ) + "," + badge3DataInt )
}
#endif










void function OnItemFlavorRegistered_Character( ItemFlavor characterClass )
{

		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( Loadout_CharacterSkin( characterClass ), OnGladiatorCardSlotChanged )


	
	
	bool setShouldContainANonGRXItem = CharacterClass_GetIsShippingCharacter( characterClass )
	
	{
		array<ItemFlavor> frameList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardFrames", "flavor" )
		MakeItemFlavorSet( frameList, fileLevel.cosmeticFlavorSortOrdinalMap, setShouldContainANonGRXItem )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_frame_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
		entry.category     = eLoadoutCategory.GCARD_FRAMES
#if DEV
			entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			entry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Frame"
#endif
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_FRAME
		entry.defaultItemFlavor 	= frameList[0]
		entry.validItemFlavorList       = frameList
		entry.isSlotLocked              = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.associatedCharacterOrNull = characterClass
		entry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName            = "GladiatorCardFrame"

			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )

		fileLevel.loadoutCharacterFrameSlotMap[characterClass] <- entry
	}

	
	{
		array<ItemFlavor> stanceList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardStances", "flavor" )
		MakeItemFlavorSet( stanceList, fileLevel.cosmeticFlavorSortOrdinalMap, setShouldContainANonGRXItem )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_stance_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER	)
		entry.category     = eLoadoutCategory.GCARD_STANCES
#if DEV
			entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			entry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Stance"
#endif
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_STANCE
		entry.defaultItemFlavor         = stanceList[0]
		entry.validItemFlavorList       = stanceList
		entry.isSlotLocked              = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.associatedCharacterOrNull = characterClass
		entry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName            = "GladiatorCardStance"

			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )

		fileLevel.loadoutCharacterStanceSlotMap[characterClass] <- entry
	}

	array<ItemFlavor> badgeList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardBadges", "flavor" )




































	MakeItemFlavorSet( badgeList, fileLevel.cosmeticFlavorSortOrdinalMap, setShouldContainANonGRXItem )
	fileLevel.loadoutCharacterBadgesSlotListMap[characterClass] <- []
	fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass] <- []

	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_badge_" + badgeIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
		entry.category     = eLoadoutCategory.GCARD_BADGES
#if DEV
			entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			entry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Badge " + badgeIndex
#endif
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_BADGE1 + 2 * badgeIndex
		entry.validItemFlavorList       = badgeList
		if ( badgeIndex == 0 && badgeList.len() > 1 )
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 1 ]
		}
		else
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 0 ]
		}
		entry.isItemFlavorUnlocked      = (bool function( EHI playerEHI, ItemFlavor badge, bool shouldIgnoreGRX = false, bool shouldIgnoreOtherSlots = false ) : ( characterClass, badgeIndex ) {
			bool isGRXWithStat = GladiatorCardBadge_IsGRXWithStat( badge )
			bool isGRXUnlockedForLoadout = IsItemFlavorGRXUnlockedForLoadoutSlot( playerEHI, badge, shouldIgnoreGRX, shouldIgnoreOtherSlots )

			if ( !isGRXUnlockedForLoadout && !isGRXWithStat )
			{
				return false
			}

			return ( isGRXUnlockedForLoadout && isGRXWithStat ) || Loadout_GetPlayerBadgeIsUnlocked( playerEHI, badge, characterClass )
		})
		entry.isSlotLocked              = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.associatedCharacterOrNull = characterClass
		entry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName            = "GladiatorCardBadge" + badgeIndex

			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )






























		fileLevel.loadoutCharacterBadgesSlotListMap[characterClass].append( entry )

		LoadoutEntry tierEntry = RegisterLoadoutSlot( eLoadoutEntryType.INTEGER, "gcard_badge_" + badgeIndex + "_tier_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
		tierEntry.category     = eLoadoutCategory.GCARD_BADGE_TIER
#if DEV
			tierEntry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			tierEntry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Badge" + badgeIndex + " Tier"
#endif
		tierEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_BADGE1_TIER + 2 * badgeIndex
		
		tierEntry.associatedCharacterOrNull = characterClass
		tierEntry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		tierEntry.networkVarName            = "GladiatorCardBadge" + badgeIndex + "Tier"

			





		fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass].append( tierEntry )
	}

	array<ItemFlavor> trackerList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardStatTrackers", "flavor" )
	foreach ( int index, ItemFlavor tracker in clone trackerList )
	{




		switch ( GladiatorCardStatTracker_GetTrackerType( tracker ) )
		{
			case eTrackerType.ART:
				trackerList.fastremovebyvalue( tracker )
				

			case eTrackerType.BOTH:
				fileLevel.trackerArtFlavors[ tracker ] <- true 
		}
	}

















	MakeItemFlavorSet( trackerList, fileLevel.cosmeticFlavorSortOrdinalMap, setShouldContainANonGRXItem )
	fileLevel.loadoutCharacterTrackersSlotListMap[characterClass] <- []
	fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass] <- []
	fileLevel.loadoutCharacterTrackersArtSlotListMap[characterClass] <- []

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
	{
		LoadoutEntry statEntry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_tracker_" + trackerIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
		statEntry.category     = eLoadoutCategory.GCARD_TRACKER_STATS
#if DEV
			statEntry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			statEntry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Tracker Stat " + trackerIndex
#endif
		statEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_TRACKER1_STAT + 2 * trackerIndex
		statEntry.validItemFlavorList       = trackerList
		statEntry.defaultItemFlavor         = trackerList[ 0 ]
		statEntry.isSlotLocked              = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		statEntry.associatedCharacterOrNull = characterClass
		statEntry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		statEntry.networkVarName            = "GladiatorCardTrackerStat" + trackerIndex

			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( statEntry, OnGladiatorCardSlotChanged )

		fileLevel.loadoutCharacterTrackersSlotListMap[characterClass].append( statEntry )

		LoadoutEntry valueEntry = RegisterLoadoutSlot( eLoadoutEntryType.INTEGER, "gcard_tracker_" + trackerIndex + "_value_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
		valueEntry.category     = eLoadoutCategory.GCARD_TRACKER_STAT_VALUE
#if DEV
			valueEntry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
			valueEntry.DEV_name       = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Tracker Stat " + trackerIndex + " Value"
#endif
		valueEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_TRACKER1_VALUE + 2 * trackerIndex
		
		valueEntry.associatedCharacterOrNull = characterClass
		valueEntry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
		valueEntry.networkVarName            = "GladiatorCardTrackerStat" + trackerIndex + "Value"

			AddCallback_IntegerLoadoutSlotDidChange_AnyPlayer( valueEntry, void function( EHI playerEHI, int value ) : ( trackerIndex ) {
				OnGladiatorCardStatTrackerValueChanged( playerEHI, value, trackerIndex )
			} )





		fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass].append( valueEntry )






	}
}



void function BuildTrackerArtLoadouts()
{
	array< ItemFlavor > trackerArtFlavors = []
	foreach ( ItemFlavor tracker, bool _ in fileLevel.trackerArtFlavors )
		trackerArtFlavors.append( tracker )











	MakeItemFlavorSet( trackerArtFlavors, fileLevel.cosmeticFlavorSortOrdinalMapArt, false )
	foreach ( ItemFlavor characterClass, array< LoadoutEntry > _ in fileLevel.loadoutCharacterTrackersSlotListMap )
	{
		for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
		{
			LoadoutEntry artEntry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_tracker_art_" + trackerIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ), eLoadoutEntryClass.CHARACTER )
			artEntry.category = eLoadoutCategory.GCARD_TRACKER_ART
#if DEV
				artEntry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
				artEntry.DEV_name = ItemFlavor_GetCharacterRef( characterClass ) + " GCard Tracker Art " + trackerIndex
#endif
			artEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_TRACKER1_ART + 1 * trackerIndex
			artEntry.validItemFlavorList       = trackerArtFlavors
			artEntry.defaultItemFlavor         = trackerArtFlavors[ 0 ]
			artEntry.isSlotLocked              = bool function( EHI playerEHI ) {
				return !IsLobby()
			}
			artEntry.associatedCharacterOrNull = characterClass
			artEntry.networkTo                 = eLoadoutNetworking.PLAYER_GLOBAL
			artEntry.networkVarName            = "GladiatorCardTrackerArt" + trackerIndex

				AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( artEntry, OnGladiatorCardSlotChanged )

			fileLevel.loadoutCharacterTrackersArtSlotListMap[characterClass].append( artEntry )
		}
	}
}



















void function OnYouDied( entity attacker, float healthFrac, int damageSourceId, float recentHealthDamage )
{
	
	if( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	if ( !IsValid( attacker ) || !attacker.IsPlayer() || ( attacker == GetLocalViewPlayer() ) )
		return

	thread PlayKillQuipThread( GetLocalClientPlayer(), ToEHI( attacker ), null, 2.0 )
}




void function OnSpectateStarted( entity spectatingPlayer, entity spectatorTarget )
{
	
	HideGladiatorCardSidePane( true )
}




void function OnYouRespawned()
{
	
	
	HideGladiatorCardSidePane( true )
}






































































void function TriggerNestedGladiatorCardUpdate( NestedGladiatorCardHandle handle )
{
	if ( handle.updateQueued )
		return

	handle.updateQueued = true
	thread ActualUpdateNestedGladiatorCard( handle )
}




void function ActualUpdateNestedGladiatorCard( NestedGladiatorCardHandle handle )
{
	WaitEndFrame()

	ItemFlavor ornull characterOrNull = null
	ItemFlavor ornull skinOrNull      = null
	ItemFlavor ornull frameOrNull     = null
	ItemFlavor ornull stanceOrNull    = null
	ItemFlavor ornull meleeSkinOrNull = null

	string platformString		= ""

	string frameRpakPath                               = ""
	bool frameHasOwnRUI                                = false
	bool isArtFullFrame                                = false
	asset fgFrameRuiAsset                              = $""
	asset fgFrameImageAsset                            = $""
	float fgFrameBlend                                 = 1.0
	float fgFramePremul                                = 0.0
	asset bgFrameRuiAsset                              = $""
	asset bgFrameImageAsset                            = $""
	int[GLADIATOR_CARDS_NUM_BADGES] badgeTiers         = [ -1, -1, -1 ]
	asset[GLADIATOR_CARDS_NUM_BADGES] badgeRuiAssets   = [ $"", $"", $"" ]
	asset[GLADIATOR_CARDS_NUM_BADGES] badgeImageAssets = [ $"", $"", $"" ]

	vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] keyColors

	bool isAlive        = false
	string playerName   = ""
	int teamMemberIndex = -1

	if ( handle.cardRui != null )
	{
		bool havePlayer = (handle.currentOwnerEHI != EHI_null)
		if ( havePlayer )
		{
			entity currentOwner = FromEHI( handle.currentOwnerEHI )

			isAlive = IsAlive( currentOwner )

			if ( handle.overrideName != null )
			{
				playerName = expect string(handle.overrideName)
			}
			else if ( EHIHasValidScriptStruct( handle.currentOwnerEHI ) )
			{
				if ( handle.situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED || handle.isKiller )
					playerName = GetKillerNameFromEHI( handle.currentOwnerEHI )
				else if ( handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_ANIMATED || handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_STILL )
					playerName = GetPlayerNameUnlessAnonymized( handle.currentOwnerEHI )
				else
					playerName = GetDisplayablePlayerNameFromEHI( handle.currentOwnerEHI )
			}

			if ( EHIHasValidScriptStruct( handle.currentOwnerEHI ) )
			{
				teamMemberIndex = EHI_GetTeamMemberIndex( handle.currentOwnerEHI )
				if ( CrossplayUserOptIn() )
					platformString = PlatformIDToIconString( EHI_GetPlatformID( handle.currentOwnerEHI ) )
			}
		}

		if ( handle.overrideCharacter != null )
			characterOrNull = handle.overrideCharacter

		LoadoutEntry characterSlot = Loadout_Character()
		if ( characterOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, characterSlot ) )
			characterOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, characterSlot )

		if ( characterOrNull != null )
		{
			ItemFlavor character = expect ItemFlavor(characterOrNull)

			if ( handle.isFrontFace )
			{
				if ( handle.overrideSkin != null )
					skinOrNull = handle.overrideSkin

				LoadoutEntry skinSlot = Loadout_CharacterSkin( character )
				if ( skinOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, skinSlot ) )
					skinOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, skinSlot )

				if ( handle.presentation != eGladCardPresentation.FRONT_FRAME_ONLY )
				{
					if ( handle.overrideStance != null )
					{
						stanceOrNull = handle.overrideStance
						
						if ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( expect ItemFlavor(stanceOrNull) ), "parentItemFlavor" ) == "" )
						{
							Warning( "Attempted to use gladiator card stance - which has NO parentItemFlavor - %s on %s", string(ItemFlavor_GetAsset( expect ItemFlavor(stanceOrNull) )), string(ItemFlavor_GetAsset( character )) )
							stanceOrNull = null
						}
						else if ( GladiatorCardStance_GetCharacterFlavor( expect ItemFlavor(stanceOrNull) ) != characterOrNull )
						{
							Warning( "Attempted to use gladiator card stance %s on %s", string(ItemFlavor_GetAsset( expect ItemFlavor(stanceOrNull) )), string(ItemFlavor_GetAsset( character )) )
							stanceOrNull = null
						}
					}

					LoadoutEntry stanceSlot = Loadout_GladiatorCardStance( character )
					if ( stanceOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, stanceSlot ) )
						stanceOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, stanceSlot )
				}

				if ( handle.overrideFrame != null )
					frameOrNull = handle.overrideFrame

				LoadoutEntry frameSlot = Loadout_GladiatorCardFrame( character )
				if ( frameOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, frameSlot ) )
				{
					frameOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, frameSlot )
				}

				if ( handle.overrideMeleeSkin != null )
					meleeSkinOrNull = handle.overrideMeleeSkin

				LoadoutEntry meleeSkinSlot = Loadout_MeleeSkin( character )
				if ( meleeSkinOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, meleeSkinSlot ) )
				{
					meleeSkinOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, meleeSkinSlot )
				}
			}

			bool wantsBadges = handle.isBackFace || handle.presentation == eGladCardPresentation.FRONT_DETAILS
			if ( wantsBadges )
			{
				for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
				{
					ItemFlavor ornull badgeOrNull = null

					int ornull overrideDataIntegerOrNull = null
					if ( handle.overrideBadgeList[badgeIndex] != null )
					{
						badgeOrNull = handle.overrideBadgeList[badgeIndex]
						overrideDataIntegerOrNull = handle.overrideBadgeDataIntegerList[badgeIndex]
					}

					LoadoutEntry badgeSlot = Loadout_GladiatorCardBadge( character, badgeIndex )
					if ( badgeOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, badgeSlot ) )
					{
						badgeOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, badgeSlot )
					}

					if ( badgeOrNull != null )
					{
						ItemFlavor badge               = expect ItemFlavor(badgeOrNull)
						GladCardBadgeDisplayData gcbdd = GetBadgeData( handle.currentOwnerEHI, character, badgeIndex, badge, overrideDataIntegerOrNull )
						badgeRuiAssets[badgeIndex] = gcbdd.ruiAsset
						badgeImageAssets[badgeIndex] = gcbdd.imageAsset
						badgeTiers[badgeIndex] = gcbdd.dataInteger
					}
				}
			}
		}
	}

	if ( handle.presentation == eGladCardPresentation.FRONT_STANCE_ONLY )
	{
		fgFrameRuiAsset = $"ui/gcard_frame_stance_preview.rpak"
		bgFrameRuiAsset = $""
	}
	else if ( frameOrNull != null )
	{
		ItemFlavor frame = expect ItemFlavor(frameOrNull)
		frameRpakPath = ItemFlavor_GetCleanDownloadAssetPath_Slow( frame ) 
		if ( frameRpakPath == "gcard_frame__temp" )
			frameRpakPath = ""

		if ( GladiatorCardFrame_HasOwnRUI( frame ) )
		{
			frameHasOwnRUI = true
			fgFrameRuiAsset = GladiatorCardFrame_GetFGRuiAsset( frame )
			bgFrameRuiAsset = GladiatorCardFrame_GetBGRuiAsset( frame )
		}
		else
		{
			isArtFullFrame = GladiatorCardFrame_IsArtFullFrame( frame )
			fgFrameRuiAsset = $"ui/gcard_frame_basic_fg.rpak"
			bgFrameRuiAsset = $"ui/gcard_frame_basic_bg.rpak"
			fgFrameImageAsset = GladiatorCardFrame_GetFGImageAsset( frame )
			fgFrameBlend = GladiatorCardFrame_GetFGImageBlend( frame )
			fgFramePremul = GladiatorCardFrame_GetFGImagePremul( frame )
			bgFrameImageAsset = GladiatorCardFrame_GetBGImageAsset( frame )
		}

		keyColors = GladiatorCardFrame_GetKeyColors( frame )
	}

	bool characterCaptureDesired = handle.isFrontFace && (skinOrNull != null && stanceOrNull != null)
	ManageCharacterCaptureStateForNestedCard( handle, characterCaptureDesired, characterOrNull, skinOrNull, frameOrNull, stanceOrNull, meleeSkinOrNull )

	string currentFrameRpakLoaded = ""
	if ( handle.framePakHandleOrNull != null )
	{
		PakHandle framePakHandle = expect PakHandle(handle.framePakHandleOrNull)
		currentFrameRpakLoaded = framePakHandle.rpakPath
	}
	if ( currentFrameRpakLoaded != frameRpakPath )
	{
		if ( handle.framePakHandleOrNull != null )
		{
			ReleasePakFile( expect PakHandle(handle.framePakHandleOrNull) )
			handle.framePakHandleOrNull = null
		}
		if ( frameRpakPath != "" )
		{
			handle.framePakHandleOrNull = RequestPakFile( frameRpakPath, TRACK_FEATURE_UI, void function() : ( handle ) {
				if ( handle.cardRui != null )
					TriggerNestedGladiatorCardUpdate( handle )
			} )
		}
	}
	if ( handle.framePakHandleOrNull != null )
	{
		PakHandle framePakHandle = expect PakHandle(handle.framePakHandleOrNull)
		if ( !framePakHandle.isAvailable )
		{
			bgFrameRuiAsset = $""
			fgFrameRuiAsset = $""
		}
	}

	if ( handle.cardRui != null && RuiIsAlive( handle.cardRui ) )
	{
		RuiSetString( handle.cardRui, "playerName", playerName )
		RuiSetInt( handle.cardRui, "teamMemberIndex", teamMemberIndex )
		RuiSetBool( handle.cardRui, "shouldShowDetails", handle.shouldShowDetails )

		for ( int idx = 0; idx < GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS; idx++ )
			RuiSetFloat3( handle.cardRui, "keyCol" + idx, keyColors[idx] )

		if ( handle.isFrontFace )
		{
			Assert( handle.parentRui != null )
			RuiSetBool( handle.cardRui, "isAlive", isAlive || IsLobby() )
#if DEV
				RuiSetBool( handle.cardRui, "devShowSafeAreaOverlay", fileLevel.DEV_showSafeAreaOverlay )
#endif

			var bgFrameRui = UpdateGladiatorCardNestedWidget( handle, "bgFrameInstance", handle.bgFrameNWS, bgFrameRuiAsset )
			if ( bgFrameRui != null )
			{
				if ( !frameHasOwnRUI )
				{
					RuiSetBool( bgFrameRui, "isArtFullFrame", isArtFullFrame )
					RuiSetImage( bgFrameRui, "bgImage", bgFrameImageAsset )
				}
			}

			var fgFrameRui = UpdateGladiatorCardNestedWidget( handle, "fgFrameInstance", handle.fgFrameNWS, fgFrameRuiAsset )
			if ( fgFrameRui != null )
			{
				
				int stancePIPSlotIndex = -1
				if ( handle.characterCaptureStateOrNull != null )
				{
					CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
					if ( ccs.stancePIPSlotStateOrNull != null )
						stancePIPSlotIndex = PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) )

					if ( handle.onStancePIPSlotReadyFunc == null )
					{
						handle.onStancePIPSlotReadyFunc = void function( int stancePIPSlotIndex, float movingSeqEndTime ) : ( handle )
						{
							
							if ( handle.cardRui != null && handle.fgFrameNWS.rui != null )
							{
								RuiSetGameTime( handle.cardRui, "movingSeqEndTime", movingSeqEndTime )
								RuiSetInt( handle.fgFrameNWS.rui, "stancePIPSlot", stancePIPSlotIndex )

								
								
							}
							
						}
					}
					if ( !(handle.onStancePIPSlotReadyFunc in ccs.onPIPSlotReadyFuncSet) )
						ccs.onPIPSlotReadyFuncSet[handle.onStancePIPSlotReadyFunc] <- true
				}
				RuiSetInt( fgFrameRui, "stancePIPSlot", stancePIPSlotIndex )

				if ( !frameHasOwnRUI )
				{
					RuiSetBool( fgFrameRui, "isArtFullFrame", isArtFullFrame )
					RuiSetImage( fgFrameRui, "fgImage", fgFrameImageAsset )
					RuiSetFloat( fgFrameRui, "fgImageBlend", fgFrameBlend )
					RuiSetFloat( fgFrameRui, "fgImagePremul", fgFramePremul )
					RuiSetImage( fgFrameRui, "bgImage", bgFrameImageAsset )
				}
			}
		}

		if ( handle.isBackFace )
		{
			UpdateStatTrackersOfNestedGladiatorCard( handle, characterOrNull )
		}

		if ( handle.presentation == eGladCardPresentation.FULL_BOX )
		{
			RuiSetBool( handle.cardRui, "showPrevRank", false )
			RuiSetBool( handle.cardRui, "frameHasOwnRUI", frameHasOwnRUI )
			RuiSetBool( handle.cardRui, "isKiller", handle.isKiller )
			RuiSetBool( handle.cardRui, "disableBlur", handle.disableBlur )
			RuiSetString( handle.cardRui, "platformString", platformString )


			if ( UpgradeCore_GladCardShowUpgrades() )
			{
				RuiSetBool( handle.cardRui, "canShowUpgrades", handle.canShowUpgrades )
				RuiSetBool( handle.cardRui, "showUpgrades", handle.showUpgrades )
				if ( handle.showUpgrades )
				{
					entity viewPlayer = FromEHI( handle.currentOwnerEHI )
					if ( IsValid ( viewPlayer ) )
					{
						array<UpgradeCoreChoice> selectedUpgrades = UpgradeCore_GetSelectedUpgrades( viewPlayer )
						RuiSetInt( handle.cardRui, "numSlots", selectedUpgrades.len() )
						for( int i = 0; i < selectedUpgrades.len(); i++ )
						{
							array<int> upgradeChoices = UpgradeCore_GetPassiveIndexChoicesForLevel( viewPlayer, i )

							RuiSetImage( handle.cardRui, "slotImage" + i, selectedUpgrades[i].icon )
							RuiSetBool( handle.cardRui, "slotDirectionIsLeft" + i, upgradeChoices.find( selectedUpgrades[i].passiveIndex ) == 0 )
						}
					}
				}
			}


			
			{
				bool forceShowRanked = handle.rankedForceShowOrNull != null ? expect bool( handle.rankedForceShowOrNull ) : false




				bool showRanked = false
				if ( forceShowRanked )
				{
					int rankScore = handle.rankedScoreOrNull != null ? expect int( handle.rankedScoreOrNull ) : SHARED_RANKED_INVALID_RANK_SCORE
					int ladderPos = handle.rankedLadderPosOrNull != null ? expect int( handle.rankedLadderPosOrNull ) : SHARED_RANKED_INVALID_LADDER_POSITION

					int rankScorePrev = handle.rankedScoreOrNull != null ? expect int( handle.rankedScoreOrNullPrevSeason ) : SHARED_RANKED_INVALID_RANK_SCORE
					int ladderPosPrev = handle.rankedLadderPosOrNull != null ? expect int( handle.rankedLadderPosOrNullPrevSeason ) : SHARED_RANKED_INVALID_LADDER_POSITION

					PopulateRuiWithRankedBadgeDetails( handle.cardRui, rankScore, ladderPos )
					PopulateRuiWithPreviousSeasonRankedBadgeDetails ( handle.cardRui, rankScorePrev, ladderPosPrev )

					showRanked = true
				}










				else if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_RANKED ) )
				{

					int rankScore = EEHHasValidScriptStruct( handle.currentOwnerEHI ) ? GetPlayerRankScoreFromEHI( handle.currentOwnerEHI ) : SHARED_RANKED_INVALID_RANK_SCORE
					int ladderPos = EEHHasValidScriptStruct( handle.currentOwnerEHI ) ? GetPlayerLadderPosFromEHI( handle.currentOwnerEHI ) : SHARED_RANKED_INVALID_LADDER_POSITION
					int rankScorePrev = EEHHasValidScriptStruct( handle.currentOwnerEHI ) ? GetPlayerRankScorePrevSeasonFromEHI( handle.currentOwnerEHI ) : SHARED_RANKED_INVALID_RANK_SCORE
					int ladderPosPrev = EEHHasValidScriptStruct( handle.currentOwnerEHI ) ? GetPlayerLadderPosPrevSeasonFromEHI( handle.currentOwnerEHI ) : SHARED_RANKED_INVALID_LADDER_POSITION

					printt ("BadgeDebug playerName: " + playerName)
					printt ("BadgeDebug rankScore: " + rankScore )
					printt ("BadgeDebug rankScorePrev: " + rankScorePrev )

					PopulateRuiWithRankedBadgeDetails( handle.cardRui, rankScore, ladderPos )
					PopulateRuiWithPreviousSeasonRankedBadgeDetails ( handle.cardRui, rankScorePrev, ladderPosPrev )

					showRanked = Ranked_ShouldShowRankedBadge()
				}

				RuiSetBool( handle.cardRui, "showRanked", showRanked )

				if (showRanked && FromEHI(handle.currentOwnerEHI) != null && FromEHI(handle.currentOwnerEHI).GetTeam() == GetLocalClientPlayer().GetTeam() )
				{
					if (!IsLobby() )
					{
						RuiSetBool( handle.cardRui, "showPrevRank", Ranked_ShouldShowPreRankedBadge () )
					}
				}
			}
		}

		if ( handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_STILL
		|| handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_ANIMATED )
		{
			RuiSetBool( handle.cardRui, "showPrevRank", Ranked_ShouldShowPreRankedBadge ()  )
			RuiSetInt( handle.cardRui, "teamMemberIndex", -1 )
			RuiSetBool( handle.cardRui, "isChampion", (handle.currentOwnerEHI == GetGlobalNetInt( "championEEH" )) )
		}

		for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
		{
			var badgeRui = UpdateGladiatorCardNestedWidget( handle, "badge" + badgeIndex + "Instance", handle.badgeNWSList[badgeIndex], badgeRuiAssets[badgeIndex] )
			if ( badgeRui != null )
			{
				RuiSetInt( badgeRui, "tier", badgeTiers[badgeIndex] )
				if ( badgeImageAssets[badgeIndex] != $"" )
					RuiSetImage( badgeRui, "img", badgeImageAssets[badgeIndex] )
			}
		}
	}

	handle.updateQueued = false
}




var function UpdateGladiatorCardNestedWidget( NestedGladiatorCardHandle handle, string argName, NestedWidgetState nws, asset desiredRuiAsset )
{
	if ( nws.rui == null || desiredRuiAsset != nws.ruiAsset )
	{
		if ( nws.rui != null )
		{
			RuiDestroyNested( handle.cardRui, argName )
			nws.rui = null
			nws.ruiAsset = $""
		}
		if ( desiredRuiAsset != $"" )
		{
			nws.ruiAsset = desiredRuiAsset
			nws.rui = RuiCreateNested( handle.cardRui, argName, desiredRuiAsset )
		}
	}
	return nws.rui
}




void function ManageCharacterCaptureStateForNestedCard( NestedGladiatorCardHandle handle, bool characterCaptureDesired, ItemFlavor ornull characterOrNull, ItemFlavor ornull skinOrNull, ItemFlavor ornull frameOrNull, ItemFlavor ornull stanceOrNull, ItemFlavor ornull meleeSkinOrNull )
{
	bool doRelease = false
	bool doCreate  = false
	if ( characterCaptureDesired )
	{
		if ( handle.characterCaptureStateOrNull == null )
		{
			doCreate = true
		}
		else
		{
			CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
			doCreate = (ccs.character != characterOrNull || ccs.skin != skinOrNull || ccs.frameOrNull != frameOrNull || ccs.stance != stanceOrNull)
			doRelease = doCreate
		}
	}
	else if ( handle.characterCaptureStateOrNull != null )
	{
		doRelease = true
	}

	if ( doRelease )
	{
		Assert( handle.characterCaptureStateOrNull != null )
		CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)

		if ( handle.onStancePIPSlotReadyFunc in ccs.onPIPSlotReadyFuncSet )
			delete ccs.onPIPSlotReadyFuncSet[handle.onStancePIPSlotReadyFunc]

		ReleaseCharacterCapture( ccs )
#if DEV
			ccs.DEV_culprits.fastremovebyvalue( string(handle) + " " + handle.DEV_culprit )
#endif
		handle.characterCaptureStateOrNull = null
	}
	if ( doCreate )
	{
		Assert( handle.characterCaptureStateOrNull == null )
		handle.characterCaptureStateOrNull = GetOrStartCharacterCapture( handle, handle.startTime + 0.5, handle.currentOwnerEHI, handle.isMoving, expect ItemFlavor(characterOrNull), expect ItemFlavor(skinOrNull), frameOrNull, expect ItemFlavor(stanceOrNull), meleeSkinOrNull )
#if DEV
			CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
			ccs.DEV_culprits.append( string(handle) + " " + handle.DEV_culprit )
#endif
	}
}




CharacterCaptureState function GetOrStartCharacterCapture( NestedGladiatorCardHandle handle, float startTime, EHI playerEHI, bool isMoving, ItemFlavor character, ItemFlavor skin, ItemFlavor ornull frameOrNull, ItemFlavor stance, ItemFlavor ornull meleeSkinOrNull )
{
	string key = format( "%d:%s:%s:%s:%s:%s:%s",
		playerEHI, isMoving ? string(handle) : "still",
		ItemFlavor_GetGUIDString( character ), ItemFlavor_GetGUIDString( skin ),
		frameOrNull == null ? "null" : ItemFlavor_GetGUIDString( expect ItemFlavor(frameOrNull) ), ItemFlavor_GetGUIDString( stance ),
		meleeSkinOrNull == null ? "null" : ItemFlavor_GetGUIDString( expect ItemFlavor(meleeSkinOrNull) )
	)

	if ( key in fileLevel.ccsMap )
	{
		CharacterCaptureState ccs = fileLevel.ccsMap[key]
		ccs.refCount += 1
		return ccs
	}

	CharacterCaptureState ccs
	ccs.key = key
	ccs.playerEHI = playerEHI
	ccs.isMoving = isMoving
	ccs.character = character
	ccs.skin = skin
	ccs.frameOrNull = frameOrNull
	ccs.stance = stance
	ccs.meleeSkin = meleeSkinOrNull
	ccs.refCount = 1
	ccs.startTime = startTime
	fileLevel.ccsMap[key] <- ccs

	thread DoGladiatorCardCharacterCapture( ccs )
	
	

	return ccs
}




void function ReleaseCharacterCapture( CharacterCaptureState ccs )
{
	Assert( ccs.refCount > 0 )
	ccs.refCount -= 1
	if ( ccs.refCount == 0 )
	{
		Signal( ccs, "StopGladiatorCardCharacterCapture" )
		delete fileLevel.ccsMap[ccs.key]
	}
}




void function DoGladiatorCardCharacterCapture( CharacterCaptureState ccs )
{
	

	bool gladCardDebug = GetConVarBool( "gladCards_debug" )

	if ( gladCardDebug )
	{
		printf( "#GLADCARDS CC %s: Start", ccs.key )
	}

	EndSignal( ccs, "StopGladiatorCardCharacterCapture" )

	bool doMoving = ccs.isMoving && GladiatorCardStance_HasMovingAnimSeq( ccs.stance )
#if DEV
		if ( fileLevel.DEV_forceMoving )
		{
			doMoving = true
		}
#endif

	array<PIPSlotState> pipSlotsToFreeOnExit = []

	OnThreadEnd( function() : ( ccs, pipSlotsToFreeOnExit, gladCardDebug ) {
		foreach(PIPSlotState slotToFree in pipSlotsToFreeOnExit)
		{
			ReleasePIPSlot( slotToFree )
		}
		ccs.stancePIPSlotStateOrNull = null

		if ( ccs.cleanupSceneFunc != null )
		{
			ccs.cleanupSceneFunc()
		}

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s: Done", ccs.key )
		}
	} )


	PIPSlotState ornull stillSlotState = null  
	if ( !doMoving )
	{
		
		stillSlotState = AllocateStillPIPSlot( fileLevel.waitForFreePip )
		if (stillSlotState == null)
		{
			Warning("Ran out of Still PIP slots - gladiator card will not show");
			return
		}

		expect PIPSlotState ( stillSlotState )
		pipSlotsToFreeOnExit.append( stillSlotState )

		if ( GladCardCache_StreamInGladCard( ccs.playerEHI, ccs.character.guid, stillSlotState.slotIndex ) )
		{
			Assert( ccs.stancePIPSlotStateOrNull == null )
			ccs.stancePIPSlotStateOrNull = stillSlotState
			WaitSignal( stillSlotState, "GladiatorCardCacheLoaded" )

			foreach ( OnStancePIPSlotReadyFuncType cb, bool unused in ccs.onPIPSlotReadyFuncSet )
			{
				cb( PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ), -1.0 )
			}

			
			
			
			WaitForever()
		}
	}

	string movingSeq = ""
	if ( doMoving )
	{
		movingSeq = string(GladiatorCardStance_GetMovingAnimSeq( ccs.stance ))
	}
	else
	{
		if ( fileLevel.stillsInProgress.len() >= ClPip_GetMaxConcurrentCaptures() )
		{
			fileLevel.ccsStillQueue.append( ccs )

			OnThreadEnd( void function() : ( ccs ) {
				fileLevel.ccsStillQueue.removebyvalue( ccs )
			} )

			WaitSignal( ccs, "YouMayProceedWithStillCCS" )
			WaitFrame()
			fileLevel.ccsStillQueue.remove( 0 )
		}

		OnThreadEnd( function() : ( ccs ) {
			fileLevel.stillsInProgress.fastremovebyvalue( ccs )
			if ( fileLevel.ccsStillQueue.len() > 0 && fileLevel.stillsInProgress.len() < ClPip_GetMaxConcurrentCaptures())
				Signal( fileLevel.ccsStillQueue[0], "YouMayProceedWithStillCCS" )
		} )

		fileLevel.stillsInProgress.append( ccs )
	}

	if ( gladCardDebug )
	{
		printf( "#GLADCARDS CC %s: Passed queueing", ccs.key )
	}

	FlagWait( "EntitiesDidLoad" )
	WaitEndFrame() 

#if DEV
		if ( fileLevel.DEV_disableCameraAlpha && ccs.frameOrNull != null )
		{
			string frameRpakPath = DEV_ItemFlavor_GetCleanedAssetPath( expect ItemFlavor( ccs.frameOrNull ) )

			if ( frameRpakPath != "gcard_frame__temp" ) 
			{
				PakHandle framePakHandle = RequestPakFile( frameRpakPath, TRACK_FEATURE_UI )

				OnThreadEnd( function() : ( framePakHandle ) {
					if ( framePakHandle.rpakPath != "" )
						ReleasePakFile( framePakHandle )
				} )

				if ( !framePakHandle.isAvailable )
					WaitSignal( framePakHandle, "PakFileLoaded" )
			}

		}
#endif

	ccs.cleanupSceneFunc = (void function() : ( ccs, gladCardDebug )
	{
		

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %s: Cleanup", ccs.key, ccs.stancePIPSlotStateOrNull == null ? "null" : string(PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) )) )
		}

		ccs.cleanupSceneFunc = null

		foreach ( int lightIndex, entity light in ccs.lights )
		{
			if ( light == null )
				continue

			if ( ccs.lightDoesShadowsMap[lightIndex] )
			{
				
				light.SetTweakLightUpdateShadowsEveryFrame( false )
				light.SetTweakLightRealtimeShadows( false )
			}
			light.SetTweakLightDistance( 2.0 ) 
		}

#if DEV
			if ( ccs.DEV_bgRui != null )
				RuiDestroyIfAlive( ccs.DEV_bgRui )
			if ( ccs.DEV_bgTopo != null )
				RuiTopology_Destroy( ccs.DEV_bgTopo )
#endif

		if ( ccs.colorCorrectionLayer != -1 )
		{
#if DEV
				Assert( ccs.colorCorrectionLayer != GetBloodhoundColorCorrectionID(), "gladiator cards tried to release bloodhounds color correction. Related to bug R5DEV-75937. Assign bug to Roger A please." )
#endif
			ColorCorrection_Release( ccs.colorCorrectionLayer )
			ccs.colorCorrectionLayer = -1
		}

		if ( ccs.captureRoomOrNull != null )
		{
			ReleaseCaptureRoom( expect CaptureRoom( ccs.captureRoomOrNull ) )
			ccs.captureRoomOrNull = null
		}

		if ( IsValid( ccs.camera ) )
			ccs.camera.Destroy()

		if ( IsValid( ccs.lightingRig ) )
			ccs.lightingRig.Destroy()

		if ( IsValid( ccs.model ) )
			ccs.model.Destroy()

		fileLevel.stillsInProgress.fastremovebyvalue( ccs )
		if ( fileLevel.ccsStillQueue.len() > 0 && fileLevel.stillsInProgress.len() < ClPip_GetMaxConcurrentCaptures())
			Signal( fileLevel.ccsStillQueue[0], "YouMayProceedWithStillCCS" )
		
	})

	string stillSeq = string(GladiatorCardStance_GetStillAnimSeq( ccs.stance ))

	CaptureRoom room = WaitForReserveCaptureRoom()
	ccs.captureRoomOrNull = room

	vector modelPos = room.center
	vector modelAng = AnglesCompose( room.ang, <0, 180, 0> )
	ccs.model = CreateClientSidePropDynamic( modelPos, modelAng, $"mdl/dev/empty_model.rmdl" )
	ccs.model.SetForceVisibleInPhaseShift( true )
	ccs.model.MakeSafeForUIScriptHack()

	asset setFile   = CharacterClass_GetSetFile( ccs.character )
	asset bodyModel = GetGlobalSettingsAsset( setFile, "bodyModel" )
	ccs.model.SetModel( bodyModel )
	CharacterSkin_Apply( ccs.model, ccs.skin )

	
	string streamSequence = movingSeq;
	if ( streamSequence == "" )
		streamSequence = stillSeq
	while ( streamSequence != "" && !ccs.model.StreamModelsForAnim( streamSequence ) )
	{
		WaitFrame()
	}

	ccs.model.e.animWindowCosmeticItemFlavor = ccs.character
	ccs.model.e.animWindowSkinItemFlavor = ccs.skin
	ccs.model.e.animWindowMeleeSkinItemFlavor = ccs.meleeSkin

	ccs.lightingRig = CreateClientSidePropDynamic( modelPos, modelAng, SCENE_CAPTURE_LIGHTING_RIG_MODEL )
	ccs.lightingRig.MakeSafeForUIScriptHack()
	string lightingRigMovingSeq = ""
	if ( doMoving )
		lightingRigMovingSeq = string(GladiatorCardStance_GetLightingRigMovingAnimSeq( ccs.stance ))
	string lightingRigStillSeq = string(GladiatorCardStance_GetLightingRigStillAnimSeq( ccs.stance ))
	
	float cameraWidgetWidth    = 408.0
	
	float croppedCardWidth     = 264.0
	float croppedCardHeight    = 720.0

	
	
	
	
	
	

	
	
	float croppedHorizontalCameraFOV = GladiatorCardStance_GetHorizontalCameraFOV( ccs.stance )
	float clippedHorizontalCameraFOV = 2.0 * RAD_TO_DEG * atan( tan( croppedHorizontalCameraFOV / 2.0 * DEG_TO_RAD ) / croppedCardWidth * cameraWidgetWidth )

	ccs.camera = CreateClientSidePointCamera( modelPos, modelAng, clippedHorizontalCameraFOV )
	
	ccs.camera.SetParent( ccs.model, "VDU", false )
	

	float cameraExposure = 0.7
	if ( ccs.frameOrNull != null )
		cameraExposure = GladiatorCardFrame_GetExposure( expect ItemFlavor( ccs.frameOrNull ) )
	ccs.camera.SetMonitorExposure( cameraExposure )

	
	
	
	
	
	

	float farZ = 642.0

#if DEV
		if ( fileLevel.DEV_disableCameraAlpha && ccs.frameOrNull != null )
		{
			float ruiWidth       = 528.0
			float ruiHeight      = 912.0
			float ruiAspectRatio = ruiWidth / ruiHeight

			float ruiDistance = 642.0
			farZ = ruiDistance + 20.0
			
			
			
			
			

			float ruiClippedWorldWidth = 2.0 * tan( clippedHorizontalCameraFOV / 2.0 * DEG_TO_RAD ) * ruiDistance
			float ruiFullWorldWidth    = ruiClippedWorldWidth / cameraWidgetWidth * ruiWidth
			float ruiFullWorldHeight   = ruiFullWorldWidth / ruiAspectRatio

			ccs.DEV_bgTopo = RuiTopology_CreatePlane(
				<ruiDistance, 0.5 * ruiFullWorldWidth, 0.5 * ruiFullWorldHeight>,
				<0, -ruiFullWorldWidth, 0>, <0, 0, -ruiFullWorldHeight>,
				false
			)
			RuiTopology_SetParent( ccs.DEV_bgTopo, ccs.camera )

			asset bgFrameRuiAsset, bgFrameImageAsset
			if ( GladiatorCardFrame_HasOwnRUI( expect ItemFlavor(ccs.frameOrNull) ) )
			{
				bgFrameRuiAsset = GladiatorCardFrame_GetBGRuiAsset( expect ItemFlavor(ccs.frameOrNull) )
			}
			else
			{
				bgFrameRuiAsset = $"ui/gcard_frame_basic_bg.rpak"
				bgFrameImageAsset = GladiatorCardFrame_GetBGImageAsset( expect ItemFlavor(ccs.frameOrNull) )
			}
			if ( bgFrameRuiAsset != $"" )
			{
				ccs.DEV_bgRui = RuiCreate( bgFrameRuiAsset, ccs.DEV_bgTopo, RUI_DRAW_WORLD, 32767 )

				if ( bgFrameImageAsset != $"" )
					RuiSetImage( ccs.DEV_bgRui, "bgImage", bgFrameImageAsset )
			}
		}
#endif

	ccs.camera.SetMonitorZFar( farZ )

	array<string> lightAttachmentNameMap = [ "LIGHT_1", "LIGHT_2", "LIGHT_3", "LIGHT_4" ]
	foreach ( int lightIndex, string attachmentName in lightAttachmentNameMap )
	{
		if ( !room.tweakLights.isvalidindex( lightIndex ) )
		{
			ccs.lights.append( null )
			continue
		}

		entity light = room.tweakLights[lightIndex]
		if ( ccs.frameOrNull != null )
		{
			GladiatorCardFrame_SetupTweakLightFromSettings( expect ItemFlavor(ccs.frameOrNull), lightIndex, light )
		}
		else
		{
			light.SetTweakLightColor( <1, 1, 1> )
			light.SetTweakLightSpecIntensity( 1.0 )
		}
		GladiatorCardStance_SetupTweakLightFromSettings( ccs.stance, lightIndex, light )
		bool doShadows = GladiatorCardStance_DoesTweakLightRequireShadows( ccs.stance, lightIndex )
		if ( doShadows )
		{
			

			if ( gladCardDebug )
			{
				printt( "#GLADCARDS --  SHADOWS ON", lightIndex )
			}

			light.SetTweakLightRealtimeShadows( true )
			light.SetTweakLightUpdateShadowsEveryFrame( true )
		}
		ccs.lightDoesShadowsMap.append( doShadows )

		
		

		ccs.lights.append( light )
	}

	string colorCorrectionRawPath = ""
	if ( GetConVarBool( "monitor_postfx" ) && GetConVarBool( "monitor_cc" ) && ccs.frameOrNull != null )
		colorCorrectionRawPath = GladiatorCardFrame_GetColorCorrectionRawPath( expect ItemFlavor(ccs.frameOrNull) )

	ccs.colorCorrectionLayer = -1
	if ( colorCorrectionRawPath != "" )
		ccs.colorCorrectionLayer = ColorCorrection_LoadAsync( colorCorrectionRawPath )

	if ( ccs.colorCorrectionLayer != -1 )
	{
		while ( !ColorCorrection_PollAsync( ccs.colorCorrectionLayer ) )
			WaitFrame()

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s: Color correction loaded %s %d", ccs.key, colorCorrectionRawPath, ccs.colorCorrectionLayer )
		}
	}

	PIPSlotState ornull movingSlotState = BeginMovingPIP( ccs.camera, fileLevel.waitForFreePip, ccs.colorCorrectionLayer )
	if (movingSlotState == null)
	{
		Warning("Ran out of Moving PIP slots - gladiator card will not show");
		return
	}
	expect PIPSlotState( movingSlotState )

	pipSlotsToFreeOnExit.append( movingSlotState )

	ccs.isReady = true

	WaitEndFrame()
	if ( ccs.startTime - Time() > 0 )
		wait (ccs.startTime - Time())

	if ( gladCardDebug )
	{
		printf( "#GLADCARDS CC %s, %d: Commence", ccs.key, PIPSlotState_GetSlotID( movingSlotState ) )
	}

	void functionref() setupStillLighting = (void function() : ( ccs, lightingRigStillSeq, lightAttachmentNameMap ) {
		

		if ( lightingRigStillSeq != $"" )
		{
			ccs.lightingRig.Anim_Play( lightingRigStillSeq )

			
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				int attachmentIndex = ccs.lightingRig.LookupAttachment( lightAttachmentNameMap[lightIndex] )
				vector lightOrigin  = ccs.lightingRig.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles  = ccs.lightingRig.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin )
				light.SetTweakLightAngles( lightAngles )

				
			}
		}
		else
		{
			
			WaitFrame()
			int attachmentIndex = ccs.model.LookupAttachment( "CHESTFOCUS" )
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				vector lightOrigin = ccs.model.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles = ccs.model.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin + RotateVector( <110, 0, 0>, <0, Graph( lightIndex, 0, 4, 0, 360 ), 0> ) )
				light.SetTweakLightAngles( <0, Graph( lightIndex, 0, 4, -180, 180 ), 0> )
			}
		}

		
	})

	float movingSeqDuration
	if ( doMoving )
	{
		if ( movingSeq == "" )
			movingSeq = stillSeq
		if ( movingSeq != "" )
		{
			movingSeqDuration = ccs.model.GetSequenceDuration( movingSeq )
			ccs.model.Anim_Play( movingSeq )
		}
		else
		{
			movingSeqDuration = 10.0
		}

		if ( lightingRigMovingSeq != "" )
		{
			ccs.lightingRig.Anim_Play( lightingRigMovingSeq )

			
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				int attachmentIndex = ccs.lightingRig.LookupAttachment( lightAttachmentNameMap[lightIndex] )
				vector lightOrigin  = ccs.lightingRig.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles  = ccs.lightingRig.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin )
				light.SetTweakLightAngles( lightAngles )

				
			}
		}
		else
		{
			setupStillLighting()
		}
	}
	if ( doMoving )
	{
		Assert( ccs.stancePIPSlotStateOrNull == null )
		ccs.stancePIPSlotStateOrNull = movingSlotState  

		foreach ( OnStancePIPSlotReadyFuncType cb, bool unused in ccs.onPIPSlotReadyFuncSet )
			cb( PIPSlotState_GetSlotID( movingSlotState ), Time() + movingSeqDuration )

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %d: Moving", ccs.key, PIPSlotState_GetSlotID( movingSlotState ) )
		}

		wait movingSeqDuration

		
		
		
		
		
		
		
		
	}

	if ( stillSeq != "" )
	{
		ccs.model.Anim_Play( stillSeq )
	}
	else
	{
		ccs.model.Anim_Play( "ACT_MP_MENU_MAIN_IDLE" )
		
		
		
		ccs.camera.SetParent( ccs.model, "CHESTFOCUS", false )
		ccs.camera.SetLocalOrigin( <110, 0, 0> )
		ccs.camera.SetLocalAngles( <0, 180, 0> )
		DebugDrawAxis( ccs.camera.GetOrigin(), ccs.camera.GetAngles(), 25, 5 )
	}

	setupStillLighting()

	if ( doMoving )
	{
		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %d: Moved", ccs.key, PIPSlotState_GetSlotID( movingSlotState ) )
		}
	}
	else
	{
		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %d: Stilling", ccs.key, PIPSlotState_GetSlotID( movingSlotState ) )
		}

		EHI cachePlayer = EHI_null
		SettingsAssetGUID cacheCharacterguid = ASSET_SETTINGS_UNIQUE_ID_INVALID
		if (EHIHasValidScriptStruct( ccs.playerEHI ))
		{
			cachePlayer = ccs.playerEHI
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ccs.playerEHI, Loadout_Character() )
			cacheCharacterguid = character.guid
		}

		expect PIPSlotState ( stillSlotState ) 
		waitthread CaptureMovingPIPtoStillPIP( movingSlotState, stillSlotState )
		Assert( ccs.stancePIPSlotStateOrNull == null )
		ccs.stancePIPSlotStateOrNull = stillSlotState
		ReleasePIPSlot( movingSlotState )
		pipSlotsToFreeOnExit.fastremovebyvalue( movingSlotState )
		

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %d: Still", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		}

		if ( ccs.playerEHI != EHI_null && !IsLobby() )
		{
			
			
			
			int stillSlotIndex = stillSlotState.slotIndex
			bool cachingInProgress = GladCardCache_CacheGladCard(ccs.playerEHI, ccs.character.guid, stillSlotIndex )
			if (cachingInProgress)
			{
				WaitSignal( stillSlotState, "GladiatorCardCached" )
				GladCardCache_ConfirmCacheGladCard( ccs.playerEHI, ccs.character.guid, stillSlotIndex )
			}
		}
		
		

		foreach ( OnStancePIPSlotReadyFuncType cb, bool unused in ccs.onPIPSlotReadyFuncSet )
			cb( PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ), -1.0 )

		WaitFrame()

		ccs.cleanupSceneFunc() 

		if ( gladCardDebug )
		{
			printf( "#GLADCARDS CC %s, %d: Stilled", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		}
	}

	WaitForever()

	
	
	
	
	
	
	
	
}




void function OnGladiatorCardSlotChanged( EHI playerEHI, ItemFlavor unused )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( FromEHI( playerEHI ) )
}




void function OnGladiatorCardStatTrackerValueChanged( EHI playerEHI, int value, int trackerIndex )
{
	UpdateStatTrackerIndexOfAllNestedGladiatorCardsForPlayer( playerEHI, trackerIndex, value )
}




void function TriggerUpdateOfNestedGladiatorCardsForPlayer( entity owner )
{
	EHI ownerEHI = ToEHI( owner )
	if ( !(ownerEHI in fileLevel.ownerNestedCardListMap) )
		return

	foreach ( NestedGladiatorCardHandle handle in fileLevel.ownerNestedCardListMap[ownerEHI] )
	{
		
		TriggerNestedGladiatorCardUpdate( handle )
	}
}




void function UpdateStatTrackerIndexOfAllNestedGladiatorCardsForPlayer( EHI ownerEHI, int trackerIndex, int newVal )
{
	if ( !(ownerEHI in fileLevel.ownerNestedCardListMap) )
		return

	foreach ( NestedGladiatorCardHandle handle in fileLevel.ownerNestedCardListMap[ownerEHI] )
	{
		if ( !handle.isBackFace || handle.cardRui == null )
			continue

		UpdateRuiWithStatTrackerData_JustValue( handle.cardRui, "statTracker" + trackerIndex, newVal )
	}
}




void function UpdateStatTrackersOfNestedGladiatorCard( NestedGladiatorCardHandle handle, ItemFlavor ornull characterOrNull )
{
	for ( int index = 0; index < GLADIATOR_CARDS_NUM_TRACKERS; index++ )
	{
		ItemFlavor ornull trackerFlavOrNull = null

		int ornull overrideDataIntegerOrNull = null
		if ( handle.overrideTrackerList[index] != null )
		{
			trackerFlavOrNull = expect ItemFlavor(handle.overrideTrackerList[index])
			overrideDataIntegerOrNull = handle.overrideTrackerDataIntegerList[index]
		}

		if ( trackerFlavOrNull == null && characterOrNull != null )
		{
			LoadoutEntry trackerSlot = Loadout_GladiatorCardStatTracker( expect ItemFlavor(characterOrNull), index )
			if ( LoadoutSlot_IsReady( handle.currentOwnerEHI, trackerSlot ) )
				trackerFlavOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, trackerSlot )
		}

		if ( trackerFlavOrNull != null )
			UpdateRuiWithStatTrackerData( handle.cardRui, "statTracker" + index, handle.currentOwnerEHI, characterOrNull, index, trackerFlavOrNull, overrideDataIntegerOrNull )
	}
}




void function UpdateRuiWithStatTrackerData( var rui, string prefix, EHI playerEHI, ItemFlavor ornull characterOrNull, int trackerIndex, ItemFlavor ornull trackerFlavorOrNull, int ornull overrideDataIntegerOrNull = null, bool isLootCeremony = false )
{
	
	if ( trackerFlavorOrNull == null || GladiatorCardTracker_IsTheEmpty( expect ItemFlavor(trackerFlavorOrNull) ) )
	{
		RuiSetString( rui, prefix + "Label", "" )
		RuiSetInt( rui, prefix + "Value", 0 )
		RuiSetString( rui, prefix + "ValueSuffix", "" )

		if ( isLootCeremony )
		{
			RuiSetBool( rui, prefix + "IsLootCeremony", isLootCeremony )
			RuiSetString( rui, prefix + "Character", "" )
		}

		return
	}

	ItemFlavor trackerFlav = expect ItemFlavor(trackerFlavorOrNull)
	if ( !isLootCeremony || ( isLootCeremony && GladiatorCardStatTracker_GetTrackerType( trackerFlav ) != eTrackerType.ART ) )
	{
		RuiSetString( rui, prefix + "Label", ItemFlavor_GetShortName( trackerFlav ) )
		RuiSetString( rui, prefix + "ValueSuffix", GladiatorCardStatTracker_GetValueSuffix( trackerFlav ) )
	}

	asset backgroundImage
	if ( characterOrNull != null && trackerIndex != -1 )
	{
		ItemFlavor trackerArt = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_GladiatorCardStatTrackerArt( expect ItemFlavor(characterOrNull), trackerIndex ) )
		backgroundImage = GladiatorCardStatTracker_GetBackgroundImage( trackerArt )
	}
	else if ( GladiatorCardStatTracker_GetTrackerType( trackerFlav ) != eTrackerType.STAT )
	{
		Assert( isLootCeremony )
		backgroundImage = GladiatorCardStatTracker_GetBackgroundImage( trackerFlav )
	}
	RuiSetAsset( rui, prefix + "BackgroundImage", backgroundImage )

	if ( isLootCeremony )
	{
		RuiSetBool( rui, prefix + "IsLootCeremony", isLootCeremony )

		ItemFlavor ornull ref = GladiatorCardStatTracker_GetCharacterFlavor( trackerFlav )
		if ( ref != null )
			RuiSetString( rui, prefix + "Character", ItemFlavor_GetShortName( expect ItemFlavor( GladiatorCardStatTracker_GetCharacterFlavor( trackerFlav ) ) ) )
	}

	if ( isLootCeremony && GladiatorCardStatTracker_GetTrackerType( trackerFlav ) == eTrackerType.ART )
		return

	LoadoutEntry valueEntry
	if ( characterOrNull != null && trackerIndex != -1 )
		valueEntry = Loadout_GladiatorCardStatTrackerValue( expect ItemFlavor(characterOrNull), trackerIndex )
	int value = 0
	if ( playerEHI == LocalClientEHI() && (isLootCeremony || IsLobby() || !IsLoadoutSlotActive( playerEHI, valueEntry )) )
	{
		if ( !GladiatorCardTracker_IsTheEmpty( trackerFlav ) )
		{
			string desiredStatRef = GladiatorCardStatTracker_GetStatRef( trackerFlav, expect ItemFlavor(characterOrNull) )
			StatEntry desiredStat = GetStatEntryByRef( desiredStatRef )
			value = GetStat_Int( GetLocalClientPlayer(), desiredStat, eStatGetWhen.START_OF_CURRENT_MATCH )
		}
	}
	else
	{
		if ( overrideDataIntegerOrNull != null )
		{
			value = expect int(overrideDataIntegerOrNull)
		}
		else
		{
			value = LoadoutSlot_GetInteger( playerEHI, valueEntry )
		}
	}
	RuiSetInt( rui, prefix + "Value", value )
}




void function UpdateRuiWithStatTrackerData_JustValue( var rui, string prefix, int value )
{
	RuiSetInt( rui, prefix + "Value", value )
}




void function OnPlayerLifestateChanged( entity player, int oldLifeState, int newLifeState )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( player )
}




void function OnPlayerClassChanged( entity player )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( player )
}




void function GladiatorCards_PlayerCompletedLevelChanged( entity player, int newLevel )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( player )
}












int function GetPlayerBadgeDataInteger( EHI playerEHI, ItemFlavor badge, int badgeIndex, ItemFlavor ornull character, bool showOneTierHigherThanIsUnlocked = false )
{

		bool enableUseSlotInteger = !GetCurrentPlaylistVarBool( "update_match_badge", false )
		if ( ( enableUseSlotInteger && !IsLobby() ) || playerEHI != LocalClientEHI() )
		{
			LoadoutEntry tierSlot = Loadout_GladiatorCardBadgeTier( expect ItemFlavor(character), badgeIndex )
			return LoadoutSlot_GetInteger( playerEHI, tierSlot )
		}


	int grxTier = -1

	int grxMode = ItemFlavor_GetGRXMode( badge )
	if ( grxMode == eItemFlavorGRXMode.REGULAR )
	{












			if ( GRX_IsItemOwnedByPlayer_AllowOutOfDateData( badge , FromEHI( LocalClientEHI() ) ) )
			{
				grxTier = GRX_GetItemTier( ItemFlavor_GetGRXIndex( badge ) )
			}
#if DEV
			else
			{
				printt( "GetPlayerBadgeDataInteger GRX badge not owned by player[Client|UI]", FromEHI( playerEHI ), ItemFlavor_GetAssetName( badge ) )
			}
#endif


		if ( !GladiatorCardBadge_IsGRXWithStat( badge ) )
		{
			return grxTier
		}
	}
	else if ( grxMode != eItemFlavorGRXMode.NONE )
	{
		
		return 0
	}

	
	int dataInteger = maxint( grxTier, GetPlayerBadgeDataInteger_Internal( playerEHI, badge, character, showOneTierHigherThanIsUnlocked ) )

	return dataInteger
}



int function GetPlayerBadgeDataInteger_Internal( EHI playerEHI, ItemFlavor badge, ItemFlavor ornull character, bool showOneTierHigherThanIsUnlocked )
{
	string dynamicTextStatRef = GladiatorCardBadge_GetDynamicTextStatRef( badge )
	string unlockStatRef      = GladiatorCardBadge_GetUnlockStatRef( badge, character )
	bool unlocksByDynamicStat = ( unlockStatRef == dynamicTextStatRef )
	int dynamicStatVal        = -1

	if ( dynamicTextStatRef != "" )
	{
		if ( !GladiatorCardBadge_IsValidStatRef( dynamicTextStatRef ) )
			return 0

		dynamicStatVal = GladiatorCardBadge_GetStatInt( FromEHI( playerEHI ), dynamicTextStatRef, IsLobby() ? eStatGetWhen.CURRENT : eStatGetWhen.START_OF_CURRENT_MATCH )
	}

	if ( !unlocksByDynamicStat && dynamicStatVal != -1 )
		return dynamicStatVal

	if ( !GladiatorCardBadge_IsValidStatRef( unlockStatRef ) )
		return 0

	int dataInteger = -1
	entity player   = FromEHI( playerEHI )
	int tierCount   = GladiatorCardBadge_GetTierCount( badge )
	for ( int tierIdx = 0; tierIdx < tierCount; tierIdx++ )
	{
		GladCardBadgeTierData tierData = GladiatorCardBadge_GetTierData( badge, tierIdx )
		if ( !GladiatorCardBadge_DoesStatRefSatisfyValue( player, unlockStatRef, tierData.unlocksAt, IsLobby() ? eStatGetWhen.CURRENT : eStatGetWhen.START_OF_CURRENT_MATCH ) )
			break

		dataInteger = tierIdx
	}

	if ( dataInteger == -1 )
		return dataInteger

	if ( dynamicStatVal != -1 )
		return dynamicStatVal

	if ( showOneTierHigherThanIsUnlocked && ( dataInteger < ( tierCount - 1 ) ) )
		dataInteger += 1

	return dataInteger
}








bool function Loadout_GetPlayerBadgeIsUnlocked( EHI playerEHI, ItemFlavor badge, ItemFlavor ornull character )
{
	if ( IsEverythingUnlocked() )
		return true

	string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, character )

	if ( unlockStatRef == "" ) 
		return true

	if ( !GladiatorCardBadge_IsValidStatRef( unlockStatRef ) )
		return false

	entity player = FromEHI( playerEHI )
	int tierCount   = GladiatorCardBadge_GetTierCount( badge )
	for ( int tierIdx = 0; tierIdx < tierCount; tierIdx++ )
	{
		GladCardBadgeTierData tierData = GladiatorCardBadge_GetTierData( badge, tierIdx )
		if ( !GladiatorCardBadge_DoesStatRefSatisfyValue( player, unlockStatRef, tierData.unlocksAt, IsLobby() ? eStatGetWhen.CURRENT : eStatGetWhen.START_OF_CURRENT_MATCH ) )
			break

		return true
	}

	return false
}




LoadoutEntry function Loadout_GladiatorCardFrame( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterFrameSlotMap[characterClass]
}




LoadoutEntry function Loadout_GladiatorCardStance( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterStanceSlotMap[characterClass]
}




LoadoutEntry function Loadout_GladiatorCardBadge( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterBadgesSlotListMap[characterClass][badgeIndex]
}




LoadoutEntry function Loadout_GladiatorCardBadgeTier( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass][badgeIndex]
}




LoadoutEntry function Loadout_GladiatorCardStatTracker( ItemFlavor characterClass, int trackerIndex )
{
	return fileLevel.loadoutCharacterTrackersSlotListMap[characterClass][trackerIndex]
}



LoadoutEntry function Loadout_GladiatorCardStatTrackerArt( ItemFlavor characterClass, int trackerIndex )
{
	return fileLevel.loadoutCharacterTrackersArtSlotListMap[characterClass][trackerIndex]
}



LoadoutEntry function Loadout_GladiatorCardStatTrackerValue( ItemFlavor characterClass, int trackerIndex )
{
	return fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass][trackerIndex]
}




int function GladiatorCardFrame_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}




ItemFlavor ornull function GladiatorCardFrame_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	if ( GladiatorCardFrame_IsSharedBetweenCharacters( flavor ) )
		return null

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}



bool function GladiatorCardFrame_HasStoryBlurb( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return ( GladiatorCardFrame_GetStoryBlurbBodyText( flavor ) != "" )
}



string function GladiatorCardFrame_GetStoryBlurbBodyText( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "customSkinMenuBlurb" )
}



bool function GladiatorCardFrame_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}



bool function GladiatorCardFrame_IsSharedBetweenCharacters( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isSharedBetweenCharacters" )
}



vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] function GladiatorCardFrame_GetKeyColors( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] out
	for ( int idx = 0; idx < GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS; idx++ )
		out[idx] = GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "keyCol_" + idx )
	return out
}




bool function GladiatorCardFrame_HasOwnRUI( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasOwnRui" )
}




bool function GladiatorCardFrame_IsArtFullFrame( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isArtFullFrame" )
}




asset function GladiatorCardFrame_GetFGImageAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "fgImageAsset" )
}




float function GladiatorCardFrame_GetFGImageBlend( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "fgImageBlend" )
}




float function GladiatorCardFrame_GetFGImagePremul( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "fgImagePremul" )
}




asset function GladiatorCardFrame_GetBGImageAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "bgImageAsset" )
}




asset function GladiatorCardFrame_GetFGRuiAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "fgRuiAsset" )
}




asset function GladiatorCardFrame_GetBGRuiAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "bgRuiAsset" )
}




string function GladiatorCardFrame_GetColorCorrectionRawPath( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "colorCorrectionRawPath" )
}




float function GladiatorCardFrame_GetExposure( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "exposure" )
}




void function GladiatorCardFrame_SetupTweakLightFromSettings( ItemFlavor flavor, int index, entity tweakLight )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	var block = ItemFlavor_GetSettingsBlock( flavor )
	
	

	tweakLight.SetTweakLightColor( GetSettingsBlockVector( block, "light" + index + "_col" ) )
	tweakLight.SetTweakLightSpecIntensity( GetSettingsBlockFloat( block, "light" + index + "_specintensity" ) )
}




int function GladiatorCardStance_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}




ItemFlavor function GladiatorCardStance_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}




void function GladiatorCardStance_SetupTweakLightFromSettings( ItemFlavor flavor, int index, entity tweakLight )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	var block = ItemFlavor_GetSettingsBlock( flavor )
	
	
	
	
	
	

	tweakLight.SetTweakLightBrightness( GetSettingsBlockFloat( block, "light" + index + "_brightness" ) )
	tweakLight.SetTweakLightDistance( GetSettingsBlockFloat( block, "light" + index + "_distance" ) )
	tweakLight.SetTweakLightCone( GetSettingsBlockFloat( block, "light" + index + "_cone" ) )
	tweakLight.SetTweakLightInnerCone( GetSettingsBlockFloat( block, "light" + index + "_innercone" ) )
	tweakLight.SetTweakLightHalfBrightFrac( GetSettingsBlockFloat( block, "light" + index + "_halfbrightfrac" ) )
	tweakLight.SetTweakLightPBRFalloff( GetSettingsBlockBool( block, "light" + index + "_pbrfalloff" ) )
}




bool function GladiatorCardStance_DoesTweakLightRequireShadows( ItemFlavor flavor, int index )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "light" + index + "_castshadows" )
}




float function GladiatorCardStance_GetHorizontalCameraFOV( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "horizontalFOV" )
}




asset function GladiatorCardStance_GetStillAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "stillAnimSeq" )
}




asset function GladiatorCardStance_GetLightingRigStillAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "lightingRigStillAnimSeq" )
}




bool function GladiatorCardStance_HasMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasMovingAnim" )
}




asset function GladiatorCardStance_GetMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "movingAnimSeq" )
}




asset function GladiatorCardStance_GetLightingRigMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "lightingRigMovingAnimSeq" )
}



































































































































bool function GladiatorCardBadge_IsGRXWithStat( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return ItemFlavor_GetGRXMode( flavor ) == GRX_ITEMFLAVORMODE_REGULAR && GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "unlockStatRef" ) != ""
}



bool function GladiatorCardBadge_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}



bool function GladiatorCardBadge_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}




bool function GladiatorCardBadge_IsCharacterBadge( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isCharacterBadge" )
}



int function GladiatorCardBadge_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}




ItemFlavor ornull function GladiatorCardBadge_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )
	if ( GladiatorCardBadge_IsCharacterBadge( flavor ) == false )
		return null

	if ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )
		return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )

	Assert( !GladiatorCardBadge_IsCharacterBadge( flavor ), "" + string(ItemFlavor_GetAsset( flavor )) + " is a CHARACTER badge but it doesn't have a parentItemFlavor" )
	return null
}




string function GladiatorCardBadge_GetUnlockStatRef( ItemFlavor flavor, ItemFlavor ornull character )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )


	string statRef = GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "unlockStatRef" )
	if ( character != null )
		statRef = replace( statRef, "%char%", ItemFlavor_GetGUIDString( expect ItemFlavor(character) ) )
	else
		Assert( replace( statRef, "%char%", "" ) == statRef )
	return statRef
}




string function GladiatorCardBadge_GetDynamicTextStatRef( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "dynamicTextStatRef" )
}




int function GladiatorCardBadge_GetTierCount( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	var flavorBlock = ItemFlavor_GetSettingsBlock( flavor )
	return GetSettingsArraySize( GetSettingsBlockArray( flavorBlock, "tiers" ) )
}




GladCardBadgeTierData function GladiatorCardBadge_GetTierData( ItemFlavor flavor, int tierIdx )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	var flavorBlock        = ItemFlavor_GetSettingsBlock( flavor )
	var tierDataBlockArray = GetSettingsBlockArray( flavorBlock, "tiers" )
	Assert( tierIdx >= 0 && tierIdx < GetSettingsArraySize( tierDataBlockArray ) )
	var tierDataBlock = GetSettingsArrayElem( tierDataBlockArray, tierIdx )

	GladCardBadgeTierData data
	data.unlocksAt = GetSettingsBlockFloat( tierDataBlock, "unlocksAt" )
	data.ruiAsset = GetSettingsBlockStringAsAsset( tierDataBlock, "ruiAsset" )
	data.imageAsset = GetSettingsBlockAsset( tierDataBlock, "imageAsset" )
	return data
}




array<GladCardBadgeTierData> function GladiatorCardBadge_GetTierDataList( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	array<GladCardBadgeTierData> tierDataList = []
	for ( int tierIdx = 0; tierIdx < GladiatorCardBadge_GetTierCount( flavor ); tierIdx++ )
		tierDataList.append( GladiatorCardBadge_GetTierData( flavor, tierIdx ) )

	return tierDataList
}



int function GladiatorCardBadge_GetStatInt( entity player, string statRef, int when = eStatGetWhen.CURRENT )
{
	bool isGeneralStat = GladiatorCardBadge_IsGeneralStat( statRef )
	if ( !isGeneralStat )
	{
		return Mastery_GetStatValue( player, statRef )
	}
	else
	{
		StatEntry statEntry = GetStatEntryByRef( statRef )
		return GetStat_Int( player, statEntry, when )
	}
	unreachable
}



bool function GladiatorCardBadge_DoesStatRefSatisfyValue( entity player, string statRef, float checkValue, int when = eStatGetWhen.CURRENT )
{
	bool isGeneralStat = GladiatorCardBadge_IsGeneralStat( statRef )
	if ( !isGeneralStat )
	{
		return Mastery_DoesStatSatisfyValue( player, statRef, checkValue )
	}
	else
	{
		StatEntry statEntry = GetStatEntryByRef( statRef )
		return DoesStatSatisfyValue( player, statEntry, checkValue, when )
	}
	unreachable
}



bool function GladiatorCardBadge_IsValidStatRef( string statRef )
{
	bool isGeneralStat = GladiatorCardBadge_IsGeneralStat( statRef )
	if ( !isGeneralStat )
	{
		return Mastery_IsValidStatRef( statRef )
	}
	else
	{
		return IsValidStatEntryRef( statRef )
	}
	unreachable
}



bool function GladiatorCardBadge_IsGeneralStat( string statRef )
{
	const string MASTERY_TAG = "mastery_"
	return !(statRef.len() > MASTERY_TAG.len() && statRef.slice( 0, MASTERY_TAG.len() ) == MASTERY_TAG)
}



bool function GladiatorCardBadge_HasOwnRUI( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasOwnRui" )
}



bool function GladiatorCardBadge_IsOversizedImage( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isOversizedImage" )
}



bool function GladiatorCardTracker_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}




bool function GladiatorCardStatTracker_IsSharedBetweenCharacters( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) == "" )
}



int function GladiatorCardStatTracker_GetTrackerType( ItemFlavor tracker )
{
	Assert( ItemFlavor_GetType( tracker ) == eItemType.gladiator_card_stat_tracker )
	string typeString = GetGlobalSettingsString( ItemFlavor_GetAsset( tracker ), "trackerType" )
	Assert( typeString in eTrackerType )
	return eTrackerType[ typeString ]
}



int function GladiatorCardStatTracker_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}



int function GladiatorCardStatTrackerArt_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return fileLevel.cosmeticFlavorSortOrdinalMapArt[flavor]
}



ItemFlavor ornull function GladiatorCardStatTracker_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	if ( GladiatorCardStatTracker_IsSharedBetweenCharacters(flavor) )
		return null

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}




string function GladiatorCardStatTracker_GetStatRef( ItemFlavor flavor, ItemFlavor character )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )
	Assert( GladiatorCardStatTracker_GetTrackerType( flavor ) != eTrackerType.ART )

	string statRef = GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "statRef" )
	statRef = replace( statRef, "%char%", ItemFlavor_GetGUIDString( character ) )
	return statRef
}





string function GladiatorCardStatTracker_GetValueSuffix( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "valueSuffix" )
}




asset function GladiatorCardStatTracker_GetBackgroundImage( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )
	Assert( GladiatorCardStatTracker_GetTrackerType( flavor ) != eTrackerType.STAT )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "backgroundImage" )
}




vector function GladiatorCardStatTracker_GetColor0( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "color0" )
}




string function GladiatorCardStatTracker_GetFormattedValueText( entity player, ItemFlavor character, ItemFlavor flavor )
{
	if ( GladiatorCardTracker_IsTheEmpty( flavor ) )
		return ""

	Assert( GladiatorCardStatTracker_GetTrackerType( flavor ) != eTrackerType.ART )
	if ( GladiatorCardStatTracker_GetTrackerType( flavor ) == eTrackerType.ART )
		return ""

	string statRef = GladiatorCardStatTracker_GetStatRef( flavor, character )

	StatEntry statEntry = GetStatEntryByRef( statRef )

	int statVal = GetStat_Int( player, statEntry )

	string valueText

	valueText = format( "%i", statVal )

	return valueText
}




void function ShGladiatorCards_OnDevnetBugScreenshot()
{
#if DEV
		DEV_DumpCharacterCaptures()
#endif
}
















































































bool function GladiatorCardBadge_DoesStatSatisfyValue( ItemFlavor badge, float val )
{
	Assert( ItemFlavor_GetType( badge ) == eItemType.gladiator_card_badge )

	string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, GladiatorCardBadge_GetCharacterFlavor( badge ) )
	Assert( GladiatorCardBadge_IsValidStatRef( unlockStatRef ) )

	return GladiatorCardBadge_DoesStatRefSatisfyValue( GetLocalClientPlayer(), unlockStatRef, val, eStatGetWhen.CURRENT )
}




array< BadgeDisplayData > function GladiatorCardBadge_GetPostGameStatUnlockBadgesDisplayData()
{
	entity player = GetLocalClientPlayer()
	array< BadgeDisplayData > badgesUnlocked = []
	for ( int i = 0; i < POST_GAME_BADGE_COUNT; i++ )
	{




			int badgeGUID = player.GetPersistentVarAsInt( format( POST_GAME_BADGES_PVAR_FORMAT_STRING, i ) )

		if ( IsValidItemFlavorGUID( badgeGUID ) )
		{
			ItemFlavor badge = GetItemFlavorByGUID( badgeGUID )

			BadgeDisplayData unlockedBadgeData
			unlockedBadgeData.badge = badge

			string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, GladiatorCardBadge_GetCharacterFlavor( badge ) )
			int currentVal = GetStat_Int( player, GetStatEntryByRef( unlockStatRef ), eStatGetWhen.CURRENT )
			foreach ( tierData in GladiatorCardBadge_GetTierDataList( badge ) )
			{
				if ( currentVal < tierData.unlocksAt )
					break

				unlockedBadgeData.tierData = tierData
			}
			badgesUnlocked.append( unlockedBadgeData )
		}
	}

	return badgesUnlocked
}































































void function PrePopulateGladiatorCardCache_ReducePriority()
{
	if (fileLevel.prepopulateManager == null)
	{
		
		return
	}
	ClPip_SetMaxConcurrentCaptures() 
}




void function PrePopulateGladiatorCardCache_Abort()
{
	if (fileLevel.prepopulateManager == null)
	{
		
		return
	}

	if ( GetConVarBool( "gladCards_debug" ) )
	{
		printf("#GLADCARDS Precaching was cancelled by PrePopulateGladiatorCardCache_Abort")
	}
	Signal( (expect PrepopulateManager(fileLevel.prepopulateManager ) ), "PrecacheAbort"  )
}





void function PrePopulateGladiatorCardCache()
{
	if (fileLevel.prepopulateManager != null)
	{
		Warning("Called PrePopulateGladiatorCardCache when it was already in flight")
		return
	}

	thread PrePopulateGladiatorCardCacheAsync()
}



void function PrePopulateGladiatorCardCacheAsync()
{
	if (!GladCardCache_IsEnabled())
		return

	int maxConcurrency = GetConVarInt("gladcard_precache_concurrency")
	if (maxConcurrency < 1)
	{
		if ( GetConVarBool( "gladCards_debug" ) )
		{
			printf("#GLADCARDS skipping PrePopulateGladiatorCardCacheAsync because gladcard_precache_concurrency was %d", maxConcurrency)
		}
		return
	}

	if (maxConcurrency > PIP_NUM_MONITORS)
	{
		if ( GetConVarBool( "gladCards_debug" ) )
		{
			printf("#GLADCARDS reducing max concurrency from %d to %d, because we shouldn't exceed PIP_NUM_MONITORS", maxConcurrency, PIP_NUM_MONITORS);
		}
		maxConcurrency = PIP_NUM_MONITORS
	}

	if ( GetConVarBool( "gladCards_debug" ) )
	{
		float startTime = Time()
		OnThreadEnd( void function() : ( startTime ) {
			float endTime = Time()
			printf("#GLADCARDS precache took %f", endTime - startTime)
		} )
	}

	PrepopulateManager mgr	
	fileLevel.prepopulateManager = mgr

	ClPip_SetMaxConcurrentCaptures(maxConcurrency)
	OnThreadEnd( void function() : ( ) {
		ClPip_SetMaxConcurrentCaptures( ) 
		fileLevel.prepopulateManager = null
	} )

	EndSignal(mgr, "PrecacheAbort")

	array<entity> players = GetPlayerArray()
	foreach (entity player in players)
	{
		
		
		
		
		
		while (mgr.activeSingleCardThreadCount >= ClPip_GetMaxConcurrentCaptures())
			WaitSignal( mgr, "TaskDone" )

		thread PrePopulateGladiatorCardCache_SingleCard(ToEHI(player), mgr)
	}

	
	while (mgr.activeSingleCardThreadCount > 0)
		WaitSignal( mgr, "TaskDone" )
}




void function PrePopulateGladiatorCardCache_SingleCard(EHI playerEHI, PrepopulateManager mgr)
{
	if (playerEHI == EHI_null)
	{
		Warning( "PrePopulateGladiatorCardCache_SingleCard was called with playerEHI == EHI_null" )
		return
	}

	++mgr.activeSingleCardThreadCount

	OnThreadEnd( void function() : ( mgr, playerEHI ) {
		--mgr.activeSingleCardThreadCount
		Signal(mgr, "TaskDone")
	} )

	EndSignal(mgr, "PrecacheAbort")

	NestedGladiatorCardHandle dummyCardHandle 
	float startTime = 0 
	bool isMoving = false

	LoadoutEntry characterSlot = Loadout_Character()
	if( !LoadoutSlot_IsReady( playerEHI, characterSlot ))
	{
		Warning("PrePopulateGladiatorCardCache_SingleCard - Character slot was not ready for %d", playerEHI)
		return;
	}
	ItemFlavor characterFlavor = LoadoutSlot_GetItemFlavor( playerEHI, characterSlot )

	LoadoutEntry skinSlot = Loadout_CharacterSkin( characterFlavor )
	if( !LoadoutSlot_IsReady( playerEHI, skinSlot ))
	{
		Warning("PrePopulateGladiatorCardCache_SingleCard - Skin slot was not ready for %d", playerEHI)
		return;
	}
	ItemFlavor skinFlavor = LoadoutSlot_GetItemFlavor( playerEHI, skinSlot )

	LoadoutEntry frameSlot = Loadout_GladiatorCardFrame( characterFlavor )
	if( !LoadoutSlot_IsReady( playerEHI, frameSlot ))
	{
		Warning("PrePopulateGladiatorCardCache_SingleCard - Frame slot was not ready for %d", playerEHI)
		return;
	}
	ItemFlavor frameFlavor = LoadoutSlot_GetItemFlavor( playerEHI, frameSlot )

	LoadoutEntry stanceSlot = Loadout_GladiatorCardStance( characterFlavor )
	if( !LoadoutSlot_IsReady( playerEHI, stanceSlot ))
	{
		Warning("PrePopulateGladiatorCardCache_SingleCard - Stance slot was not ready for %d", playerEHI)
		return;
	}
	ItemFlavor stanceFlavor = LoadoutSlot_GetItemFlavor( playerEHI, stanceSlot )

	LoadoutEntry meleeSkinSlot = Loadout_MeleeSkin( characterFlavor )
	if( !LoadoutSlot_IsReady( playerEHI, meleeSkinSlot ))
	{
		Warning("PrePopulateGladiatorCardCache_SingleCard - Melee Skin slot was not ready for %d", playerEHI)
		return;
	}
	ItemFlavor meleeSkinFlavor = LoadoutSlot_GetItemFlavor( playerEHI, meleeSkinSlot )

	CharacterCaptureState ccs = GetOrStartCharacterCapture(
		dummyCardHandle,
		startTime,
		playerEHI,
		isMoving,
		characterFlavor,
		skinFlavor,
		frameFlavor,
		stanceFlavor,
		meleeSkinFlavor
	)

	OnThreadEnd( void function() : ( ccs ) {
		ReleaseCharacterCapture(ccs);
	} )

	if (ccs.stancePIPSlotStateOrNull != null)
	{
		
		printf("bypassing capture, seems to already be done I guess?")
		return
	}

	OnStancePIPSlotReadyFuncType onReadyFunc = void function(int stancePIPSlotIndex, float movingSeqEndTime) : ( ccs ) {
		Signal(ccs, "PrecacheDone")
	}
	ccs.onPIPSlotReadyFuncSet[onReadyFunc] <- true

	WaitSignal(ccs, "PrecacheDone")
}



