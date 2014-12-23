package com.studyMate.world.screens
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.display.Scale9Image;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class SetSoundMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SetSoundMediator";
		private var vo:SwitchScreenVO;
		private var musicArray:Array;
		private var bgmManager:UserBGMusicManagerMediator;
		private var bgmList:Array;
//		private var bgmusicProxy:BackgroundMusicProxy;
		
		public function SetSoundMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private var config:IConfigProxy;
		private var bgMusicVolume:int;
		private var setBackgroundMusic:Boolean;
		private var setSoundEffects:Boolean;
		private var setSoftKeySoundBoo:Boolean;
		
		override public function onRegister():void{
			bgmManager = new UserBGMusicManagerMediator();
			facade.registerMediator(bgmManager);
//			bgmusicProxy = new BackgroundMusicProxy();
			var img:Image = new Image(Assets.getTexture("soundSetBg"));
			view.addChild(img);
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var tmpString:String = config.getValueInUser("setBackgroundMusic");
			if(tmpString == "true"){
				setBackgroundMusic = true;
			}else if(tmpString == "false"){
				setBackgroundMusic = false;
			}else{
				setBackgroundMusic = true;
				config.updateValueInUser("setBackgroundMusic", true);
			}
			tmpString = config.getValueInUser("setSoundEffects");
			if(tmpString == "true"){
				setSoundEffects = true;
			}else if(tmpString == "false"){
				setSoundEffects = false;
			}else{
				setSoundEffects = true;
				config.updateValueInUser("setSoundEffects", true);
			}
			tmpString = config.getValueInUser("bgMusicVolume");
			if(tmpString == ""){
				bgMusicVolume = 100;
				config.updateValueInUser("bgMusicVolume", "100");
			}else{
				bgMusicVolume = parseInt(tmpString);
			}
			
			tmpString = config.getValueInUser("setSoftKeySoundBoo");
			if(tmpString == "true"){
				setSoftKeySoundBoo = true;
			}else if(tmpString == "false"){
				setSoftKeySoundBoo = false;
			}else{
				setSoftKeySoundBoo = false;
				config.updateValueInUser("setSoftKeySoundBoo", false);
			}
			soundSettingView();
		}
		
		private var bgtswitch:ToggleSwitch;
		private var sefftswitch:ToggleSwitch;
		private var softKeySoundSwitch:ToggleSwitch;
		private var slider:Slider;
		
		private function soundSettingView():void{
			slider = new Slider();
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
			slider.width = 754;
			slider.step = 1; slider.page = 2;
			slider.minimum = 0; slider.maximum = 100;
			slider.value = bgMusicVolume; 
			slider.x = 167; slider.y = 72;
			view.addChild(slider);
			slider.liveDragging = false;
			slider.addEventListener( Event.CHANGE, slider_changeHandler );			
			slider.thumbProperties.defaultSkin = new Image(Assets.getAtlasTexture("set/soundSet/soundThumb"));
			
			var minRect:Rectangle = new Rectangle(4,0,3,13);
			var minScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("set/soundSet/minTrack"),minRect);
			slider.minimumTrackProperties.defaultSkin = new Scale9Image(minScale9Txtur);
			var maxRect:Rectangle = new Rectangle(1,0,3,13);
			var maxScale9Txtur:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("set/soundSet/maxTrack"),maxRect);
			slider.maximumTrackProperties.defaultSkin = new Scale9Image(maxScale9Txtur);			
			slider.thumbProperties.stateToSkinFunction = null;
			slider.minimumTrackProperties.stateToSkinFunction = null;
			slider.maximumTrackProperties.stateToSkinFunction = null;
			slider.thumbProperties.minWidth = slider.thumbProperties.minHeight = 18;
			
			var switchTrack:Scale9Image = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchTrack"),new Rectangle()));
			var switchThumb:Scale9Image = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchThumb"),new Rectangle()));
			
			bgtswitch = new ToggleSwitch();
			bgtswitch.x = 800; bgtswitch.y = 120;
			bgtswitch.isSelected = setBackgroundMusic;
			view.addChild(bgtswitch);
			bgtswitch.addEventListener(Event.CHANGE,bgtSwitchChangehandler);
			bgtswitch.defaultLabelProperties.textFormat = new TextFormat("comic", 10, 0x005291, false);
			bgtswitch.defaultLabelProperties.embedFonts = true;
			bgtswitch.onLabelProperties.textFormat = new TextFormat("comic", 10, 0xffffff, false);
			bgtswitch.onLabelProperties.embedFonts = true;
			bgtswitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			bgtswitch.onTrackProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchTrack"),new Rectangle()));
			bgtswitch.thumbProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchThumb"),new Rectangle()));
			bgtswitch.onTrackProperties.stateToSkinFunction = null;
			bgtswitch.thumbProperties.stateToSkinFunction = null;
			bgtswitch.thumbProperties.minWidth = bgtswitch.thumbProperties.minHeight = 21;
			bgtswitch.thumbProperties.minTouchWidth = bgtswitch.thumbProperties.minTouchHeight = 40;
			bgtswitch.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			
			sefftswitch = new ToggleSwitch();
			sefftswitch.x = 800; sefftswitch.y = 160;
			sefftswitch.isSelected = setSoundEffects;
			view.addChild(sefftswitch);
			sefftswitch.addEventListener(Event.CHANGE,sefftswitchChangeHandler);
			sefftswitch.defaultLabelProperties.textFormat = new TextFormat("comic", 10, 0x005291, false);
			sefftswitch.defaultLabelProperties.embedFonts = true;
			sefftswitch.onLabelProperties.textFormat = new TextFormat("comic", 10, 0xffffff, false);
			sefftswitch.onLabelProperties.embedFonts = true;
			sefftswitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			sefftswitch.onTrackProperties.defaultSkin = switchTrack;
			sefftswitch.thumbProperties.defaultSkin = switchThumb;
			sefftswitch.onTrackProperties.stateToSkinFunction = null;
			sefftswitch.thumbProperties.stateToSkinFunction = null;
			sefftswitch.thumbProperties.minWidth = sefftswitch.thumbProperties.minHeight = 21;
			sefftswitch.thumbProperties.minTouchWidth = sefftswitch.thumbProperties.minTouchHeight = 40;
			sefftswitch.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			
			softKeySoundSwitch = new ToggleSwitch();
			softKeySoundSwitch.x = 800; softKeySoundSwitch.y = 200;
			softKeySoundSwitch.isSelected = setSoftKeySoundBoo;
			view.addChild(softKeySoundSwitch);
			softKeySoundSwitch.addEventListener(Event.CHANGE,softKeySoundSwitchChangeHandler);
			softKeySoundSwitch.defaultLabelProperties.textFormat = new TextFormat("comic", 10, 0x005291, false);
			softKeySoundSwitch.defaultLabelProperties.embedFonts = true;
			softKeySoundSwitch.onLabelProperties.textFormat = new TextFormat("comic", 10, 0xffffff, false);
			softKeySoundSwitch.onLabelProperties.embedFonts = true;
			softKeySoundSwitch.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			softKeySoundSwitch.onTrackProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchTrack"),new Rectangle()));
			softKeySoundSwitch.thumbProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("set/soundSet/switchThumb"),new Rectangle()));
			softKeySoundSwitch.onTrackProperties.stateToSkinFunction = null;
			softKeySoundSwitch.thumbProperties.stateToSkinFunction = null;
			softKeySoundSwitch.thumbProperties.minWidth = softKeySoundSwitch.thumbProperties.minHeight = 21;
			softKeySoundSwitch.thumbProperties.minTouchWidth = softKeySoundSwitch.thumbProperties.minTouchHeight = 40;
			softKeySoundSwitch.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;
			
			layout = new VerticalLayout();
			layout.gap = 5;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			musicContainer = new ScrollContainer();
			musicContainer.layout = layout;
			musicContainer.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			musicContainer.snapScrollPositionsToPixels = true;
			musicContainer.x = 21; musicContainer.y = 274;
			musicContainer.width = 978; musicContainer.height = 480;
			view.addChild(musicContainer);
			getMusicList();
