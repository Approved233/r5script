globalize_all_functions





bool function RTKMutator_ItemFlavorBool( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsBool( item, p0 )
}

int function RTKMutator_ItemFlavorInt( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsInt( item, p0 )
}

float function RTKMutator_ItemFlavorFloat( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsFloat( item, p0 )
}

vector function RTKMutator_ItemFlavorVector( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsVector( item, p0 )
}

string function RTKMutator_ItemFlavorString( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsString( item, p0 )
}

asset function RTKMutator_ItemFlavorAsset( int input, string p0 )
{
	asset item = GetSettingsAssetForUniqueId( input )
	return GetGlobalSettingsAsset( item, p0 )
}





asset function RTKMutator_ItemFlavorIcon( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetIcon( flav )
}

asset function RTKMutator_ItemFlavorSourceIcon( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetSourceIcon( flav )
}

string function RTKMutator_ItemFlavorLongName( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetLongName( flav )
}

string function RTKMutator_ItemFlavorShortName( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetShortName( flav )
}

string function RTKMutator_ItemFlavorLongDescription( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetLongDescription( flav )
}

string function RTKMutator_ItemFlavorShortDescription( int input )
{
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return ItemFlavor_GetShortDescription( flav )
}