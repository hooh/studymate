package com.mylib.game.charater.item
{

	public class MarketItemInfoVO
	{
		
		public var frameId:String;
		public var goodsId:String;
		public var goodsName:String;
		public var seq:String;
		public var rackst:String;
		public var goodsCost:String;
		
		public var hasBuy:String;//0未购买，1已购买
		public var author:String;
		
		
		public function MarketItemInfoVO(_frameId:String="",_goodsId="",_goodsName:String="",
										   _seq:String="",_rackst:String="",_goodsCost="")
		{
			this.frameId = _frameId;
			this.goodsId = _goodsId;
			this.goodsName = _goodsName;
			this.seq = _seq;
			this.rackst = _rackst;
			this.goodsCost = _goodsCost;
			
			
		}
	}
}