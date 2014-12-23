package com.studyMate.world.screens.ui.music
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class MusicTypeSp extends Sprite
	{
		public static const GET_MUSIC_TYPE:String = "Music_Type_Select";
		public static const DEL_MUSIC_TYPE:String = "DEL_MUSIC_TYPE";
		
		public var title:String="";//分类标题
		public var grgid:String = "";//分类标识
		
		private var alertBoo:Boolean;
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var _delBtn:Button;
		
		public function MusicTypeSp(arr:Array=null)
		{
			if(arr){
				grgid = arr[1];
				title = arr[3];
				var txt:TextField = new TextField(190,50,title,"HeiTi",20,0x1B4E7A);
				txt.touchable = false;
				var bg:Button = new Button(Assets.getMusicSeriesTexture("typeBg"));
				txt.x = 0;
				txt.y = 40;
				this.addChild(bg);
				this.addChild(txt);
				this.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}else{
				bg = new Button(Assets.getMusicSeriesTexture("addTypeBg"));
				this.addChild(bg);
				bg.addEventListener(Event.TRIGGERED,addTypeHandler);
			}			
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		private function removeFromStageHandler():void
		{
			// TODO Auto Generated method stub
			TweenLite.killTweensOf(onComp);
			
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
			this.removeChildren(0,-1,true);
		}
		
		public function get delBtn():Button
		{
			if(_delBtn == null){
				_delBtn = new Button(Assets.getMusicSeriesTexture("delIcon"));
				this.addChild(_delBtn);
			}
			return _delBtn;
		}

		private function addTypeHandler(e:Event):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AddTypeInputMediator,this,SwitchScreenType.SHOW)]);
		}
		
		
		
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos = touch.getLocation(this);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				canPlayBoo = true;
				alertBoo = true;
				TweenLite.killTweensOf(onComp);
				TweenLite.delayedCall(0.7,onComp);
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(this);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					canPlayBoo = false;
					alertBoo = false;
				}
			}else if(touch && touch.phase == TouchPhase.ENDED){
				TweenLite.killTweensOf(onComp);
				if(canPlayBoo ){
					canPlayBoo=false;
					var obj:Object={title:title,grgid:grgid};
					Facade.getInstance(CoreConst.CORE).sendNotification(GET_MUSIC_TYPE,obj);						
					
				}
				alertBoo=false;
			}
			
		}
		private function onComp():void{
			if(alertBoo && grgid!="0"){
				canPlayBoo = false;
				trace("长按了");
				delBtn.addEventListener(TouchEvent.TOUCH,delTypeHandler);
				Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandler);
			}
		}
		private function stageTouchHandler(e:TouchEvent):void{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
				e.stopImmediatePropagation();
				this.removeChild(_delBtn,true);
				_delBtn = null;
			}
		}
		
		private function delTypeHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as DisplayObject);	
			if(touch && touch.phase == TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				Facade.getInstance(CoreConst.CORE).sendNotification(DEL_MUSIC_TYPE,this);			
			}
			
		}
	}
}