package com.studyMate.world.screens
{
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.pages.PhotoPage;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class PlayPhotosMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PlayPhotosMediator";
		private var folderUrl:String;
		private var pages:Vector.<IFlipPageRenderer>;
		private var photosFileList:Array;
		private var index:Number;
		private var total:Number;
		private var photos:Vector.<Image>;
		
		public function PlayPhotosMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			
			folderUrl = vo.data as String;
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			var file:File = Global.document.resolvePath(folderUrl);
			var list:Array = file.getDirectoryListing();
			photosFileList = list.filter(photoUrlCallback);
			pages = new Vector.<IFlipPageRenderer>(photosFileList.length);
			total = pages.length; index = 0;
			photos = new Vector.<Image>();
			loadPhotos();
		}
		
		private function loadPhotos():void{
			if(index != total){
				var loader:Loader = new Loader();
				loader.name = photosFileList[index].name;
				loader.load(new URLRequest(photosFileList[index].url));
//				trace("LOADING FILE: " + photosFileList[index].url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			}else{
				for(var i:int = 0; i < photosFileList.length; i++){
					pages[i] = new PhotoPage(photos[i]);
				}
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,view)]);
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipDaoHangMediator,total,SwitchScreenType.SHOW,view,0,52)]);
				
			}
		}
		
		private function LoaderComHandler(event:Event):void{
//			trace("LOADED FILE: " + photosFileList[index].url);
			var tmp:Bitmap = Bitmap(event.target.content);
			photos.push(new Image(Texture.fromBitmap(tmp,false)));
			index++;
			loadPhotos();
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){
				case WorldConst.PLAY_PHOTOS_END : 
					facade.removeMediator(ChapterSeleterMediator.NAME);
					facade.removeMediator(FlipDaoHangMediator.NAME);
					sendNotification(WorldConst.CLEAR_FLIP_PAGE);
					facade.removeMediator(FlipPageMediator.NAME);
					break;
			}
		}
		
		private function photoUrlCallback(item:File, index:int, array:Array):Boolean{
			if(item.url.substring(item.url.length-4) == ".png") return true;
			return false;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.PLAY_PHOTOS_END];
		}
		
	}
}