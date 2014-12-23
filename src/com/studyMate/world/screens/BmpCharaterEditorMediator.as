package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.PetDogMediator;
	import com.mylib.game.charater.logic.PetFactoryProxy;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.component.BmpCharaterList;
	import com.studyMate.world.model.vo.BmpCharaterDataVO;
	
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class BmpCharaterEditorMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "BmpCharaterEditorMediator";
		private var list:BmpCharaterList;
		private var editor:TextFieldTextEditor;
		
		public function BmpCharaterEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
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
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			list = new BmpCharaterList();
			
			
			view.addChild(list);
			
			editor = new TextFieldTextEditor();
			view.addChild(editor);
			
			editor.textFormat = new TextFormat("HeiTi",20);
			editor.embedFonts = true;
			
			editor.x = 500;
			editor.y = 150;
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
			
			
			initDefault();
			
			GlobalModule.charaterUtils.humanDressFun(dog,"bmpNpc_bmp1");
			dog.actor.switchCostume("head","bmpNpc","normal");
			updateListData(new BmpCharaterDataVO("petDog1","bmpNpc_bmp1"));
			
			createControl();
		}
		
		private var dog:PetDogMediator;
		private function initDefault():void{
			var petCreater:PetFactoryProxy = facade.retrieveProxy(PetFactoryProxy.NAME) as PetFactoryProxy;
			dog = petCreater.getPetDog("petDog1","dog1",null);
			
			dog.velocity = 3;
			
			dog.view.x = 1000;
			dog.view.y = 250;
			
			dog.view.scaleX = 3;
			dog.view.scaleY = 3;
			
			view.addChild(dog.view);
			
			
			
			
			
			
		}
		private var preBtn:Button;
		private var btnList:Vector.<Button> = new Vector.<Button>;
		private function createControl():void{
			for(var i:int=0;i<btnList.length;i++){
				
				if(btnList[i])
					btnList[i].removeFromParent(true);
				
			}
			
			//动作系列按钮
			var actionBtnList:Array = GlobalModule.charaterUtils.getHumanFaceList(GlobalModule.charaterUtils.getHumanDressList(dog));
			var actionBtn:Button;
			preBtn = new Button();
			preBtn.x = 500
			for(i=0;i<actionBtnList.length;i++){
				actionBtn = new Button();
				actionBtn.name = actionBtnList[i]+"Btn";
				actionBtn.label = actionBtnList[i];
				view.addChild(actionBtn);
				actionBtn.validate();
				
				actionBtn.x = preBtn.x + preBtn.width + 5;
				actionBtn.y = 60;
				preBtn = actionBtn;
				
				actionBtn.addEventListener(Event.TRIGGERED,actionBtnHandle);
			}
			
		}
		private function actionBtnHandle(event:Event):void{
			var acterState:String = (event.target as Button).label;
			
			dog.actor.switchCostume("head","face",acterState);
		}
		
		
		//编辑
		private function editorBtnHandle(event:Event):void{
			editor.setFocus();
		}
		//新建
		private function newBtnHandle(event:Event):void
		{
			var vo:BmpCharaterDataVO = new BmpCharaterDataVO("name","face_bmp");
			editor.text = vo.toString();
			
			list.selectedItem = null;
			list.validate();
			
			
		}
		//保存
		private function saveBtnHandle(event:Event):void
		{
			var str:String = editor.text.replace(/\r/g,"\n");
			var valueArr:Array = str.split("\n");
			var vo:BmpCharaterDataVO = new BmpCharaterDataVO((valueArr[0] as String).split(":")[1],
				(valueArr[1] as String).split(":")[1]
			);
			trace(vo.toString());
			
			
			updateListData(vo);
			
			GlobalModule.charaterUtils.humanDressFun(dog,vo.dressList);
			dog.actor.switchCostume("head","bmpNpc","normal");
			
			createControl();
		}
		//删除
		private function delBtnHandle(event:Event):void
		{
			
			if(list.selectedItem){
				
				deletListData(list.selectedItem as BmpCharaterDataVO);
				
			}
		}
		//刷新
		private function refreshListHandle(event:Event):void{
			list.updateData();
		}
		
		
		
		private function updateListData(vo:BmpCharaterDataVO):void{
			
			list.dataProvider||=new ListCollection();
			var dataCollection:ListCollection = list.dataProvider;
			
			var founded:Boolean = false;
			for (var i:int = 0; i < dataCollection.length; i++) 
			{
				var dataItem:BmpCharaterDataVO = dataCollection.getItemAt(i) as BmpCharaterDataVO;
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
		private function deletListData(bmp:BmpCharaterDataVO):void{
			if(list.dataProvider){
				var dataCollection:ListCollection = list.dataProvider;
				
				var idx:int = -1;
				for (var i:int = 0; i < dataCollection.length; i++) 
				{
					var dataItem:BmpCharaterDataVO = dataCollection.getItemAt(i) as BmpCharaterDataVO
					if(dataItem.name==bmp.name){
						idx = i;
						break;
					}
				}
				
				if(idx>=0){
					dataCollection.removeItemAt(idx);
				}
			}
		}
		
		
		
		
		
		
		private function list_changeHandler(event:Event):void
		{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				var vo:BmpCharaterDataVO = list.selectedItem as BmpCharaterDataVO;
				editor.text = vo.toString();
				
				
				GlobalModule.charaterUtils.humanDressFun(dog,vo.dressList);
				dog.actor.switchCostume("head","bmpNpc","normal");
				createControl();
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var dvo:DataResultVO = notification.getBody() as DataResultVO;
			
			
			switch(notification.getName())
			{
					
				default:
				{
					break;
				}
			}
			
		}
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			dog.dispose();
		}
		

		
		

		
		
		
		
		
		
		
	}
}