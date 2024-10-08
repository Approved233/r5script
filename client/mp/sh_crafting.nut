

global function Crafting_Init
global function Crafting_RegisterNetworking
global function Crafting_IsEnabled
global function Crafting_IsDispenserCraftingEnabled
global function Crafting_DispenserFreeSupportBanner
global function Crafting_DispenserSupportMRB
global function Dispensers_GetReplicatorStateForPlayer
global function Crafting_Access_Inventory_Enabled
global function Crafting_GetPlayerCraftingMaterials
global function Crafting_GetLootDataFromIndex
global function Crafting_GetCraftingDataArray
global function Crafting_IsItemCurrentlyOwnedByAnyPlayer
global function Crafting_DoesPlayerOwnItem

global function Crafting_IsPingMapIconEnabled












































































#if DEV



global function DEV_Crafting_PrintsOn
#endif


global function UICallback_PopulateCraftingPanel
global function Crafting_Workbench_OpenCraftingMenu
global function Crafting_PopulateItemRuiAtIndex
global function ServerCallback_CL_MaterialsChanged
global function ServerCallback_CL_HarvesterUsed
global function ServerCallback_CL_ArmorDeposited
global function ServerCallback_PromptNextHarvester
global function ServerCallback_PromptWorkbench
global function ServerCallback_PromptAllWorkbenches
global function ServerCallback_UpdateWorkbenchVars

global function ServerCallback_Crafting_Notify_Player_On_Obit

global function ServertoClientCallback_SetDispenserData
global function Crafting_IsPlayerCrafting

global function Crafting_OnMenuItemSelected
global function Crafting_OnWorkbenchMenuClosed
global function TryCloseCraftingMenuFromDamage
global function TryCloseCraftingMenu
global function ServerCallback_SetCraftingIndexForSpectator

global function MarkNextStepForPlayer
global function MarkAllWorkbenches
global function DestroyWorkbenchMarkers
global function HarvesterAnimThread

global function Crafting_ShowCraftingMapFeature

global function Crafting_GetWorkbenchTitleString
global function Crafting_GetWorkbenchDescString

global function Crafting_IsPlayerAtWorkbench

global function Crafting_GetCraftingIcon
global function Crafting_GetSmallCraftingIcon
global function Crafting_GetCraftingZoneIcon





#if DEV
global function DEV_Crafting_TogglePreMatchRotation
global function DEV_Crafting_PrintUsedHarvesterEHIs
#endif














const asset CRAFTING_DATATABLE = $"datatable/crafting_workbench.rpak"
const asset CRAFTING_CATEGORIES_DATATABLE = $"datatable/crafting_bundles.rpak"
const string CRAFTING_NULL_CHECK = "null"

const asset CRAFTING_DISPENSERS_DATATABLE = $"datatable/crafting_dispenser_workbench.rpak"
const asset CRAFTING_DISPENSERS_CATEGORIES_DATATABLE = $"datatable/crafting_dispenser_bundles.rpak"


global const string HARVESTER_SCRIPTNAME = "crafting_harvester"
global const string WORKBENCH_CLUSTER_SCRIPTNAME = "crafting_workbench_cluster"
global const string WORKBENCH_SCRIPTNAME = "crafting_workbench"
global const string WORKBENCH_CLUSTER_AIRDROPPED_SCRIPTNAME = "crafting_workbench_cluster_airdropped"
const string WORKBENCH_RANDOMIZATION_TARGET_SCRIPTNAME = "crafting_workbench_randomization"


const float HARVESTER_USE_DURATION = 0.5
const asset HARVESTER_MODEL = $"mdl/props/crafting_siphon/crafting_siphon.rmdl"
const string HARVESTER_FULL_IDLE_ANIM = "source_full_idle"
const string HARVESTER_EMPTY_IDLE_ANIM = "source_empty_idle"
const string HARVESTER_FULL_TO_EMPTY_ANIM = "source_full_to_empty"
const string HARVESTER_MINIMAP_SCRIPTNAME = "crafting_harvester_minimap"

const asset HARVESTER_IDLE_FX = $"P_siphon_idle"


const asset WORKBENCH_CLUSTER_AIRDROP_MODEL = $"mdl/props/crafting_replicator/crafting_replicator.rmdl"
const asset WORKBENCH_CLUSTER_MODEL = $"mdl/props/crafting_replicator/crafting_replicator_no_engine.rmdl"
const asset WORKBENCH_MODEL = $"mdl/dev/empty_model.rmdl"
const float WORKBENCH_USE_DURATION = 1.0
const float WORKBENCH_CRAFTING_DURATION = 10.0
const float WORKBENCH_LIMITED_STOCK_USE_DEFAULT = 3
const string WORKBENCH_IDLE_ANIM = "crafting_replicator_ready_idle"
const string WORKBENCH_IDLE_GROUND_ANIM = "crafting_replicator_ready_groundidle"

const float WORKBENCH_CRAFTING_DURATION_NEW = 0
const asset WORKBENCH_DISPENSER_HOLO_COLOR_FX = $"P_workbench_s20"
const asset WORKBENCH_DISPENSER_START_FX = $"P_workbench_s20_start"
const asset WORKBENCH_DISPENSER_BEAM_FX = $"P_workbench_s20_stock_beam_LT"
const vector WORKBENCH_DISPENSER_VFX_COLOR = < 183, 135, 255 >




const asset WORKBENCH_HOLO_FX = $"P_workbench_holo"



const asset WORKBENCH_START_FX = $"P_workbench_start"
const asset WORKBENCH_BEAM_FX = $"P_workbench_stock_beam_LT"
const asset WORKBENCH_ENGINE_SMOKE_FX = $"P_lootpod_vent_top"
const asset WORKBENCH_DOOR_OPEN_FX = $"P_lootpod_door_open"
const asset WORKBENCH_PRINTING_FX = $"P_replipod_printing_CP"


const float WORKBENCH_CLOSEDOOR_DURATION = 0.8


const array<string> CRAFTED_ITEM_CATEGORIES_FOR_ITEM_NAMES = [ "weapon_one", "weapon_two" ]


const int CRAFTING_PASSIVE_REWARD = 5
const int HARVESTER_SUCCESS_REWARD = 25
const int HARVESTER_TEAMMATE_REWARD = 25


const asset WORKBENCH_ICON_ASSET = $"rui/hud/gametype_icons/survival/crafting_workbench"
const asset WORKBENCH_ICON_LIMITED_ASSET = $"rui/hud/gametype_icons/survival/crafting_workbench_limited"
const asset WORKBENCH_ICON_AIRDROP_ASSET = $"rui/hud/gametype_icons/survival/crafting_workbench_airdrop"

const asset DISPENSER_WORKBENCH_ICON_ASSET = $"rui/hud/gametype_icons/survival/crafting_workbench_2"
const asset DISPENSER_WORKBENCH_ICON_AIRDROP_ASSET = $"rui/hud/gametype_icons/survival/crafting_workbench_airdrop_2"
const asset DISPENSER_CRAFTING_SMALL_WORKBENCH_ASSET = $"rui/hud/ping/icon_ping_crafting_2_hexagon"
global const asset CRAFTING_2_ZONE_ASSET = $"rui/hud/gametype_icons/survival/crafting_2_zone"

const asset HARVESTER_ICON_ASSET = $"rui/hud/gametype_icons/survival/crafting_harvester"
const asset CRAFTING_SMALL_HARVESTER_ASSET = $"rui/hud/gametype_icons/survival/crafting_small_harvester"
const asset CRAFTING_SMALL_WORKBENCH_ASSET = $"rui/hud/ping/icon_ping_crafting_hexagon"
global const asset CRAFTING_ZONE_ASSET = $"rui/hud/gametype_icons/survival/crafting_zone"
const asset CRAFTING_CURRENCY_ASSET = $"rui/hud/gametype_icons/survival/crafting_currency"


const string HARVESTER_AMBIENT_LOOP = "Crafting_Extractor_AmbientLoop"
const string WORKBENCH_AMBIENT_LOOP = "Crafting_V2_0_Replicator_AmbientLoop"
const string HARVESTER_COLLECT_1P = "Crafting_Extractor_Collect_1P"
const string HARVESTER_COLLECT_3P = "Crafting_Extractor_Collect_3P"
const string HARVESTER_COLLECT_TEAM = "UI_InGame_Crafting_Extractor_Collect_Squad"
const string WORKBENCH_MENU_OPEN_START = "Crafting_ReplicateMenu_OpenStart"
const string WORKBENCH_MENU_OPEN_FAIL = "Crafting_ReplicateMenu_OpenFail"
const string WORKBENCH_MENU_OPEN_SUCCESS = "Crafting_ReplicateMenu_OpenSuccess"
const string WORKBENCH_CRAFTING_START_1P = "Crafting_V2_0_Replicator_Crafting_Start_1P"
const string WORKBENCH_CRAFTING_START_3P = "Crafting_V2_0_Replicator_Crafting_Start_3P"
const string WORKBENCH_CRAFTING_FINISH = "Crafting_Replicator_CraftingFinish"
const string WORKBENCH_CRAFTING_FINISH_WARNING = "Crafting_Replicater_WarningToEnd"
const string WORKBENCH_CRAFTING_LOOP = "Crafting_Replicator_CraftingLoop"
const string WORKBENCH_CRAFTING_DOOR_OPEN = "Crafting_V2_0_Replicator_Crafting_Finish_Eject"
const string WORKBENCH_CRAFTING_DOOR_CLOSE = "Crafting_V2_0_Replicator_Crafting_Close"


const int RUI_TRACK_INDEX_CAPTURE_END_TIME = 0 
const int RUI_TRACK_INDEX_REQUIRED_TIME = 1 
const int RUI_TRACK_INDEX_ACTIVATOR_TEAM = 4 
const int RUI_TRACK_INDEX_COLOR = 0 


const float CRAFTING_PICKUP_GRACE_PERIOD = 5.0
global const string HOLDER_ENT_NAME = "holder_ent"


global const int CRAFTING_EVO_GRANT = 200
const int MAX_ARMOR_EVO_TIER = 5


global const int CRAFTING_AMMO_MULTIPLIER = 3
global const int CRAFTING_AMMO_MULTIPLIER_SMALL = 2

global const int DISPENSERS_CRAFTING_AMMO_MULTIPLIER = 6
global const int DISPENSERS_CRAFTING_AMMO_MULTIPLIER_SMALL = 4



const float IDEAL_END_FLAT_LENGTH = 27
const vector IDEAL_END_TRACE_OFFSET_START = <0, 0, 72>
const vector IDEAL_END_TRACE_OFFSET_END = <0, 0, -32>


global const float CRAFTING_OBIT_DEBOUNCE_PERIOD = 1.0


const string FUNCNAME_PingCrafterFromMap = "Crafting_ClientToServer_PingCrafterFromMap"






const float REPLICATOR_AIRDROP_DISPLACEMENT = 3000.0

global enum eHarvesterState
{
	EMPTY,
	FULL,
	CLOSED,
	COUNT_
}

global enum eCraftingExclusivityStyle
{
	RARITY,
	FLOOR,
	NONE,
	COUNT_
}

global enum eCraftingRotationStyle
{
	DAILY,
	WEEKLY,
	HOURLY,
	PERMANENT,
	LOADOUT_BASED,
	SEASONAL,

		PERK,

	


	COUNT_
}

global enum eCraftingRandomization
{
	NO_DISTRIBUTION, 
	RANDOM_HARVESTER_DISTRIBUTION, 
	RANDOM_CLUSTER_DISTRIBUTION, 
	RANDOM_CLUSTER_LINKED_DISTRIBUTION, 
	RANDOM_COMBINATION_DISTRIBUTION, 
	COUNT_
}

enum eCrafting_Obit_NotifyType
{
	IS_CRAFTING_ITEM,
	SUBSEQUENT_ITEM,
	IS_REQUESTING_MATERIALS,
	COUNT_
}

global enum eCrafting_Dispenser_StateType
{
	DEFAULT,
	NO_ONE_HAS_USED,
	ALL_USED,
	PLAYER_HAS_USED,
	TEAMMATE_HAS_USED,
	COUNT_
}

global struct CraftingBundle
{
	array< string > 			itemsInBundle


		table<int, var> attachedRui

}

global struct CraftingCategory
{
	int index
	string category
	int rotationStyle
	int exclusivityStyle
	int numSlots

	table< string, CraftingBundle > bundlesInCategory
	array< string > bundleStrings

	table< string, int > itemToCostTable
}

struct WorkbenchData
{
	entity workbench
	string lootAttachmentIndex
	string doorAnimIndex
	bool isDoorOpen = false
	array<entity> spawnedLoot





	entity cluster
	bool isCrafting = false
	table<entity, bool> playersHaveUsed
}

struct CraftingItemInfo
{
	int index
	var rui
	int cost
	bool canBuy
	bool canAfford
}















struct {
	bool                           isEnabled = false
	bool						   isNetworkingRegistered = false

	table<string, CraftingCategory > craftingData
	array<CraftingCategory> craftingDataArray

	array<string> disabledGroundLoot
	array<string> disabledPoolLoot
	entity		  limitedStockParent
	int 		  timeAtMatchStart


	table<entity, entity>	   	   harvesterToClientProxy
	table<entity, var>             harvesterRuiTable
	table<entity, var>			   workbenchRuiTable
	array<var>					   gameStartRui
	bool						   gameStartRuiCreated
	array<var>					   fullmapRui
	bool						   fullmapInitialized = false
	array<var> 					   exclusivityNotification

	table<entity, var>			   harvesterMinimapRuiTable
	table<entity, var>			   harvesterFullmapRuiTable

	table<entity, var>			   dispenserMapRuiTable
	table<entity, var>			   dispenserMinimapRuiTable

	array<int>					   workbenchMarkerList
	array<var>				   	   workbenchMarkerRuiList

	array<int>				       nextStepMarkerList
	array<var>					   nextStepMarkerRuiList

	array< table<var, var> >	   nearbyLiveWorkbenchRui

	array< CraftingItemInfo >	   craftingItems_ClientList

	
	table< EHI, array< EHI > >		usedHarvesterEHIs

	
	table< EHI, entity >			harvesterTableLocal

	
	table<entity, WorkbenchData>	workbenchDataTable_Client
	bool							playerIsCrafting = false

#if DEV
	bool 							DEV_testingRotationRui
#endif





























