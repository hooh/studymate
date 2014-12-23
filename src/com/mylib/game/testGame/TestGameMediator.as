package com.mylib.game.testGame
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.component.DefaultItem;
	import com.mylib.framework.component.ScrollListMediator;
	import com.mylib.framework.controller.vo.ScrollListVO;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class TestGameMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TestGameMediator";
		
		private var vo:SwitchScreenVO;
		private var tvo:TransformVO;
		public function TestGameMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			super.onRegister();
			var svo:ScrollListVO = new ScrollListVO(DefaultItem,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],4,new Rectangle(100,100,400,300));
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ScrollListMediator,svo,SwitchScreenType.SHOW,null,0,0,-1,"ScrollListMediator1")]);
			
			var btn:Button = new Button();
			btn.label = "refresh";
			btn.addEventListener(Event.TRIGGERED,refreshHandle);
			view.addChild(btn);
		}
		
		private function refreshHandle():void
		{
			sendNotification("ScrollListMediator1"+ScrollListMediator.REFRESH);
		}
		
		private var camera:CameraSprite
		
		
		private var captain:ICharater;
		private function creatHuman():void{
			captain = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			captain.view.alpha = 1;
			captain.view.scaleX = 1;
			captain.view.scaleY = 1;
			captain.view.x = 200;
			captain.view.y = 300;
			
			GlobalModule.charaterUtils.configHumanFromDressList(captain as HumanMediator,Global.myDressList,new Rectangle());
			
			mapHolder.addChild(captain.view);
			
		}
		
		private var worldHolder:Sprite;
		private var mapHolder:Sprite;
		private function createMap():void{
			
			worldHolder = new Sprite;
			view.addChild(worldHolder);
			
			mapHolder = new Sprite;
			mapHolder.x = -300;
			mapHolder.y = -100;
			view.addChild(mapHolder);
			
			var quad:Quad = new Quad(2000, 1000, 0xCCCC66);
			mapHolder.addChild(quad);
			
			
			
			
			
		}
		
		
		
		
		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.UPDATE_CAMERA:
				{
					if(camera){
						
						var local:Point = notification.getBody() as Point;
						camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,tvo.scale,0,false);
						
						
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA];
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
	}
}