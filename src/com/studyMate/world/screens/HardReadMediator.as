package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.screens.item.HardReadCellRender;
	import com.studyMate.world.screens.item.WordFrameInfo;
	
	import fl.containers.*;
	import fl.containers.BaseScrollPane;
	import fl.controls.*;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridCellEditor;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.dataGridClasses.HeaderRenderer;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ImageCell;
	import fl.controls.listClasses.ListData;
	import fl.controls.progressBarClasses.IndeterminateBar;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.DataGridEvent;
	import fl.events.SliderEvent;
	import fl.managers.StyleManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class HardReadMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "HardReadMediator";
		
		private const RECEIVE_DATA:String = "RECEIVE_DATA";
		
		
		public function HardReadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			var dp:DataProvider = new DataProvider();
			var totalEntries:uint = 10;
			var i:uint;
			for(i=0; i<totalEntries; i++) {
				dp.addItem( {     col1:"CellName",
					col2:"CellName",
					col3:"CellName" } );            
			}
			
			var dg:DataGrid = new DataGrid();
			dg.columns = [ "col1", "col2", "col3" ];
			dg.dataProvider = dp;
			dg.move(200,10);
			dg.setSize(200,300);
			view.addChild(dg);
			dg.horizontalScrollPolicy = ScrollPolicy.OFF;
			dg.verticalScrollPolicy = ScrollPolicy.OFF;
			dg.editable = false;
			
			var bt:Button = new Button();
			bt.label = "你好";
			bt.x = 200;
			view.addChild(bt);
						
			var dataGridColumn:DataGridColumn = new DataGridColumn("field");
			dataGridColumn.editable =false;				
			dataGridColumn.cellRenderer =  HardReadCellRender;
			//dg.addEventListener("GoHerHome",traceHandler);
			
			var dataGridColumn1:DataGridColumn = new DataGridColumn("field2");
			dataGridColumn1.editable =false;
			dataGridColumn1.cellRenderer =  HardReadCellRender;
			
			dg.addColumn(dataGridColumn);
			dg.addColumn(dataGridColumn1);
			
			dg.headerHeight  = 80;
			dg.rowCount = dg.length;

			
			
		}
		override public function onRemove():void{			
			super.onRemove();			
		}
		private function traceHandler(e:Event):void{
			trace("接收信息");
		}
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case RECEIVE_DATA:
					if((PackData.app.CmdOStr[0] as String).charAt(0)!="!"){
						var oneWord:WordFrameInfo = new WordFrameInfo();
						oneWord.itemid =  PackData.app.CmdOStr[2];
						oneWord.content = PackData.app.CmdOStr[3];
						oneWord.json = PackData.app.CmdOStr[4];
					}
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [RECEIVE_DATA];
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_HARDREAD_INFO;
			PackData.app.CmdIStr[1] = "3478";
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(RECEIVE_DATA));									
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}				
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}