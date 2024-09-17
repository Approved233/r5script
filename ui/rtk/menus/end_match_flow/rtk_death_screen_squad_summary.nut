
global function DeathScreenSquadSummary_RTKInitialize
global function RTKDeathScreenSquadSummary_OnInitialize
global function RTKDeathScreenSquadSummary_OnDestroy







struct
{
	rtk_struct squadSummary = null
} file

global struct RTKDeathScreenSquadSummary_Properties
{
	rtk_panel summaryCardList
}

global struct RTKSquadSummaryCardStatModel
{
	string title
	string value
}

global struct RTKSquadSummaryCardModel
{
	string playerName = ""
	string hardware
	string platformIDString
	array<RTKSquadSummaryCardStatModel> stats
	string obfuscatedID
	string uid
	string unspoofedUID
	string playerEAID
	string actionText = ""
	bool isLocalPlayer

	bool canMute = false
	bool isMuted = false
	bool canViewProfile = false

	bool canReport = false
	bool canInvite = false
	bool canSendFriendRequest = false
	bool isConnected = true
}

global struct RTKSquadSummaryModel
{
	array<RTKSquadSummaryCardModel> cards
}



void function RTKDeathScreenSquadSummary_OnInitialize( rtk_behavior self )
{
	file.squadSummary = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "squadSummary", "RTKSquadSummaryModel" )
	string squadSummaryPath = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "squadSummary")

	self.GetPanel().SetBindingRootPath( squadSummaryPath )

	if ( CanRunClientScript() )
		RunClientScript( "RTKDeathScreenSquadSummary_PopulateData")

	
	rtk_panel ornull summaryCardList = self.PropGetPanel( "summaryCardList" )
	if ( summaryCardList != null )
	{
		expect rtk_panel( summaryCardList )
		self.AutoSubscribe( summaryCardList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ){

			rtk_panel Actions = newChild.FindDescendantByName( "Actions" )
			rtk_behavior ReportButton = Actions.FindChildByName( "ReportButtonContainer" ).FindChildByName( "ReportButton" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior MuteButton = Actions.FindChildByName( "MuteButtonContainer" ).FindChildByName( "MuteButton" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior GladCardHitArea = newChild.FindChildByName( "CardElements" ).FindChildByName( "TooltipContainer" ).FindBehaviorByTypeName( "Button" )

			self.AutoSubscribe( GladCardHitArea, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				switch( keycode )
				{
					case MOUSE_LEFT:
					case BUTTON_A:
						RTKDeathScreenSquadSummary_InviteSquadMate( self, newChildIndex )
						break
					case MOUSE_RIGHT:
					case BUTTON_X:
						RTKDeathScreenSquadSummary_SendFriendRequest( self, newChildIndex )
						break
					case BUTTON_Y:
					case KEY_F:
						RTKDeathScreenSquadSummary_RTKViewProfile( self, newChildIndex )
						break
				}
			} )

			self.AutoSubscribe( ReportButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKDeathScreenSquadSummary_Report( newChildIndex )
			} )

			self.AutoSubscribe( MuteButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKDeathScreenSquadSummary_ToggleMute( newChildIndex )
			} )

		} )
	}
}

void function RTKDeathScreenSquadSummary_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "squadSummary" )

	file.squadSummary = null
}


void function RTKDeathScreenSquadSummary_InviteSquadMate( rtk_behavior self, int index )
{
	rtk_array squadSummaryCardsModel = RTKStruct_GetArray( file.squadSummary, "cards" )
	int squadSummaryCardsModelCount = RTKArray_GetCount( squadSummaryCardsModel )

	if( squadSummaryCardsModelCount > index )
	{
		rtk_struct quadSummaryCardModel = RTKArray_GetStruct( squadSummaryCardsModel, index )

		string playerName = RTKStruct_GetString( quadSummaryCardModel, "playerName" )
		int hardware = int( RTKStruct_GetString( quadSummaryCardModel, "hardware" ) )
		string uid = RTKStruct_GetString( quadSummaryCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadSummaryCardModel, "playerEAID" )

		int localHardwareId = GetHardwareFromName( GetPlayerHardware() )
		if ( localHardwareId != hardware )
		{
			ClientToUI_InviteToPlayByEAID( eaid )
		}
		else
		{
			DoInviteToParty( [ uid ] )
		}
	}
}



