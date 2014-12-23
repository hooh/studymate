package com.mylib.game.fightGame
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class CircleChart extends starling.display.Sprite
	{
		private var baseSprite:flash.display.Sprite;
		private var advSprite:flash.display.Sprite;
		private var bg:Bitmap;
		private var texture:Texture;
		private var img:Image;
		
		public static const BASE_ATT:uint = 0xebc954;
		public static const ADV_ATT:uint = 0xdf4236;
		public static const BASE_DEF:uint = 0x55aace;
		public static const ADV_DEF:uint = 0x3352ac;
		
		
		public function CircleChart()
		{
			super();
			
			bg = Assets.getTextureAtlasBMP(Assets.store["FightGameTexture"],Assets.store["FightGameXML"],"circlePlate");
			
			baseSprite = new flash.display.Sprite;
			advSprite = new flash.display.Sprite;
			
			
			
		}
		
		public function addSector(start:int,end:int,type:uint,alpha:Number=1):void{
			new Sector(0,0,52,start,end,10,0,type,baseSprite.graphics,alpha);
		}
		
		
		public function refresh():void{
			if(img){
				img.removeFromParent(true);
			}
			
			if(texture){
				texture.dispose();
			}
			
			
			this.unflatten();
			
			baseSprite.removeChildren();
			advSprite.removeChildren();
			
			
			var bmpd:BitmapData = new BitmapData(104,104,true,0);
			var m:Matrix = new Matrix;
			m.translate(2,2);
			bmpd.draw(bg,m);
			
			m.translate(50,50);
			bmpd.draw(baseSprite,m);
			advSprite.graphics.beginFill(0xffffff);
			advSprite.graphics.drawCircle(0,0,28);
			advSprite.graphics.endFill();
			bmpd.draw(advSprite,m);
			
			texture = Texture.fromBitmapData(bmpd);
			img = new Image(texture);
			addChild(img);
			
			img.pivotX = 52;
			img.pivotY = 52;
			
			this.flatten();
		}
		
		public function clear():void{
			baseSprite.graphics.clear();
			advSprite.graphics.clear();
			if(img){
				img.removeFromParent(true);
			}
			
			if(texture){
				texture.dispose();
			}
			
		}
		
		
		override public function dispose():void
		{
			clear();
			super.dispose();
		}
		
		
		
		
		
		
		
		
	}
}


import flash.display.Graphics;

class Sector{
	private var _x0:Number;//圆心横坐标
	private var _y0:Number;//圆心纵坐标
	private var _r:Number;//圆半径
	private var _a0:Number;//起始角度 0度开始顺时针方向
	private var _lineWidth:Number;//线条宽度
	private var _lineColor:Number;//线条颜色
	private var _fillColor:Number;//填充颜色
	private var _graphics:Graphics;
	private var _alpha:Number;
	
	
	public function Sector(x0:Number,y0:Number,r:Number,a0:Number,a:Number,lineWidth:Number=1,lineColor:Number=0xFF0000,fillColor:Number=0xFFFF00,graphics:Graphics=null,alpha:Number=1){
		_x0 = x0;
		_y0 = y0;
		_r = r;
		_a0 = a0*Math.PI/180;
		_lineWidth = lineWidth;
		_lineColor = lineColor;
		_fillColor = fillColor;
		_graphics = graphics;
		_alpha = alpha;
		if(a>0&&a<=360) drawSector(a);
	}
	private function drawSector(a:Number):void{
//		this.graphics.lineStyle(_lineWidth,_lineColor);
		_graphics.beginFill(_fillColor,_alpha);
		_graphics.moveTo(_x0,_y0);
		_graphics.lineTo(_x0+_r*Math.cos(_a0),_y0+_r*Math.sin(_a0));//曲线绘制起始点
		var n:uint = Math.floor(a/45);//分段绘制接近Bezier曲线的曲线，分段越细，曲线越接近真实圆弧线
		var a0:Number = _a0;//记录初始角度
		while(n>0){
			n--;
			a0+=Math.PI/4;
			_graphics.curveTo(_x0+_r/Math.cos(Math.PI/8)*Math.cos(a0-Math.PI/8),_y0+_r/Math.cos(Math.PI/8)*Math.sin(a0-Math.PI/8),_x0+_r*Math.cos(a0),_y0+_r*Math.sin(a0));
		}
		if(a%45){
			var am:Number = a%45*Math.PI/180;
			_graphics.curveTo(_x0+_r/Math.cos(am/2)*Math.cos(a0+am/2),_y0+_r/Math.cos(am/2)*Math.sin(a0+am/2),_x0+_r*Math.cos(a0+am),_y0+_r*Math.sin(a0+am));
		}
		_graphics.lineTo(_x0,_y0);
		_graphics.endFill();
	}
	
}

