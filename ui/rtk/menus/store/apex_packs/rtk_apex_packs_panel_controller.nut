global function InitApexPacksPanelFooterOptions

global function RTKApexPacksPanel_OnInitialize
global function RTKApexPacksPanel_OnDestroy

global struct RTKApexPacksPanel_Properties
{
	rtk_behavior giftButton
	rtk_behavior purchaseButton
	rtk_behavior openPackButton
	rtk_behavior moreInfoButton
}

global struct RTKApexPacksPurchaseButtonData
{
	bool visible
	int state
	bool interactive
	string title
	string description
	string notification
	bool notificationVisible
}

global struct RTKApexPacksGiftButtonData
{
	bool visible
	int state
	bool interactive
	string title
	string description
	string notification
	bool notificationVisible
}

global struct RTKApexPacksOpenPackButtonData
{
	string packCountText
	string availablePacksText
	string title
	string description
	asset icon
	int state
}

global struct RTKApexPacksPanel_ModelStruct
{
	bool visible = false
	RTKApexPacksGiftButtonData& giftButtonData
	RTKApexPacksPurchaseButtonData& purchaseButtonData
	RTKApexPacksOpenPackButtonData& openPackButtonData
}

struct PrivateData
{
	void functionref() OnGRXStateChanged
}

void function RTKApexPacksPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct apexPackModelStruct = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "apexPacksData", "RTKApexPacksPanel_ModelStruct" )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "apexPacksData", true ) )

	
	ItemFlavorBag basePrice = expect array<GRXScriptOffer>( GetLootTickPurchaseOffers() )[0].prices[0]
	string buttonDescription = Localize( "#LOOT_TICK_PRICE_1", GRX_GetFormattedPrice( basePrice, 1 ) )

	rtk_struct giftButtonData = RTKStruct_GetStruct( apexPackModelStruct, "giftButtonData" )
	RTKStruct_SetString( giftButtonData, "description", buttonDescription )
	rtk_struct purchaseButtonData = RTKStruct_GetStruct( apexPackModelStruct, "purchaseButtonData" )
	RTKStruct_SetString( purchaseButtonData, "description", buttonDescription )

	
	SetUpGiftButton( self, apexPackModelStruct )
	SetUpPurchaseButton( self, apexPackModelStruct )

	
	SetUpOpenPackButton( self, apexPackModelStruct )

	
	rtk_behavior ornull moreInfoButton = self.PropGetBehavior( "moreInfoButton" )
	if ( moreInfoButton != null )
	{
		expect rtk_behavior( moreInfoButton )

		self.AutoSubscribe( moreInfoButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
			OpenPackInfoDialog( null )
		} )
	}

	
	
	thread function() : ( self, apexPackModelStruct )
	{
		RTK_DevAssert( IsFullyConnected(), "RTKApexPacksPanel_OnInitialize called while not connected to a server")

		while ( !IsFullyConnected() )
			WaitFrame()

		RTKApexPacksPanel_OnInitializedAndConnected( self, apexPackModelStruct )
	}()
}

void function RTKApexPacksPanel_OnInitializedAndConnected( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	PrivateData p
	self.Private( p )

	p.OnGRXStateChanged = (void function() : ( self, apexPackModelStruct )
	{
		if ( !GRX_IsInventoryReady() )
			return

		UpdateVisuals( self, apexPackModelStruct )
	})

	AddCallbackAndCallNow_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	AddCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function RTKApexPacksPanel_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "apexPacksData" )

	RemoveCallback_OnGRXOffersRefreshed( p.OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( p.OnGRXStateChanged )
}

void function SetUpGiftButton( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	
	UpdateGiftButton( self, apexPackModelStruct )

	
	rtk_behavior ornull giftButton = self.PropGetBehavior( "giftButton" )
	if ( giftButton != null )
	{
		expect rtk_behavior( giftButton )

		self.AutoSubscribe( giftButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {

			if ( !IsTwoFactorAuthenticationEnabled() )
			{
				OpenTwoFactorInfoDialog( button )
				return
			}

			array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
			if ( offers == null )
			{
				EmitUISound( "menu_deny" )
				return
			}

			int quantity = 1
			PurchaseDialogConfig pdc
			pdc.offer = expect array<GRXScriptOffer>( offers )[0]
			pdc.quantity = quantity
			pdc.markAsNew = false
			pdc.isGiftPack = true
			PurchaseDialog( pdc )
		} )
	}
	else
	{
		Warning( "%s: no button!", FUNC_NAME() )
	}
}

