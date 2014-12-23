package com.mylib.game.drawing
{
	import com.studyMate.global.Global;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.Sprite3D;
	import starling.textures.Texture;
	
	public class DrawingSprite extends Sprite3D
	{
		
		public var rawData:DrawingDataVO;
		private var _img:Image;
		
		private var oTexture:Texture;
		private var oImg:Image;
		
		public var px:int;
		public var py:int;
		
		
		
		public function DrawingSprite()
		{
			super();
			
			
			
		}
		
		
		public function active():void{
			
			parent.setChildIndex(this,parent.numChildren);
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this,0.5,{rotationX:0.6,x:stage.stageWidth*0.4,y:stage.stageHeight*0.4,transition:Transitions.EASE_IN});
			
			_img.visible = false;
			if(!oImg){
				genOriginal();
			}
			oImg.scaleX = 0.25;
			oImg.scaleY = 0.25;
			oImg.visible = true;
			
			Starling.juggler.removeTweens(oImg);
			Starling.juggler.tween(oImg,0.5,{scaleX:1,scaleY:1,transition:Transitions.EASE_OUT});
			
		}
		
		public function deactive():void{
			
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this,0.3,{rotationX:0,x:px,y:py,transition:Transitions.EASE_IN});
			
			
			Starling.juggler.removeTweens(oImg);
			Starling.juggler.tween(oImg,0.3,{scaleX:0.25,scaleY:0.25,onComplete:deactiveCompleteHandle,transition:Transitions.EASE_OUT});
			
			
		}
		
		private function deactiveCompleteHandle():void{
			
			
			_img.visible = true;
			oImg.removeFromParent(true);
			oImg = null;
			oTexture.dispose();
		}
		
		
		
		override public function dispose():void{
			super.dispose();
			
			
			disposeImage();
		}
		
		public function disposeImage():void{
			if(oTexture){
				oTexture.dispose();
			}
			
			if(oImg){
				oImg.removeFromParent(true);
				oImg = null;
			}
			
			if(_img){
				_img.removeFromParent(true);
				_img = null;
			}
			
			
		}
			
		
		
		public function addImg(_img:Image):void{
			this._img = _img;
			addChildAt(_img,0);
		}
		
		
		private function genOriginal():void{
			
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0xeeeeee);
			sp.graphics.drawRect(0,0,400,400);
			sp.graphics.drawGraphicsData(rawData.picData);
			
			var bmpd:BitmapData = new BitmapData(sp.width,sp.height);
			bmpd.draw(sp);
			
			
			oTexture = Texture.fromBitmapData(bmpd);
			
			
			oImg = new Image(oTexture);
			oImg.pivotX = oImg.width*0.5;
			oImg.pivotY = oImg.height*0.5;
			addChild(oImg);
			
		}
		
		
		
		
	}
}