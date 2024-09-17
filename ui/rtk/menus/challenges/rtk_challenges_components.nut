
global function RTKChallengeBlock_OnInitialize
global function RTKChallengeBlock_OnDestroy
global function RTKChallengeBlock_OnHoverEnter
global function RTKChallengeBlock_RefreshHighlightStatus
global function RTKChallengeListItem_OnInitialize
global function RTKChallengeListItem_OnHoverEnter
global function RTKChallengeRerollButton_OnInitialize
global function RTKMutator_ChallengeIsCurrentBlockIndex
global function RTKMutator_CanRerollChallenge


global function RTKChallenges_GetTileChallengeModeTagData
global function RTKChallenges_GetChallengeModeTagData
global function RTKChallenges_GetBlockChallengeModeTagData
global function RTKChallenges_GetChallengeDataModelStructName
global function RTKChallenges_GetChallengeListItemButtonDisplayType
global function RTKChallenges_IsItemFlavForPreview

global struct RTKChallengeBlock_Properties
{
	rtk_behavior buttonBehavior

	string pathToPanelModel
	int index
	bool isCurrentChallengeBlock

	void functionref() onClick
}

struct BlockPrivateData
{
	int propertyListenerID
}

global struct RTKChallengeListItem_Properties
{
	rtk_behavior buttonBehavior

	void functionref() onClick
	void functionref() onRewardInspected
	void functionref() onHighlighted
}

global struct RTKChallengeRerollButton_Properties
{
	rtk_behavior buttonBehavior
}

global struct RTKChallengeModeTagModel
{
	vector tagColor
	string tagString
}

global struct RTKChallengeAltItemModel
{
	string description
	int currentProgress = 4
	int maxProgress = 15
}

global struct RTKChallengeItemModel
{
	int challengeItemType = 0
	string description
	string title 
	string progressText
	bool isTracked = false

	int currentProgress = 4
	int maxProgress = 15

	bool isBRMode = false
	bool isNBRMode = false
	bool isCompleted
	bool isInfinite

	asset rewardIcon = $"ui_image/white.rpak"
	int rewardQuantity = 0
	string rewardString = "+1"
	int currentTier
	int maxTier
	int rewardItemGUID
	int challengeGUID
}

global struct RTKChallengeItemEitherOrItemModel
{
	string altDescription = "ALT"
	int altCurrentProgress = 1
	int altMaxProgress = 4
	bool isBRMode = false
	bool isNBRMode = false
}

global struct RTKChallengeItemNarrativeModel
{
	string altDescription
	asset previewImage
}

global struct RTKChallengeTileModel
{
	string title
	int endTime
	int category
	int progressionDisplayType
	string timerFormat
	asset customTimerIconAssetPath
	string highlightReward
	asset backgroundImage

	bool isPinned
	bool isTracked
	bool isNewTag
	bool isBRMode
	bool isNBRMode
	bool hasNarratives
	bool isCompleted
}

global struct RTKChallengeBlockModel
{
	int index
	int blockType

	bool isPinned = false
	bool isTracked = false
	bool isNewTag = true
	bool isLocked
	bool isCompleted
	bool isShortBlock
	string title
	string rewards

	string progressText

	int endTime
	int startTime

	bool isBRMode = true
	bool isNBRMode = true
	bool hasNarratives
	bool isMetaBlock

	string pathToPanelModel
	array<string> lockReason
	array<bool> lockReasonAvailable
	array<bool> lockReasonCompleted
}

global enum eChallengeListItemButtonType
{
	BASIC,
	META,
	EITHER,
	NARRATIVE
}

void function RTKChallengeBlock_OnInitialize( rtk_behavior self )
{
	rtk_behavior button = self.PropGetBehavior( "buttonBehavior" )

	if ( button == null )
		return

	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		RTKChallengeBlock_OnClick( self )
	} )

	RTKStruct_AddPropertyListener( self.GetProperties(), "pathToPanelModel", void function( rtk_struct rtkStruct, string propertyName, int type, var value ) : ( self ) {

		string pathToModel = self.PropGetString( "pathToPanelModel" )
		int index = self.PropGetInt( "index" )
		rtk_struct screenModelStruct = RTKDataModel_GetStruct( pathToModel )

		if ( screenModelStruct == null )
			return

		int propertyListenerID = RTKStruct_AddPropertyListener( screenModelStruct, "challengeBlockIndex", void function( rtk_struct rtkStruct, string propertyName, int type, var value ) : ( self ) {
			RTKChallengeBlock_RefreshHighlightStatus( self )
		} )

		self.AddPropertyCallback( "index", RTKChallengeBlock_RefreshHighlightStatus )

		BlockPrivateData p
		self.Private( p )
		p.propertyListenerID = propertyListenerID
	} )
}

