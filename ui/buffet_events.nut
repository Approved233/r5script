


global function BuffetEvents_Init




global function GetActiveBuffetEventArray
global function GetActiveBuffetEventForIndex
global function GetActiveStoryEventArray
global function GetActiveStoryEventForIndex
global function BuffetEvent_GetModesAndChallengesData
global function BuffetEvent_GetCurrentChallenges_EXCLUDING_DAILIES
global function BuffetEvent_GetDailyChallenges_TEMP



global function BuffetEvent_GetHeaderIcon
global function BuffetEvent_GetRewardIconCol



global function BuffetEvent_GetAboutPageCheckMarkCol
global function BuffetEvent_GetAboutPageUnownedRewardBorderImage
global function BuffetEvent_GetAboutPageOwnedRewardBorderImage
global function BuffetEvent_GetProgressBarCol
global function BuffetEvent_GetProgressBarTextCol
global function BuffetEvent_GetHeaderTextCol1
global function BuffetEvent_GetHeaderTextCol2
global function BuffetEvent_GetCategoryButtonTint

global function BuffetEvent_GetChallengeHeaderImage
global function BuffetEvent_GetChallengeButtonImage
global function BuffetEvent_GetChallengeButtonText
global function BuffetEvent_GetChallengeButtonTextCol

global function BuffetEvent_GetString
global function BuffetEvent_GetAsset
global function BuffetEvent_GetBool
global function BuffetEvent_GetVector
global function BuffetEvent_GetFloat
global function BuffetEvent_GetGUIDString

global function BuffetEvent_OnLobbyPlayPanelSpecialChallengeClicked

global const string UI_REWARDS_PANEL_PROGRESS_BAR_COLOR_ID = "rewardProgressBarColor"
global const string UI_CHALLENGE_TILE_ID = "challengeTileFlavor"
global const string UI_REWARD_OWNED_COLOR_ID = "rewardProgressOwnedColor"
global const string UI_REWARD_UNOWNED_COLOR_ID = "rewardProgressUnownedColor"










global struct BuffetEventBadgeData
{
	ItemFlavor& badge
	int         x = 0
	int         y = 0
	int         size = 118
}

global struct BuffetEventModesAndChallengesData
{
	ItemFlavor ornull                                mainChallengeFlav
	table<ItemFlavor ornull, TimestampRange >        bonusChallengeFlavs
	array<ItemFlavor>                                dailyChallenges
	array<ItemFlavor>								 hiddenChallenges
	array<string>                                    modes
	table<string, array<ItemFlavor> >                modeToChallengesMap
	array<BuffetEventBadgeData>                      badges
}











struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, BuffetEventModesAndChallengesData> eventModesAndChallengesDataMap
}




FileStruct_LifetimeLevel& fileLevel 

struct {
	
} fileVM 