	table<entity, entity>		   ambGenericTable
	array<entity>				   workbenchClusterArray

	bool harvestersTeamUse = true

	bool craftingBetterSpectatorEnabled = false

	bool crafting_obit_notify = true

#if DEV
		bool devPrintsOn = false
#endif
} file

void function Crafting_Init()
{
	FlagInit( "CraftingInitialized" )

	RegisterCraftingData()
	RegisterCraftingDistribution()

	
	file.harvestersTeamUse 	= GetCurrentPlaylistVarBool( "harvesters_teamuse", true )

	file.craftingBetterSpectatorEnabled	= GetCurrentPlaylistVarBool( "crafting_use_better_specating", true )

	file.crafting_obit_notify = GetCurrentPlaylistVarBool( "crafting_obit_notify", true )




















		if ( IsLobby() )
		{
			file.isEnabled = Crafting_PlaylistVar_IsEnabled()
			return
		}











		AddCreateCallback( "prop_material_harvester", OnHarvesterCreated )
		AddDestroyCallback( "prop_material_harvester", OnHarvesterDestroyed )
		AddCreateCallback( "prop_dynamic", OnWorkbenchClusterCreated )
		AddCreateCallback( "info_target", OnLimitedStockParentCreated )


	RegisterSignal( "CraftingPlayerAttaching" )
	RegisterSignal( "CraftingComplete" )
	RegisterSignal( "CraftingPlayerDetached" )
	RegisterSignal( "OnPinged_Crafting" )
	RegisterSignal( "CraftingPlayerPlayExitAnim" )
	RegisterSignal( "CraftingPlayerDetachImmediate" )
	if ( file.craftingBetterSpectatorEnabled )
	{
		RegisterSignal( "crafting_kill_spectator_thread" )
	}


		RegisterSignal ( "OnPlayerUsedDispenser" )
		RegisterSignal ( "OnNewHoloStartPlaying" )








	if ( !Crafting_PlaylistVar_IsEnabled() )
		return

	printf( "CRAFTING: Crafting Systems enabled" )
	file.isEnabled = true























		AddCallback_GameStateEnter( eGameState.WaitingForPlayers, OnWaitingForPlayers_Client )
		AddCallback_GameStateEnter( eGameState.Playing, OnGameStartedPlaying_Client )
		
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, SetupProgressWaypoint )
		AddCallback_GameStateEnter( eGameState.Playing, Crafting_OnGameStatePlaying )
		AddLocalPlayerTookDamageCallback( TryCloseCraftingMenuFromDamage )
		RegisterMinimapPackages()
		AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

		AddCallback_UseEntGainFocus( Crafting_OnGainFocus )
		AddCallback_UseEntLoseFocus( Crafting_OnLoseFocus )

		RegisterSignal( "CraftingWaypointCreated" )
		RegisterSignal( "HarvesterDisabled" )
		RegisterSignal( "HarvesterStopFX" )
		RegisterSignal( "WorkbenchUsed" )

		FlagInit( "CraftingNotificationLive", false )

		if( Replicators_PingFromMap_Enabled() )
			AddCallback_OnFindFullMapAimEntity( GetCrafterUnderAim, PingCrafterUnderAim )


	PrecacheScriptString( WORKBENCH_SCRIPTNAME )
	PrecacheScriptString( WORKBENCH_RANDOMIZATION_TARGET_SCRIPTNAME )
	PrecacheScriptString( WORKBENCH_CLUSTER_SCRIPTNAME )
	PrecacheScriptString( WORKBENCH_CLUSTER_AIRDROPPED_SCRIPTNAME )



	PrecacheScriptString( HOLDER_ENT_NAME )
	PrecacheScriptString( HARVESTER_SCRIPTNAME )
	PrecacheScriptString( HARVESTER_MINIMAP_SCRIPTNAME )
	PrecacheScriptString( CARE_PACKAGE_SCRIPTNAME )

	PrecacheModel( HARVESTER_MODEL )
	PrecacheModel( WORKBENCH_MODEL )
	PrecacheModel( WORKBENCH_CLUSTER_MODEL )
	PrecacheModel( WORKBENCH_CLUSTER_AIRDROP_MODEL )


	PrecacheParticleSystem( HARVESTER_IDLE_FX )

	PrecacheParticleSystem( WORKBENCH_HOLO_FX )



	PrecacheParticleSystem( WORKBENCH_START_FX )
	PrecacheParticleSystem( WORKBENCH_BEAM_FX )
	PrecacheParticleSystem( WORKBENCH_ENGINE_SMOKE_FX )
	PrecacheParticleSystem( WORKBENCH_DOOR_OPEN_FX )
	PrecacheParticleSystem( WORKBENCH_PRINTING_FX )
	PrecacheParticleSystem( WORKBENCH_DISPENSER_HOLO_COLOR_FX )
	PrecacheParticleSystem( WORKBENCH_DISPENSER_START_FX )
	PrecacheParticleSystem( WORKBENCH_DISPENSER_BEAM_FX )
}

void function Crafting_RegisterNetworking()
{
	if ( !Crafting_PlaylistVar_IsEnabled() )
		return

	file.isEnabled = true

	if ( !Crafting_IsDispenserCraftingEnabled() )
	{
		RegisterNetworkedVariable( "craftingMaterials", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, 0 )
		RegisterNetworkedVariable( "Crafting_NumHarvesters", SNDC_GLOBAL, SNVT_INT, 0 )
	}

	RegisterNetworkedVariable( "Crafting_StartTime", SNDC_GLOBAL, SNVT_TIME, -1 )


	Remote_RegisterClientFunction( "ServerCallback_CL_MaterialsChanged", "int", -1, INT_MAX, "int", -1, INT_MAX, "int", 0, eWildLifeCampType.Count, "entity", "bool" )





	Remote_RegisterClientFunction( "ServerCallback_CL_HarvesterUsed", "entity", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_CL_ArmorDeposited" )
	Remote_RegisterClientFunction( "ServerCallback_PromptNextHarvester", "entity", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_PromptWorkbench", "entity", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_PromptAllWorkbenches", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_UpdateWorkbenchVars" )
	Remote_RegisterClientFunction( "ServerCallback_SetCraftingIndexForSpectator", "int", 0, 32 )

	Remote_RegisterClientFunction( "Crafting_Workbench_OpenCraftingMenu", "entity" )
	Remote_RegisterClientFunction( "TryCloseCraftingMenu" )
	Remote_RegisterClientFunction( "MarkAllWorkbenches" )
	Remote_RegisterClientFunction( "MarkNextStepForPlayer", "entity" )

	Remote_RegisterClientFunction( "ServerCallback_Crafting_Notify_Player_On_Obit", "entity", "int", 0, eCrafting_Obit_NotifyType.COUNT_, "int", 0, 256, "int", 0, 128, "int", -1, MAX_ARMOR_EVO_TIER + 1 )
	Remote_RegisterServerFunction( "ClientCallback_Crafting_Notify_Teammates_On_Obit", 		  "int", 0, eCrafting_Obit_NotifyType.COUNT_, "int", 0, 256, "int", 0, 128, "int", -1, MAX_ARMOR_EVO_TIER + 1 )
	Remote_RegisterServerFunction( "ClientCallback_InitializeCraftingAtWorkbench", "int", 0, 32 )
	Remote_RegisterServerFunction( "ClientCallback_ClosedCraftingMenu" )

	Remote_RegisterServerFunction( FUNCNAME_PingCrafterFromMap, "typed_entity", "prop_dynamic" )








	Remote_RegisterClientFunction( "ServertoClientCallback_SetDispenserData", "entity", "entity", "entity", "entity", "bool", "bool" )


	AddOnSpectatorTargetChangedCallback( Crafting_OnSpectateTargetChanged )
	AddFirstPersonSpectateStartedCallback( Crafting_OnFirstPersonSpectateStarted )
	AddFirstPersonSpectateEndedCallback( Crafting_OnFirstPersonSpectateEnded )


	file.isNetworkingRegistered = true
}


bool function Crafting_IsEnabled()
{
	return file.isEnabled
}

bool function Crafting_PlaylistVar_IsEnabled()
{
	return( GetCurrentPlaylistVarBool( "crafting_enabled", true ))
}

bool function Crafting_IsDispenserCraftingEnabled()
{
	return( GetCurrentPlaylistVarBool( "crafting_dispensers_enabled", true ))
}

int function Crafting_DispenserAmmoMulitplier()
{
	return GetCurrentPlaylistVarInt( "dispensers_ammo_multi", 6 )
}

int function Crafting_DispenserAmmoMulitplierSmall()
{
	return GetCurrentPlaylistVarInt( "dispensers_ammo_multi_small", 4 )
}

bool function Crafting_DispenserFreeSupportBanner()
{
	return GetCurrentPlaylistVarBool ( "dispenser_support_craft", false )
}

bool function Crafting_DispenserSupportMRB()
{
	return GetCurrentPlaylistVarBool( "dispenser_support_mrb", false )
}

bool function Crafting_AutoEject_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "crafting_auto_eject_enabled", true )
}

bool function Crafting_Access_Inventory_Enabled()
{
	return GetCurrentPlaylistVarBool( "crafting_access_inventory_enabled", true )
}

bool function Crafting_QuickOpenCraftingMenu()
{
	return GetCurrentPlaylistVarBool( "crafting_quickopen_enabled", true )
}

bool function Crafting_DispenserReactivation_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "crafting_dispensers_reactivate_enabled", false )
}

bool function Crafting_LocationBeam_Enabled()
{
	return GetCurrentPlaylistVarBool( "crafting_dispensers_locationbeam", true )
}


bool function Replicators_PingFromMap_Enabled()
{
	return GetCurrentPlaylistVarBool( "replicators_pingfrommap_enabled", true )
}


array<CraftingCategory> function Crafting_GetCraftingDataArray()
{
	return file.craftingDataArray
}

bool function Crafting_IsPingMapIconEnabled()
{
	return GetCurrentPlaylistVarBool( "crafting_pingmapicon_enabled", true )
}

bool function Crafting_CraftersDisabledInDeathField()
{
	return( GetCurrentPlaylistVarBool( "crafting_crafters_disabled_indeathfield", false ))
}

float function Crafting_CrafterExlusionDistance()
{
	return GetCurrentPlaylistVarFloat( "crafting_crafter_exclusion_distance", 16250 )
}

float function Crafting_HarvesterExlusionDistance()
{
	return GetCurrentPlaylistVarFloat( "crafting_harvester_exclusion_distance", 12000 )
}













void function RegisterCraftingData()
{
	var dataTable
	dataTable = GetDataTable( CRAFTING_DATATABLE )

	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		dataTable = GetDataTable( CRAFTING_DISPENSERS_DATATABLE )
	}

	int numRows = GetDataTableRowCount( dataTable )

	for ( int i=0; i<numRows; i++ )
	{
		CraftingCategory item
		item.index = i

		item.category = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "category" ) )

		string rotationStyle = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "rotationStyle" ) )
		item.rotationStyle = GetRotationStyleEnumFromString( rotationStyle )

		string exclusivityStyle = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "exclusivityStyle" ) )
		item.exclusivityStyle = GetExclusivityStyleEnumFromString( exclusivityStyle )

		int numSlots = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "slots" ) )
		item.numSlots = numSlots

		string bundleString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "bundlesList" ) )
		array<string> bundles = GetTrimmedSplitString( bundleString, " " )
		foreach( bundle in bundles )
		{
			CraftingBundle newBundleStruct
			item.bundlesInCategory[bundle] <- newBundleStruct
			item.bundleStrings.append( bundle )
		}

		file.craftingData[ item.category ] <- item
		file.craftingDataArray.append( item )
	}

	printf( "CRAFTING: Data parsed and registered" )

	
	foreach ( item in file.craftingDataArray )
	{
		string bundlesPlaylistCheck = GetCurrentPlaylistVarString( "crafting_dt_override_" + item.category + "_bundles", "" )
		if ( bundlesPlaylistCheck != "" )
		{
			array<string> bundles = GetTrimmedSplitString( bundlesPlaylistCheck, " " )
			foreach( bundle in bundles )
			{
				CraftingBundle newBundleStruct
				item.bundlesInCategory.clear()
				item.bundlesInCategory[bundle] <- newBundleStruct
				item.bundleStrings.clear()
				item.bundleStrings.append( bundle )
			}
		}
	}
}


void function RegisterCraftingDistribution()
{
	var distributionTable
	distributionTable = GetDataTable( CRAFTING_CATEGORIES_DATATABLE )

	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		distributionTable = GetDataTable( CRAFTING_DISPENSERS_CATEGORIES_DATATABLE )
	}

	int numRows = GetDataTableRowCount( distributionTable )

	
	
	foreach ( category in file.craftingDataArray )
	{
		printf( "CRAFTING: Getting datatable for category " + category.category )
		foreach ( name, bundle in category.bundlesInCategory )
		{
			int startingRow = GetDataTableRowMatchingStringValue( distributionTable, GetDataTableColumnByName( distributionTable, "bundle" ), name )
			string bundlePlaylistCheck = GetCurrentPlaylistVarString( "crafting_dt_override_bundle_" + name, "" )

			if ( bundlePlaylistCheck != "" )
			{
				array<string> itemsInBundle = GetTrimmedSplitString( bundlePlaylistCheck, " " )
				Assert( itemsInBundle.len() == category.numSlots, "CRAFTING: Playlist override for bundle " + name + " in category " + category.category + " does not match expected number of slots: " + category.numSlots )

				foreach( item in itemsInBundle )
				{
					array<string> result = GetTrimmedSplitString( item, ":" )
					string itemRef = result[0]
					int cost = int(result[1])

					bundle.itemsInBundle.append( itemRef )
					category.itemToCostTable[itemRef] <- cost
				}
				continue
			}

			if ( startingRow == -1 )
				continue

			int currentRow = startingRow
			while ( ( currentRow < numRows && GetDataTableString( distributionTable, currentRow, GetDataTableColumnByName( distributionTable, "bundle" ) ) == "" ) || currentRow == startingRow )
			{
				string item = GetDataTableString( distributionTable, currentRow, GetDataTableColumnByName( distributionTable, "base" ) )
				int cost = GetDataTableInt( distributionTable, currentRow, GetDataTableColumnByName( distributionTable, "base_item_cost" ) )

				bundle.itemsInBundle.append( item )
				category.itemToCostTable[item] <-cost

				currentRow++
			}
		}
	}
}

