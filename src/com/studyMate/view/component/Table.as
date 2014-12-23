package com.studyMate.view.component
{

	
	import com.studyMate.world.component.SimpleMenuTextField;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class Table extends Sprite
	{
		private var row:int = 2;
		private var column:int = 2;
		private var gridWidth:int = 100;
		private var gridHeight:int = 100;
		
		private var myTextFormat:TextFormat;
		
		private var arr:Array = [];
		private var coverLineShape:Shape;
		
		public function Table(row:int,column:int,gridWidth:int,gridHeight:int){
			myTextFormat = new TextFormat();
			this.row = row;
			this.column = column;
			this.gridWidth = gridWidth;
			this.gridHeight = gridHeight;
			
			createTable();
			coverLineShape = new Shape;
			this.addChild(coverLineShape);
		}
		private function createTable():void{
			for (var i:int=0; i<row; i++)
			{
				for (var j:int=0; j<column; j++)
				{
					var tf:SimpleMenuTextField = new SimpleMenuTextField;
					myTextFormat.leftMargin = 2;
					myTextFormat.rightMargin = 2;
					myTextFormat.align = TextFormatAlign.CENTER;
					tf.defaultTextFormat = myTextFormat;
					
					tf.width = gridWidth;
					tf.height = gridHeight;
					tf.y = i * gridHeight;
					tf.x = j * gridWidth;
					tf.border = true;
					tf.wordWrap = true;
					tf.multiline = true;
					tf.embedFonts = true;
					this.addChild(tf);
					arr.push(tf);
				}
			}
					drawOutLine();
		}
		public function hideLine(_d:Number=2):void{
			var d:Number =1;
			coverLineShape.graphics.lineStyle(3,0xff0000);
			coverLineShape.graphics.moveTo(arr[5].x+d,arr[5].y+arr[5].height);
			coverLineShape.graphics.lineTo(arr[5].x+arr[5].width-d,arr[5].y+arr[5].height);
		}
		public function hideBorder():void{
			for(var i:int=0;i<arr.length;i++){
				TextField(arr[i]).border = false;
			}
			this.graphics.clear();
		}
		public function updateBorder(_thick:int,_color:uint):void{
			coverLineShape.graphics.clear();
			coverLineShape.graphics.lineStyle(_thick,_color);
			for(var i:int=0;i<arr.length;i++){
				coverLineShape.graphics.moveTo(arr[i].x,arr[i].y);
				coverLineShape.graphics.lineTo(arr[i].x+arr[i].width,arr[i].y);
				coverLineShape.graphics.lineTo(arr[i].x+arr[i].width,arr[i].y+arr[i].height);
				coverLineShape.graphics.lineTo(arr[i].x,arr[i].y+arr[i].height);
				coverLineShape.graphics.lineTo(arr[i].x,arr[i].y);
			}
		}
		private function drawOutLine(_thick:Number=0.5,_color:uint=0):void{
		/*	this.graphics.clear();
			this.graphics.lineStyle(_thick,_color);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(this.width,0);
			this.graphics.lineTo(this.width,this.height);
			this.graphics.lineTo(0,this.height);
			this.graphics.lineTo(0,0);*/
		}
		public function get children():Array{
			return arr;
		}
		//用一个数组来表示行和列，例如，第2行第1列表示为【2，1】
		public function  rowColumn(array:Array):TextField{

			var index:int = (array[0]-1)*this.column+(array[1]-1);
			
			return arr[index];
		}
		public function updateHeight(_row:int,_height:int):void{
			var array:Array = [_row,1];
			var tf:TextField = rowColumn(array);
			var d:int = tf.height - _height;
			var index:int = (_row-1)*this.column;
			for(var i:int=0;i<this.column;i++){
				arr[index+i].height = _height;
			}
			index = _row*this.column;
			if(_row<this.row){
				for(i=_row;i<this.row;i++){
					for(var j:int=0;j<this.column;j++){
						arr[index].y -=d;
						index++;
					}
				}
			}
			drawOutLine();
		}
		public function updateWidth(_col:int,_width:int):void{
			var array:Array = [1,_col];
			var tf:TextField = rowColumn(array);
			var d:int = tf.width - _width;
			
			for(var i:int;i<this.row;i++){
				arr[(_col-1)+this.column*i].width = _width;
			}
			if(_col<this.column){
				
				for(i=_col;i<this.column;i++){
					for(var j:int=0;j<this.row;j++){
						arr[i+this.column*j].x -=d;
					}
				}
			}
			drawOutLine();
		}
		public function setRowAlign(_row:int,align:String):void{
				
			var start:int = (_row-1)*this.column;
			var end:int = _row*this.column;
			
			for(var i:int=start;i<end;i++){
				alignHandler(arr[i],align);
			}
		}
		public function setRowText(_row:int,textArray:Array):void{
			var start:int = (_row-1)*this.column;
			var end:int = _row*this.column;
			
			var textArrayIndex:int=0;
			
			for(var i:int=start;i<end;i++){
				if(textArray[textArrayIndex]){
					var tf:TextField = arr[i] as TextField;
					var format:TextFormat = tf.getTextFormat();
					format.font = TypeTool.font;
					format.size = TypeTool.size;
					format.color = TypeTool.color;
					format.leading = TypeTool.leading;
					format.letterSpacing = TypeTool.letterSpacing;
					
					tf.defaultTextFormat = format;
					tf.setTextFormat(format)
					tf.htmlText = textArray[textArrayIndex];
				}
				textArrayIndex++;
			}
		}
		public function setColumnAlign(_column:int,align:String):void{
			for(var i:int;i<this.row;i++){
				alignHandler(arr[(_column-1)+this.column*i],align);
			}
		}
		public function setColumnText(_column:int,textArray:Array):void{
			var textArrayIndex:int=0;
			for(var i:int=0;i<this.row;i++){
				if(textArray[textArrayIndex]){
					var tf:TextField = arr[(_column-1)+this.column*i] as TextField;
					var format:TextFormat = tf.getTextFormat();
					format.font = TypeTool.font;
					format.size = TypeTool.size;
					format.color = TypeTool.color;
					format.leading = TypeTool.leading;
					format.letterSpacing = TypeTool.letterSpacing;
					
					tf.defaultTextFormat = format;
					tf.setTextFormat(format)
					tf.htmlText = textArray[textArrayIndex];
				}
				textArrayIndex++;
			}
		}
		public function setTableAlign(align:String):void{
			for(var i:int;i<arr.length;i++){
				alignHandler(arr[i],align);
			}
		}
		public function setGridAlign(_row:int,_column:int,align:String):void{
			var tf:TextField = rowColumn([int(_row),int(_column)]);
			alignHandler(tf,align);
		}
		private function alignHandler(tf:TextField,align:String):void{
			var tmpFormat:TextFormat = tf.getTextFormat();
			if(align=="left"){
				tmpFormat.align = TextFormatAlign.LEFT;
			}else if(align=="right"){
				tmpFormat.align = TextFormatAlign.RIGHT;
			}else if(align=="center"){
				tmpFormat.align = TextFormatAlign.CENTER;
			}
			tf.setTextFormat(tmpFormat);
			tf.defaultTextFormat = tmpFormat;
		}
		public function set textSize(size:int):void{
			myTextFormat.size = size;
			for(var i:int;i<arr.length;i++){
				arr[i].setTextFormat(myTextFormat,-1,-1);
			}
		}
		
		public function set defaultTextSize(size:int):void{
			myTextFormat.size = size;
			for(var i:int;i<arr.length;i++){
				arr[i].defaultTextFormat = myTextFormat;
			}
		}
		public function set textFont(font:String):void{
			myTextFormat.font = font;
			for(var i:int;i<arr.length;i++){
				arr[i].setTextFormat(myTextFormat,-1,-1);
			}
		}
		public function set defaultTextFont(font:String):void{
			myTextFormat.font = font;
			for(var i:int;i<arr.length;i++){
				arr[i].defaultTextFormat = myTextFormat;
			}
		}
		public function set textAlign(align:String):void{
			myTextFormat.align = align;
			for(var i:int;i<arr.length;i++){
				arr[i].setTextFormat(myTextFormat,-1,-1);
			}
		}
		public function set selectable(ifSelectable:Boolean):void{
			for(var i:int;i<arr.length;i++){
				arr[i].selectable = ifSelectable;
			}
		}
		public function set borderColor(color:uint):void{
			for(var i:int;i<arr.length;i++){
				arr[i].borderColor = color;
			}
		}
		public function set textColor(color:uint):void{
			for(var i:int;i<arr.length;i++){
				arr[i].textColor = color;
			}
		}
		public function set defaultTextColor(color:uint):void{
			myTextFormat.color = color;
			for(var i:int;i<arr.length;i++){
				arr[i].defaultTextFormat = myTextFormat;
			}
		}
		public function set background(ifShowBackground:Boolean):void{
			for(var i:int;i<arr.length;i++){
				arr[i].background = ifShowBackground;
			}
		}
		public function set backgroundColor(color:uint):void{
			for(var i:int;i<arr.length;i++){
				arr[i].backgroundColor = color;
			}
		}
		public function set textVisible(ifVisible:Boolean):void{
			for(var i:int;i<arr.length;i++){
				arr[i].visible = ifVisible
			}
		}
	}
}