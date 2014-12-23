package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.effects.Bubbles;
	import com.studyMate.world.screens.email.EmailViewMediator;
	import com.studyMate.world.screens.talkingbook.TalkingBookMediator;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import feathers.controls.Alert;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
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
	import starling.extensions.PixelHitArea;
	import starling.extensions.PixelImageTouch;
	import starling.textures.Texture;
	
	public class WorldMediator extends ScreenBaseMediator
	{
		public static var NAME:String = "WorldMediator";
		private static const GET_MONEY:String = NAME + "GetMoney";
		
		private var range:Rectangle = new Rectangle(-640,100,1280,300);
		
		private var _background:OceanBackground;
		private var _foreground:OceanForeground;
		private var currentX:int;
		
		private var viewPoint:Point;
		
		private var throwDis:int;
		
		private var t1:uint, t2:uint;
		
		private var x1:int,x2:int;
		
//		private var _juggler:Juggler;
		
		private var charater:WhaleMediator;
		
		private var island:PixelImageTouch;
		private var island2:PixelImageTouch;
		private var rainbow:PixelImageTouch;
		
		
		private var bubbles:Bubbles;
		
		private var camera:CameraSprite;
		
		private var background:Image;
		private var seabed:Image;
		
//		private var nightSky:StretchImage;
		
		
//		private var nightImage:Image;
//		private var dayImage:Image;
//		
//		private var isTap:Boolean;
		
		private var hit_1:PixelHitArea;
		private var chapterSeleterVO:SwitchScreenVO;
//		private var jellyfish:MovieClip;
//		private var reflection:Image;
		
		public function WorldMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			Starling.current.stage.color = 0xFFFFFF;
//			SoundAS.loadSound(MyUtils.getSoundPath("shortCutPop2.mp3"),"shortCutPop2");
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("shortCutPop2.mp3"),"shortCutPop2"));
			chapterSeleterVO = new SwitchScreenVO(ChapterSeleterMediator,8,SwitchScreenType.SHOW,view);
			sendNotification(WorldConst.SWITCH_SCREEN, [chapterSeleterVO]);
			
//			Global.isEmail = true;
			//var daySky:StretchImage = new StretchImage(Assets.getAtlas().getTexture("bg/sky"),new InfiniteRectangle(Number.NEGATIVE_INFINITY, 0, Number.POSITIVE_INFINITY, 285),new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight),20);
			//view.addChild(daySky);
//			dayImage = new Image(Assets.getTexture("dayBg"));
//			view.addChild(dayImage);
//			
//			nightImage = new Image(Assets.getTexture("nightBg"));
//			nightImage.alpha = 0;
//			view.addChild(nightImage);
			
			
			background = new Image(Assets.getTexture("background"));
			background.x = -40;
			view.addChild(background);
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HeavenMediator,null,SwitchScreenType.SHOW,view)]);
			
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			
			_background=new OceanBackground();
			_background.touchable = false;
			camera.addChild(_background);
			
			
//			_background.hill.blendMode = BlendMode.MULTIPLY;
//			_background.hill.alpha = 0.5;
			
			currentX = 0;
//			camera.moveTo(0, 0, 1.55, 0, true);// force the camera in for a closeup
//			camera.easingZoom=.01;//set the zoom easing low for a slow zoom ease
			camera.moveTo(0, 0, 1, 0, false); //set a broader zoom (pull out slowly)
			viewPoint = new Point;
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			
			
//			_juggler = Starling.juggler;
			
			var texture:Texture;
			
			
			hit_1 = new PixelHitArea ( Assets.store["chapterBMP"],0.5);
			
			
			texture = Assets.getChapterAtlasTexture("chapter/chapter1");
			
			
			island = new PixelImageTouch(texture,hit_1);
			island.hitArea = hit_1;
			
			camera .addChild(island);
			island.pivotX = island.width>>1;
			island.pivotY = island.height>>1;
//			island.x=-60;
			island.x=100;
			island.y = -30;
			island.addEventListener(TouchEvent.TOUCH,islandHandle);
			
			
			
			texture = Assets.getChapterAtlasTexture("chapter/rainbow");
			rainbow = new PixelImageTouch(texture)
			rainbow.x = 1200;
			rainbow.y = -190;
			camera.addChild(rainbow);
			
				
			texture = Assets.getChapterAtlasTexture("chapter/chapter2");
			island2 = new PixelImageTouch(texture,hit_1);
			island2.hitArea = hit_1;
			
			
			/*var reflection:Image = new Image(texture);
			reflection.touchable = false;
			reflection.x = 1280;
			reflection.y = 60;
			reflection.scaleY = -1;
			reflection.pivotX = reflection.width>>1;
			reflection.pivotY = reflection.height>>1;
			reflection.alpha = 0.3;
			
			camera .addChild(reflection);*/
