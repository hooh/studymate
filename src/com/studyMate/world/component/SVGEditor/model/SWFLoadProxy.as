package com.studyMate.world.component.SVGEditor.model
{
	import com.studyMate.world.component.SVGEditor.SVGConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class SWFLoadProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SWFLoadProxy";
		
		private var loaderContext:LoaderContext;
		private var loader:Loader;
		
		private var url:String;
		private var urlLoader:URLLoader;
		private static var childDomain:ApplicationDomain;
		
		private static var sp:Sprite;
		
		public function SWFLoadProxy()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		//测试的是ui.swf.所以以后再删除。
		override public function onRemove():void
		{
			sp = null;
			childDomain = null;
			loaderContext = null;
			if(loader){
				loader.unloadAndStop();
				loader = null;				
			}
		}
		public function update():void{
			if(this.url){
				loadURL(this.url);
			}
		}
		
		
		
		public function loadURL(url:String):void{
			if(url) this.url = url;
			
			onRemove();			
			childDomain = new ApplicationDomain();
			loaderContext = new LoaderContext(false,childDomain);
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loaderContext.allowLoadBytesCodeExecution = true;
			
			urlLoader=new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE,completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			urlLoader.load(new URLRequest(url));			
			
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function completeHandler(event:Event):void{										
			urlLoader.removeEventListener(Event.COMPLETE,completeHandler);
			
			var bytes:ByteArray=URLLoader(event.target).data;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfOnLoadHandler);			
			loader.loadBytes(bytes,loaderContext);
			
			urlLoader.close();
			urlLoader= null;			
		}
		
		private function swfOnLoadHandler(event:Event):void{
			var item:Vector.<String> = childDomain.getQualifiedDefinitionNames();
			var itme1:Vector.<String> = item.filter(doEach);
			sendNotification(SVGConst.LOAD_SWF_COMPLETE,itme1);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,swfOnLoadHandler);		
			
			
			function doEach(obj:String,idx:int,ownarr:Vector.<String>):Boolean{
				if(obj.indexOf("mx.")==0 || obj.indexOf("fl.")==0)
				{
					return false;
				}
				else return true;
			}
			
		}
		
		public static function getClass(className:String):Class {
			if (childDomain && childDomain.hasDefinition(className)) {
				return childDomain.getDefinition(className) as Class;
			}
			return null;
		}
		
		public static function getDisplayObject(className:String):DisplayObject{
			var swfClass:Class = getClass(className);
			if(swfClass == null) return null;
 			var tempObj:* = new swfClass;
			var displayObject:DisplayObject;
			if(tempObj is BitmapData){
				var bitmap:Bitmap = new Bitmap(tempObj);
				var sp:Sprite = new Sprite;
				sp.addChild(bitmap);
				displayObject = sp;
			}else if(tempObj is DisplayObject){
				displayObject = tempObj;
			}
			return displayObject;
			
		}
	}
}