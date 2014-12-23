package com.mylib.game.runner
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class RecordPicker extends Mediator
	{
		public static const NAME:String = "RecordPicker";
		public static const REC_RECORD:String = "recRecord";
		private var records:Vector.<RunnerRecordVO>;
		
		
		public function RecordPicker()
		{
			super(NAME);
			records = new Vector.<RunnerRecordVO>;
		}
		
		public function reset():void{
			records.length = 0;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case RunnerGameConst.PICK_RECORD:
				{
					
					pick();
					
					
					
					break;
				}
				case REC_RECORD:{
					var vo:DataResultVO = notification.getBody() as DataResultVO;
					
					if(vo.isErr){
						
					}else if(!vo.isEnd){
						records.push(new RunnerRecordVO(int(PackData.app.CmdOStr[1]),PackData.app.CmdOStr[2],int(PackData.app.CmdOStr[4])
							,int(PackData.app.CmdOStr[5]),PackData.app.CmdOStr[6],PackData.app.CmdOStr[7]
						));
					}
					
					break;
				}
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [RunnerGameConst.PICK_RECORD,REC_RECORD];
		}
		
		public function getRecord():RunnerRecordVO{
			
			if(!records.length){
				return null;
			}
			
			
			var record:RunnerRecordVO = records.pop();
			
			if(record.distance<=RunnerGlobal.distance){
				return null;
			}
			
			
			return record;
		}
		
		
		public function pick():void{
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_RUN_DATA;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdIStr[2] = RunnerGlobal.map;
			PackData.app.CmdIStr[3] = String(RunnerGlobal.distance);
			PackData.app.CmdIStr[4] = 12;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(REC_RECORD,null,PackData.BUFF_ENCODE,null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			
			
			
			
			
			
		}
		
		
		
	}
}