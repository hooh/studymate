package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SaveTempFileVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RequestFileDataCommand extends SimpleCommand
	{
		
		private var socket:SocketProxy;
		
		public function RequestFileDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:RemoteFileLoadVO = notification.getBody() as RemoteFileLoadVO;
			
			var file:File;
			
			socket = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			if(vo.downType == RemoteFileLoadVO.DOWN_TYPE_PER){
				file = saveTempFileFunction(vo);
			}else if(vo.downType==RemoteFileLoadVO.DEFAULT){
				file = defaultFileProcess(vo);
			}else if(vo.downType==RemoteFileLoadVO.DOWN_CHRISTMAS){
				file = christmasUserFileProcess(vo);
			}
			else{
				file = freeUserFileProcess(vo);
			}
			
			facade.registerCommand(CoreConst.CALL_BACK_COMMAND,RequestFileDataCommand);
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(CoreConst.SAVE_TEMP_FILE,[new SaveTempFileVO(file.nativePath,vo)],"byte"));
		}
		
		private function defaultFileProcess(vo:RemoteFileLoadVO):File{
			
			var version:String;
			if(vo.updateVO){
				version = vo.updateVO.version;
				socket.CmdIStr[0] = Global.getSharedProperty(ShareConst.DOWNLOAD_CMD);
				socket.CmdIStr[1] = Global.license.macid;
				socket.CmdIStr[2] = PackData.app.head.dwOperID.toString();
				socket.CmdIStr[3] = (vo.updateVO as UpdateListItemVO).wbid;
				socket.CmdIStr[4] = vo.updateVO.version;
				socket.CmdIStr[5] = (vo.updateVO as UpdateListItemVO).wfname;
				socket.CmdIStr[7] = Global.packSizeB;
				socket.CmdInCnt = 8;
				
			}else{
				socket.CmdIStr[0] = CmdStr.DOWN_HOST_FILE;
				socket.CmdIStr[1] = vo.remotePath;
				socket.CmdIStr[3] = Global.packSizeB;
				socket.CmdInCnt = 4;
				version = "000";
			}
			
			var file:File = Global.document.resolvePath("tmpEDU/"+vo.localPath+"."+version+".tmp");
			
			
			var position:Number=0;
			
			if(file.exists){
				if(vo.position==0){
					position = file.size;
				}else{
					position = vo.position;
				}
				
			}else{
			}
			
			
			if(vo.updateVO){
				socket.CmdIStr[6] = position.toString();
			}else{
				socket.CmdIStr[2] = position.toString();
				
			}
			
			return file;
			
			
		}
		
		public function saveTempFileFunction(downVO:RemoteFileLoadVO):File{
			var version:String;
			socket.CmdIStr[0] = CmdStr.DOWN_PERSON_FILE;
			socket.CmdIStr[1] = Global.player.operId;
			socket.CmdIStr[2] = downVO.remotePath;
			socket.CmdIStr[4] = Global.packSizeB;
			socket.CmdInCnt = 5;
			version = "000";
			var file:File = Global.document.resolvePath(downVO.localPath+"."+version+".tmp");
			var position:Number=0;
			if(file.exists){
				if(downVO.position==0){
					position = file.size;
				}else{
					position = downVO.position;
				}
			}
			socket.CmdIStr[3] = position.toString();
			return file;
		}
		
		public function freeUserFileProcess(downVO:RemoteFileLoadVO):File{
			var version:String;
			socket.CmdIStr[0] = CmdStr.DOWN_USER_FILE;
			socket.CmdIStr[1] = downVO.remotePath;
			socket.CmdIStr[3] = Global.packSizeB;
			socket.CmdInCnt = 4;
			version = "000";
			var file:File = Global.document.resolvePath(downVO.localPath+"."+version+".tmp");
			var position:Number=0;
			if(file.exists){
				if(downVO.position==0){
					position = file.size;
				}else{
					position = downVO.position;
				}
			}
			socket.CmdIStr[2] = position.toString();
			return file;
			
		}
		
		public function christmasUserFileProcess(downVO:RemoteFileLoadVO):File{
			var version:String;
			socket.CmdIStr[0] = CmdStr.DOWN_PERSON_FILE;
			socket.CmdIStr[1] = "chrpic";
			socket.CmdIStr[2] = downVO.remotePath;
			socket.CmdIStr[4] = Global.packSizeB;
			socket.CmdInCnt = 5;
			version = "000";
			var file:File = Global.document.resolvePath(downVO.localPath+"."+version+".tmp");
			var position:Number=0;
			if(file.exists){
				if(downVO.position==0){
					position = file.size;
				}else{
					position = downVO.position;
				}
			}
			socket.CmdIStr[3] = position.toString();
			return file;
			
		}
		
		
		
	}
}