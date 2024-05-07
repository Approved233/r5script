global function ShArtifacts_LevelInit

global function RegisterArtifactComponentsForWeapon
global function Artifacts_GetConfigurationFramework
global function Artifacts_GetAssociatedWeaponForComponent
global function Artifacts_GetComponentType
global function Artifacts_GetSetKey
global function Artifacts_GetSetIndex
global function Artifacts_GetComponentChangeGUID
global function Artifacts_IsEmptyComponent
global function Artifacts_GetComponentIcon
global function Artifacts_GetComponentMainColor
global function Artifacts_GetComponentSecondaryColor
global function Artifacts_IsItemFlavorArtifact








global function Artifacts_Loadouts_GetMeleeSkinNetVarOverrideType
global function Artifacts_Loadouts_IsAnyArtifactUnlocked
global function Artifacts_Loadouts_GetConfigIndex
global function Artifacts_Loadouts_GetEntryForConfigIndexAndType
global function Artifacts_Loadouts_IsConfigPointerItemFlavor
global function Artifacts_Loadouts_IsConfigPointerGUID
global function Artifacts_Loadouts_GetEquippedTier
global function Artifacts_Loadouts_CheckAndFixMisconfigurations
global function Artifacts_Loadouts_ComponentChangeSlot






















































global function Artifacts_GetSetUIData
global function Artifacts_GetSetNameLocalized
global function Artifacts_GetSets
global function Artifacts_GetSetIndexOrdered
global function Artifacts_GetIndexOrder
global function Artifacts_GetComponentOrder
global function Artifacts_GetSetItemsOrdered
global function Artifacts_HasPreviousItem
global function Artifacts_PreviewSet
global function Artifacts_GetEquippedSet
global function Artifacts_GetCustomizationSetIndex



global function Artifacts_GetSetItems
global function Artifacts_IsBaseArtifact
global function Artifacts_IsBaseArtifactOwned
global function Artifacts_ActivationEmote_GetVideo


#if DEV

global function Artifacts_DEV_RequestEquipSetByIndex














#endif

global enum eArtifactComponentType {
	BLADE,
	THEME,
	POWER_SOURCE,
	DEATHBOX,
	ACTIVATION_EMOTE,

	COUNT,
}

global enum eArtifactConfigurationType {
	SKIN_ONLY,
	COMPONENT,

	COUNT,
}

global enum eArtifactFXPackageType {
	INVALID = -1,
	ATTACK,
	IDLE,
	STARTUP,
	FLOURISH,
	INSPECT,
	LOBBY,

	COUNT,
	
	
	BLADE_EMISSIVE,
}























global struct ArtifactConfig
{
	ItemFlavor& character
	ItemFlavor& powerSource
	ItemFlavor& theme
	ItemFlavor& blade
	ItemFlavor& deathbox
	ItemFlavor& activationEmote
}

struct ArtifactThemeModelData
{
	asset worldModel
	asset viewModel
}


global struct ArtifactThemeUIData
{
	string name
	string imageRef
}


struct FileStruct_LifetimeLevel
{
	ItemFlavor& artifactWeapon 

	array< ItemFlavor > allComponents
	array< array< ItemFlavor > > componentListsByType 

	array< array< LoadoutEntry > > loadoutConfigurationEntriesByIndexAndType
	table< LoadoutEntry, int > loadoutConfigurationSlotsToIndices

	LoadoutEntry& componentChangeSlot

	
	table< int, array< ItemFlavor > > componentSets 
	table< int, ArtifactThemeModelData > setModels 


	table < int, ArtifactThemeUIData > setUIData 










}
FileStruct_LifetimeLevel& fileLevel

global const string ARTIFACT_DAGGER_MP_WEAPON = "mp_weapon_artifact_dagger_primary"
global const string ARTIFACT_DAGGER_MELEE_WEAPON = "melee_artifact_dagger"

global const int ARTIFACT_FX_HANDLE_INVALID = -1
global const string ARTIFACT_POWER_SOURCE_MODIFIER_SUFFIX = "_ps"

global const int ARTIFACT_CONFIGURATION_PTR_0_GUID = 1182724979

const int ARTIFACT_DAGGER_ITEM_FLAVOR_GUID = 2113589622

const float DEACTIVATED_EMISSIVE_FACTOR = 0.15
const float ACTIVATION_EMOTE_ANIM_TIME_RESTART_LIMIT = 2.0 

const string WORLD_MODEL = "worldModel"
const string VIEW_MODEL = "viewModel"
const string SET_NAME = "setName"
const string SET_IMAGE_REF = "setImageRef"

const string BASE_WEAPON = "base_weapon"
const table< int, string > ARTIFACT_COMPONENTS_TO_LOADOUT_NAMES_MAP = {
	[eArtifactComponentType.BLADE] = "blade",
	[eArtifactComponentType.THEME] = "theme",
	[eArtifactComponentType.POWER_SOURCE] = "power_source",
	[eArtifactComponentType.DEATHBOX] = "deathbox",
	[eArtifactComponentType.ACTIVATION_EMOTE] = "activation_emote",
}


