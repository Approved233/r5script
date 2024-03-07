global function RTKCharacterSkillsInfo_OnInitialize
global function RTKCharacterSkillsInfo_OnDestroy
global function RTKCharacterSkillsModel_SetCharacter
global function RTKCharacterSkillsModel_GetModelFromItemFlav

global struct RTKCharacterSkillsInfo_Properties
{
	string characterGUID
}

global struct RTKCharacterSkillInfoItemModel
{
	asset icon
	string headerText
	string descText
}

global struct RTKCharacterSkillsInfoModel
{
	string                                  mainText 
	string                                  subText 
	array<RTKCharacterSkillInfoItemModel> 	characterSkillItems
	RTKCharacterSkillInfoItemModel&         characterClassInfo
	array<RTKCharacterSkillInfoItemModel> 	characterClassItems
}

struct PrivateData
{
	string	   charGuid
	rtk_struct characterSkillsStruct
}

void function RTKCharacterSkillsInfo_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_struct characterSkillsInfoModel = RTKDataModel_GetOrCreateEmptyStruct( RTK_MODELTYPE_COMMON, "characterSkillsInfo" )
	p.characterSkillsStruct = RTKStruct_GetOrCreateScriptStruct( characterSkillsInfoModel, string( self.GetInternalId() ), "RTKCharacterSkillsInfoModel" )

	RTKCharacterSkillsInfo_SetDataModel( self )
	RTKStruct_AddPropertyListener( self.GetProperties(), "characterGUID", void function ( rtk_struct properties, string propName, int propType, var propValue ) : ( self ) {
		RTKCharacterSkillsInfo_SetDataModel( self )
	} )

	self.GetPanel().SetBindingRootPath( RTKDataModelType_GetDataPath( RTK_MODELTYPE_COMMON, string( self.GetInternalId() ), true, [ "characterSkillsInfo" ] ) )
}

void function RTKCharacterSkillsInfo_OnDestroy( rtk_behavior self )
{
	
	rtk_struct characterSkillsInfoModel = RTKDataModel_GetOrCreateEmptyStruct( RTK_MODELTYPE_COMMON, "characterSkillsInfo" )

	if ( RTKStruct_HasProperty( characterSkillsInfoModel,string( self.GetInternalId() ) ) )
	{
		RTKStruct_RemoveProperty( characterSkillsInfoModel, string( self.GetInternalId() ) )
	}
}

void function RTKCharacterSkillsInfo_SetDataModel( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	string charGuid = self.PropGetString( "characterGUID" )
	if ( charGuid == "" || charGuid == p.charGuid  )
		return

	p.charGuid = charGuid

	SettingsAssetGUID characterGuid = ConvertItemFlavorGUIDStringToGUID( charGuid )
	if ( !IsValidItemFlavorGUID( characterGuid ) )
	{
		Assert( false, "The provided GUID isn't valid" )
		return
	}

	rtk_struct characterSkillsStruct = p.characterSkillsStruct
	ItemFlavor character = GetItemFlavorByGUID( characterGuid )
	RTKCharacterSkillsInfoModel characterSkillsModel = RTKCharacterSkillsModel_GetModelFromItemFlav( character )

	RTKStruct_SetValue( characterSkillsStruct, characterSkillsModel )
}

void function RTKCharacterSkillsModel_SetCharacter( ItemFlavor character )
{
	rtk_struct characterSkillsInfoModel = RTKDataModel_GetOrCreateEmptyStruct( RTK_MODELTYPE_COMMON, "characterSkillsInfo" )

	if ( !RTKStruct_HasProperty(characterSkillsInfoModel,"characterGUID" ) )
	{
		RTKStruct_AddProperty( characterSkillsInfoModel, "characterGUID", RTKPROP_STRING )
	}

	RTKStruct_SetString( characterSkillsInfoModel, "characterGUID",ItemFlavor_GetGUIDString( character ) )
}

RTKCharacterSkillsInfoModel function RTKCharacterSkillsModel_GetModelFromItemFlav( ItemFlavor character )
{
	RTKCharacterSkillsInfoModel infoModel
	infoModel.mainText = Localize( ItemFlavor_GetLongName( character ) )
	infoModel.subText = Localize( ItemFlavor_GetShortDescription( character ) )

	ItemFlavor passiveAbility  = CharacterClass_GetPassiveAbilityToShow( character )
	RTKCharacterSkillInfoItemModel passiveInfo
	passiveInfo.headerText = Localize ( "#PASSIVE" )
	passiveInfo.descText = Localize( ItemFlavor_GetLongName( passiveAbility ) )
	passiveInfo.icon = ItemFlavor_GetIcon( passiveAbility )
	infoModel.characterSkillItems.append( passiveInfo )

	ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
	RTKCharacterSkillInfoItemModel tacticalInfo
	tacticalInfo.headerText = Localize ( "#TACTICAL" )
	tacticalInfo.descText = Localize( ItemFlavor_GetLongName( tacticalAbility ) )
	tacticalInfo.icon = ItemFlavor_GetIcon( tacticalAbility )
	infoModel.characterSkillItems.append( tacticalInfo )

	ItemFlavor ultimateAbility = CharacterClass_GetUltimateAbility( character )
	RTKCharacterSkillInfoItemModel ultimateInfo
	ultimateInfo.headerText = Localize ( "#ULTIMATE" )
	ultimateInfo.descText = Localize( ItemFlavor_GetLongName( ultimateAbility ) )
	ultimateInfo.icon = ItemFlavor_GetIcon( ultimateAbility )
	infoModel.characterSkillItems.append( ultimateInfo )

	int characterRole = CharacterClass_GetRole( character )

	RTKCharacterSkillInfoItemModel classInfo
	classInfo.headerText = Localize( CharacterClass_GetRoleTitle (characterRole ) )
	classInfo.descText = Localize( CharacterClass_GetRoleSubtitle (characterRole ) )
	classInfo.icon = CharacterClass_GetRoleIcon(characterRole )
	infoModel.characterClassInfo = classInfo

	RTKCharacterSkillInfoItemModel perkInfo0
	perkInfo0.descText = Localize( CharacterClass_GetRolePerkShortDescriptionAtIndex(characterRole, 0).toupper() )
	perkInfo0.icon = CharacterClass_GetRolePerkIconAtIndex(characterRole, 0 )
	infoModel.characterClassItems.append( perkInfo0 )

	if ( CharacterClass_GetRolePerkShortDescriptionAtIndex(characterRole, 1) != "" )
	{
		RTKCharacterSkillInfoItemModel perkInfo1
		perkInfo1.descText = Localize( CharacterClass_GetRolePerkShortDescriptionAtIndex(characterRole, 1).toupper() )
		perkInfo1.icon       = CharacterClass_GetRolePerkIconAtIndex(characterRole, 1 )
		infoModel.characterClassItems.append( perkInfo1 )
	}

	return infoModel
}