package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.db.schema.PlayerDAO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SendErrorCommand extends SimpleCommand implements ICommand
	{
		public function SendErrorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void{
			var errInfo:String = notification.getBody() as String;
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			socket.B0LoginComplete = true;
			sendErrInfo(packInfo(errInfo));
		}
		
		private function packInfo(errInfo:String):String{
			var userId:String = "null";
			var userName:String = "null";
			var macId:String = "null";
			if(Global.player == null){
				Global.user = Global.fixUserName;
				Global.password = Global.fixUserPSW;
				var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				var ipReader:IPReaderProxy = facade.retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
//				var array:Array = ipReader.getValueByKeys(IPReaderProxy.IP_INFO_FILE, ["ip","telecom","host",null,"port",null]);
				var array:Array = ipReader.getIpInf("telecom");
				if(array != null){
					socket.host = array[0];
					socket.port = parseInt(array[1]);
				}else{
					socket.host = "121.33.246.212";
					socket.port = 8820;
				}
				macId = readLicense();
			}else{
				userId = Global.player.operId.toString();
				userName = Global.player.userName;
			}
			if(Global.license){
				macId = Global.license.macid;
			}
			
			if(userId == "150" || userName == Global.fixUserName || userId == "null" || userName == "null"){
//				var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
				var player:PlayerDAO = new PlayerDAO();
				userName = player.getDefUser();
				userId = player.getUserInfByKey(userName,"operId");
			}
			var information:String = "UserId=" + userId + "; UserName=" + userName + "; MacId=" + macId + "; ErrorString=" + errInfo;
			return information;
		}
		
		private function readLicense():String{
			var file:File = Global.document.resolvePath("EDU_8820_License.properties");
			if(file.exists){
				var stream:FileStream = new FileStream();
				stream.open(file,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				var arr:Array = str.split("\n");
				stream.close();
				
				if(arr.length==3){
					return arr[0];
				}
			}
			return null;
		}
		
		private function sendErrInfo(info:String):void{ //上传错误信息
			var value:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
			info+="; 磁盘剩余(G)："+value.toFixed(2);
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO(info,"d",0));
			
			socket.CmdIStr[0] = CmdStr.Send_FAQ_Info;
			socket.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			
			if(Global.OS==OSType.ANDROID){
				socket.CmdIStr[2] = "Error";//菜单名称
			}else{
				socket.CmdIStr[2] = "PC Error";//菜单名称
			}
			
			socket.CmdIStr[3] = info;
			socket.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.REC_ERR_INFOR));
		}
		

	}
}