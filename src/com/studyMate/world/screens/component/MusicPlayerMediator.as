package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.MusicListPlayMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.music.MusicBaseClass;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import feathers.controls.Slider;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	
	public class MusicPlayerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MusicPlayerMediator";
		
		public static const SECECT_SOUNDS:String = NAME+"SECECT_SOUNDS";
		
		private var mp3Proxy:MP3PlayerProxy;
		private var playBtn:starling.display.Button;
		private var pauseBtn:starling.display.Button;
		private var preBtn:starling.display.Button;
		private var nextBtn:starling.display.Button;
		private var circulateStyleBtn:starling.display.Button
		private var orderStyleBtn:starling.display.Button;
		private var randomStyleBtn:starling.display.Button;
		private var titleTxt:TextField;
		private var soundSlider:Slider;
		private var playSlider:Slider;
		private var playTimeTxt:TextField;
		
		private var listArr:ListCollection=new ListCollection;
		private var index:int;
		private var preBoo:Boolean;
		
		private var defauldAlpha:Number = 0.2;
		private var songName:String = '';
		
		//private var mode:int = 1 ;//0为顺序播放，1单曲循环，2为随机播放
		private const modeKey:String = "MusicPlayMode";
		private const soundVolume:String = "soundVolume";
		
		private var config:IConfigProxy;
		
		public function MusicPlayerMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(startPlayTime);
			mp3Proxy.onRemove();
			TweenLite.killDelayedCallsTo(delayPlayHandler);
			listArr = null;
			
			view.removeChildren(0,-1,true);
			super.onRemove();	
		}
		
		override public function onRegister():void{
			mp3Proxy = facade.retrieveProxy(MP3PlayerProxy.NAME) as MP3PlayerProxy;
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			
			var bg:Quad = new Quad(1280, 202,0xFFFFFF);
			bg.alpha = 0.1;
			view.addChild(bg);
			
			playBtn = new starling.display.Button(Assets.getMusicSeriesTexture("playBtn"));
			pauseBtn = new starling.display.Button(Assets.getMusicSeriesTexture("pauseBtn"));
			preBtn = new starling.display.Button(Assets.getMusicSeriesTexture("preBtn"));
			nextBtn = new starling.display.Button(Assets.getMusicSeriesTexture("nextBtn"));
			circulateStyleBtn = new starling.display.Button(Assets.getMusicSeriesTexture("circulateStyleBtn"));
			orderStyleBtn = new starling.display.Button(Assets.getMusicSeriesTexture("orderStyleBtn"));
			randomStyleBtn = new starling.display.Button(Assets.getMusicSeriesTexture("randomStyleBtn"));
			titleTxt = new TextField(520,42,"歌曲名","HeiTi",22,0xFFFFFF);
			
						
			playBtn.x = 585;
			playBtn.y = 106;
			pauseBtn.x = 585;
			pauseBtn.y = 106;
			preBtn.x = 441;
			preBtn.y = 106;
			nextBtn.x = 728;
			nextBtn.y = 106;
			circulateStyleBtn.x = 934;
			circulateStyleBtn.y = 129;
			orderStyleBtn.x = 999;
			orderStyleBtn.y = 129;
			randomStyleBtn.x = 1064;
			randomStyleBtn.y = 129;
			titleTxt.x = 380;
			titleTxt.y = 26;
			
			pauseBtn.visible = false;
			
			view.addChild(playBtn);
			view.addChild(pauseBtn);
			view.addChild(preBtn);
			view.addChild(nextBtn);
			view.addChild(circulateStyleBtn);
			view.addChild(orderStyleBtn);
			view.addChild(randomStyleBtn);
			view.addChild(titleTxt);
			
			playBtn.addEventListener(TouchEvent.TOUCH,playHandler);
			pauseBtn.addEventListener(TouchEvent.TOUCH,pauseHandler);
			preBtn.addEventListener(TouchEvent.TOUCH,preHandler);
			nextBtn.addEventListener(TouchEvent.TOUCH,nextHandler);
			circulateStyleBtn.addEventListener(TouchEvent.TOUCH,circulateStyleHandler);
			orderStyleBtn.addEventListener(TouchEvent.TOUCH,orderStyleHandler);
			randomStyleBtn.addEventListener(TouchEvent.TOUCH,randomStyleHandler);
			
			var minRect:Rectangle = new Rectangle(4,0,11,12);
			var maxRect:Rectangle = new Rectangle(0,0,4,14);
			var minScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getMusicSeriesTexture("soundMinTrack"),minRect);
			var maxScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getMusicSeriesTexture("soundMaxTrack"),maxRect);
			soundSlider = new Slider();
			soundSlider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			soundSlider.width = 171;
			soundSlider.x = 159;
			soundSlider.y = 134;
			soundSlider.minimum = 0;
			soundSlider.maximum = 30;
			soundSlider.step = 1;
			soundSlider.page = 2;
			soundSlider.minimumPadding = -10;
			soundSlider.maximumPadding = -10;
			
			var value:String = (config.getValueInUser(soundVolume));
			if(value==""){
				config.updateValueInUser(soundVolume,10);
				soundSlider.value = 10;
			}else{
				soundSlider.value = int(value);				
			}
		
			soundSlider.liveDragging = false;
			view.addChild(soundSlider);
			soundSlider.addEventListener( Event.CHANGE, slider_changeHandler );
			
			soundSlider.thumbProperties.defaultSkin = new Image(Assets.getMusicSeriesTexture("mythumbUpSkin"));
			soundSlider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			soundSlider.maximumTrackProperties.defaultSkin =  new Scale9Image(maxScale9Txtur);
			soundSlider.thumbProperties.stateToSkinFunction = null;
			soundSlider.minimumTrackProperties.stateToSkinFunction = null;
			soundSlider.maximumTrackProperties.stateToSkinFunction = null;
			soundSlider.thumbProperties.minWidth = soundSlider.thumbProperties.minHeight = 0;
			
			playSlider = new Slider();
			playSlider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			playSlider.width = 958;
			playSlider.x = 159;
			playSlider.y = 53;
			playSlider.minimum = 0;
			playSlider.maximum = 60;
			playSlider.step = 1;
			playSlider.page = 2;
			playSlider.minimumPadding = -14;
			playSlider.maximumPadding = -14;
			playSlider.value = 0;
			playSlider.liveDragging = false;
			view.addChild(playSlider);
			playSlider.addEventListener( FeathersEventType.END_INTERACTION, playSlider_changeHandler );
			
			playSlider.thumbProperties.defaultSkin = new Image(Assets.getMusicSeriesTexture("hoverSkin"));
			playSlider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			playSlider.maximumTrackProperties.defaultSkin =  new Scale9Image(maxScale9Txtur);
			playSlider.thumbProperties.stateToSkinFunction = null;
			playSlider.minimumTrackProperties.stateToSkinFunction = null;
			playSlider.maximumTrackProperties.stateToSkinFunction = null;
			playSlider.thumbProperties.minWidth = soundSlider.thumbProperties.minHeight = 0;
			
			
			playTimeTxt = new TextField(120,20,"00:00/00:00","HeiTi",14,0xFFFFFF);
			playTimeTxt.x = 1018;
			playTimeTxt.y = 92;
			playTimeTxt.touchable = false;
			view.addChild(playTimeTxt);
			
			
			var mode:String = config.getValueInUser(modeKey);
			switch(mode){
				case "0"://顺序
					randomStyleBtn.alpha = defauldAlpha;
					orderStyleBtn.alpha = 1
					circulateStyleBtn.alpha = defauldAlpha;
					break;								
				case "1"://单曲
					randomStyleBtn.alpha = defauldAlpha;
					orderStyleBtn.alpha = defauldAlpha;
					circulateStyleBtn.alpha = 1;
					break;
				case "2"://随机
					randomStyleBtn.alpha = 1;
					orderStyleBtn.alpha =defauldAlpha;
					circulateStyleBtn.alpha = defauldAlpha;
					break;
				default:
					randomStyleBtn.alpha = defauldAlpha;
					orderStyleBtn.alpha = defauldAlpha;
					circulateStyleBtn.alpha = 1;
					config.updateValueInUser(modeKey,1);
					break;
			}
					
			
		}
		private function startPlayTime():void{
			var total:int = int(mp3Proxy.getLength()/1000);
			playSlider.maximum = total;
			var current:int = int(mp3Proxy.getPosition()/1000);
			trace(current);
			playSlider.value = current;
			TweenLite.delayedCall(1,startPlayTime);

			
			playTimeTxt.text = MyUtils.setFormat(playSlider.value)+"/"+MyUtils.setFormat(total);
		}
		
		private function slider_changeHandler(event:Event):void
		{			
			mp3Proxy.setVolume(soundSlider.value/10);
			config.updateValueInUser(soundVolume,soundSlider.value);
		}
		private function playSlider_changeHandler(event:Event):void
		{
			mp3Proxy.jumpTime(playSlider.value*1000);
			
		}

		private function randomStyleHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				config.updateValueInUser(modeKey,2);
				//mode = 2;//随机播放
				randomStyleBtn.alpha = 1;
				orderStyleBtn.alpha =defauldAlpha;
				circulateStyleBtn.alpha = defauldAlpha;
			}
		}
		
		private function orderStyleHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				//mode = 0;//顺序播放
				config.updateValueInUser(modeKey,0);
				randomStyleBtn.alpha = defauldAlpha;
				orderStyleBtn.alpha = 1
				circulateStyleBtn.alpha = defauldAlpha;
			}
		}
		
		private function circulateStyleHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				//mode = 1;//单曲循环
				config.updateValueInUser(modeKey,1);
				randomStyleBtn.alpha = defauldAlpha;
				orderStyleBtn.alpha = defauldAlpha;
				circulateStyleBtn.alpha = 1;
			}
		}
		
		private function nextHandler(e:TouchEvent):void
		{
			if(e==null || e.touches[0].phase=="ended"){
				if(listArr==null || listArr.length<2) return;
				if(index < listArr.length-1) index++;
				else index = 0;
				TweenLite.killDelayedCallsTo(delayPlayHandler);
				TweenLite.delayedCall(0.5,delayPlayHandler);
				preBoo =false;
			}
		}
		
		private function preHandler(e:TouchEvent):void
		{
			if(e==null || e.touches[0].phase=="ended"){
				if(listArr==null || listArr.length<2) return;
				if(index > 0) index--;
				else index = listArr.length-1;
				TweenLite.killDelayedCallsTo(delayPlayHandler);
				TweenLite.delayedCall(0.5,delayPlayHandler);
				preBoo = true;
			}
		}
		
		private function delayPlayHandler():void{
			if(listArr!=null && listArr.length>1){
				if(index <= 0) index=0;
				else if( index > listArr.length-1) index = listArr.length-1;
//				titleTxt.text = listArr.getItemAt(index).Name;
				songName = listArr.getItemAt(index).Name;;
				mp3Proxy.stop();
				mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
			}
		}
		
		private function pauseHandler(e:TouchEvent):void
		{			
			if(e.touches[0].phase=="ended"){
				playBtn.visible = true;
				pauseBtn.visible = false;
				mp3Proxy.pause();
				TweenLite.killDelayedCallsTo(startPlayTime);
			}
		}
		
		private function playHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				if(listArr==null || listArr.length==0) {
					try{
						var mediator:MusicListPlayMediator = (facade.retrieveMediator(MusicListPlayMediator.NAME) as MusicListPlayMediator);
						listArr = mediator.dic[mediator.currentGrid];
					}catch(e:Error){
						
					}											
				}
				if(listArr==null || listArr.length==0) return;
				var file:File;
				var hasFile:Boolean;
				for(var i:int=0;i<listArr.length;i++){
					file = Global.document.resolvePath(Global.localPath+ listArr.getItemAt(i).encrypt);	
					if(file.exists){
						hasFile = true;
						break;
					}
				}
				if(listArr.length>0 && hasFile){
					playBtn.visible = false;
					pauseBtn.visible = true;
					if(mp3Proxy.soundChannel){						
						mp3Proxy.resume();
					}else{
						if(index <= 0) index=0;
						else if( index > listArr.length-1) index = listArr.length-1;
						mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
//						titleTxt.text = listArr.getItemAt(index).Name;
						songName = listArr.getItemAt(index).Name;;
					}				
					TweenLite.killDelayedCallsTo(startPlayTime);
					TweenLite.delayedCall(1,startPlayTime);
				}				
			}			
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case SECECT_SOUNDS:					
					var base:MusicBaseClass = notification.getBody() as MusicBaseClass;
					if(base.Name == titleTxt.text) return;
					var mediator:MusicListPlayMediator = (facade.retrieveMediator(MusicListPlayMediator.NAME) as MusicListPlayMediator);
					listArr = mediator.dic[mediator.currentGrid];
					if(listArr==null || listArr.length==0) {
						 return;
					}
					
					if(listArr.contains(base)){
						playBtn.visible = false;
						pauseBtn.visible = true;
						index = listArr.getItemIndex(base);
						mp3Proxy.stop();
						mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
//						titleTxt.text = listArr.getItemAt(index).Name;
						songName = listArr.getItemAt(index).Name;;
						TweenLite.killDelayedCallsTo(startPlayTime);
						TweenLite.delayedCall(1,startPlayTime);
						break;
					}
					break;
				case MP3PlayerProxy.LOADED_COMPLETE:
					titleTxt.text = songName;
					break;
				case MP3PlayerProxy.SOUND_ERROR://播放歌曲不存在
					if(listArr.length>1){
						if(preBoo ){//可以不停的向前检索							
							if(index>0){
								index--;
								mp3Proxy.stop();
								mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
//								titleTxt.text = listArr.getItemAt(index).Name;
								songName = listArr.getItemAt(index).Name;;
							}else{
								index=listArr.length-1
								TweenLite.killDelayedCallsTo(delayPlayHandler);
								TweenLite.delayedCall(1,delayPlayHandler);
							}
						}else {
							if(index < listArr.length-1){	//不停的向后检索									
								index++;
								mp3Proxy.stop();
								mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
//								titleTxt.text = listArr.getItemAt(index).Name;
								songName = listArr.getItemAt(index).Name;;
							}else{
								index = 0;
								TweenLite.killDelayedCallsTo(delayPlayHandler);
								TweenLite.delayedCall(1,delayPlayHandler);
							}
							
						}
					}
					
					break;
				case MP3PlayerProxy.SOUND_COMPLETE:
					if(listArr==null || index>=listArr.length) return
					var mode:String = config.getValueInUser(modeKey);
					if(mode=="0"){//顺序
						nextHandler(null);
					}else if(mode=="1"){//单曲
						mp3Proxy.stop();
						mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
					}else if(mode=="2"){//随机
						if(listArr.length>2){
							index = int(Math.random()*listArr.length);
							mp3Proxy.stop();
							mp3Proxy.play(listArr.getItemAt(index).Encrypt_path,0,0,soundSlider.value/10);
//							titleTxt.text = listArr.getItemAt(index).Name;
							songName = listArr.getItemAt(index).Name;;
						}else{
							nextHandler(null);
						}
					}
					break;
				case WorldConst.Del_Music:
					base = notification.getBody() as MusicBaseClass;
					if(listArr.contains(base)){
						if(index == listArr.getItemIndex(base)){
							mp3Proxy.stop();
							titleTxt.text = '请选择要播放的歌曲';
							playBtn.visible = true;
							pauseBtn.visible = false;
						}
					}
					base = null;
					break;

				/*case CoreConst.DEACTIVATE://AIR3.9发布后。音乐可以后台播放。配置文件中渲染模式设为“direct”。。
					if(mp3Proxy.isRunning){
						NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
						
					}
					break;*/
			}
		}
		override public function listNotificationInterests():Array{
			return [SECECT_SOUNDS,MP3PlayerProxy.SOUND_ERROR,MP3PlayerProxy.SOUND_COMPLETE,WorldConst.Del_Music,MP3PlayerProxy.LOADED_COMPLETE];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);						
		}
	}
}