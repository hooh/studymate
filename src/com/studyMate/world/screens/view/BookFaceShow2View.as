package com.studyMate.world.screens.view
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BookFaceShow2View extends Sprite
	{
		public var backGround:Shape;//背景色
		
		public var uiImage:Sprite;
		public var uiImage_width:int = 509;
		public var uiImage_height:int = 606;
		
		public var btnGroup:Sprite;
		
		public var cancleBtn:Sprite;
		public var sureBtn:Sprite;
		public var leftBtn:Sprite;
		public var rightBtn:Sprite;
		public var birdieBtn:Sprite;
		public var DownLoadFlagBtn:Sprite;
		public var info:TextField;
		public var infoBtn:TextField;
		public var delTxt:TextField;
		
		public function BookFaceShow2View()
		{
			backGround = new Shape();
			backGround.graphics.beginFill(0);
			backGround.graphics.drawRect(0,0,Global.stageWidth,Global.stageHeight);
			backGround.graphics.endFill();
			backGround.alpha = 0;
			
			uiImage = new Sprite();
			uiImage.x = 382;
			uiImage.y = 79.5;
			uiImage.mouseChildren = false;
			uiImage.mouseEnabled = false;
			
			btnGroup = new Sprite();
			btnGroup.x = 282;
			btnGroup.y = 60;			
			
			var bigBookQuitClass:Class = AssetTool.getCurrentLibClass("Big_Book_Quit");//右上角退出图片
			cancleBtn = new bigBookQuitClass;
			cancleBtn.x = 572;
			cancleBtn.y = -4;
			btnGroup.addChild(cancleBtn);
			
			var bigBookSureClass:Class = AssetTool.getCurrentLibClass("Big_Book_Sure");//确认进入图片
			sureBtn = new bigBookSureClass;
			sureBtn.x = 328;
			sureBtn.y = 575;
			btnGroup.addChild(sureBtn);
			
			var bigBookLeftBtnClass:Class = AssetTool.getCurrentLibClass("Big_Book_LeftBtn");//向左移动图片
			leftBtn = new bigBookLeftBtnClass;
			leftBtn.x = 5;
			leftBtn.y = 600;
			btnGroup.addChild(leftBtn);
			
			var bigBookRightBtnClass:Class = AssetTool.getCurrentLibClass("Big_Book_RightBtn");//向右移动图片
			rightBtn = new bigBookRightBtnClass;
			rightBtn.x = 616;
			rightBtn.y = 600;
			btnGroup.addChild(rightBtn);
			
			var birdieICOClass:Class = AssetTool.getCurrentLibClass("birdie_ICO");//左上角小鸟装饰
			birdieBtn = new birdieICOClass;
			birdieBtn.x = 25;
			birdieBtn.y = 8;
			btnGroup.addChild(birdieBtn);
			
			var DownLoadFlagClass:Class = AssetTool.getCurrentLibClass("Down_Load_Flag");//下载标志
			DownLoadFlagBtn = new DownLoadFlagClass;
			DownLoadFlagBtn.x = 65;
			DownLoadFlagBtn.y = 117;
			btnGroup.addChild(DownLoadFlagBtn);
			
			infoBtn = new TextField();
			infoBtn.x = 142;
			infoBtn.y = 575;
			infoBtn.text = "信息";
			btnGroup.addChild(infoBtn);
			
			var tf:TextFormat = new TextFormat("HeiTi",22,0xFFFFFF);
			delTxt = new TextField();
			delTxt.defaultTextFormat = tf;
			delTxt.x = 174;
			delTxt.y = 48;
			delTxt.border = true;
			delTxt.text = '修复该绘本';
			delTxt.width = 120;
			delTxt.height = 30;
			delTxt.visible = false;
			btnGroup.addChild(delTxt);
			
			info = new TextField();
			info.x=49;
			info.y = 300;
			info.width = 449;
			info.height= 182;
			info.visible = false;
			info.mouseEnabled = false;
			info.selectable = false;
			btnGroup.addChild(info);
			
			this.addChild(backGround);
			this.addChild(uiImage);
			this.addChild(btnGroup);
		}
	}
}