void function RTKChallengeBlock_OnDestroy( rtk_behavior self )
{
	BlockPrivateData p
	self.Private( p )

	Signal( uiGlobal.signalDummy, "OnChallengeBlockIdle" )
	string pathToModel = self.PropGetString( "pathToPanelModel" )
	if ( RTKDataModel_HasDataModel( pathToModel ) )
	{
		rtk_struct screenModelStruct = RTKDataModel_GetStruct( pathToModel )
		RTKStruct_RemovePropertyListener( screenModelStruct, "challengeBlockIndex", p.propertyListenerID )
	}
}


void function RTKChallengeBlock_OnHoverEnter( rtk_behavior self )
{
	thread RTKChallengeBlock_DelayedIndexUpdate( self )
}

const float MAX_TIME_ON_BUTTON = 0.2
void function RTKChallengeBlock_DelayedIndexUpdate( rtk_behavior self )
{
	Signal( uiGlobal.signalDummy, "OnChallengeBlockIdle" )
	EndSignal( uiGlobal.signalDummy, "OnChallengeBlockIdle" )
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	string pathToModel = self.PropGetString( "pathToPanelModel" )
	rtk_struct screenModelStruct = RTKDataModel_GetStruct( pathToModel )
	if ( screenModelStruct == null )
		return
	int index = self.PropGetInt( "index" )

	float startTime = UITime()
	vector previousPosition = GetCursorPosition()
	UISize screenSize = GetScreenSize()

	while( self.PropGetInt( "index" ) != RTKStruct_GetInt( screenModelStruct, "challengeBlockIndex" ) )
	{
		WaitFrame()
		vector newPosition = GetCursorPosition()
		float xMovement = float( abs( int( newPosition.x - previousPosition.x ) ) )
		float yMovement = float( abs( int( newPosition.y - previousPosition.y ) ) )
		previousPosition = newPosition

		float velocity = xMovement + yMovement
		float now = UITime()
		if ( velocity < 0.5 || startTime + MAX_TIME_ON_BUTTON <= now )
		{
			RTKStruct_SetInt( screenModelStruct, "challengeBlockIndex", index )
			break
		}
	}
}


void function RTKChallengeBlock_OnClick( rtk_behavior self )
{
	self.InvokeEvent( "onClick" )
}

void function RTKChallengeBlock_RefreshHighlightStatus( rtk_behavior self )
{
	string path = self.PropGetString( "pathToPanelModel" )
	if ( !RTKDataModel_HasDataModel( path ) )
		return
	rtk_struct screenModelStruct = RTKDataModel_GetStruct( path )
	int currentBlockIndex = RTKStruct_GetInt( screenModelStruct, "challengeBlockIndex" )
	int index = self.PropGetInt( "index" )

	bool isCurrentBlock = currentBlockIndex == self.PropGetInt( "index" )
	self.PropSetBool( "isCurrentChallengeBlock", isCurrentBlock )
}

void function RTKChallengeListItem_OnInitialize( rtk_behavior self )
{
	rtk_behavior button = self.PropGetBehavior( "buttonBehavior" )

	if ( button == null )
		return

	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		self.InvokeEvent( "onClick" )
		if ( keycode == MOUSE_LEFT || keycode == BUTTON_A )
		{
			RTKChallengeListItem_OnClick( self )
		}
		else if ( keycode == MOUSE_RIGHT || keycode == BUTTON_X )
		{
			RTKChallengeListItem_OnRightClick( self )
		}
		else if ( keycode == BUTTON_Y )
		{
			RTKChallengeListItem_OnYPressed( self )
		}
	} )
}


