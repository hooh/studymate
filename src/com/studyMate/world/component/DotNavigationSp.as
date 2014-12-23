package com.studyMate.world.component
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-10-9上午11:33:36
	 * Author wt
	 *
	 */	
	
	public class DotNavigationSp extends Sprite
	{
		private var gap:Number = 28;
		private var totalPage:int;
		private var selectDot:Image;
		
		public function DotNavigationSp()
		{
			super();						
		}
		
		public function set pageTotal(num:int):void{
			if(totalPage!=num){
				this.removeChildren(0,-1,true);
				totalPage = num;
								
				var dot:Image;
				for(var i:int=0;i<num;i++){
					dot = new Image(Assets.getAtlasTexture("dot0"));
					dot.x = gap*i;					
					this.addChild(dot);
				}
				selectDot = new Image(Assets.getAtlasTexture("dot1"));
				this.addChild(selectDot);
			}						
		}
		
		public function set pageIndex(index:int):void{
			if(selectDot==null){
				throw new Error('请先赋值PageToTal！');
			}
			selectDot.x = index*gap;
		}
	}
}