const string EMPTY = "_EMPTY"
const string RAGOLD = "RAGOLD"
global enum eArtifactSetIndex { 
	
	
	RAGOLD = -2,
	_EMPTY = -1, 

	CELES = 0,
	DEATH = 1,
	HISOC = 2,

	MOB = 3,

	STEAM = 4,
	STECH = 5,

	COUNT = 6 
}

const int LOADOUT_MELEE_SKIN_ITEM_TYPE_OVERRIDE = eItemType.artifact_component_blade
const int LOADOUT_MELEE_SKIN_COMPONENT_TYPE_OVERRIDE = eArtifactComponentType.BLADE
const int ULTIMATE_SET_INDEX = eArtifactSetIndex.CELES
const int BASE_SET_INDEX = eArtifactSetIndex.MOB 

const string BLADE_KEY = "blade"
const string THEME_KEY = "theme"
const string POWER_SOURCE_KEY = "powerSource"
const string DEATHBOX_KEY = "deathbox"
const string ACTIVATION_EMOTE_KEY = "activationEmote"
global const table<string, int> ARTIFACT_COMPONENT_SETTINGS_KEYS = {
	[BLADE_KEY] = eArtifactComponentType.BLADE,
	[THEME_KEY] = eArtifactComponentType.THEME,
	[POWER_SOURCE_KEY] = eArtifactComponentType.POWER_SOURCE,
	[DEATHBOX_KEY] = eArtifactComponentType.DEATHBOX,
	[ACTIVATION_EMOTE_KEY] = eArtifactComponentType.ACTIVATION_EMOTE,
}


const array<int> ARTIFACT_SET_ORDER = [
	eArtifactSetIndex.MOB,
	eArtifactSetIndex.CELES,
	eArtifactSetIndex.DEATH,
	eArtifactSetIndex.HISOC,
	eArtifactSetIndex.STEAM,
	eArtifactSetIndex.STECH,
]

global array<int> ARTIFACT_CUSTOMIZATION_SET_ORDER = [
	eArtifactSetIndex.MOB,
	eArtifactSetIndex.STECH,
	eArtifactSetIndex.HISOC,
	eArtifactSetIndex.STEAM,
	eArtifactSetIndex.DEATH,
	eArtifactSetIndex.CELES,
	eArtifactSetIndex.RAGOLD,
	eArtifactSetIndex._EMPTY,
]

const table< int, int > ARTIFACT_COMPONENT_ORDER = {
	[eArtifactComponentType.BLADE] = 0,
	[eArtifactComponentType.THEME] = 1,
	[eArtifactComponentType.POWER_SOURCE] = 2,
	[eArtifactComponentType.ACTIVATION_EMOTE] = 3,
	[eArtifactComponentType.DEATHBOX] = 4,
}


const int ARTIFACT_MAX_LOADOUTS = 3
const string ONE_P = "1P"
const string THREE_P = "3P"
const int BODY_GROUP_INVALID = -1

const int THEME_BASE = 1 
const int THEME_SHINY = 2 

const float VFX_FLOURISH_3P_START_DELAY = 1.0 
const float VFX_FLOURISH_ANIM_DURATION = 3.2 
global const string VFX_SIGNAL = "ArtifactsFxSignal"


const string LOADOUTS_ARTIFACT_INDEX_COMPONENT_TYPE = "artifact_%d_component_%s"
const string LOADOUTS_ARTIFACT_COMPONENT_CHANGE = "artifact_configuration_component_change"
#if DEV
const string LOADOUTS_DEV_ARTIFACT_COMPONENT_CHANGE_VERBOSE_PDEF_SECTION_KEY = "artifact configuration component change"
const string LOADOUTS_DEV_ARTIFACT_COMPONENT_CHANGE_VERBOSE = "Artifact Configuration Componenent Change"
const string LOADOUTS_DEV_ARTIFACT_CONFIGURATION_PDEF_SECTION_KEY = "artifact configuration %d"
const string LOADOUTS_DEV_ARTIFACT_CONFIGURATION_VERBOSE = "Artifact Configuration %d"
#endif


const string COMPONENT_TYPE_SETTINGS_BLOCK_KEY = "artifactComponentType"
const string CONFIGURATION_TYPE_SETTINGS_BLOCK_KEY = "configurationFramework"
const string CONFIG_POINTER_INDEX_KEY = "artifactConfigIndex"
const string IS_CONFIG_POINTER_KEY = "isArtifactConfigPointer"
const string IS_EMPTY = "isEmpty" 
const string THEME_NAME = "themeName" 
const string COMPONENT_SETS = "componentSets"
const string SET_ASSET = "set"
const string BLADE_BODY_GROUP_MOD_PREFIX = "blade" 
const string POWER_SOURCE_BODY_GROUP_MOD_PREFIX = "power" 

