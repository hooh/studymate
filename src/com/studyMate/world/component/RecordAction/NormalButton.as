package com.studyMate.world.component.RecordAction
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class NormalButton extends Sprite
	{
		private var btn:SimpleButton;
		
		private var _enable:Boolean = true;
		
		private var labelTF:TextField;
		private var idxTF:TextField;
		
		private var __width:Number;
		private var __height:Number;
		private var __upColor:uint;
		private var __downColor:uint;
		
		private var __needBord:Boolean = false;
		private var __bordColor:uint = 0xffffff;
		
		public function NormalButton(_width:Number, _height:Number, _upColor:uint, _downColor:uint=0, 
									 _labelTFormat:TextFormat=null, _needIdx:Boolean=false, 
									 _idxTFormat:TextFormat=null, _topIdx:String="",
									 _needBord:Boolean=false,_bordColor:uint=0xffffff)
		{
			super();
			__width = _width;
			__height = _height;
			__upColor = _upColor;
			//			__downColor = __upColor+80;
			__downColor = 0xa6a6a6;
			
			__needBord = _needBord;
			__bordColor = _bordColor;
			
			btn = new SimpleButton;
			btn.useHandCursor=true;
			
			btn.upState = drawBtn(_upColor);
			btn.overState = drawBtn(_upColor);
			btn.downState = drawBtn(__downColor);
			btn.hitTestState = btn.upState;
			this.addChild(btn);
			
			
			var tf1:TextFormat;
			if(_labelTFormat){
				tf1 = _labelTFormat;
			}else{
				tf1 = new TextFormat("HeiTi",20,0,true);
				tf1.align = TextFormatAlign.CENTER;
			}
			labelTF = new TextField();
			labelTF.defaultTextFormat = tf1;
			labelTF.width = _width;
			labelTF.height = tf1.size + 5;
			labelTF.mouseEnabled = false;
			labelTF.y = (_height-labelTF.height)>>1;
			this.addChild(labelTF);
			
			
			if(_needIdx)
			{
				var tf2:TextFormat;
				if(_idxTFormat){
					tf2 = _idxTFormat;
				}else{
					tf2 = new TextFormat("HeiTi",20,0,true);
					tf2.align = TextFormatAlign.LEFT;
				}
				idxTF = new TextField();
				idxTF.defaultTextFormat = tf2;
				idxTF.width = _width;
				idxTF.height = tf2.size + 5;
				idxTF.mouseEnabled = false;
				idxTF.x = 18;
				idxTF.y = 15;
				idxTF.text = _topIdx;
				this.addChild(idxTF);
				
			}
			
			
			
		}
		private function drawBtn(color:uint):Shape
		{
			var shape:Shape = new Shape();
			
			if(__needBord){
				shape.graphics.lineStyle(1,__bordColor);
			}else{
				shape.graphics.lineStyle(0,0xffffff);
			}
			
			shape.graphics.beginFill(color,1);
			shape.graphics.drawRect(0,0,__width,__height);
			shape.graphics.endFill();
			
			return shape;
		};
		
		public function set enable(val:Boolean):void{
			_enable = val;
			
			
			this.mouseEnabled = val;
			this.mouseChildren = val;
			
			
			btn.upState = val ? drawBtn(__upColor) : drawBtn(0x807b77);
		}
		
		public function set label(val:String):void{
			
			if(labelTF){
				labelTF.visible = true;
				labelTF.text = val;
			}
		}
	}
}