package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.events.ItemLoadEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class LazyLoad extends EventDispatcher{
		public static const QUEUE_LOAD_COMPLETE:String = 'lazyloadComplete';
		public static const QUEUE_LOAD_START:String = 'lazyloadSTART';
		private var pathArr:Array;//路径数组
		private var loaders:Loader;
		
		private var loading:Boolean;//是否正在下载
		private var displayObject:DisplayObject;
		
		private var num:int;
		
		/**
		 *该类负责队列加载，使用需侦听ItemLoadEvent事件，并且使用ItemLoadEvent.Item为已加载的当前文件
		 * @param _pathArr 加载文件路径数组，数组文件路径为相对路径
		 */				
		public function LazyLoad(_pathArr:Array){
			this.pathArr = _pathArr;
			num = 0;					
			loaders = new Loader();			
			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			loaders.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loading = true;
			init();	
			
			Facade.getInstance(CoreConst.CORE).sendNotification(QUEUE_LOAD_START);
		}
		
		//开始下载
		public function startLoad():void{
			if(this.pathArr){
				loading = true;
				init();	
			}
			
		}
		//暂停下载
		public function pauseLoad():void{
			loading = false;
		}
		
		//清理
		public function clear():void{
			if(loaders){
				loading = false;
				loaders.contentLoaderInfo.removeEventListener(Event.COMPLETE,LoaderComHandler);
				loaders.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loaders.unload();
				loaders = null;
				this.pathArr = null;
			}
		}
		
		private function init():void{
			if(num<this.pathArr.length){
				if(this.pathArr[num] != ""){
					var str:String = Global.document.resolvePath(Global.localPath+pathArr[num]).url;
					loaders.load(new URLRequest(str));					
				}else{//数组为空				
					//ioErrorHandler(null);	
					loaders.load(new URLRequest(""));
				}
			}else{
				loaders.contentLoaderInfo.removeEventListener(Event.COMPLETE,LoaderComHandler);
				loaders.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loaders.unload();
				loaders = null;
				pathArr = null;
				dispatchEvent(new Event(Event.COMPLETE));
				
				Facade.getInstance(CoreConst.CORE).sendNotification(QUEUE_LOAD_COMPLETE);
			}
		}
		
		//加载成功，派发加载对象，并继续加载下一张。
		private function LoaderComHandler(event:Event):void{						
			var itemLoadEvent:ItemLoadEvent = new ItemLoadEvent(ItemLoadEvent.ITEM_LOAD_COMPLETE);
			itemLoadEvent.Item = Loader(event.target.loader);
			dispatchEvent(itemLoadEvent);
			num++;	
			if(loading){	
				init();
			}	
		}
		
		//捕获数组元素为空或者加载失败的事件
		private function ioErrorHandler(event:Event):void{
			var itemLoadEvent:ItemLoadEvent = new ItemLoadEvent(ItemLoadEvent.ITEM_LOAD_FAILD);
			dispatchEvent(itemLoadEvent);
			num++;
			if(loading){	
				init();
			}
		}
	}
}