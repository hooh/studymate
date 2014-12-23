package com.studyMate.world.screens.ui.music
{
	public class MusicMarketItemVO
	{
		public var frameId:String;
		public var goodsId:String;
		public var goodsName:String;
		public var rackst:String;
		public var goodsCost:String;
		
		public var hasBuy:String;//0未购买，1已购买
		public var author:String;
		public var enable:Boolean
		
		public function MusicMarketItemVO(arr:Array)
		{
			this.frameId = arr[3];
			this.goodsName = arr[4];
			this.goodsCost = arr[8];
			this.hasBuy = arr[11];
			this.author = arr[13];
						
		}
	}
}