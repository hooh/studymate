package com.studyMate.world.screens.component
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class FAQBmpProxy extends Proxy
	{
		public static const NAME:String = 'FAQBmpProxy';
		
		private var dateTxtL:TextField;
		private var contTxtL:TextField;
		
		private var dateTxtR:TextField;
		private var contTxtR:TextField;
		
		private var leftChatUI:Sprite;
		private var rightChatUI:Sprite;
		
		private var yearStr:String="";
		private var matrix:Matrix;
		private var bmd:BitmapData;
		
		public function FAQBmpProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRemove():void
		{
			leftChatUI.removeChildren();
			rightChatUI.removeChildren();
			leftChatUI = null;
			rightChatUI = null;
			if(bmd){
				bmd.dispose();
				bmd = null;
			}
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			yearStr= String((Global.nowDate).fullYear).substr(0,2);
			matrix = new Matrix();
			matrix.ty = 26;
			
			
			var tf1:TextFormat = new TextFormat("HeiTi",12,0x999999,true);
			var tf2:TextFormat = new TextFormat("HeiTi",15,0x333333);
			tf2.leading = 10;
			var leftChatClass:Class = AssetTool.getCurrentLibClass("LeftWindowChat");
			var rightChatClass:Class = AssetTool.getCurrentLibClass("RightWindowChat");
//			var teachFaceClass:Class = AssetTool.getCurrentLibClass("FaqTeachChat");
			
			leftChatUI = new Sprite();
			rightChatUI = new Sprite();
			leftChatUI.addChild(new leftChatClass);
			rightChatUI.addChild(new rightChatClass);
			leftChatUI.getChildAt(0).width = 623;
			
			/*var teachSp:Sprite = new teachFaceClass();
			teachSp.x = 492;
			teachSp.y = -18;
			teachSp.scaleX = 0.8;
			teachSp.scaleY = 0.8;
			rightChatUI.addChild(teachSp);*/
			
			/**----------左侧框-----------------------*/
			dateTxtL = new TextField();//日期
			dateTxtL.width = 328;
			dateTxtL.defaultTextFormat = tf1;		
			dateTxtL.antiAliasType = AntiAliasType.ADVANCED;		
			dateTxtL.x = 240;
			dateTxtL.y = -26;
			
			contTxtL = new TextField();//内容
			contTxtL.width = 582;
			contTxtL.defaultTextFormat = tf2;
			contTxtL.embedFonts = true;
			contTxtL.wordWrap = true;
			contTxtL.multiline = true;
			contTxtL.autoSize = TextFieldAutoSize.LEFT;
			contTxtL.antiAliasType = AntiAliasType.ADVANCED;	
			contTxtL.x = 38;
			contTxtL.y = 4;
			leftChatUI.addChild(dateTxtL);
			leftChatUI.addChild(contTxtL);
			
			/**---------右侧框--------------------------*/
			dateTxtR = new TextField();//日期
			dateTxtR.width = 328;
			dateTxtR.defaultTextFormat = tf1;		
			dateTxtR.antiAliasType = AntiAliasType.ADVANCED;		
			dateTxtR.x = 0;
			dateTxtR.y = -26;
			
			contTxtR = new TextField();//内容
			contTxtR.width = 425;
//			contTxtR.border = true;
			contTxtR.defaultTextFormat = tf2;
			contTxtR.embedFonts = true;
			contTxtR.wordWrap = true;
			contTxtR.multiline = true;
//			contTxtR.autoSize = TextFieldAutoSize.LEFT;
			contTxtR.antiAliasType = AntiAliasType.ADVANCED;	
			contTxtR.x = 4;
			contTxtR.y = 4;
			rightChatUI.addChild(dateTxtR);
			rightChatUI.addChild(contTxtR);
					
		}
			
		public function chatboxL(date:String,value:String):Bitmap{//左侧框
			dateTxtL.text = yearStr+date.substr(0,14);
			value = value.replace(/\r/g,'');
			contTxtL.htmlText = value;
			var height:Number = contTxtL.y + contTxtL.textHeight + 16;
			leftChatUI.getChildAt(0).height = height;
			
			bmd = new BitmapData(630,height+24,true,0);
			bmd.draw(leftChatUI,matrix);
			var bmp:Bitmap = new Bitmap(bmd);
			return bmp;
		}
		
		public function chatboxR(date:String,value:String):Bitmap{//右侧框
			value = value.replace(/\r/g,'');
//			value = value.replace(/\s/gm,'*');
			dateTxtR.text = yearStr+date.substr(0,14);
			contTxtR.text = value;
			contTxtR.height = contTxtR.textHeight+10;
			var height:Number = contTxtR.y + contTxtR.textHeight + 16;
			rightChatUI.getChildAt(0).height = height;
			
			bmd = new BitmapData(480,height+24,true,0);
			bmd.draw(rightChatUI,matrix);
			var bmp:Bitmap = new Bitmap(bmd);
			return bmp;
		}
		
		
	}
}