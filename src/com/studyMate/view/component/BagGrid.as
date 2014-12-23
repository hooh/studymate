package com.studyMate.view.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BagGrid extends Sprite
	{
		public var gridIndex:int=0;
		public var _bg:Sprite=null;
		public var _content:Sprite = null;
		private var tf:TextField = null;
		public function BagGrid(_content:Sprite,_bg:Sprite,_label:String,_index:int)
		{
			this.gridIndex = _index;
			this._bg = _bg;
			this._content = _content;
			tf = new TextField;
			tf.autoSize = TextFieldAutoSize.LEFT
			tf.mouseEnabled = false;
			tf.text = _label;
			this.addChild(this._bg);
			this.addChild(this._content);
			this._content.name = "content";
			this.addChild(tf);
			
			if(_bg.width>_content.width){
				_content.x = (_bg.width-_content.width)*0.5;
			}
			if(_bg.height>_content.height){
				_content.y = (_bg.height-_content.height)*0.5;
			}
		}
		public function addBg(_bg:Sprite):Sprite{
			this.addChildAt(_bg,1);
			return this.removeChildAt(0) as Sprite;
		}
		public function addContent(_content:Sprite):Sprite{
			this.addChildAt(_content,1);
			return this.removeChildAt(2) as Sprite;
		}
		public function set label(_label:String):void{
			tf.text = _label;
		}
		public function get label():String{
			return tf.text;
		}
	}
}