array<string> function Crafting_GetCraftingItemsByCategoryName( string categoryToCheck )
{
	array<string> validItemsInBundle

	for ( int i = 0; i < file.craftingDataArray.len(); i++ )
	{
		CraftingCategory group = file.craftingDataArray[i]

		if( group.category != categoryToCheck )
			continue

		if ( group.exclusivityStyle == eCraftingExclusivityStyle.RARITY || group.exclusivityStyle == eCraftingExclusivityStyle.FLOOR )
		{
			validItemsInBundle.extend( GenerateCraftingItemsInCategory( null, group ) )
		}
	}

	return validItemsInBundle
}


void function HandleCraftingExclusivity()
{
	if ( !Crafting_PlaylistVar_IsEnabled() )
		return

	for ( int i = 0; i < file.craftingDataArray.len(); i++ )
	{
		CraftingCategory group = file.craftingDataArray[i]

		array<string> itemsToDisable

		if ( group.exclusivityStyle == eCraftingExclusivityStyle.RARITY || group.exclusivityStyle == eCraftingExclusivityStyle.FLOOR )
		{
			array< string > validItems = GenerateCraftingItemsInCategory( null, group )
			foreach ( item in validItems )
			{
				itemsToDisable.append( item )
			}
		}
		else if ( group.exclusivityStyle == eCraftingExclusivityStyle.NONE )
		{
			
		}

		foreach ( item in itemsToDisable )
		{
			Crafting_AddExclusiveLoot(item)
		}
	}
}

void function Crafting_AddExclusiveLoot( string item )
{
	if ( item.find( "mp_weapon" ) != -1 )
	{
		
		string weapon = GetBaseWeaponRef( item )
		file.disabledPoolLoot.append( weapon )
		foreach ( string set in GetLockedSetsDisabledByCrafting() )
		{
			file.disabledPoolLoot.append( weapon + set )
		}
	}
	else
		
		file.disabledGroundLoot.append( item )
}


int function GetRotationStyleEnumFromString( string input )
{
	int rotationStyle
	bool rotationStyleFound = false

	for ( int i = 0; i < eCraftingRotationStyle.COUNT_; i++ )
	{
		string enumStyle = GetEnumString( "eCraftingRotationStyle", i )
		if ( enumStyle.tolower() == input )
		{
			rotationStyle = i
			rotationStyleFound = true
			break
		}
	}

	Assert( rotationStyleFound, "Playlist Crafting Rotation Pattern '" + input + "' is not a specified enumerator." )

	return rotationStyle
}


int function GetExclusivityStyleEnumFromString( string input )
{
	int exclusivityStyle
	bool exclusivityStyleFound = false

	for ( int i = 0; i < eCraftingExclusivityStyle.COUNT_; i++ )
	{
		string enumStyle = GetEnumString( "eCraftingExclusivityStyle", i )
		if ( enumStyle.tolower() == input )
		{
			exclusivityStyle = i
			exclusivityStyleFound = true
			break
		}
	}

	Assert( exclusivityStyleFound, "Playlist Crafting Exclusivity Style '" + input + "' is not a specified enumerator." )

	return exclusivityStyle
}


void function Crafting_OnGameStatePlaying()
{
	thread Crafting_OnGameStatePlaying_Thread()
}


void function Crafting_OnGameStatePlaying_Thread()
{



































	file.timeAtMatchStart = GetUnixTimestamp()

	FlagSet( "CraftingInitialized" )
}





































































































































































































































































































































































































































































































































































int function Dispensers_GetReplicatorStateForPlayer( entity player, entity pingEnt )
{
	if ( !IsValid( pingEnt ) || !IsValid( player ) )
		return 0

	
	int notifyType
	int teammatesUsed = 0
	bool isNotifier = false
	WorkbenchData craftingBenchData

	array <entity> benchSiblings = pingEnt.GetLinkEntArray()
	foreach ( bench in benchSiblings)
	{
		if ( bench.GetScriptName() == WORKBENCH_SCRIPTNAME )
		{





			craftingBenchData = file.workbenchDataTable_Client[bench]

			break
		}
		else
		{
			return 0
		}
	}

	array<entity> teammates = GetPlayerArrayOfTeam( player.GetTeam() )
	foreach ( teamPlayer in teammates )
	{
		if ( teamPlayer in craftingBenchData.playersHaveUsed )
		{
			teammatesUsed++
			if ( teamPlayer == player )
				isNotifier = true
		}
	}

	if ( teammatesUsed == 0 )
	{
		notifyType = eCrafting_Dispenser_StateType.NO_ONE_HAS_USED
	}
	else if ( isNotifier && teammatesUsed == teammates.len() )
	{
		notifyType = eCrafting_Dispenser_StateType.ALL_USED
	}
	else if ( isNotifier && teammatesUsed > 0 )
	{
		notifyType = eCrafting_Dispenser_StateType.PLAYER_HAS_USED
	}
	else if ( !isNotifier && teammatesUsed > 0 )
	{
		notifyType = eCrafting_Dispenser_StateType.TEAMMATE_HAS_USED
	}

	return notifyType
}

array<string> function GetItemNamesFromCraftingBundle( CraftingBundle craftedBundle )
{
	array<string> arrayResults

	Assert( craftedBundle.itemsInBundle.len() > 0, "WARNING: GetItemNamesFromCraftingBundle called with no items in the bundle." )

	foreach( string bundleString in craftedBundle.itemsInBundle )
	{
#if DEV
		DEV_Crafting_Print( format( "  ** crafting item bundlestring = %s", bundleString  ))
#endif
		arrayResults.append( bundleString )
	}
	return arrayResults
}

int function GetLimitedStockFromWorkbench( entity workbench )
{
	if ( !IsLimitedStockWorkbench( workbench ) )
	{
		return 0
	}

	return workbench.GetShieldHealth()
}

bool function IsLimitedStockWorkbench( entity workbench )
{
	if ( !IsValid( file.limitedStockParent ) || !IsValid( workbench ) )
		return false

	
	return false
}


string function LimitedStock_TextOverride( entity workbench )
{
	entity cluster
	foreach ( ent in workbench.GetLinkParentArray() )
	{
		if ( ent.GetScriptName() == WORKBENCH_CLUSTER_SCRIPTNAME )
		{
			cluster = ent
			break
		}
	}

	bool isWorkbenchBusy = workbench.GetLinkEntArray().len() != 0
	bool isWorkbenchCrafting = workbench.GetOwner() != null
	if ( isWorkbenchBusy || isWorkbenchCrafting || workbench.e.isBusy )
		return "#CRAFTING_WORKBENCH_USE_PROMPT_UNAVAILABLE"

	if ( GetLimitedStockFromWorkbench( cluster ) <= 0 )
		return "#CRAFTING_WORKBENCH_USE_PROMPT_INVALID"

	return "#CRAFTING_WORKBENCH_USE_PROMPT"
}



void function OnLimitedStockParentCreated( entity target )
{
	if ( !file.isEnabled )
		return

	if ( target.GetScriptName() != WORKBENCH_RANDOMIZATION_TARGET_SCRIPTNAME )
		return

	file.limitedStockParent = target
}


string function Crafting_GetWorkbenchTitleString()
{
	entity workbench = GetLocalClientPlayerWorkbench()
	if ( IsLimitedStockWorkbench( workbench ) )
	{
		return Localize("#CRAFTING_WORKBENCH_LIMITED")
	}
	else if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return Localize("#DISPENSER_TITLE")
	}

	else
		return Localize("#CRAFTING_WORKBENCH")
	unreachable
}


string function Crafting_GetWorkbenchDescString()
{
	entity workbench = GetLocalClientPlayerWorkbench()
	if ( IsLimitedStockWorkbench( workbench ) )
	{
		return GetLimitedStockFromWorkbench( workbench ) <=1 ? Localize("#CRAFTING_LIMITED_USE_BENCH_SINGULAR", GetLimitedStockFromWorkbench( workbench )) : Localize("#CRAFTING_LIMITED_USE_BENCH", GetLimitedStockFromWorkbench( workbench ))
	}
	else if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return Localize("#DISPENSER_DESC")
	}

	else
		return Localize("#CRAFTING_WORKBENCH_DESC")
	unreachable
}


entity function GetLocalClientPlayerWorkbench()
{
	entity player = GetLocalViewPlayer()
	entity workbench
	array<entity> possibleWorkbenches = player.GetLinkParentArray()
	foreach( ent in possibleWorkbenches )
	{
		if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
		{
			foreach ( cluster in ent.GetLinkParentArray() )
			{
				if ( cluster.GetScriptName() == WORKBENCH_CLUSTER_SCRIPTNAME )
				{
					workbench = cluster
					break
				}
			}

			if ( workbench != null )
				break
		}
	}

	return workbench
}


void function RegisterMinimapPackages()
{
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CRAFTING_HARVESTER, MINIMAP_OBJECT_RUI, MinimapPackage_Crafting_Harvester, FULLMAP_OBJECT_RUI, FullmapPackage_Crafting_Harvester )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CRAFTING_WORKBENCH, MINIMAP_OBJECT_RUI, MiniMapPackage_Crafting_Workbench, FULLMAP_OBJECT_RUI, MapPackage_Crafting_Workbench )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CRAFTING_WORKBENCH_LIMITED, MINIMAP_OBJECT_RUI, MapPackage_Crafting_WorkbenchLimited, FULLMAP_OBJECT_RUI, MapPackage_Crafting_WorkbenchLimited )
}


void function FullmapPackage_Crafting_Harvester( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", HARVESTER_ICON_ASSET )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )

	RuiSetImage( rui, "smallIcon", CRAFTING_SMALL_HARVESTER_ASSET )
	RuiSetBool( rui, "hasSmallIcon", true )

	file.harvesterFullmapRuiTable[ent] <- rui
}

void function MinimapPackage_Crafting_Harvester( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", HARVESTER_ICON_ASSET )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )

	RuiSetImage( rui, "smallIcon", CRAFTING_SMALL_HARVESTER_ASSET )
	RuiSetBool( rui, "hasSmallIcon", true )

	file.harvesterMinimapRuiTable[ent] <- rui
}

void function MapPackage_Crafting_Workbench( entity ent, var rui )
{
	bool isAirdrop = ent.GetTargetName() == "craftingWorkbenchAirdropIcon"

	RuiSetImage( rui, "defaultIcon", Crafting_GetCraftingIcon( isAirdrop ) )

	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )

	if ( !isAirdrop )
	{
		RuiSetImage( rui, "smallIcon", Crafting_GetSmallCraftingIcon() )
		RuiSetBool( rui, "hasSmallIcon", true )

		if ( Crafting_IsDispenserCraftingEnabled() )
			RuiSetFloat2( rui, "iconScale", <1.15, 1.15, 0.0> )
	}

	file.dispenserMapRuiTable[ent] <- rui
}

void function MiniMapPackage_Crafting_Workbench( entity ent, var rui )
{
	bool isAirdrop = ent.GetTargetName() == "craftingWorkbenchAirdropIcon"

	RuiSetImage( rui, "defaultIcon", Crafting_GetCraftingIcon( isAirdrop ) )

	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )

	if ( !isAirdrop )
	{
		RuiSetImage( rui, "smallIcon", Crafting_GetSmallCraftingIcon() )
		RuiSetBool( rui, "hasSmallIcon", true )

		if ( Crafting_IsDispenserCraftingEnabled() )
			RuiSetFloat2( rui, "iconScale", <1.15, 1.15, 0.0> )
	}

		file.dispenserMinimapRuiTable[ent] <- rui
}

void function MapPackage_Crafting_WorkbenchLimited( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", WORKBENCH_ICON_LIMITED_ASSET )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function TryCloseCraftingMenuFromDamage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetConVarBool( "player_setting_damage_closes_deathbox_menu" ) )
		TryCloseCraftingMenu()
}














































































































void function OnHarvesterCreated( entity target )
{
	if ( !file.isEnabled )
	{
		return
	}

	if ( target.GetScriptName() != "crafting_harvester" )
		return

	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		target.Destroy()
		return
	}

#if DEV
	DEV_Crafting_Print( format( "OnHarvesterCreated():  %s", string( target ) ))
#endif

	EHI harvesterEHI = ToEHI( target )
	file.harvesterTableLocal[ harvesterEHI ] <- target

	
	vector origin = target.GetOrigin()
	vector angles = target.GetAngles()
	entity fakeHarvester = CreatePropDynamic( HARVESTER_MODEL, origin, angles)
	fakeHarvester.SetFadeDistance( 15000 )
	fakeHarvester.SetForceVisibleInPhaseShift( true )
	file.harvesterToClientProxy[target] <- fakeHarvester

	entity ambGen = CreateClientSideAmbientGeneric( target.GetOrigin(), HARVESTER_AMBIENT_LOOP, 3000 )
	ambGen.SetParent( target )
	ambGen.SetLocalOrigin( <0, 0, 60> )
	file.ambGenericTable[target] <- ambGen

	CreateHarvesterWorldIcon( target )

	if( !PlayerHasUsedHarvester( GetLocalViewPlayer(), target ) )
	{
		CL_SetHarvesterState( target, eHarvesterState.FULL )

		AddCallback_OnUseEntity_ClientServer( target, HarvestCraftingMaterials )
		SetCallback_CanUseEntityCallback( target, Crafting_Harvester_IsNotBusy )
		AddEntityCallback_GetUseEntOverrideText( target, Crafting_Harvester_UseTextOverride )
	}
	else
	{
		CL_SetHarvesterState( target, eHarvesterState.EMPTY )
		entity minimapObj = null
		foreach ( entity child in target.GetChildren() )
		{
			if ( child.GetScriptName() == HARVESTER_MINIMAP_SCRIPTNAME )
			{
				minimapObj = child
				break
			}
		}

		bool success = SetMapIconsAsUsed( target, minimapObj )
		
		
		if ( !success )
		{
			thread SetMapIconStateRetry_Thread( target, minimapObj )
		}
	}
}

void function SetMapIconStateRetry_Thread( entity harvester, entity minimapObj )
{
	EndSignal( harvester, "OnDestroy", "HarvesterDisabled" )
	EndSignal( minimapObj, "OnDestroy" )
	for( int i = 0; i < 10; i++ )
	{
		WaitFrame()

		if ( SetMapIconsAsUsed( harvester, minimapObj ) )
			return
	}
}

