global function RTKLegendUpgradeTree_OnInitialize
global function RTKLegendUpgradeTree_OnDestroy
global function RTKLegendUpgradeTree_SetCharacter
global function RTKLegendUpgradeTree_SetCharacterByGUID
global function RTKLegendUpgradeTree_SetTitleVisibility
global function RTKLegendUpgradeTree_SetDescriptionVisibility
global function RTKLegendUpgradeTree_IsInteractable
global function RTKMutator_AlphaFromUpgradeState
global function RTKMutator_HideIfNotSelected
global function RTKMutator_UpgradesToolTipIsActive
global function RTKMutator_ToolTipActionTextVisible
global function RTKMutator_PickTooltipAction

global enum eTreeUpgradeState
{
	LOCKED,
	SELECTABLE,
	SELECTED,
	NOT_SELECTED,
	_COUNT,
}

global struct RTKLegendUpgradeTree_Properties
{
	string characterGUID
	rtk_panel tierList
}

struct PrivateData
{
	string charGuid
	rtk_array treeTierArray
}

global struct RTKUpgradeCoreChoiceModel
{
	string title
	string shortDesc
	string desc
	asset icon
	int state
	int quality = 1
	bool isSelectable
	bool isLocked
}

global struct RTKLegendUpgradeEvoShieldModel
{
	int quality = 1
	int state = 2
	int level = 1
	bool isLocked
}

global struct RTKLegendUpgradeTreeTierModel
{
	bool isInteractable
	bool hasUpgrades
	bool showTitle
	bool showDescription
	RTKLegendUpgradeEvoShieldModel& evoShield
	RTKUpgradeCoreChoiceModel& leftUpgrade
	RTKUpgradeCoreChoiceModel& rightUpgrade
}

struct
{
	bool showTitle = false
	bool showDescription = false
	bool isInteractable = false
	bool isSelectingUpgrade = false
	bool forceUpdate = false
} file

const float HOLD_TO_SELECT_UPGRADE_TIME = 0.4
const string LEGEND_UPGRADES_TREE_DATA_MODEL_NAME = "legendUpgradeTree"
const string SHIELD_MODEL_NAME = "evoShield"

void function RTKLegendUpgradeTree_OnInitialize( rtk_behavior self )
{
	if ( !UpgradeCore_IsEnabled() )
		return

	if( UpgradeCore_AreUpgradesLocked() )
		return

	PrivateData p
	self.Private( p )

	rtk_struct legendUpgradeTree = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_TREE_DATA_MODEL_NAME )
	if ( !RTKStruct_HasProperty(legendUpgradeTree,"isVisible" ) )
	{
		RTKStruct_AddProperty( legendUpgradeTree, "isVisible", RTKPROP_BOOL )
	}
	p.treeTierArray = RTKStruct_GetOrCreateScriptArrayOfStructs( legendUpgradeTree, string( self.GetInternalId() ), "RTKLegendUpgradeTreeTierModel" )

	RTKLegendUpgradeTree_PopulateLegendUpgradeTree( self )
	RTKStruct_AddPropertyListener( self.GetProperties(), "characterGUID", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		string charGuid = self.PropGetString( "characterGUID" )
		RTKLegendUpgradeTree_PopulateLegendUpgradeTree( self, file.forceUpdate && charGuid != "" ) 
	} )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_COMMON, string( self.GetInternalId() ), true, [ "legendUpgradeTree" ] ) )

	RegisterSignal( "RTKLegendUpgradeTree_OnDestroy" )
}

void function RTKLegendUpgradeTree_OnDestroy( rtk_behavior self )
{
	if ( !UpgradeCore_IsEnabled() )
		return

	
	rtk_struct legendUpgradeTree = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_TREE_DATA_MODEL_NAME )

	if ( RTKStruct_HasProperty( legendUpgradeTree, string( self.GetInternalId() ) ) )
	{
		RTKStruct_RemoveProperty( legendUpgradeTree, string( self.GetInternalId() ) )
	}

	Signal( uiGlobal.signalDummy, "RTKLegendUpgradeTree_OnDestroy" )
	file.isSelectingUpgrade = false
	file.isInteractable = false
}

