package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.studyMate.world.screens.effects.SalvoPartical;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SalvoComponent extends Sprite
	{
		private var salvo:SalvoPartical;
		private var bg:Image;
		
		public function SalvoComponent()
		{
			//Assets.getAtlas().getTexture("bg/sidai2");
			bg = new Image(Assets.getAtlas().getTexture("bg/jiangliLaba"));
			this.addChild(bg);
			
			salvo = new SalvoPartical(false);
			salvo.x = 110;
			salvo.y = 110;
			this.addChild(salvo);
			
			TweenLite.delayedCall(1,start);
			
			/*function start():void{
				salvo.start(1.4);
				
				TweenMax.to(bg,0.2,{scaleX:0.9,scaleY:0.9,yoyo:true,repeat:7});
				
				TweenMax.to(bg,0.8,{delay:1.4,rotation:-0.2,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			}*/
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
		}
		
		private function start():void{
			salvo.start(1.4);
			
			TweenMax.to(bg,0.2,{scaleX:0.9,scaleY:0.9,yoyo:true,repeat:7});
			
			TweenMax.to(bg,0.8,{delay:1.4,rotation:-0.2,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
		}
		
		private function removeHandler(e:Event):void{
			TweenLite.killTweensOf(start);
			TweenMax.killTweensOf(bg);
			salvo.dispose();
			this.dispose();
		}
	}
}