package com.studyMate.world.component
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
		
	public final class MySortGroup
	{
		private var num:int=0;
		public static const row:int = 7;//行
		public static const col:int = 3;//列		
		public static const leftSpace:int =85;//左边距
		public static const topSpace:int =0;//上边距
		public static const rowgap:int =163;//行间隔
		public static const colgap:int = 216;//列间隔
					
		public function MySortGroup():void{						
		}
		
		/**
		 * 排列类
		 * @param _displayobject 存放的显示对象
		 * @param cantainer 存放显示对象的容器
		 * @return 
		 * 
		 */	
		public function _addElement(_displayobject:DisplayObject,_cantainer:DisplayObjectContainer):void{
			var s:DisplayObject = _displayobject;
			var baseX:Number = ((int)(num%row))*rowgap + leftSpace + ((int)(num/(row*col)))*1280;
			var baseY:Number = ((int)(num/row))%col*colgap + topSpace;
			s.x = baseX;
			s.y = baseY;

			_cantainer.addChild(s);
									
			num++;
		}
	}
}