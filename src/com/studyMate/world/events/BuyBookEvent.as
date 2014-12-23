package com.studyMate.world.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class BuyBookEvent extends Event
	{
		//自定义事件类型，单击买书事件
		public static const BUY_BOOK:String = "buyBook";
		
		private var _rankid:String;//主键
		private var _series:String;//系列
		private var _title:String;//标题
		private var _price:String;//价格
		private var _displayObject:DisplayObject;
		
		
		public function BuyBookEvent(type:String)
		{
			super(type);
		}

		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject(value:DisplayObject):void
		{
			_displayObject = value;
		}

		public function get price():String
		{
			return _price;
		}

		public function set price(value:String):void
		{
			_price = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get series():String
		{
			return _series;
		}

		public function set series(value:String):void
		{
			_series = value;
		}

		public function get rankid():String
		{
			return _rankid;
		}

		public function set rankid(value:String):void
		{
			_rankid = value;
		}

	}
}