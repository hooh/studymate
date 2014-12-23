package com.studyMate.world.screens.wallpaper
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class PreviewWallpaperViewMediator extends ScreenBaseMediator
	{
		
		private const NAME:String = "PreviewWallpaperViewMediator";
		
		public function PreviewWallpaperViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		private var img:Bitmap = new Bitmap();
		private var texture:Texture;
		
		private var prepareVO:SwitchScreenVO;
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			img = vo.data as Bitmap;	
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite
		}
		
		public function get view():Sprite
		{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			
			texture = Texture.fromBitmap(img,false);
			var preImg:Image = new Image(texture);
			view.addChild(preImg);
			
			
			var _studyMateImg:Image = new Image(Assets.getWallpaperAtlasTexture("studyMateIcon"));
			_studyMateImg.x = 100;
			_studyMateImg.y = 270;
			view.addChild(_studyMateImg);
			
			
			
			var _wifiImg:Image = new Image(Assets.getWallpaperAtlasTexture("wifiIcon"));
			_wifiImg.x = 350;
			_wifiImg.y = 270;
			view.addChild(_wifiImg);
			
			var _baiduImg:Image = new Image(Assets.getWallpaperAtlasTexture("baiduIcon"));
			_baiduImg.x = 600;
			_baiduImg.y = 270;
			view.addChild(_baiduImg);
			
			
			var _time:Number = Number(MyUtils.getTimeFormat1().substr(10,3));
			var clock:String;
			if(_time>12)
			{
				clock = String((_time-12))+":"+MyUtils.getTimeFormat1().substr(14,8) + "  下午"
			}else{
				clock = MyUtils.getTimeFormat1().substr(10,10) +"  上午";
			}
			var _timeTxt:TextField = new TextField(450,150,clock,"serif",60,0xffffff,true);
			_timeTxt.x = 750;
			_timeTxt.y = 18;
			view.addChild(_timeTxt);
			
			
			view.addEventListener(TouchEvent.TOUCH,hidePreImgHandler);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHidePreImgHandler);
		}
		
		protected function keyHidePreImgHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode==Keyboard.BACK){
				event.preventDefault();
				event.stopImmediatePropagation();
				prepareVO.type = SwitchScreenType.HIDE	;
				sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHidePreImgHandler);
			}		
		}
		
		private function hidePreImgHandler(event:TouchEvent):void
		{
			if(event.touches[0].phase == "ended"){
				prepareVO.type = SwitchScreenType.HIDE	;
				sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHidePreImgHandler);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return[]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				
			}
		}
		
		override public function onRemove():void
		{
		}
		
	}
}