void function SetUpPurchaseButton( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	rtk_struct purchaseButtonModelStruct = RTKStruct_GetOrCreateScriptStruct( apexPackModelStruct, "purchaseButtonData", "RTKApexPacksPurchaseButtonData" )

	RTKApexPacksPurchaseButtonData purchaseDataStruct
	purchaseDataStruct.title = Localize("#PURCHASE")
	purchaseDataStruct.description = RTKStruct_GetString( purchaseButtonModelStruct, "description" )
	purchaseDataStruct.notification = ""
	purchaseDataStruct.interactive = true

	RTKStruct_SetValue( purchaseButtonModelStruct, purchaseDataStruct )

	rtk_behavior ornull purchaseButton = self.PropGetBehavior( "purchaseButton" )
	if ( purchaseButton != null )
	{
		expect rtk_behavior( purchaseButton )

		self.AutoSubscribe( purchaseButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, apexPackModelStruct ) {

			int quantity = 1

			array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
			if ( offers == null )
			{
				EmitUISound( "menu_deny" )
				return
			}

			PurchaseDialogConfig pdc
			pdc.offer = expect array<GRXScriptOffer>( offers )[0]
			pdc.quantity = quantity
			pdc.markAsNew = false
			pdc.onPurchaseResultCallback = void function( bool wasSuccessful ) : ( self, apexPackModelStruct ) {
				if ( wasSuccessful && GRX_IsInventoryReady() )
				{
					UpdateVisuals( self, apexPackModelStruct )
				}
			}

			PurchaseDialog( pdc )
		} )
	}
	else
	{
		Warning( "%s: no button!", FUNC_NAME() )
	}
}

void function SetUpOpenPackButton( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	UpdateOpenPackButton( self, apexPackModelStruct )

	rtk_behavior ornull openPackButton = self.PropGetBehavior( "openPackButton" )
	if ( openPackButton != null )
	{
		expect rtk_behavior( openPackButton )

		self.AutoSubscribe( openPackButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {

			AdvanceMenu( GetMenu( "LootBoxOpen" ) )
		} )
	}
	else
	{
		Warning( "%s: no button!", FUNC_NAME() )
	}
}

void function UpdateGiftButton( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	int giftsLeft = Gifting_GetRemainingDailyGifts()
	bool isPlayerLeveledForGifting = IsPlayerLeveledForGifting()
	bool isPlayerWithinGiftingLimit = IsPlayerWithinGiftingLimit()
	bool isTwoFactorEnabled = IsTwoFactorAuthenticationEnabled()
	bool canLocalPlayerGift = CanLocalPlayerGift()
	bool isMissingTwoFactor = isPlayerLeveledForGifting && isPlayerWithinGiftingLimit && !isTwoFactorEnabled

	string giftMainText = Localize( "#BUY_GIFT" )
	string giftDescText = Localize( "#GIFTS_LEFT_FRACTION", giftsLeft ) 

	if ( !canLocalPlayerGift )
	{
		giftMainText = Localize( "#LOCKED_GIFT" )

		if( !isPlayerLeveledForGifting )
		{
			giftDescText = Localize( "#LEVEL_REQUIRED", GetConVarInt( "mtx_giftingMinAccountLevel" ) )
		}
		else if ( !isPlayerWithinGiftingLimit )
		{
			giftDescText =  Localize( "#GIFTS_LEFT", giftsLeft )
		}
		else if ( !isTwoFactorEnabled )
		{
			giftDescText = Localize( "#TWO_FACTOR_NEEDED" )
		}
	}

	bool giftButtonUnlocked = false
	if ( GRX_IsInventoryReady() && GRX_AreOffersReady() )
	{
		array<GRXScriptOffer> ornull offers = GetLootTickPurchaseOffers()
		if ( offers != null )
		{
			giftButtonUnlocked = true
		}
	}

	rtk_struct giftButtonModelStruct = RTKStruct_GetOrCreateScriptStruct( apexPackModelStruct, "giftButtonData", "RTKApexPacksGiftButtonData" )

	RTKApexPacksGiftButtonData giftDataStruct
	giftDataStruct.description = RTKStruct_GetString( giftButtonModelStruct, "description" )
	giftDataStruct.title = giftMainText
	giftDataStruct.notification = giftDescText
	giftDataStruct.interactive = giftButtonUnlocked

	RTKStruct_SetValue( giftButtonModelStruct, giftDataStruct )
}

