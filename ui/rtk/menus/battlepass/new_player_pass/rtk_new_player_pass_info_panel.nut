global function RTKNewPlayerPassInfoPanel_OnInitialize
global function NewPlayerPassInfoInitMenu
global function OpenNewPlayerPassInfo
global function OpenChallengesInfo

global struct RTKNewPlayerPassInfoPanel_Properties
{
	rtk_behavior viewPassButton
}

global struct RTKNewPlayerPassInfoPanelModel
{
	string title1
	string title2
	string title3

	string altTitle
	string altTitle2

	string info1
	string info2
	string info3
	string info4

	string additional1
	string additional2

	string backgroundPathLeft
	string backgroundPathCenter
	string backgroundPathRight

	string buttonLabel
	bool isChallenges
	bool isCompleted
}

enum ePanelDisplayType
{
	NEW_PLAYER_PASS,
	CHALLENGES
}
struct
{
	var menu
	int displayType = -1
}file

const string NEW_PLAYER_PASS_INFO_MODEL_NAME = "new_player_pass_info"

void function NewPlayerPassInfoInitMenu( var menu )
{
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )
}

void function OpenNewPlayerPassInfo()
{
	if ( GetActiveMenu() != file.menu )
	{
		AdvanceMenu( file.menu )
		file.displayType = ePanelDisplayType.NEW_PLAYER_PASS
		bool isCompleted

			isCompleted = NPP_IsNPPComplete( GetLocalClientPlayer() )
			if ( isCompleted )
				Remote_ServerCallFunction( "ClientCallback_MarkCompletedNPPInfoDialogAsSeen" )
			else
				Remote_ServerCallFunction( "ClientCallback_MarkNPPInfoDialogAsSeen" )

	}
}

void function OpenChallengesInfo()
{
	if ( GetActiveMenu() != file.menu )
	{
		AdvanceMenu( file.menu )
		file.displayType = ePanelDisplayType.CHALLENGES
	}
}

void function RTKNewPlayerPassInfoPanel_OnInitialize( rtk_behavior self )
{
	if ( file.displayType == -1 )
		return
	rtk_struct panelStruct  = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, NEW_PLAYER_PASS_INFO_MODEL_NAME, "RTKNewPlayerPassInfoPanelModel" )
	string pathToPanelModel = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, NEW_PLAYER_PASS_INFO_MODEL_NAME, true )
	self.GetPanel().SetBindingRootPath( pathToPanelModel )

	RTKNewPlayerPassInfoPanelModel model
	model.isChallenges = file.displayType == ePanelDisplayType.CHALLENGES
	if ( file.displayType == ePanelDisplayType.NEW_PLAYER_PASS )
	{
		bool isCompleted

			isCompleted = NPP_IsNPPComplete( GetLocalClientPlayer() )


		model.title1 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_TITLE_LINE_1" : "#NEWPLAYERPASS_INFO_TITLE_LINE_1"
		model.title2 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_TITLE_LINE_2" : "#NEWPLAYERPASS_INFO_TITLE_LINE_2"
		model.title3 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_TITLE_LINE_3" : "#NEWPLAYERPASS_INFO_TITLE_LINE_3"

		model.info1 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_1" : "#NEWPLAYERPASS_INFO_LINE_1"
		model.info2 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_2" : "#NEWPLAYERPASS_INFO_LINE_2"
		model.info3 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_3" : "#NEWPLAYERPASS_INFO_LINE_3"
		model.info4 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_4" : "#NEWPLAYERPASS_INFO_LINE_4"

		model.additional1 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_5" : "#NEWPLAYERPASS_INFO_LINE_5"
		model.additional2 = isCompleted ? "#NEWPLAYERPASS_COMPLETED_INFO_LINE_6" : "#NEWPLAYERPASS_INFO_LINE_6"

		model.backgroundPathLeft = "ui_image/rui/menu/ftue/new_player_pass/npp_modal_bg_left.rpak"
		model.backgroundPathCenter = "ui_image/rui/menu/ftue/new_player_pass/npp_modal_bg_center.rpak"
		model.backgroundPathRight = "ui_image/rui/menu/ftue/new_player_pass/npp_modal_bg_right.rpak"

		model.buttonLabel = isCompleted ? "#VIEW_BATTLEPASS" : "#VIEW_NEWPLAYERPASS"
		model.isCompleted = isCompleted
	}
	else if ( file.displayType == ePanelDisplayType.CHALLENGES )
	{
		Remote_ServerCallFunction( "ClientCallback_MarkChallengesInfoDialogAsSeen" )

		bool isNewPlayerActive

			isNewPlayerActive = NPP_IsNPPActive( GetLocalClientPlayer() )


		model.altTitle  = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_TITLE_LINE_1" : "#CHALLENGES_INFO_TITLE_LINE_1"
		model.altTitle2 = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_TITLE_LINE_2" : "#CHALLENGES_INFO_TITLE_LINE_2"

		model.info1 = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_LINE_1" : "#CHALLENGES_INFO_LINE_1"
		model.info2 = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_LINE_2" : "#CHALLENGES_INFO_LINE_2"
		model.info3 = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_LINE_3" : "#CHALLENGES_INFO_LINE_3"
		model.info4 = isNewPlayerActive ? "#NEWPLAYER_CHALLENGES_INFO_LINE_4" : "#CHALLENGES_INFO_LINE_4"

		model.backgroundPathLeft = "ui_image/rui/menu/ftue/new_player_pass/ftue_new_player_challenges_bg_left.rpak"
		model.backgroundPathCenter = "ui_image/rui/menu/ftue/new_player_pass/ftue_new_player_challenges_bg_center.rpak"
		model.backgroundPathRight = "ui_image/rui/menu/ftue/new_player_pass/ftue_new_player_challenges_bg_right.rpak"

		model.buttonLabel = "#EVENTS_EVENT_SHOP_GRID_CHALLENGES"
	}
	RTKStruct_SetValue( panelStruct, model )

	rtk_behavior button = self.PropGetBehavior( "viewPassButton" )

	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		OnMenuClose()
	} )
}

void function OnMenuClose()
{
	if ( !IsFullyConnected() )
		return

	if ( file.displayType == ePanelDisplayType.NEW_PLAYER_PASS )
	{

		if ( NPP_IsNPPComplete( GetLocalClientPlayer() ) )
		{
			Remote_ServerCallFunction( "ClientCallback_NPP_SetNPPCompleteAcknowledged" )
			JumpToSeasonTab( "RTKBattlepassPanel" )
		}
		else
		{
			JumpToSeasonTab( "RTKNewplayerpassPanel" )
		}

	}
	else if ( file.displayType == ePanelDisplayType.CHALLENGES )
	{
		JumpToChallenges()
	}
	else if ( file.menu == GetActiveMenu() )
	{
		CloseActiveMenu()
	}
}
void function RTKNewPlayerPassInfoPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, NEW_PLAYER_PASS_INFO_MODEL_NAME )
	file.displayType = -1
}