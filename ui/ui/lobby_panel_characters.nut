global function InitCharactersPanel

global function JumpToCharactersTab
global function JumpToCharacterCustomize
global function OpenPurchaseCharacterDialogFromTop

struct
{
	var                    	panel
	var                    	characterSelectInfoRui
	var					   	lobbyClassPerkInfoRui
	array<var>             	buttons
	var						topLegendRowAnchor
	var						botLegendRowAnchor
	var		   				assaultShelf
	var		   				skirmisherShelf
	var		   				reconShelf
	var		   				supportShelf
	var		   				controllerShelf
	var		   				assaultShelfRUI
	var		   				skirmisherShelfRUI
	var		   				reconShelfRUI
	var		   				supportShelfRUI
	var		   				controllerShelfRUI
	array<var>             	roleButtons_Assault
	array<var>             	roleButtons_Skirmisher
	array<var>             	roleButtons_Recon
	array<var>             	roleButtons_Defense
	array<var>             	roleButtons_Support
	table<var, ItemFlavor> 	buttonToCharacter
	table<ItemFlavor, var>  characterToButton
	ItemFlavor ornull	   	presentedCharacter
	InputDef&				giftFooter

	InputDef&				upgradesFooter
	var						lobbyCharacterInfoRTK

	bool 					featuredalwaysOwned

	bool 					registeredInputs = false
} file

struct CharacterToolTipIconConfig
{
	asset topRightIcon = $""
	asset bottomLeftIcon = $""
	bool topRightIconInactive = false
}

void function InitCharactersPanel( var panel )
{
	file.panel = panel


	file.lobbyCharacterInfoRTK = Hud_GetChild( file.panel, "LobbyLegendSkillPerkInfo" )

	file.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "LobbyClassLegendInfo" ) )
	file.lobbyClassPerkInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "LobbyClassPerkInfo" ) )
	file.assaultShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "assaultShelf" ))
	file.skirmisherShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "SkirmisherShelf" ))
	file.reconShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "reconShelf" ))
	file.supportShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "supportShelf" ))
	file.controllerShelfRUI = Hud_GetRui(Hud_GetChild( file.panel, "controllerShelf" ))



	file.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )
	file.roleButtons_Assault = GetPanelElementsByClassname( panel, "AssaultCharacterRoleButtonClass" )
	file.roleButtons_Skirmisher = GetPanelElementsByClassname( panel, "SkirmisherCharacterRoleButtonClass" )
	file.roleButtons_Recon = GetPanelElementsByClassname( panel, "ReconCharacterRoleButtonClass" )
	file.roleButtons_Defense = GetPanelElementsByClassname( panel, "DefenseCharacterRoleButtonClass" )
	file.roleButtons_Support = GetPanelElementsByClassname( panel, "SupportCharacterRoleButtonClass" )
	file.topLegendRowAnchor = Hud_GetChild( panel, "Top_List_Anchor" )
	file.botLegendRowAnchor = Hud_GetChild( panel, "Bot_List_Anchor" )
	file.assaultShelf = Hud_GetChild( file.panel, "assaultShelf" )
	file.skirmisherShelf = Hud_GetChild( file.panel, "SkirmisherShelf" )
	file.reconShelf = Hud_GetChild( file.panel, "reconShelf" )
	file.supportShelf = Hud_GetChild( file.panel, "supportShelf" )
	file.controllerShelf = Hud_GetChild( file.panel, "controllerShelf" )

	SetPanelTabTitle( panel, "#LEGENDS" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharactersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharactersPanel_OnHide )
	AddPanelEventHandler( Hud_GetParent( panel ), eUIEvent.PANEL_HIDE, CharactersPanel_OnParentHide )
	AddPanelEventHandler_FocusChanged( panel, CharactersPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Assault )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Skirmisher )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Recon )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Defense )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	foreach ( button in file.roleButtons_Support )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BUTTON_MARK_ALL_AS_SEEN_GAMEPAD", "#BUTTON_MARK_ALL_AS_SEEN_MOUSE", MarkAllCharacterItemsAsViewed, CharacterButtonNotFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, IsCharacterButtonFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_TOGGLE_LOADOUT", "#X_BUTTON_TOGGLE_LOADOUT", OpenFocusedCharacterSkillsDialog, IsCharacterPresented )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FEATURED", "#Y_BUTTON_SET_FEATURED", SetFeaturedCharacterFromFocus, IsReadyAndNonfeaturedCharacterButtonFocused )

		file.upgradesFooter = AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, true, "", "", null )






	file.giftFooter = AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "", "", null )
}

bool function IsFocusedCharacterLocked()
{
	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return !Character_IsCharacterOwnedByPlayer( file.buttonToCharacter[focus] )

	return false
}

bool function IsReadyAndNonfeaturedCharacterButtonFocused()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return file.buttonToCharacter[focus] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	return false
}

bool function CharacterButtonNotFocused()
{
	return !IsCharacterButtonFocused()
}


bool function IsCharacterButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
		return true

	if ( file.roleButtons_Assault.contains( GetFocus() )
			|| file.roleButtons_Skirmisher.contains( GetFocus() )
			|| file.roleButtons_Recon.contains( GetFocus() )
			|| file.roleButtons_Defense.contains( GetFocus() )
			|| file.roleButtons_Support.contains( GetFocus() ))
		return true

	return false
}

bool function IsCharacterPresented()
{
	return file.presentedCharacter != null
}



