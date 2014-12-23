package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	import com.studyMate.world.screens.UserBGMusicManagerMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.music.MySlider;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	
	/**
	 * 背景音乐播放器
	 * @author wt
	 * 
	 */	
	public class MusicSoundMediator extends Mediator
	{
		public static const NAME:String = "MusicSoundMediator";
		
		public static const SHOW_MUSIC:String = NAME + "SHOW_MUSIC";
		
		
//		public static const RESUME_MUSIC:String =NAME+ "resumeMusic";
		private const soundVolume:String = "BgSoundVolume";
				
		private var mainUI:Sprite;
		private var playOrStopBtn:SimpleButton;
		private var preBtn:SimpleButton;
		private var nextBtn:SimpleButton;
		private var music_playSp:Sprite;
		private var music_stopSp:Sprite;
		private var soundNameTxt:TextField;
		private var soundSlider:Slider;
		private var loopBtn:SimpleButton;
		private var orderMusicSp:Sprite;
		private var oneMusicSp:Sprite;

		private static var soundArr:Vector.<BackgroundMusicVO>=new Vector.<BackgroundMusicVO>;
		private var playBoo:Boolean;
		private var preBoo:Boolean;
		private var Index:int;
		private var loopBoo:Boolean;//true单曲循环，false顺序播放
		
		private var mp3Proxy:MP3PlayerProxy;
		private var config:IConfigProxy
		
		private var bgmManager:UserBGMusicManagerMediator;
		
		public function MusicSoundMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			mp3Proxy = facade.retrieveProxy(MP3PlayerProxy.NAME) as MP3PlayerProxy;
			
			bgmManager = new UserBGMusicManagerMediator();
			facade.registerMediator(bgmManager);
			var mainUIClass:Class = AssetTool.getCurrentLibClass("MusicMain");
			mainUI = new mainUIClass();
			mainUI.x = (Global.stage.stageWidth-mainUI.width)/2;
			mainUI.y = (Global.stage.stageHeight-mainUI.height)/2-150;
			Starling.current.stage.touchable = false;
			Global.stage.addChild(mainUI);
			
			playOrStopBtn = mainUI.getChildByName("playOrStopBtn") as SimpleButton;
			preBtn = mainUI.getChildByName("music_preBtn") as SimpleButton;
			nextBtn = mainUI.getChildByName("music_nextBtn") as SimpleButton;
			music_playSp = mainUI.getChildByName("music_playBtn") as Sprite;
			music_stopSp = mainUI.getChildByName("music_stopBtn") as Sprite;
			soundNameTxt = mainUI.getChildByName("soundNameTxt") as TextField;
			orderMusicSp = mainUI.getChildByName("orderMusic") as Sprite;
			oneMusicSp = mainUI.getChildByName("oneMusic") as Sprite;
			oneMusicSp.visible = false;
			orderMusicSp.visible = true
			
			soundSlider = new MySlider();
			soundSlider.maximum = 20;
			soundSlider.move(130,214);
			mainUI.addChild(soundSlider);
			
			loopBtn = mainUI.getChildByName("loopBtn") as SimpleButton;
			soundNameTxt.maxChars = 15;
			soundNameTxt.text = "歌曲名";
			music_stopSp.visible = false;
			
			playOrStopBtn.addEventListener(MouseEvent.CLICK,stopOrPlayMusic);						
			preBtn.addEventListener(MouseEvent.CLICK,playPre);
			nextBtn.addEventListener(MouseEvent.CLICK,playNext);
			loopBtn.addEventListener(MouseEvent.CLICK,loopHandler);
			mainUI.addEventListener(MouseEvent.CLICK,mainUIClickHandler);
			
			var value:String = (config.getValueInUser(soundVolume));
			if(value==""){
				config.updateValueInUser(soundVolume,10);
				soundSlider.value = 10;
			}else{
				soundSlider.value = int(value);				
			}
			
			soundSlider.setSize(262,43);
			soundSlider.addEventListener(SliderEvent.CHANGE,soundSliderChangeFun);
			var thumb:Class =  AssetTool.getCurrentLibClass("mythumbUpSkin");
			var track:Class =  AssetTool.getCurrentLibClass("MusicTrack");
			soundSlider.setStyle("sliderTrackSkin",track);
			soundSlider.setStyle("thumbDownSkin",thumb);
			soundSlider.setStyle("thumbUpSkin",thumb);
			soundSlider.setStyle("thumbOverSkin",thumb);


			Global.stage.addEventListener(MouseEvent.CLICK,MusicStageClickHandler);						
			
			this.preparePlay();
		}
		
		private function checkSoundArr():void{
			soundArr = soundArr.filter(doEach);//本地可以用书本数组。
			if(soundArr.length<1){
				defaultMusic();
			}
		}
		private function doEach(item:BackgroundMusicVO, index:int, array:Vector.<BackgroundMusicVO>):Boolean{
			var file:File = new File(item.path);
			if(file.exists){
				item.path = file.url;
				return true;//文件存在
			}else
				return false;//文件不存在			
			
		}	
		
		private function preparePlay():void{
			if(CacheTool.has('MusicSoundMediator',"ChangeBackGround")){
				var Change_Background_Sound:Boolean = CacheTool.getByKey('MusicSoundMediator',"ChangeBackGround") as Boolean;
			}else{
				Change_Background_Sound = true;
			}
			if(Change_Background_Sound==true || soundArr==null){		
				CacheTool.put('MusicSoundMediator','ChangeBackGround',false);
				sendNotification(WorldConst.GET_BGMUSIC_LIST);
			}else{
				if(!mp3Proxy.isRunning){
					var url:String = config.getValueInUser("BeginBGMusic");
					if(url =="") return;
					for(var i:int=0;i<soundArr.length;i++){
						if(soundArr[i].path == url){
							Index = i;
							stopOrPlayMusic();
							break;
						}
					}
				}								
				var tmpString:String = config.getValueInUser("setBackgroundMusic");
				if(tmpString == "true"){
					if(!mp3Proxy.isRunning){
						stopOrPlayMusic();
					}
				}else if(tmpString == "false"){
					
				}else{
					stopOrPlayMusic();
					config.updateValueInUser("setBackgroundMusic", true);
				}
			}
		}
		
		private function showMusic():void{			
			if(mainUI && !Global.stage.contains(mainUI)){				
				if(Index>soundArr.length-1) Index = soundArr.length-1;
				if(Index<0) Index=0;
				this.preparePlay();
								
				Starling.current.stage.touchable = false;
				Global.stage.addChild(mainUI);
				Global.stage.addEventListener(MouseEvent.CLICK,MusicStageClickHandler);		
				
				trace("@VIEW:MusicSoundMediator:");
			}			
		}
		
		private function defaultMusic():void{
			var file:File =Global.document.resolvePath(Global.localPath + "Market/defaultBgMusic");
			var index:int=1;
			if(file.exists){
				var files:Array = file.getDirectoryListing();
				for each(var obj:* in files){
					var object:Object =new Object;												
					var bgVo:BackgroundMusicVO = new BackgroundMusicVO(index.toString(),"默认歌曲"+index, Global.document.resolvePath(obj.nativePath).url);
					soundArr.push(bgVo);
					index++;
				}
			}
			index = 1;
			
		}
		
		protected function loopHandler(event:MouseEvent):void{
			loopBoo = !loopBoo;
			if(loopBoo){
				oneMusicSp.visible = true;
				orderMusicSp.visible = false;
			}else{
				oneMusicSp.visible = false;
				orderMusicSp.visible = true;
			}
		}
		
		protected function soundSliderChangeFun(event:SliderEvent):void{
			mp3Proxy.setVolume(soundSlider.value/10);
			config.updateValueInUser(soundVolume,soundSlider.value);
		}
		
		protected function mainUIClickHandler(event:MouseEvent):void{
			event.stopImmediatePropagation();
		}
		
		protected function MusicStageClickHandler(event:MouseEvent):void{
			event.stopImmediatePropagation();
			Global.stage.removeEventListener(MouseEvent.CLICK,MusicStageClickHandler);
			Global.stage.removeChild(mainUI);
			Starling.current.stage.touchable = true;	
		}
		
		//播放和暂停
		private function stopOrPlayMusic(e:MouseEvent=null):void{
			if(e)	e.stopImmediatePropagation();
			if(soundArr.length){
				if(!playBoo){	
					if(Index>soundArr.length-1) Index = soundArr.length-1;
					if(Index<0) Index=0;
					if(mp3Proxy.soundChannel){						
						mp3Proxy.resume();
					}else{
						mp3Proxy.play(soundArr[Index].path);
					}
					music_playSp.visible = false;
					music_stopSp.visible = true;
					soundNameTxt.text = soundArr[Index].name;
					playBoo = true;							
					config.updateValueInUser("setBackgroundMusic", true);
				}else{					
					music_playSp.visible = true;
					music_stopSp.visible = false;
					mp3Proxy.pause();
					playBoo = false;		
					config.updateValueInUser("setBackgroundMusic", false);
				}				
			}
		}
		//下一首
		private function playNext(e:MouseEvent=null):void {
			
			if(e!=null){
				e.stopImmediatePropagation();
				if(soundArr.length<2) return;				
			}else{
				if(soundArr.length<1) return;	
			}
			if(Index < soundArr.length-1) Index++;
			else Index = 0;
			preBoo = false;
			soundNameTxt.text = soundArr[Index].name;
			TweenLite.killDelayedCallsTo(playHandler);
			TweenLite.delayedCall(0.8,playHandler);
		}  
		//前一首
		private function playPre(e:MouseEvent):void {
			if(soundArr.length<2) return;
			e.stopImmediatePropagation();
			if(Index > 0) Index--;
			else Index = soundArr.length-1;
			preBoo = true;
			soundNameTxt.text = soundArr[Index].name;
			TweenLite.killDelayedCallsTo(playHandler);
			TweenLite.delayedCall(0.8,playHandler);
		}  
		
		private function playHandler():void{
			if(soundArr.length>0){				
				mp3Proxy.stop();
				mp3Proxy.play(soundArr[Index].path);
				playBoo = true;														
			}
		}
								
		override public function handleNotification(notification:INotification):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification" + notification.getName(),"MusicSoundMediator",0));
			switch(notification.getName()){
				case SHOW_MUSIC:
					showMusic();
					break;
				case WorldConst.GET_BGMUSIC_LIST_OVER :
					var arr:Array = notification.getBody() as Array;
					soundArr = new Vector.<BackgroundMusicVO>;
					for(var i:int=0;i<arr.length;i++){
						soundArr[i] = arr[i];
						soundArr[i].path = Global.document.resolvePath(Global.localPath+arr[i].path).url;
					}
					checkSoundArr();
					
					if(!mp3Proxy.isRunning){
						var url:String = config.getValueInUser("BeginBGMusic");
						if(url =="") return;
						for(i=0;i<soundArr.length;i++){
							if(soundArr[i].path == url){
								Index = i;
								stopOrPlayMusic();
								break;
							}
						}
					}
					
					
					var tmpString:String = config.getValueInUser("setBackgroundMusic");
					if(tmpString == "true"){
						if(!mp3Proxy.isRunning){
							stopOrPlayMusic();
						}
					}else if(tmpString == "false"){
						
					}else{
						stopOrPlayMusic();
						config.updateValueInUser("setBackgroundMusic", true);
					}
					
					break;
				case MP3PlayerProxy.SOUND_COMPLETE:
					if(loopBoo){//trace("循环播放");		
						if(Index>soundArr.length-1) Index = soundArr.length-1;
						if(Index<0) Index=0;
						mp3Proxy.stop();
						mp3Proxy.play(soundArr[Index].path);
					}else{
						playNext();
					}					
					break;
				case MP3PlayerProxy.SOUND_STOP:
					music_playSp.visible = true;
					music_stopSp.visible = false;
					mp3Proxy.pause();
					soundNameTxt.text = "";
					playBoo = false;					
					break;
				case MP3PlayerProxy.SOUND_ERROR://播放歌曲不存在
					if(soundArr.length>1){
						if(preBoo ){//可以不停的向前检索		
							if(Index>0){
								Index--;
								mp3Proxy.stop();
								mp3Proxy.play(soundArr[Index].path);
								soundNameTxt.text = soundArr[Index].name;
							}else{
								Index=soundArr.length-1;
								TweenLite.killDelayedCallsTo(playHandler);
								TweenLite.delayedCall(2,playHandler);
							}
						}else{
							if(Index < soundArr.length-1){	//不停的向后检索									
								Index++;
								mp3Proxy.stop();
								mp3Proxy.play(soundArr[Index].path);
								soundNameTxt.text = soundArr[Index].name;
							}else{
								Index = 0;
								TweenLite.killDelayedCallsTo(playHandler);
								TweenLite.delayedCall(2,playHandler);
							}
						}
					}
					break;
				
				/*case RESUME_MUSIC://通知恢复界面播放
					if(soundArr.length && soundArr[Index]){
						if(playBoo){//如果是播放的则恢复						
							if(mp3Proxy.soundChannel){						
								mp3Proxy.resume();
							}else{
								mp3Proxy.play(soundArr[Index].path);
							}
							music_playSp.visible = false;
							music_stopSp.visible = true;
							soundNameTxt.text = soundArr[Index].name;
							playBoo = true;													
						}else{							
							music_playSp.visible = true;
							music_stopSp.visible = false;
							mp3Proxy.pause();
							playBoo = false;											
						}				
					}
					break;*/
				case MP3PlayerProxy.LOADED_COMPLETE:
					url = notification.getBody() as String;
					config.updateValueInUser("BeginBGMusic",url);
					mp3Proxy.setVolume(soundSlider.value/10);
					break;
				case CoreConst.ACTIVATE:
					if(mp3Proxy.isRunning){
						return;
					}
					if(Index>soundArr.length-1) Index = soundArr.length-1;
					if(Index<0) Index=0;
					if(soundArr.length && soundArr[Index]){
						if(playBoo){//如果是播放的则恢复						
							if(mp3Proxy.soundChannel){						
								mp3Proxy.resume();
							}else{								
								mp3Proxy.play(soundArr[Index].path);
							}
							music_playSp.visible = false;
							music_stopSp.visible = true;
							soundNameTxt.text = soundArr[Index].name;
							playBoo = true;													
						}else{							
							music_playSp.visible = true;
							music_stopSp.visible = false;
							mp3Proxy.pause();
							playBoo = false;											
						}				
					}
					break;
				case CoreConst.DEACTIVATE:
					if(mp3Proxy.isRunning){
						mp3Proxy.pause();
					}
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
					break;
			}
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification end" ,"MusicSoundMediator",0));

		}
		
		override public function listNotificationInterests():Array{
			return [SHOW_MUSIC,CoreConst.DEACTIVATE,CoreConst.ACTIVATE,MP3PlayerProxy.LOADED_COMPLETE,WorldConst.GET_BGMUSIC_LIST_OVER,MP3PlayerProxy.SOUND_COMPLETE,MP3PlayerProxy.SOUND_STOP,MP3PlayerProxy.SOUND_ERROR];
		}
				
		override public function onRemove():void{
			facade.removeMediator(UserBGMusicManagerMediator.NAME);
			if(Global.stage.hasEventListener(MouseEvent.CLICK))
				Global.stage.removeEventListener(MouseEvent.CLICK,MusicStageClickHandler);
			if(mainUI && Global.stage.contains(mainUI)){
				Global.stage.removeChild(mainUI);				
				Starling.current.stage.touchable = true;
			}
			mp3Proxy.onRemove();
			TweenLite.killDelayedCallsTo(playHandler);	
			
			super.onRemove();	
		}						
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}