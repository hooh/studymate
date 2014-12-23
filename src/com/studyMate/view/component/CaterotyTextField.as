package com.studyMate.view.component
{
	import de.polygonal.ds.TreeNode;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class CaterotyTextField extends TextField
	{
		private var _data:TreeNode;
		private var textFormat:TextFormat
		public function CaterotyTextField(d:TreeNode)
		{
			
//			this.addEventListener(MouseEvent.ROLL_OVER,showHand);
//			this.addEventListener(MouseEvent.ROLL_OUT,hideHand);
			this.autoSize = TextFieldAutoSize.LEFT;
			textFormat = new TextFormat;
			
			data = d;
		}
		
		protected function outHandler(event:MouseEvent):void
		{
			this.background = false;
		}
		
		protected function downHandler(event:MouseEvent):void
		{
			this.background = true;
			this.backgroundColor = 0x0000ff;
		}
		
		protected function hideHand(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		protected function showHand(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		public function set data(d:TreeNode):void{
			_data = d;
			
			
			var depth:int = d.depth;
			textFormat.size = 36-depth*3;
			this.embedFonts = true;
			textFormat.font = "HeiTi";
			if(d.data.yyzsid!=-1){
				textFormat.underline = true;
				this.defaultTextFormat = textFormat;
				this.text = d.data.pathstr;
				
				this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				this.addEventListener(MouseEvent.ROLL_OUT,outHandler);
			}else{
				this.defaultTextFormat = textFormat;
				this.mouseEnabled = false;
				this.text = d.data.pathstr;
			}
			
			refresh();
			
		}
		
		public function get data():TreeNode{
			return _data;
		}
		
		private function refresh():void{
			
		}
		
	}
}