package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;

	internal class SpokenSubAlertMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SpokenSubAlertMediator";
		private var bg:Image;
		
		
		public function SpokenSubAlertMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{
			bg = new Image(Assets.getEgAtlasTexture("word/alertSpoken"));						
			bg.x += bg.width>>1;
			bg.y += bg.height>>1;
			bg.pivotX = bg.width>>1;
			bg.pivotY = bg.height>>1;
			
			view.addChild(bg);
						
			
			TweenLite.from(bg,0.6,{scaleX:0.1,scaleY:0.1,ease:Back.easeOut,onComplete:showHandler});
		}
		private function showHandler():void{
			var firstBtn:Button = new Button(Assets.getEgAtlasTexture("word/firstBtn"));
			firstBtn.name = "firstBtn";
			firstBtn.addEventListener(Event.TRIGGERED,keyDownHandler);
			firstBtn.x = 80;
			firstBtn.y = 210;
			view.addChild(firstBtn);
			
			var secondBtn:Button = new Button(Assets.getEgAtlasTexture("word/secondBtn"));
			secondBtn.name = "secondBtn";
			secondBtn.addEventListener(Event.TRIGGERED,keyDownHandler);
			secondBtn.x = 308;
			secondBtn.y = 210;
			view.addChild(secondBtn);
			
			var threeBtn:Button = new Button(Assets.getEgAtlasTexture("word/threeBtn"));
			threeBtn.name = "threeBtn";
			threeBtn.addEventListener(Event.TRIGGERED,keyDownHandler);
			threeBtn.x = 530;
			threeBtn.y = 210;
			view.addChild(threeBtn);
			
		}
		
		private function keyDownHandler(e:Event):void{
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			var gradStr:String = "100";
			switch(obj.name){
				case "firstBtn":
					gradStr = "100";
					break;
				case "secondBtn":
					gradStr = "80";
					break;
				case "threeBtn":
					gradStr = "60";
					break;
			}
			view.touchable = false;
			sendNotification(SpokenGpuMediator.GRADE_SPOKEN,gradStr);
			
			
		}
		
		
		override public function onRemove():void{
			TweenLite.killTweensOf(bg);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);								
		}
	}
}