//			addReflectionTo(reflection);
			
			camera .addChild(island2);
			island2.pivotX = island2.width>>1;
			island2.pivotY = island2.height>>1;
//			island2.x= 1100;
			island2.x=1320;
			island2.y = -30;
			island2.addEventListener(TouchEvent.TOUCH,secIslandHandle);
			
			
			var fishBowlMediator:FishBowlMediator = new FishBowlMediator(camera.world,new Rectangle(-800,200,3000,200));
			facade.registerMediator(fishBowlMediator);
			
			
			
			bubbles = new Bubbles;
			camera.addChild(bubbles);
			bubbles.x = 3200;
			bubbles.y = 500;
			
			
			charater = new WhaleMediator(new Sprite(),null);
			camera .addChild(charater.view);
			
			charater.range = range;
			
			
			facade.registerMediator(charater);
			
			charater.move(0,-50);
			
			_foreground=new OceanForeground();
			camera.addChild(_foreground);
			
			charater.goX(-300);;
			
			var comming:Image;
			texture = Assets.getChapterAtlasTexture("chapter/commingsoon");
			for (var i:int = 0; i < 7; i++) 
			{
				comming = new Image(texture);
				camera .addChild(comming);
				comming.pivotX = comming.width>>1;
				comming.pivotY = comming.height>>1;
				comming.x=(i+2)*1280;
				comming.y = -50;
			}
			

//			
			
			/*jellyfish = new MovieClip(Assets.getAtlas().getTextures("charater/jellyfish"));
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:jellyfish,holder:camera,range:range,randomSize:false,
				fps:4,setFrameDuration:[0.128,0.112,0.45,0.16]});*/
			

			createShortCut();
			
			//显示公告栏
			sendNotification(WorldConst.SHOW_NOTICE_BOARD);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU_GOLD,true);	//显示金币框
			
			