const string SCRIPT_ANIM_WINDOW_FX = "scriptAnimWindowFXControls"
const string SCRIPT_ANIM_WINDOW_PARAMETER = "parameter"
const string SCRIPT_ANIM_WINDOW_SET_FX = "setSpecificFX"
const string SCRIPT_ANIM_WINDOW_UNIVERSAL = "UNIVERSAL" 
const string SCRIPT_ANIM_WINDOW_FX_PACKAGE_TYPE = "fxPackageType"
const string SCRIPT_ANIM_WINDOW_ACTION = "action"
const string SCRIPT_ANIM_WINDOW_STOP = "STOP"
const string SCRIPT_ANIM_WINDOW_START = "START"

const string DEATHBOX_FX_NAME_KEY = "artifactDeathboxFXName"
const string DEATHBOX_MDL_REF_KEY = "artifactDeathboxModel"
const string DEATHBOX_SFX_SPAWN_KEY = "spawnSFX"

const string FX_SMEAR_COLOR = "smearColor"
const string FX_SKIN_INDEX = "skinIdx"
const string FX_ASSET = "fxAsset"
const string FX_ATTACH = "attachName"
const string FX_PERSPECTIVE = "perspective"
const array<string> FX_FIELDS = [
	FX_ASSET,
	FX_ATTACH,
	FX_PERSPECTIVE,
]
const string FX_PACKAGE_FLOURISH = "flourishFX"
const string FX_PACKAGE_ATTACK = "attackFX"
const string FX_PACKAGE_IDLE = "idleFX"
const string FX_PACKAGE_STARTUP = "startupFX"
const string FX_PACKAGE_INSPECT = "inspectFX"
const string FX_PACKAGE_LOBBY = "lobbyFX"
const array<string> FX_PACKAGES = [
	FX_PACKAGE_FLOURISH,
	FX_PACKAGE_ATTACK,
	FX_PACKAGE_IDLE,
	FX_PACKAGE_STARTUP,
	FX_PACKAGE_INSPECT,
	FX_PACKAGE_LOBBY,
]

const string FX_CONTROL_POINT_LIST = "fxControlPoints"
const string FX_CONTROL_POINT_LIST_LOBBY = "lobbyFxControlPoints"
const string FX_CONTROL_POINT = "controlPoint"
const string FX_CONTROL_POINT_NUMBER = "controlPointNumber"
const string FX_CONTROL_POINT_NAME = "controlPointName"
const array<string> FX_CONTROL_POINT_PROPERTIES = [
	FX_CONTROL_POINT,
	FX_CONTROL_POINT_NUMBER,
	FX_CONTROL_POINT_NAME,
]
const vector FX_NULL_CAP_EMISSIVE = <0, 0, 0>



const asset VFX_TEST_DEATHBOX_PARTICLE = $"P_death_box_mob_kill_fx"
const asset VFX_TEST_IDLE = $"P_car_reac_spinners_lvl4"

const asset VFX_MOB_STARTUP_1P = $"P_art_MOB_power_start_FP"
const asset VFX_MOB_STARTUP_3P = $"P_art_MOB_power_start_3P"
const asset VFX_MOB_IDLE_1P = $"P_art_MOB_power_idle_FP"
const asset VFX_MOB_IDLE_3P = $"P_art_MOB_power_idle_3P"
const asset VFX_MOB_IDLE_BLADE_1P = $"P_art_MOB_blade_idle_FP"
const asset VFX_MOB_IDLE_BLADE_3P = $"P_art_MOB_blade_idle_3P"
const asset VFX_MOB_ATTACK_1P = $"P_art_MOB_blade_attack_FP"
const asset VFX_MOB_ATTACK_1P_CP = $"P_art_MOB_blade_attack_FP_CP"
const asset VFX_MOB_ATTACK_3P = $"P_art_MOB_blade_attack_3P"
const asset VFX_MOB_FLOURISH_1P = $"P_art_MOB_blade_flourish_FP"
const asset VFX_MOB_FLOURISH_3P = $"P_art_MOB_blade_flourish_3P"
const asset VFX_MOB_LOBBY_BLADE = $"P_art_MOB_blade_idle_Menu_CP" 
const asset VFX_MOB_INSPECT_1P = $"P_art_MOB_power_inspect_FP"
const asset VFX_MOB_LOBBY_POWER_SOURCE = $"P_art_MOB_power_idle_Menu"

const asset VFX_celes_STARTUP_1P = $"P_art_celes_power_start_FP"
const asset VFX_celes_STARTUP_3P = $"P_art_celes_power_start_3P"
const asset VFX_celes_IDLE_1P = $"P_art_celes_power_idle_FP"
const asset VFX_celes_IDLE_3P = $"P_art_celes_power_idle_3P"
const asset VFX_celes_IDLE_BLADE_1P = $"P_art_celes_blade_idle_FP"
const asset VFX_celes_IDLE_BLADE_3P = $"P_art_celes_blade_idle_3P"
const asset VFX_celes_ATTACK_1P = $"P_art_celes_power_attack_FP"
const asset VFX_celes_ATTACK_3P = $"P_art_celes_power_attack_3P"
const asset VFX_celes_ATTACK_BLADE_1P = $"P_art_celes_blade_attack_FP"
const asset VFX_celes_ATTACK_BLADE_3P = $"P_art_celes_blade_attack_3P"
const asset VFX_celes_FLOURISH_1P = $"P_art_celes_blade_flourish_FP"
const asset VFX_celes_FLOURISH_3P = $"P_art_celes_blade_flourish_3P"
const asset VFX_celes_INSPECT_1P = $"P_art_celes_power_inspect_FP"
const asset VFX_celes_DEATHBOX = $"P_death_box_artifact_celes"