void function BuffetEvents_Init()
{

		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel


	AddCallback_OnItemFlavorRegistered( eItemType.calevent_buffet, void function( ItemFlavor ev ) {

		BuffetEventModesAndChallengesData bemacd
		bool expired = false


			Assert( IsConnected(), "We're not connected to a server. This will result in excess challenges being loaded. This won't break anything, but it also shouldn't happen." )
			if ( IsConnected() )

			{
				expired = CalEvent_GetFinishUnixTime( ev ) < GetUnixTimestamp()
			}

		bemacd.mainChallengeFlav = RegisterItemFlavorFromSettingsAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( ev ), "mainChallengeFlav" ) )
		if ( bemacd.mainChallengeFlav != null )
		{
			RegisterChallengeSource( expect ItemFlavor( bemacd.mainChallengeFlav ), ev, 0 )
		}
		else Warning( "Buffet event '%s' refers to bad challenge asset: %s", string(ItemFlavor_GetAsset( ev )), string( GetGlobalSettingsAsset( ItemFlavor_GetAsset( ev ), "mainChallengeFlav" ) ) )

		if ( expired == false )
		{
			int challengeSortOrdinal = 1
			foreach ( var modeBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "modes" ) )
			{
				string modePlaylistName          = GetSettingsBlockString( modeBlock, "playlistName" )
				array<ItemFlavor> modeChallenges = []

				foreach ( var challengeBlock in IterateSettingsArray( GetSettingsBlockArray( modeBlock, "challenges" ) ) )
				{
					ItemFlavor ornull challengeFlav = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "flavor" ) )
					if ( challengeFlav != null )
					{
						modeChallenges.append( expect ItemFlavor( challengeFlav ) )
						RegisterChallengeSource( expect ItemFlavor( challengeFlav ), ev, challengeSortOrdinal )
						challengeSortOrdinal++
					}
					else Warning( "Buffet event '%s' refers to bad challenge asset for mode '%s': %s", string(ItemFlavor_GetAsset( ev )), string( GetGlobalSettingsAsset( ItemFlavor_GetAsset( ev ), "mainChallengeFlav" ) ), modePlaylistName )
				}

				bemacd.modes.append( modePlaylistName )
				bemacd.modeToChallengesMap[modePlaylistName] <- modeChallenges
			}

			foreach ( int index, var bonusChallengeBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "bonusChallengeFlavs" ) )
			{
				array<string> StartAndStopDates       = []
				ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( bonusChallengeBlock, "bonusChallengeFlav" ) )
				if ( challengeFlavOrNull != null )
				{
					int ornull startTime = CalEvent_GetUnixTimePlaylistOverride( ev, format( "_bonus%02d_start_time", index ) )
					int ornull finishTime = CalEvent_GetUnixTimePlaylistOverride( ev, format( "_bonus%02d_finish_time", index ) )

					if ( startTime == null || finishTime == null )
					{
						startTime = DateTimeStringToUnixTimestamp( GetSettingsBlockString( bonusChallengeBlock, "bonusChallengeStartTime" ) )
						finishTime = DateTimeStringToUnixTimestamp( GetSettingsBlockString( bonusChallengeBlock, "bonusChallengeEndTime" ) )
						if ( startTime == null || finishTime == null )
						{
							Warning( format( "Buffet event bonus challenge %s has invalid start and/or end time settings in buffet event", string(ItemFlavor_GetAsset( expect ItemFlavor( challengeFlavOrNull ) )) ) )
							continue
						}
					}

					TimestampRange block
					block.startUnixTime = expect int( startTime )
					block.endUnixTime = expect int( finishTime )

					bemacd.bonusChallengeFlavs[ challengeFlavOrNull ] <- block
					RegisterChallengeSource( expect ItemFlavor( challengeFlavOrNull ), ev, challengeSortOrdinal )
				}
			}

			foreach ( int index, var dailyChallengeBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "dailyChallengeFlavs" ) )
			{
				ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( dailyChallengeBlock, "challengeFlav" ) )
				if ( challengeFlavOrNull != null )
				{
					expect ItemFlavor( challengeFlavOrNull )
					bemacd.dailyChallenges.append( challengeFlavOrNull )
					RegisterChallengeSource( challengeFlavOrNull, ev, challengeSortOrdinal )
				}
			}

			foreach ( int index, var hiddenChallengeBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "hiddenChallengeFlavs" ) )
			{
				ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( hiddenChallengeBlock, "challengeFlav" ) )
				if ( challengeFlavOrNull != null )
				{
					expect ItemFlavor( challengeFlavOrNull )
					bemacd.hiddenChallenges.append( challengeFlavOrNull )
					RegisterChallengeSource( challengeFlavOrNull, ev, challengeSortOrdinal )
				}
			}
		}

		foreach ( int index, var badgeBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "badgeFlavs" ) )
		{
			ItemFlavor ornull badgeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( badgeBlock, "badgeFlav" ) )
			if ( badgeFlavOrNull != null )
			{
				expect ItemFlavor( badgeFlavOrNull )

				BuffetEventBadgeData bd
				bd.badge = badgeFlavOrNull
				bd.x     = GetSettingsBlockInt( badgeBlock, "badgeX" )
				bd.y     = GetSettingsBlockInt( badgeBlock, "badgeY" )
				bd.size  = GetSettingsBlockInt( badgeBlock, "badgeSize" )

				bemacd.badges.append( bd )
			}
		}

		fileLevel.eventModesAndChallengesDataMap[ev] <- bemacd
	} )
}











array<ItemFlavor> function GetActiveStoryEventArray( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	array<ItemFlavor> events
	bool eventIsUsingChallengeBox = false
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_story_challenges ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( eventIsUsingChallengeBox == false || StoryEvent_GetShowInChallengeBoxBool( ev ) == false, "Only one event can use the Lobby Challenge widget at a time" )

		if ( StoryEvent_GetShowInChallengeBoxBool( ev ) )
			eventIsUsingChallengeBox = true

		events.append( ev )
	}
	events.sort( int function( ItemFlavor a, ItemFlavor b ) {
		if ( StoryEvent_GetShowInChallengeBoxBool( a ) == false && StoryEvent_GetShowInChallengeBoxBool( b ) == true )
			return 1
		if ( StoryEvent_GetShowInChallengeBoxBool( a ) == true && StoryEvent_GetShowInChallengeBoxBool( b ) == false )
			return -1
		return 0
	} )

	return events
}

ItemFlavor ornull function GetActiveStoryEventForIndex( int t, int index )
{
	array<ItemFlavor> events = GetActiveStoryEventArray( t )

	if ( events.len() > index )
		return events[ index ]

	return null
}

array<ItemFlavor> function GetActiveBuffetEventArray( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	array<ItemFlavor> events
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_buffet ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		events.append( ev )
	}
	return events
}