void function RTKChallengeListItem_OnHoverEnter( rtk_behavior self )
{

}


void function RTKChallengeListItem_OnClick( rtk_behavior self )
{
	string modelPath = self.GetPanel().GetBindingRootPath()
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_struct challengeModel = RTKDataModel_GetStruct( modelPath )
		int rewardGUID = RTKStruct_GetInt( challengeModel, "rewardItemGUID" )
		if ( IsValidItemFlavorGUID( rewardGUID ) )
		{
			ItemFlavor item = GetItemFlavorByGUID( rewardGUID )
			if ( RTKChallenges_IsItemFlavForPreview( item ) )
			{
				self.InvokeEvent( "onRewardInspected" )
				if ( CanRunClientScript() )
					RunClientScript( "ClearBattlePassItem" )
				SetChallengeRewardPresentationModeActive( GetItemFlavorByGUID( rewardGUID ), 1, -1, "#CHALLENGE_REWARD", "", true )
			}
		}
	}
}


void function RTKChallengeListItem_OnYPressed( rtk_behavior self )
{
	string modelPath = self.GetPanel().GetBindingRootPath()
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_struct challengeModel = RTKDataModel_GetStruct( modelPath )
		int challengeGUID = RTKStruct_GetInt( challengeModel, "challengeGUID" )
		if ( IsValidItemFlavorGUID( challengeGUID ) )
		{
			ItemFlavor flavor = GetItemFlavorByGUID( challengeGUID )
			if ( Challenge_PlayerCanRerollChallenge( GetLocalClientPlayer(), flavor ) )
			{
				RTKChallengeRerollButton_ReRollPressed( self )
			}
		}
	}
}


void function RTKChallengeListItem_TrackChallenge( string modelPath )
{
	rtk_struct challengeModel = RTKDataModel_GetStruct( modelPath )
	int challengeGUID = RTKStruct_GetInt( challengeModel, "challengeGUID" )
	ItemFlavor challenge = GetItemFlavorByGUID( challengeGUID )

	bool isFavorite = IsFavoriteChallenge( challenge )
	int challengeDataPos = modelPath.find( ".challengeData" )
	if ( GetFavoriteChallenges( GetLocalClientPlayer() ).len() == 5 )
	{
		
		RTKStruct_SetBool( challengeModel, "isTracked", false )
	}
	else
	{
		string blockModelPath = modelPath.slice( 0, challengeDataPos )
		if ( RTKDataModel_HasDataModel( blockModelPath ) )
		{
			int favChallengesCount = 0
			rtk_struct blockModel = RTKDataModel_GetStruct( blockModelPath )

			rtk_array blockChallenges = RTKStruct_GetArray( blockModel, "challengeData" )
			for ( int j = 0; j < RTKArray_GetCount( blockChallenges ); j++ )
			{
				rtk_struct blockChallenge = RTKArray_GetStruct( blockChallenges, j )
				int blockChallengeGUID = RTKStruct_GetInt( blockChallenge, "challengeGUID" )
				if ( IsFavoriteChallenge( GetItemFlavorByGUID( blockChallengeGUID ) ) )
					favChallengesCount++
			}

			if ( favChallengesCount == 0 )
				RTKStruct_SetBool( blockModel , "isTracked", true )
			else if ( favChallengesCount == 1 )
				RTKStruct_SetBool( blockModel , "isTracked", !isFavorite )
		}
		RTKStruct_SetBool( challengeModel, "isTracked", !isFavorite )
	}
	Remote_ServerCallFunction( "ClientCallback_ToggleFavoriteChallenge", challengeGUID )
}

void function RTKChallengeListItem_OnRightClick( rtk_behavior self )
{
	string modelPath = self.GetPanel().GetBindingRootPath()
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_struct challengeModel = RTKDataModel_GetStruct( modelPath )
		int challengeGUID = RTKStruct_GetInt( challengeModel, "challengeGUID" )
		ItemFlavor challenge = GetItemFlavorByGUID( challengeGUID )

		if ( Challenge_IsNarrativeChallenge( challenge ) )
		{
			Narrative_ActivateRadioPlay( challenge )
		}
		else if ( IsChallengeValidAsFavorite( GetLocalClientPlayer(), challenge ) )
		{
			RTKChallengeListItem_TrackChallenge( modelPath )
		}
	}
}

