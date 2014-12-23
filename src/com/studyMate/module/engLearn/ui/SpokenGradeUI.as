package com.studyMate.module.engLearn.ui
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	
	public class SpokenGradeUI extends Sprite
	{
		public var gradeBtn:Button;
		private var waterFill:Fill;
		private var waterSurfaceStroke:Stroke;
		private var gradeTip:Image;
		public function SpokenGradeUI()
		{
			gradeBtn = new Button(Assets.getEgLearnSpokenTexture('spokenGradeBtn'));
			gradeBtn.pivotX = gradeBtn.width>>1;
			gradeBtn.pivotY = gradeBtn.height>>1;
			gradeBtn.x = 267;
			gradeBtn.y = 637;
			gradeBtn.scaleX = 0.1;
			gradeBtn.scaleY = 0.15;
			this.addChild(gradeBtn);
//			gradeBtn.touchable = false;
			this.touchable = false;
			
		}
		
		override public function dispose():void
		{
			TweenMax.killTweensOf(gradeBtn);
			TweenLite.killTweensOf(gradeBtn);
			if(gradeTip){
				TweenLite.killTweensOf(gradeTip);
			}
			super.dispose();
		}
		
		
		public function delayTouch(value:Number):void{
			TweenMax.to(gradeBtn,1,{skewX:0.05,skewY:0.04,yoyo:true,yoyo:true,repeat:99999,ease:Linear.easeNone});
			TweenLite.to(gradeBtn,value,{x:84,y:632,scaleX:1,scaleY:1,ease:Circ.easeIn,onComplete:animationComplete});
		}
		
		private function animationComplete():void{
			this.touchable = true;
			gradeTip = new Image(Assets.getEgLearnSpokenTexture('spokenGradeTIp'));
			gradeTip.x = 44;
			gradeTip.y = 447;
			this.addChild(gradeTip);
			TweenMax.to(gradeTip,1,{y:450,yoyo:true,repeat:99999,ease:Linear.easeNone});
		}
	}
}