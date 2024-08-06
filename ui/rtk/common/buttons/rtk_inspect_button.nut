global function RTKInspectButton_InitMetaData
global function RTKInspectButton_OnEnable

global struct RTKInspectButton_Properties
{
	string playerName = ""
	string playerHardware = ""
	string playerUID = ""
}

void function RTKInspectButton_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorRequiresBehaviorType( behaviorType, "Button" )
}

void function RTKInspectButton_OnEnable( rtk_behavior self )
{
	rtk_behavior button = self.GetPanel().FindBehaviorByTypeName( "Button" )
	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		Friend friend
		friend.name     = self.PropGetString( "playerName" )
		friend.hardware = self.PropGetString( "playerHardware" )
		friend.id       = self.PropGetString( "playerUID" )

		friend.inleaderboard = true
		friend.eadpData = CreateEADPDataFromEAID( friend.id )

		InspectFriendForceEADP( friend, true )
	} )
}