void function RTKChallengeRerollButton_OnInitialize( rtk_behavior self )
{
	rtk_behavior button = self.PropGetBehavior( "buttonBehavior" )
	if ( button == null )
		return

	self.AutoSubscribe( button, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self ) {
		RTKChallengeRerollButton_ReRollPressed( self )
	} )
}

void function RTKChallengeRerollButton_ReRollPressed( rtk_behavior self )
{
	string modelPath = self.GetPanel().GetBindingRootPath()
	if ( RTKDataModel_HasDataModel( modelPath ) )
	{
		rtk_struct challengeModel = RTKDataModel_GetStruct( modelPath )
		int challengeGUID = RTKStruct_GetInt( challengeModel, "challengeGUID" )
		if ( IsValidItemFlavorGUID( challengeGUID ) )
		{
			ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
			if ( activeBattlePass == null )
				return
			expect ItemFlavor( activeBattlePass )
			ItemFlavor rerollFlav = BattlePass_GetRerollFlav( activeBattlePass )
			if ( ItemFlavor_IsItemDisabledForGRX( rerollFlav ) )
				return

			ItemFlavor challenge = GetItemFlavorByGUID( challengeGUID )
			int tier             = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
			string challengeText = Challenge_GetDescription( challenge, tier )
			challengeText = StripRuiStringFormatting( challengeText )

			int numTokens         = maxint( GRX_GetConsumableCount( ItemFlavor_GetGRXIndex( rerollFlav ) ), 0 )
			int tokensUsed        = maxint( GetPersistentVarAsInt( "challengeRerollsUsed" ), 0 )

			Assert( tokensUsed <= numTokens )
			int currentDailyRerollCount = maxint( GetPersistentVarAsInt( "dailyRerollCount" ), 0 )
			int numNeeded               = CHALLENGE_REROLL_COSTS[ minint( currentDailyRerollCount, CHALLENGE_REROLL_COSTS.len() - 1 ) ]

			if ( numTokens - tokensUsed < numNeeded && numNeeded > 0 ) 
			{
				ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( challenge )

				GRXScriptOffer offer
				array<GRXScriptOffer> offers
				foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
					foreach ( GRXScriptOffer locationOffer in locationOfferList )
						offers.append( locationOffer )

				PurchaseDialogConfig pdc
				pdc.flav = rerollFlav
				pdc.messageOverride = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
				pdc.quantity = numNeeded
				pdc.markAsNew = false
				pdc.onPurchaseResultCallback = void function( bool wasSuccessful ) : ( challengeGUID ) {
					if ( wasSuccessful )
					{
						Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", challengeGUID )
						EmitUISound( CHALLENGE_REROLL_SOUND )
					}
				}
				PurchaseDialog( pdc )
			}
			else
			{
				ConfirmDialogData data
				data.headerText     = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
				data.messageText    = "#REROLL_NO_CHOICE_MESSAGE"
				data.resultCallback = void function( int result ) : ( challengeGUID ) {
					if ( result == eDialogResult.YES )
					{
						Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", challengeGUID )
						EmitUISound( CHALLENGE_REROLL_SOUND )
					}
				}
				OpenConfirmDialogFromData( data )
			}
		}
	}
}

bool function RTKMutator_ChallengeIsCurrentBlockIndex( int input, string pathToModel )
{
	rtk_struct screenModelStruct = RTKDataModel_GetStruct( pathToModel )
	int currentIndex = RTKStruct_GetInt( screenModelStruct, "challengeBlockIndex" )

	return input == currentIndex
}

bool function RTKMutator_CanRerollChallenge( int input )
{
	if ( IsValidItemFlavorGUID( input ) )
	{
		entity localPlayer = GetLocalClientPlayer()
		ItemFlavor challenge = GetItemFlavorByGUID( input )
		return Challenge_PlayerCanRerollChallenge( localPlayer, challenge )
	}
	return false
}

