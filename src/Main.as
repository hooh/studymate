package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	
	public class Main extends Sprite
	{
		private var loader:Loader;
		private	var urlLoader:URLLoader;
	
		[Embed(source="../assets/loading.jpg")]
		public static var StartupBG:Class;
		
		private var libDomain:ApplicationDomain;
				
		public function Main()
		{
			
			start();
		}
		private function start():void{						
			loader = new Loader;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			//先加载库，再加载启动模块
//			if(CONFIG::ARM){
				urlLoader.addEventListener(Event.COMPLETE, onLibBytesComplete,false,0,true);
				urlLoader.load(new URLRequest(File.documentsDirectory.resolvePath("edu/module/AllLibs.swf").url));
//			}else{
//				urlLoader.addEventListener(Event.COMPLETE, onBytesComplete,false,0,true);
//				urlLoader.load(new URLRequest(File.applicationDirectory.resolvePath("StartprocessModule.swf").url));
//			}	
			
			
		}
		

		//加载库
		protected function onLibBytesComplete(event:Event):void
		{			
			urlLoader.removeEventListener(Event.COMPLETE, onLibBytesComplete);
			libDomain = new ApplicationDomain(ApplicationDomain.currentDomain)
			var loaderContext:LoaderContext = new LoaderContext(false,libDomain);
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loaderContext.allowLoadBytesCodeExecution = true;			
			loader.loadBytes((event.target as URLLoader).data,loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,allLibLoaderComplete);
		}
		
		protected function allLibLoaderComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,allLibLoaderComplete);
			urlLoader.addEventListener(Event.COMPLETE, onBytesComplete,false,0,true);
			if(CONFIG::ARM){
				urlLoader.load(new URLRequest(File.documentsDirectory.resolvePath("edu/module/StartprocessModule.swf").url));				
			}else{
				urlLoader.load(new URLRequest(File.applicationDirectory.resolvePath("StartprocessModule.swf").url));
			}
		}
		
		//加载启动模块
		protected function onBytesComplete(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, onBytesComplete);
			
			StudyMateDomain.currentDomain = new ApplicationDomain(libDomain);
			var loaderContext:LoaderContext = new LoaderContext(false,StudyMateDomain.currentDomain);
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loaderContext.allowLoadBytesCodeExecution = true;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
			loader.loadBytes((event.target as URLLoader).data,loaderContext);
		}
		
		protected function loaderComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderComplete);
			event.target.content.startupBMP = new StartupBG;
			event.target.content.init(stage);
			
		}
		
	}

}