const asset VFX_death_STARTUP_1P = $"P_art_death_power_start_FP"
const asset VFX_death_STARTUP_3P = $"P_art_death_power_start_3P"
const asset VFX_death_IDLE_1P = $"P_art_death_power_idle_FP"
const asset VFX_death_IDLE_3P = $"P_art_death_power_idle_3P"
const asset VFX_death_IDLE_BLADE_1P = $"P_art_death_blade_idle_FP"
const asset VFX_death_IDLE_BLADE_3P = $"P_art_death_blade_idle_3P"
const asset VFX_death_ATTACK_1P = $"P_art_death_blade_attack_FP"
const asset VFX_death_ATTACK_3P = $"P_art_death_blade_attack_3P"
const asset VFX_death_FLOURISH_1P = $"P_art_death_blade_flourish_FP"
const asset VFX_death_FLOURISH_3P = $"P_art_death_blade_flourish_3P"
const asset VFX_death_INSPECT_1P = $"P_art_death_power_idle_FP"
const asset VFX_death_DEATHBOX = $"P_death_box_artifact_death_mdl"

const asset VFX_hisoc_STARTUP_1P = $"P_art_hisoc_power_start_FP"
const asset VFX_hisoc_STARTUP_3P = $"P_art_hisoc_power_start_3P"
const asset VFX_hisoc_IDLE_1P = $"P_art_hisoc_power_idle_FP"
const asset VFX_hisoc_IDLE_3P = $"P_art_hisoc_power_idle_3P"
const asset VFX_hisoc_IDLE_BLADE_1P = $"P_art_hisoc_blade_idle_FP"
const asset VFX_hisoc_IDLE_BLADE_3P = $"P_art_hisoc_blade_idle_3P"
const asset VFX_hisoc_ATTACK_1P = $"P_art_hisoc_blade_attack_FP"
const asset VFX_hisoc_ATTACK_3P = $"P_art_hisoc_blade_attack_3P"
const asset VFX_hisoc_FLOURISH_1P = $"P_art_hisoc_blade_flourish_FP"
const asset VFX_hisoc_FLOURISH_3P = $"P_art_hisoc_blade_flourish_3P"
const asset VFX_hisoc_INSPECT_1P = $"P_art_hisoc_power_inspect_FP"

const asset VFX_steam_STARTUP_1P = $"P_art_steam_power_start_FP"
const asset VFX_steam_STARTUP_3P = $"P_art_steam_power_start_3P"
const asset VFX_steam_IDLE_1P = $"P_art_steam_power_idle_FP"
const asset VFX_steam_IDLE_3P = $"P_art_steam_power_idle_3P"
const asset VFX_steam_IDLE_BLADE_1P = $"P_art_steam_blade_idle_FP"
const asset VFX_steam_IDLE_BLADE_3P = $"P_art_steam_blade_idle_3P"
const asset VFX_steam_ATTACK_1P = $"P_art_steam_blade_attack_FP"
const asset VFX_steam_ATTACK_3P = $"P_art_steam_blade_attack_3P"
const asset VFX_steam_FLOURISH_1P = $"P_art_steam_blade_flourish_FP"
const asset VFX_steam_FLOURISH_3P = $"P_art_steam_blade_flourish_3P"
const asset VFX_steam_INSPECT_1P = $"P_art_steam_power_inspect_FP"

const asset VFX_stech_STARTUP_1P = $"P_art_stech_power_start_FP"
const asset VFX_stech_STARTUP_3P = $"P_art_stech_power_start_3P"
const asset VFX_stech_IDLE_1P = $"P_art_stech_power_idle_FP"
const asset VFX_stech_IDLE_3P = $"P_art_stech_power_idle_3P"
const asset VFX_stech_IDLE_BLADE_1P = $"P_art_stech_blade_idle_FP"
const asset VFX_stech_IDLE_BLADE_3P = $"P_art_stech_blade_idle_3P"
const asset VFX_stech_ATTACK_1P = $"P_art_stech_blade_attack_FP"
const asset VFX_stech_ATTACK_3P = $"P_art_stech_blade_attack_3P"
const asset VFX_stech_FLOURISH_1P = $"P_art_stech_blade_flourish_FP"
const asset VFX_stech_FLOURISH_3P = $"P_art_stech_blade_flourish_3P"
const asset VFX_stech_INSPECT_1P = $"P_art_stech_power_inspect_FP"