void function CL_SetHarvesterState( entity harvester, int harvesterState )
{
	if( !IsValid( harvester ) )
		return

	entity fakeHarvester = file.harvesterToClientProxy[ harvester ]
	entity ambGen = file.ambGenericTable[ harvester ]

	if( !IsValid( fakeHarvester ) )
		return

	switch( harvesterState )
	{
		case eHarvesterState.EMPTY:
			fakeHarvester.Anim_Stop()
			fakeHarvester.Anim_Play( HARVESTER_EMPTY_IDLE_ANIM )
			fakeHarvester.kv.intensity = 0.1
			if( IsValid( ambGen ) )
			{
				ambGen.SetEnabled( false )
			}
			break
		case eHarvesterState.FULL:
			thread PlayHarvesterIdleFX( fakeHarvester )
			fakeHarvester.Anim_Stop()
			fakeHarvester.Anim_Play( HARVESTER_FULL_IDLE_ANIM )
			fakeHarvester.kv.intensity = 1.0
			if( IsValid( ambGen ) )
			{
				ambGen.SetEnabled( true )
			}
			break
		default:
			break
	}
}

void function OnHarvesterDestroyed( entity target )
{
#if DEV
		DEV_Crafting_Print( format( "OnHarvesterDestroyed():  %s", string( target ) ))
#endif

	if ( !( target in file.harvesterRuiTable ) )
		return

	RuiDestroy( file.harvesterRuiTable[target] )
	delete file.harvesterRuiTable[target]

	if (( target in file.harvesterToClientProxy ) && IsValid( file.harvesterToClientProxy[target] ) )
	{
		file.harvesterToClientProxy[target].Destroy()
		delete file.harvesterToClientProxy[target]
	}

	if (( target in file.ambGenericTable ) && IsValid( file.ambGenericTable[target] ))
	{
		file.ambGenericTable[target].Destroy()
		delete file.ambGenericTable[target]
	}
}

void function PlayHarvesterIdleFX( entity harvester )
{
	if( !IsValid( harvester ) )
		return

	
	Signal( harvester, "HarvesterStopFX" )

	EndSignal( harvester, "OnDestroy", "HarvesterDisabled", "HarvesterStopFX" )

	int attachId = harvester.LookupAttachment( "FX_INSIDE" )
	int idleFx = StartParticleEffectOnEntity( harvester, GetParticleSystemIndex( HARVESTER_IDLE_FX ), FX_PATTACH_POINT_FOLLOW, attachId )

	OnThreadEnd(
		function() : ( idleFx )
		{
			if ( IsValid( idleFx ) )
			{
				EffectStop( idleFx, false, true )
			}
		}
	)

	WaitForever()
}

string function Crafting_Harvester_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()

	CustomUsePrompt_Show( ent )
	CustomUsePrompt_SetSourcePos( ent.GetOrigin() + < 0, 0, 30 > )

	
	CustomUsePrompt_SetText( Localize("#CRAFTING_HARVESTER_USE_PROMPT") )
	CustomUsePrompt_SetLineColor( GetCraftingColor() )
	CustomUsePrompt_SetHintImage( CRAFTING_CURRENCY_ASSET )
	CustomUsePrompt_SetShouldCenterImage( true )

	if ( PlayerIsInADS( player ) )
		CustomUsePrompt_ShowSourcePos( false )
	else
		CustomUsePrompt_ShowSourcePos( true )

	return ""
}


bool function PlayerHasUsedHarvester( entity player, entity harvester )
{
	if( !IsValid( harvester ) )
		return false

	if( !IsValid( player ) || !player.IsPlayer() )
		return false

	int indexToCheck = 0
	if ( file.harvestersTeamUse )
	{
		indexToCheck = player.GetTeam()
	}
	else
	{
		indexToCheck = EHIToEncodedEHandle( ToEHI( player ) )
		
		indexToCheck--
	}

	return harvester.GetUseStateByIndex( indexToCheck )
}




























void function HarvestCraftingMaterials( entity harvester, entity player, int pickupFlags )
{






















}






































void function Crafting_OnSpectateTargetChanged( entity spectatingPlayer, entity oldSpectatorTarget, entity newSpectatorTarget )
{
#if DEV
		DEV_Crafting_Print( format( " ********** Refreshing Local Harvesters"))
#endif

	entity player = GetLocalViewPlayer()

#if DEV
		DEV_Crafting_Print( format( "*** SPECTATOR: ServerCallback_RefreshLocalHarvesters: "))
		DEV_Crafting_Print( format( "*** SPECTATOR: Player == %s", string( player ) ))
		EHI playerEHI = ToEHI( player )
		if( playerEHI in file.usedHarvesterEHIs )
		{
			DEV_Crafting_Print( format( "*** SPECTATOR: Local file.usedHarvesterEHIs.len() == %s", string( file.usedHarvesterEHIs[ playerEHI ].len()) ))
		}
#endif

	foreach( harvesterEHI, harvester in file.harvesterTableLocal )
	{
		if( IsValid( harvester ) )
		{
			entity fakeHarvester = file.harvesterToClientProxy[ harvester ]

			if( IsValid( fakeHarvester ) )
			{
				if( PlayerHasUsedHarvester( player, harvester )  )
				{
					CL_SetHarvesterState( harvester, eHarvesterState.EMPTY )
				}
				else
				{
					CL_SetHarvesterState( harvester, eHarvesterState.FULL )
				}
			}
		}
	}

	if ( file.craftingBetterSpectatorEnabled && GetLocalClientPlayer() != GetLocalViewPlayer() )
	{
		Signal(GetLocalClientPlayer(), "crafting_kill_spectator_thread")
		Crafting_Workbench_CloseCraftingMenu()

		if ( Crafting_IsPlayerAtWorkbench( newSpectatorTarget ) )
		{
			entity linkedCrafter
			foreach ( ent in newSpectatorTarget.GetLinkParentArray() )
			{
				if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
				{
					linkedCrafter = ent
					break
				}
			}

			if ( IsValid( linkedCrafter )  )
				Crafting_Workbench_OpenCraftingMenuAsSpectator( linkedCrafter )
		}
	}
}

void function Crafting_OnFirstPersonSpectateStarted( entity spectatingPlayer, entity spectateTarget )
{
	if ( file.craftingBetterSpectatorEnabled )
	{
		if ( Crafting_IsPlayerAtWorkbench( spectateTarget ) )
		{
			entity linkedCrafter
			foreach ( ent in spectateTarget.GetLinkParentArray() )
			{
				if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
				{
					linkedCrafter = ent
					break
				}
			}

			if ( IsValid( linkedCrafter )  )
				Crafting_Workbench_OpenCraftingMenuAsSpectator( linkedCrafter )
		}
	}
}

void function Crafting_OnFirstPersonSpectateEnded( entity  spectatingPlayer, entity spectateTarget )
{
	if ( file.craftingBetterSpectatorEnabled )
	{
		Crafting_Workbench_CloseCraftingMenu()
	}
}

void function HarvesterAnimThread( entity harvesterProxy, bool doEmptyingAnim = true )
{
	if( !IsValid( harvesterProxy ) )
		return

	harvesterProxy.Anim_Stop()

	string animName = HARVESTER_FULL_TO_EMPTY_ANIM
	float waitTime = 2

	if( !doEmptyingAnim )
	{
		animName = HARVESTER_EMPTY_IDLE_ANIM
		waitTime = 0.1
	}

	if( !UpgradeCore_UseUpdatedHarvesterModel() )
	{
		harvesterProxy.Anim_Play( animName )

		wait waitTime

		if ( IsValid( harvesterProxy ) )
		{
			harvesterProxy.Anim_Stop()
		}
	}
	else
	{
		harvesterProxy.Anim_Play( EVO_HARVESTER_FULL_TO_EMPTY_ANIM )

		wait waitTime

		if ( IsValid( harvesterProxy ) )
		{
			harvesterProxy.Anim_Stop()
		}
	}
}
























































































































bool function Crafting_Harvester_IsNotBusy( entity player, entity ent, int useFlags )
{

	if( GetLocalClientPlayer() != GetLocalViewPlayer() )
		return false


	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( player.ContextAction_IsActive() )
		return false

	if ( !SURVIVAL_PlayerAllowedToPickup( player ) )
		return false

	
	if ( PlayerHasUsedHarvester( player, ent ) )
		return false

	return true
}


void function ServerCallback_CL_HarvesterUsed( entity harvester, entity minimapObj )
{
	if( !IsValid( harvester ) )
		return

#if DEV
		DEV_Crafting_Print( format( "ServerCallback_CL_HarvesterUsed():  %s", string( harvester ) ))
#endif

	file.ambGenericTable[harvester].SetEnabled( false )
	thread HarvesterAnimThread( file.harvesterToClientProxy[harvester] )
	thread FadeModelIntensityOverTime( file.harvesterToClientProxy[harvester], 1, 1, 0.1 )

	Signal( file.harvesterToClientProxy[harvester], "HarvesterDisabled" )
	Signal( harvester, "HarvesterDisabled" )

	SetMapIconsAsUsed( harvester, minimapObj )
}

bool function SetMapIconsAsUsed( entity harvester, entity minimapObj )
{
	if ( IsValid(harvester) && (harvester in file.harvesterRuiTable) && (file.harvesterRuiTable[harvester] != null) )
	{
		RuiDestroyIfAlive( file.harvesterRuiTable[harvester] )
		delete file.harvesterRuiTable[harvester]
	}

	bool setMap = false
	if ( IsValid(minimapObj) && (minimapObj in file.harvesterFullmapRuiTable) && (minimapObj in file.harvesterMinimapRuiTable) )
	{
		
		RuiSetFloat3( file.harvesterFullmapRuiTable[minimapObj], "iconColor", <0,0,0> )
		RuiSetFloat3( file.harvesterMinimapRuiTable[minimapObj], "iconColor", <0,0,0> )
		setMap = true
	}

	return setMap
}

void function ServerCallback_CL_MaterialsChanged( int amount, int difference, int campIndex, entity giver, bool selfOnly )
{
		if ( Crafting_IsDispenserCraftingEnabled() )
			return

	if ( file.fullmapRui.len() != 0 && file.fullmapRui[0] != null )
		RuiSetInt( file.fullmapRui[0], "craftingMaterials", amount )

	string headerText = WILDLIFE_REWARD_STRINGS[ campIndex ]
	string header
	string milesAlias
	if (headerText != "")
	{
		header = Localize(headerText).toupper() + "\n"
		if (headerText.find("CAMP_REWARD") >= 0)
			milesAlias = "UI_TropicsAI_AreaCompletionStinger"
	}

	if ( difference > 0 )
	{
		if( GetLocalViewPlayer() == giver )
		{
			if ( selfOnly )
			{
				AnnouncementMessageRight( GetLocalViewPlayer(), header + Localize( "#CRAFTING_HARVESTER_AWARD", difference ), "", <214, 214, 214>, $"", 2, milesAlias )
			}
			else
			{
				AnnouncementMessageRight( GetLocalViewPlayer(), header + Localize( "#CRAFTING_HARVESTER_AWARD_TEAMUSE", difference ), "", <214, 214, 214>, $"", 2, milesAlias )
			}
		}
		else
		{
			AnnouncementMessageRight( GetLocalViewPlayer(), header + Localize( "#CRAFTING_HARVESTER_AWARD_TEAMMATES", giver.GetPlayerName(), difference ), "", <214, 214, 214>, $"", 2, milesAlias )
		}
	}
	else
	{
		AnnouncementMessageRight( GetLocalViewPlayer(), header + Localize( "#CRAFTING_HARVESTER_BALANCE_UPDATE", amount ), "", <214, 214, 214>, $"", 2, milesAlias )
	}

	
	RefreshCraftingMenu()
}


void function RefreshCraftingMenu()
{
	if ( !Crafting_IsPlayerAtWorkbench( GetLocalViewPlayer() ) )
		return

	CommsMenu_RefreshData()

	Update_CraftingItems_Availabilities()
}

void function ServerCallback_CL_ArmorDeposited()
{
	thread CLArmorDepositThread()
}

void function CLArmorDepositThread()
{
	GetLocalViewPlayer().EndSignal( "OnDeath" )
	GetLocalViewPlayer().EndSignal( "OnDestroy" )

	wait 3.0
	AnnouncementMessageRight( GetLocalViewPlayer(), Localize( "#CRAFTING_WORKBENCH_ARMOR_DEPOSIT" ), "", <214,214,214>, $"", 3, "Crafting_MaterialsGathered_1P" )
}

void function CreateHarvesterWorldIcon( entity harvester )
{
	if( !IsValid( harvester ) )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	vector pos             = harvester.GetOrigin() + (harvester.GetUpVector() * 50)
	var rui                = CreateCockpitRui( $"ui/survey_beacon_marker_icon.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetImage( rui, "beaconImage", CRAFTING_CURRENCY_ASSET )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", pos )
	RuiSetFloat( rui, "sizeMin", 24 )
	RuiSetFloat( rui, "sizeMax", 40 )
	RuiSetFloat( rui, "minAlphaDist", 1000 )
	RuiSetFloat( rui, "maxAlphaDist", 3000 )
	RuiSetBool( rui, "shouldHideNearCrosshairs", true )
	RuiKeepSortKeyUpdated( rui, true, "pos" )
	file.harvesterRuiTable[harvester] <- rui
}

void function ServerCallback_Crafting_Notify_Player_On_Obit( entity notifyingPlayer, int notifyType, int cost, int itemIndex, int evoTier )
{
	if( !file.crafting_obit_notify )
		return

	if( !IsValid( notifyingPlayer ) || !notifyingPlayer.IsPlayer())
		return

	if(( notifyType < 0 ) || ( notifyType >= eCrafting_Obit_NotifyType.COUNT_ ))
		return

	
	CraftingCategory ornull item = GetCategoryForIndex( itemIndex )
	if ( item == null )
		return
	expect CraftingCategory( item )

	string itemCategory = item.category
	array<string> validItems = Crafting_GetLootDataFromIndex( itemIndex, notifyingPlayer )

	
	array< string > obit_SpecialCategories = [
		"evo",

			"banner"

	]

	if( obit_SpecialCategories.contains( itemCategory ) )
	{
		Crafting_Obit_Notify_Single( notifyingPlayer, notifyType, cost, itemCategory, evoTier )
	}
	else
	{
		int numValidItems = validItems.len()
		if( numValidItems > 0 )
		{
			
			array< string > prevItems = []
			for ( int i = numValidItems - 1; i >= 0; i-- )
			{
				
				if( !( prevItems.contains( validItems[i] )))
				{
					Crafting_Obit_Notify_Single( notifyingPlayer, notifyType, cost, validItems[i] )
					prevItems.append( validItems[i] )
				}
			}
		}
	}
}

