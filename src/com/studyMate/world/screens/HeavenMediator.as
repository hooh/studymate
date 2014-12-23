package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class HeavenMediator extends ScreenBaseMediator
	{
		private var sun:Image;
		private var moon:Image;
		private var boat:Image;
		private var ufo:Image;
		
		
		private var could:Image;
		
		public static const NAME:String = "HeavenMediator";
		
		public function HeavenMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			sun = new Image(Assets.getAtlasTexture("bg/sun"));
			sun.x = 900;
			sun.y = 50;
			view.addChild(sun);
			
			could = new Image(Assets.getAtlasTexture("bg/cloud"));
			could.y = 30;
			could.x = 200;
			TweenLite.to(could,60,{alpha:0,x:-1000});
			view.addChild(could);
			
			boat = new Image(Assets.getAtlasTexture("bg/boat"));
			boat.y = 280;
			boat.x = 1280
			TweenLite.to(boat,150,{x:-50});
			view.addChild(boat);
			
			ufo = new Image(Assets.getAtlasTexture("bg/ufo"));
			TweenLite.to(ufo,30,{x:1000,y:160,alpha:0.2,width:5,height:7});
			ufo.y = 50;
			ufo.x = 480;
			view.addChild(ufo);
		}
		
		override public function onRemove():void{
			view.removeChildren(0,-1,true);
			sun.dispose();
			could.dispose();
			boat.dispose();
			ufo.dispose();
			TweenLite.killTweensOf(could);
			TweenLite.killTweensOf(boat);
			TweenLite.killTweensOf(ufo);
			
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}