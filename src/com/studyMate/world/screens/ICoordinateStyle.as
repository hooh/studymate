package com.studyMate.world.screens
{
	import com.studyMate.world.component.LineItemSprite;
	import com.studyMate.world.model.vo.StandardItemsVO;

	public interface ICoordinateStyle
	{
		
		function getLevelDisplay(data:StandardItemsVO):LineItemSprite;
		
	}
}