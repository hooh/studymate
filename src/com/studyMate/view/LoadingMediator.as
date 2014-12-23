package com.studyMate.view
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	
	public class LoadingMediator extends Mediator
	{
		public static const NAME:String = "LoadingMediator";
		
		
		private var isShowing:Boolean;
		
		private var disable:Boolean;
		
		
		public function LoadingMediator()
		{
			super(NAME, null);
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.LOADING:
				{
					Global.isLoading = notification.getBody();
					
					if(disable){
						break;
					}
					
					if(Global.isLoading){
						if(!isShowing){
							isShowing = true;
							trace("show loading");
							sendNotification(CoreConst.SHOW_LOADING);
							sendNotification(WorldConst.SET_MODAL,true);
						}
						
					}else{
						isShowing = false;
						hideLoading();
						
					}
					
					
					
					break;
				}
				case CoreConst.MANUAL_LOADING:{
					Global.manualLoading = disable = notification.getBody();
					
					if(disable){
						isShowing = false;
						hideLoading();
					}
					break;
				}
				case WorldConst.INIT_UI:{
					sendNotification(CoreConst.REFRESH_LOADING);
					break;
				}
				case CoreConst.LOADING_TOTAL_PROCESS_MSG:{
					var tpm:Array = notification.getBody() as Array;
					if(tpm[0]){
						sendNotification(CoreConst.LOADING_TOTAL,tpm[0]);
					}
					if(tpm[1]){
						sendNotification(CoreConst.LOADING_PROCESS,tpm[1]);
					}
					if(tpm[2]){
						sendNotification(CoreConst.LOADING_MSG,tpm[2]);
					}
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		
		private function hideLoading():void{
//			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,loadingHolder);
			trace("hide loading");
				sendNotification(WorldConst.SET_MODAL,false);
				sendNotification(CoreConst.HIDE_LOADING);
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.LOADING,WorldConst.INIT_UI,CoreConst.MANUAL_LOADING,CoreConst.LOADING_TOTAL_PROCESS_MSG];
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
	}
}