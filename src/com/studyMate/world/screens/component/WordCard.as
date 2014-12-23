package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class WordCard extends Sprite
	{
		public var bg:Image;
		
		public var geen:Image;
		
		private var wordField:Label;
		
		private var _isActive:Boolean;
		
		public var id:int;
		
		public var wordId:String;
		public var isRemember:Boolean;
		
		public var num:String;
		
		public var isChoosed:Boolean;
		
		public var ox:int;
		public var oy:int;
		
		public var backHolder:Sprite;
		
		public var backField:String;
		private var _isBack:Boolean;
		
		

		
		public function WordCard(texture:Texture)
		{
			super();

			creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
			creatWordCardBackground(texture);
			
			backHolder = new Sprite;
			backHolder.scaleX = -1;
			
			wordField = BitmapFontUtils.getLabel();
			wordField.y = bg.height/6;
			wordField.width = bg.width;
			wordField.textRendererProperties.textFormat.align = "center";
			wordField.textRendererProperties.wordWrap = true;
			
			
			pivotX = this.width*0.5;
			pivotY = this.height*0.5;
			
			isBack = false;
		}
		
		public function creatWordCardBackground(texture:Texture):void
		{
			if(bg != null){
				removeChild(bg,false);
			}
			if(geen != null){
				geen.alpha = 0;
			}
			bg = new Image(texture);
			addChildAt(bg,0);
		}
		
		public function creatgeenWordCardBackground(texture:Texture):void
		{
			if(geen != null){
				removeChild(geen,false);
			}
			if(bg!= null){
				bg.alpha = 0;
			}
			geen = new Image(texture);
			geen.x = -2;
			geen.y = -2;
			addChildAt(geen,0);
		}
		
		public function get isBack():Boolean
		{
			return _isBack;
		}

		public function set isBack(value:Boolean):void
		{
			_isBack = value;
			if(value){
				turnBack();
			}else{
				turnFront();
			}
			
		}
		
		public function turnBack():void{
			active(180);
			TweenLite.killTweensOf(showFrontContent);
			TweenLite.delayedCall(0.2,showBackContent);
		}
		
		public function turnFront():void{
			active(0);
			TweenLite.killTweensOf(showBackContent);
			TweenLite.delayedCall(0.2,showFrontContent);
		}
		
		

		public function showBackContent():void{
			wordField.removeFromParent();
			backHolder.x = 350;
			backHolder.y = 250;
			addChild(backHolder);
		}
		
		public function showFrontContent():void{
			backHolder.removeFromParent();

			addChild(wordField);
			if(wordField.text != null){
				if(wordField.text.length>7){
					wordField.textRendererProperties.textFormat.size = 60;
					wordField.textRendererProperties.textFormat.align = "center";
				}
			}
		}
		
		
		public var _vo:WordCardVO
		public function set vo(_vo:WordCardVO):void{
			symbolText = _vo.wordSymbol;
			text = _vo.word;
			this._vo = _vo;
		}
		
		
		public function get vo():WordCardVO
		{
			return this._vo
		}
		
		public function set text(txt:String):void{
				wordField.text = txt
		}
		
		
		public function set backvo(_vo:WordCardVO):void
		{
			backtext = _vo.wordMean;
			num = _vo.wrongNum;
		}
		
				
		public function set backtext(txt:String):void
		{
			var _tab:Boolean = false;
			for(var i:int = 0;i<txt.length;i++){
				if(txt.slice(i,i+1) == "^"&&!_tab){
					_tab = true;
					if(i<9){
						backField = txt.substr(0,i)+"\n"+txt.substr(i+1,txt.length);
					}else{
						backField = txt.substr(0,9)+"\n"+txt.substr(9,(i-9)) +"\n"+txt.substr(i+1,txt.length);
					}
				}
				
			}
			if(!_tab){
				if(txt.length > 10){
					backField = txt.substr(0,10)+"\n"+txt.substr(10,txt.length);
				}else{
					backField = txt;
				}
				
			}
		}
		
		public function get backtext():String
		{
			return backField;
		}
		
		private var symbol:String
		public function set symbolText(txt:String):void
		{
			symbol = txt;
		}
		
		public function get symbolText():String
		{
			return symbol;
		}
		
		
		public function get isActive():Boolean{
			return _isActive;
		}
		
		public function rest():void{
			_isActive = false;
			TweenLite.to(this,0.5,{skewY:45*Math.PI/180,scaleX:0.4,scaleY:0.4});
		}
		
		public function active(degree:int=360):void{
			_isActive = true;
			TweenLite.to(this,0.5,{skewY:degree*Math.PI/180,scaleX:0.8,scaleY:0.8});
		}
		
		public function activeScale(degree:int =360):void
		{
			TweenLite.to(this,0.5, {transformAroundCenter:{scaleX:0.8, scaleY:0.8,skewY:degree*Math.PI/180}, ease:Cubic.easeOut});
		}
		
		public function changePivot():void
		{
			this.pivotX = this.width*0.5;
		}
		
		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.killTweensOf(showFrontContent);
			TweenLite.killTweensOf(showBackContent);
			super.dispose();
		}
		
		
	}
}