package com.mylib.framework.model
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.api.IModuleManager;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.world.WorldFacade;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ModuleManagerMediator extends Mediator implements IModuleManager
	{
		private var urlLoader:URLLoader;
		private var loader:Loader;
		public var context:LoaderContext;
		private var _path:String;
		private var modules:Vector.<String>;
		private var loadingIndex:uint;
		private var _domain:ApplicationDomain;
		private var loadedModules:Vector.<String>;
		private var compelteCommand:String;
		
		public function ModuleManagerMediator(viewComponent:Object=null)
		{
			super(ModuleConst.MODULE_MANAGER, viewComponent);
			loadedModules = new Vector.<String>;
			modules = new Vector.<String>;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.LOAD_APP_MODULES:{
					
					(facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy).resetAppDomain();
					
					_domain = (facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy).appDomain;
					context = new LoaderContext(false,_domain);
					loadedModules.length = 0;
					loadModuleConfig();
					
					compelteCommand = WorldConst.LOAD_INIT_LIB;
					loadModules();
					
					break;
				}
				case CoreConst.LOAD_MODULES:{
					modules.length = 0;
					loadingIndex = 0;
					compelteCommand = CoreConst.LOAD_MODULES_COMPLETE;
					modules = notification.getBody() as Vector.<String>;
					
					loadModules();
					break;
				}
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		private function loadModuleConfig():void{
			
			if(CONFIG::ARM){
			
				var stream:FileStream = new FileStream();
				stream.open(Global.document.resolvePath(Global.localPath+"modules.xml"),FileMode.READ);
				
				var xml:XML = XML(stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE));
				
				stream.close();
				
				for (var i:int = 0; i < (xml.module as XMLList).length(); i++) 
				{
					modules.push(Global.document.resolvePath(Global.localPath+"module/"+(xml.module[i] as XML).toString()).url);
				}
			
			
			
			}else{
//				new WorldFacade(ModuleConst.WORLD);
				modules = Vector.<String>([
					//"GameModule.swf",
//					"SVGModule.swf",
					"app:/WorldModule.swf"
				]);
			}
			
			
			
			
			
			
		}
		
		
		
		override public function onRegister():void
		{
			
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.LOAD_APP_MODULES,CoreConst.LOAD_MODULES];
		}
		
		private function loadModules():void{
			if(loadingIndex<modules.length){
				
				if(loadedModules.indexOf(modules[loadingIndex])<0){
					loadByte(modules[loadingIndex]);
				}else{
					loadingIndex++;
					loadModules();
				}
				
				
			}else{
				loadingIndex = 0;
				modules.length = 0;
				var t:String = compelteCommand;
				compelteCommand = null;
				
				if(!CONFIG::ARM){
					LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget );
				}
				
				sendNotification(t);
			}
		}
		
		
		
		public function loadByte(path:String):void{
			sendNotification(WorldConst.SET_MODAL,true);
			_path = path;
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandle);
			urlLoader.addEventListener(Event.COMPLETE, onBytesComplete);
			urlLoader.load(new URLRequest(path));
		}
		
		protected function errorHandle(event:IOErrorEvent):void
		{
			sendNotification(CoreConst.ERROR_REPORT,event.text);
		}		
		
		protected function onBytesComplete(event:Event):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfOnLoadHandler);
			context.allowCodeImport = true;
			loader.loadBytes((event.target as URLLoader).data,context);
		}
		
		private function swfOnLoadHandler(event:Event):void{
			sendNotification(WorldConst.SET_MODAL,false);
			loadedModules.push(modules[loadingIndex]);
			
			
			loadingIndex++;
			loadModules();
			
		}
		
		
		public function get domain():ApplicationDomain
		{
			return _domain;
		}
		
	}
}