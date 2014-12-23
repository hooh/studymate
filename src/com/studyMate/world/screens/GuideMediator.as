package com.studyMate.world.screens
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class GuideMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "GuideMediator";
		private var vo:SwitchScreenVO;
		private var closeBtn:Button;
		
		private var photosFileList:Array;
		private var photos:Vector.<Image>;
		private var index:uint;
		private var total:uint;
		private var container:ScrollContainer;
		private var _scrollIndex:uint;
		private var indexSign:Image;
		private var spriteBaseX:Number;
		private var guideArray:Array;
		
		public function GuideMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get scrollIndex():uint
		{
			return _scrollIndex;
		}

		public function set scrollIndex(value:uint):void
		{
			_scrollIndex = value;
			indexSign.x = spriteBaseX + value * 19;
		}

		private function init():void{
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			quad.alpha = 0.3;
			view.addChild(quad);
		}
		
		override public function onRegister():void{
			guideArray = vo.data as Array;
			
			var bg:Image = new Image(Texture.fromBitmap(Assets.store["task_bg"],false));
			view.addChild(bg);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			init();
			addGuide();
			
			var texture:Texture = Assets.getAtlasTexture("flip/closeGuide");
			closeBtn = new Button(texture);
			closeBtn.x = 1170; closeBtn.y = 680;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
			
			AppLayoutUtils.cpuLayer.visible =false;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,GuideKeyDownHandler,false,2);
		}
		
		private function GuideKeyDownHandler(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			e.preventDefault();
			e.stopImmediatePropagation();
		}
		
		private function addGuide():void{
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = true;
			container.x = 0; container.y = 0;
			container.width = Global.stageWidth; container.height = Global.stageHeight;
			view.addChild(container);
			container.addEventListener(FeathersEventType.SCROLL_COMPLETE, charaterContainerHandle);
			
			var file:File = Global.document.resolvePath(Global.localPath+"media//guide");
			var list:Array = file.getDirectoryListing();
			var urlList:Array = new Array();
			var i:int = 0;
			if(guideArray && guideArray.length > 1){
				for(i = 0; i < list.length; i++){
					var j:int = 0
					for(j = 0; j < guideArray.length; j++){
						if(guideArray[j] == list[i].name){
							urlList.push(list[i].url);
							break;
						}
					}
					if(j == guideArray.length){
						list[i].deleteFile();
					}
				}
			}else{
				for(i = 0; i < list.length; i++){
					urlList.push(list[i].url);
				}
			}
			photosFileList = urlList.filter(photoUrlCallback);
			photosFileList.sort();
			total = photosFileList.length; index = 0;
			photos = new Vector.<Image>();
			loadPhotos();
		}
		
		private function charaterContainerHandle():void{
			var a:Number = container.horizontalScrollPosition / container.width;
			scrollIndex = a;
		}

		private function loadPhotos():void{
			if(index != total){
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest(photosFileList[index]));
				trace(photosFileList[index]);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			}else{
				_scrollIndex = 0;
				for(var i:int = 0; i < photos.length; i++){
					container.addChild(photos[i]);
				}
				makeDaoHang(total);
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function makeDaoHang(num:uint):void{
			spriteBaseX = (Global.stageWidth - total * 19) / 2 + 3;
			var otherSign:Image;
			for(var i:int = 0; i < total; i++){
				otherSign = new Image(Assets.getAtlasTexture("flip/other"));
				otherSign.x = spriteBaseX + i * 19;
				otherSign.y = 52;
				view.addChild(otherSign);
			}
			indexSign = new Image(Assets.getAtlasTexture("flip/index"));
			indexSign.x = spriteBaseX;
			indexSign.y = 52;
			view.addChild(indexSign);
		}
		
		private function LoaderComHandler(event:Event):void{
			var tmp:Bitmap = Bitmap(event.target.content);
			photos.push(new Image(Texture.fromBitmap(tmp,false)));
			index++;
			loadPhotos();
		}
		
		private function photoUrlCallback(item:*, index:int, array:Array):Boolean{
			if(item.substring(item.length - 4) == ".png") return true;
			return false;
		}
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
//				sendNotification(WorldConst.PLAY_PHOTOS_END);
//				facade.removeMediator(PlayPhotosMediator.NAME);
				var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
				var selfGuideVer:String = configProxy.getValueInUser("guideVersion");
				if(Global.guideVersion == selfGuideVer){
					
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					
				}else{
					configProxy.updateValueInUser("guideVersion",Global.guideVersion);
					sendNotification(WorldConst.POP_SCREEN_DATA);
					sendNotification(WorldConst.SWITCH_FIRST_SCREEN);
				}
				
				
				
				
			}
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,GuideKeyDownHandler);
			AppLayoutUtils.cpuLayer.visible =true;
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			super.onRemove();
			container.removeChildren(0,-1,true);
			container.dispose();
			view.removeChildren(0,-1,true);
			view.dispose();
		}
		
		override public function listNotificationInterests():Array{
			return [];
		}
	}
}