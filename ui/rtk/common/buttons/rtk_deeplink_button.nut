global function RTKDeepLinkButton_OnInitialize

global struct RTKDeepLinkButton_Properties
{
	rtk_behavior buttonBehavior
	string link = ""
	string linkType = ""
	string fromPageId = ""
}

void function RTKDeepLinkButton_OnInitialize( rtk_behavior self )
{
	rtk_behavior ornull button = self.PropGetBehavior( "buttonBehavior" )

	if ( button )
	{
		expect rtk_behavior ( button )
		self.AutoSubscribe( button, "OnPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) { GoToLink( self ) } )
	}
}

void function GoToLink( rtk_behavior self )
{
	string link = self.PropGetString( "link" )
	string linkType = self.PropGetString( "linkType" )
	string fromPageId = self.PropGetString( "fromPageId" )
	if ( linkType == "" )
		return

	OpenPromoLink( linkType, link, fromPageId )
}