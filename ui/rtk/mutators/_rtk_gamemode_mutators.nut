globalize_all_functions

string function RTKMutator_GamemodeName( string input )
{
	int gamemode = GameModeVariant_GetByDevName( input )
	if ( GameModeVariant_IsDefined( gamemode ) )
		return GameModeVariant_GetName( gamemode )

	return ""
}

asset function RTKMutator_GamemodeIcon( string input )
{
	int gamemode = GameModeVariant_GetByDevName( input )
	if ( GameModeVariant_IsDefined( gamemode ) )
		return GameModeVariant_GetIcon( gamemode )

	return $""
}
