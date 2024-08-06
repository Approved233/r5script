
global function RadioPlays_GetAnimations
global function RadioPlay_PlayItemFlavor
global function RadioPlay_PlayFromGUIDString



global struct RadioPlayLayerModel
{
	array< asset > ruis = []
	array< float > durations = []
	array< string > sounds = []
}




array< RadioPlayLayerModel > function RadioPlays_GetAnimations( ItemFlavor radioPlay )
{
	Assert( ItemFlavor_GetType( radioPlay ) == eItemType.radio_play )

	array< RadioPlayLayerModel > animations

	foreach ( var layersBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( radioPlay ), "layers" ) )
	{
		RadioPlayLayerModel layerModel

		foreach ( var animationsBlock in IterateSettingsArray( GetSettingsBlockArray( layersBlock, "ruiAnimations" ) ) )
		{
			layerModel.ruis.append( GetKeyValueAsAsset( { kn = GetSettingsBlockString( animationsBlock, "ruiAsset" ) }, "kn" ) )
			layerModel.durations.append( GetSettingsBlockFloat( animationsBlock, "length" ) )
			layerModel.sounds.append( GetSettingsBlockString( animationsBlock, "sound" ) )
		}

		animations.push( layerModel )
	}

	return animations
}



void function RadioPlay_PlayItemFlavor( ItemFlavor radioPlay )
{
	Assert( ItemFlavor_GetType( radioPlay ) == eItemType.radio_play )
	RadioPlay_PlayFromGUIDString( ItemFlavor_GetGUIDString( radioPlay ) )
}

void function RadioPlay_PlayFromGUIDString( string radioPlayGUID )
{
	RadioPlay_SetGUID( radioPlayGUID )
	AdvanceMenu( GetMenu( "RadioPlayDialog" ) )
}

