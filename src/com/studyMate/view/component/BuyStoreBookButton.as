package com.studyMate.view.component
{
	import com.mylib.framework.utils.AssetTool;
	
	import mycomponent.DrawBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.flash.UIMovieClip;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	
	public class BuyStoreBookButton extends SpriteVisualElement
	{
		private var line:int = 0;
		private var _displayObject:DisplayObject;
		private var _rankid:String;
		
		
		/**
		 *购买书架按钮 
		 * @param rankid
		 * @param series
		 * @param title
		 * @param price
		 */		
		public function BuyStoreBookButton(rankid:String,series:String=null,title:String=null,price:String=null,displayObject:DisplayObject=null){
			this._displayObject = displayObject;
			this._rankid = rankid;
			
			var sp:Sprite = new Sprite();
			
			var textformat0:TextFormat = new TextFormat();
			textformat0.color = 0x4C371E;
			textformat0.size = 15;
						
			var textformat:TextFormat = new TextFormat();
			textformat.color = 0x907650;
			textformat.size = 15;
				
			if(series){
				var SeriesText:TextField = textElement(textformat0,series);
				layoutElement(sp,SeriesText);
			}
			if(title){
				var TitleText:TextField = textElement(textformat,title);				
				layoutElement(sp,TitleText);
			}
			var priceText:TextField = textElement(textformat,"价格  ");
			if(price){
				priceText.appendText(price+"元");				
			}			
			layoutElement(sp,priceText);
			
			//***************************************************//
			var lineUI:SpriteVisualElement = new SpriteVisualElement();
			lineUI.graphics.lineStyle(3);
			var mxe1:Matrix = new Matrix();
			lineUI.graphics.lineGradientStyle(GradientType.LINEAR,[0x00FF00,0x33FF99],[0.5,0.0],[0,255],mxe1);
			lineUI.graphics.moveTo(0,0);
			lineUI.graphics.lineTo(450,0);
			layoutElement(sp,lineUI);
			//***************************************************//
			
			refresh(sp);
			sp=null
		}
		//重绘
		private function refresh(displayObject:DisplayObject):void{
			var bitmap:Bitmap = new DrawBitmap(displayObject,displayObject.width,displayObject.height);
			this.addChild(bitmap);
						
			var delOneClass:Class = AssetTool.getCurrentLibClass("del_One")//删除

			var cleanImage:UIMovieClip = new delOneClass as UIMovieClip;
			cleanImage.x = 400;
			cleanImage.y = 40;
			this.addChild(cleanImage);
			cleanImage.addEventListener(MouseEvent.CLICK,cleanImageHandler);
		}
		
		private function cleanImageHandler(e:MouseEvent):void{
			e.currentTarget.removeEventListener(MouseEvent.CLICK,cleanImageHandler);
			(parent as Group).removeElement(this);
			var ui:Sprite = (this._displayObject as Sprite)
			ui.mouseEnabled = true;
			ui.removeChildAt(ui.numChildren-1)
		}
		
		/**
		 * 纵向排列功能
		 * @param uiCantainer 容器
		 * @param ui 对象
		 * @return 
		 */		
		private function layoutElement(uiCantainer:DisplayObjectContainer,ui:DisplayObject):void{
			uiCantainer.addChild(ui);
			ui.y = line*30;
			line++;
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
			textField.text = info;
			textField.autoSize = TextFieldAutoSize.LEFT;
			return textField;
		}

		public function get rankid():String
		{
			return _rankid;
		}

		public function set rankid(value:String):void
		{
			_rankid = value;
		}

		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject(value:DisplayObject):void
		{
			_displayObject = value;
		}


	}
}