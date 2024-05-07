global function RTKBoostStatusButton_OnInitialize
global function RTKBoostStatusButton_OnDestroy


global struct RTKBoostStatusButton_Properties
{
	rtk_behavior button
}

struct
{
	var menu = null
} file

global struct RTKBoostStatusButtonModel
{
	bool isAcountXPAvailable
	bool isBPStarsAvailable
	bool isMasteryAvailable
}

void function RTKBoostStatusButton_OnInitialize( rtk_behavior self )
{
	rtk_struct buttonPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "boostStatusButton", "RTKBoostStatusButtonModel" )
	BoostTable boosts = Boost_GetActiveBoosts( GetLocalClientPlayer() )
	RTKBoostStatusButtonModel buttonModel
	buttonModel.isAcountXPAvailable = true 
	buttonModel.isBPStarsAvailable = Boost_GetBoostEventQuantityFromCategory( eBoostCategory.BP_STARS, boosts ) > 0
	buttonModel.isMasteryAvailable = Boost_GetBoostEventQuantityFromCategory( eBoostCategory.MASTERY, boosts ) > 0
	RTKStruct_SetValue( buttonPanel, buttonModel )

	rtk_behavior button = self.PropGetBehavior( "button" )
	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		OpenProgressionModifiersMenu()
	} )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "boostStatusButton", true ) )
}

void function RTKBoostStatusButton_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "boostStatusButton" )
}