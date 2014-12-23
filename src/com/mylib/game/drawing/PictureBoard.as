package com.mylib.game.drawing
{
	import com.studyMate.global.Global;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PictureBoard extends Sprite implements IMediator
	{
		public static const NAME:String = "PictureBoard";
		public var key:String;
		private var texture:Texture;
		private var img:Image;
		public var picID:String;
		
		public function PictureBoard()
		{
			super();
			
		}
		
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			// TODO Auto Generated method stub
			return this;
		}
		
		public function randomShow():void{
			
			var dir:Array = Global.document.resolvePath(Global.localPath+"pokemon").getDirectoryListing();
			
			var file:File = dir[int(dir.length*Math.random())];
			
			var tempArr:Array = file.url.split("/");
			
			picID = tempArr[tempArr.length-1];
			
			
			
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			
			
			loader.load(new URLRequest(file.url));
			
			
			
		}
		
		protected function loadComplete(event:Event):void
		{
			
			disposeInside();
			
			texture = Texture.fromBitmap((event.target as LoaderInfo).content as Bitmap,false);
			img = new Image(texture);
			
			addChild(img);
			
		}		
		
		private function disposeInside():void{
			if(texture){
				texture.dispose();
				img.removeFromParent(true);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			disposeInside();
		}
		
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function initializeNotifier(key:String):void
		{
			this.key = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(key).sendNotification(notificationName,body,type);
		}
		
	}
}