package com.studyMate.world.pages
{
	import com.studyMate.world.component.IFlipPageRenderer;
	
	import flash.filesystem.File;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class AndroidGamePage extends Sprite implements IFlipPageRenderer
	{
		public var pageNum:int;
		public var apkArr:Array;
		public var totalLen:int;
		public var totalPage:int;
		public var image:AndroidGameItem;
		
		private var textureList:Vector.<Texture>;
		
		public function AndroidGamePage(pageNum:int,apkArr:Array,totalPage:int,_textureList:Vector.<Texture>=null)
		{
			this.pageNum = pageNum;
			this.apkArr = apkArr;
			this.totalLen = apkArr.length;
			this.totalPage = totalPage;
			this.textureList = _textureList;
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function disposePage():void
		{
			removeChildren(0,-1,true);
		}
		
		
		public function displayPage():void
		{
			var curItem:int;
			var lineNum:int = 0;
			if(pageNum < totalPage)
				lineNum = 4;
			else
				lineNum = (totalLen%20)/5+1;
			for (var j:int = 0; j < lineNum; j++) 
			{
				for (var k:int = 0; k < 5; k++) 
				{
					curItem = pageNum*20+(j*5+k);
					if(apkArr[curItem] == null)
						break;
					
					var texture:Texture = textureList[curItem];
					image = new AndroidGameItem(apkArr[curItem] as File,new Image(texture));
					image.x = (158+216*k)-640;
					image.y = (129+144*j)-381;
					
					addChild(image);
				}
			}
//			flatten();
		}
		
	}
}