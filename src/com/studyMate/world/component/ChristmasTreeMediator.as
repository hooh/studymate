package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.effects.SwimWater;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	public class ChristmasTreeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ChristmasTreeMediator";
		
		private var sp:Sprite;
		private var rect:Rectangle;
		private var giftHolder:Sprite;
		private var _waterSpray:SwimWater;
		
		public function ChristmasTreeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get waterSpray():SwimWater
		{
			if(_waterSpray == null){
				_waterSpray = new SwimWater();
//				_waterSpray.scaleY = -1;	
				_waterSpray.rotation = -0.8;
				view.addChild(_waterSpray);
			}			
			return _waterSpray;
		}

		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRemove():void{
			runEnterFrames = false;
			if(_waterSpray)
				_waterSpray.dispose();
			for(var i:int = 0;i<giftHolder.numChildren;i++){
				TweenLite.killTweensOf(giftHolder.getChildAt(i));
			}
			giftHolder.dispose();
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			runEnterFrames = true;
			var img:Image = new Image(Assets.getChristmasTexture('treeBg'));
			view.addChild(img);
			
			var imgligth:Image = new Image(Assets.getChristmasTexture('treeLight-1'));
			sp = new Sprite();
			sp.addChild(imgligth);
			rect = new Rectangle(0,0,205,340);
			sp.clipRect = rect;
			view.addChild(sp);
			sp.touchable = false;
			
			giftHolder = new Sprite();
			view.addChild(giftHolder);
			getRandomDecorate();
			
			img = new Image(Assets.getChristmasTexture('snow'));
			img.touchable = false;
			view.addChild(img);
			
			view.scaleX = 1.1;
			view.scaleY = 1.1;
		}
		
		private var imgligth:Image;
		private function getRandomDecorate():void{
			for(var i:int = 0;i<7;i++){
				var rd:int = int(Math.random()*21);
				imgligth = new Image(Assets.getChristmasTexture('decorate'+i));
				var h:Number = Math.random()*214;
				var w:Number = h/Math.tan(1);
				
				imgligth.pivotX = imgligth.width>>1;
				imgligth.y = 49+h;
				imgligth.x =250/2 + w*(Math.random()*2-1);
				imgligth.addEventListener(TouchEvent.TOUCH,touchHandler);
				giftHolder.addChild(imgligth);
			}			
		}
		
		private function touchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				var img:Image = e.target as Image;
				img.touchable = false;
				waterSpray.x = img.x+10;
				waterSpray.y = img.y;
				TweenLite.to(img,1,{y:310,rotation:1,alpha:0,onComplete:onComplete});
				
				waterSpray.removeAnimation();
				waterSpray.start();
			}
		}
		
		private function onComplete():void{
			waterSpray.stop();
		}
		
		private var recth:Number;
		override public function advanceTime(time:Number):void
		{
			rect.y -=1;

			sp.clipRect =rect;
			if(rect.y<0){
				rect.y = 250;
			}			
			if(rect.y%5==0){
				sp.visible = false;
			}else if(rect.y%9==0){
				sp.visible = true;
			}
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
	}
}