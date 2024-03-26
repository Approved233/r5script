global function OpenPurchaseRerollDialog
global function OpenApexCupPurchaseRerollDialog

const string CHALLENGE_REROLL_SOUND = "UI_Menu_Challenge_ReRoll"

struct
{
	ItemFlavor& rerollChallenge
	var sourceChallengeButton
	var sourceChallengeMenu
} file


void function RerollDialog_OnClickRerollButton( int challengeType )
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( activeBattlePass == null )
		return

	expect ItemFlavor( activeBattlePass )

	ItemFlavor rerollFlav = BattlePass_GetRerollFlav( activeBattlePass )

	if ( ItemFlavor_IsItemDisabledForGRX( rerollFlav ) )
		return

	ItemFlavor challenge = file.rerollChallenge
	var clickedButton = file.sourceChallengeButton
	var sourceMenu = file.sourceChallengeMenu

	int tier             = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
	string challengeText = Challenge_GetDescription( challenge, tier )
	challengeText = StripRuiStringFormatting( challengeText )

	if ( challengeType != eChallengeGameMode.INVALID )
	{
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

			var rui = Hud_GetRui( clickedButton )
			PurchaseDialogConfig pdc
			pdc.flav = rerollFlav
			pdc.messageOverride = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
			pdc.quantity = numNeeded
			pdc.markAsNew = false
			pdc.onPurchaseResultCallback = void function( bool wasSuccessful ) : ( challenge, rui, sourceMenu, challengeType ) {
				if ( sourceMenu == null )
					JumpToChallenges( "" )

				if ( wasSuccessful )
				{
					Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", ItemFlavor_GetGUID( challenge ) )
					delaythread( 1.65 ) ShimmerChallenge( rui, sourceMenu )
				}
			}

			PurchaseDialog( pdc )
		}
		else
		{
			ConfirmDialogData data
			data.headerText = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
			data.messageText = "#REROLL_NO_CHOICE_MESSAGE"
			data.resultCallback = void function( int result ) {
				if ( result == eDialogResult.YES )
				{
					ResetFreeChallenge()
				}
			}

			OpenConfirmDialogFromData( data )
		}
	}
}

void function ResetFreeChallenge()
{
	var sourceMenu = file.sourceChallengeMenu
	ItemFlavor challenge = file.rerollChallenge
	var clickedButton = file.sourceChallengeButton

	if ( sourceMenu == null )
		JumpToChallenges( "" )

	Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", ItemFlavor_GetGUID( challenge ) )
	var rui = Hud_GetRui( clickedButton )
	ShimmerChallenge( rui, sourceMenu )
}

void function ShimmerChallenge( var rui, var menu )
{
	if ( menu == null )
		return

	if ( GetActiveMenu() != menu )
		return

	RuiSetGameTime( rui, "rerollAnimStartTime", ClientTime() )
	EmitUISound( CHALLENGE_REROLL_SOUND )
}

void function OpenPurchaseRerollDialog( ItemFlavor challenge, var sourceButton, var sourceMenu )
{
	file.rerollChallenge = challenge
	file.sourceChallengeButton = sourceButton
	file.sourceChallengeMenu = sourceMenu

	RerollDialog_OnClickRerollButton( eChallengeGameMode.ANY )
}

void function OpenApexCupPurchaseRerollDialog( ItemFlavor reRoll, string cupName, CupEntry entry )
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	int numTokens = maxint( GRX_GetConsumableCount( ItemFlavor_GetGRXIndex( reRoll ) ), 0 )

	if ( numTokens > entry.reRollCount )
	{
		Remote_ServerCallFunction( "ClientCallback_ReRollCup", entry.cupID )
		return
	}

	PurchaseDialogConfig pdc
	pdc.flav = reRoll
	pdc.messageOverride = cupName
	pdc.quantity = 1
	pdc.markAsNew = false
	pdc.isCupsReRoll = true
	pdc.entry = entry

	PurchaseDialog( pdc )
}