void function SetFeaturedCharacter( ItemFlavor character )
{
	
	if ( !Character_IsCharacterOwnedByPlayer( character ) && !Character_IsCharacterUnlockedForCalevent( character ) )
		return


		foreach ( button in file.roleButtons_Assault )
		{
			if ( button in file.buttonToCharacter )
				Hud_SetSelected( button, file.buttonToCharacter[button] == character )
		}
		foreach ( button in file.roleButtons_Skirmisher )
		{
			if ( button in file.buttonToCharacter )
				Hud_SetSelected( button, file.buttonToCharacter[button] == character )
		}
		foreach ( button in file.roleButtons_Recon )
		{
			if ( button in file.buttonToCharacter )
				Hud_SetSelected( button, file.buttonToCharacter[button] == character )
		}
		foreach ( button in file.roleButtons_Defense )
		{
			if ( button in file.buttonToCharacter )
				Hud_SetSelected( button, file.buttonToCharacter[button] == character )
		}
		foreach ( button in file.roleButtons_Support )
		{
			if ( button in file.buttonToCharacter )
				Hud_SetSelected( button, file.buttonToCharacter[button] == character )
		}








	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )

	file.featuredalwaysOwned = ItemFlavor_GetGRXMode( character ) == eItemFlavorGRXMode.NONE
	Character_UpdateFooter()

	EmitUISound( "UI_Menu_Legend_SetFeatured" )
}

void function MarkAllCharacterItemsAsViewed( var button )
{
	if ( MarkAllItemsOfTypeAsViewed( eItemTypeUICategory.CHARACTER ) )
		EmitUISound( "UI_Menu_Accept" )
	else
		EmitUISound( "UI_Menu_Deny" )
}

void function OpenPurchaseCharacterDialogFromFocus( var button )
{
	if ( !GRX_IsInventoryReady() )
		return

	if ( IsSocialPopupActive() )
		return


	if( file.presentedCharacter != null )
	{
		var focus = file.characterToButton[ expect ItemFlavor ( file.presentedCharacter ) ]

		if( focus == null )
			OpenPurchaseCharacterDialogFromLoadout( focus )

		OpenPurchaseCharacterDialogFromButton( focus )
	}

}

void function OpenPurchaseCharacterDialogFromTop( var button )
{
	if (  !GRX_IsInventoryReady() )
		return

	if ( IsSocialPopupActive() )
		return

	PurchaseDialogConfig pdc

	if ( !Character_IsCharacterOwnedByPlayer(GetTopLevelCustomizeContext() ) )
	{
		pdc.flav = GetTopLevelCustomizeContext()
		pdc.quantity = 1
		PurchaseDialog( pdc )
	}
	else
	{
		pdc.offer = GRX_GetItemDedicatedStoreOffers( GetTopLevelCustomizeContext(), "character" )[0]
		PurchaseDialog( pdc )
	}
}

void function OpenPurchaseCharacterDialogFromButton( var button )
{
	if ( button in file.buttonToCharacter )
	{
		if ( ItemFlavor_GetGRXMode( file.buttonToCharacter[button] ) == eItemFlavorGRXMode.NONE )
			return

		PurchaseDialogConfig pdc

		if ( !Character_IsCharacterOwnedByPlayer( file.buttonToCharacter[button] ) )
		{
			pdc.flav = file.buttonToCharacter[button]
			pdc.quantity = 1
			pdc.onPurchaseResultCallback = void function( bool wasPurchaseSuccessful ) : ( button ) {

					CharacterClassButton_Init( button, file.buttonToCharacter[button] , false, wasPurchaseSuccessful )

			}

			PurchaseDialog( pdc )
		}
		else
		{
			pdc.offer = GRX_GetItemDedicatedStoreOffers( file.buttonToCharacter[button], "character" )[0]
			PurchaseDialog( pdc )
		}
	}

	EmitUISound( "menu_accept" )
}

void function OpenPurchaseCharacterDialogFromLoadout( var button )
{
	PurchaseDialogConfig pdc

	if ( !file.presentedCharacter )
		return

	if ( !Character_IsCharacterOwnedByPlayer( expect ItemFlavor ( file.presentedCharacter ) ) )
	{
		pdc.flav = Loadout_Character().defaultItemFlavor
		pdc.quantity = 1
		pdc.onPurchaseResultCallback = void function( bool wasPurchaseSuccessful ) : ( button ) {

				CharacterClassButton_Init( button, expect ItemFlavor ( file.presentedCharacter ) , false )

		}

		PurchaseDialog( pdc )
	}
	else
	{
		pdc.offer = GRX_GetItemDedicatedStoreOffers( expect ItemFlavor ( file.presentedCharacter ), "character" )[0]
		PurchaseDialog( pdc )
	}

	EmitUISound( "menu_accept" )
}

void function SetFeaturedCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		SetFeaturedCharacter( file.buttonToCharacter[button] )
}

void function SetFeaturedCharacterFromFocus( var button )
{
	if ( IsSocialPopupActive() )
		return

	var focus = GetFocus()

	SetFeaturedCharacterFromButton( focus )
}


void function OpenFocusedCharacterSkillsDialog( var button )
{
	if ( !file.presentedCharacter )
		return

	OpenCharacterSkillsDialog( expect ItemFlavor ( file.presentedCharacter ) )
}


