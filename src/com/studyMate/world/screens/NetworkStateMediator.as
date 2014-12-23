package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * note
	 * 2014-5-23上午11:18:56
	 * Author wt
	 *
	 */	
	
	public class NetworkStateMediator extends Mediator
	{
		public static const NAME:String = 'NetworkStateMediator';
		private var sign1:Image;
		private var sign2:Image;
		private var sign3:Image;
		public function NetworkStateMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new starling.display.Sprite);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			AppLayoutUtils.uiLayer.removeChild(sign1,true);
			AppLayoutUtils.uiLayer.removeChild(sign2,true);
			AppLayoutUtils.uiLayer.removeChild(sign3,true);
		}
		override public function onRegister():void
		{
			sign1 = new Image(Assets.getAtlasTexture("item/signal1"));//黄的50以上
			sign2 = new Image(Assets.getAtlasTexture("item/signal2"));//红的100以上
			sign3 = new Image(Assets.getAtlasTexture("item/signal3"));//断网
			
			sign1.x = 1238;
			sign1.y = 720;
			sign2.x = 1238;
			sign2.y = 720;
			sign3.x = 1224;
			sign3.y = 714;
			sign1.touchable = false;
			sign2.touchable = false;
			sign3.touchable = false;
			
			goodState();
			AppLayoutUtils.uiLayer.addChild(sign1);
			AppLayoutUtils.uiLayer.addChild(sign2);
			AppLayoutUtils.uiLayer.addChild(sign3);
		}
		
		private var enable:Boolean=true;
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case CoreConst.UPDATE_NETWORK_SPEED:
					var num:Number = notification.getBody() as Number;
//					trace('network speed',num);
					if(num>500){
						speedVeryslowState();
					}else if(num>300){
						speedSlowState();
					}else{
						goodState();
					}
					break;
				case CoreConst.SOCKET_CLOSED:
					speed0State();
					break;
				case CoreConst.RELOGIN_COMPLETE:
					goodState();
					break;
				case CoreConst.HIDE_NETWORKSTATE://返回登陆界面后影藏所有
					goodState();
					enable = false;
					break;
				case CoreConst.SHOW_NETWORKSTATE:
					enable = true;
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [CoreConst.UPDATE_NETWORK_SPEED,CoreConst.SOCKET_CLOSED,CoreConst.RELOGIN_COMPLETE,CoreConst.SHOW_NETWORKSTATE,CoreConst.HIDE_NETWORKSTATE];
		}
		//延迟一般
		private function speedSlowState():void{
			if(enable){				
				sign1.visible = true;
				sign2.visible = false;
				sign3.visible = false;
			}
		}
		//延迟很大
		private function speedVeryslowState():void{
			if(enable){						
				sign1.visible = false;
				sign2.visible = true;
				sign3.visible = false;
			}
		}
		//断网
		private function speed0State():void{
			if(enable){		
				
				sign1.visible = false;
				sign2.visible = false;
				sign3.visible = true;
			}
		}
		//信号良好
		private function goodState():void{
			if(enable){		
				sign1.visible = false;
				sign2.visible = false;
				sign3.visible = false;
				
			}
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}

		
		
		
		
	}
}