void function Crafting_Obit_Notify_Single( entity notifyingPlayer, int notifyType, int mats, string itemRef, int evoTier = -1 )
{
	if( !IsValid( notifyingPlayer ) || !notifyingPlayer.IsPlayer())
		return

	string notifierName = notifyingPlayer.GetPlayerName()
	if( notifierName == "" )
		return

	if(( notifyType < 0 ) || ( notifyType > eCrafting_Obit_NotifyType.COUNT_ ))
		return

	string itemName = ""
	vector itemColor = < 255, 255, 255 >

	if ( itemRef == "evo" )
	{
		itemName = Localize( "#CRAFTING_ITEM_EVO" )
		LootData existingArmorData = EquipmentSlot_GetEquippedLootDataForSlot( notifyingPlayer, "armor" )

		if( evoTier >= 0 )
		{
			itemColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, evoTier )
		}
	}


	else if( itemRef == "banner" )
	{
		itemName = Localize( "#CRAFTING_ITEM_BANNER" )
	}

	else if ( SURVIVAL_Loot_IsRefValid( itemRef ) )
	{
		LootData lootData = SURVIVAL_Loot_GetLootDataByRef( itemRef )
		itemName = Localize( lootData.pickupString )
		itemColor = GetKeyColor( COLORID_TEXT_LOOT_TIER0, SURVIVAL_Loot_GetLootDataByRef( itemRef ).tier )
	}

	vector playerColor = GetKeyColor( COLORID_MEMBER_COLOR0, notifyingPlayer.GetTeamMemberIndex())

	if( itemName != "" )
	{
		switch( notifyType )
		{
			case eCrafting_Obit_NotifyType.IS_REQUESTING_MATERIALS:
				Obituary_Print_Localized( Localize( "#CRAFTING_REQUEST_MATS_TO_CRAFT_ITEM", notifierName, mats, itemName ), playerColor, itemColor )
				break
			case eCrafting_Obit_NotifyType.IS_CRAFTING_ITEM:
				Obituary_Print_Localized( Localize( "#CRAFTING_PLAYER_IS_CRAFTING_ITEM", notifierName, itemName ), playerColor, itemColor )
				break
			case eCrafting_Obit_NotifyType.SUBSEQUENT_ITEM:
				Obituary_Print_Localized( Localize( "#CRAFTING_SUBSEQUENT_ITEM", itemName ))
				break
			default:
				break
		}
	}
}





































































































































int function Crafting_GetPlayerCraftingMaterials( entity player )
{
	if ( Crafting_IsDispenserCraftingEnabled() )
		return 0

	if( !IsValid( player ) || !Crafting_IsEnabled() )
		return 0

	int playerMaterials = ( Crafting_PlaylistVar_IsEnabled() && file.isNetworkingRegistered ) ? player.GetPlayerNetInt( "craftingMaterials" ) : 0
	return playerMaterials
}


bool function Crafting_IsPlayerAtWorkbench( entity player )
{
	if ( !IsValid( player ) )
		return false

	foreach( ent in player.GetLinkParentArray() )
	{
		if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
			return true
	}

	return false
}

asset function Crafting_GetCraftingIcon( bool isAirdrop )
{






	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return isAirdrop ? DISPENSER_WORKBENCH_ICON_AIRDROP_ASSET : DISPENSER_WORKBENCH_ICON_ASSET
	}

	return isAirdrop ? WORKBENCH_ICON_AIRDROP_ASSET : WORKBENCH_ICON_ASSET
}

asset function Crafting_GetSmallCraftingIcon()
{






	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return DISPENSER_CRAFTING_SMALL_WORKBENCH_ASSET
	}

	return CRAFTING_SMALL_WORKBENCH_ASSET
}

asset function Crafting_GetCraftingZoneIcon()
{
	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return CRAFTING_2_ZONE_ASSET
	}

	return CRAFTING_ZONE_ASSET
}



























































































































































































































































































































































































































































































































































































void function OnWorkbenchClusterCreated( entity target )
{
	if ( !file.isEnabled )
	{
		return
	}

	if ( target.GetScriptName() != WORKBENCH_CLUSTER_SCRIPTNAME )
		return

	foreach( ent in target.GetLinkEntArray() )
	{
		OnWorkbenchCreated( ent, target )

		if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME && IsLimitedStockWorkbench( target ) )
			AddEntityCallback_GetUseEntOverrideText( ent, LimitedStock_TextOverride )
		else if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
		{
			AddEntityCallback_GetUseEntOverrideText( ent, Crafting_Workbench_UseTextOverride )

			if ( Crafting_IsDispenserCraftingEnabled() )
			{
				WorkbenchData benchData
				benchData.workbench = ent
				benchData.cluster = target

				file.workbenchDataTable_Client[ent] <- benchData
			}
		}
	}
	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		entity player = GetLocalViewPlayer()
		thread PlayClientSideWorkbenchHologramFX( target )
	}








	
	file.workbenchClusterArray.append( target )
}

void function OnWorkbenchCreated( entity target, entity cluster )
{
	if ( target.GetScriptName() != WORKBENCH_SCRIPTNAME )
		return

	AddCallback_OnUseEntity_ClientServer( target, UseCraftingWorkbench )
	SetCallback_CanUseEntityCallback( target, Crafting_Workbench_IsNotBusy )
}

string function Crafting_Workbench_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()

	CustomUsePrompt_Show( ent )
	CustomUsePrompt_SetSourcePos( ent.GetOrigin() + ( ent.GetScriptName() == HARVESTER_SCRIPTNAME ? < 0, 0, 30 > : <0,0,-20> ) )

	CustomUsePrompt_SetText( Localize("#CRAFTING_WORKBENCH_USE_PROMPT") )

	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		CustomUsePrompt_SetText( Localize("#DISPENSER_USE_PROMPT") )

		WorkbenchData dispensorData = file.workbenchDataTable_Client [ ent ]
		if ( player in dispensorData.playersHaveUsed )
			CustomUsePrompt_SetText( Localize("#DISPENSER_HAS_USED_PROMPT") )
	}
























	CustomUsePrompt_SetLineColor( GetCraftingColor() )

	if ( PlayerIsInADS( player ) )
		CustomUsePrompt_ShowSourcePos( false )
	else
		CustomUsePrompt_ShowSourcePos( true )

	return ""
}


void function UseCraftingWorkbench( entity bench, entity player, int pickupFlags )
{

		CustomUsePrompt_SetLastUsedTime( Time() )


	if ( player.IsInventoryOpen() )
		return

	if( player.Player_IsSkywardLaunching() )
		return

	if( player.Player_IsSkywardFollowing() )
		return


		if ( TitanSword_Super_BlockAction( player, "use_crafter" ) )
			return



























	if ( IsBitFlagSet( pickupFlags, USE_INPUT_LONG ) )
	{
		entity cluster
		foreach ( ent in bench.GetLinkParentArray() )
		{
			if ( ent.GetScriptName() == WORKBENCH_CLUSTER_SCRIPTNAME )
			{
				cluster = ent
				break
			}
		}

		
		if ( IsLimitedStockWorkbench( cluster ) && GetLimitedStockFromWorkbench( cluster ) <= 0 )
			return

		thread WorkbenchThink( bench, player )


			cluster.Signal("WorkbenchUsed")

	}



























}

void function WorkbenchThink( entity ent, entity playerUser )
{










		if ( Crafting_IsDispenserCraftingEnabled() )
		{
			WorkbenchData craftingBenchData = file.workbenchDataTable_Client[ent]
			if ( playerUser in craftingBenchData.playersHaveUsed )
				return
		}


	ExtendedUseSettings settings = WorkbenchExtendedUseSettings( ent, playerUser )

	ent.EndSignal( "OnDestroy" )
	playerUser.EndSignal( "StartPhaseShift" )

	waitthread ExtendedUse( ent, playerUser, settings )
}


























ExtendedUseSettings function WorkbenchExtendedUseSettings( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.duration = 0.3

	settings.loopSound = "UI_Survival_PickupTicker"
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = DefaultExtendedUseRui
	settings.icon = $""
	settings.hint = "#PROMPT_OPEN"





	return settings
}










































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































int function EnsureValidEvoTier( int evoTier )
{

	if( evoTier > MAX_ARMOR_EVO_TIER )
		return MAX_ARMOR_EVO_TIER

	
	if( evoTier == 4  )
		return MAX_ARMOR_EVO_TIER

	if( evoTier < -1 )
		return -1

	return evoTier
}

bool function Crafting_IsItemCurrentlyOwnedByAnyPlayer( entity itemEnt )
{
	if ( !IsValid( itemEnt ) )
		return false

	if ( !IsValid( itemEnt.GetParent() ) )
		return false

	if ( ! ( itemEnt.GetParent().GetScriptName() == HOLDER_ENT_NAME ) )
		return false

	if ( !IsValid( itemEnt.GetParent().GetOwner() ) )
		return false

	if ( ! ( itemEnt.GetParent().GetOwner().IsPlayer() ) )
		return false

	return true
}

bool function Crafting_DoesPlayerOwnItem( entity player, entity itemEnt )
{
	if ( !IsValid( player ) )
		return false

	if ( !Crafting_IsItemCurrentlyOwnedByAnyPlayer( itemEnt ) )
		return false

	return player == itemEnt.GetParent().GetOwner()
}

array< string > function GenerateCraftingItemsInCategory( entity player, CraftingCategory categoryToCheck )
{
	int craftingRotation = categoryToCheck.rotationStyle

	
	if ( craftingRotation == eCraftingRotationStyle.PERMANENT || craftingRotation == eCraftingRotationStyle.SEASONAL )
	{
		CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
		return bundle.itemsInBundle
	}


	if ( craftingRotation == eCraftingRotationStyle.PERK )
	{
		bool has_banners = Player_Banners_Enabled()
		if ( Crafting_IsDispenserCraftingEnabled() && ( GetRespawnStyle() == eRespawnStyle.RESPAWN_CHAMBERS ) && has_banners )
		{
			CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
			return bundle.itemsInBundle
		}
		else
		{
			if ( categoryToCheck.category == "banner" && ( Perk_CanBuyBanners( player ) && ( GetRespawnStyle() == eRespawnStyle.RESPAWN_CHAMBERS ) && has_banners || Perks_DoesPlayerHavePerk( player, ePerkIndex.BANNER_CRAFTING ) ) )
			{
				CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
				return bundle.itemsInBundle
			}







			else
			{
				return []
			}
		}
	}



		if ( categoryToCheck.category == "mode_objectivebr" )
		{
			if ( Crafting_IsDispenserCraftingEnabled() && GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_OBJECTIVE_BR ) )
			{
				CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
				return bundle.itemsInBundle
			}
			else
			{
				return []
			}
		}


	if ( craftingRotation == eCraftingRotationStyle.LOADOUT_BASED )
	{
		array< string > itemList
		CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
		array< string > listToCheck = bundle.itemsInBundle

		array<entity> weapons  = SURVIVAL_GetPrimaryWeapons( player )
		foreach( slot, weapon in weapons )
		{
			int ammoType = weapon.GetWeaponAmmoPoolType()
			string ammoRef = AmmoType_GetRefFromIndex(ammoType)

			foreach( item in listToCheck )
			{
				if ( item == ammoRef )
					itemList.append( item )
			}
		}

		return itemList
	}


	CraftingBundle bundle = GetBundleForCategory( categoryToCheck )
	array< string > listToCheck = bundle.itemsInBundle

	return listToCheck
}

void function Crafting_Obit_Items_Notify_Teammates( entity notifyingplayer, int notifyType, int cost, int itemIndex, int evoTier = -1 )
{
	if( file.crafting_obit_notify )
	{
		int evoTierToUse = EnsureValidEvoTier( evoTier )




			Remote_ServerCallFunction( "ClientCallback_Crafting_Notify_Teammates_On_Obit", notifyType, cost, itemIndex, evoTierToUse )

	}
}

CraftingBundle function GetBundleForCategory( CraftingCategory categoryToCheck )
{
	int craftingRotation = categoryToCheck.rotationStyle

	

	if ( CheckCraftingRotation( craftingRotation ) )
	{
		Assert( categoryToCheck.bundlesInCategory.len() != 0, "CRAFTING: Bundle list in category " + categoryToCheck.category + " is empty" )
		return categoryToCheck.bundlesInCategory[categoryToCheck.bundleStrings.top()]
	}

	
	string unixTimeEventStartString = GetCurrentPlaylistVarString( "crafting_rotation_start", "2020-03-01 10:00:00 -08:00" )
	int unixTimeNow







		if ( !IsLobby() )
			unixTimeNow = int(GetGlobalNetTime( "Crafting_StartTime" ))
		else
			unixTimeNow = GetUnixTimestamp()


	int ornull unixTimeEventStart = DateTimeStringToUnixTimestamp( unixTimeEventStartString )
	Assert( unixTimeEventStart != null, format( "Bad format in playlist for setting 'crafting_rotation_start': '%s'", unixTimeEventStartString ) )
	expect int( unixTimeEventStart )

	int unixTimeSinceEventStarted = ( unixTimeNow - unixTimeEventStart )
	int hoursSinceEventStarted = int( floor( unixTimeSinceEventStarted / SECONDS_PER_HOUR ) )
	int daysSinceEventStarted =  int( floor( unixTimeSinceEventStarted / SECONDS_PER_DAY ) )
	int weeksSinceEventStarted = int( floor( unixTimeSinceEventStarted / SECONDS_PER_WEEK ) )

	int rotationRaw = 1
	if ( craftingRotation == eCraftingRotationStyle.WEEKLY )
	{
		rotationRaw = weeksSinceEventStarted
	} else if ( craftingRotation == eCraftingRotationStyle.DAILY )
	{
		rotationRaw = daysSinceEventStarted
	} else if ( craftingRotation == eCraftingRotationStyle.HOURLY )
	{
		rotationRaw = hoursSinceEventStarted
	}

	int rotationIndex = abs(rotationRaw % ( categoryToCheck.bundleStrings.len() ) )
	return categoryToCheck.bundlesInCategory[ categoryToCheck.bundleStrings[rotationIndex] ]
}

