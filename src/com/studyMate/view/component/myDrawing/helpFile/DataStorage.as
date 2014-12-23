package com.studyMate.view.component.myDrawing.helpFile
{
	import flash.utils.Dictionary;

	public final class DataStorage
	{
		
		private var rectArr:Array=[];
		
		public function DataStorage()
		{
		}
		
		public function push(dotObj:Object):void{
			//rectArr.push(dotObj);
			testing();
		}
		
		/**
		 * 测试每组数据量
		 * @param type 		绘图类型
		 * @param begin		开始字符
		 * @param end		结束字符
		 * @param color		绘图颜色
		 */		
		private function testing(begin:int,end:int):void{
			var reg:RegExp = /[begin-end]/;
			/*for each(var obj:Object in rectArr){
				if(obj.data.startChar
			}*/
		}
	}
}