void function CharacterButton_OnQKey( var button )
{
	if ( !file.presentedCharacter )
		return

	OpenCharacterUpgradesDialog( expect ItemFlavor ( file.presentedCharacter ) )
}


void function InitCharacterButtons()
{
	file.buttonToCharacter.clear()
	file.characterToButton.clear()

	foreach ( button in file.buttons )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Assault )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Skirmisher )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Recon )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Defense )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Support )
	{
		Hud_SetVisible( button, false )
		Hud_ReturnToBaseScaleOverTime( button, 0.0, INTERPOLATOR_DEACCEL )
	}

	array<ItemFlavor> characters
	foreach ( ItemFlavor itemFlav in GetAllCharacters() )
	{
		bool isAvailable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), itemFlav )
		if ( !isAvailable )
		{
			if ( !ItemFlavor_ShouldBeVisible( itemFlav, GetLocalClientPlayer() ) )
				continue
		}

		characters.append( itemFlav )
	}

	array<ItemFlavor> orderedCharacters = GetCharacterButtonOrder( characters, file.buttons.len() )
	array<var> characterButtons


	int listGap = 90
	int buttonGap = 6
	int buttonWidth = 77

	float scaleFrac = GetScreenScaleFrac()

	int assaultLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ).len()
	int skirmisherLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SKIRMISHER ).len()
	int reconLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ).len()
	int supportLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ).len()
	int defenderLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ).len()

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ) )
	{
		var button = file.roleButtons_Assault[index]
		CharacterClassButton_Init( button, character )
		int offset = (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int topListOffset1 = (assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap) + listGap

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SKIRMISHER ) )
	{
		var button = file.roleButtons_Skirmisher[index]
		CharacterClassButton_Init( button, character )
		int offset = topListOffset1 + (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ) )
	{
		var button = file.roleButtons_Recon[index]
		CharacterClassButton_Init( button, character )
		int offset = (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int botListOffset1 = (reconLegendsAmount * buttonWidth) + ( (reconLegendsAmount - 1) * buttonGap) + listGap

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ) )
	{
		var button = file.roleButtons_Support[index]
		CharacterClassButton_Init( button, character )
		int offset = botListOffset1 + (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int botListOffset2 = botListOffset1 + (supportLegendsAmount * buttonWidth) + ( (supportLegendsAmount - 1) * buttonGap) + listGap

	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ) )
	{
		var button = file.roleButtons_Defense[index]
		CharacterClassButton_Init( button, character )
		int offset = botListOffset2 + (buttonWidth * index) + (buttonGap * index)
		Hud_SetX( button, offset * scaleFrac)
	}

	int topListFullWidth = (assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap) + listGap + (skirmisherLegendsAmount * buttonWidth) + ( (skirmisherLegendsAmount - 1) * buttonGap)
	int botListFullWidth = botListOffset2 + (defenderLegendsAmount * buttonWidth) + ( (defenderLegendsAmount - 1) * buttonGap)

	Hud_SetX( file.topLegendRowAnchor, -(topListFullWidth/2) * scaleFrac)
	Hud_SetX( file.botLegendRowAnchor, -(botListFullWidth/2) * scaleFrac)

	RuiSetFloat( file.assaultShelfRUI, "shelfWidth", float((assaultLegendsAmount * buttonWidth) + ( (assaultLegendsAmount - 1) * buttonGap)))
	RuiSetColorAlpha( file.assaultShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(1)), 1.0)
	RuiSetString( file.assaultShelfRUI, "roleString", "#ROLE_ASSAULT" )
	RuiSetImage( file.assaultShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_offense" )

	RuiSetFloat( file.skirmisherShelfRUI, "shelfWidth", float((skirmisherLegendsAmount * buttonWidth) + ( (skirmisherLegendsAmount - 1) * buttonGap)))
	RuiSetColorAlpha( file.skirmisherShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(2)), 1.0)
	RuiSetString( file.skirmisherShelfRUI, "roleString", "#ROLE_SKIRMISHER" )
	RuiSetImage( file.skirmisherShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_skirmisher" )

	RuiSetFloat( file.reconShelfRUI, "shelfWidth", float((reconLegendsAmount * buttonWidth) + ( (reconLegendsAmount - 1) * buttonGap)))
	RuiSetColorAlpha( file.reconShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(3)), 1.0)
	RuiSetString( file.reconShelfRUI, "roleString", "#ROLE_RECON" )
	RuiSetImage( file.reconShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_recon" )

	RuiSetFloat( file.supportShelfRUI, "shelfWidth", float((supportLegendsAmount * buttonWidth) + ( (supportLegendsAmount - 1) * buttonGap)))
	RuiSetColorAlpha( file.supportShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(5)), 1.0)
	RuiSetString( file.supportShelfRUI, "roleString", "#ROLE_SUPPORT" )
	RuiSetImage( file.supportShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_support" )

	RuiSetFloat( file.controllerShelfRUI, "shelfWidth", float((defenderLegendsAmount * buttonWidth) + ( (defenderLegendsAmount - 1) * buttonGap)))
	RuiSetColorAlpha( file.controllerShelfRUI, "shelfColor", SrgbToLinear(CharacterClass_GetRoleColor(4)), 1.0)
	RuiSetString( file.controllerShelfRUI, "roleString", "#ROLE_CONTROLLER" )
	RuiSetImage( file.controllerShelfRUI, "roleIcon", $"rui/menu/character_select/utility/role_defense" )

	Hud_SetX( file.assaultShelf, (-buttonWidth/2) * scaleFrac)
	Hud_SetX( file.skirmisherShelf, (topListOffset1 -buttonWidth/2) * scaleFrac)
	Hud_SetX( file.reconShelf, (-buttonWidth/2) * scaleFrac)
	Hud_SetX( file.supportShelf, (botListOffset1 -buttonWidth/2) * scaleFrac)
	Hud_SetX( file.controllerShelf, (botListOffset2 -buttonWidth/2) * scaleFrac)

	SetPerkLayoutNav( orderedCharacters )














}

