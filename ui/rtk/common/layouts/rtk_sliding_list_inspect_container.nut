global function RTKSlidingListInspect_OnInitialize
global function RTKSlidingListInspect_OnDestroy
global function RTKSlidingListInspect_OnKeyCodePressed
global function RTKSlidingListInspect_OnItemListInspect
global function RTKSlidingListInspect_OnBlockListInspect
global function RTKSlidingListInspect_SetItemListInspectInstant
global function RTKSlidingListInspect_SetBlockListInspectInstant
global function RTKSlidingListInspect_IsInspectingItemList

global struct RTKSlidingListInspect_Properties
{
	rtk_panel blockListPanel
	rtk_panel itemListPanel
	rtk_panel itemDetailPanel

	rtk_behavior animatorBehavior

	float offscreenPosition
	float leftAnchorPosition
	float rightAnchorPosition

	void functionref() onItemListInspectStarted
	void functionref() onItemListInspectFinished
	void functionref() onBlockListInspectStarted
	void functionref() onBlockListInspectFinished

	void functionref() onBlockHover
	void functionref() onItemHover
	void functionref() onItemInspect

}

struct PrivateData
{
	bool isInspectingItemList 
}

const string ANIMATION_ITEM_LIST_INSPECT = "BlockListToItemList"
const string ANIMATION_BLOCK_LIST_INSPECT = "ItemListToBlockList"

void function RTKSlidingListInspect_OnInitialize( rtk_behavior self )
{
	rtk_behavior animator = self.PropGetBehavior( "animatorBehavior" )

	self.AutoSubscribe( animator, "onAnimationStarted", function( rtk_behavior animator, string animName ) : ( self ) {
		RTKSlidingListInspect_OnAnimationStarted( self, animName )
	} )

	self.AutoSubscribe( animator, "onAnimationFinished", function( rtk_behavior animator, string animName ) : ( self ) {
		RTKSlidingListInspect_OnAnimationFinished( self, animName )
	} )
}


void function RTKSlidingListInspect_OnDestroy( rtk_behavior self )
{

}


void function RTKSlidingListInspect_OnBlockHover( rtk_behavior self )
{
	self.InvokeEvent( "onBlockHover" )
}

bool function RTKSlidingListInspect_OnKeyCodePressed( rtk_behavior self, int code )
{
	PrivateData p
	self.Private( p )

	if ( code == KEY_ESCAPE && p.isInspectingItemList )
	{
		RTKSlidingListInspect_OnBlockListInspect( self )
	}

	return false
}


void function RTKSlidingListInspect_OnItemListInspect( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_behavior animator = self.PropGetBehavior( "animatorBehavior" )
	if ( animator == null || !RTKAnimator_HasAnimation( animator, ANIMATION_ITEM_LIST_INSPECT ) )
		return

	RTKAnimator_PlayAnimation( animator, ANIMATION_ITEM_LIST_INSPECT )
	p.isInspectingItemList = true
}

void function RTKSlidingListInspect_SetItemListInspectInstant( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_panel blockList = self.PropGetPanel( "blockListPanel" )
	rtk_panel itemList = self.PropGetPanel( "itemListPanel" )
	rtk_panel itemDetail = self.PropGetPanel( "itemDetailPanel" )
	float offScreenPosition = self.PropGetFloat( "offScreenPosition" )
	float leftAnchor = self.PropGetFloat( "leftAnchorPosition" )

	blockList.GetParent().SetPositionX( offScreenPosition )
	itemList.GetParent().SetPositionX( leftAnchor )
	itemDetail.FindBehaviorByTypeName( "RenderGroup" ).PropSetFloat( "alpha", 1 )

	RTKSlidingListInspect_OnAnimationStarted( self, ANIMATION_ITEM_LIST_INSPECT )
	RTKSlidingListInspect_OnAnimationFinished( self, ANIMATION_ITEM_LIST_INSPECT )

	p.isInspectingItemList = true
}


void function RTKSlidingListInspect_OnBlockListInspect( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_behavior animator = self.PropGetBehavior( "animatorBehavior" )
	if ( animator == null || !RTKAnimator_HasAnimation( animator, ANIMATION_BLOCK_LIST_INSPECT ) )
		return

	RTKAnimator_PlayAnimation( animator, ANIMATION_BLOCK_LIST_INSPECT )
	p.isInspectingItemList = false
}

void function RTKSlidingListInspect_SetBlockListInspectInstant( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	rtk_panel blockList = self.PropGetPanel( "blockListPanel" )
	rtk_panel itemList = self.PropGetPanel( "itemListPanel" )
	rtk_panel itemDetail = self.PropGetPanel( "itemDetailPanel" )
	float leftAnchor = self.PropGetFloat( "leftAnchorPosition" )
	float rightAnchor = self.PropGetFloat( "rightAnchorPosition" )

	blockList.GetParent().SetPositionX( leftAnchor )
	itemList.GetParent().SetPositionX( rightAnchor )
	itemDetail.FindBehaviorByTypeName( "RenderGroup" ).PropSetFloat( "alpha", 0 )

	RTKSlidingListInspect_OnAnimationStarted( self, ANIMATION_BLOCK_LIST_INSPECT )
	RTKSlidingListInspect_OnAnimationFinished( self, ANIMATION_BLOCK_LIST_INSPECT )

	p.isInspectingItemList = false
}


void function RTKSlidingListInspect_OnItemHover( rtk_behavior self )
{
	self.InvokeEvent( "onItemHover" )
}

void function RTKSlidingListInspect_OnItemInspect( rtk_behavior self )
{
	self.InvokeEvent( "onItemInspect" )
}

void function RTKSlidingListInspect_OnAnimationStarted( rtk_behavior self, string animName )
{
	switch ( animName )
	{
		case ANIMATION_ITEM_LIST_INSPECT:
			self.InvokeEvent( "onItemListInspectStarted" )
			rtk_panel blockList = self.PropGetPanel( "blockListPanel" )
			blockList.SetActive( false )
			break

		case ANIMATION_BLOCK_LIST_INSPECT:
			self.InvokeEvent( "onBlockListInspectStarted" )
			rtk_panel blockList = self.PropGetPanel( "blockListPanel" )
			blockList.SetActiveAndVisible( true )
			break
	}
}

void function RTKSlidingListInspect_OnAnimationFinished( rtk_behavior self, string animName )
{
	switch ( animName )
	{
		case ANIMATION_ITEM_LIST_INSPECT:
			self.InvokeEvent( "onItemListInspectFinished" )
			rtk_panel blockList = self.PropGetPanel( "blockListPanel" )
			blockList.SetVisible( false )
			break

		case ANIMATION_BLOCK_LIST_INSPECT:
			self.InvokeEvent( "onBlockListInspectFinished" )
			break
	}
}

bool function RTKSlidingListInspect_IsInspectingItemList( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	return p.isInspectingItemList
}