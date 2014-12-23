package com.mylib.game.charater
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Rectangle;
	
	import akdcl.skeleton.export.TextureMix;
	
	public class ChickCharaterMediator extends SimpleCharaterMediator
	{
		public static const NAME:String = "ChickCharaterMediator";
		
		override public function idle():void
		{
			if(Math.random() > 0.3)
				actor.playAnimation("idle1",10,50,true);
			else
				actor.playAnimation("idle2",10,64,true);
		}
		override public function walk():void
		{
			actor.playAnimation("walk",2,10,true);
		}
		
		public function ChickCharaterMediator(charaterName:String,charaterSuit:CharaterSuitsVO,skeleon:String,viewComponent:Object,range:Rectangle,copy:Boolean=false)
		{
			super(NAME+charaterName, charaterSuit,skeleon,viewComponent,range,copy);
		}
		
		override protected function getTexture():TextureMix
		{
			return Assets.charaterTexture;
		}
		
		
	}
}