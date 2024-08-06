globalize_all_functions

string function RTKMutator_PanelName( rtk_panel input )
{
	return input.GetDisplayName()
}

vector function RTKMutator_QualityColor( int input, bool exception )
{
	if (exception)
		return GetKeyColor( COLORID_STORE_LOOT_TIER0, 1 ) / 255.0

	return GetKeyColor( COLORID_STORE_LOOT_TIER0, input ) / 255.0
}

vector function RTKMutator_HUDQualityColor( int input, bool exception )
{
	if (exception)
		return (GetKeyColor( COLORID_HUD_LOOT_TIER0, 1 ) / 255.0) * 1.6

	return (GetKeyColor( COLORID_HUD_LOOT_TIER0, input ) / 255.0) * 1.6
}

vector function RTKMutator_QualityTextColor( int input )
{
	return GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, input + 1 ) / 255.0
}

string function RTKMutator_QualityName( int input )
{
	return Localize( ItemQuality_GetQualityName( input ) )
}

bool function RTKMutator_IsLocalPlayer( string input )
{
	return input == GetPlayerUID()
}

string function RTKMutator_PlayerDisplayName( string input, string hardware )
{
	if ( hardware != "" )
		return Localize( PlatformIDToIconString( GetHardwareFromName( hardware ) ) ) + "  " + input
	return input
}

bool function RTKMutator_HasStarted( int input )
{
	return input < GetUnixTimestamp()
}