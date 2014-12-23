package com.studyMate.view.component
{
	import com.studyMate.events.BuyBookEvent;
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
	
	import spark.core.SpriteVisualElement;
	
	public class ShowStoreBookButton extends SpriteVisualElement
	{
		private var line:int=0;//第几行
		
		private var _rankid:String;
		private var _series:String;
		private var _title:String;
		private var _price:String;
		
		/**
		 * 书本展示按钮
		 * @param rankid 主键
		 * @param series 系列丛书标题
		 * @param title 书本标题
		 * @param starCount 星级数
		 * @param age 年龄段
		 * @param price 价格
		 * @return 一本书的按钮
		 */		
		public function ShowStoreBookButton(rankid:String, series:String=null,title:String=null,starCount:Number=0,age:String=null,price:String=null){
			this._rankid = rankid;
			this._series = series;
			this._title = title;
			this._price = price;
			
			var sp:Sprite = new Sprite();
			
			var textformat0:TextFormat = new TextFormat();
			textformat0.color = 0x4C371E;
			textformat0.size = 12;
			
			
			var textformat:TextFormat = new TextFormat();
			textformat.color = 0x907650;
			textformat.size = 12;

			var starClass:Class = AssetTool.getCurrentLibClass("star");//一颗星
			var halfClass:Class = AssetTool.getCurrentLibClass("halfStar");//半颗星			
			//***************************************************//
			if(series){
				var SeriesText:TextField = textElement(textformat0,series);
				layoutElement(sp,SeriesText);
			}
			//***************************************************//
			if(title){
				var TitleText:TextField = textElement(textformat,title);				
				layoutElement(sp,TitleText);
			}
			//***************************************************//
			var starText:TextField = textElement(textformat,"星级");
			if(starCount>0){
				var starUI:SpriteVisualElement = new SpriteVisualElement();
				starUI.addChild(starText);
				for(var i:int=0;i<int(starCount);i++){
					var ui:DisplayObject = new starClass as DisplayObject;
					starUI.addChild(ui);
					ui.x = i*21+40;
				}
				if(int(starCount)!=starCount){
					var halfui:DisplayObject = new halfClass as DisplayObject;
					starUI.addChild(halfui);
					halfui.x = int(starCount)*21+40;
				}
				layoutElement(sp,starUI);
			}
			//***************************************************//
			var ageText:TextField = textElement(textformat,"适合年龄 ");
			if(age){
				ageText.appendText(age+"岁");				
			}
			layoutElement(sp,ageText);
			//***************************************************//
			var priceText:TextField = textElement(textformat,"价格  ");
			if(price){
				priceText.appendText(price+"元");
			}	
			layoutElement(sp,priceText);		
			//***************************************************//
			var lineUI:SpriteVisualElement = new SpriteVisualElement();
			lineUI.graphics.lineStyle(5);
			var mxe1:Matrix = new Matrix();
			lineUI.graphics.lineGradientStyle(GradientType.LINEAR,[0x33FF99,0x00ff00],[0.0,0.5],[0,255],mxe1);
			lineUI.graphics.moveTo(0,0);
			lineUI.graphics.lineTo(450,0);
			layoutElement(sp,lineUI,11);
			//***************************************************//

			refresh(sp);
			sp=null
		}

		
		private function refresh(displayObject:DisplayObject):void{
			var bitmap:Bitmap = new DrawBitmap(displayObject,displayObject.width,displayObject.height);
			this.addChild(bitmap);
			
			var buyCarClass:Class = AssetTool.getCurrentLibClass("buyCar");//购物车
			var buyImage:UIMovieClip = new buyCarClass as UIMovieClip;
			buyImage.x = 400;
			buyImage.y = 82;
			this.addChild(buyImage);
			buyImage.addEventListener(MouseEvent.CLICK,buyHandler);
		}

		private function buyHandler(e:MouseEvent):void{
			var buyEvent:BuyBookEvent = new BuyBookEvent(BuyBookEvent.BUY_BOOK);
			buyEvent.rankid = this._rankid;
			buyEvent.series = this._series;
			buyEvent.title = this._title;
			buyEvent.price = this._price;
			buyEvent.displayObject = this;
			
			var ui:Sprite = new Sprite();
			ui.graphics.beginFill(123456,0.5);
			ui.graphics.drawRect(0,0,475,120);			
			ui.graphics.endFill();
			this.addChild(ui);
			
			this.mouseEnabled = false;
			//(e.currentTarget as Sprite).mouseEnabled = false;
			this.dispatchEvent(buyEvent);
		}
		
		/**
		 * 纵向排列功能
		 * @param uiCantainer 容器
		 * @param ui 对象
		 * @return 
		 */		
		private function layoutElement(uiCantainer:DisplayObjectContainer,ui:DisplayObject,extendY:Number=0):void{
			uiCantainer.addChild(ui);
			ui.y = line*21;
			line++;
			if(extendY!=0){
				ui.y += extendY;
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
			textField.text = info;
			textField.autoSize = TextFieldAutoSize.LEFT;
			return textField;
		}
		
	}
	
}