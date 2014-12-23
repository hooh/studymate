package com.studyMate.world.screens.wordcards
{
	import com.greensock.easing.Quad;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.fishGame.Circle;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.WordCard;
	
	import flash.display.Sprite;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class GuideWordCardMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "GuideWordCardMediator";
		
		public function GuideWordCardMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		
		private var prepareVO:SwitchScreenVO;
//		private var step:String;
//		private var tempBtn:starling.display.Button;
		private var obj:Object;
		private var _set:WordCard
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			obj = vo.data ;
//			step = String(vo.data);
			_set = vo.data as WordCard;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite
		{
			return getViewComponent()as starling.display.Sprite;
		}
		
		override public function onRegister():void
		{
			
/*			var sp:flash.display.Sprite = new flash.display.Sprite();
			sp.graphics.beginFill(0,0.3);
//			sp.graphics.drawCircle(0,0,400);
			sp.graphics.drawRect(0,0,1280,800);
			sp.graphics.endFill();
//			sp.x = 500;
//			sp.y = 100;
			view.addChild(sp);
			
/*			var _mask:Sprite = new Sprite();
			_mask.graphics.beginFill(0,0.3);
			_mask.graphics.drawCircle(0,0,100);
			_mask.graphics.endFill();
			_mask.x = 500;
			_mask.y = 300;
			view.addChild(_mask);
			_mask.mask = sp;*/
//			trace(tempBtn);
			/*	bg.alpha = 0.3;
			view.addChild(bg);*/
			
//			if(tempBtn != null){
//				view.addChild(tempBtn);
//			}
//			if(obj.)
			
/*			if(step== "selectCard"){
				var bg:starling.display.Quad = new starling.display.Quad(1280,500,0);
				bg.alpha = 0.3;
				view.addChild(bg);
				
				var btn:feathers.controls.Button = new feathers.controls.Button();
				btn.y = 600;
				btn.x = 100;
				btn.label = "跳过";
				view.addChild(btn);
			}*/
//			view.clipRect = new Rectangle(0,0,100,100);
			
			if(_set != null){
				var bg:starling.display.Quad = new starling.display.Quad(1280,800,0);
				bg.alpha = 0.3;
				view.addChild(bg);	
				
//				view.addChild(_set);
			}
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.HIDE_SETTING_SCREEN];
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN:
				{
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				}
			}
			
		}
		
		
	}
}