void function RTKDeathScreenSquadSummary_SendFriendRequest( rtk_behavior self, int index )
{
	rtk_array squadSummaryCardsModel = RTKStruct_GetArray( file.squadSummary, "cards" )
	int squadSummaryCardsModelCount = RTKArray_GetCount( squadSummaryCardsModel )

	if( squadSummaryCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadSummaryCardsModel, index )

		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "playerEAID" )
		string unspoofedUid = RTKStruct_GetString( quadGladCardModel, "unspoofedUID" )

		if ( uid == "" )
			return

		bool canAddFriend = CanSendFriendRequest( GetLocalClientPlayer() )

		if ( canAddFriend )
		{
			CommunityFriends friends = GetFriendInfo()
			foreach ( id in friends.ids )
			{
				if ( uid == id || unspoofedUid == id || EADP_IsFriendByEAID( eaid ) )
				{
					canAddFriend = false
					break
				}
			}
		}

		if ( !canAddFriend )
			return

		EmitUISound( "UI_Menu_InviteFriend_Send" )
		string playerHardware = GetPlayerHardware()
		if ( playerHardware == hardware )
		{
			DoInviteToBeFriend( unspoofedUid )
		}
		else if ( CrossplayEnabled() && eaid != "" )
		{
			
			EADP_InviteFriendByEAID( eaid )
		}
	}
}



void function RTKDeathScreenSquadSummary_RTKViewProfile( rtk_behavior self, int index )
{
	rtk_array squadSummaryCardsModel = RTKStruct_GetArray( file.squadSummary, "cards" )
	int squadSummaryCardsModelCount = RTKArray_GetCount( squadSummaryCardsModel )


	if( squadSummaryCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadSummaryCardsModel, index )

		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "playerEAID" )
		string unspoofedUid = RTKStruct_GetString( quadGladCardModel, "unspoofedUID" )
		bool canViewProfile = RTKStruct_GetBool( quadGladCardModel, "canViewProfile" )

		if( canViewProfile )
		{


				if ( !PCPlat_IsOverlayAvailable() )
				{
					string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
					ConfirmDialogData dialogData
					dialogData.headerText   = ""
					dialogData.messageText  = "#" + platname + "_INGAME_REQUIRED"
					dialogData.contextImage = $"ui/menu/common/dialog_notice"

					OpenOKDialogFromData( dialogData )
					return
				}


			ShowPlayerProfileCardForUID( unspoofedUid )
		}
	}
}



void function RTKDeathScreenSquadSummary_Report( int index )
{

	rtk_array squadSummaryCardsModel = RTKStruct_GetArray( file.squadSummary, "cards" )
	int squadSummaryCardsModelCount = RTKArray_GetCount( squadSummaryCardsModel )

	if( squadSummaryCardsModelCount > index )
	{
		rtk_struct quadSummaryCardModel = RTKArray_GetStruct( squadSummaryCardsModel, index )

		string playerName = RTKStruct_GetString( quadSummaryCardModel, "playerName" )
		int hardware = int( RTKStruct_GetString( quadSummaryCardModel, "platformIDString" ) )
		string uid = RTKStruct_GetString( quadSummaryCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadSummaryCardModel, "playerEAID" )

		ClientToUI_ShowReportPlayerDialog( playerName, hardware, uid, eaid, "friendly" )
	}
}



void function RTKDeathScreenSquadSummary_ToggleMute( int index )
{
	rtk_array squadSummaryCardsModel = RTKStruct_GetArray( file.squadSummary, "cards" )
	int squadSummaryCardsModelCount = RTKArray_GetCount( squadSummaryCardsModel )

	if( squadSummaryCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadSummaryCardsModel, index )

		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "playerEAID" )

		TogglePlayerVoiceAndTextMuteForUID( uid, hardware, eaid )
		RTKStruct_SetBool( quadGladCardModel, "isMuted", IsPlayerVoiceAndTextMutedForUID( uid, hardware ) )
	}
}


void function DeathScreenSquadSummary_RTKInitialize( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SquadSummaryOnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SquadSummaryOnClosePanel )

	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SQUAD_SUMMARY )
}

void function SquadSummaryOnOpenPanel( var panel )
{
	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	var headerDataElement = Hud_GetChild( menu, "SquadSummaryHeader" )
	var chatBoxContainer = Hud_GetChild( menu, "DeathScreenChatBox" )
	Hud_SetVisible( headerDataElement, true )
	Hud_SetVisible( chatBoxContainer, true )
	RunClientScript( "UICallback_ShowSquadSummary", headerElement, headerDataElement )

	DeathScreenUpdateCursor()
	SetMenuReceivesCommands( menu, false)
}

void function SquadSummaryOnClosePanel( var panel )
{
	var menu = GetParentMenu( panel )
	SetMenuReceivesCommands( menu, true)
	var headerDataElement = Hud_GetChild( menu, "SquadSummaryHeader" )
	var chatBoxContainer = Hud_GetChild( menu, "DeathScreenChatBox" )

	Hud_SetVisible( headerDataElement, false )
	Hud_SetVisible( chatBoxContainer, false )

	RunClientScript( "UICallback_HideSquadSummary" )
	RunClientScript( "SignalShowRoundEndSquadResults" )
}































































































































































































