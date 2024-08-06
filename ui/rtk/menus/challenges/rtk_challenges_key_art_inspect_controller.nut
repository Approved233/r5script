
global function InitChallengesKeyArtInspectMenu
global function RTKChallengesKeyArtInspectPanel_OnInitialize
global function OpenChallengesKeyArtInspectPanel

global struct RTKChallengesKeyArtInspectPanel_Properties
{
}

global struct RTKChallengesKeyArtInspectPanelModel
{
	string title
}

struct
{
	var menu
	int challengeType
	ChallengeTile& tileData
} file



void function InitChallengesKeyArtInspectMenu( var menu )
{
	file.menu = menu
}

void function RTKChallengesKeyArtInspectPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct templatePanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "challengesKeyArtPanel", "RTKChallengesKeyArtInspectPanelModel" )

	RTKChallengesKeyArtInspectPanelModel panelModel
	panelModel.title = "TITLE"
	RTKStruct_SetValue( templatePanel, panelModel )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "challengesKeyArtPanel", true ) )
}

void function RTKChallengesKeyArtInspectPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "challengesKeyArtPanel" )
}

void function OpenChallengesKeyArtInspectPanel( ChallengeTile tileData )
{
	file.tileData = tileData
	AdvanceMenu( file.menu )
}
      