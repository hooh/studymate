package com.studyMate.world.component.weixin
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.world.component.weixin.interfaces.IDropDownView;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 下拉菜单界面处理
	 * 2014-6-5下午3:43:10
	 * Author wt
	 *
	 */	
	
	internal class DropDownComponent extends Sprite
	{
		private var dropDownView:IDropDownView;
		private var cameraMediator:CameraMediator;
		public var core:String;
		private var value:Class;
		
		public function DropDownComponent(value:Class=null)
		{
			this.value = value;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			
		}
		
		private function addToStageHandler(e:Event):void
		{
			if(value==null){
				value = VoicechatComponent.owner(core).configText.dropDownView;
			}
			dropDownView = new value;
			this.addChild(dropDownView as DisplayObject);
			
			if(dropDownView.cameraDisplayObject)
				dropDownView.cameraDisplayObject.addEventListener(Event.TRIGGERED,camerHandler);
//			if(dropDownView.shareBoardplayObject)
//				dropDownView.shareBoardplayObject.addEventListener(Event.TRIGGERED,shareBoardHandler);
		}		
		
		
//		private function shareBoardHandler():void
//		{
//			if(Facade.getInstance(CoreConst.CORE).hasMediator(DrawBoardMediator.NAME)){
//				Facade.getInstance(CoreConst.CORE).sendNotification(DrawBoardMediator.HIDE_DRAWBOARD);
//			}else{				
//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(DrawBoardMediator,null,SwitchScreenType.SHOW)]);
//			}
//		}
		
		override public function dispose():void
		{
			super.dispose();
			if(cameraMediator){
				Facade.getInstance(CoreConst.CORE).removeMediator(cameraMediator.getMediatorName());
				cameraMediator = null;
			}

				
		}
		
		
		private function camerHandler():void
		{
			if(Global.OS==OSType.ANDROID){	
//				trace("Global.OS",Global.OS);
				if(cameraMediator==null) {
					cameraMediator = new CameraMediator();
					cameraMediator.core = core;
					Facade.getInstance(CoreConst.CORE).registerMediator(cameraMediator);
				}
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.CALL_CAMERA);
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("pc暂不支持发图片"));
			}
		}
	}
}