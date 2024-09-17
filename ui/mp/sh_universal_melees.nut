global function ShUniversalMelees_LevelInit


global function UniversalMelee_IsItemFlavorUniversalMelee
global function UniversalMelee_GetSetItems
global function UniversalMelee_GetSetItemIndex
global function UniversalMelee_GetNumberOfSetItems
global function UniversalMelee_GetBaseSkin
global function UniversalMelee_IsBaseSkin
global function UniversalMelee_IsBaseSkinOwned
global function UniversalMelee_HasPreviousItem
global function UniversalMelee_GetVideo
global function UniversalMelee_GetComponentMainColor
global function UniversalMelee_GetComponentSecondaryColor
global function UniversalMelee_GetTheme
global function UniversalMelee_GetSkins
global function UniversalMelee_GetAddons
global function UniversalMelee_GetDeathboxes


global enum eUniversalSetIndex {
	_EMPTY = -1,
	HOOK_SWORD = 0,








	COUNT = 2
}

struct FileStruct_LifetimeLevel
{
}

FileStruct_LifetimeLevel& fileLevel

void function ShUniversalMelees_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel
}

bool function UniversalMelee_IsItemFlavorUniversalMelee( ItemFlavor meleeSetItem )
{
	if ( !UniversalMelee_IsValidSetItemType( meleeSetItem ) )
		return false

	ItemFlavor ornull meleeWeapon = ItemFlavor_GetParentFlavor( meleeSetItem )
	if ( meleeWeapon == null )
		return false

	expect ItemFlavor( meleeWeapon )

	return MeleeWeapon_GetWeaponType( meleeWeapon ) == eMeleeWeaponType.UNIVERSAL
}

bool function UniversalMelee_IsValidSetItemType( ItemFlavor meleeSetItem )
{
	array<int> setTypes = [eItemType.melee_skin, eItemType.melee_addon, eItemType.artifact_component_deathbox ]

	return setTypes.contains( ItemFlavor_GetType( meleeSetItem ) )
}

array< ItemFlavor > function UniversalMelee_GetSetItems( ItemFlavor meleeItem )
{
	array< ItemFlavor > setItems = []

	setItems.extend( UniversalMelee_GetSkins( meleeItem ) )
	setItems.extend( UniversalMelee_GetAddons( meleeItem ) )
	setItems.extend( UniversalMelee_GetDeathboxes( meleeItem ) )

	return setItems
}

int function UniversalMelee_GetSetItemIndex( ItemFlavor meleeItem )
{
	array< ItemFlavor > setItems = UniversalMelee_GetSetItems( meleeItem )

	foreach( int index, ItemFlavor itemFlav in setItems )
	{
		if ( itemFlav == meleeItem )
			return index
	}

	return -1
}

int function UniversalMelee_GetNumberOfSetItems( ItemFlavor meleeItem )
{
	return UniversalMelee_GetSetItems( meleeItem ).len()
}

ItemFlavor function UniversalMelee_GetBaseSkin( ItemFlavor meleeItem )
{
	array<ItemFlavor> skins = UniversalMelee_GetSkins( meleeItem )

	foreach( skin in skins )
	{

		if ( UniversalMelee_IsBaseSkin( skin ) )
			return skin
	}
	Assert( false, "Couldn't find a base skin for universal melee, please make sure set has at least one eItemType.melee_skin checked as base item" )
	unreachable
}

bool function UniversalMelee_IsBaseSkin( ItemFlavor meleeSkin )
{
	if ( ItemFlavor_GetType( meleeSkin ) == eItemType.melee_skin )
		return GetGlobalSettingsBool( ItemFlavor_GetAsset( meleeSkin ), "isBaseSkin" )

	return false
}

bool function UniversalMelee_IsBaseSkinOwned( ItemFlavor meleeItem, entity player = null )
{
	ItemFlavor baseSkin = UniversalMelee_GetBaseSkin( meleeItem )








		return GRX_IsItemOwnedByPlayer( baseSkin )


	unreachable
}

bool function UniversalMelee_HasPreviousItem( ItemFlavor meleeItem )
{
	array< ItemFlavor > setItems = UniversalMelee_GetSetItems( meleeItem )

	int itemIndex = 0
	for ( int i = 0; i < setItems.len(); i++ )
	{
		if ( meleeItem.guid == setItems[ i ].guid )
		{
			itemIndex = i
		}
	}

	if ( itemIndex > 0)
	{
		int previousItemIndex = itemIndex - 1
		ItemFlavor previousSetItem = setItems[previousItemIndex]
		return GRX_IsItemOwnedByPlayer( previousSetItem )
	}

	return UniversalMelee_IsBaseSkin( meleeItem ) || UniversalMelee_IsBaseSkinOwned( meleeItem )
}

