package com.studyMate.world.pages
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class RollMark extends Sprite{
		public static const LEFT:String = "LEFT";
		public static const CENTER:String = "CENTER";
		public static const RIGHT:String = "RIGHT";
		private var alignX:Number;
		private var prePage:int;
		private var totalPage:int;
		private var preSign:Image;
		private var elseSign:Image;
		private var imageWidth:Number;
		/**
		 * align 滚动点的对齐方式
		 * prePage 当前页的页码
		 * totalPage 总共页数
		 */
		public function RollMark(align:String,prePage:int,totalPage:int){
			this.prePage = prePage;
			this.totalPage = totalPage;
			
			preSign = new Image(Assets.getAtlasTexture("preSign"));
			elseSign = new Image(Assets.getAtlasTexture("elseSign"));
			if(align == LEFT){
				alignX = 0;
			}else if(align == CENTER){
				alignX = (1280 - imageWidth * this.totalPage)/2;
			}else if(align == RIGHT){
				alignX = 1280 - imageWidth * this.totalPage;
			}
			drawRollMark();
		}
		
		private function drawRollMark():void{
			var imageWidth = 16;
			for(var i:int=0; i<this.totalPage; i++){
				if(i+1 == this.prePage){
					this.addChild(preSign);
					preSign.x = alignX + i * imageWidth;
				}else{
					this.addChild(elseSign);
					elseSign.x = alignX + i * imageWidth;
				}
			}
		}
		
		public function setPrePage(prePage:int):void{
			this.prePage = prePage;
			
			drawRollMark();
		}
	}
}