//			sendNotification(WorldConst.GET_UNREAD_MESSAGE);
			/*sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["U"],SwitchScreenType.SHOW, view.stage)]);*/
			sendNotification(WorldConst.SHOW_CHANGE_LOG, view);
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 2);
			sendNotification(WorldConst.UPDATE_LEFT_MENU_GOLD,Global.goldNumber);
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["U"],SwitchScreenType.SHOW, AppLayoutUtils.uiLayer)]);
			
			if(Global.unreadMessage){
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["U"],SwitchScreenType.SHOW, AppLayoutUtils.uiLayer)]);
			}
			
			
			if(!Global.loopSound){
				var sound:Sound = new Sound(new URLRequest(Global.document.resolvePath(Global.localPath+"/mp3/gameEff/stage.mp3").nativePath));
				Global.loopSound = sound.play(0,Number.MAX_VALUE,new SoundTransform(0));
			}
			

			
			this.backHandle = quitHandle;
			trace("@VIEW:WorldMediator:");
		}
		private var alert:Alert;
		private function quitHandle():void{
			sendNotification(WorldConst.RECORD_ACTION_FLAG, "FeatherAlertShow");
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
			alert = Alert.show( "确定要回退到登陆界面吗？","温馨提示", new ListCollection(
					[
						{ label: "确定",triggered:exitHandle},
						{ label: "取消"}
					]));
			
			trace("@VIEW:FeatherAlertShow:");
			
		}
		private function exitHandle():void{
			PackData.app.CmdIStr[0] = CmdStr.RETURN_LOGIN;
			PackData.app.CmdIStr[1] = NAME;
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO("",null,"cn-gb",null,SendCommandVO.QUEUE));
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.POP_SCREEN);
		}
		
		private function updateGold():void{
			
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY,null,"cn-gb",null,SendCommandVO.QUEUE));
			
		}
		
		
		private function secIslandHandle(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EnglishIslandMediator)]);
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HappyIslandMediator)]);
						//sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IndexMusicMediator)]);
						/*chapterSeleterVO.type = SwitchScreenType.HIDE;
						sendNotification(WorldConst.SWITCH_SCREEN, [chapterSeleterVO]);*/
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandsMapMediator)]);
						(event.target as DisplayObject).touchable = false; 
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HappyIslandMediator),new SwitchScreenVO(CleanCpuMediator)]);
						return;
					}
				}
			}
		}
		
		private var beginX:Number;
		private var endX:Number;
		private function islandHandle(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						showShortCut();
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EngTaskIslandMediator)]);
//						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HappyIslandMediator)]);
					}
				}
			}
		}
		private var picBookBtn:Button;
		private var readingBtn:Button;
		private var wordBtn:Button;
		private var enterBtn:Button;
		private function createShortCut():void{
			picBookBtn = new Button(Assets.getChapterAtlasTexture("chapter/chapter1_PicBook"));
			picBookBtn.name = "picBookBtn";
			centerPivot(picBookBtn);
			picBookBtn.x = -135;
			picBookBtn.y = -160;
			camera .addChild(picBookBtn);
			picBookBtn.addEventListener(Event.TRIGGERED,shortCutHandle);

			readingBtn = new Button(Assets.getChapterAtlasTexture("chapter/chapter1_Reading"));
			readingBtn.name = "readingBtn";
			centerPivot(readingBtn);
			readingBtn.x = 140;
			readingBtn.y = -160;
			camera .addChild(readingBtn);
			readingBtn.addEventListener(Event.TRIGGERED,shortCutHandle);

			wordBtn = new Button(Assets.getChapterAtlasTexture("chapter/chapter1_Word"));
			wordBtn.name = "wordBtn";
			centerPivot(wordBtn);
			wordBtn.x = 400;
			wordBtn.y = -80;
			camera .addChild(wordBtn);
			wordBtn.addEventListener(Event.TRIGGERED,shortCutHandle);

			enterBtn = new Button(Assets.getChapterAtlasTexture("chapter/chapter1_Enter"));
			enterBtn.name = "enterBtn";
			centerPivot(enterBtn);
			enterBtn.x = 310;
			enterBtn.y = 35;
			camera .addChild(enterBtn);
			enterBtn.addEventListener(Event.TRIGGERED,shortCutHandle);
			
			doHide();
		}
		private function showShortCut():void{
			/*try{
				
				SoundAS.play("shortCutPop2");
			}catch(e:Error){
				
			}*/
				
			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("shortCutPop2"));
			
			TweenLite.killTweensOf(picBookBtn);
			TweenLite.killTweensOf(readingBtn);
			TweenLite.killTweensOf(wordBtn);
			TweenLite.killTweensOf(enterBtn);
			
			picBookBtn.visible = true;
			picBookBtn.scaleX = 1;
			picBookBtn.scaleY = 1;
			picBookBtn.y = -170;
			
			readingBtn.visible = true;
			readingBtn.scaleX = 1;
			readingBtn.scaleY = 1;
			readingBtn.y = -150;
			
			wordBtn.visible = true;
			wordBtn.scaleX = 1;
			wordBtn.scaleY = 1;
			wordBtn.y = -120;
			
			enterBtn.visible = true;
			enterBtn.scaleX = 1;
			enterBtn.scaleY = 1;
			enterBtn.y = 35;
			
			TweenLite.from(picBookBtn,0.5,{scaleX:0,scaleY:0,y:picBookBtn.y+picBookBtn.height,ease:Elastic.easeOut,onComplete:doShow});
			TweenLite.from(readingBtn,0.5,{delay:0.1,scaleX:0,scaleY:0,y:readingBtn.y+readingBtn.height,ease:Elastic.easeOut});
			TweenLite.from(wordBtn,0.5,{delay:0.2,scaleX:0,scaleY:0,y:wordBtn.y+wordBtn.height,ease:Elastic.easeOut});
			TweenLite.from(enterBtn,0.5,{delay:0.3,scaleX:0,scaleY:0,y:enterBtn.y+enterBtn.height,ease:Elastic.easeOut});
			
			
		}
		private function doShow():void{
			island.removeEventListener(TouchEvent.TOUCH,islandHandle);
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,hideShortCut);
		}
		
		private function hideShortCut(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.ENDED){
					Starling.current.stage.removeEventListener(TouchEvent.TOUCH,hideShortCut);
					island.addEventListener(TouchEvent.TOUCH,islandHandle);
					
					doHide();
				}
			}
		}
		private function doHide():void{
			picBookBtn.visible = false;
			readingBtn.visible = false;
			wordBtn.visible = false;
			enterBtn.visible = false;
		}
		
		//4个按钮的监听
		private function shortCutHandle(event:Event):void{
			switch((event.target as Button).name){
				case "picBookBtn":
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TalkingBookMediator),new SwitchScreenVO(CleanCpuMediator)]);

					break;
				case "readingBtn":
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
						[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
					break;
				case "wordBtn":
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
						[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
					break;
				case "enterBtn":
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EnglishIslandMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EngTaskIslandMediator)]);
					
