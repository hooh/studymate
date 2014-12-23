package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PerCommandMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PerCommandMediator";
		public static const ASK_COMMAND:String = NAME + "AskCommand";
		private var file:File = Global.document.resolvePath(Global.localPath+"command/com.m");
		
		public function PerCommandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.GET_COMMAND : 
					getCommand();
					break;
				case ASK_COMMAND :
					var command:String = new String();
					if(result.isErr == false){
						if(PackData.app.CmdOStr[0] == "000"){
							command = PackData.app.CmdOStr[6];
						}
					}
					dealCommand(command);
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [ASK_COMMAND, WorldConst.GET_COMMAND];
		}
		
		private function getCommand():void{
			PackData.app.CmdIStr[0] = CmdStr.SELECT_PERCOMMAND;
			PackData.app.CmdIStr[1] = Global.license.macid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11, new SendCommandVO(ASK_COMMAND,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
		private function dealCommand(command:String):void{
			writeCommand(command);
			sendNotification(WorldConst.GET_COMMAND_OVER);
		}
		
		private function writeCommand(command:String):void{
			if(command == "") return;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.APPEND);
			stream.writeMultiByte("\n" + command, PackData.BUFF_ENCODE);
			stream.close();
		}		
		
	}
}