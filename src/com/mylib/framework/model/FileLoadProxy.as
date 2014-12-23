package com.mylib.framework.model
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.AssetsDomain;
	import com.studyMate.model.vo.FileVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
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
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	
	public final class FileLoadProxy extends Proxy implements IFileLoadProxy
	{
		private var loaderContext:LoaderContext;
		private var loader:Loader;
		private var urlLoader:URLLoader;
		private var _assetsDomain:ApplicationDomain;
		private var _childDomain:ApplicationDomain;
		
		public function FileLoadProxy(data:Object=null)
		{
			super(ModuleConst.FILE_LOAD_PROXY, data);
		}
		
		override public function onRemove():void
		{
			AssetTool.fileLoadProxy = null;
			childDomain = null;
			appDomain = null;
		}
		
		
		public function load():void{
			var stream:FileStream = getFileStream();
			
			if(stream==null){
				fileVO.isLoaded = false;
				log(fileVO.filePath+" does not exist");
				sendNotification(CoreConst.ERROR_REPORT,fileVO.filePath+" does not exist");
				
				if(stream){
					stream.close();
				}
				
//				sendNotification(fileVO.onLoadNotification,[fileVO]);
				return;
			}
			//to-do 检查本地文件是否需要更新
			/*if....
			fileVO.needUpdate = true;
			sendNotification(fileVO.onLoadNotification,fileVO);
			return;*/
			
			
			var str:String;
			
			stream.position = fileVO.position;
			if(fileVO.encoded=="byte"){
				
				
				//如果是库文件，要把它存到域内
				if(fileVO.isLib){
					//loadSWF(fileVO.filePath);
					urlLoader = new URLLoader();
					urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					urlLoader.addEventListener(Event.COMPLETE, onBytesComplete);
					urlLoader.load(new URLRequest(Global.document.resolvePath(fileVO.filePath).url));
					
					//saveLib(bytes);
					
				}else{
					var bytes:ByteArray = new ByteArray();
					bytes.endian = Endian.LITTLE_ENDIAN;
					if(fileVO.length>0){
						stream.readBytes(bytes,0,fileVO.length);
					}else{
						stream.readBytes(bytes);
					}
					fileVO.isLoaded = true;
					sendNotification(fileVO.onLoadNotification,[fileVO,bytes]);
				}
				
				
			}else if(fileVO.encoded=="UTF"){
				str = stream.readUTFBytes(stream.bytesAvailable);
				fileVO.isLoaded = true;
				sendNotification(fileVO.onLoadNotification,[fileVO,str]);
			}else{
				str = stream.readMultiByte(stream.bytesAvailable,fileVO.encoded);
				fileVO.isLoaded = true;
				sendNotification(fileVO.onLoadNotification,[fileVO,str]);
			}
			
			stream.close();
		}
		
		
		public function saveLib(lib:ByteArray):void{
			
			//TweenLite.delayedCall(2,sendNotification,[ApplicationFacade.LOAD_NEXT_LIB]);
			
			try
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfOnLoadHandler);
				
				if(fileVO.domain==AssetsDomain.GLOBAL){
					loader.loadBytes(lib,loaderContext);
				}else{
					var context:LoaderContext = new LoaderContext(false,childDomain);
					context.allowCodeImport = true;
					context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					loader.loadBytes(lib,context);
				}
				
				
			} 
			catch(error:Error) 
			{
				sendNotification(CoreConst.EASY_DOWNLOAD);
			}
			
		}
		
		private function swfOnLoadHandler(event:Event):void{
			log("load complete:"+fileVO.filePath);
			fileVO.isLoaded = true;
			
			urlLoader = null;
			sendNotification(fileVO.onLoadNotification,[fileVO,event.target.content]);
		}
		
		public function removeLib():void{
			
			
			
		}
		
		public function getLibClass(cname:String):Class{
			if(childDomain.hasDefinition(cname)){
				return childDomain.getDefinition(cname) as Class;
			}else{
				return getAppClass(cname);
			}
			
		}
		
		public function getAppClass(cname:String):Class{
			if(appDomain.hasDefinition(cname)){
				return appDomain.getDefinition(cname) as Class;
			}else{
				return null;
			}
		}
		
		
		override public function onRegister():void
		{
			resetAppDomain();
			AssetTool.fileLoadProxy = this;
			
			childDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
		}
		
		protected function onBytesComplete(event:Event):void
		{
			
			saveLib((event.target as URLLoader).data);
			
			
			
		}
		
		public function resetAppDomain():void{
			appDomain = new ApplicationDomain(StudyMateDomain.currentDomain);
			loaderContext = new LoaderContext(false,appDomain);
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loaderContext.allowLoadBytesCodeExecution = true;
		}
		
		public function disposeLibsDomain():void{
			resetChildDomain();
			
			var assetsLib:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
			
			if(assetsLib.newDomainLibs.length>0){
				assetsLib.newDomainLibs.length=0;
			}
		}
		
		public function resetChildDomain():void{
			childDomain = new ApplicationDomain(appDomain);
		}
		
		
		
		private function getFileStream():FileStream{
			var file:File = Global.document.resolvePath (fileVO.filePath);
			log("open:"+fileVO.filePath);
			
			if(file.exists){
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ); 
				return stream;
			}else{
				return null;
			}
			
			
		}
		
		
		public function get fileVO():FileVO{
			return getData() as FileVO;
		}
		
		
		private static function log(str:String):void{
			getLogger(FileLoadProxy).debug(str);
		}

		public function get appDomain():ApplicationDomain
		{
			return _assetsDomain;
		}

		public function set appDomain(value:ApplicationDomain):void
		{
			_assetsDomain = value;
		}

		public function get childDomain():ApplicationDomain
		{
			return _childDomain;
		}

		public function set childDomain(value:ApplicationDomain):void
		{
			_childDomain = value;
		}
		
		
		
	}
}