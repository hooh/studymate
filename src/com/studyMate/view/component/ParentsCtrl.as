package com.studyMate.view.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.view.component.DateChooser;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	public class ParentsCtrl extends ScreenBaseMediator
	{
		public static const NAME:String = "ParentsCtrl";
		
		private static const NOTIFICATION:String = "ThisIsNOTIFICATION";
		
		private var dateChooser:DateChooser = new DateChooser();
		private var textField:TextField = new TextField();
		
		private var dataSetArr:Array;
		
		public function ParentsCtrl(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			dateChooser.height = 600;
			dateChooser.width = 800;
			dateChooser.addEventListener(DateChooser.SELECTION_CHANGED,selectionChangeHandler);
			//dateChooser.dateFormat = DateChooser.YYYY_MM_DD;
			//dateChooser.dateSeperator = "";
			view.addChild(dateChooser);
			
			textField.x = 850;
			textField.y = 0;
			textField.width = 400;
			textField.height = 800;
			textField.wordWrap = true;
			textField.multiline = true;
			//textField.background = true;
			//textField.backgroundColor = 0xFF83FA;
			view.addChild(textField);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			//			Assets.disposeTexture("engIslandBg02");
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
		}
		
		private function selectionChangeHandler(e:Event):void{
			textField.htmlText = "<b>" + dateChooser.selectedDates + "</b>";
			sendCommand(dateChooser.selectedDates.toString(),NOTIFICATION);
		}
		
		//override public prepare(vo:SwitchScreenVO):void{}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void {
			var result:DataResultVO = notification.getBody() as DataResultVO;		
			switch(notification.getName()){
				case NOTIFICATION:
					if(!result.isEnd){
						trace("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						trace("PackData.app.CmdOStr[0] : " + PackData.app.CmdOStr[0].toString());
						trace("PackData.app.CmdOStr[1] : " + PackData.app.CmdOStr[1].toString());
						trace("PackData.app.CmdOStr[2] : " + PackData.app.CmdOStr[2].toString());
						trace("PackData.app.CmdOStr[3] : " + PackData.app.CmdOStr[3].toString());
						trace("PackData.app.CmdOStr[4] : " + PackData.app.CmdOStr[4].toString());
						trace("PackData.app.CmdOStr[5] : " + PackData.app.CmdOStr[5].toString());
						trace("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
						textField.htmlText += "<div style='margin:20px auto;border: solid 0px #ff9900;background: #DDEADA;'>";
						textField.htmlText += "<br>++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
						textField.htmlText += "PackData.app.CmdOStr[0] : " + PackData.app.CmdOStr[0].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[1] : " + PackData.app.CmdOStr[1].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[2] : " + PackData.app.CmdOStr[2].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[3] : " + PackData.app.CmdOStr[3].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[4] : " + PackData.app.CmdOStr[4].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[5] : " + PackData.app.CmdOStr[5].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[6] : " + PackData.app.CmdOStr[6].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[7] : " + PackData.app.CmdOStr[7].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[8] : " + PackData.app.CmdOStr[8].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[9] : " + PackData.app.CmdOStr[9].toString() + "<br>";
						textField.htmlText += "PackData.app.CmdOStr[10] : " + PackData.app.CmdOStr[10].toString() + "<br>";
						textField.htmlText += "++++++++++++++++++++++++++++++++++++++++++++++++++++++++<br></div>";
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [NOTIFICATION];
		}
		
		private function sendCommand(selectedDates:String,reveive:String):void{
			PackData.app.CmdIStr[0] = CmdStr.QUERY_DEALTR;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = selectedDates;
			PackData.app.CmdIStr[3] = selectedDates;
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));
			trace("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
			trace("PackData.app.CmdIStr[0] : "+PackData.app.CmdIStr[0]);
			trace("PackData.app.CmdIStr[1] : "+PackData.app.CmdIStr[1]);
			trace("PackData.app.CmdIStr[2] : "+PackData.app.CmdIStr[2]);
			trace("PackData.app.CmdIStr[3] : "+PackData.app.CmdIStr[3]);
			trace("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		}
		
	}
}