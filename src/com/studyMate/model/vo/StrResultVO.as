package com.studyMate.model.vo
{
	public final class StrResultVO implements IStrResultVO
	{
		
		private var _str:String;
		
		public function StrResultVO()
		{
			str="";
		}
		
		public function appendText(arr:Array):void{
			
			str+=arr[3];
			
			
		}

		public function get str():String
		{
			return _str;
		}

		public function set str(value:String):void
		{
			_str = value;
		}

		
	}
}