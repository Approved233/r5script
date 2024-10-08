global function RTKRankedBadge_InitMetaData
global function RTKRankedBadge_OnInitialize
global function RTKRankedBadge_OnDrawBegin
global function RTKRankedBadge_OnDestroy

global struct RTKRankedBadge_Properties
{
	asset badgeRuiAsset
	asset rankedIcon

	bool isPlacementMode = false
	int completedMatches
	int maxMatches = 10
	bool useDynamicPips = false
	bool isPromotional = false
	bool showDemoteProtection = false
	int startPip
	array<bool> wonMatches

	string emblemText
	int emblemDisplayMode
	int ladderPosition
	int rankScore
	int protectionCurrent
}

void function RTKRankedBadge_InitMetaData( string behaviorType, string structType )
{
	RTKMetaData_BehaviorIsRuiBehavior( behaviorType, true )
}

void function RTKRankedBadge_OnInitialize( rtk_behavior self )
{
	self.AddPropertyCallback( "badgeRuiAsset", UpdateBadgeRuiAsset )

	UpdateBadgeRuiAsset( self )
}

void function RTKRankedBadge_OnDrawBegin( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	if ( panel.HasRui() )
	{
		panel.SetRuiArgImage( "rankedIcon", expect asset( self.rtkprops.rankedIcon ) )

		bool showProtection = expect bool ( self.rtkprops.showDemoteProtection )
		bool isPlacementMode = expect bool( self.rtkprops.isPlacementMode )
		if ( showProtection )
		{
			panel.SetRuiArgInt( "protectionCurrent", expect int (self.rtkprops.protectionCurrent ) )
			panel.SetRuiArgString( "emblemText", expect string( self.rtkprops.emblemText ) )
		}
		else if ( isPlacementMode )
		{
			panel.SetRuiArgInt( "placementProgress", expect int( self.rtkprops.completedMatches ) )
			panel.SetRuiArgInt( "maxPips", expect int( self.rtkprops.maxMatches ) )
			panel.SetRuiArgBool( "useDynamicPips", expect bool( self.rtkprops.useDynamicPips ) )
			panel.SetRuiArgBool( "isPromotional", expect bool( self.rtkprops.isPromotional ) )
			panel.SetRuiArgInt( "startPip", expect int( self.rtkprops.startPip ) )

			rtk_array wonMatches = expect rtk_array( self.rtkprops.wonMatches )
			for ( int i = 0; i < RTKArray_GetCount( wonMatches ); i++ )
			{
				bool val = RTKArray_GetBool( wonMatches, i )
				panel.SetRuiArgBool( "wonGame" + i, val )
			}

			panel.SetRuiArgInt("emblemDisplayMode", expect int( self.rtkprops.emblemDisplayMode ) )

			switch( expect int( self.rtkprops.emblemDisplayMode ) )
			{
				case emblemDisplayMode.DISPLAY_DIVISION:
				{
					panel.SetRuiArgString( "emblemText", expect string( self.rtkprops.emblemText ) )
					break
				}

				case emblemDisplayMode.DISPLAY_RP:
				{
					string rankScoreShortened = FormatAndLocalizeNumber( "1", float( expect int( self.rtkprops.rankScore ) ), IsTenThousandOrMore( expect int( self.rtkprops.rankScore ) ) )
					panel.SetRuiArgString( "emblemText", Localize( "#RANKED_POINTS_GENERIC", rankScoreShortened ) )
					break
				}

				case emblemDisplayMode.DISPLAY_LADDER_POSITION:
				{
					string ladderPosShortened
					if ( expect int( self.rtkprops.ladderPosition ) == SHARED_RANKED_INVALID_LADDER_POSITION )
						ladderPosShortened = ""
					else
						ladderPosShortened = Localize( "#RANKED_LADDER_POSITION_DISPLAY", FormatAndLocalizeNumber( "1", float( expect int( self.rtkprops.ladderPosition ) ), IsTenThousandOrMore( expect int( self.rtkprops.ladderPosition ) ) ) )

					panel.SetRuiArgString(  "emblemText", ladderPosShortened )
					break
				}

				case emblemDisplayMode.NONE:
				default:
				{
					panel.SetRuiArgString( "emblemText", "" )
					break
				}
			}
		}
	}
}

void function RTKRankedBadge_OnDestroy( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	if ( panel.HasRui() )
		panel.DestroyRui()
}

void function UpdateBadgeRuiAsset( rtk_behavior self )
{
	rtk_panel panel = self.GetPanel()

	asset badgeRuiAsset = expect asset( self.rtkprops.badgeRuiAsset )
	if ( badgeRuiAsset != "" )
		panel.CreateRui( badgeRuiAsset )
	else if ( panel.HasRui() )
		panel.DestroyRui()
}