bool function CheckCraftingRotation( int craftingRotation )
{
	if ( craftingRotation == eCraftingRotationStyle.PERMANENT )
		return true

	if ( craftingRotation == eCraftingRotationStyle.SEASONAL )
		return true

	if ( craftingRotation == eCraftingRotationStyle.LOADOUT_BASED )
		return true


	if ( craftingRotation == eCraftingRotationStyle.PERK )
		return true


	




	return false
}






















































































#if DEV


















void function DEV_Crafting_PrintsOn( bool isOn = true )
{
	file.devPrintsOn = isOn
}

void function DEV_Crafting_Print( string printThis )
{
	if( file.devPrintsOn )
	{
		printt( format( "CRAFTING: %s ", printThis ))
	}
}

#endif



bool function Crafting_Workbench_IsNotBusy( entity player, entity ent, int useFlags )
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, ent ) )
		return false

	bool isWorkbenchBusy = ent.GetLinkEntArray().len() != 0
	bool isWorkbenchCrafting = ent.GetOwner() != null

	if( Crafting_CraftersDisabledInDeathField() )
	{
		if ( DeathField_PointDistanceFromFrontier( ent.GetOrigin(), player.DeathFieldIndex() ) <= 0 )
		{
			return false
		}
	}

	if ( isWorkbenchBusy || isWorkbenchCrafting )
		return false

	return true
}


array<string> function Crafting_GetLootDataFromIndex( int index, entity player )
{
	entity workbench
	array<entity> possibleWorkbenches = player.GetLinkParentArray()
	foreach( ent in possibleWorkbenches )
	{
		if ( ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
		{
			foreach ( cluster in ent.GetLinkParentArray() )
			{
				if ( cluster.GetScriptName() == WORKBENCH_CLUSTER_SCRIPTNAME )
				{
					workbench = cluster
					break
				}
			}

			if ( workbench != null )
				break
		}
	}

	CraftingCategory ornull item = GetCategoryForIndex( index )
	array< string > validItemList

	if ( item == null )
		return validItemList

	expect CraftingCategory( item )
	bool showWhenEmpty = false

	validItemList = GenerateCraftingItemsInCategory( player, item )

	int cumulativeIndex = 0
	foreach( category in file.craftingDataArray )
	{
		if ( category == item )
			break

		cumulativeIndex += category.numSlots
	}

	if ( item.category == "ammo" || item.category == "evo" || item.category == "banner" )
		return validItemList


	if ( validItemList.len() == 0 )
		return validItemList

	array<string> finalItemList
	int difference = index - cumulativeIndex
	finalItemList.append( validItemList[difference] )
	return finalItemList
}


CraftingCategory ornull function GetCategoryForIndex( int index )
{
	int cumulativeIndex = 0
	foreach( category in file.craftingDataArray )
	{
		cumulativeIndex += category.numSlots
		if ( index < cumulativeIndex )
			return category
	}

	return null
}


































void function MarkNextStepForPlayer( entity markedEnt )
{
	thread NextStepMarkerThread( markedEnt )
}

void function NextStepMarkerThread( entity markedEnt )
{
	table<int, var> result = CreateMarker( markedEnt, true )

	markedEnt.EndSignal( "HarvesterDisabled" )
	markedEnt.EndSignal( "WorkbenchUsed" )

	OnThreadEnd(
		function() : ( result )
		{
			foreach( fxId, rui in result)
			{
				EffectStop( fxId, true, false )
				RuiSetBool( rui, "isFinished", true )
			}
		}
	)

	wait 20

	return
}

void function MarkAllWorkbenches()
{
	foreach( cluster in file.workbenchClusterArray )
	{
		table<int, var> result = CreateMarker(cluster)
		foreach( fxId, rui in result)
		{
			file.workbenchMarkerList.append( fxId )
			file.workbenchMarkerRuiList.append( rui )
		}
	}
}

bool function ShouldShowCraftingMapFeature()
{
	if( !GameMode_IsActive( eGameModes.SURVIVAL ) )
		return false


	if( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_WINTEREXPRESS ) )
		return false


	return true
}

void function Crafting_ShowCraftingMapFeature()
{
	if( !ShouldShowCraftingMapFeature() )
		return

	string mapName = GetMapName()
	bool showMapFeature = true

	
	
	if(  mapName.find( "mp_rr_tropic_island" ) >= 0 )
		showMapFeature = false

	if( showMapFeature )
	{
		if ( Crafting_IsDispenserCraftingEnabled() )
		{
			SetMapFeatureItem( 100, "#DISPENSER_MAP_FEATURE_TITLE", "#DISPENSER_MAP_FEATURE_DESC", Crafting_GetCraftingIcon( false ) )
		}
		else if ( !Crafting_IsDispenserCraftingEnabled() )
		{
			SetMapFeatureItem( 100, "#CRAFTING_CLUSTER_MAP_FEATURE", "#CRAFTING_CLUSTER_MAP_FEATURE_DESC", Crafting_GetCraftingIcon( false ) )
		}
	}
}

table<int, var> function CreateMarker( entity markedEnt, bool shouldFadeOutNearCrosshair = false )
{
	table<int, var> resultTable
	if ( !IsValid( markedEnt ) )
		return resultTable

	asset iconToUse = $""
	switch( markedEnt.GetScriptName() )
	{
		case HARVESTER_SCRIPTNAME:
			iconToUse = HARVESTER_ICON_ASSET
			break
		case WORKBENCH_CLUSTER_SCRIPTNAME:
			iconToUse = Crafting_GetCraftingIcon( false )
			break
	}

	int fxHandle
	if (Crafting_IsDispenserCraftingEnabled())
	{
		fxHandle = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( WORKBENCH_DISPENSER_BEAM_FX ), markedEnt.GetOrigin(), markedEnt.GetAngles() )
		EffectSetControlPointVector( fxHandle, 1, WORKBENCH_DISPENSER_VFX_COLOR )






	}
	else
	{
		fxHandle = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( WORKBENCH_BEAM_FX ), markedEnt.GetOrigin(), markedEnt.GetAngles() )
	}

	entity localViewPlayer = GetLocalViewPlayer()
	vector pos             = markedEnt.GetOrigin() + (markedEnt.GetUpVector() * 200)
	var rui                = CreatePermanentCockpitRui( $"ui/survey_beacon_marker_icon.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetImage( rui, "beaconImage", iconToUse )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", pos )
	RuiSetFloat( rui, "sizeMin", 24 )
	RuiSetFloat( rui, "sizeMax", 40 )
	RuiSetFloat( rui, "minAlphaDist", 50000 )
	RuiSetFloat( rui, "maxAlphaDist", 200000 )
	RuiSetBool( rui, "shouldHideNearCrosshairs", shouldFadeOutNearCrosshair )
	RuiKeepSortKeyUpdated( rui, true, "pos" )

	EmitSoundOnEntity( localViewPlayer, "coop_minimap_ping" )

	resultTable[fxHandle] <- rui
	return resultTable
}

void function DestroyWorkbenchMarkers()
{
	foreach( id in file.workbenchMarkerList )
		EffectStop( id, true, false )

	file.workbenchMarkerList.clear()

	foreach( rui in file.workbenchMarkerRuiList )
	{
		RuiSetBool( rui, "isFinished", true )
	}

	file.workbenchMarkerRuiList.clear()
}


void function Crafting_OnGainFocus( entity ent )
{
	if ( !IsValid( ent ) )
		return

	if ( ent.GetScriptName() == HARVESTER_SCRIPTNAME || ent.GetScriptName() == WORKBENCH_SCRIPTNAME )
		CustomUsePrompt_Show( ent )

}


void function Crafting_OnLoseFocus( entity ent )
{
	if ( ent != null && ent.GetScriptName() == HARVESTER_SCRIPTNAME )
		CustomUsePrompt_ClearForEntity( ent )
}

#if DEV
void function DEV_Crafting_TogglePreMatchRotation()
{
	if ( file.DEV_testingRotationRui )
	{
		file.DEV_testingRotationRui = false
	}
	else
	{
		file.gameStartRuiCreated = false
		file.DEV_testingRotationRui = true
		OnWaitingForPlayers_Client()
	}
}

void function DEV_Crafting_PrintUsedHarvesterEHIs()
{
	entity player = GetLocalViewPlayer()
	EHI playerEHI = ToEHI( player )

	if( playerEHI in file.usedHarvesterEHIs )
	{
		printt( format( "Used Harvester EHIs for %s", string( player ) ) )
		array< EHI > usedHarvesterEHIs = file.usedHarvesterEHIs[ playerEHI ]
		foreach( harvesterEHI in usedHarvesterEHIs )
		{
			printt( "Used Harvester EHI == " + harvesterEHI )
		}
	}
	else
	{
		printt( format( "%s has no used EHIs", string( player ) ) )
	}
}

#endif

void function OnWaitingForPlayers_Client()
{
	if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) || GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_TRAINING ) || HasWaitingGameStateArtHud() )
		return

	if ( file.gameStartRui.len() != 0 )
		Warning( "CRAFTING: OnWaitingForPlayers_Client() in sh_crafting.nut is being triggering multiple times - Code should investigate" )
	
	if ( file.gameStartRuiCreated )
		return

	if ( !Crafting_IsDispenserCraftingEnabled() )
	{
		file.gameStartRuiCreated = true
		var craftingGameStartRui = RuiCreate( $"ui/crafting_game_start.rpak", clGlobal.topoFullScreen, RUI_DRAW_POSTEFFECTS, 1 )
		file.gameStartRui.append( craftingGameStartRui )

		for ( int i = 0; i < 6; i++ )
		{
			var rui = SetupWorkbenchPreview( file.gameStartRui[0], i , "rotation" + i, false )
			file.gameStartRui.append( rui )
			
			
		}
	}

	thread GameStart_CleanupThread()
}


void function GameStart_CleanupThread()
{
	OnThreadEnd(
		function() : (  )
		{
			if ( file.gameStartRui.len() != 0 )
			{
				RuiDestroy( file.gameStartRui[0] )
				file.gameStartRui.clear()
			}
		}
	)

#if DEV
	while ( file.DEV_testingRotationRui )
	{
		WaitFrame()
	}
#endif
	while ( GetGameState() == eGameState.WaitingForPlayers )
	{
		WaitFrame()
	}

	
}


void function UICallback_PopulateCraftingPanel( var button )
{
	if ( Crafting_IsDispenserCraftingEnabled() )
		return

	var rui = Hud_GetRui( button )
	if ( rui == null )
		return
	
	for ( int i = 0; i < 6; i++ )
	{
		var nestedRui = SetupWorkbenchPreview( rui, i , "rotation" + i, false )
		RuiSetBool( nestedRui, "shouldDisplayCost", false )
		if ( i == 1 || i == 3 || i == 5 )
			RuiSetBool( nestedRui, "shouldDisplayRotation", true )
	}
}


var function SetupWorkbenchPreview( var baseRui, int index, string uiHandle, bool shouldShowLimitedStock = true, bool shouldUseMini = false, string itemRefOverride = "" )
{
	RuiDestroyNestedIfAlive( baseRui, uiHandle )

	var rui = RuiCreateNested( baseRui, uiHandle, $"ui/crafting_button.rpak" )
	if ( shouldUseMini )
		RuiSetBool( rui, "isMini", true )

	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "cost", 0 )

	array< string > validItemList
	if ( itemRefOverride == "" )
	{
		validItemList = Crafting_GetLootDataFromIndex( index, GetLocalViewPlayer() )
	} else {
		validItemList.append( itemRefOverride )
	}

	RuiSetBool( rui, "isWeapon", false )
	RuiSetInt( rui, "limitedStockAmount", 0 )

	CraftingCategory ornull item
	item = GetCategoryForIndex( index )
	if ( item == null )
		return

	if ( validItemList.len() != 0 )
	{
		expect CraftingCategory( item )
		string refString = validItemList[0]
		int cost = item.itemToCostTable[refString]

		LootData lootRef = SURVIVAL_Loot_GetLootDataByRef( refString )
		asset hudIcon = lootRef.craftingIcon != $"" ? lootRef.craftingIcon : lootRef.hudIcon
		RuiSetImage( rui, "iconImage", hudIcon )
		RuiSetInt( rui, "lootTier", lootRef.tier )


			if ( lootRef.ref == "hopup_golden_horse_green" )
			{
				RuiSetInt( rui, "lootTier", GOLDEN_HORSE_SPECIAL_EVENT_LOOT_TIER )
			}


		if ( lootRef.lootType == eLootType.MAINWEAPON )
		{
			RuiSetBool( rui, "isWeapon", true )
			RuiSetString( rui, "name", Localize( GetWeaponInfoFileKeyField_GlobalString( GetBaseWeaponRef(refString), "shortprintname" ) ) )
		}

		RuiSetInt( rui, "cost", cost )
	}

	RuiSetBool( rui, "isOwned", false )
	if ( item != null )
	{
		expect CraftingCategory( item )
		RuiSetInt( rui, "rotationStyle", item.rotationStyle )
	}

	return rui
}

void function OnGameStartedPlaying_Client()
{
	if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) || GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_TRAINING ) )
		return

	if ( file.fullmapInitialized )
	{
		printf( "CRAFTING: Cancelling fullmap init because it already exists" )
		return
	}

	if ( !Crafting_IsDispenserCraftingEnabled() )
	{
		file.fullmapRui.append( RuiCreate( $"ui/crafting_fullmap.rpak", clGlobal.topoFullscreenFullMap, FULLMAP_RUI_DRAW_LAYER, 20 ) )
		RuiTrackInt( file.fullmapRui[0], "craftingMaterials", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "craftingMaterials" ) )

		for ( int i = 0; i < 6; i++ )
		{
			if ( Crafting_IsDispenserCraftingEnabled() )
				break

			var rui = SetupWorkbenchPreview( file.fullmapRui[0], i, "rotation" + i, false )
			RuiSetBool( rui, "isMini", true )
			file.fullmapRui.append( rui )
		}

		InitHUDRui( file.fullmapRui[0] )
		Fullmap_AddRui( file.fullmapRui[0] )

		file.fullmapInitialized = true
	}

