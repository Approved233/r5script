globalize_all_functions

string function RTKMutator_GamemodeName( string input )
{
	if ( LimitedTimeMode_IsDefined( input ) )
		return LimitedTimeMode_GetName( input )
	else if ( GameMode_IsDefined( input ) )
		return GameMode_GetName( input )

	return ""
}

asset function RTKMutator_GamemodeIcon( string input )
{
	if ( LimitedTimeMode_IsDefined( input ) )
		return LimitedTimeMode_GetIcon( input )
	else if ( GameMode_IsDefined( input ) )
		return GameMode_GetIcon( input )

	return $""
}