array<RTKChallengeModeTagModel> function RTKChallenges_GetTileChallengeModeTagData( ChallengeTile tile )
{
	array<RTKChallengeModeTagModel> tileTags = RTKChallenges_TagTableToArray( RTKChallenges_GetTileChallengeModeTagTable( tile ) )
	return tileTags
}

array<RTKChallengeModeTagModel> function RTKChallenges_GetBlockChallengeModeTagData( ChallengeBlock block )
{
	array<RTKChallengeModeTagModel> blockTags = RTKChallenges_TagTableToArray( RTKChallenges_GetBlockChallengeModeTagTable( block ) )
	return blockTags
}

RTKChallengeModeTagModel function RTKChallenges_GetChallengeModeTagData( ItemFlavor challenge, bool getAlt = false )
{
	RTKChallengeModeTagModel tag
	int gameMode = Challenge_GetGameMode( challenge )
	tag.tagColor = Challenge_GetGameModeTagColor( gameMode )
	tag.tagString = Challenge_GetGameModeTag( gameMode )
	return tag
}

table<string, RTKChallengeModeTagModel> function RTKChallenges_GetTileChallengeModeTagTable( ChallengeTile tile )
{
	table<string, RTKChallengeModeTagModel> tileTags
	foreach( ChallengeBlock block in tile.blocks )
	{
		table<string, RTKChallengeModeTagModel> blockTags = RTKChallenges_GetBlockChallengeModeTagTable( block )
		foreach( tagString, tag in blockTags )
		{
			if( !( tagString in tileTags ) )
			{
				tileTags[ tagString ] <- tag
			}
		}
	}
	return tileTags
}

table<string, RTKChallengeModeTagModel> function RTKChallenges_GetBlockChallengeModeTagTable( ChallengeBlock block )
{
	table<string, RTKChallengeModeTagModel> blockTags
	foreach( ItemFlavor challenge in block.challenges )
	{
		RTKChallengeModeTagModel tag = RTKChallenges_GetChallengeModeTagData( challenge )
		if ( !( tag.tagString in blockTags ) )
		{
			blockTags[ tag.tagString ] <- tag
		}

		if ( Challenge_IsEitherOr( challenge ) )
		{
			RTKChallengeModeTagModel altTag = RTKChallenges_GetChallengeModeTagData( challenge, true )
			if ( !( altTag.tagString in blockTags ) )
			{
				blockTags[ altTag.tagString ] <- altTag
			}
		}
	}
	return blockTags
}

array<RTKChallengeModeTagModel> function RTKChallenges_TagTableToArray( table<string, RTKChallengeModeTagModel> tagTable )
{
	array<RTKChallengeModeTagModel> tags
	foreach ( tagModel in tagTable )
	{
		tags.append( tagModel )
	}
	return tags
}

int function RTKChallenges_GetChallengeListItemButtonDisplayType( ItemFlavor challenge )
{
	if ( Challenge_IsEitherOr( challenge ) )
	{
		return eChallengeListItemButtonType.EITHER
	}
	else if ( Challenge_IsMetaChallenge( challenge ) )
	{
		return eChallengeListItemButtonType.META
	}
	else if ( Challenge_IsNarrativeChallenge( challenge ) )
	{
		return eChallengeListItemButtonType.NARRATIVE
	}
	return eChallengeListItemButtonType.BASIC
}

string function RTKChallenges_GetChallengeDataModelStructName( int challengeListType )
{
	switch ( challengeListType )
	{
		case eChallengeListItemButtonType.BASIC:
		case eChallengeListItemButtonType.META:
			return "RTKChallengeItemModel"
		case eChallengeListItemButtonType.EITHER:
			return "RTKChallengeItemEitherOrItemModel"
		case eChallengeListItemButtonType.NARRATIVE:
			return "RTKChallengeItemNarrativeModel"
	}
	unreachable
}

bool function RTKChallenges_IsItemFlavForPreview( ItemFlavor item )
{
	if ( ItemFlavor_GetType( item ) == eItemType.voucher && GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "model" ) == $"" )
	{
		
		if ( Voucher_GetEffectBattlepassStars( item ) > 0 || Voucher_GetEffectBattlepassLevels( item ) > 0 )
		{
			return true
		}
		else
		{
			return false
		}
	}
	else
	{
		return true
	}
	return false
}