package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.studyMate.global.Global;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.view.MP3PlayerView;
	
	import fl.controls.Button;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	
	import mx.states.AddChild;
	
	public class MP3PlayerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MP3PlayerMediator";
		public static const URL:String = Global.document.resolvePath(Global.localPath+"/mp3").url;
		private var mp3:MP3PlayerProxy;
		private var songIndex:int = 0;
		private var mp3UrlsArray:Array;
		private var mp3NamesArray:Array;
		private var pauseOrNot:Boolean = false;
		
		public function MP3PlayerMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			facade.registerProxy(mp3);
			mp3UrlsArray = mp3.getMP3Urls(URL);
			mp3NamesArray = mp3.getMP3Names(URL);
			
			view.playBtn.addEventListener(MouseEvent.CLICK, playMP3Handler);
			view.pauseBtn.addEventListener(MouseEvent.CLICK, pauseMP3Handler);
			view.nextBtn.addEventListener(MouseEvent.CLICK, nextMP3Handler);
			view.preBtn.addEventListener(MouseEvent.CLICK, lastMP3Handler);
			view.stopBtn.addEventListener(MouseEvent.CLICK, stopMP3Handler);
			view.volumeSlider.addEventListener(SliderEvent.THUMB_DRAG,volumeChangeHandler);
			view.positionSlider.addEventListener(Event.CHANGE,positionChangeHandler);
			
		}
		
		private function sliderAutoChange():void{
			TweenLite.delayedCall(1,sliderAutoChange);
			view.positionSlider.value = (mp3.getPosition() / mp3.getLength()) * view.positionSlider.maximum;
			view.positionText.text = getTimeFmt(mp3.getPosition());
			view.sumTimeText.text = getTimeFmt(mp3.getLength());
			if(view.positionText.text == view.sumTimeText.text){
				nextMP3Handler(null);
			}
		}
		
		private static function getTimeFmt(ms:Number):String{
			var s:int = int(ms/1000);
			var m:int = int(s/60);
			s -= m*60;
			return make2Str(m) + ":" + make2Str(s);
		}
		
		private static function make2Str(i:int):String{
			if(i<10) return "0" + i;
			else return ""+i;
		}
		
		private function positionChangeHandler(event:SliderEvent):void{
			mp3.moveToPosition(view.positionSlider.value / view.positionSlider.maximum);
		}
		
		private function stopMP3Handler(event:MouseEvent):void{
			mp3.stop();
			view.pauseBtn.visible = false;
			view.playBtn.visible = true;
			pauseOrNot = false;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
			view.positionSlider.value = 0;
			view.positionText.text = "00:00";
			view.sumTimeText.text = "00:00";
		}
		
		private function volumeChangeHandler(e:SliderEvent):void{
			mp3.setVolume(view.volumeSlider.value);
		}
		
		private function nextMP3Handler(event:MouseEvent):void{
			mp3.stop();
			songIndex++;
			if(songIndex == mp3UrlsArray.length) songIndex = 0;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
			playMP3Handler(null);
		}
		
		private function lastMP3Handler(event:MouseEvent):void{
			mp3.stop();
			songIndex--;
			if(songIndex < 0) songIndex = mp3UrlsArray.length - 1;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
			playMP3Handler(null);
		}
		
		private function pauseMP3Handler(event:MouseEvent):void{
			view.playBtn.visible = true;
			view.pauseBtn.visible = false;
			mp3.pause();
			pauseOrNot = true;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
		}
		
		private function playMP3Handler(event:MouseEvent):void{
			view.playBtn.visible = false;
			view.pauseBtn.visible = true;
			if(pauseOrNot){
				mp3.resume();
				pauseOrNot = false;
			}else{
				mp3.play((mp3UrlsArray[songIndex] as File).url, 0, 1, view.volumeSlider.value);
				view.nameOfMP3Text.text = mp3NamesArray[songIndex];
			}
			TweenLite.delayedCall(1,sliderAutoChange);
		}
		
		public function get view():MP3PlayerView{
			return getViewComponent() as MP3PlayerView;
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return MP3PlayerView;
		}
	}
}