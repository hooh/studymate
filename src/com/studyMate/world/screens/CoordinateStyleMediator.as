package com.studyMate.world.screens
{
	import com.studyMate.world.component.LineItemSprite;
	import com.studyMate.world.model.vo.StandardItemsVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class CoordinateStyleMediator extends Mediator implements IMediator,ICoordinateStyle
	{
		public function CoordinateStyleMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		public function getLevelDisplay(data:StandardItemsVO):LineItemSprite
		{
			return new LineItemSprite(data);
		}
	}
}