asset function UniversalMelee_GetVideo( ItemFlavor meleeAddon )
{
	Assert( ItemFlavor_GetType( meleeAddon ) == eItemType.melee_addon )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( meleeAddon ), "video" )
}

vector function UniversalMelee_GetComponentMainColor( ItemFlavor meleeItem )
{
	Assert( ItemFlavor_GetType( meleeItem ) == eItemType.melee_addon || ItemFlavor_GetType( meleeItem ) == eItemType.melee_skin )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( meleeItem ), "universalMeleeMainColor" )
}

vector function UniversalMelee_GetComponentSecondaryColor( ItemFlavor meleeItem )
{
	Assert( ItemFlavor_GetType( meleeItem ) == eItemType.melee_addon || ItemFlavor_GetType( meleeItem ) == eItemType.melee_skin )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( meleeItem ), "universalMeleeSecondaryColor" )
}

int function UniversalMelee_GetTheme( ItemFlavor meleeItem )
{
	Assert( ItemFlavor_GetType( meleeItem ) == eItemType.melee_addon || ItemFlavor_GetType( meleeItem ) == eItemType.melee_skin )
	string themeName = GetSettingsBlockString( ItemFlavor_GetSettingsBlock( meleeItem ), "universalMeleeTheme" )
	return eUniversalSetIndex[ themeName ]
}

array<ItemFlavor> function UniversalMelee_GetSkins( ItemFlavor item )
{
	ItemFlavor ornull meleeWeapon = ItemFlavor_GetParentFlavor( item )
	if ( meleeWeapon == null )
		return []

	expect ItemFlavor( meleeWeapon )

	array<ItemFlavor> skins = []

	var addonSettingsArray = GetSettingsBlockArray( GetSettingsBlockForAsset( ItemFlavor_GetAsset( meleeWeapon ) ), "skins" )
	foreach ( var addonBlock in IterateSettingsArray( addonSettingsArray ) )
	{
		asset addonAsset = GetSettingsBlockAsset( addonBlock, "flavor" )

		if ( IsValidItemFlavorSettingsAsset( addonAsset ) )
		{
			skins.append( GetItemFlavorByAsset( addonAsset ) )
		}
	}

	return skins
}

array<ItemFlavor> function UniversalMelee_GetAddons( ItemFlavor item )
{
	ItemFlavor ornull meleeWeapon = ItemFlavor_GetParentFlavor( item )
	if ( meleeWeapon == null )
		return []

	expect ItemFlavor( meleeWeapon )

	array<ItemFlavor> addons = []

	var addonSettingsArray = GetSettingsBlockArray( GetSettingsBlockForAsset( ItemFlavor_GetAsset( meleeWeapon ) ), "meleeAddOns" )
	foreach ( var addonBlock in IterateSettingsArray( addonSettingsArray ) )
	{
		asset addonAsset = GetSettingsBlockAsset( addonBlock, "flavor" )

		if ( IsValidItemFlavorSettingsAsset( addonAsset ) )
		{
			addons.append( GetItemFlavorByAsset( addonAsset ) )
		}
	}

	return addons
}

array<ItemFlavor> function UniversalMelee_GetDeathboxes( ItemFlavor item )
{
	ItemFlavor ornull meleeWeapon = ItemFlavor_GetParentFlavor( item )
	if ( meleeWeapon == null )
		return []

	expect ItemFlavor( meleeWeapon )

	array<ItemFlavor> deathboxes = []

	var addonSettingsArray = GetSettingsBlockArray( GetSettingsBlockForAsset( ItemFlavor_GetAsset( meleeWeapon ) ), "deathboxes" )
	foreach ( var addonBlock in IterateSettingsArray( addonSettingsArray ) )
	{
		asset addonAsset = GetSettingsBlockAsset( addonBlock, "flavor" )

		if ( IsValidItemFlavorSettingsAsset( addonAsset ) )
		{
			deathboxes.append( GetItemFlavorByAsset( addonAsset ) )
		}
	}

	return deathboxes
}