const asset VFX_MOB_IDLE_BLADE_1P_NO_CP = $"P_art_MOB_blade_idle_FP"
const asset VFX_MOB_IDLE_BLADE_1P_CP = $"P_art_MOB_blade_idle_FP_CP"





void function ShArtifacts_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	
	AddCallback_OnPreAllItemFlavorsRegistered( OnAllItemFlavorsRegistered_Artifact_Weapon )

	











	RegisterSignal( VFX_SIGNAL )
}

void function RegisterArtifactComponentsForWeapon( ItemFlavor artifactWeapon )
{
#if DEV
		printf( "ArtifactsDebug: %s", FUNC_NAME() )
#endif

	Assert( !IsValidItemFlavorGUID( fileLevel.artifactWeapon.guid ) )
	fileLevel.artifactWeapon = artifactWeapon

	fileLevel.componentListsByType.clear()
	fileLevel.componentListsByType.resize( eArtifactComponentType.COUNT )

	var settingsBlock = ItemFlavor_GetSettingsBlock( artifactWeapon )
	foreach ( var componentBlock in IterateSettingsArray( GetSettingsBlockArray( settingsBlock, COMPONENT_SETS ) ) )
	{
		asset componentSet                  = GetSettingsBlockAsset( componentBlock, SET_ASSET )
		string currentTheme                 = ""
		array< ItemFlavor > componentsInSet = []
		componentsInSet.resize( eArtifactComponentType.COUNT )

		string setTheme = GetGlobalSettingsString( componentSet, THEME_NAME )




























		{
			bool isSpecialSet = ( setTheme == EMPTY || setTheme == RAGOLD )
			Assert( setTheme in eArtifactSetIndex )

			string setName = GetGlobalSettingsString( componentSet, SET_NAME )
			string setImageRef  = isSpecialSet ? "" : GetGlobalSettingsString( componentSet, SET_IMAGE_REF )

			ArtifactThemeUIData uiData
			uiData.name = setName
			uiData.imageRef = setImageRef

			fileLevel.setUIData[ eArtifactSetIndex[ setTheme ] ] <- uiData
		}


		foreach ( string componentKey, int componentType in ARTIFACT_COMPONENT_SETTINGS_KEYS )
		{
			asset settingsAsset = GetGlobalSettingsAsset( componentSet, componentKey )
			if ( settingsAsset != $"" )
			{
				ItemFlavor ornull component = RegisterItemFlavorFromSettingsAsset( settingsAsset )
				if ( component != null )
				{
					expect ItemFlavor( component )
					fileLevel.componentListsByType[ Artifacts_GetComponentType( component ) ].append( component )
					Assert( !fileLevel.allComponents.contains( component ) )
					fileLevel.allComponents.append( component )
					Assert( componentType == Artifacts_GetComponentType( component ) )
					componentsInSet[ Artifacts_GetComponentType( component ) ] = component













					string themeName = Artifacts_GetSetKey( component )
					Assert( currentTheme == "" || themeName == currentTheme )
					currentTheme = themeName

#if DEV
















#endif
				}
			}
			else
			{
				Assert( setTheme == RAGOLD )
				ItemFlavor invalidComponent
				componentsInSet[ componentType ] = invalidComponent
			}
		}

		fileLevel.componentSets[ eArtifactSetIndex[ currentTheme ] ] <- componentsInSet
	}

}

void function OnAllItemFlavorsRegistered_Artifact_Weapon()
{
	BuildLoadoutEntries_ArtifactWeapons()
}


void function BuildLoadoutEntries_ArtifactWeapons()
{
#if DEV
		printf("ArtifactsDebug: %s", FUNC_NAME() )
#endif

	fileLevel.loadoutConfigurationEntriesByIndexAndType.clear()
	for ( int artifactIdx = 0; artifactIdx < ARTIFACT_MAX_LOADOUTS; artifactIdx++ )
	{
		fileLevel.loadoutConfigurationEntriesByIndexAndType.append( [] )
		for ( int componentCounter = 0; componentCounter < eArtifactComponentType.COUNT; componentCounter++ )
		{
			if ( fileLevel.componentListsByType[ componentCounter ].len() == 0 )
				continue 

#if DEV
				printf( "ArtifactsDebug: %s - %s", FUNC_NAME(), ARTIFACT_COMPONENTS_TO_LOADOUT_NAMES_MAP[ componentCounter ] )
#endif

			LoadoutEntry componentEntry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, format( LOADOUTS_ARTIFACT_INDEX_COMPONENT_TYPE, artifactIdx, ARTIFACT_COMPONENTS_TO_LOADOUT_NAMES_MAP[ componentCounter ] ), eLoadoutEntryClass.ACCOUNT )
			componentEntry.category = eLoadoutCategory.ARTIFACT_CONFIGURATIONS
#if DEV
				componentEntry.pdefSectionKey = format( LOADOUTS_DEV_ARTIFACT_CONFIGURATION_PDEF_SECTION_KEY, artifactIdx )
				componentEntry.DEV_name = format( LOADOUTS_DEV_ARTIFACT_CONFIGURATION_VERBOSE, artifactIdx )
#endif

			componentEntry.defaultItemFlavor   = fileLevel.componentSets[ eArtifactSetIndex._EMPTY ][ componentCounter ] 
			componentEntry.validItemFlavorList = fileLevel.componentListsByType[ componentCounter ]

			componentEntry.isSlotLocked              = bool function( EHI playerEHI ) { return !IsLobby() }
			componentEntry.associatedCharacterOrNull = null
			componentEntry.networkTo                 = eLoadoutNetworking.PLAYER_EXCLUSIVE 
			componentEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.INVALID

			fileLevel.loadoutConfigurationEntriesByIndexAndType[ artifactIdx ].append( componentEntry )
			fileLevel.loadoutConfigurationSlotsToIndices[ componentEntry ] <- artifactIdx
		}
	}

	
	ArtifactsCallback_AddArtifactDeathboxesToCharacterLoadouts( fileLevel.componentListsByType[ eArtifactComponentType.DEATHBOX ] )

	






	LoadoutEntry componentEntry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, LOADOUTS_ARTIFACT_COMPONENT_CHANGE, eLoadoutEntryClass.ACCOUNT )
	componentEntry.category = eLoadoutCategory.ARTIFACT_CONFIGURATIONS