//					sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
					break;
			}
		}
		
		/*protected function onCurrentVideoChanged(event:Event):void
		{
			trace("Current video: " + AirVideo.getInstance().currentVideo + " - " + AirVideo.getInstance().queue.length + " videos in queue");
			
		}*/
		
		override public function onRemove():void
		{			
//			SoundAS.removeSound("shortCutPop2");
			
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
			
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'shortCutPop2');
			sendNotification(WorldConst.HIDE_LEFT_MENU);
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			facade.removeMediator(charater.getMediatorName());
			island.dispose();
			hit_1.dispose();
			PixelHitArea.dispose();
			bubbles.dispose();
			facade.removeMediator(FishBowlMediator.NAME);
			camera.removeChildren(0,-1,true);
			camera.dispose();
			
//			jellyfish.dispose();
			
			view.removeChildren(0,-1,true);
			
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
			
//			reflectionTexture.dispose();
			TweenLite.killTweensOf(picBookBtn);
			TweenLite.killTweensOf(readingBtn);
			TweenLite.killTweensOf(wordBtn);
			TweenLite.killTweensOf(enterBtn);
			island.removeEventListener(TouchEvent.TOUCH,islandHandle);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,hideShortCut);
		}
		
		
		private function addToStageHandle(event:Event):void
		{
			/*var freeTransform:TransformGesture = new TransformGesture(view.stage);
			freeTransform.addEventListener(TransformGestureEvent.GESTURE_TRANSFORM, onTransform, false, 0, true);
			freeTransform.delegate = view as IGestureDelegate;*/
			
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(name)
			{
				case WorldConst.UPDATE_CAMERA:
				{
					if(camera)
						camera.moveTo(notification.getBody() as int,0,1,0,false);
					break;
				}
				case WorldConst.UPDATE_FLIP_PAGE_INDEX:
				{
					var xx:Number = notification.getBody() as Number;
					if(charater)
						charater.goX(xx*WorldConst.stageWidth-300);;
					range.x = xx*WorldConst.stageWidth-640;
					
					break;
				}
				case GET_MONEY:
					if(!result.isErr){
						Global.goldNumber = parseInt(PackData.app.CmdOStr[4]);
						
					}
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					break;
				default:{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.UPDATE_FLIP_PAGE_INDEX,WorldConst.UPDATE_WORLD_TIME,WorldConst.UPDATE_TASKLIST_COMPLETE,GET_MONEY];
		}
		
		
		private function cameraUpdate():void{
			
			if(!myIsNaN(viewPoint.x)){//!isNaN
				camera.moveTo(viewPoint.x,0,.6,0,false);
			}
			
		}
		
		private function myIsNaN(val:Number): Boolean
		{
			return !(val <= 0) && !(val > 0);
		}
		
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		
		private function updateBackground(e:CameraUpdateEvent):void
		{
			_background.show(e.viewport);
			if(_foreground) _foreground.show(e.viewport);
			
		}
		
		private var vo:SwitchScreenVO = new SwitchScreenVO;
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			updateGold();
		}
//		
//		private var reflectionTexture:Texture;
//		private function addReflectionTo(target:DisplayObject):void
//		{
//			var offset:Number = 0;
//			var scale:Number = Starling.contentScaleFactor;
//			var width:int  = target.width * scale;
//			var height:int = target.height * scale;
//			
//			var perlinData:BitmapData = new BitmapData(width, height, false);
//			perlinData.perlinNoise(200*scale, 20*scale, 2, 5, true, true, 0, true);
//			
//			var dispMap:BitmapData = new BitmapData(width, height*2, false);
//			dispMap.copyPixels(perlinData,perlinData.rect, new Point(0,0));
//			dispMap.copyPixels(perlinData,perlinData.rect, new Point(0,perlinData.height));
//			
//			reflectionTexture = Texture.fromBitmapData(dispMap);
//			var filter:DisplacementMapFilter = new DisplacementMapFilter(reflectionTexture, null,
//				BitmapDataChannel.RED, BitmapDataChannel.RED, 40, 5);
//			dispMap.dispose();
//			perlinData.dispose();
//			target.filter = filter;
//			target.addEventListener(EnterFrameEvent.ENTER_FRAME, function(event:EnterFrameEvent):void
//			{
//				if (offset > height) offset = 0;
//				else offset += event.passedTime * scale * 20;
//				
//				filter.mapPoint.y = offset - height;
//			});
//		}
		
		override public function activate():void
		{
			super.activate();
			trace("@VIEW:WorldMediator:");
			
			if(!facade.hasMediator(ChapterSeleterMediator.NAME)){
				Global.isFirstSwitch = false;
				sendNotification(WorldConst.SWITCH_SCREEN,[
					new SwitchScreenVO(ChapterSeleterMediator,8,SwitchScreenType.SHOW,view),
				]);
				
				Global.isFirstSwitch = true;
				
			}
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			
			facade.removeMediator(ChapterSeleterMediator.NAME);
		}
		
	}
}