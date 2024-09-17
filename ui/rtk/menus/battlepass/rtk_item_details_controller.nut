
global function RTKItemDetailsControllerPanel_OnInitialize
global function RTKItemDetailsControllerPanel_OnDestroy
global function RTKItemDetailsControllerPanel_SetItem

global struct RTKItemDetailsControllerPanel_Properties
{

}

global struct RTKItemDetailsControllerPanel_ModelStruct
{

}

global struct RTKItemDetailsModelStruct
{
	int quality
	bool isOwned
	string qualityLabel
	vector qualityColor
	string title
	string subTitle
	string packRarityLabel
	bool packDetailsVisible
	string extraItemDescription
}

struct PrivateData
{

}

void function RTKItemDetailsControllerPanel_SetItem( rtk_behavior self, BattlePassReward bpReward, string modelRoot = "menus", string modelName = "itemDetails", bool elitePassPrompt = true )
{
	rtk_struct itemInspectStruct = RTKDataModelType_GetOrCreateStruct( modelRoot, modelName, "RTKItemDetailsControllerPanel_ModelStruct" )
	rtk_struct itemDetails = RTKStruct_GetOrCreateScriptStruct( itemInspectStruct, "item", "RTKItemDetailsModelStruct" )

	if ( self != null)
	{
		self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( modelRoot, modelName, true ) )
	}

	ItemFlavor item = bpReward.flav

	int itemType = ItemFlavor_GetType( item )
	int grxMode = ItemFlavor_GetGRXMode( item )

	RTKItemDetailsModelStruct itemInfo
	itemInfo.isOwned = (itemType == eItemType.character) ? ( Character_IsCharacterOwnedByPlayer( item ) || Character_IsCharacterUnlockedForCalevent( item ))
		: ( grxMode != GRX_ITEMFLAVORMODE_REGULAR  ) ? false
		: GRX_IsItemOwnedByPlayer( item )
	int quality = GRX_GetRarityOverrideFromQuantity( item, ItemFlavor_GetQuality( item ), bpReward.quantity ) 
	vector qualityColor = GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, maxint(0, quality) + 1 ) / 255.0
	itemInfo.quality = quality
	itemInfo.qualityColor = qualityColor
	itemInfo.qualityLabel = (itemType == eItemType.character) ? "#NEWPLAYERPASS_LEGEND_UNLOCK" : Localize( ItemQuality_GetQualityName( quality ) ).toupper()
	itemInfo.title = ItemFlavor_GetLongName( item )
	itemInfo.subTitle = ( grxMode != GRX_ITEMFLAVORMODE_REGULAR  ) ? "" : GetLocalizedItemFlavorDescriptionForOfferButton( item, false )
	itemInfo.packDetailsVisible = ( itemType == eItemType.account_pack )
	if ( itemType == eItemType.character_skin )
	{

		ItemFlavor ornull associatedItem = GetItemFlavorAssociatedCharacterOrWeapon( item )
		if ( elitePassPrompt && associatedItem != null )
		{
			expect ItemFlavor( associatedItem )
			ItemFlavor ornull activePass = GetActiveBattlePassV2()
			if ( activePass != null )
			{
				expect ItemFlavor( activePass )
				bool hasUltimatePlusPass = DoesPlayerOwnBattlePassTier( GetLocalClientPlayer(), activePass, eBattlePassV2OwnershipTier.ULTIMATE_PLUS )
				if ( ItemFlavor_GetType( associatedItem ) == eItemType.character
					&& !hasUltimatePlusPass
					&& ( !Character_IsCharacterOwnedByPlayer( associatedItem ) && !Character_IsCharacterUnlockedForCalevent( associatedItem ))
				)
				{
					itemInfo.extraItemDescription = "#BATTLEPASS_PLAYABLE_WITH_ULTIMATE_PLUS"
				}
			}
		}

	}
	else
	{
		itemInfo.extraItemDescription = (itemType == eItemType.character) ? "#NEWPLAYERPASS_LEGEND_UNLOCK_DESC_0"
		: (itemType == eItemType.account_flag) ? "#NEWPLAYERPASS_BOT_LEGEND_UNLOCK_DESC_0"
		: ""
	}
	itemInfo.packRarityLabel = ( itemType == eItemType.account_pack )
		? ( itemInfo.quality == 3 ? "#APEX_PACK_PROBABILITIES_LEGENDARY" : ( itemInfo.quality == 2 ? "#APEX_PACK_PROBABILITIES_EPIC" : (itemInfo.quality == 1 ? "#APEX_PACK_PROBABILITIES_RARE" : "?") ) )
		: ""

	RTKStruct_SetValue( itemDetails, itemInfo )
}

void function RTKItemDetailsControllerPanel_OnInitialize( rtk_behavior self )
{

}

void function RTKItemDetailsControllerPanel_OnDestroy( rtk_behavior self )
{

}
