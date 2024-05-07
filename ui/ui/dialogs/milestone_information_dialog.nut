global function InitMilestonePackInfoDialog
global function OpenMilestonePackInfoDialog

struct {
	var menu
	var infoPanel
}file

void function InitMilestonePackInfoDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	file.infoPanel = Hud_GetChild( menu, "InfoPanel" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	SetDialog( menu, true )
}

void function SetMilestoneEventRuiArgs( ItemFlavor ornull event )
{
	if ( !IsConnected() )
	{
		return
	}

	if ( event != null )
	{
		ItemFlavor ornull activeEvent = event
		expect ItemFlavor( activeEvent )

		AboutPacksInfoModal modalInfo = MilestoneEvent_GetPackInfoModalInfo( activeEvent )

		var modalRui = Hud_GetRui( file.infoPanel )

		RuiSetString( modalRui, "messageText", modalInfo.packInfoModalHeaderText )
		RuiSetString( modalRui, "itemDetailsText1", modalInfo.packInfoDetailsText1 )
		RuiSetString( modalRui, "itemDetailsText2", modalInfo.packInfoDetailsText2 )
		RuiSetString( modalRui, "itemDetailsText3", modalInfo.packInfoDetailsText3 )
		RuiSetString( modalRui, "itemDetailsText4", modalInfo.packInfoDetailsText4 )

		RuiSetString( modalRui, "eventItemsRowLabel", modalInfo.eventItemsRowLabel )

		RuiSetBool( modalRui, "hasMultiPackOffers", modalInfo.hasMultiPackOffers )
		RuiSetBool( modalRui, "hasCraftingOffers", modalInfo.hasCraftingOffers )

		
		if ( modalInfo.itemRates.len() > 0 && modalInfo.itemRates[0].rates.len() > 0 )
		{
			for ( int i = 1; i <= 3; i++ )
			{
				int ratesIndex = i-1
				if ( modalInfo.itemRates[0].rates.len() > ratesIndex )
				{
					RuiSetString( modalRui, "eventItemsBox" + i + "Header", modalInfo.itemRates[0].rates[ratesIndex].title )
					RuiSetString( modalRui, "eventItemsBox" + i + "Percent", modalInfo.itemRates[0].rates[ratesIndex].rate )

					int quality = modalInfo.itemRates[0].rates[ratesIndex].quality
					RuiSetColorAlpha( modalRui, "eventItemsBox" + i + "Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, quality + 1) / 255.0 ), 1.0 )
				}
			}
		}

		
		if ( modalInfo.packPriceThresholds.prices.len() > 0 )
		{
			for ( int i = 1; i <= 4; i++ )
			{
				int priceIndex = i-1
				if ( modalInfo.packPriceThresholds.prices.len() > priceIndex )
				{
					RuiSetString( modalRui, "perPackBox" + i + "TopLabel", modalInfo.packPriceThresholds.prices[priceIndex].title )
					RuiSetString( modalRui, "perPackBox" + i + "PrimaryPrice", modalInfo.packPriceThresholds.prices[priceIndex].price )
				}
			}
		}
	}
}

void function OpenMilestonePackInfoDialog( var button, ItemFlavor ornull event )
{
	if ( GetActiveMenu() != file.menu )
	{
		SetMilestoneEventRuiArgs( event )
		AdvanceMenu( GetMenu( "MilestonePackInfoDialog" ) )
	}
}