#if DEV
		componentEntry.pdefSectionKey = LOADOUTS_DEV_ARTIFACT_COMPONENT_CHANGE_VERBOSE_PDEF_SECTION_KEY
		componentEntry.DEV_name = LOADOUTS_DEV_ARTIFACT_COMPONENT_CHANGE_VERBOSE
#endif
	componentEntry.defaultItemFlavor   		 = fileLevel.componentSets[ eArtifactSetIndex._EMPTY ][ eArtifactComponentType.BLADE ]
	componentEntry.validItemFlavorList 		 = fileLevel.allComponents
	componentEntry.isSlotLocked              = bool function( EHI playerEHI ) { return !IsLobby() }
	componentEntry.associatedCharacterOrNull = null
	componentEntry.networkTo                 = eLoadoutNetworking.PLAYER_EXCLUSIVE
	componentEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.INVALID
	fileLevel.componentChangeSlot = componentEntry




}






















bool function Artifacts_IsEmptyComponent( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( component ), IS_EMPTY ) )
}

asset function Artifacts_GetComponentIcon( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( component ), "componentIcon" )
}

vector function Artifacts_GetComponentMainColor( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( component ), "artifactMainColor" )
}

vector function Artifacts_GetComponentSecondaryColor( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( component ), "artifactSecondaryColor" )
}

int function Artifacts_GetConfigurationFramework( ItemFlavor weapon )
{
	Assert( ItemFlavor_GetType( weapon ) == eItemType.melee_weapon )

	var weaponBlock = ItemFlavor_GetSettingsBlock( weapon )
	string configurationName = GetSettingsBlockString( weaponBlock, CONFIGURATION_TYPE_SETTINGS_BLOCK_KEY )

	Assert ( configurationName in eArtifactConfigurationType )
	return eArtifactConfigurationType[ configurationName ]
}

int function Artifacts_GetComponentType( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )

	var componentBlock = ItemFlavor_GetSettingsBlock( component )
	string typeName = GetSettingsBlockString( componentBlock, COMPONENT_TYPE_SETTINGS_BLOCK_KEY )

	Assert ( typeName in eArtifactComponentType )
	return eArtifactComponentType[ typeName ]
}

string function Artifacts_GetSetKey( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return GetSettingsBlockString( ItemFlavor_GetSettingsBlock( component ), THEME_NAME )
}

int function Artifacts_GetSetIndex( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	string themeName = GetSettingsBlockString( ItemFlavor_GetSettingsBlock( component ), THEME_NAME )
	Assert( themeName in eArtifactSetIndex )
	return eArtifactSetIndex[ themeName ]
}

