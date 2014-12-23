package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class SpokenGradeMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = 'SpokenGradeMediator';
		
		private var pareVO:SwitchScreenVO;
		private var holder:Sprite;
		private var clickTip:Image;
		
		public function SpokenGradeMediator(viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		override public function onRemove():void{
			TweenMax.killTweensOf(clickTip);
			TweenLite.killDelayedCallsTo(delayTouch);
			TweenLite.killTweensOf(holder.getChildAt(0));
			TweenLite.killTweensOf(holder.getChildAt(1));
			TweenLite.killTweensOf(holder.getChildAt(2));
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		override public function onRegister():void{
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			
			var bg:Image = new Image(Assets.getEgLearnSpokenTexture('familyGradeBg'));
			view.addChild(bg);
			
			view.x = (Global.stage.stageWidth-bg.width)/2;
			view.y = (Global.stage.stageHeight-bg.height)/2;
			
			var closeBtn:starling.display.Button = new starling.display.Button(Assets.getEgLearnSpokenTexture('closeBtn'));
			closeBtn.x = 655;
			closeBtn.y = -15;
			view.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
			
			holder = new Sprite();						
			var starBtn:Image;
			var starLight:Image;
			for(var i:int=0;i<3;i++){
				starBtn = new Image(Assets.getEgLearnSpokenTexture('star'));
				starBtn.x = i*216 + (starBtn.width>>1);
				starBtn.y = 78 + (starBtn.height>>1);
				starBtn.pivotX = starBtn.width>>1;
				starBtn.pivotY = starBtn.height>>1;
				starBtn.name = String(i);
				starBtn.addEventListener(TouchEvent.TOUCH,starClickHandler);
				view.addChild(starBtn);
				
				starLight = new Image(Assets.getEgLearnSpokenTexture('starLight'));
				starLight.x = i*216 + (starLight.width>>1);
				starLight.y = 78+(starLight.height>>1);
				starLight.pivotX = starLight.width>>1;
				starLight.pivotY = starLight.height>>1;
				starLight.visible = false;
				starLight.touchable = false;
				holder.addChild(starLight);
			}
			view.addChild(holder);
			
			
			var sureBtn:Button = new Button(Assets.getEgLearnSpokenTexture('confirmBtn'));
			sureBtn.x = 269;
			sureBtn.y = 311;
			view.addChild(sureBtn);
			sureBtn.addEventListener(Event.TRIGGERED,sureBtnHandler);
			
			
			clickTip = new Image(Assets.getEgLearnSpokenTexture('clickTip'));
			clickTip.x = 100;
			clickTip.y = 210;
			clickTip.alpha
			clickTip.touchable = false;
			view.addChild(clickTip);
			TweenMax.to(clickTip,1,{x:590});
			TweenMax.to(clickTip,0.5,{y:220,yoyo:true,repeat:99999,ease:Linear.easeNone});
		}
		
		private function sureBtnHandler():void
		{	
			
			var gradStr:String = "100";
			if(holder.getChildAt(2).visible){
				gradStr = "100";
			}else if(holder.getChildAt(1).visible){
				gradStr = "80"
			}else if(holder.getChildAt(0).visible){
				gradStr = "60";
			}
			sendNotification(SpokenNewMediator.GRADE_SPOKEN,gradStr);
			closeHandler();
		}
		private function closeHandler():void
		{
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		private function starClickHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				TweenMax.killTweensOf(clickTip);				
				clickTip.visible = false;
				view.touchable = false;
				TweenLite.killDelayedCallsTo(delayTouch);
				TweenLite.delayedCall(0.6,delayTouch);
				switch((e.target as Image).name){
					case '0':
						TweenLite.killTweensOf(holder.getChildAt(0));
						TweenLite.from(holder.getChildAt(0),0.5,{scaleX:5,scaleY:5,alpha:0,ease:Back.easeOut});
						holder.getChildAt(0).visible = true;
						holder.getChildAt(1).visible = false;
						holder.getChildAt(2).visible = false;
						break;
					case '1':
						TweenLite.killTweensOf(holder.getChildAt(1));
						TweenLite.from(holder.getChildAt(1),0.5,{scaleX:5,scaleY:5,alpha:0,ease:Back.easeOut});
						holder.getChildAt(0).visible = true;
						holder.getChildAt(1).visible = true;
						holder.getChildAt(2).visible = false;
						break;
					case '2':
						TweenLite.killTweensOf(holder.getChildAt(2));
						TweenLite.from(holder.getChildAt(2),0.5,{scaleX:5,scaleY:5,alpha:0,ease:Back.easeOut});
						holder.getChildAt(0).visible = true;
						holder.getChildAt(1).visible = true;
						holder.getChildAt(2).visible = true;
						break;
				}				
			}
		}
		
		private function delayTouch():void
		{
			view.touchable = true;
		}
		/*override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				
			}
		}*/
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);								
		}
		
	}
}