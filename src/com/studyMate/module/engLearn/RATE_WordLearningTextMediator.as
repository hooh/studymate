package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.ItemVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.WordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	internal class RATE_WordLearningTextMediator extends WordLearningTXTMediator
	{
		
		public  static const NAME:String = "RATE_WordLearningTextMediator";
		
		private const YES_QUIT:String = NAME+"YES_QUIT";
		private const SUBMIT:String = NAME+'submit';
		private var len:int;
		
		public function RATE_WordLearningTextMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = NAME;
		}
		
		override protected function selectMode(lw:String):void
		{
			if(lw=="FINW"){
				sendNotification(yesHandler);
			}
			if(lw=="LE101"){
				lw = 'LE006';//考核英文
			}else if(lw=="LE102"){
				lw='LE007';//考核中文
			}
			
			super.selectMode(lw);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			super.prepare(vo);
			
			for(var i:int = 0;i < itemArray.length;i++) {
				if(itemArray[i].isWord){
					itemArray[i].ROE = "E";
					itemArray[i].isCheck = false;
				}
			}
			len = itemArray.length;
		}
		private var subMitSucced:Boolean;
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()) {
				case YES_QUIT:
					quitPopScreen();
					break;
				case SUBMIT:
					if(!subMitSucced){
						subMitSucced = true;
						var totlaTime:Number = (getTimer()-startSSS)*0.001;		
						rightNum = 0;
						for(var i:int=0;i < len;i++) {	
							item = itemArray[i] as ItemVO;
							if(item){								
								if(item.isWord && item.ROE == "R") rightNum++;																								
							}
						}	
						if(rightNum<0) rightNum=0;
						PackData.app.CmdIStr[0] = CmdStr.Test_YYword;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = dataSetArr[0].rrl;
						PackData.app.CmdIStr[3] =String(int(totlaTime));
						PackData.app.CmdIStr[4] = String(rightNum); //学习正确数
						PackData.app.CmdIStr[5] = String(totalNum-rightNum); //学习错误数
						PackData.app.CmdIStr[6] = String(totalNum); //学习总数
						PackData.app.CmdIStr[7] = countNum(false).toString(); //错误单词
						PackData.app.CmdIStr[8] = countNum(true).toString(); //正确单词
						PackData.app.CmdIStr[9] = startTime; //开始学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[10] = MyUtils.getTimeFormat(); //结束学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[11] = testGetStatistics(); //统计结果
						PackData.app.CmdInCnt = 12;	
						sendNotification(CoreConst.SEND_11,new SendCommandVO(YES_QUIT,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
					}
					break;
				case yesAbandonHandler:
				case yesHandler:
					if(!subMitSucced){
						rightNum = 0;
						for(var i:int = 0;i < itemArray.length;i++) {	
							item = itemArray[i] as ItemVO;
							if(item.isWord && item.ROE == "R") rightNum++;																								
						}
						var rate:String = Math.floor(rightNum/totalNum*100)+'%';
						var str:String = "\n学习统计结果.\n答对："+rightNum+" | 总题数:"+totalNum+".\n正确率:"+rate;
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,true,SUBMIT));//提交订单
						
						sendNotification(RATE_WordLearningBGMediator.QUIT,rate);
					}
					return;
					break;
					
			}
			
			super.handleNotification(notification);
		}
		
		private function countNum(b:Boolean):Array {
			var arr:Array = [];
			var item:ItemVO;
			for(var i:int = 0;i < len;i++) {
				item = itemArray[i] as ItemVO;
				if(b) {
					if(item.isWord && item.ROE == "R" && item.isCheck) {
						arr.push(item.wordId);
					}
				} else {
					if(item.isWord && item.ROE == "E" && item.isCheck) {
						arr.push(item.wordId);
					}
				}
			}
			return arr;
		}
		protected function testGetStatistics():String {	
			var item:ItemVO, str:String = "", arr:Array = [];
			for(var i:int = 0;i < len;i++) {
				item = itemArray[i] as ItemVO;
				if(item.isWord && item.isCheck) {
					arr.push(item.wordId);
					str += "IDS`" + item.wordId + "`" + item.ROE + "`" + item.userAnswer + "`" + item.standardAnswer + "\n";
				}
			}
			return str;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(YES_QUIT,SUBMIT);
		}
		
		
	}
}