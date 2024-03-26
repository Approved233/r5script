globalize_all_functions

int function RTKMutator_CalEventStartTime( int input )
{
	if ( input <= ASSET_SETTINGS_UNIQUE_ID_INVALID )
	{
		Warning("RTKMutator_CalEventStartTime - invalid itemflavor")
		return -1
	}
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return CalEvent_GetStartUnixTime( flav )
}

bool function RTKMutator_CalEventStarted( int input )
{
	if ( input <= ASSET_SETTINGS_UNIQUE_ID_INVALID )
	{
		Warning("RTKMutator_CalEventStarted - invalid itemflavor")
		return false
	}
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return CalEvent_HasStarted( flav, GetUnixTimestamp() )
}

int function RTKMutator_CalEventFinishTime( int input )
{
	if ( input <= ASSET_SETTINGS_UNIQUE_ID_INVALID )
	{
		Warning("RTKMutator_CalEventFinishTime - invalid itemflavor")
		return -1
	}
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return CalEvent_GetFinishUnixTime( flav )
}

bool function RTKMutator_CalEventFinished( int input )
{
	if ( input <= ASSET_SETTINGS_UNIQUE_ID_INVALID )
	{
		Warning("RTKMutator_CalEventStarted - invalid itemflavor")
		return false
	}
	ItemFlavor flav = GetItemFlavorByGUID( input )
	return CalEvent_HasFinished( flav, GetUnixTimestamp() )
}

int function RTKMutator_CalEventNextTime( int input )
{
	if ( input <= ASSET_SETTINGS_UNIQUE_ID_INVALID )
	{
		Warning("RTKMutator_CalEventNextTime - invalid itemflavor")
		return -1
	}

	ItemFlavor flav = GetItemFlavorByGUID( input )
	int unixTime = GetUnixTimestamp()

	if ( !CalEvent_IsRevealed( flav, unixTime ) )
		return CalEvent_GetRevealUnixTime( flav )

	if ( !CalEvent_HasStarted( flav, unixTime ) )
		return CalEvent_GetStartUnixTime( flav )

	if ( !CalEvent_HasFinished( flav, unixTime ) )
		return CalEvent_GetFinishUnixTime( flav )

	return CalEvent_GetHideUnixTime( flav )
}