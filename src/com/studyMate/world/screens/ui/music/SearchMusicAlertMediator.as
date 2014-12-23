package com.studyMate.world.screens.ui.music
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.screens.MusicMarketMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SearchMusicAlertMediator extends ScreenBaseMediator
	{
		public static const NAME :String = "SearchMusicAlertMediator";
		private var pareVO:SwitchScreenVO;
		private var img:Image;
		private var searchTxt:TextFieldHasKeyboard;
		
		public function SearchMusicAlertMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			view.x = 377;
			view.y = 211;
			
			img = new Image(Assets.getMusicSeriesTexture("searchAlert"));
			img.pivotX = img.width>>1;
			img.pivotY = img.height>>1;
			img.x += img.width>>1;
			img.y += img.height>>1;
									
			view.addChild(img);			
			
			img.addEventListener(TouchEvent.TOUCH,bgTouchHandler);
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandler);
			TweenLite.from(img,0.6,{scaleX:0.1,scaleY:0.1,ease:Back.easeOut,onComplete:showHandler});
		}
		private function delBtnHandler(e:Event):void{		
				e.stopImmediatePropagation();
				
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		override public function onRemove():void{
			TweenLite.killTweensOf(img);
			if(searchTxt){
				searchTxt.removeEventListener(KeyboardEvent.KEY_DOWN,searchDownHandler);
				searchTxt.removeEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
				Starling.current.nativeOverlay.removeChild(searchTxt);
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		private function bgTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
			}
		}
		private function showHandler():void{
			var sureBtn:Button = new Button(Assets.getMusicSeriesTexture("yesButtonIcon"));
			sureBtn.x = 267;
			sureBtn.y = 145;
			view.addChild(sureBtn);
			sureBtn.addEventListener(TouchEvent.TOUCH,sureBtnHandler);
			
			var _delBtn:Button = new Button(Assets.getMusicSeriesTexture("delIcon"));
			_delBtn.x = 560;			
			view.addChild(_delBtn);
			_delBtn.addEventListener(Event.TRIGGERED,delBtnHandler);
			
			var tf:TextFormat = new TextFormat("HeiTi",34,0xFFFFFF);
			searchTxt = new TextFieldHasKeyboard();
			searchTxt.defaultTextFormat = tf;
			searchTxt.embedFonts = true;
			searchTxt.antiAliasType = AntiAliasType.ADVANCED;
			searchTxt.width = 410;
			searchTxt.height = 60;
			searchTxt.x = 550;
			searchTxt.y = 280;
			searchTxt.maxChars = 18;
			searchTxt.addEventListener(KeyboardEvent.KEY_DOWN,searchDownHandler);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
						
			Starling.current.nativeOverlay.addChild(searchTxt); 			
			searchTxt.setFocus();
		}
		
		private function stageTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}
		}
		
		private function sureBtnHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				var infoStr:String = StringUtil.trim(searchTxt.text);
				
				if(infoStr !=""){					
					sendNotification(MusicMarketMediator.SEARCH_MUSIC,infoStr);
				}
			}
			
		}
		
		protected function searchFocusInHandler(event:FocusEvent):void
		{
			//searchTxt.selectRange(0,searchTxt.text.length);
			sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0x0C92B7);//键盘带背景
		}
		
		protected function searchDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车
				e.preventDefault();
				e.stopImmediatePropagation();
				var infoStr:String = StringUtil.trim(searchTxt.text);
				if(infoStr !=""){	
					sendNotification(MusicMarketMediator.SEARCH_MUSIC,infoStr);
				}				
			}
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