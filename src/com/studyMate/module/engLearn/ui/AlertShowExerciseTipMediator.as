package com.studyMate.module.engLearn.ui
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class AlertShowExerciseTipMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'AlertShowExerciseTipMediator';
		public static const HIDE_EXERCISE_TIP:String = NAME+'HIDE_EXERCISE_TIP';
		private var pareVO:SwitchScreenVO;
		private var tipHolder:Sprite;
		private var bottomBtn:Quad;
		
		public function AlertShowExerciseTipMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			tipHolder = new Sprite();
			view.addChild(tipHolder);
						
			var img:Image = new Image(Assets.getEgAtlasTexture("word/alertUnkonw"));
			tipHolder.addChild(img);			
			
			var closeBtn:Button = new Button(Assets.getEgAtlasTexture("word/closeBtn"));
			closeBtn.x = 580;
			closeBtn.y = 0;
			tipHolder.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
			
			var tipTxt:ScrollText = new ScrollText();
			tipHolder.addChild(tipTxt);
			tipTxt.width = 542;
			tipTxt.height = 397;
			tipTxt.x = 40;
			tipTxt.y = 92;
			tipTxt.isHTML = true;
			tipTxt.textFormat = new TextFormat('HeiTi',20,0x333333);
			tipTxt.embedFonts = true;
			
			bottomBtn = new Quad(557,80,0);
			bottomBtn.x = 2;
			bottomBtn.y = 7;
			bottomBtn.alpha = 0;
			tipHolder.addChild(bottomBtn);				
			bottomBtn.addEventListener(TouchEvent.TOUCH,tipTounchHandler);
			
			tipTxt.text = String(pareVO.data);
			
			view.x = Global.stageWidth-view.width;
			view.y = Global.stageHeight-view.height+20;
		}
		
		private	var pos:Point = new Point();
		private var pos0:Point = new Point();
		private function tipTounchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(view);	
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos0 =  touch.getLocation(tipHolder,pos0);
			}else if(touch && touch.phase == TouchPhase.MOVED){
				touch.getLocation(view,pos);
				tipHolder.x = pos.x-pos0.x;
				tipHolder.y = pos.y-pos0.y;
			}
		}
		
		override public function onRemove():void{
			sendNotification(HIDE_EXERCISE_TIP);
		}
		private function closeHandler(e:Event):void
		{
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}		
		
	}
	
	
}