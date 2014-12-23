package com.mylib.game.charater
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import starling.display.Sprite;
	
	public class CaptainMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CaptainMediator";
		public var charaterName:String="captain";
		public var skeleon:String = "MHuman";
		public var charaterSuit:String="captain";
		private var charater:HumanMediator;
		
		public function CaptainMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			
			facade.removeMediator(charater.getMediatorName());
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			// TODO Auto Generated method stub
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			
			charater = new HumanMediator(charaterName,charaterSuit,skeleon,view);
			facade.registerMediator(charater);
			
		}
		
	}
}