bool function Artifacts_IsItemFlavorArtifact( ItemFlavor component )
{
	return ( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
}


int function Artifacts_Loadouts_GetMeleeSkinNetVarOverrideType( bool getComponentType )
{
	return getComponentType ? LOADOUT_MELEE_SKIN_COMPONENT_TYPE_OVERRIDE : LOADOUT_MELEE_SKIN_ITEM_TYPE_OVERRIDE
}

bool function Artifacts_Loadouts_IsAnyArtifactUnlocked( EHI playerEHI, bool shouldIgnoreGRX )
{
	foreach ( ItemFlavor blade in fileLevel.componentListsByType[ eArtifactComponentType.BLADE ] )
	{
		if ( ItemFlavor_GetGRXMode( blade ) == eItemFlavorGRXMode.NONE )
			continue

		if ( IsItemFlavorGRXUnlockedForLoadoutSlot( playerEHI, blade, shouldIgnoreGRX ) )
			return true
	}

	return false
}

bool function Artifacts_Loadouts_IsConfigPointerItemFlavor( ItemFlavor flav )
{
	Assert( ItemFlavor_GetType( flav ) == eItemType.melee_skin )

	var block = ItemFlavor_GetSettingsBlock( flav )
	return GetSettingsBlockBool( block, IS_CONFIG_POINTER_KEY )
}

bool function Artifacts_Loadouts_IsConfigPointerGUID( int guid )
{
	if ( !IsValidItemFlavorGUID( guid ) )
		return false

	ItemFlavor flav = GetItemFlavorByGUID( guid )
	Assert( ItemFlavor_GetType( flav ) == eItemType.melee_skin )

	var block = ItemFlavor_GetSettingsBlock( flav )
	return GetSettingsBlockBool( block, IS_CONFIG_POINTER_KEY )
}

int function Artifacts_Loadouts_GetConfigIndex( ItemFlavor configPtr )
{
	Assert( Artifacts_Loadouts_IsConfigPointerGUID( ItemFlavor_GetGUID( configPtr ) ) )

	var block = ItemFlavor_GetSettingsBlock( configPtr )
	int configIdx = GetSettingsBlockInt( block, CONFIG_POINTER_INDEX_KEY )

	Assert( configIdx >= 0 && configIdx < ARTIFACT_MAX_LOADOUTS )

	return configIdx
}

bool function Artifacts_Loadouts_CheckAndFixMisconfigurations( EHI playerEHI, ItemFlavor character )
{
	bool isMisconfigured = false
	
	
	
	LoadoutEntry skinSlot = Loadout_MeleeSkin( character )
	ItemFlavor meleeSkin  = LoadoutSlot_GetItemFlavor( playerEHI, skinSlot )

	if ( !IsLobby() && !Artifacts_Loadouts_IsConfigPointerItemFlavor( meleeSkin ) )
		return isMisconfigured

	for ( int i = 0; i < ARTIFACT_MAX_LOADOUTS; i++ )
	{
		if ( !IsLobby() && i != Artifacts_Loadouts_GetConfigIndex( meleeSkin ) )
			continue 

		LoadoutEntry bladeSlot    = Artifacts_Loadouts_GetEntryForConfigIndexAndType( i, eArtifactComponentType.BLADE )
		ItemFlavor bladeComponent = LoadoutSlot_GetItemFlavor_ForValidation( playerEHI, bladeSlot )
#if DEV
			isMisconfigured = Artifacts_IsEmptyComponent( bladeComponent )
#else
			isMisconfigured = Artifacts_IsEmptyComponent( bladeComponent ) || !IsItemFlavorUnlockedForLoadoutSlot( playerEHI, bladeSlot, bladeComponent )
#endif

		if ( isMisconfigured && IsLobby() )
		{
			LoadoutEntry slotToSet = skinSlot
			ItemFlavor component   = skinSlot.defaultItemFlavor
			foreach ( ItemFlavor blade in bladeSlot.validItemFlavorList )
			{
				if ( Artifacts_IsEmptyComponent( blade ) )
					continue

				if ( IsItemFlavorUnlockedForLoadoutSlot( playerEHI, bladeSlot, blade ) )
				{
					slotToSet = bladeSlot
					component = blade
					break
				}
			}




				RequestSetItemFlavorLoadoutSlot( playerEHI, slotToSet, component )

		}
	}

	return isMisconfigured
}

LoadoutEntry function Artifacts_Loadouts_ComponentChangeSlot()
{
	return fileLevel.componentChangeSlot
}









































































































































































































































































































































































































int function Artifacts_Loadouts_GetConfigIndexForLoadoutSlot( LoadoutEntry slot )
{
	Assert ( slot in fileLevel.loadoutConfigurationSlotsToIndices )
	return fileLevel.loadoutConfigurationSlotsToIndices[ slot ]
}




































LoadoutEntry function Artifacts_Loadouts_GetEntryForConfigIndexAndType( int configIdx, int componentType )
{
	return fileLevel.loadoutConfigurationEntriesByIndexAndType[ configIdx ][ componentType ]
}

int function Artifacts_Loadouts_GetEquippedTier( EHI playerEHI )
{
	
	
	
	

#if DEV
		return GetConVarInt( "artifacts_tier_override" )
#endif

	return 0 
}



ItemFlavor function Artifacts_GetAssociatedWeaponForComponent( ItemFlavor component )
{
	
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( component ), "parentItemFlavor" ) )
}

































































































































































































































































































































































































































































































































































int function Artifacts_GetComponentChangeGUID( entity player )
{

	Assert( player == GetLocalClientPlayer() )


	
	ItemFlavor changedComponent = LoadoutSlot_GetItemFlavor( ToEHI( player ), fileLevel.componentChangeSlot )
	if ( Artifacts_IsEmptyComponent( changedComponent ) )
		return 0

	return ItemFlavor_GetGUID( changedComponent )
}


ArtifactThemeUIData function Artifacts_GetSetUIData( int setIndex )
{
	return fileLevel.setUIData[ setIndex ]
}

