global function RTKBaseEventLandingPanel_OnInitialize
global function RTKBaseEventLandingPanel_OnDestroy

global struct RTKBaseEventLandingPanel_Properties
{
	rtk_panel buttonsPanel
}

global struct RTKBaseEventLandingPageModel
{
	RTKBaseEventLandingTitleData& titleData
	RTKBaseEventLandingSubtitleData& subtitleData
	asset titleImage
	int endTime
}

struct
{
	ItemFlavor ornull activeEvent
}file

void function RTKBaseEventLandingPanel_OnInitialize( rtk_behavior self )
{
	rtk_struct landingPanel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "landingPage", "RTKBaseEventLandingPageModel" )

	BuildLandingPanelInfo( landingPanel )
	BuildLandingButtonsDataModel( landingPanel )

	SetUpLandingButtons( self )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "landingPage", true ) )
}

void function RTKBaseEventLandingPanel_OnDestroy( rtk_behavior self )
{
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "landingPage" )
}

void function BuildLandingPanelInfo( rtk_struct landingPanelModel )
{
	file.activeEvent = GetActiveBaseEvent( GetUnixTimestamp() )
	if ( file.activeEvent != null )
	{
		ItemFlavor ornull event = file.activeEvent
		expect ItemFlavor(event)

		RTKBaseEventLandingPageModel generalModel
		generalModel.endTime = CalEvent_GetFinishUnixTime( event )
		generalModel.titleData = BaseEvent_GetLandingPageTitleData( event )
		generalModel.subtitleData = BaseEvent_GetLandingPageSubtitleData( event )
		generalModel.titleImage = BaseEvent_GetLandingPageImage( event )
		RTKStruct_SetValue( landingPanelModel, generalModel )

		rtk_struct titleData = RTKStruct_GetStruct( landingPanelModel, "titleData" )
		RTKStruct_AddProperty( titleData, "outlineInnerColor", RTKPROP_FLOAT4 )
		RTKStruct_SetFloat4( titleData, "outlineInnerColor", BaseEvent_GetLandingPageTitleOutlineInnerColor( event ), BaseEvent_GetLandingPageTitleOutlineInnerAlpha( event ) )
		RTKStruct_AddProperty( titleData, "outlineOuterColor", RTKPROP_FLOAT4 )
		RTKStruct_SetFloat4( titleData, "outlineOuterColor", BaseEvent_GetLandingPageTitleOutlineOuterColor( event ), BaseEvent_GetLandingPageTitleOutlineOuterAlpha( event ) )
	}
}

void function BuildLandingButtonsDataModel( rtk_struct landingPanelModel )
{
	if ( file.activeEvent == null )
		return

	ItemFlavor ornull event = file.activeEvent
	expect ItemFlavor(event)

	array<BaseEventLandingPageButtonData> buttonsData = BaseEvent_GetLandingPageButtonData( event )
	rtk_array landingButtonsData = RTKStruct_GetOrCreateScriptArrayOfStructs( landingPanelModel, "buttonData", "BaseEventLandingPageButtonData" )
	RTKArray_SetValue( landingButtonsData, buttonsData )
}

void function SetUpLandingButtons( rtk_behavior self )
{
	rtk_panel ornull buttonsPanel = self.PropGetPanel( "buttonsPanel" )
	if ( buttonsPanel != null )
	{
		expect rtk_panel( buttonsPanel )
		self.AutoSubscribe( buttonsPanel, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ) {

			ItemFlavor ornull event = file.activeEvent
			expect ItemFlavor(event)
			array<BaseEventLandingPageButtonData> buttonsData = BaseEvent_GetLandingPageButtonData( event )

			array< rtk_behavior > buttonBehaviors = newChild.FindBehaviorsByTypeName( "Button" )
			foreach( button in buttonBehaviors )
			{
				self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex, buttonsData ) {
					switch ( buttonsData[newChildIndex].pageRedirectEnum )
					{
						case eEventLandingPageButtonRedirect.LANDING:
							EventsPanel_GoToPage( eEventsPanelPage.LANDING )
							break

						case eEventLandingPageButtonRedirect.COLLECTION_EVENT:
							EventsPanel_GoToPage( eEventsPanelPage.COLLECTION_EVENT )
							break

						case eEventLandingPageButtonRedirect.MILESTONES:
							EventsPanel_GoToPage( eEventsPanelPage.MILESTONES )
							break
						case eEventLandingPageButtonRedirect.COLLECTION:
							EventsPanel_GoToPage( eEventsPanelPage.COLLECTION )
							break
						case eEventLandingPageButtonRedirect.EVENT_SHOP:
							EventsPanel_GoToPage( eEventsPanelPage.EVENT_SHOP )
							break
						case eEventLandingPageButtonRedirect.EVENT_STORE:
							ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
							if ( activeThemedShopEvent != null )
							{
								JumpToEventTab( "ThemedShopPanel" )
							}
							OpenPromoLink( "storeOfferShop", "#VOID_RECKONING_STORE" )
							break
						case eEventLandingPageButtonRedirect.PLAY_MODE:
							OpenGameModeSelectDialog()
							break
						case eEventLandingPageButtonRedirect.VGUI_PRIZE_TRACKER: 

							EventsPanel_GoToPage( eEventsPanelPage.PRIZE_TRACKER )














							break
						case eEventLandingPageButtonRedirect.CUSTOM_DEEPLINK:
							OpenPromoLink( buttonsData[newChildIndex].customDeeplinkType, buttonsData[newChildIndex].customDeeplink )
						break
					}
				} )
			}
		} )
	}
}