void function SetPerkLayoutNav (array<ItemFlavor> orderedCharacters)
{
	int assaultLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ).len()
	int skirmisherLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SKIRMISHER ).len()
	int reconLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ).len()
	int supportLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ).len()
	int defenderLegendsAmount = GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ).len()

	

	
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.OFFENSE ) )
	{
		var button = file.roleButtons_Assault[index]

		
		if (index < assaultLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Assault[index + 1])
		else
			Hud_SetNavRight(button, file.roleButtons_Skirmisher[0])

		
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Assault[index - 1])

		
		if ( index <= reconLegendsAmount - 1 )
			Hud_SetNavDown(button, file.roleButtons_Recon[0])
		else
			Hud_SetNavDown(button, file.roleButtons_Support[0])
	}

	
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SKIRMISHER ) )
	{
		var button = file.roleButtons_Skirmisher[index]

		
		if (index < skirmisherLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Skirmisher[index + 1])

		
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Skirmisher[index - 1])
		else if( assaultLegendsAmount > 0 )
			Hud_SetNavLeft(button, file.roleButtons_Assault[assaultLegendsAmount - 1])

		
		if ( index >= skirmisherLegendsAmount - defenderLegendsAmount )
			Hud_SetNavDown(button, file.roleButtons_Defense[0])
		else if( supportLegendsAmount > 0 )
			Hud_SetNavDown(button, file.roleButtons_Support[supportLegendsAmount - 1])
	}

	
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.RECON ) )
	{
		var button = file.roleButtons_Recon[index]
		
		if (reconLegendsAmount <= assaultLegendsAmount)
			Hud_SetNavUp(button, file.roleButtons_Assault[0])
		else if( assaultLegendsAmount > 0 )
			Hud_SetNavUp(button, file.roleButtons_Assault[assaultLegendsAmount - 1])

		
		if (index < reconLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Recon[index + 1])
		else
			Hud_SetNavRight(button, file.roleButtons_Support[0])

		
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Recon[index - 1])
	}

	
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.SUPPORT ) )
	{
		var button = file.roleButtons_Support[index]
		
		if (index <= (supportLegendsAmount-1)/2 && assaultLegendsAmount > 0)
			Hud_SetNavUp(button, file.roleButtons_Assault[assaultLegendsAmount -1])
		else
			Hud_SetNavUp(button, file.roleButtons_Skirmisher[0])

		
		if (index < supportLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Support[index + 1])
		else
			Hud_SetNavRight(button, file.roleButtons_Defense[0])

		
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Support[index - 1])
		else if( reconLegendsAmount > 0 )
			Hud_SetNavLeft(button, file.roleButtons_Recon[reconLegendsAmount - 1])
	}

	
	foreach ( index, character in GetCharactersByRole( orderedCharacters, eCharacterClassRole.DEFENSE ) )
	{
		var button = file.roleButtons_Defense[index]
		
		if (defenderLegendsAmount <= skirmisherLegendsAmount)
			Hud_SetNavUp(button, file.roleButtons_Skirmisher[skirmisherLegendsAmount - 1])
		else
			Hud_SetNavUp(button, file.roleButtons_Skirmisher[0])

		
		if (index < defenderLegendsAmount -1)
			Hud_SetNavRight(button, file.roleButtons_Defense[index + 1])

		
		if (index != 0)
			Hud_SetNavLeft(button, file.roleButtons_Defense[index - 1])
		else if( supportLegendsAmount > 0 )
			Hud_SetNavLeft(button, file.roleButtons_Support[supportLegendsAmount - 1])
	}
}

