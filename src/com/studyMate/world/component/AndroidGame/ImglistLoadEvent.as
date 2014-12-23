package com.studyMate.world.component.AndroidGame
{
	import com.greensock.events.LoaderEvent;
	
	public class ImglistLoadEvent extends LoaderEvent
	{
		public static const CHILDCOMPLETE:String = "childComplete";
		public static const ONPROCESS:String = "onProcess";
		
		public function ImglistLoadEvent(type:String, target:Object, text:String="", data:*=null)
		{
			super(type, target, text, data);
		}
	}
}