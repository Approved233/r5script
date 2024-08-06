
global function RTKFTUEMessage_OnInitialize
global function RTKFTUEMessage_OnDestroy
global function RTKFTUEMessage_SetData

global struct RTKFTUEMessageModel
{
	string title
	string description
}

void function RTKFTUEMessage_OnInitialize( rtk_behavior self )
{
	rtk_struct FTUEMessage = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "ftue", "RTKFTUEMessageModel", ["play"] )
	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "ftue", true, ["play"] ) )
}

void function RTKFTUEMessage_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "ftue", ["play"] )
}

void function RTKFTUEMessage_SetData( RTKFTUEMessageModel data )
{
	RTKStruct_SetValue( RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_MENUS, "ftue", "RTKFTUEMessageModel", ["play"] ), data )
}
      