void function CharacterButton_Init( var button, ItemFlavor character )
{
	SeasonStyleData seasonStyle = GetSeasonStyle()

	file.buttonToCharacter[button] <- character
	file.characterToButton[character] <- button

	
	
	bool isLocked   = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )
	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() ) == character

	Hud_SetVisible( button, true )
	Hud_SetLocked( button, !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), character ) )
	Hud_SetSelected( button, isSelected )

	RuiSetColorAlpha( Hud_GetRui( button ), "seasonColor", SrgbToLinear( seasonStyle.seasonNewColor ), 1.0 )
	RuiSetString( Hud_GetRui( button ), "buttonText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetImage( Hud_GetRui( button ), "buttonImage", CharacterClass_GetGalleryPortrait( character ) )
	RuiSetImage( Hud_GetRui( button ), "bgImage", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetImage( Hud_GetRui( button ), "roleImage", CharacterClass_GetCharacterRoleImage( character ) )
	




















	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
}


void function CharacterClassButton_Init( var button, ItemFlavor character, bool addNewness = true, bool forceOwned = false)
{
	Hud_SetVisible( button, true )
	file.buttonToCharacter[button] <- character
	file.characterToButton[character] <- button

	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() ) == character

	Hud_SetVisible( button, true )
	bool isPlayable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )
	bool isOwned = Loadout_IsCharacterOwnedByPlayerIngoringUnlockSources( FromEHI( LocalClientEHI() ), character ) || forceOwned

	if ( forceOwned )
	{
		Hud_SetLocked( button, false )
	}
	else
	{
		Hud_SetLocked( button, !isPlayable )
	}

	Hud_SetSelected( button, isSelected )

	
	var buttonRui = Hud_GetRui( button )
	RuiSetImage( buttonRui, "portraitImage", CharacterClass_GetGalleryPortrait( character ) )
	RuiSetImage( buttonRui, "portraitBackground", CharacterClass_GetGalleryRoleBackground( character ) )
	RuiSetString( buttonRui, "portraitName", Localize( ItemFlavor_GetLongName( character ) ) )
	RuiSetImage( buttonRui, "roleImage", CharacterClass_GetCharacterRoleImage( character ) )

	bool isUnlockedByBP2 = Character_IsUnlockedForBattlePassV2( GetLocalClientPlayer(), character )
	bool isUnlockableInNPP = Character_IsUnlockableInNewPlayerPass( character )

	if ( addNewness )
	{
		Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
	}

	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.NONE
	asset topRightIcon = $""
	bool topRightIconInactive = false
	asset bottomLeftIcon = $""

	if ( isUnlockedByBP2 && !isOwned )
	{
		toolTipData.tooltipFlags             = toolTipData.tooltipFlags | eToolTipFlag.SOLID
		toolTipData.tooltipStyle             = eTooltipStyle.BOOSTED
		toolTipData.boostedToolTipData.state = eBoostedToolTipState.UNLOCKED
		toolTipData.titleText                = Localize( "#BPV2_LEGEND_SELECT_TOOLTIP_TITLE_UNLOCKED_BY_PREMIUMPLUS" )
		toolTipData.descText                 = Localize( "#BPV2_LEGEND_SELECT_TOOLTIP_DESC_UNLOCKED_BY_PREMIUMPLUS", Localize( ItemFlavor_GetLongName( character ) ) )
		
		bottomLeftIcon                       = $"rui/menu/character_select/utility/timer_icon"
	}
	else if ( isUnlockableInNPP && !isOwned )
	{
		toolTipData.tooltipFlags             = toolTipData.tooltipFlags | eToolTipFlag.SOLID
		toolTipData.tooltipStyle             = eTooltipStyle.BOOSTED
		toolTipData.boostedToolTipData.state = eBoostedToolTipState.LOCKED
		toolTipData.titleText                = Localize( "#BPV2_LEGEND_SELECT_TOOLTIP_TITLE_UNLOCKABLE_BY_NPP" )
		toolTipData.descText                 = Localize( "#BPV2_LEGEND_SELECT_TOOLTIP_DESC_UNLOCKABLE_BY_NPP", Localize( ItemFlavor_GetLongName( character ) ) )
		topRightIcon                         = $"rui/menu/character_select/utility/npp_icon"
		bottomLeftIcon                       = $""
	}
	else
	{
		CharacterToolTipIconConfig toolTipConfig = CharacterClassButton_InitTempUnlockToolTip( toolTipData, character, isOwned )
		topRightIcon = toolTipConfig.topRightIcon
		topRightIconInactive = toolTipConfig.topRightIconInactive
		bottomLeftIcon = toolTipConfig.bottomLeftIcon
	}

	Hud_SetToolTipData( button, toolTipData )

	RuiSetImage( buttonRui, "topRightIcon", topRightIcon )
	RuiSetImage( buttonRui, "bottomLeftIcon", bottomLeftIcon )
	RuiSetBool( buttonRui, "topRightIconVisible", topRightIcon != $"" )
	RuiSetBool( buttonRui, "topRightIconInactive", topRightIconInactive )
	RuiSetBool( buttonRui, "bottomLeftIconVisible", bottomLeftIcon != $"" )
}