#if DEV
	DEV_Crafting_Print( format( "CLIENT: Player Started Playing: %s", string( GetLocalViewPlayer() ) ) )
#endif

	
}









































void function OnPlayerMatchStateChanged( entity player, int newState )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( newState == ePlayerMatchState.NORMAL )
	{
		DestroyWorkbenchMarkers()
	}
}




















vector function GetCraftingColor()
{
	if ( Crafting_IsDispenserCraftingEnabled() )
	{
		return SrgbToLinear( CRAFTING_2PT0_COLOR / 255.0 )
	}

	return SrgbToLinear( <0, 255, 240> / 255.0 )
}



void function Crafting_Workbench_OpenCraftingMenu( entity workbench )
{
	file.playerIsCrafting = true

	CommsMenu_Shutdown( false )
	HideScoreboard()

	if ( !CommsMenu_CanUseMenu( GetLocalViewPlayer(), eChatPage.CRAFTING ) )
	{
		return
	}

	if ( Bleedout_IsBleedingOut( GetLocalViewPlayer() ) )
		return

	file.craftingItems_ClientList.clear()

	PushLockFOV(0.2)
	UpgradeSelectionMenu_TryClose()
	CommsMenu_OpenMenuTo( GetLocalViewPlayer(), eChatPage.CRAFTING, eCommsMenuStyle.CRAFTING, false )

	if ( GetLocalClientPlayer() == GetLocalViewPlayer() && GetCurrentPlaylistVarBool("crafting_enable_stuck_player_fix", false) )
	{
		thread Crafting_StuckPlayerWatchdog_Thread( workbench )
	}
}

void function Crafting_Workbench_OpenCraftingMenuAsSpectator( entity workbench )
{
	if ( !IsLocalPlayerOnTeamSpectator() )
		return

	CommsMenu_Shutdown( false )
	file.craftingItems_ClientList.clear()

	PushLockFOV(0.2)
	UpgradeSelectionMenu_TryClose()
	CommsMenu_OpenMenuTo( GetLocalViewPlayer(), eChatPage.CRAFTING, eCommsMenuStyle.CRAFTING, false )
}

void function Crafting_StuckPlayerWatchdog_Thread( entity workbench )
{
	Assert( GetLocalViewPlayer() == GetLocalClientPlayer(), "Spectators shouldn't be running this function" )

	entity player = GetLocalViewPlayer()
	EndSignal( player, "OnDeath", "OnDestroy")
	EndSignal( workbench, "OnDestroy" )

	while ( true )
	{
		WaitFrame()

		if ( IsCommsMenuActive() )
			continue

		wait 0.5

		entity crafter = player.GetParent()
		if ( !IsValid( crafter ) )
			break

		if ( crafter.GetScriptName() != WORKBENCH_CLUSTER_SCRIPTNAME )
			break

		Remote_ServerCallFunction( "ClientCallback_ClosedCraftingMenu" )
	}
}

bool function Crafting_OnMenuItemSelected( int index, var menuRui )
{
	if ( !file.isEnabled )
		return false

	CraftingCategory ornull item = GetCategoryForIndex( index )
	array< string > validItemList

	if ( item == null )
	{
		RuiSetGameTime( menuRui, "invalidSelectionTime", Time() )
		return false
	}

	expect CraftingCategory( item )
	entity player = GetLocalViewPlayer()

	validItemList = Crafting_GetLootDataFromIndex( index, player )

	int cost
	bool canBuy = true
	if ( validItemList.len() != 0 )
	{
		foreach ( ref in validItemList )
			cost += item.itemToCostTable[ref]

		if ( item.category == "evo" )
		{
			LootData existingArmorData = EquipmentSlot_GetEquippedLootDataForSlot( GetLocalViewPlayer(), "armor" )
			if ( existingArmorData.ref.find( "evolving" ) == -1 )
			{
				canBuy = false
			}
			else if ( existingArmorData.tier >= 5 )
			{

				canBuy = false
			}
			
		}

		else if (  item.category == "banner" )
		{
			if ( Perk_CanBuyBanners( player ) )
				canBuy = true
			else
				canBuy = false
		}








		else if ( item.category == "mode_objectivebr" )
		{
			canBuy = GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_OBJECTIVE_BR )
		}

	}
	else
	{
		canBuy = false
	}

	bool canAfford = Crafting_GetPlayerCraftingMaterials( player ) >= cost

	
	if (canBuy && canAfford)
	{
		Remote_ServerCallFunction( "ClientCallback_InitializeCraftingAtWorkbench", index )
		Crafting_Workbench_CloseCraftingMenu()
		return true
	}
	else
	{
		CraftingBundle bundle = GetBundleForCategory( item )
		RuiSetGameTime( bundle.attachedRui[index], "invalidSelectionTime", Time() )
		RuiSetGameTime( menuRui, "invalidSelectionTime", Time() )

		
		if( file.crafting_obit_notify )
		{
			int materialsNeeded = cost - Crafting_GetPlayerCraftingMaterials( player )
			if(( canBuy ) && ( materialsNeeded > 0 ))
			{
				Crafting_Obit_Items_Notify_Teammates( player, eCrafting_Obit_NotifyType.IS_REQUESTING_MATERIALS, materialsNeeded, index )
			}
		}

		return false
	}

	unreachable
}


void function TryCloseCraftingMenu()
{
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		Crafting_Workbench_CloseCraftingMenu()
	}
	else
	{
		if ( file.craftingBetterSpectatorEnabled )
		{
			thread TryCloseCraftingMenuForSpectator_Thread()
		}
	}
}

void function TryCloseCraftingMenuForSpectator_Thread()
{
	wait 0.2
	Signal(GetLocalClientPlayer(), "crafting_kill_spectator_thread")
	Crafting_Workbench_CloseCraftingMenu()
}

void function ServerCallback_SetCraftingIndexForSpectator( int index )
{
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
		return

	CommsMenu_SetCurrentChoiceForCrafting( index )
}

void function Crafting_Workbench_CloseCraftingMenu( )
{
	if ( !IsCommsMenuActive() )
		return
	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.CRAFTING )
		return

	file.playerIsCrafting = false
	CommsMenu_Shutdown( true )
}

void function Crafting_OnWorkbenchMenuClosed( bool instant )
{
	if ( !file.isEnabled)
		return
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		Remote_ServerCallFunction( "ClientCallback_ClosedCraftingMenu" )
	}
	PopLockFOV( instant ? 0.0 : 0.1 )

	file.playerIsCrafting = false
	file.craftingItems_ClientList.clear()
}

void function CreateWorkbenchWorldIcon( entity workbench, bool isLimitedStock = false )
{
	entity localViewPlayer = GetLocalViewPlayer()
	vector pos             = workbench.GetOrigin() + (workbench.GetUpVector() * 160)
	var rui                = CreateCockpitRui( $"ui/survey_beacon_marker_icon.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetImage( rui, "beaconImage", isLimitedStock ? WORKBENCH_ICON_LIMITED_ASSET : Crafting_GetCraftingIcon( false ) )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", pos )
	RuiSetFloat( rui, "sizeMin", 48 )
	RuiSetFloat( rui, "minAlphaDist", 1000 )
	RuiSetFloat( rui, "maxAlphaDist", 3000 )
	RuiKeepSortKeyUpdated( rui, true, "pos" )
	file.workbenchRuiTable[workbench] <- rui
}

void function SetupProgressWaypoint( entity waypoint )
{
	if ( Crafting_IsDispenserCraftingEnabled() )
		return

	if ( waypoint.GetWaypointType() != eWaypoint.OBJECTIVE || Waypoint_GetPingTypeForWaypoint( waypoint ) != ePingType.OBJECTIVE )
	{
		return
	}

	thread SetupProgressWaypoint_Internal( waypoint )
}

void function SetupProgressWaypoint_Internal( entity waypoint )
{
	if ( waypoint.GetWaypointType() != eWaypoint.OBJECTIVE || Waypoint_GetPingTypeForWaypoint( waypoint ) != ePingType.OBJECTIVE )
	{
		return
	}

	int timeoutCounter = 0
	while ( IsValid( waypoint ) && waypoint.wp.ruiHud == null )
	{
		printf( "CRAFTING: Waypoint WaitFrame" )
		WaitFrame()
		timeoutCounter++
		if (timeoutCounter > 1000)
			return
	}

	if ( !IsValid( waypoint ) )
	{
		printf( "CRAFTING: Waypoint Invalid" )
		return
	}

	RuiSetFloat( waypoint.wp.ruiHud, "maxDrawDistance", 3000 )
	RuiSetFloat( waypoint.wp.ruiHud, "iconSize", 72.0 )
	RuiSetFloat( waypoint.wp.ruiHud, "iconSizePinned", 72.0 )
	RuiSetImage( waypoint.wp.ruiHud, "outerIcon", $"rui/events/s03e01a/item_source_icon" )
	RuiSetImage( waypoint.wp.ruiHud, "innerIcon", $"rui/events/s03e01a/item_source_icon" )
	RuiSetInt( waypoint.wp.ruiHud, "yourObjectiveStatus", 2 )
	RuiSetInt( waypoint.wp.ruiHud, "yourTeamIndex", GetLocalViewPlayer().GetTeam() )
	RuiSetInt( waypoint.wp.ruiHud, "roundState", 0 )
	RuiSetString( waypoint.wp.ruiHud, "pingPrompt", Localize( "#CRAFTING_PROMPT" ) )
	RuiSetString( waypoint.wp.ruiHud, "pingPromptForOwner", Localize( "#CRAFTING_PROMPT" ) )
	RuiSetBool( waypoint.wp.ruiHud, "reverseProgress", false )
	RuiSetBool( waypoint.wp.ruiHud, "iconColorOverride", true )
	RuiSetFloat3( waypoint.wp.ruiHud, "iconColor", Crafting_GetWaypointColor( waypoint ) )
	RuiSetImage( waypoint.wp.ruiHud, "fillBackgroundImage", $"rui/hud/gametype_icons/obj_background_capturepoint" )
	RuiSetImage( waypoint.wp.ruiHud, "fillImage", $"rui/hud/gametype_icons/obj_background_capturepoint_fill" )

	RuiTrackGameTime( waypoint.wp.ruiHud, "captureEndTime", waypoint, RUI_TRACK_WAYPOINT_GAMETIME, RUI_TRACK_INDEX_CAPTURE_END_TIME )
	RuiTrackFloat( waypoint.wp.ruiHud, "captureTimeRequired", waypoint, RUI_TRACK_WAYPOINT_FLOAT, RUI_TRACK_INDEX_REQUIRED_TIME )
	RuiTrackInt( waypoint.wp.ruiHud, "currentControllingTeam", waypoint, RUI_TRACK_WAYPOINT_INT, RUI_TRACK_INDEX_ACTIVATOR_TEAM )

	thread PlayWorkbenchPrintingFX( waypoint, waypoint.GetWaypointString( 0 )  )
}

void function PlayWorkbenchPrintingFX( entity waypoint, string animIndex )
{
	waypoint.EndSignal( "OnDestroy" )

	entity workbench = waypoint.GetParent()
	foreach ( cluster in workbench.GetLinkParentArray() )
	{
		if ( cluster.GetScriptName() == WORKBENCH_CLUSTER_SCRIPTNAME )
		{
			workbench = cluster
			break
		}
	}

	int attachId = workbench.LookupAttachment( "FX_DOOR_OPEN_" + animIndex )
	int fxHandle = StartParticleEffectOnEntity( workbench, GetParticleSystemIndex( WORKBENCH_PRINTING_FX ), FX_PATTACH_POINT_FOLLOW, attachId )
	vector lootTier = Crafting_GetWaypointColor( waypoint )

	EffectSetControlPointVector( fxHandle, 1, lootTier )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, true, false )
		}
	)

	WaitForever()
}

vector function Crafting_GetWaypointColor( entity waypoint, bool isVFX = false )
{
	switch( waypoint.GetWaypointInt( 6 ) )
	{
		case 1: 
			return SrgbToLinear( GetKeyColor( COLORID_HUD_HEAL_COLOR ) / 255.0 )
			break
		case 0:
		default:
			if( isVFX )
				return GetFXRarityColorForTier( waypoint.GetWaypointInt( 5 ) )
			else
				return ( GetKeyColor( COLORID_LOOT_TIER0 + waypoint.GetWaypointInt( 5 ) ) / 255.0 )
			break
	}

	return ( GetKeyColor( COLORID_LOOT_TIER0 + waypoint.GetWaypointInt( 5 ) ) / 255.0 )
}

void function ServerCallback_UpdateWorkbenchVars()
{
	if ( GetGameState() != eGameState.Playing )
		return

	CommsMenu_RefreshData()
}


void function ServerCallback_PromptNextHarvester( entity playerBeingAddressed, entity harvester )
{
	if( !IsValid( harvester ) )
		return

	if( !IsValid( playerBeingAddressed ) )
		return

	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_CRAFTING_NEXT_HARVESTER_OR_WORKBENCH, null) )
		return

	const float DELAY = 0.5
	const float DURATION = 5.0

	thread PromptAfterDelayThread( playerBeingAddressed, eCommsAction.REPLY_CRAFTING_NEXT_HARVESTER_OR_WORKBENCH, "#PING_CRAFTING_NEXT_HARVESTER" , DELAY, DURATION )
}

void function ServerCallback_PromptWorkbench( entity playerBeingAddressed, entity workbench )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_CRAFTING_NEXT_HARVESTER_OR_WORKBENCH, null) )
		return

	const float DELAY = 2.5
	const float DURATION = 6.0

	thread PromptAfterDelayThread( playerBeingAddressed, eCommsAction.REPLY_CRAFTING_NEXT_HARVESTER_OR_WORKBENCH, "#PING_CRAFTING_NEXT_WORKBENCH" , DELAY, DURATION )
}

void function ServerCallback_PromptAllWorkbenches( entity playerBeingAddressed )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_CRAFTING_PING_ALL_WORKBENCHES, null ) )
		return

	const float DELAY = 2.0

	thread PromptAfterDelayThread( playerBeingAddressed, eCommsAction.REPLY_CRAFTING_PING_ALL_WORKBENCHES, "#PING_CRAFTING_ALL_WORKBENCHES", DELAY )
}

void function PromptAfterDelayThread( entity player, int commAction, string promptText, float delay = 2.5, float duration = 10 )
{
	wait delay

	if ( !IsValid( player ) )
		return

	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( commAction, player ), duration, Localize( promptText ) )
}