string function Artifacts_GetSetNameLocalized( ItemFlavor component )
{
	Assert( ItemFlavor_GetType( component ) > eItemType.artifact_component_START && ItemFlavor_GetType( component ) < eItemType.artifact_component_END )
	return fileLevel.setUIData[ Artifacts_GetSetIndex( component ) ].name
}

table< int, array< ItemFlavor > > function Artifacts_GetSets()
{
	return fileLevel.componentSets
}
int function Artifacts_GetSetIndexOrdered( int sortIndex )
{
	return ARTIFACT_SET_ORDER[sortIndex]
}

int function Artifacts_GetIndexOrder( int index )
{
	return ARTIFACT_COMPONENT_ORDER[index]
}

int function Artifacts_GetComponentOrder( ItemFlavor component )
{
	int componentType = Artifacts_GetComponentType( component )
	return ARTIFACT_COMPONENT_ORDER[componentType]
}

array< ItemFlavor > function Artifacts_GetSetItemsOrdered( int setIndex )
{
	array< ItemFlavor > setItemsOrdered = Artifacts_GetSetItems( setIndex )
	setItemsOrdered.sort( int function( ItemFlavor a, ItemFlavor b ) {
		int componentA = Artifacts_GetComponentOrder( a )
		int componentB = Artifacts_GetComponentOrder( b )
		if ( componentA < componentB )
			return -1
		else if ( componentA > componentB )
			return 1
		return 0
	} )

	return setItemsOrdered
}

bool function Artifacts_HasPreviousItem( ItemFlavor component )
{
	array< ItemFlavor > setItems = Artifacts_GetSetItems( Artifacts_GetSetIndex( component ) )
	int itemIndex = Artifacts_GetComponentOrder( component )

	if ( itemIndex > 0)
	{
		int previousItemIndex = itemIndex - 1
		ItemFlavor previousSetItem = setItems[previousItemIndex]
		return GRX_IsItemOwnedByPlayer( previousSetItem )
	}

	return Artifacts_IsBaseArtifact( component ) || Artifacts_IsBaseArtifactOwned()
}

void function Artifacts_PreviewSet( ItemFlavor ornull selectedMeleeSkin )
{
	if ( selectedMeleeSkin != null )
	{
		expect ItemFlavor( selectedMeleeSkin )

		if ( CanRunClientScript() )
		{
			RunClientScript( "UIToClient_PreviewMeleeSkin", ItemFlavor_GetGUID( selectedMeleeSkin ) )
		}
	}
}

array< ItemFlavor > function Artifacts_GetEquippedSet( ItemFlavor ornull configPointer )
{
	array< ItemFlavor > equippedItems = []
	if ( configPointer != null )
	{
		expect ItemFlavor( configPointer )

		LoadoutEntry entry
		ItemFlavor flav
		foreach ( string _, int type in eArtifactComponentType )
		{
			if ( type == eArtifactComponentType.COUNT )
				break

			entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( Artifacts_Loadouts_GetConfigIndex( configPointer ), type )
			flav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )
			equippedItems.push( flav )
		}
	}
	return equippedItems
}

int function Artifacts_GetCustomizationSetIndex( ItemFlavor component )
{
	return ARTIFACT_CUSTOMIZATION_SET_ORDER.find( Artifacts_GetSetIndex( component ) )
}



array< ItemFlavor > function Artifacts_GetSetItems( int setIndex )
{
	return fileLevel.componentSets[ setIndex ]
}

bool function Artifacts_IsBaseArtifact( ItemFlavor component )
{
	return ItemFlavor_GetType( component ) == eItemType.artifact_component_blade && Artifacts_GetSetIndex( component ) == eArtifactSetIndex.MOB
}

bool function Artifacts_IsBaseArtifactOwned()
{
	array< ItemFlavor > baseSet = Artifacts_GetSetItems( eArtifactSetIndex.MOB )

	if ( baseSet.len() == 0 )
		return false

	ItemFlavor baseArtifact = baseSet[0]
	return GRX_IsItemOwnedByPlayer( baseArtifact )
}

asset function Artifacts_ActivationEmote_GetVideo( ItemFlavor emote )
{
	Assert( ItemFlavor_GetType( emote ) == eItemType.artifact_component_activation_emote )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( emote ), "video" )
}


#if DEV


void function Artifacts_DEV_RequestEquipSetByIndex( LoadoutEntry meleeSkinSlot, ItemFlavor configPointer, int setIndex )
{
	EHI lcEHI = LocalClientEHI()

	LoadoutEntry entry
	ItemFlavor flav
	foreach ( string _, int type in eArtifactComponentType )
	{
		if ( type == eArtifactComponentType.COUNT )
			break

		flav  = fileLevel.componentSets[ setIndex ][ type ]
		entry = Artifacts_Loadouts_GetEntryForConfigIndexAndType( Artifacts_Loadouts_GetConfigIndex( configPointer ), type )

		DEV_RequestSetItemFlavorLoadoutSlot( lcEHI, entry, flav )
	}

	DEV_RequestSetItemFlavorLoadoutSlot( lcEHI, meleeSkinSlot, configPointer )
}


















































































































































































































































































































































#endif
