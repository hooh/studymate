package com.studyMate.world.screens
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CalloutMenuButton extends Button
	{
		private var _secUpState:Texture;
		private var tips:NumberTips;
		public var level:int = -1;
		
		public function CalloutMenuButton(upState:Texture, text:String="", downState:Texture=null)
		{
			super(upState, text, downState);
			tips = new NumberTips();
			tips.x = this.width - tips.width; tips.y = - (tips.width >> 1);
			tips.visible = false;
			addChild(tips);
			
			addEventListener(Event.TRIGGERED, menuBtnTrigHandler);
		}
		
		public function get secUpState():Texture
		{
			if(_secUpState == null){
				return upState;
			}
			return _secUpState;
		}

		public function set secUpState(value:Texture):void
		{
			_secUpState = value;
		}

		public function set number(num:int):void{
			if(num < 0){
				num = 0;
			}
			tips.number = num;
			if(num == 0){
				tips.visible = false;
			}else{
				tips.visible = true;
			}
		}
		
		public function get number():int{
			return tips.number;
		}
		
		private function menuBtnTrigHandler():void{
			if(number > 0){
				number = 0;
			}
		}
	}
}