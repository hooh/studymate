package com.studyMate.module.game.gameEditor
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.IslandEditorConst;
	import com.studyMate.world.component.IslandList;
	import com.studyMate.world.model.vo.IslandDataVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class IslandEditorMediator extends ScreenBaseMediator
	{
		private var list:IslandList;
		private var editor:TextFieldTextEditor;
		
		
		public function IslandEditorMediator(viewComponent:Object=null)
		{
			super(ModuleConst.ISLAND_EDITOR, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			/*islandList = new ListCollection;
			
			
			for (var i:int = 0; i < 10; i++) 
			{
				var vo:IslandDataVO = new IslandDataVO("看不岛","nothing","",100,1000);
				islandList.addItem(vo);
			}*/
			
			list = new IslandList();
			
			
			view.addChild(list);
			refreshList();
			
			editor = new TextFieldTextEditor();
			view.addChild(editor);
			
			editor.textFormat = new TextFormat("HeiTi",20);
			editor.embedFonts = true;
			
			editor.x = 500;
			editor.y = 60;
			editor.width = 600;
			
			
			list.addEventListener( Event.CHANGE, list_changeHandler );
			
			var btn:Button = new Button();
			btn.label = "编辑";
			view.addChild(btn);
			btn.x = 500;
			btn.addEventListener(Event.TRIGGERED,editorBtnHandle);
			
			btn = new Button();
			btn.label = "保存";
			view.addChild(btn);
			btn.x = 580;
			btn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			
			
			btn = new Button();
			btn.label = "新建";
			view.addChild(btn);
			btn.x = 660;
			btn.addEventListener(Event.TRIGGERED,newBtnHandle);
			
			
			btn = new Button();
			btn.label = "删除";
			view.addChild(btn);
			btn.x = 740;
			btn.addEventListener(Event.TRIGGERED,delBtnHandle);
			
			btn = new Button();
			btn.label = "刷新";
			view.addChild(btn);
			btn.x = 820;
			btn.addEventListener(Event.TRIGGERED,refreshListHandle);
			
			
			
			
			
//			editor.width = 500;
//			editor.height = 300;
			
		}
		
		private function delBtnHandle(event:Event):void
		{
			
			if(list.selectedItem){
				var vo:IslandDataVO = list.selectedItem as IslandDataVO;
				PackData.app.CmdIStr[0] = CmdStr.DELETE_LAND_INFO;
				PackData.app.CmdIStr[1] = vo.name;
				PackData.app.CmdInCnt = 2;
				
				sendNotification(CoreConst.SEND_11,new SendCommandVO(IslandEditorConst.DEL_LIST_REC,[vo]));
				
				
			}
			
			
			
			
			
		}
		
		private function refreshListHandle(event:Event):void{
			list.updateData();
		}
		
		private function saveBtnHandle(event:Event):void
		{
			var str:String = editor.text.replace(/\r/g,"\n");
			var valueArr:Array = str.split("\n");
			var vo:IslandDataVO = new IslandDataVO((valueArr[0] as String).split(":")[1],
				(valueArr[1] as String).split(":")[1],
				(valueArr[2] as String).split(":")[1],
				(valueArr[3] as String).split(":")[1],
				(valueArr[4] as String).split(":")[1],
				(valueArr[5] as String).split(":")[1],
				(valueArr[6] as String).split(":")[1],
				(valueArr[7] as String).split(":")[1],
				(valueArr[8] as String).split(":")[1]
			);
			trace(vo.toString());
			
			PackData.app.CmdIStr[0] = CmdStr.INT_UPD_LAND_INFO;
			PackData.app.CmdIStr[1] = vo.name;
			PackData.app.CmdIStr[2] = vo.texture;
			PackData.app.CmdIStr[3] = vo.attribute.toString();
			PackData.app.CmdIStr[4] = vo.description;
			PackData.app.CmdIStr[5] = vo.type;
			PackData.app.CmdIStr[6] = vo.status;
			PackData.app.CmdIStr[7] = vo.price.toString();
			PackData.app.CmdIStr[8] = vo.taskNum.toString();
			PackData.app.CmdIStr[9] = vo.exploreTime.toString();
			PackData.app.CmdIStr[10] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 11;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(IslandEditorConst.UPDATE_LIST_REC,[vo]));
			
			
		}
		
		private function newBtnHandle(event:Event):void
		{
			var vo:IslandDataVO = new IslandDataVO("名字","描述","贴图名",100,1000);
			editor.text = vo.toString();
			
			list.selectedItem = null;
			list.validate();
			
			
		}
		
		private function editorBtnHandle(event:Event):void{
			
			editor.setFocus();
			
			
			
		}
		
		private function list_changeHandler(event:Event):void
		{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				var vo:IslandDataVO = list.selectedItem as IslandDataVO;
				editor.text = vo.toString();
				
				
				
			}
			
		}		
		
		private function refreshList():void{
			
			
			
			
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var dvo:DataResultVO = notification.getBody() as DataResultVO;
			
			
			switch(notification.getName())
			{
				case IslandEditorConst.UPDATE_LIST_REC:
				{
					if(dvo.isEnd&&!dvo.isErr){
						updateListData(dvo.para[0]);
					}
					break;
				}
				case IslandEditorConst.DEL_LIST_REC:{
					
					
					if(dvo.isErr){
						
					}else{
						
						
						if((PackData.app.CmdOStr[0] as String).charAt(1)!="M"){
							
							
							deletListData(dvo.para[0]);
							
							
						}
						
						
						
					}
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
			
		}
		
		
		private function deletListData(cardPlayer:IslandDataVO):void{
			if(list.dataProvider){
				var dataCollection:ListCollection = list.dataProvider;
				
				var idx:int = -1;
				for (var i:int = 0; i < dataCollection.length; i++) 
				{
					var dataItem:IslandDataVO = dataCollection.getItemAt(i) as IslandDataVO
					if(dataItem.name==cardPlayer.name){
						idx = i;
						break;
					}
				}
				
				if(idx>=0){
					dataCollection.removeItemAt(idx);
				}
				
				
			}
			
			
			
		}
		
		
		private function updateListData(vo:IslandDataVO):void{
			
			list.dataProvider||=new ListCollection();
			var dataCollection:ListCollection = list.dataProvider;
			
			var founded:Boolean = false;
			for (var i:int = 0; i < dataCollection.length; i++) 
			{
				var dataItem:IslandDataVO = dataCollection.getItemAt(i) as IslandDataVO
				if(dataItem.name==vo.name){
					dataCollection.setItemAt(vo.clone(),i);
					founded = true;
					break;
				}
			}
			
			if(!founded){
				dataCollection.addItem(vo.clone());
			}
			
			list.validate();
			
			
			
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [IslandEditorConst.UPDATE_LIST_REC,IslandEditorConst.DEL_LIST_REC];
		}
		
		
		
	}
}