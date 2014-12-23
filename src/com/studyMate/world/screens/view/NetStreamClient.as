package com.studyMate.world.screens.view
{
	import com.studyMate.world.screens.VideoPlayerMediator;

	public class NetStreamClient
	{
		private var player:VideoPlayerMediator;
		public function NetStreamClient(pl:VideoPlayerMediator){
			player = pl;
		}
		
		public function onCuePoint(e:Object):void{
			trace("onCuePoint");
		}
		
		public function onPlayStatus(e:Object):void{
			trace("onPlayStatus");
		}
		
		public function onMetaData(e:Object):void{
			player.duration = e.duration;
			player.setRect(e.height,e.width);
		}
		
		public function netStatus(e:Object):void{
			trace("netStatus");
		}
	}
}