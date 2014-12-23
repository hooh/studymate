package com.mylib.game.charater.item
{
	import flash.utils.ByteArray;

	public class MarketItemSpriteVO
	{
		
		public var frameId:String;
		public var frameName:String;
		public var goldCost:String;
		public var wbidface:String;
		public var wbName:String;
		public var txtBrief:String;
		public var rackst:String;
		public var wbidlean:ByteArray; //显示的图标串 二进制存储
		
		//电影分级
		/**
		 * G:全部 <br>
		 * PG:6岁以上<br>
		 * PG-13:13岁以上<br>
		 */		
		public var level:String = "*";
		
		
		
		public function MarketItemSpriteVO(_frameId:String="",_frameName:String="",_goldCost:String="",
										   _wbidface:String="",_wbName:String="",_txtBrief:String="",
										   _rackst:String="",_wbidlean:ByteArray=null)
		{
			this.frameId = _frameId;
			this.frameName = _frameName;
			this.goldCost = _goldCost;
			this.wbidface = _wbidface;
			this.wbName = _wbName;
			this.txtBrief = _txtBrief;
			this.rackst = _rackst;
			this.wbidlean = _wbidlean;
			
			
		}
	}
}