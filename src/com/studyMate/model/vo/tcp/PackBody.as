package com.studyMate.model.vo.tcp
{
	import flash.utils.ByteArray;

	public final class PackBody
	{
		private var _byCmßdCnt:uint;//CmdStr数组个数;
		private var _arrayLen:Vector.<uint>;//数组长度;
		public var arrayStr:Array;//带结尾'\0'; 串中也允许包含'\0'; 结合长度验证;
		
		public function PackBody()
		{
		}
		
		public function get arrayLen():Vector.<uint>
		{
			return _arrayLen;
		}

		public function get byCmdCnt():uint
		{
			return arrayStr.length;
		}

		public function toByte():ByteArray{
			
			return null;
		}
		
		public function get length():uint{
			
			return 0;
		}
		
		
	}
}