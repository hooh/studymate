package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;

	/**
	 * 蒸汽机 ，点击进入游戏市场。
	 * @author wangtu
	 * 
	 */	
	public class ZhengQiJiMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ZhengQiJiMediator";
		private var stopBoo:Boolean;
		
		private var zhengqi:Image;
		
		public function ZhengQiJiMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{		
			var img:Image = new Image(Assets.getWhaleInsideTexture("ui/zhengqiJi"));//机器
			img.x = 48;
			var chi0:Image = new Image(Assets.getWhaleInsideTexture("ui/zhengqiChi0"));//齿轮
			var chi1:Image = new Image(Assets.getWhaleInsideTexture("ui/zhengqiChi1"));
			var chi2:Image = new Image(Assets.getWhaleInsideTexture("ui/zhengqiChi2"));			
			chi0.x = 50;
			chi0.y = 38;
			chi1.x = 50;
			chi1.y = 84;
			chi2.x = 50;
			chi2.y = 134;
			chi0.pivotX = chi0.width>>1;
			chi0.pivotY = chi0.height>>1;
			chi1.pivotX = chi1.width>>1;
			chi1.pivotY = chi1.height>>1;
			chi2.pivotX = chi2.width>>1;
			chi2.pivotY = chi2.height>>1;
			
			view.addChild(chi0);
			view.addChild(chi1);
			view.addChild(chi2);
			view.addChild(img);		
			
			TweenMax.to(chi0,12,{rotation:Math.PI*2,ease:Linear.easeNone,repeat:999});
			TweenMax.to(chi1,9,{rotation:-Math.PI*2,ease:Linear.easeNone,repeat:999});
			TweenMax.to(chi2,12,{rotation:Math.PI*2,ease:Linear.easeNone,repeat:999});
			
			zhengqi = new Image(Assets.getWhaleInsideTexture("ui/zhengqi"));
			zhengqi.x = 120;
			zhengqi.y = 118;
			zhengqi.alpha = 0;
			zhengqi.pivotX = zhengqi.width>>1;
			zhengqi.pivotY = zhengqi.height>>1;
			zhengqi.scaleX = zhengqi.scaleY = 0.7;
			view.addChild(zhengqi);
			
			zhengqiFunc();
			
			view.touchable = false;
			
			for (var i:int = 0; i < 8; i++) {//显示喷气
				tweenDot(getNewDot(), getRandom(0, 3));
			}
		}
		
				
		private function tweenDot(dot:Shape, delay:Number):void {
			if(stopBoo) return;
			dot.x = 80;
			dot.y = 190;
			dot.alpha = 0.5
			TweenMax.to(dot, 2, {alpha:0,physics2D:{velocity:getRandom(50, 150), angle:getRandom(245, 295)}, delay:delay, onComplete:tweenDot, onCompleteParams:[dot, 0]});
		}
		
		private function getNewDot():Shape {			
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.drawCircle(0, 0, 15);
			s.graphics.endFill();
			s.alpha = 0.5;
			view.addChild(s);
			return s;
		}
		
		private function getRandom(min:Number, max:Number):Number {
			return min + (Math.random() * (max - min));
		}
		

		private function zhengqiFunc():void{
			zhengqi.alpha = 0;
			zhengqi.scaleX = zhengqi.scaleY = 0.7;
			TweenLite.to(zhengqi,0.6,{alpha:1,scaleX:1,scaleY:1});
			TweenLite.to(zhengqi,0.2,{delay:0.5,alpha:0});
			TweenLite.delayedCall(7,zhengqiFunc);
			
		}
		override public function onRemove():void{	
			stopBoo = true;
			TweenMax.killAll(true);
			TweenLite.killDelayedCallsTo(tweenDot);
			TweenLite.killTweensOf(zhengqi);
			TweenLite.killDelayedCallsTo(zhengqiFunc);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				
			}			
		}
		
		override public function listNotificationInterests():Array{
			return [];
		}
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);						
		}
	}
}