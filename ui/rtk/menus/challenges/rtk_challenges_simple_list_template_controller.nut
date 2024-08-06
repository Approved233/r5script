
global function RTKChallengesSimpleListTemplate_OnInitialize
global function RTKChallengesSimpleListTemplate_OnDestroy

global struct RTKChallengesSimpleListTemplate_Properties
{
	rtk_panel itemsParentPanel
	string genericPanelFullPath

	int challengeBlockIndex
}

global struct RTKChallengeData
{
	int currentProgress
	int maxProgress
	string description
	asset reward
	int rewardQuantity
	int tier
}

global struct RTKChallengesSimpleListTemplateModel
{
	string title
	string subtitle
	string pathToModel
	string pathToChallenges
}

const string SIMPLE_LIST_STRUCT_NAME = "simpleListTemplate"
const string BLOCK_LIST_ARRAY_NAME = "blockList"

struct PrivateData
{
	string pathToSimpleList
}
struct
{
} file

void function RTKChallengesSimpleListTemplate_OnInitialize( rtk_behavior self )
{
	RTKChallengesSimpleListTemplateModel panelModel
	panelModel.title = "TITLE"
	panelModel.subtitle = "SUBTITLE"

	string genericPanelFullPath = self.PropGetString( "genericPanelFullPath" )
	rtk_struct genericInspectPanel = RTKDataModel_GetStruct( genericPanelFullPath )
	RTKStruct_GetOrCreateScriptStruct( genericInspectPanel, SIMPLE_LIST_STRUCT_NAME, "RTKChallengesSimpleListTemplateModel" )
	self.AddPropertyCallback( "challengeBlockIndex", RTKChallengesSimpleListTemplate_OnChallengeBlockIndexUpdated )
}

void function RTKChallengesSimpleListTemplate_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	string simpleListFullPath = p.pathToSimpleList
	if ( RTKDataModel_HasDataModel( simpleListFullPath ) )
		RTKDataModel_DestroyModel( simpleListFullPath )
}


void function RTKChallengesSimpleListTemplate_OnChallengeBlockIndexUpdated( rtk_behavior self )
{
	PrivateData p
	self.Private( p )
	string genericPanelFullPath = self.PropGetString( "genericPanelFullPath" )
	string pathToModel = genericPanelFullPath + "." + SIMPLE_LIST_STRUCT_NAME
	if ( RTKDataModel_HasDataModel( pathToModel ) )
	{
		p.pathToSimpleList = pathToModel
		rtk_struct panelDataModel         = RTKDataModel_GetStruct( pathToModel )
		int challengeBlockIndex           = self.PropGetInt( "challengeBlockIndex" )
		string pathToActiveChallengeModel = genericPanelFullPath + "." + BLOCK_LIST_ARRAY_NAME + "[" + string(challengeBlockIndex) + "]" + ".challengeData"
		RTKChallengesSimpleListTemplateModel model
		model.subtitle         = "A"
		model.title            = "Title"
		model.pathToChallenges = pathToActiveChallengeModel
		RTKStruct_SetValue( panelDataModel, model )
	}
}


