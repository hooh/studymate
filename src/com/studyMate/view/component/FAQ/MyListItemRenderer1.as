package com.studyMate.view.component.FAQ
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	import mx.flash.UIMovieClip;
	
	import spark.components.supportClasses.ItemRenderer;
	
	public class MyListItemRenderer1 extends ItemRenderer
	{
		private var yesClass:Class;
		private var textformat0:TextFormat;
		private var textformat1:TextFormat;
		
		private var ui:UIMovieClip;
		private var yesBtn:UIMovieClip;
		private var titleText:TextField;
		private var contentText:TextField;
		
		public function MyListItemRenderer1()
		{			
			trace("init");
			yesClass = AssetTool.getCurrentLibClass("check");
			
			textformat0 = new TextFormat();
			textformat0.color = 0x5555FF;
			textformat0.font = "HeiTi";
			textformat0.size = 18;
			
			textformat1 = new TextFormat();
			textformat1.font = "HeiTi";
			textformat1.size = 18;	
		}

		
		override public function set data(value:Object):void{
			//trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + value.content);
			super.data = value;			
			var str:String;
			if(data.content.length>=25){
				str = data.content + "…";
			}else{
				str = data.content;
			}
			if(ui==null){
				//trace("建立新的00");
				ui = new UIMovieClip();
				yesBtn = new yesClass as UIMovieClip;
				yesBtn.scaleX = 0.5;
				yesBtn.scaleY = 0.5;
				yesBtn.x = 250;
				yesBtn.y = 15;
				ui.addChild(yesBtn);//是否回答标志
				
				titleText = textElement(textformat0,data.date);
				titleText.embedFonts = true;
				titleText.width = 230;
				titleText.x = 12;
				titleText.y = 20;
				if(data.readState=="R"){
					titleText.appendText("(已读)");
				}
				ui.addChild(titleText);//标题
				
				contentText = textElement(textformat1,str);
				contentText.x = 12;
				contentText.y = titleText.y + titleText.height + 5;
				contentText.width = 300;				
				ui.addChild(contentText);//内容
				
				var bottom:Number = contentText.y+contentText.height+18;
				ui.graphics.lineStyle(2,0xD9D9D9);
				ui.graphics.moveTo(0,bottom);
				ui.graphics.lineTo(337,bottom);
				
				var ss:TextField = new TextField();
				ss.height = 1;
				ss.y =bottom+15;
				ui.addChild(ss);
				ui.mouseChildren = false;
				ui.mouseEnabled = false;	
				
				addElement(ui);				
			}else{
				//trace("复制老的00");
				titleText.text = data.date;
				contentText.text = str;
			}
			if(data.state == "A"){
				yesBtn.visible = true;
			}else{
				yesBtn.visible = false;
			}
			
		}
		
		/**
		 * 制造文本
		 * @param textformat 文字样式
		 * @param info 文字内容
		 * @return  文本组件
		 */		
		private function textElement(textformat:TextFormat,info:String):TextField{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = textformat;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = true;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.text = info;
			textField.autoSize = TextFieldAutoSize.LEFT;
			return textField;
		}
	}
}