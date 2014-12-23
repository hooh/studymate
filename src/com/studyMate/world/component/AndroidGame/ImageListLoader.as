package com.studyMate.world.component.AndroidGame
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.studyMate.global.Global;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class ImageListLoader extends EventDispatcher
	{
		
		private var gameList:Vector.<AndroidGameVO>;
		private var queue:LoaderMax;
		
		public function ImageListLoader(_gameList:Vector.<AndroidGameVO>)
		{
			
			gameList = _gameList;
			
			
			var file:File;
			var len:int = gameList.length;
			
			queue = new LoaderMax({name:"mainQueue",maxConnections:1,onProgress:progressHandler,onChildComplete:childCompleteHandler,onError:onError});
			
//			trace("一共有："+len);
			for(var i:int=0;i<len;i++){
				queue.append( new ImageLoader(Global.document.resolvePath(Global.localPath + "game/" + gameList[i].faceName).url
						, {gamevo:gameList[i],width:72,height:72}) );
				
			}
			queue.load();
		}
		private function progressHandler(e:LoaderEvent):void{
//			trace("加载进度:"+e.target.progress);
			
			this.dispatchEvent(new ImglistLoadEvent(ImglistLoadEvent.ONPROCESS,e.target,e.text,e.data));
		}
		
		
		private function childCompleteHandler(e:LoaderEvent):void{
			

			this.dispatchEvent(new ImglistLoadEvent(ImglistLoadEvent.CHILDCOMPLETE,e.target,e.text,e.data));

		}
		
		private function onError(e:LoaderEvent):void{
			trace("报错："+e.text);
		}

		
		//移除loader
		public function dispose():void{
			
			if(queue){
				queue.unload();
				queue.dispose(true);
				queue = null;
			}
			
		}
		
		
		
	}
}