void function RTKLegendUpgradeTree_PopulateUpgrade( int tier, int upgradesIndex, rtk_struct treeTierStruct, ItemFlavor character )
{
	entity player = GetLocalClientPlayer()

	array<UpgradeCoreChoice> upgrades = UpgradeCore_GetUpgradesForCharacter( character )
	rtk_struct upgradeStruct = RTKStruct_GetOrCreateScriptStruct( treeTierStruct, upgradesIndex % 2 == 0 ? "leftUpgrade" : "rightUpgrade", "RTKUpgradeCoreChoiceModel" )

	if ( upgrades.len() > upgradesIndex )
	{
		RTKStruct_SetString( upgradeStruct, "title", upgrades[ upgradesIndex ].title )
		RTKStruct_SetString( upgradeStruct, "desc", upgrades[ upgradesIndex ].desc )
		RTKStruct_SetString( upgradeStruct, "shortDesc", upgrades[ upgradesIndex ].shortDesc )
		RTKStruct_SetAssetPath( upgradeStruct, "icon", upgrades[ upgradesIndex ].icon )
		RTKStruct_SetInt( upgradeStruct, "quality", tier == 3 ? 5 : tier + 1 )
		RTKStruct_SetBool( upgradeStruct, "isSelectable", UpgradeCore_IsUpgradeSelectable( player, upgradesIndex ) )

		
		
		int state = eTreeUpgradeState.LOCKED
		if ( file.isInteractable )
		{
			
			
			if ( UpgradeCore_IsUpgradeSelectable( player, upgradesIndex ) )
			{
				state = eTreeUpgradeState.SELECTABLE
			}
			else
			{
				
				if ( UpgradeCore_IsUpgradeSelected( player, upgradesIndex ) )
				{
					state = eTreeUpgradeState.SELECTED
				}
				else
				{
					
					
					state = UpgradeCore_GetPlayerLevel( player ) >= tier ? eTreeUpgradeState.NOT_SELECTED : eTreeUpgradeState.LOCKED
				}
			}
		}
		else
		{
			state = eTreeUpgradeState.SELECTED
		}

		RTKStruct_SetInt( upgradeStruct, "state", state )
		RTKStruct_SetBool( upgradeStruct, "isLocked", state == eTreeUpgradeState.LOCKED )
	}
}

