package
{
	import com.studyMate.global.Global;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	public class StudyMate extends Sprite
	{
		private var loader:Loader;
		
		public function StudyMate()
		{
			
			this.stage.addEventListener("reboot",rebootHandle);
			
			start();
		}
		
		private function start():void{
			var urlLoader:URLLoader;
			
			
			loader = new Loader;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onBytesComplete,false,0,true);
			
			if(CONFIG::ARM){
				urlLoader.load(new URLRequest(File.documentsDirectory.resolvePath("edu/module/Main.swf").url));
			}else{
				urlLoader.load(new URLRequest(File.applicationDirectory.resolvePath("Main.swf").url));
			}
			
			addChild(loader);
			
		}
		
		private function clean():void{
			while(numChildren){
				removeChildAt(0);
			}
		}
		
		
		
		private function rebootHandle(event:Event):void{
			clean();
			start();
		}
		
		protected function onBytesComplete(event:Event):void
		{
			
			var loaderContext:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loaderContext.allowLoadBytesCodeExecution = true;
			
			loader.loadBytes((event.target as URLLoader).data,loaderContext);
		}
		
		
	}
}