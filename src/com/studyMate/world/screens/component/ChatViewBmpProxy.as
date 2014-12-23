package com.studyMate.world.screens.component
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.sysface.SysFace;
	import com.studyMate.world.screens.component.vo.MoMoSp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ChatViewBmpProxy extends Proxy
	{
		public static const NAME:String = 'ChatViewBmpProxy';
		
		private var nameTxtL:TextField;
		private var dateTxtL:TextField;
		private var contTxtL:TextField;
		
		private var dateTxtR:TextField;
		private var contTxtR:TextField;
		
		private var leftChatUI:Sprite;
		private var rightChatUI:Sprite;

		private var matrix:Matrix;
		private var bmd:BitmapData;
		private var sysFace:SysFace;
		
		public function ChatViewBmpProxy(proxyName:String=null, data:Object=null)
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
			matrix = new Matrix();
			matrix.ty = 26;
			sysFace = new SysFace();
			
			var tf1:TextFormat = new TextFormat("HeiTi",14,0x958e79,true);
			var tf2:TextFormat = new TextFormat("HeiTi",18);
			var leftChatClass:Class = AssetTool.getCurrentLibClass("chatViewItemL");
			var rightChatClass:Class = AssetTool.getCurrentLibClass("chatViewItemR");
			
			leftChatUI = new Sprite();
			rightChatUI = new Sprite();
			leftChatUI.addChild(new leftChatClass);
			rightChatUI.addChild(new rightChatClass);
			

			
			/**----------左侧框-----------------------*/
			nameTxtL = new TextField();//日期
			nameTxtL.width = 328;
			nameTxtL.defaultTextFormat = new TextFormat("HeiTi",14,null,true);	
			nameTxtL.antiAliasType = AntiAliasType.ADVANCED;		
			nameTxtL.x = 40;
			nameTxtL.y = -26;
			
			dateTxtL = new TextField();//日期
			dateTxtL.width = 328;
			dateTxtL.defaultTextFormat = tf1;		
			dateTxtL.antiAliasType = AntiAliasType.ADVANCED;		
			dateTxtL.x = (877-dateTxtL.width)>>1;
			dateTxtL.y = -26;
			
			contTxtL = new TextField();//内容
			contTxtL.width = 378;
			contTxtL.defaultTextFormat = tf2;
			contTxtL.embedFonts = true;
			contTxtL.wordWrap = true;
			contTxtL.multiline = true;
//			contTxtL.border = true;
			contTxtL.autoSize = TextFieldAutoSize.LEFT;
			contTxtL.antiAliasType = AntiAliasType.ADVANCED;	
			contTxtL.x = 46;
			contTxtL.y = 8;
			leftChatUI.addChild(nameTxtL);
			leftChatUI.addChild(dateTxtL);
			leftChatUI.addChild(contTxtL);
			
			/**---------右侧框--------------------------*/
			dateTxtR = new TextField();//日期
			dateTxtR.width = 328;
			dateTxtR.defaultTextFormat = tf1;		
			dateTxtR.antiAliasType = AntiAliasType.ADVANCED;		
			dateTxtR.x = 68;
			dateTxtR.y = -26;
			
			contTxtR = new TextField();//内容
			contTxtR.width = 350;
			contTxtR.defaultTextFormat = tf2;
			contTxtR.embedFonts = true;
			contTxtR.wordWrap = true;
			contTxtR.multiline = true;
//			contTxtR.border = true;
			contTxtR.autoSize = TextFieldAutoSize.LEFT;
			contTxtR.antiAliasType = AntiAliasType.ADVANCED;	
			contTxtR.x = 20;
			contTxtR.y = 8;
			rightChatUI.addChild(dateTxtR);
			rightChatUI.addChild(contTxtR);
					
		}
			
		public function chatboxL(name:String,date:String,value:String,isColor:Boolean=false,type:String='text'):MoMoSp{//左侧框
			var momoSp:MoMoSp = new MoMoSp('L');
			
			if(type=='text'){	
				momoSp.isRecord = false;
				nameTxtL.text = name;
				dateTxtL.text = date;
				contTxtL.htmlText = value;
				if(isColor){	nameTxtL.textColor = contTxtL.textColor = 0x4900ee;	}//4900ee   0x404dfe
				else{	nameTxtL.textColor = contTxtL.textColor = 0;	}
				
				var width:Number = contTxtL.x + contTxtL.textWidth + 20;
				var height:Number = contTxtL.y + contTxtL.textHeight + 16;
				leftChatUI.getChildAt(0).height = height;
				leftChatUI.getChildAt(0).width = width;
				contTxtL.width = contTxtL.textWidth + 20;
				bmd = new BitmapData(444,height+24,true,0);
				var num:int = leftChatUI.numChildren;
				sysFace.checkFaces(contTxtL);			
				bmd.draw(leftChatUI,matrix);
				while(leftChatUI.numChildren>num){//清理掉表情
					leftChatUI.removeChildAt(leftChatUI.numChildren-1);
				}			
				contTxtL.width = 378
				var bmp:Bitmap = new Bitmap(bmd);
				momoSp.addChild(bmp);
			}else if(type=='voice'){
				dateTxtL.text = '                       '+ date;
				if(isColor){	nameTxtL.textColor = contTxtL.textColor = 0x4900ee;	}//4900ee   0x404dfe
				else{	nameTxtL.textColor = contTxtL.textColor = 0;	}
				
				
				bmd = new BitmapData(dateTxtL.textWidth+4,10+24,true,0);
				bmd.draw(dateTxtL);
				bmp = new Bitmap(bmd);
				momoSp.addChild(bmp);
				momoSp.isRecord = true;
				momoSp.faceMoive =  sysFace.checRecord(value);							
			}			
			
			return momoSp;
		}
		
		public function chatboxR(date:String,value:String,type:String):MoMoSp{//右侧框
			var momoSp:MoMoSp = new MoMoSp('R');
			
			if(type=='text'){	
				dateTxtR.text = date;
				contTxtR.htmlText = value;
				contTxtR.height = contTxtR.textHeight+10;
				var width:Number =  contTxtR.textWidth + 80;
				var height:Number = contTxtR.y + contTxtR.textHeight + 16;
				rightChatUI.getChildAt(0).height = height;
				rightChatUI.getChildAt(0).width = width;
				rightChatUI.getChildAt(0).x = 444-width;
				contTxtR.x = 444-width + 20;
				
				contTxtR.width = contTxtR.textWidth+ 20;
				bmd = new BitmapData(444,height+24,true,0);
				var num:int = rightChatUI.numChildren;
				sysFace.checkFaces(contTxtR);
				bmd.draw(rightChatUI,matrix);
				while(rightChatUI.numChildren>num){
					rightChatUI.removeChildAt(leftChatUI.numChildren-1);
				}
				
				contTxtR.width = 350;//复位
				var bmp:Bitmap = new Bitmap(bmd);
				bmp.x = 0;
				momoSp.addChild(bmp);
			}else if(type=='voice'){
				dateTxtR.text = date;			
				bmd = new BitmapData(dateTxtR.textWidth+4,10+24,true,0);
				bmd.draw(dateTxtR);
				bmp = new Bitmap(bmd);
				momoSp.addChild(bmp);
//				momoSp.x = 60;
				momoSp.isRecord = true;				
				momoSp.faceMoive =  sysFace.checRecord(value,false);
			}
			
			
			return momoSp;
		}
		
		
	}
}