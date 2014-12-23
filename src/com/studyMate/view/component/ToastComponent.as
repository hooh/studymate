package com.studyMate.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ToastVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
//	import starling.core.Starling;
	
	public class ToastComponent extends Sprite
	{
		private static var instance:ToastComponent;
				
		private var msgArr:Array=[];
		private var label:TextField;
		private var displayNow:Boolean;
		private var timer:Timer;
				
		public function ToastComponent() {
			label = new TextField();	
			label.selectable = false;
			var tf:TextFormat = new TextFormat(null,16,0xFFFFFF);
			label.defaultTextFormat = tf;
			this.addChild(label);
			this.y = Global.stage.stageHeight/2 - 60;
			
			
			Global.stage.addChild(this);
			
			
			timer = new Timer(20000,1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		private function timerHandler(e:TimerEvent):void{
			msgArr.length = 0;
			TweenMax.killTweensOf(label);
			displayNow = false;
			if(instance){
				instance.graphics.clear();
				if(label&&label.parent){
					label.parent.removeChild(label);
				}
				label = null;
				if(instance.parent)
					instance.parent.removeChild(instance);	
			}
			instance = null;
		}
		
		private function removeFromStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub			
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer = null;
		}
		
		public static function getInstance():ToastComponent{
			if (instance == null){
				instance = new ToastComponent();
			}
			return instance as ToastComponent;
		}
		
		public function show(toastVO:ToastVO):void{
			if(label && label.text == toastVO.msg) return;
			for(var i:int=0;i<msgArr.length;i++){
				if(msgArr[i].msg==toastVO.msg) return;
				
			}
			if(!displayNow){//如果还没启动则启动
//				trace('启动消息');
				displayNow = true;
				label.alpha = 0;
				label.text = toastVO.msg;
//				trace('1');
				if(!label.parent){
//					trace('2');
					this.addChild(label);
				}
				updataSize();				
				TweenMax.to(label,toastVO.time,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut,onComplete:NextInfoHandler});
			}else{//否则加入队列
				if(!TweenMax.isTweening(label)){
//					trace('结束消息');
					msgArr.length = 0;
					NextInfoHandler();
				}else{
//					trace('添加队列');
					msgArr.push(toastVO);
				}				
			}										
		}
				
		
		//队列执行
		private function NextInfoHandler():void{
//			trace('enter next');
			if(msgArr.length>0){
				var vo:ToastVO = msgArr.shift();	
				if(label){
					label.alpha = 0;
					label.text = vo.msg;
					label.width=label.textWidth;
					updataSize();
//					trace('开始特效');
					TweenMax.to(label,vo.time,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut,onComplete:NextInfoHandler});					
				}
			}else{
//				trace('移除：'+msgArr.length,label);
				msgArr.length = 0;
				if(label){
					TweenMax.killTweensOf(label);
					instance.graphics.clear();
					if(label.parent){
						label.parent.removeChild(label);
					}
					label = null;
					displayNow = false;
					
					if(instance.parent)
						instance.parent.removeChild(instance);
					
					instance = null;					
				}
			}					
		}
		
		private function updataSize():void{
			label.autoSize = TextFieldAutoSize.LEFT;
			instance.graphics.clear();
			instance.graphics.beginFill(0,0.6);
			instance.graphics.drawRect(0,0,label.width,label.height);
			instance.graphics.endFill();
			instance.x = (Global.stage.stageWidth-this.width)>>1;			
		}
		
	}
}