global function RTKShowByInputMode_OnInitialize
global function RTKShowByInputMode_OnDestroy

global struct RTKShowByInputMode_Properties
{
	bool showIfController
	bool showIfMKB
}

struct PrivateData
{
	void functionref( bool input ) callbackFunc
	int ifControllerListenerID
	int ifMKBListenerID
}

void function RTKShowByInputMode_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKShowByInputMode_OnInputModeUpdated( self )

	p.callbackFunc = void function( bool input ) : ( self ) { RTKShowByInputMode_OnInputModeUpdated( self ) }
	AddUICallback_InputModeChanged( p.callbackFunc )

	p.ifControllerListenerID = RTKStruct_AddPropertyListener( self.GetProperties(), "showIfController", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKShowByInputMode_OnInputModeUpdated( self )
	} )

	p.ifMKBListenerID = RTKStruct_AddPropertyListener( self.GetProperties(), "showIfMKB", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKShowByInputMode_OnInputModeUpdated( self )
	} )
}

void function RTKShowByInputMode_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RemoveUICallback_InputModeChanged( p.callbackFunc )
	RTKStruct_RemovePropertyListener( self.GetProperties(), "showIfController", p.ifControllerListenerID )
	RTKStruct_RemovePropertyListener( self.GetProperties(), "showIfMKB", p.ifMKBListenerID )
}
void function RTKShowByInputMode_OnInputModeUpdated( rtk_behavior self )
{
	bool isController = IsControllerModeActive()
	bool visible      = ( isController && self.PropGetBool( "showIfController" ) ) || ( !isController && self.PropGetBool( "showIfMKB" ) )
	self.GetPanel().SetVisible( visible )
}