package com.studyMate.world.screens.wordcards
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class GotoWordCardMediator extends ScreenBaseMediator
	{
		
		private const NAME:String = "GotoWordCardMediator";
		
		private var unRememberWordCardBtn:starling.display.Button;
		private var rememberWordCardBtn:starling.display.Button
		
		public function GotoWordCardMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent)
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		private var background:Image;
		
		override public function onRegister():void
		{
			
			background = new Image(Assets.getTexture("startWordBackground"));
			view.addChild(background);
			
			unRememberWordCardBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("studyWord"));
			unRememberWordCardBtn.x = 500;
			unRememberWordCardBtn.y = 150;
			view.addChild(unRememberWordCardBtn);
			unRememberWordCardBtn.addEventListener(Event.TRIGGERED,unRememberHandler);
			
			rememberWordCardBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("achievementBtn"));
			rememberWordCardBtn.x = 1000;
			rememberWordCardBtn.y = 630;
			view.addChild(rememberWordCardBtn);
			rememberWordCardBtn.addEventListener(Event.TRIGGERED,rememberHandler);
		}
		
		private function rememberHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RememberWordCardMediator)]);
		}
		
		private function unRememberHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UnrememberWordCardMediator)]);
		}
		
	}
}