CharacterToolTipIconConfig function CharacterClassButton_InitTempUnlockToolTip( ToolTipData toolTipData, ItemFlavor character, bool isOwned )
{
	CharacterToolTipIconConfig toolTipConfig
	entity player = GetLocalClientPlayer()

	ItemFlavor ornull latestActiveTempUnlock    = TempUnlock_GetLatestActiveEvent( GetUnixTimestamp() )
	ItemFlavor ornull boundingEvent             = latestActiveTempUnlock != null ? TempUnlock_GetParentFlav( expect ItemFlavor( latestActiveTempUnlock ) ) : null
	ItemFlavor ornull activeCharacterTempUnlock = TempUnlock_GetActiveCharacterUnlockEvent( character, boundingEvent )

	
	if ( activeCharacterTempUnlock != null )
	{
		expect ItemFlavor( activeCharacterTempUnlock )
		ItemFlavor ornull characterChallenge = TempUnlock_GetCharacterUnlockChallenge( character )
		if ( characterChallenge != null )
		{
			expect ItemFlavor( characterChallenge )
			int characterChallengeTier 			= minint( Challenge_GetCurrentTier( player, characterChallenge ), Challenge_GetTierCount( characterChallenge ) - 1 )
			int characterChallengeProgressValue = Challenge_GetProgressValue( player, characterChallenge, characterChallengeTier )
			int characterChallengeGoalValue     = Challenge_GetGoalVal( characterChallenge, characterChallengeTier )

			
			toolTipData.actionHint1 = Localize( "#N_N_CHALLENGES_COMPLETED", characterChallengeProgressValue, characterChallengeGoalValue, Localize( ItemFlavor_GetShortName( character ) ) )
			toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.SOLID
			toolTipData.tooltipStyle = eTooltipStyle.BOOSTED

			
			toolTipConfig.bottomLeftIcon = isOwned ? $"" : $"rui/menu/character_select/utility/timer_icon"

			if ( Challenge_IsComplete( GetLocalClientPlayer(), characterChallenge ) ) 
			{
				toolTipData.titleText = Localize( TempUnlock_GetTooltipTitleCompleted( activeCharacterTempUnlock ) )
				toolTipData.descText = Localize( TempUnlock_GetTooltipDescCompleted( activeCharacterTempUnlock ) )
				toolTipData.boostedToolTipData.state = eBoostedToolTipState.COMPLETED
				toolTipConfig.topRightIcon = $"rui/menu/buttons/checked"
			}
			else 
			{
				toolTipData.titleText = Localize( TempUnlock_GetTooltipTitleUnlocked( activeCharacterTempUnlock ) )
				toolTipData.descText = Localize( TempUnlock_GetTooltipDescUnlocked( activeCharacterTempUnlock ) )
				toolTipData.boostedToolTipData.state = eBoostedToolTipState.UNLOCKED
				toolTipConfig.topRightIcon =  $"rui/menu/character_select/utility/legend_challenge_key"
			}
		}
	}
	else if ( !isOwned )
	{
		
		
		
		
		ItemFlavor ornull upcomingCharacterTempUnlock = latestActiveTempUnlock != null ? TempUnlock_GetUpcomingCharacterUnlockEvent( character, boundingEvent ) : null
		if ( upcomingCharacterTempUnlock != null )
		{
			expect ItemFlavor( upcomingCharacterTempUnlock  )
			toolTipData.titleText = Localize( TempUnlock_GetTooltipTitleUpcoming( upcomingCharacterTempUnlock ) )
			toolTipData.descText = Localize( TempUnlock_GetTooltipDescUpcoming( upcomingCharacterTempUnlock ) )
			toolTipData.tooltipStyle = eTooltipStyle.BOOSTED
			toolTipData.boostedToolTipData.state = eBoostedToolTipState.LOCKED
			toolTipConfig.topRightIcon =  $"rui/menu/character_select/utility/legend_challenge_key"
			toolTipConfig.topRightIconInactive = true
		}
	}

	return toolTipConfig
}



void function CharactersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )
	SetTopLevelCustomizeContext( character )
#if PC_PROG_NX_UI
	file.presentedCharacter = null
#endif


	bool showUpgradeTree = UpgradeCore_ShowUpgradeTree_LobbyMenu()
	Hud_SetVisible( file.lobbyCharacterInfoRTK, showUpgradeTree )
	RuiSetBool( file.characterSelectInfoRui, "hidden", showUpgradeTree )
	RuiSetBool( file.lobbyClassPerkInfoRui, "hidden", showUpgradeTree )

	PresentCharacter( character )

	InitCharacterButtons()

	if( !file.registeredInputs )
	{
		RegisterButtonPressedCallback( MOUSE_RIGHT, CharactersPanel_OnRightClick )
		file.registeredInputs = true
	}
}

void function CharactersPanel_OnRightClick( var button )
{
	OpenFocusedCharacterSkillsDialog( button )
}

void function CharactersPanel_OnHide( var panel )
{
	CharactersPanel_ShutDown( panel )
}

void function CharactersPanel_OnParentHide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	if( tabData.tabDefs[tabData.activeTabIdx].panel == Hud_GetChild( panel, "CharactersPanel" ) )
	{
		CharactersPanel_ShutDown( panel )
	}
}

void function CharactersPanel_ShutDown( var panel )
{
	if ( NEWNESS_QUERIES.isValid )
		foreach ( var button, ItemFlavor character in file.buttonToCharacter )
			if ( character in NEWNESS_QUERIES.CharacterButton ) 
				Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )

	SetTopLevelCustomizeContext( null )
	RunMenuClientFunction( "ClearAllCharacterPreview" )
	file.buttonToCharacter.clear()
	file.characterToButton.clear()

	if( file.registeredInputs )
	{
		DeregisterButtonPressedCallback( MOUSE_RIGHT, CharactersPanel_OnRightClick )
		file.registeredInputs = false
	}
}

bool function CharactersPanel_HasDelayedSelectPlaylistVar()
{
	return GetCurrentPlaylistVarBool( "lobby_characters_has_delayed_select", true )
}

