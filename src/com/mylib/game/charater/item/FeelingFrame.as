package com.mylib.game.charater.item
{
	import com.byxb.utils.centerPivot;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class FeelingFrame extends Sprite
	{
		private var bg:Image;
		private var showingObj:DisplayObject;
		
		public static const LIKE:String="like";
		
		
		
		public function FeelingFrame()
		{
			super();
			
			bg = new Image(Assets.getAtlasTexture("item/feelingFrame1"));
			centerPivot(bg);
		}
		
		public function show(code:String,parameters:Object):void{
			
			bg.removeFromParent();
			
			if(showingObj){
				showingObj.removeFromParent(true);
			}
			
			
			if(parameters&&!parameters["type"]){
				
			}
			
			
			addChild(bg);
			showingObj = new Image(Assets.getAtlasTexture(code));
			
			addChild(showingObj);
			centerPivot(showingObj);
			
			
			
		}
		
		public function set dir(_dir:int):void{
			
			bg.scaleX = _dir;
			
		}
		
		
		
	}
}