void function RTKLegendUpgradeTree_PopulateLegendUpgradeTree( rtk_behavior self, bool forceUpdate = false )
{
	if ( !UpgradeCore_IsEnabled() )
		return

	PrivateData p
	self.Private( p )

	entity player = GetLocalClientPlayer()

	string charGuid = self.PropGetString( "characterGUID" )
	if ( ( charGuid == "" || charGuid == p.charGuid ) && forceUpdate == false )
		return

	p.charGuid = charGuid
	file.forceUpdate = false

	SettingsAssetGUID characterGuid = ConvertItemFlavorGUIDStringToGUID( p.charGuid )
	if ( !IsValidItemFlavorGUID( characterGuid ) )
	{
		Assert( false, "The provided GUID isn't valid" )
		return
	}

	ItemFlavor character = GetItemFlavorByGUID( characterGuid )
	array<UpgradeCoreChoice> upgrades = UpgradeCore_GetUpgradesForCharacter( character )

	array< RTKLegendUpgradeTreeTierModel > legendUpgradeTreeArray = []
	for( int i = 0; i < 4; i++ )
	{
		RTKLegendUpgradeTreeTierModel treeTier
		legendUpgradeTreeArray.push( treeTier )
	}

	rtk_array treeTierArray = p.treeTierArray
	RTKArray_SetValue( treeTierArray, legendUpgradeTreeArray )

	
	for( int i = 1; i < RTKArray_GetCount( treeTierArray ); i++ )
	{
		rtk_struct treeTierStruct = RTKArray_GetStruct( treeTierArray, i )
		int upgradesIndex = ( i - 1 ) * 2

		RTKLegendUpgradeTree_PopulateUpgrade( i, upgradesIndex, treeTierStruct, character )
		RTKLegendUpgradeTree_PopulateUpgrade( i, upgradesIndex + 1, treeTierStruct, character )

		RTKStruct_SetBool( treeTierStruct, "hasUpgrades", i != 3 )
		RTKStruct_SetBool( treeTierStruct, "showTitle", file.showTitle )
		RTKStruct_SetBool( treeTierStruct, "showDescription", file.showDescription )

		rtk_struct evoShieldStruct  = RTKStruct_GetOrCreateScriptStruct(treeTierStruct, SHIELD_MODEL_NAME, "RTKLegendUpgradeEvoShieldModel")
		RTKStruct_SetInt( evoShieldStruct, "quality", i == 3 ? 5 : i + 1 )
		RTKStruct_SetInt( evoShieldStruct, "level", i + 1 )
		int state = UpgradeCore_GetPlayerLevel( player ) >= i || !file.isInteractable ? eTreeUpgradeState.SELECTED : eTreeUpgradeState.LOCKED
		RTKStruct_SetInt( evoShieldStruct, "state", state )
		RTKStruct_SetBool( evoShieldStruct, "isLocked", state == eTreeUpgradeState.LOCKED )
	}

	if ( file.isInteractable )
	{
		rtk_panel tierList = self.PropGetPanel( "tierList" )
		self.AutoSubscribe( tierList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self, player ) {
			rtk_behavior ornull leftSkillButton = newChild.FindChildByName( "LeftSkill" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior ornull rightSkillButton = newChild.FindChildByName( "RightSkill" ).FindBehaviorByTypeName( "Button" )
			array< rtk_behavior ornull > tierButtons = [ leftSkillButton, rightSkillButton ]

			foreach( int i, button in tierButtons )
			{
				if ( button != null )
				{
					expect rtk_behavior( button )
					self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, i, newChildIndex, player ) {
						int position = ( ( newChildIndex - 1 ) * 2 ) + i
						if ( keycode == BUTTON_SHOULDER_RIGHT || keycode == MOUSE_MIDDLE )
						{
							if ( IsFullyConnected() && !IsLobby() && Remote_ServerCallFunctionAllowed() )
							{
								RunClientScript("UIToClient_PingUpgrade", position)
							}
						}
						else
						{

							if( position < 0 )
								return


							if ( UpgradeCore_IsUpgradeSelectable(player, position ) )
							{
								thread RTKLegendUpgradeTree_HoldToSelectUpgrade( self, button, position, keycode )
							}
						}
					} )

					self.AutoSubscribe( button, "onHighlighted", function( rtk_behavior button, int prevState ) : ( self ) {
						OnUpgradeTreeEnableNavigation( false )
					} )

					self.AutoSubscribe( button, "onIdle", function( rtk_behavior button, int prevState ) : ( self ) {
						OnUpgradeTreeEnableNavigation( true )
					} )
				}
			}
		} )
	}
}

