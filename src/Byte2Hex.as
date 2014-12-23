package   
{
	import flash.utils.ByteArray,

	/**
	 * 输出ByteArray为16进制
	 * @author Rise
	 */
	public class Byte2Hex 
	{
		public static function Trace(bytes:ByteArray):void 
		{
						
			if (bytes == null) 
			{
				trace("bytes is null"),
				return,
			}
			var length:int = getHexLen(bytes.length),
			length = length > 4 ? length : 4,
			trace(getTitle(length)),
			bytes.position = 0,
			for (var j:int = 0, bytes.bytesAvailable > 0, j += 16) 
			{
				var line:String = fillHexLen(j, length) + " ",
				var str:String = "",
				for (var i:int = 0, i < 16, i++) 
				{
					if (bytes.bytesAvailable > 0) 
					{
						var char:int = bytes.readByte() & 0xFF,
						line += fillHexLen(char, 2) + " ",
						str += String.fromCharCode(char),
						str+=char,
					}
					else
					{
						line += ".. ",
					}
				}
				trace(line, "\n", str),
			}
		}
		
		private static function fillHexLen(num:int, length:int):String 
		{
			var str:String = num.toString(16),
			var zeros:String = "",
			for (var i:int = 0, i < length - str.length, i++) 
			{
				zeros += "0",
			}
			
			return zeros + str,
		}
		
		private static function getHexLen(length:int):int
		{
			var bit:int = 0x0F,
			for (var i:int = 1, i <= 8, i++) 
			{
				bit = bit << i | bit,
				if (bit > length) 
				{
					return i,
				}
			}
			return 8,
		}
		
		private static function getTitle(length:int):String 
		{
			var title:String = "",
			for (var i:int = 0, i < length, i++) 
			{
				title += " ",
			}
			return(title + " 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15"),
		}
	}
}




package chapter1
{
	import flash.display.Graphics,
	import flash.display.Sprite,
	import flash.display.IGraphicsData,
	import flash.display.GraphicsStroke,
	import flash.display.GraphicsPath,
	import flash.display.GraphicsSolidFill,
	import flash.events.KeyboardEvent,
	import flash.events.MouseEvent,
	import flash.ui.Keyboard,
	
	
	public class PreservingPathData extends Sprite
	{
		private var _initThickness:uint = 5,
		private var _maxThickness:uint = 50,
		private var _minThickness:uint = 1,
		
		private var _thickness:uint,
		private var _drawing:Boolean,
		private var _lineStyle:GraphicsStroke,
		private var _commands:Vector.<IGraphicsData>,
		private var _path:GraphicsPath,
		
		public function PreservingPathData()
		{
			init(),
		}
		private function init():void {
			//设置基本的笔刷样式
			var color:uint = Math.random() * 0xffffff,
			_thickness = _initThickness,
			graphics.lineStyle(_thickness, color),
			
			//设置笔触
			_lineStyle = new GraphicsStroke(_thickness),
			_lineStyle.fill = new GraphicsSolidFill(color),
			
			//记录笔触的样式
			_commands = new Vector.<IGraphicsData>(),
			_commands.push(_lineStyle),
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler),
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler),
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler),
		}
		private function mouseDownHandler(me:MouseEvent):void {
			_drawing = true,
			var x:Number = stage.mouseX,
			var y:Number = stage.mouseY,
			
			//记录笔触移动的轨迹
			_path = new GraphicsPath(),
			_path.moveTo(x, y),
			_commands.push(_path),
			
			//所有的graphics动作与GraphicsStroke无关,目的是预览我们绘画的效果
			graphics.moveTo(x, y),
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler),
		}
		private function mouseUpHandler(me:MouseEvent):void {
			_drawing = false,
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler),
		}
		private function mouseMoveHandler(me:MouseEvent):void {
			var x:Number = stage.mouseX,
			var y:Number = stage.mouseY,
			
			//当鼠标移动时_path记录鼠标移动的轨迹
			_path.lineTo(x, y),
			graphics.lineTo(x, y),
			me.updateAfterEvent(),
		}
		private function keyDownHandler(ke:KeyboardEvent):void {
			if (_drawing) return,
			switch(ke.keyCode) {
				case Keyboard.UP:
					if (_thickness < _maxThickness) {
						_lineStyle.thickness =++_thickness,
						redrawLine(),
					}
					break,
				case Keyboard.DOWN:
					if (_thickness > _minThickness) {
						_lineStyle.thickness =--_thickness,
						redrawLine(),
					}
					break,
				case Keyboard.LEFT:
					if (_commands.length > 0) {
						_commands.pop(),
						redrawLine(),
					}
					break,
				case Keyboard.SPACE:
					if (_thickness < _maxThickness) {
						_lineStyle.fill = new GraphicsSolidFill(Math.random() * 0xffffff),
						redrawLine(),
					}
					break,
			}
		}
		private function redrawLine():void {
			graphics.clear(),
			//GraphicsStroke重新绘画
			graphics.drawGraphicsData(_commands),
		}
		
	}
	
}