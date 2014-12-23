package com.mylib.game.card
{
	
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import starling.extensions.krecha.ScrollImage;
	import starling.extensions.krecha.ScrollTile;
	import starling.textures.Texture;
	
	public class CardRoller extends ScrollImage
	{
		
		protected var _data:Vector.<CValue>;
		
		
		
		private var offset:int;
		
		
		
		public var dir:int;
		
		public static const ROLL_COMPLETE:String = "rollComplete";
		
		public var rollTime:Number;
		public var roundNum:uint;
		public var result:CValue;
		private var itemHeight:int;
		
		public var rollTexture:Texture;
		private var totalHeight:int;
		
		public function CardRoller(_data:Vector.<CValue>,texture:Texture,_width:int,_height:int,dir:int=1,rollTime:Number=3,roundNum:uint=3)
		{
			this._data = _data;
			this.dir = dir;
			this.rollTime = rollTime;
			this.roundNum = roundNum;
			itemHeight = _height;
			totalHeight = itemHeight*_data.length;
			super(_width, _height);
			
			refresh(texture);
			
		}
		
		public function get data():Vector.<CValue>{
			
			return _data;
		}
		
		public function set data(_d:Vector.<CValue>):void{
			_data = _d;
		}
		
		public function refresh(texture:Texture):void{
			if(this.numLayers>0){
				this.removeLayerAt(0);
			}
			TweenLite.killTweensOf(this,true);
			rollTexture = texture;
			
			
			addLayer (  new ScrollTile (rollTexture) )
			
			/*var random:int = Math.random()*_data.length;
			tilesOffsetY  = random*itemHeight;
			result = _data[random];*/
			
			
		}
		
		
		
		public function roll():void{
			var next:int = Math.random()*_data.length;
			result = _data[next];
			TweenLite.killTweensOf(this,true);
			var yy:int;
			
			if(dir>0){
				yy = totalHeight*roundNum+(_data.length-next)*itemHeight;
			}else{
				
				yy = -(totalHeight*roundNum+next*itemHeight);
			}
			
			TweenLite.to(this,rollTime,{tilesOffsetY:yy,onComplete:rollCompelteHandle});
		}
		
		private function rollCompelteHandle():void{
			tilesOffsetY = tilesOffsetY%totalHeight;
			
			this.dispatchEventWith(ROLL_COMPLETE);
		}
		
		public static function genTexutre(_data:Vector.<CValue>,template:CardRollerItem,addValue:int=0):Texture{
			var bmd:BitmapData = new BitmapData(template.width,template.height*_data.length);
			
			var m:Matrix = new Matrix();
			for (var i:int = 0; i < _data.length; i++) 
			{
				
				template.color = HeroAttribute.getCardColor(_data[i].type);
				var v:int = _data[i].value+addValue;
				
				if(v<0){
					v=0;
				}
				
				template.text = v.toString();
				m.identity();
				m.translate(0,i*template.height);
				bmd.draw(template,m);
			}
			
			
			return Texture.fromBitmapData(bmd);
		}
		
		
		
	}
}