void function Crafting_PopulateItemRuiAtIndex( var rui, int index )
{
	if ( !file.isEnabled )
		return

	if ( IsLobby() )
		return

	CraftingCategory ornull item = GetCategoryForIndex( index )
	array<string> validItemList

	if ( item == null )
		return

	expect CraftingCategory( item )
	validItemList = Crafting_GetLootDataFromIndex( index, GetLocalViewPlayer() )

	int cost
	bool canBuy = true

		if ( validItemList.len() != 0 && item.category != "evo" && item.category != "banner" && item.category != "event_special" )



	{
		foreach ( ref in validItemList )
			cost += item.itemToCostTable[ref]


		LootData lootRef = SURVIVAL_Loot_GetLootDataByRef( validItemList[0] )
		asset hudIcon = lootRef.craftingIcon != $"" ? lootRef.craftingIcon : lootRef.hudIcon
		RuiSetImage( rui, "icon", hudIcon )
		printt("CRAFTING LOOT ICON : " + lootRef.hudIcon)
		RuiSetInt( rui, "tier", lootRef.tier )

			if ( lootRef.ref == "hopup_golden_horse_green" )
			{
				RuiSetInt( rui, "tier", GOLDEN_HORSE_SPECIAL_EVENT_LOOT_TIER )
			}


		if ( lootRef.lootType == eLootType.MAINWEAPON )
			RuiSetBool( rui, "isWeapon", true )
		else if ( lootRef.lootType == eLootType.AMMO && validItemList.len() > 1 && validItemList[1] != "" )
		{
			LootData lootRefAlt = SURVIVAL_Loot_GetLootDataByRef( validItemList[1] )
			RuiSetBool( rui, "isAmmo", true )
			RuiSetImage( rui, "altIcon", lootRefAlt.hudIcon )
			if ( lootRef.ref == BULLET_AMMO || lootRef.ref == HIGHCAL_AMMO || lootRef.ref == SPECIAL_AMMO )
			{
				RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * CRAFTING_AMMO_MULTIPLIER )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * Crafting_DispenserAmmoMulitplier() )
				}
			}

			if ( lootRefAlt.ref == BULLET_AMMO || lootRefAlt.ref == HIGHCAL_AMMO || lootRefAlt.ref == SPECIAL_AMMO )
			{
				RuiSetInt( rui, "ammoAmountAlt", lootRefAlt.countPerDrop * CRAFTING_AMMO_MULTIPLIER )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmountAlt", lootRefAlt.countPerDrop * Crafting_DispenserAmmoMulitplier() )
				}
			}

			if ( lootRef.ref == SHOTGUN_AMMO || lootRef.ref == ARROWS_AMMO || lootRef.ref == SNIPER_AMMO )
			{
				RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * CRAFTING_AMMO_MULTIPLIER_SMALL )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * Crafting_DispenserAmmoMulitplierSmall() )
				}
			}

			if ( lootRefAlt.ref == SHOTGUN_AMMO || lootRefAlt.ref == ARROWS_AMMO || lootRefAlt.ref == SNIPER_AMMO )
			{
				RuiSetInt( rui, "ammoAmountAlt", lootRefAlt.countPerDrop * CRAFTING_AMMO_MULTIPLIER_SMALL )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmountAlt", lootRefAlt.countPerDrop * Crafting_DispenserAmmoMulitplierSmall() )
				}
			}
		}
		else if ( lootRef.lootType == eLootType.AMMO )
		{
			if ( lootRef.ref == BULLET_AMMO || lootRef.ref == HIGHCAL_AMMO || lootRef.ref == SPECIAL_AMMO )
			{
				RuiSetBool( rui, "isAmmo", true )
				RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * CRAFTING_AMMO_MULTIPLIER )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * Crafting_DispenserAmmoMulitplier() )
				}
			}

			if ( lootRef.ref == SHOTGUN_AMMO || lootRef.ref == ARROWS_AMMO || lootRef.ref == SNIPER_AMMO )
			{
				RuiSetBool( rui, "isAmmo", true )
				RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * CRAFTING_AMMO_MULTIPLIER_SMALL )
				if ( Crafting_IsDispenserCraftingEnabled() )
				{
					RuiSetInt( rui, "ammoAmount", lootRef.countPerDrop * Crafting_DispenserAmmoMulitplierSmall() )
				}
			}
		}
	}
	else if ( validItemList.len() != 0 && item.category == "evo" )
	{
		cost = item.itemToCostTable[validItemList[0]]
		RuiSetImage( rui, "icon", $"rui/hud/gametype_icons/survival/crafting_evo_points" )
		RuiSetBool( rui, "isWeapon", true )

		LootData existingArmorData = EquipmentSlot_GetEquippedLootDataForSlot( GetLocalViewPlayer(), "armor" )
		if ( existingArmorData.ref.find( "evolving" ) == -1 )
		{
			canBuy = false
		}
		else
		{
			if ( existingArmorData.tier >= 5 )
				canBuy = false
		}
	}

		else if ( validItemList.len() != 0 && item.category == "banner" && ( GetRespawnStyle() == eRespawnStyle.RESPAWN_CHAMBERS ) && Player_Banners_Enabled() )
		{
			cost = item.itemToCostTable[validItemList[0]]
			RuiSetImage( rui, "icon", $"rui/hud/gametype_icons/survival/perk_craftable_banner_double_generic" )
			RuiSetBool( rui, "isWeapon", false )

			if ( Perk_CanBuyBanners( GetLocalViewPlayer() ) )
			{
				canBuy = true
			}
			else
			{
				canBuy = false
			}
		}











	else if ( item.category == "mode_objectivebr" )
	{
		canBuy = GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_OBJECTIVE_BR )
	}

	else
	{
		canBuy = false
	}

	RuiSetInt( rui, "cost", cost )
	RuiSetString( rui, "rotationStyle", GetEnumString( "eCraftingRotationStyle", item.rotationStyle ) )

	bool canAfford = Crafting_GetPlayerCraftingMaterials( GetLocalViewPlayer() ) >= cost
	RuiSetBool( rui, "isEnabled", canBuy && canAfford )

	
	if ( Crafting_IsDispenserCraftingEnabled() )
		RuiSetBool( rui, "isCrafting2pt0", true )

	CraftingBundle bundle = GetBundleForCategory( item )
	bundle.attachedRui[index] <- rui

	Add_CraftingItem_To_ClientList( index, rui, cost, canBuy, canAfford )
}


void function Add_CraftingItem_To_ClientList( int index, var rui, int cost, bool canBuy, bool canAfford )
{
	int playerMaterials = Crafting_GetPlayerCraftingMaterials( GetLocalViewPlayer() )

	
	foreach( itemInfo in file.craftingItems_ClientList )
	{
		if( itemInfo.index == index )
		{
			itemInfo.rui = rui
			itemInfo.cost = cost
			itemInfo.canBuy = canBuy
			itemInfo.canAfford = playerMaterials >= cost
			return
		}
	}

	CraftingItemInfo newItem
	newItem.index = index
	newItem.rui = rui
	newItem.cost = cost
	newItem.canBuy = canBuy
	newItem.canAfford = playerMaterials >= cost

	file.craftingItems_ClientList.append( newItem )
}


void function Update_CraftingItems_Availabilities()
{
	int playerMaterials = Crafting_GetPlayerCraftingMaterials( GetLocalViewPlayer() )

	foreach( item in file.craftingItems_ClientList )
	{
		if( IsValid( item.rui ) )
		{
			bool newCanAfford = playerMaterials >= item.cost
			

			item.canAfford = newCanAfford
			RuiSetBool( item.rui, "isEnabled", item.canBuy && item.canAfford )
		}
	}
}

void function ServertoClientCallback_SetDispenserData( entity player, entity bench, entity cluster, entity minimapObj, bool isBanner, bool hasUsed )
{
	if ( !IsValid( player ) || !IsValid( bench ) || !IsValid( cluster ) || !IsValid( minimapObj ) )
		return

	WorkbenchData dispensorData = file.workbenchDataTable_Client[ bench ]
	dispensorData.workbench = bench
	if ( isBanner && ( Perks_GetRoleForPlayer( player ) == eCharacterClassRole.SUPPORT ) && Crafting_DispenserFreeSupportBanner() )
	{
		
	}
	else if ( !hasUsed )
	{
		dispensorData.playersHaveUsed.clear()
		file.workbenchDataTable_Client[ bench ] <- dispensorData
		if ( player == GetLocalViewPlayer() )
		{
			thread PlayClientSideWorkbenchHologramFX( cluster )
			ResetDispenserIcons( cluster, minimapObj )
			thread DisplayDelayedReactivationMessage( player )
		}
	}
	else
	{
		dispensorData.playersHaveUsed[ player ] <- hasUsed
		file.workbenchDataTable_Client[ bench ] <- dispensorData
		if ( player == GetLocalViewPlayer() )
		{
			cluster.Signal( "OnPlayerUsedDispenser")
			SetDispenserIconsAsUsed( cluster, minimapObj )
		}
	}
}

void function SetDispenserIconsAsUsed( entity dispenser, entity minimapObj )
{
	if ( !IsValid( minimapObj ) || !(minimapObj in file.dispenserMapRuiTable) )
		return

	RuiSetFloat3( file.dispenserMapRuiTable[minimapObj], "iconColor", GetCraftingColor() )
	RuiSetFloat3( file.dispenserMinimapRuiTable[minimapObj], "iconColor", GetCraftingColor() )

	RuiSetImage( file.dispenserMapRuiTable[minimapObj], "defaultIcon", $"" )
	RuiSetImage( file.dispenserMinimapRuiTable[minimapObj], "defaultIcon", $"" )

	RuiSetImage( file.dispenserMapRuiTable[minimapObj], "smallIcon", $"" )
	RuiSetImage( file.dispenserMinimapRuiTable[minimapObj], "smallIcon", $"" )
}

void function ResetDispenserIcons( entity dispenser, entity minimapObj )
{
	if ( !IsValid( minimapObj ) || !(minimapObj in file.dispenserMapRuiTable) )
		return

	RuiSetFloat3( file.dispenserMapRuiTable[minimapObj], "iconColor", GetCraftingColor() )
	RuiSetFloat3( file.dispenserMinimapRuiTable[minimapObj], "iconColor", GetCraftingColor() )

	bool isAirdrop = dispenser.GetModelName() == WORKBENCH_CLUSTER_AIRDROP_MODEL

	RuiSetImage( file.dispenserMapRuiTable[minimapObj], "defaultIcon", Crafting_GetCraftingIcon( isAirdrop ) )
	RuiSetImage( file.dispenserMinimapRuiTable[minimapObj], "defaultIcon", Crafting_GetCraftingIcon( isAirdrop ) )

	if ( !isAirdrop )
	{
		RuiSetImage( file.dispenserMapRuiTable[minimapObj], "smallIcon", Crafting_GetSmallCraftingIcon() )
		RuiSetImage( file.dispenserMinimapRuiTable[minimapObj], "smallIcon", Crafting_GetSmallCraftingIcon() )

		RuiSetBool( file.dispenserMapRuiTable[minimapObj], "hasSmallIcon", true )
		RuiSetBool( file.dispenserMinimapRuiTable[minimapObj], "hasSmallIcon", true )
	}
}

void function DisplayDelayedReactivationMessage( entity player )
{
	wait 8.5

	if( GetLocalViewPlayer() == player )
	{
		AnnouncementMessageSweep( GetLocalViewPlayer(),  "#DISPENSER_REACTIVATED_ANNOUNCEMENT" , "", GetCraftingColor(), $"", SFX_HUD_ANNOUNCE_QUICK, 3.0 )
	}
}

void function PlayClientSideWorkbenchHologramFX( entity workbench )
{
	if ( !IsValid( workbench ) )
		return

	workbench.Signal( "OnNewHoloStartPlaying" ) 

	workbench.EndSignal( "OnDestroy" )
	workbench.EndSignal ( "OnPlayerUsedDispenser" )
	workbench.EndSignal ( "OnNewHoloStartPlaying" )

	int attachId = workbench.LookupAttachment( "FX_LIGHT" )
	int holoFx = StartParticleEffectOnEntityWithPos( workbench, GetParticleSystemIndex( WORKBENCH_DISPENSER_HOLO_COLOR_FX ), FX_PATTACH_POINT_FOLLOW_NOROTATE, attachId, <0, 0, 0>, <-90, 0, 0> )
	EffectSetControlPointVector( holoFx, 1, WORKBENCH_DISPENSER_VFX_COLOR )







	OnThreadEnd(
		function() : ( holoFx )
		{
			if ( EffectDoesExist( holoFx ) )
			{
				EffectStop( holoFx, false, true )
			}
		}
	)

	WaitForever()
}












































bool function Crafting_IsPlayerCrafting()
{
	return file.playerIsCrafting
}
























































































































































































































































































































































entity function GetCrafterUnderAim( vector worldPos, float worldRange )
{
	float closestDistSqr        = FLT_MAX
	float worldRangeSqr = worldRange * worldRange
	entity closestEnt = null

	if( MapPing_Modify_DistanceCheck_Enabled() )
	{
		float modifier = MapPing_DistanceCheck_GetModifier()

		if( worldRange >= MapPing_DistanceCheck_GetDistanceRange() )
			modifier *= 0.5

		worldRangeSqr = ( worldRange * modifier ) * ( worldRange * modifier )
	}

	foreach ( crafter in file.workbenchClusterArray )
	{
		if ( !IsValid( crafter ) )
			continue

		vector crafterOrigin = crafter.GetOrigin()

		float distSqr = Distance2DSqr( crafterOrigin, worldPos )
		if ( distSqr < worldRangeSqr && distSqr < closestDistSqr  )
		{
			closestDistSqr = distSqr
			closestEnt     = crafter
		}
	}

	if ( !IsValid( closestEnt ) )
	{
		return null
	}

	return closestEnt
}

bool function PingCrafterUnderAim( entity crafter )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) || !IsAlive( player ) )
		return false

	if ( !IsPingEnabledForPlayer( player ) )
		return false

	Remote_ServerCallFunction( FUNCNAME_PingCrafterFromMap, crafter )

	EmitSoundOnEntity( GetLocalViewPlayer(), PING_SOUND_LOCAL_CONFIRM )

	return true
}






































