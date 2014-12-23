package com.studyMate.world.component.weixin
{
	import com.edu.AMRMedia;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.component.weixin.interfaces.ITryListenView;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * 试听类
	 * @author wt
	 * 
	 */	
	internal class ListenTestMeidator extends Mediator
	{
		private const NAME:String = 'ListenTestMeidator';
		public var recordName:String;
		public var core:String;
		
		public function ListenTestMeidator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
	
		override public function onRegister():void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
			AppLayoutUtils.gpuPopUpLayer.addChild(view as DisplayObject);
			if(view.cancelDisplayObject) view.cancelDisplayObject.addEventListener(starling.events.Event.TRIGGERED,cancelHandler);
			if(view.sureDisplayObject) view.sureDisplayObject.addEventListener(starling.events.Event.TRIGGERED,sureHandler);
			if(view.playDisplayObject) view.playDisplayObject.addEventListener(starling.events.Event.TRIGGERED,playHandler);
			if(view.pauseDisplayObject) view.pauseDisplayObject.addEventListener(starling.events.Event.TRIGGERED,pauseHandler);

			playHandler();
		}
		
		private function pauseHandler():void
		{
			view.pauseDisplayObject.visible = false;
			view.playDisplayObject.visible = true;
//			if(VoicechatComponent.owner.localFile(recordName.mtxt).exists){//真实下载目录中文件存在
//				
//			}
			AMRMedia.getInstance().pauseAMR();
		}
		
		private function playHandler():void
		{
			view.playDisplayObject.visible = false;
			view.pauseDisplayObject.visible = true;
			if(VoicechatComponent.owner(core).localFile(recordName).exists){//真实下载目录中文件存在				
				AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
				AMRMedia.getInstance().playAMR(VoicechatComponent.owner(core).localFile(recordName).nativePath);
			}
			
		}
		//播放完成
		private function playComplete(e:flash.events.Event):void{
			view.playDisplayObject.visible = true;
			view.pauseDisplayObject.visible = false;
		}
		
		private function sureHandler():void
		{
			sendNotification(VoiceInputMediator.UPLAOD_SPEECH);
			cancelHandler();
		}
		
		private function cancelHandler():void
		{
			facade.removeMediator(NAME);
		}
		
		override public function onRemove():void
		{
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,false);
			AppLayoutUtils.gpuPopUpLayer.removeChild(view as DisplayObject,true);
			AMRMedia.getInstance().stopAMR();
			super.onRemove();
		}
		
		public function get view():ITryListenView{
			return getViewComponent() as ITryListenView;
		}
		

	}
}