void function RTKLegendUpgradeTree_HoldToSelectUpgrade( rtk_behavior self, rtk_behavior button, int position, int keycode )
{
	EndSignal( uiGlobal.signalDummy, "RTKLegendUpgradeTree_OnDestroy" )
	float endTime = ClientTime() + HOLD_TO_SELECT_UPGRADE_TIME

	while( ClientTime() < endTime )
	{
		button.GetPanel().FindBehaviorByName( "Hold" ).SetActive( file.isSelectingUpgrade )
		if ( !InputIsButtonDown( keycode ) || !button.PropGetBool( "isPressed" ) )
		{
			file.isSelectingUpgrade = false
			break
		}

		file.isSelectingUpgrade = true
		WaitFrame()
	}


	OnThreadEnd(
		function() : ( self, button, position )
		{
			if ( file.isSelectingUpgrade )
			{
				RunClientScript( "UpgradeCore_SelectOption", position )
				RTKLegendUpgradeTree_PopulateLegendUpgradeTree( self, true )
			}
			file.isSelectingUpgrade = false
			button.GetPanel().FindBehaviorByName( "Hold" ).SetActive( file.isSelectingUpgrade )
		}
	)
}


void function RTKLegendUpgradeTree_SetCharacter( ItemFlavor character, bool forceUpdate = false )
{
	if ( forceUpdate )
		file.forceUpdate = true

	rtk_struct legendUpgradeTree = RTKDataModelType_GetOrCreateStruct( RTK_MODELTYPE_COMMON, LEGEND_UPGRADES_TREE_DATA_MODEL_NAME )

	if ( !RTKStruct_HasProperty(legendUpgradeTree,"characterGUID" ) )
	{
		RTKStruct_AddProperty( legendUpgradeTree, "characterGUID", RTKPROP_STRING )
	}

	RTKStruct_SetString( legendUpgradeTree, "characterGUID",ItemFlavor_GetGUIDString( character ) )
	RTKStruct_SetBool( legendUpgradeTree, "isVisible",true )
}

void function RTKLegendUpgradeTree_SetCharacterByGUID( int characterGUID, bool forceUpdate = false )
{
	RTKLegendUpgradeTree_SetCharacter(GetItemFlavorByGUID( characterGUID ), forceUpdate )
}

void function RTKLegendUpgradeTree_SetTitleVisibility( bool isVisible )
{
	file.showTitle = isVisible
}

void function RTKLegendUpgradeTree_SetDescriptionVisibility( bool isVisible )
{
	file.showDescription = isVisible
}

void function RTKLegendUpgradeTree_IsInteractable( bool isInteractable )
{
	file.isInteractable = isInteractable
}


float function RTKMutator_AlphaFromUpgradeState( int input, float minAlpha, float maxAlpha )
{
	switch (input)
	{
		case eTreeUpgradeState.LOCKED:
		case eTreeUpgradeState.NOT_SELECTED:
			return minAlpha
		case eTreeUpgradeState.SELECTED:
		case eTreeUpgradeState.SELECTABLE:
			return maxAlpha
	}

	Assert( false, "Unexistent state sent to AlphaFromUpgradeState mutator!" )
	unreachable
}

bool function RTKMutator_HideIfNotSelected( int input )
{
	return input != eTreeUpgradeState.NOT_SELECTED
}

bool function RTKMutator_UpgradesToolTipIsActive( int input )
{
	if ( file.showTitle || file.showDescription )
		return false

	switch ( input )
	{
		case 2:
		case 3:
			return true
		case 1:
		case 5:
		case 4:
		default:
			return false
	}

	Assert( false, "Unexistent quality sent to UpgradesToolTip mutator!" )
	unreachable
}

bool function RTKMutator_ToolTipActionTextVisible( int input )
{
	return file.isInteractable && ( input == eTreeUpgradeState.LOCKED || input == eTreeUpgradeState.SELECTABLE || input == eTreeUpgradeState.SELECTED )
}

string function RTKMutator_PickTooltipAction( int input )
{
	switch( input )
	{
		case eTreeUpgradeState.LOCKED:
			return "#CORE_UPGRADE_REQUEST_TOOLTIP"
		case eTreeUpgradeState.SELECTABLE:
			return "#CORE_UPGRADE_HOLD_TO_SELECT_TOOLTIP"
		case eTreeUpgradeState.SELECTED:
			return "#CORE_UPGRADE_PING_TOOLTIP"
	}
	return ""
}


