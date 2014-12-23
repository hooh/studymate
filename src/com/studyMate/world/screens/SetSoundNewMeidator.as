package com.studyMate.world.screens
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	import com.studyMate.world.screens.ui.setSound.SetSoundView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import feathers.data.ListCollection;
	
	import net.digitalprimates.volume.VolumeController;
	import net.digitalprimates.volume.events.VolumeEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;

	public class SetSoundNewMeidator extends ScreenBaseMediator
	{
		public static const NAME:String = 'SetSoundNewMeidator';
		public static const Del_Music:String = NAME + "Del_Music";
		
		private var vo:SwitchScreenVO;
		private var config:IConfigProxy;
		
		private var bgMusicVolume:int;
		private var setBackgroundMusic:Boolean;
		private var setSoundEffects:Boolean;
		private var setSoftKeySoundBoo:Boolean;
		private var bgmList:Array;
		private var listCollection:ListCollection;
		
		public function SetSoundNewMeidator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			VolumeController.instance.removeEventListener(VolumeEvent.VOLUME_CHANGED,volumeChangeHandler);
			BitmapFontUtils.dispose();
			facade.removeMediator(UserBGMusicManagerMediator.NAME);
			super.onRemove();
		}
		override public function onRegister():void{
			view.init();//底层控制的，加载逻辑onRegister在后面
			var bgmManager:UserBGMusicManagerMediator = new UserBGMusicManagerMediator();
			facade.registerMediator(bgmManager);
			setingData();//初始化数据
			setingView();//初始化界面
		}
		
		private function setingData():void{
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
			/*tmpString = config.getValueInUser("bgMusicVolume");
			if(tmpString == ""){
				bgMusicVolume = 100;
				config.updateValueInUser("bgMusicVolume", "100");
			}else{
				bgMusicVolume = parseInt(tmpString);
			}*/			
			tmpString = config.getValueInUser("setSoftKeySoundBoo");
			if(tmpString == "true"){
				setSoftKeySoundBoo = true;
			}else if(tmpString == "false"){
				setSoftKeySoundBoo = false;
			}else{
				setSoftKeySoundBoo = false;
				config.updateValueInUser("setSoftKeySoundBoo", false);
			}
			
		}
		private function setingView():void{
			VolumeController.instance.addEventListener(VolumeEvent.VOLUME_CHANGED,volumeChangeHandler);
//			view.slider.value = bgMusicVolume;
			view.slider.value = VolumeController.instance.systemVolume*100;
			view.bgtswitch.isSelected = setBackgroundMusic;
			view.sefftswitch.isSelected = setSoundEffects;
			view.softKeySoundSwitch.isSelected = setSoftKeySoundBoo;
			
			view.slider.addEventListener( starling.events.Event.CHANGE, slider_changeHandler );		
			view.bgtswitch.addEventListener(starling.events.Event.CHANGE,bgtSwitchChangehandler);
			view.sefftswitch.addEventListener(starling.events.Event.CHANGE,sefftswitchChangeHandler);
			view.softKeySoundSwitch.addEventListener(starling.events.Event.CHANGE,softKeySoundSwitchChangeHandler);
			
			sendNotification(WorldConst.GET_BGMUSIC_LIST);
		}	
		
		private function volumeChangeHandler(event:flash.events.Event=null):void
		{
			view.slider.value = VolumeController.instance.systemVolume*100;
		}
		
		/**
		 * --------------------------各种开关的事件-------------------------------------------*/
		 
		private function slider_changeHandler( event:starling.events.Event ):void{
//			bgMusicVolume = view.slider.value;
//			config.updateValueInUser("bgMusicVolume", bgMusicVolume.toString());
			VolumeController.instance.setVolume(view.slider.value/100);
			
		}		
		private function softKeySoundSwitchChangeHandler():void{
			setSoftKeySoundBoo = view.softKeySoundSwitch.isSelected;
			config.updateValueInUser("setSoftKeySoundBoo", setSoftKeySoundBoo);
		}
		
		private function sefftswitchChangeHandler():void{
			setSoundEffects = view.sefftswitch.isSelected;
			config.updateValueInUser("setSoundEffects", setSoundEffects);
			if(setSoundEffects){
				sendNotification(CoreConst.MUTE_EFFECT_SOUND,false);
			}else{				
				sendNotification(CoreConst.MUTE_EFFECT_SOUND,true);
			}
		}		
		private function bgtSwitchChangehandler(e:starling.events.Event):void{
			setBackgroundMusic = view.bgtswitch.isSelected;
			config.updateValueInUser("setBackgroundMusic", setBackgroundMusic);
		}
		/** --------------------------各种开关的事件-------------------------------------------*/
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case WorldConst.GET_BGMUSIC_LIST_OVER :
					bgmList = notification.getBody() as Array;
					initBgMusicList();//设定界面
					sendNotification(WorldConst.VIEW_READY);
					break;
				case Del_Music:
					CacheTool.put('MusicSoundMediator','ChangeBackGround',true);//背景音乐已修改,需要更新
					var music:BackgroundMusicVO = notification.getBody() as BackgroundMusicVO; 
					listCollection.removeItem(music);
					sendNotification(WorldConst.DEL_BGMUSIC,music);
//					if(facade.hasMediator(MusicSoundMediator.NAME)){
//						facade.removeMediator(MusicSoundMediator.NAME);
//					}
					break;
				default : 
					break;
			}
		}
		
		//初始化音乐列表，嵌入位图字体。
		private function initBgMusicList():void
		{
			var str:String = '';
			var len:int = bgmList.length;
			listCollection = new ListCollection();
			for(var i:int = 0;i<len;i++){
				listCollection.push(bgmList[i]);
				str += bgmList[i].name;
				
			}
			
			if(str!=''){
				var assets:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"parents/del_Resource_icon");
				bmp.name = "parents/del_Resource_icon";
				assets.push(bmp);
				
				var ui:Shape = new Shape();
				ui.graphics.clear();
				ui.graphics.lineStyle(1,0xCACACA);  
				ui.graphics.beginFill(0x0EFEFEF,1);
				ui.graphics.drawRect(0,0,978,50);
				var bmd:BitmapData = new BitmapData(978,50,true,0);
				bmd.draw(ui);
				bmp = new Bitmap(bmd);
				bmp.name = 'bgQuad';
				assets.push(bmp);
				
				ui.graphics.clear();
				ui.graphics.lineStyle(1,0xFFFFFF);   
				ui.graphics.beginFill(0xEBEBEB,1);
				var mtrix:Matrix = new Matrix(1,0,0,1,0,0);
				ui.graphics.drawRect(0,0,978,49);
				bmd = new BitmapData(978,52,true,0);
				bmd.draw(ui,mtrix);
				bmp = new Bitmap(bmd);
				bmp.name = 'bgQuad2';
				assets.push(bmp);
				var tf:TextFormat = new TextFormat('HeiTi',20,0);
				tf.letterSpacing = -2;
				BitmapFontUtils.init(str,assets,tf);
				
				if(view.playList){
					view.playList.stopScrolling();
					view.playList.removeFromParent(true);
				}
				view.initList();
				
				view.playList.dataProvider = listCollection;				
			}			
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.HIDE_SETTING_SCREEN, WorldConst.GET_BGMUSIC_LIST_OVER,Del_Music];
		}		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		public function get view():SetSoundView{
			return getViewComponent() as SetSoundView;
		}
		override public function get viewClass():Class{
			return SetSoundView;
		}
	}
}