package com.mylib.game.controller
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.mylib.game.controller.vo.PChatInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.SpeechVO;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.SpeechChatView;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.vo.MoMoSp;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MutiSpeechMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MutiSpeechMediator";
		public static const UPLOAD_SPEECH_COMPLETE:String = NAME + "UpLoadSpeechComplete";
		public static const SPEECH_DOWN_COMPLETE:String = NAME + "SpeechDownComplete";
		
		private var currentSVO:SpeechVO;
		private var playMOSp:MoMoSp;
		private var downMOSp:MoMoSp;
		
		public function MutiSpeechMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			
			
		}
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case CoreConst.LOADING_TOTAL:
					var _total:int = notification.getBody() as int;
					/*trace("=======总共："+_total);*/
					break;
				case CoreConst.LOADING_PROCESS:
					var _process:int = notification.getBody() as int;
					/*trace("============已上载："+_process);*/
					break;
				case CoreConst.UPLOAD_COMPLETE:
//					//派发上传完成消息
//					sendNotification(MutiSpeechMediator.UPLOAD_SPEECH_COMPLETE);
					trace("测试上载完了.....");
					trace("私聊："+PackData.app.CmdOStr[5]);
					if(PackData.app.CmdOStr[5] && currentSVO){
						sendNotification(WorldConst.MUTICONTROL_START);
						
						addSpeech(PackData.app.CmdOStr[5],currentSVO);
					}
					break;
				case SPEECH_DOWN_COMPLETE:
//					//派发下载完成消息
//					sendNotification(MutiSpeechMediator.SPEECH_DOWN_COMPLETE);
					
					trace("测试下载完成.....");
					sendNotification(WorldConst.MUTICONTROL_START);
					if(downMOSp)	downMOSp.defaultState();
					break;
				case SpeechChatView.SEND_SPEECH:
					var speechVo:SpeechVO = notification.getBody() as SpeechVO;
					doUpload(speechVo);
					break;
				case WorldConst.UPLOAD_USERFILE_INIT:
					var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
					PackData.app.CmdIStr[0] = CmdStr.UP_VOICE_FILE;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = Global.player.realName;
					PackData.app.CmdIStr[3] = currentSVO.rId;
					PackData.app.CmdIStr[4] = currentSVO.rName;
					PackData.app.CmdIStr[5] = vo.toPath;
					var upBytes:ByteArray = UploadProxy.readBytes(vo);
					PackData.app.CmdIStr[6] = vo.size.toString();
					PackData.app.CmdIStr[7] = vo.process.toString();
					PackData.app.CmdIStr[8] = vo.segmentSize.toString();
					PackData.app.CmdIStr[9] = upBytes;
					PackData.app.CmdInCnt = 10;
					sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo]));
					break;
				case MoMoSp.PLAY_RECORD:
					if(playMOSp)	playMOSp.defaultState();
					//降低背景声音
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,0);
					var __path:String = notification.getBody()[0] as String;
					playMOSp = notification.getBody()[1] as MoMoSp;
					
					AMRMedia.getInstance().stopAMR();
					AMRMedia.getInstance().playAMR(remote2Local(__path));
					AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
					break;
				case MoMoSp.STOP_RECORD:
					//恢复背景声音
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
					AMRMedia.getInstance().stopAMR();				
					break;
				case MoMoSp.DOWN_RECORD:
					var _downPath:String = notification.getBody()[0] as String;
					downMOSp = notification.getBody()[1] as MoMoSp;
					doDownload(_downPath,getFileName(_downPath));		
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [CoreConst.LOADING_TOTAL,CoreConst.LOADING_PROCESS,CoreConst.UPLOAD_COMPLETE,
				SPEECH_DOWN_COMPLETE,WorldConst.UPLOAD_USERFILE_INIT,
				SpeechChatView.SEND_SPEECH,MoMoSp.PLAY_RECORD,MoMoSp.STOP_RECORD,MoMoSp.DOWN_RECORD];
		}
		
		private function playComplete(e:Event):void{
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
			if(playMOSp)	playMOSp.defaultState();
			//恢复背景声音
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
		}
		
		
		private function doUpload(_speechVo:SpeechVO):void{
			
			TweenLite.killTweensOf(doUpload);
			if(Global.isLoading){
				TweenLite.delayedCall(2,doUpload,[_speechVo]);
				return;
			}
			//开始上传，停止轮询
			sendNotification(WorldConst.MUTICONTROL_STOP);
			
			
			currentSVO = _speechVo;
			var file:File = new File(Global.document.resolvePath(Global.localPath + "speech/" + _speechVo.path + ".amr").url);
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name,null,WorldConst.UPLOAD_USERFILE_INIT));
		}
		private function doDownload(_remotePath:String,_fileName:String):void{
			TweenLite.killTweensOf(doDownload);
			if(Global.isLoading){
				TweenLite.delayedCall(2,doDownload,[_remotePath,_fileName]);
				return;
			}
			
			//开始下载，停止轮询
			sendNotification(WorldConst.MUTICONTROL_STOP);
			
//			var remotePath:String = "/home/cpyf/userdata/public/voice/"+_fileName;
			var localPath:String = Global.localPath + "speech/"+_fileName;
			var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(_remotePath,localPath,SPEECH_DOWN_COMPLETE);
			downVO.downType = RemoteFileLoadVO.USER_FILE;
			sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);
			
		}
		/**
		 * 服务器文件路径转本地路径 
		 * @param _remotePath
		 * @return 
		 * 
		 */		
		private function remote2Local(_remotePath:String):String{
			
			return Global.document.resolvePath(Global.localPath + "speech/" + getFileName(_remotePath)).nativePath;
		}
		/**
		 * 根据后台路径取文件名 
		 * @param _remotePath
		 * @return 
		 * 
		 */		
		private function getFileName(_remotePath:String):String{
			
			return _remotePath.substring(_remotePath.lastIndexOf("/")+1);
			
		}
		
		
		
		private function addSpeech(_id:String,_speechVo:SpeechVO):void{
			if(!_id || !_speechVo)
				return;
			
			var chatView:ChatViewMediator = facade.retrieveMediator(ChatViewMediator.NAME) as ChatViewMediator;
//			var _path:String = Global.document.resolvePath(Global.localPath + "speech/" + _speechVo.path + ".amr").nativePath;
			var _path:String = "/home/cpyf/userdata/public/voice/"+_speechVo.path + ".amr";

			
			chatView.getChatScroll("PC").setMyChat(getNowTime(),_path,"voice");
			var _pchatVO:PChatInfoVO = new PChatInfoVO(int(_id),PackData.app.head.dwOperID.toString(),Global.player.realName,
				_speechVo.rId,_speechVo.rName,getNowTime(),"voice",_path);
			chatView.locRecordList.push(_pchatVO);
			
			_speechVo = null;
		}
		
		
		private function getNowTime():String{
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			
			return dateFormatter.format(new Date);
		}
		
		
		override public function onRemove():void
		{
			TweenLite.killTweensOf(doUpload);
			TweenLite.killTweensOf(doDownload);
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
			AMRMedia.getInstance().stopAMR();
			
			MyUtils.clearFileNum('speech');// 录音文件超出范围。
			if(playMOSp){
				playMOSp.stopAllMovieClips();
				playMOSp = null;
			}
			if(downMOSp){
				downMOSp.stopAllMovieClips();
				downMOSp = null;
			}
		}
		

	}
}