//			initMusicCon();
		}
		
		private function slider_changeHandler( event:Event ):void{
			bgMusicVolume = slider.value;
			config.updateValueInUser("bgMusicVolume", bgMusicVolume.toString());
			
		}
		
		private function softKeySoundSwitchChangeHandler():void{
			setSoftKeySoundBoo = softKeySoundSwitch.isSelected;
			config.updateValueInUser("setSoftKeySoundBoo", setSoftKeySoundBoo);
		}
		
		private function sefftswitchChangeHandler():void{
			setSoundEffects = sefftswitch.isSelected;
			config.updateValueInUser("setSoundEffects", setSoundEffects);
			if(setSoundEffects){
//				SoundAS.mute = false;
				sendNotification(CoreConst.MUTE_EFFECT_SOUND,false);
			}else{
//				SoundAS.mute = true;
				
				sendNotification(CoreConst.MUTE_EFFECT_SOUND,true);
			}
		}
		
		private function bgtSwitchChangehandler(e:Event):void{
			setBackgroundMusic = bgtswitch.isSelected;
			/*if(bgtswitch.isSelected){
				SoundAS.mute = false;
			}else{
				SoundAS.mute = true;
			}*/
			config.updateValueInUser("setBackgroundMusic", setBackgroundMusic);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case WorldConst.GET_BGMUSIC_LIST_OVER :
					bgmList = notification.getBody() as Array;
					initMusicCon();
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.HIDE_SETTING_SCREEN, WorldConst.GET_BGMUSIC_LIST_OVER];
		}
		
		
		private var musicContainer:ScrollContainer;
		private var layout:VerticalLayout;
		
		private function getMusicList():void{
			bgmList = new Array;
//			bgmManager.getListCommand();
			sendNotification(WorldConst.GET_BGMUSIC_LIST);
		}
		
		private function initMusicCon():void{
			for(var i:int = 0; i < bgmList.length; i++){
				if(bgmList[i] is BackgroundMusicVO)
					musicContainer.addChild(makeSp(bgmList[i]));
			}
		}
		
		//又没有封装成对象，怎么知道里面放的是什么，怎么访问
		private function makeSp(music:BackgroundMusicVO):Sprite{
			var sp:Sprite = new Sprite();
			sp.name = music.id;
			sp.addEventListener(TouchEvent.TOUCH, spTouchHandler);
			
			var quad:Quad = new Quad(978, 40, 0xe18242);
			quad.alpha = 0;
			sp.addChild(quad);
			var txt:TextField = new TextField(600, 40, music.name, "HuaKanT", 20, 0x5c310d);
			txt.autoScale = true; txt.vAlign = VAlign.CENTER; txt.hAlign = HAlign.LEFT;
			txt.x = 49;
			sp.addChild(txt);
			
			var delBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("targetWall/dele"));
			delBtn.x = quad.width - 65;
			delBtn.addEventListener(TouchEvent.TOUCH,delBtnHandler);
			sp.addChild(delBtn);
			return sp;
		}
		
		private var selectIndex:int = -1;
		private var onTouchBeginY:Number;
		private var onTouchEndY:Number;
		
		private function spTouchHandler(event:TouchEvent):void{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				onTouchBeginY = touch.globalY;
			}
			if(touch.phase == TouchPhase.ENDED){
				onTouchEndY = touch.globalY;
				//没封装的效果
				if(Math.abs(onTouchBeginY - onTouchEndY) < 10){
					if(selectIndex != -1){
						(musicContainer.getChildAt(selectIndex) as Sprite).getChildAt(0).alpha = 0;
					}
					var sp:Sprite = event.currentTarget as Sprite;
					sp.getChildAt(0).alpha = 0.1;
					selectIndex = musicContainer.getChildIndex(sp);
				}
			}
		}
		
		private function delBtnHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				CacheTool.put('MusicSoundMediator','ChangeBackGround',true);//背景音乐已修改,需要更新
				var sp:Sprite = (event.currentTarget as starling.display.Button).parent as Sprite;
				var music:BackgroundMusicVO = new BackgroundMusicVO(sp.name,null,null);
				if(selectIndex == musicContainer.getChildIndex(sp)){
					selectIndex = -1;
				}
//				bgmusicProxy.deleMusic(music);
//				bgmManager.delBgMusic(music);
				sendNotification(WorldConst.DEL_BGMUSIC,music);
				musicContainer.removeChild(sp, true);
				
				if(facade.hasMediator(MusicSoundMediator.NAME)){
					facade.removeMediator(MusicSoundMediator.NAME);
				}
			}
		}
		
		override public function onRemove():void{
			facade.removeMediator(UserBGMusicManagerMediator.NAME);
			super.onRemove();
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
	}
}