void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) 
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	ItemFlavor ornull characterOrNull = null
	if ( file.buttons.contains( newFocus )
			||file.roleButtons_Assault.contains( GetFocus() )
			|| file.roleButtons_Skirmisher.contains( GetFocus() )
			|| file.roleButtons_Recon.contains( GetFocus() )
			|| file.roleButtons_Defense.contains( GetFocus() )
			|| file.roleButtons_Support.contains( GetFocus() ) )
	{
		characterOrNull = file.buttonToCharacter[newFocus]
		if (newFocus != null)
		{
#if PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				Hud_SetZ( newFocus, 700 )
				Hud_ScaleOverTime( newFocus, 1.85, 1.85,0.1, INTERPOLATOR_DEACCEL )
			}
#else
			Hud_ScaleOverTime( newFocus, 1.15, 1.15,0.1, INTERPOLATOR_DEACCEL )
#endif
		}
	}
	else if( !CharactersPanel_HasDelayedSelectPlaylistVar() )
		characterOrNull = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	
	
	foreach ( button in file.buttons )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Assault )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Skirmisher )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Recon )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Defense )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}

	foreach ( button in file.roleButtons_Support )
	{
		if( newFocus != button )
			Hud_ReturnToBaseScaleOverTime( button, 0.1, INTERPOLATOR_DEACCEL )
	}
	

	if ( file.buttons.contains( oldFocus )
			||file.roleButtons_Assault.contains( oldFocus )
			|| file.roleButtons_Skirmisher.contains( oldFocus )
			|| file.roleButtons_Recon.contains( oldFocus )
			|| file.roleButtons_Defense.contains( oldFocus )
			|| file.roleButtons_Support.contains( oldFocus ) )
	{
		if (oldFocus != null)
		{
			Hud_ReturnToBaseScaleOverTime( oldFocus, 0.1, INTERPOLATOR_DEACCEL )
#if PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				Hud_SetZ( oldFocus, 1 )
			}
#endif
		}
	}
	if( characterOrNull != null )
	{
		expect ItemFlavor(characterOrNull)

		if( CharactersPanel_HasDelayedSelectPlaylistVar() )
		{
			thread CharactersPanel_DelayedSelectCharacter( newFocus, characterOrNull )
		}
		else
		{
			PresentCharacter( characterOrNull )
			Character_UpdateFooter()
		}
	}else
	{
		Character_UpdateFooter()
	}

}

const float MAX_TIME_ON_CHAR_BUTTON = 0.2

void function CharactersPanel_DelayedSelectCharacter( var btn, ItemFlavor characterOrNull )
{
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	float startTime = UITime()
	vector previousPosition = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	float screenWidthDiff = screenSize.width / 1920.0
	float screenHeightDiff = screenSize.width / 1080.0

	while( Hud_IsFocused( btn ) )
	{
		WaitFrame()

		vector newPosition = GetCursorPosition()

		float xMovement = float( abs( int( newPosition.x - previousPosition.x ) ) )
		float yMovement = float( abs( int( newPosition.y - previousPosition.y ) ) )

		previousPosition = newPosition

		float velocity = xMovement + yMovement
		
		if( velocity < 0.5 || startTime + MAX_TIME_ON_CHAR_BUTTON <=  UITime())
		{
			printt( ItemFlavor_GetCharacterRef( characterOrNull ) )
			PresentCharacter( characterOrNull )
			break
		}
	}

	Character_UpdateFooter()
}


void function Character_UpdateFooter()
{

		UpdatePanelCharacterUpgradesFooter( file.upgradesFooter )


	UpdateFooterOptions()
	UpdatePanelCharacterGiftFooter( file.giftFooter )
}
void function CharacterButton_OnActivate( var button )
{
	ItemFlavor character = file.buttonToCharacter[button]
	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )

	
	if ( Character_IsCharacterOwnedByPlayer( character ) || Character_IsCharacterUnlockedForCalevent( character ) )
	{
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )
	}

	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}


void function CharacterButton_OnRightClick( var button )
{
	if ( IsSocialPopupActive() && IsControllerModeActive() )
		return

	OpenCharacterSkillsDialog( file.buttonToCharacter[button] )
}


void function CharacterButton_OnMiddleClick( var button )
{
	bool needsToBuy = false 
	if ( button in file.buttonToCharacter )
	{
		ItemFlavor character = file.buttonToCharacter[ button ]

			if ( NPP_ShouldDisableGRXForNPPLegend( GetLocalClientPlayer(), character ) )
			{
				EmitUISound( "menu_deny" )
				return
			}


		
		if ( ItemFlavor_GetGRXMode( file.buttonToCharacter[button] ) == eItemFlavorGRXMode.NONE )
			needsToBuy = false
		else
		{
			
			if ( Character_IsCharacterOwnedByPlayer( character ) )
				needsToBuy = false
			else
				needsToBuy = !Character_IsCharacterUnlockedForCalevent( character )
		}
	}

	if ( needsToBuy )
		OpenPurchaseCharacterDialogFromButton( button )
	else
		SetFeaturedCharacterFromButton( button )
}