void function UpdateOpenPackButton( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	ItemFlavor ornull packFlav
	int lootBoxCount     = 0
	int totalPackCount   = 0
	string buttonText    = "#APEX_PACKS"
	string descText      = "#UNAVAILABLE"
	int nextRarity       = -1
	asset rarityIcon     = $""
	asset packIcon       = $""
	int specialPackCount = 0

	if ( GRX_IsInventoryReady() )
	{
		ItemFlavor ornull nextPack = GetNextLootBox()
		totalPackCount = GRX_GetTotalPackCount()
		if ( totalPackCount > 0 )
		{
			expect ItemFlavor( nextPack )
			packIcon = GRXPack_GetOpenButtonIcon( nextPack )
			if ( packIcon != "" )
			{
				specialPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( nextPack ) )
			}
		}

		descText = "#TO_OPEN"

		if ( packFlav == null )
		{
			if ( specialPackCount > 0 )
			{
				lootBoxCount = specialPackCount
				packFlav = nextPack
			}
			else
			{
				lootBoxCount = totalPackCount
				if ( lootBoxCount > 0 )
				{
					packFlav = nextPack
				}
			}
		}
	}

	if ( packFlav != null )
	{
		expect ItemFlavor( packFlav )

		bool isPlural = lootBoxCount > 1
		if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.EVENT )
		{
			buttonText = ItemFlavor_GetShortName( packFlav )
			descText = (isPlural ? "#EVENT_PACKS" : "#EVENT_PACK")
		}
		else if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.SIRNGE )
		{
			if ( MilestoneEvent_IsMilestonePackFlav( packFlav, false, true ) )
				buttonText = (isPlural ? "#PACK_MILESTONE_TEXT_PLURAL" : "#PACK_MILESTONE_TEXT")
			else
				buttonText = (isPlural ? "#EVENT_PACKS" : "#EVENT_PACK")

			ItemFlavor ornull milestoneEvent = GetActiveMilestoneEvent( GetUnixTimestamp() )
			if ( milestoneEvent != null )
			{
				expect ItemFlavor( milestoneEvent )
				lootBoxCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( MilestoneEvent_GetMainPackFlav( milestoneEvent ) ) ) +
				GRX_GetPackCount( ItemFlavor_GetGRXIndex( MilestoneEvent_GetGuaranteedPackFlav( milestoneEvent ) ) )
			}
		}
		else if ( ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.THEMATIC || ItemFlavor_GetAccountPackType( packFlav ) == eAccountPackType.EVENT_THEMATIC )
		{
			buttonText = ItemFlavor_GetShortName( packFlav )
			descText = (isPlural ? "#THEMATIC_PACKS" : "#THEMATIC_PACK")
		}
		else
		{
			int packRarity = ItemFlavor_GetQuality( packFlav )
			if ( packRarity > 1 )
			{
				string packTier = ItemFlavor_GetQualityName( packFlav, isPlural )
				buttonText = ( isPlural ? Localize( "#APEX_PACKS_WITH_TIER", Localize ( packTier ) ) : Localize( "#APEX_PACK_WITH_TIER", Localize( packTier ) ) )
			}
			else
			{
				buttonText = ( isPlural ? "#APEX_PACKS" : "#APEX_PACK" )
			}
		}

		rarityIcon = GRXPack_GetOpenButtonIcon( packFlav )
	}

	RTKApexPacksOpenPackButtonData openPackButtonDataStruct

	openPackButtonDataStruct.packCountText = string( lootBoxCount )
	openPackButtonDataStruct.availablePacksText = lootBoxCount < totalPackCount ? string( totalPackCount ) : ""
	openPackButtonDataStruct.title = buttonText
	openPackButtonDataStruct.description = descText
	openPackButtonDataStruct.icon = rarityIcon
	openPackButtonDataStruct.state = lootBoxCount > 0 ? eEventPackPurchaseButtonState.AVAILABLE : eEventPackPurchaseButtonState.UNAVAILABLE

	rtk_struct openPackButtonModelStruct = RTKStruct_GetOrCreateScriptStruct( apexPackModelStruct, "openPackButtonData", "RTKApexPacksOpenPackButtonData" )
	RTKStruct_SetValue( openPackButtonModelStruct, openPackButtonDataStruct )
}


void function UpdateVisuals( rtk_behavior self, rtk_struct apexPackModelStruct )
{
	UpdateGiftButton( self, apexPackModelStruct )
	UpdateOpenPackButton( self, apexPackModelStruct )
}

void function InitApexPacksPanelFooterOptions( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_GIFT_INFO_TITLE", "#GIFT_INFO_TITLE", OpenGiftInfoPopUpWithEventTabTelemetry, ShouldShowGiftingFooter )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM_CODE", "#REDEEM_CODE_TEXT", void function( var button ) : () {
		AdvanceMenu( GetMenu( "CodeRedemptionDialog" ) )
	} )
}