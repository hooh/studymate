package com.mylib.game.charater
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Rectangle;
	
	import akdcl.skeleton.export.TextureMix;
	
	public class PetDogMediator extends BMPCharaterMediator
	{
		public static const WALK:String = "walk";
		public static const RUN:String = "run";
		public static const NORMAL:String = "normal";
		public static const REST:String = "rest";
		public static const SHOUT:String = "shout";
		public static const BREATHE:String = "breathe";
		public static const NORMALSIDE:String = "normalSide";
		public static const LIEDOWN:String = "liedown";
		public static const SIT:String = "sit";
		
		
		public function PetDogMediator(charaterName:String, charaterSuit:CharaterSuitsVO, skeleon:String, viewComponent:Object, range:Rectangle, copy:Boolean=false)
		{
			super(charaterName, charaterSuit, skeleon, viewComponent, range, copy);
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			
		}
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
		}
		
		
		override public function idle():void
		{
			action(NORMAL);
		}
		
		override public function walk():void
		{
			if(WALK!=currentAction){
				action(WALK);
			}
		}
		public function shout():void{
			
			if(currentAction!=SHOUT){
				action(SHOUT);
			}
			
			
		}
		
		public function sit():void{
			
			if(currentAction!=SIT){
				action(SIT);
			}
			
			
		}
		
		public function lieDown():void{
			
			if(currentAction!=LIEDOWN){
				action(LIEDOWN);
			}
			
			
		}
		
		override public function run():void{
			if(currentAction!=RUN){
				action(RUN);
				
			}
		}
		
		
		
		public function rest():void{
			if(currentAction!=REST){
				action(REST);
			}
		}
		
		
		
		override protected function getTexture():TextureMix
		{
			return Assets.petTexture;
		}
		
	}
}