void function PresentCharacter( ItemFlavor character )
{
	if ( file.presentedCharacter == character )
		return

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetGUID( characterSkin ), ItemFlavor_GetGUID( character ) )



	if ( UpgradeCore_ShowUpgradeTree_LobbyMenu() )
	{
		RTKCharacterSkillsModel_SetCharacter( character )
		RTKLegendUpgradeTree_SetCharacter( character )
		RTKLegendUpgradeTree_IsInteractable( false )
		RTKLegendUpgradeTree_SetTitleVisibility( false )
		RTKLegendUpgradeTree_SetDescriptionVisibility( false )
	}
	else
	{
		ItemFlavor passiveAbility  = CharacterClass_GetPassiveAbilityToShow( character )
		RuiSetString( file.lobbyClassPerkInfoRui, "classNameString", Localize( CharacterClass_GetRoleTitle (CharacterClass_GetRole( character )).toupper() ) )
		RuiSetString( file.lobbyClassPerkInfoRui, "classFootnoteString", Localize( CharacterClass_GetRoleSubtitle (CharacterClass_GetRole( character )).toupper() ) )
		RuiSetString( file.lobbyClassPerkInfoRui, "perkDescriptionString1", Localize( CharacterClass_GetRolePerkShortDescriptionAtIndex(CharacterClass_GetRole( character ), 0).toupper() ))
		RuiSetString( file.lobbyClassPerkInfoRui, "perkDescriptionString2", Localize( CharacterClass_GetRolePerkShortDescriptionAtIndex(CharacterClass_GetRole( character ), 1).toupper() ))
		RuiSetImage( file.lobbyClassPerkInfoRui, "classIconImage", CharacterClass_GetRoleIcon(CharacterClass_GetRole( character ) ) )
		RuiSetImage( file.lobbyClassPerkInfoRui, "perkIconImage1", CharacterClass_GetRolePerkIconAtIndex(CharacterClass_GetRole( character ), 0 ) )
		RuiSetImage( file.lobbyClassPerkInfoRui, "perkIconImage2", CharacterClass_GetRolePerkIconAtIndex(CharacterClass_GetRole( character ), 1 ) )
		RuiSetFloat( file.lobbyClassPerkInfoRui, "startTime", ClientTime() )
		RuiSetBool ( file.lobbyClassPerkInfoRui, "showPerkInfo", GetCurrentPlaylistVarBool( "charSelect_show_perk_info", true ) )
		RuiSetBool ( file.lobbyClassPerkInfoRui, "showLegendInfo", false )

		RuiSetString( file.characterSelectInfoRui, "nameString", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
		RuiSetString( file.characterSelectInfoRui, "footnoteString", Localize( ItemFlavor_GetShortDescription( character ) ).toupper() )
		RuiSetFloat( file.characterSelectInfoRui, "startTime", ClientTime() )

		RuiSetString( file.characterSelectInfoRui, "passiveNameString", Localize( ItemFlavor_GetLongName( passiveAbility ) ) )
		RuiSetString( file.characterSelectInfoRui, "tacticalNameString", Localize( ItemFlavor_GetLongName( CharacterClass_GetTacticalAbility( character ) ) ) )
		RuiSetString( file.characterSelectInfoRui, "ultimateNameString", Localize( ItemFlavor_GetLongName( CharacterClass_GetUltimateAbility( character ) ) ) )

		RuiSetImage( file.characterSelectInfoRui, "passiveIconImage", ItemFlavor_GetIcon( passiveAbility ) )
		RuiSetImage( file.characterSelectInfoRui, "tacticalIconImage", ItemFlavor_GetIcon( CharacterClass_GetTacticalAbility( character ) ) )
		RuiSetImage( file.characterSelectInfoRui, "ultimateIconImage", ItemFlavor_GetIcon( CharacterClass_GetUltimateAbility( character ) ) )
	}



































	file.presentedCharacter = character
	Character_UpdateFooter()
}

void function JumpToCharactersTab()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "ArmoryPanel" ) )
}

void function JumpToCharacterCustomize( ItemFlavor character )
{
	JumpToCharactersTab()

	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )
	if ( Character_IsCharacterOwnedByPlayer( character ) )
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character ) 
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}

void function UpdatePanelCharacterGiftFooter( InputDef footer )
{
	var focus = GetFocus()
	if ( file.presentedCharacter != null )
	{
		bool alwaysOwnsChar = ( ItemFlavor_GetGRXMode( expect ItemFlavor ( file.presentedCharacter ) ) == eItemFlavorGRXMode.NONE )

		bool isNPPLegend = false


		isNPPLegend = NPP_IsNPPLegend( expect ItemFlavor ( file.presentedCharacter ) )


		if ( alwaysOwnsChar || isNPPLegend )
		{
			footer.gamepadLabel = ""
			footer.mouseLabel = ""
			footer.activateFunc = null
			return
		}

		if ( IsControllerModeActive() )
		{
			footer.input = BUTTON_BACK
		}
		else
		{
			footer.input = KEY_H
		}

		if ( Character_IsCharacterOwnedByPlayer( expect ItemFlavor ( file.presentedCharacter ) ) == false )
		{
			footer.gamepadLabel = Localize( "#BACK_BUTTON_UNLOCK" )
			footer.mouseLabel = Localize( "#BACK_BUTTON_UNLOCK" )
			footer.activateFunc = OpenPurchaseCharacterDialogFromFocus
		}
		else
		{
			footer.gamepadLabel = Localize( "#BACK_BUTTON_GIFT" )
			footer.mouseLabel = Localize( "#BACK_BUTTON_GIFT" )
			footer.activateFunc = OpenPurchaseCharacterDialogFromFocus
		}
	}
	else
	{
		footer.gamepadLabel = ""
		footer.mouseLabel = ""
		footer.activateFunc = null
	}
}


void function UpdatePanelCharacterUpgradesFooter( InputDef footer )
{
	if ( !UpgradeCore_ShowUpgradeTree_SkillsMenu() || !IsCharacterPresented() )
	{
		footer.gamepadLabel = ""
		footer.mouseLabel = ""
		footer.activateFunc = null
		return
	}

	footer.gamepadLabel = Localize( "#RIGHT_STICK_VIEW_UPGRADES" )
	footer.mouseLabel = Localize( "#RIGHT_STICK_VIEW_UPGRADES" )
	footer.activateFunc = CharacterButton_OnQKey

	if ( IsControllerModeActive() )
	{
		footer.input = BUTTON_STICK_RIGHT
	}
	else
	{
		footer.input = KEY_Q
	}
}
      