ItemFlavor ornull function GetActiveBuffetEventForIndex( int t, int index )
{
	array<ItemFlavor> events = GetActiveBuffetEventArray( t )

	if ( events.len() > index )
		return events[ index ]

	return null
}




BuffetEventModesAndChallengesData function BuffetEvent_GetModesAndChallengesData( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return fileLevel.eventModesAndChallengesDataMap[event]
}




array<ItemFlavor> function BuffetEvent_GetCurrentChallenges_EXCLUDING_DAILIES( ItemFlavor event, int[1] OUT_nextRefreshUnixTime )
{
	BuffetEventModesAndChallengesData bemacd = BuffetEvent_GetModesAndChallengesData( event )
	array<ItemFlavor> result                 = []

	if ( bemacd.mainChallengeFlav != null )
		result.append( expect ItemFlavor( bemacd.mainChallengeFlav ) )

	int nextRefreshUnixTime = INT_MAX

	foreach ( string modeName in bemacd.modes )
	{
		PlaylistScheduleData scheduleData = Playlist_GetScheduleData_Deprecated( modeName )
		if ( scheduleData.currentBlock != null )
		{
			result.extend( bemacd.modeToChallengesMap[modeName] )
			nextRefreshUnixTime = minint( (expect TimestampRange(scheduleData.currentBlock)).endUnixTime, nextRefreshUnixTime )
		}
	}

	int currentTime = GetUnixTimestamp()
	foreach ( bonusChallengeFlav, TimestampRange block in bemacd.bonusChallengeFlavs )
	{
		if ( bonusChallengeFlav != null )
		{
			int startTime = block.startUnixTime
			int endTime   = block.endUnixTime
			if ( currentTime >= startTime && currentTime <= endTime )
				result.append( expect ItemFlavor( bonusChallengeFlav ) )
		}
	}

	foreach ( hiddenChallengeFlav in bemacd.hiddenChallenges )
	{
		result.append( hiddenChallengeFlav )
	}

	OUT_nextRefreshUnixTime[0] = nextRefreshUnixTime

	return result
}




array<ItemFlavor> function BuffetEvent_GetDailyChallenges_TEMP( ItemFlavor event )
{
	BuffetEventModesAndChallengesData bemacd = BuffetEvent_GetModesAndChallengesData( event )

	return bemacd.dailyChallenges
}




asset function BuffetEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}



asset function BuffetEvent_GetChallengeHeaderImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "eventChallengeHeaderImage" )
}



asset function BuffetEvent_GetChallengeButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "eventChallengeButtonImage" )
}



string function BuffetEvent_GetChallengeButtonText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "eventChallengeButtonText" )
}



vector function BuffetEvent_GetChallengeButtonTextCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "eventChallengeButtonTextColor" )
}



asset function BuffetEvent_GetAboutPageUnownedRewardBorderImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "aboutPageUnownedRewardBorderImage" )
}



asset function BuffetEvent_GetAboutPageOwnedRewardBorderImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "aboutPageOwnedRewardBorderImage" )
}



vector function BuffetEvent_GetAboutPageCheckMarkCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "aboutPageCheckMarkCol" )
}



vector function BuffetEvent_GetProgressBarCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "progressBarColor" )
}



vector function BuffetEvent_GetProgressBarTextCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "progressBarTextColor" )
}



vector function BuffetEvent_GetHeaderTextCol1( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "eventChallengeHeaderColor1" )
}



vector function BuffetEvent_GetHeaderTextCol2( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "eventChallengeHeaderColor2" )
}




vector function BuffetEvent_GetCategoryButtonTint( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "eventChallengeCategoryButtonTint" )
}



vector function BuffetEvent_GetRewardIconCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "rewardIconColor" )
}



string function BuffetEvent_GetString( ItemFlavor event, string id  )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), id )
}

asset function BuffetEvent_GetAsset( ItemFlavor event, string id )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), id )
}

string function BuffetEvent_GetGUIDString( ItemFlavor event, string id )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	asset settingsAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), id )

	if( settingsAsset == $"" )
		return ""

	return ItemFlavor_GetGUIDString( GetItemFlavorByAsset( settingsAsset ) )
}

bool function BuffetEvent_GetBool( ItemFlavor event, string id )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), id )
}

vector function BuffetEvent_GetVector( ItemFlavor event, string id )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), id )
}

float function BuffetEvent_GetFloat( ItemFlavor event, string id )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )
	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( event ), id )
}



void function BuffetEvent_OnLobbyPlayPanelSpecialChallengeClicked( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_buffet )

	Assert( IsLobby() )
	Assert( IsFullyConnected() )
	Assert( GetActiveMenu() == GetMenu( "LobbyMenu" ) )
	Assert( IsTabPanelActive( GetPanel( "PlayPanel" ) ) )


	EventsPanel_SetOpenPageIndex( eEventsPanelPage.LANDING )
	JumpToEventTab( "RTKEventsPanel" )

}






















