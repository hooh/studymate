package com.mylib.game.charater
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Rectangle;
	
	public class BMPCharaterMediator extends SimpleCharaterMediator implements IBMPCharater
	{
		private var __currentAction:String;
		
		public function BMPCharaterMediator(charaterName:String, charaterSuit:CharaterSuitsVO, skeleon:String, viewComponent:Object, range:Rectangle, copy:Boolean=false)
		{
			super(charaterName, charaterSuit, skeleon, viewComponent, range, copy);
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			
			
			actor.playAnimation("default",1);
			
		}
		
		override public function action(...parameters):void
		{
			__currentAction = parameters[0];
			parameters.unshift("bmpNpc");
			parameters.unshift("head");
			actor.switchCostume.apply(this,parameters);
//			actor.switchCostume("head","bmpNpc",_currentAction,parameters[1]);
			actor.display.pivotY = int(actor.display.height*0.5);
			
			
			
			
			
		}
		
		
		
	}
}