package com.studyMate.world.component.weixin
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	/**
	 * 拍照的图片显示处理
	 * 2014-5-15上午11:27:06
	 * Author wt
	 *
	 */	
	
	internal class ImgBroadcastMediator extends Mediator
	{
		private var initialization:Boolean;
		//当前下载
		private var downWeixinVO:WeixinVO;
		//下载结束
		private const DOWN_IMG_COMPLETE:String = 'down_img_complete';
		private var loader:Loader;
		public var core:String;
		
		public function ImgBroadcastMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("ImgBroadcastMediator", viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SpeechConst.IMG_UI_CLICK:
					whetherDownload(notification.getBody() as WeixinVO);
					break;
				case DOWN_IMG_COMPLETE:
					if(downWeixinVO){
						downWeixinVO.hasRead = true;
						downWeixinVO.updateUIState = VoiceState.defaultState;
						whetherDownload(downWeixinVO);
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [SpeechConst.IMG_UI_CLICK,DOWN_IMG_COMPLETE];
		}
				
		private function whetherDownload(voiceVO:WeixinVO):void{
			if(localFile(voiceVO.mtxt).exists){//文件存在则放大。不存在则下载
				voiceVO.updateUIState = VoiceState.playState;
				
				var file:File = localFile(voiceVO.mtxt);
				if(file.exists){
					if(loader == null){
						loader = new Loader();			
						loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					}else{
						loader.unload();
					}				
					loader.load(new URLRequest(file.url));	
				}
			
			}else{
				downWeixinVO = voiceVO;
				downWeixinVO.updateUIState = VoiceState.loadingState;
				var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(voiceVO.mtxt,localPath(voiceVO.mtxt),DOWN_IMG_COMPLETE);
				downVO.downType = RemoteFileLoadVO.USER_FILE;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);	
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		protected function LoaderComHandler(event:Event):void
		{
			loader.width = Global.stageWidth;
			loader.height = Global.stageHeight;
			Global.stage.addChild(loader);
			Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler,false,5);
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
		}
		
		protected function stageClickHandler(event:MouseEvent = null):void
		{
		
			if(loader){				
				loader.unload();
				if(loader.parent){
					Global.stage.removeChild(loader);
				}
				Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,false);
		}
		
		override public function onRegister():void
		{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			if(!initialization){
				initialization = true;
				if(VoicechatComponent.owner(core))
					MyUtils.clearFileNum(VoicechatComponent.owner(core).configText.imgfolder,40,20);// 清理文件超出范围。
			}
		}
		
		
		/**
		 * @param path 后台下载目录的相对路径
		 * @return 真实存储文件 File
		 */		
		public function localFile(path:String):File{
			return Global.document.resolvePath(localPath(path))
		}
		/**
		 * @param path 服务器的相对路径
		 * @return 本地文件路径
		 */		
		public function localPath(path:String):String{
			return Global.localPath + VoicechatComponent.owner(core).configText.imgfolder+'/' + path.substring(path.lastIndexOf("/")+1);
		}
		
		override public function onRemove():void
		{
			Facade.getInstance(CoreConst.CORE).removeMediator("ImgBroadcastMediator");
			stageClickHandler();
		}
		
	}
}