package com.studyMate.module.game.gameEditor
{
	import com.byxb.utils.centerPivot;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.model.DressSuitsProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class DressMarketManagerMediator extends ScreenBaseMediator
	{
		private static const QRY_EQUIPMENT:String = "QryEquipment";
		private static const INUP_EQUIPMENT:String = "InupEquipment";
		private static const DEL_EQUIPMENT:String = "DelEquipment";
		
		private var vo:SwitchScreenVO;
		
		private var dressSuitsProxy:DressSuitsProxy;
		private var suitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		private var loalSuitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		private var marketSuitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		
		private var locList:List;
		private var marketList:List;
		
		private var previewSp:Sprite;
		
		public function DressMarketManagerMediator(viewComponent:Object=null)
		{
			super(ModuleConst.DRESS_MARKET_MANAGER, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			getEquipForServer();
		}
		
		private var currentTF:TextField;
		override public function onRegister():void{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			
			if(dressSuitsProxy.dressSuitsVoList)
				suitList = dressSuitsProxy.dressSuitsVoList;
			else
				suitList = new Vector.<DressSuitsVO>;
			
			//去重复，把后台存在的从本地列表去除
			filterLoclist();
			
			initLocalList();
			initMarketList();
			
			updateList(locList,loalSuitList);
			updateList(marketList,marketSuitList);
			
			currentTF = new TextField(230,60,"请选择一件装备","HeiTi",30);
			centerPivot(currentTF);
			currentTF.x = 640;
			currentTF.y = 120;
			view.addChild(currentTF);
			
			
			previewSp = new Sprite;
			previewSp.x = 680;
			previewSp.y = 300;
			view.addChild(previewSp);
			
			creatInfoSp();
		}
		//过滤本地列表
		private function filterLoclist():void{
			for(var i:int=0;i<suitList.length;i++){
				var isHad:Boolean = false;
				
				//服务器存在，或者是脸，则在本地列表显示
				if(suitList[i].suitType == "face")
					isHad = true;
				else{
					for(var j:int=0;j<marketSuitList.length;j++){
						
						if(suitList[i].name == marketSuitList[j].name){
							marketSuitList[j].suitType = suitList[i].suitType;
							marketSuitList[j].sex = suitList[i].sex;
							marketSuitList[j].level = suitList[i].level;
							marketSuitList[j].equipments = suitList[i].equipments.concat();
							
							isHad = true;
							
							break;
						}
					}
				}
				
				
				//服务器已存在该装备，本地不显示
				if(!isHad)
					loalSuitList.push(suitList[i]);
			}
		}

		
		private function initLocalList():void{
			locList = new List();
			locList.name = "locList";
			locList.x = 100;
			locList.y = 50;
			locList.width = 400;
			locList.height = 500;
			locList.itemRendererProperties.labelField ="name";
			locList.itemRendererFactory = itemFactory;
			locList.addEventListener( Event.CHANGE, itemClickHandle );
			view.addChild(locList);
			
			
		}
		private function initMarketList():void{
			marketList = new List();
			marketList.name = "marketList";
			marketList.x = 780;
			marketList.y = 50;
			marketList.width = 400;
			marketList.height = 500;
			marketList.itemRendererProperties.labelField ="name";
			marketList.itemRendererFactory = itemFactory;
			marketList.addEventListener( Event.CHANGE, itemClickHandle );
			view.addChild(marketList);
			
		}
		private function updateList(_list:List,_suitlist:Vector.<DressSuitsVO>):void{
			var dataList:ListCollection = new ListCollection();
			for (var i:int = 0; i < _suitlist.length; i++) 
			{
				dataList.addItem(_suitlist[i]);
			}
			_list.dataProvider = dataList;
		}
		
		private var currentSuit:DressSuitsVO;
		private function itemClickHandle(event:Event):void{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				if(list.name == "locList")
					marketList.selectedItem = null;
				else if(list.name == "marketList")
					locList.selectedItem = null;
				
				
				previewSp.removeChildren(0,-1,true);
				currentSuit = list.selectedItem as DressSuitsVO;
				
				var img:DisplayObject = GlobalModule.charaterUtils.getNormalEquipImg(currentSuit,2);
				if(img){
					
					
					previewSp.addChild(img);centerPivot(img);
				}else{
					
					
					var tips:TextField = new TextField(230,60,"该装备在图库中不存在，强烈建议从商城删除！","HeiTi",20);
					tips.autoScale = true;
					centerPivot(tips);
					previewSp.addChild(tips);
				}
				
				//有装备id，属于商城装备
				if(currentSuit.equipId != ""){
					currentTF.text = "商城装备";
					
					setInfoSp(currentSuit.name,currentSuit.price.toString(),false);
				}else{
					currentTF.text = "图库装备";
					
					setInfoSp(currentSuit.name,currentSuit.price.toString());
					
				}
				
				
			}
		}
		
		private var listInfoSp:Sprite = new Sprite;
		private var nameInput:TextInput;
		private var priceInput:TextInput;
		private var saveBtn:Button;
		private var delBtn:Button;
		private function creatInfoSp():void{
			listInfoSp.x = 100;
			listInfoSp.y = 600;
			view.addChild(listInfoSp);
			
			nameInput = new TextInput();
			nameInput.width = 160;
			nameInput.height = 50;
			nameInput.isEnabled = false;
			listInfoSp.addChild(nameInput);
			
			priceInput = new TextInput();
			priceInput.width = 160;
			priceInput.height = 50;
			priceInput.x = 250;
			listInfoSp.addChild(priceInput);
			
			saveBtn = new Button();
			saveBtn.label = "上传服务器";
			saveBtn.width = 100;
			saveBtn.height = 50;
			saveBtn.x = 800;
			saveBtn.y = 20;
			listInfoSp.addChild(saveBtn);
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			
			delBtn = new Button();
			delBtn.label = "删除装备";
			delBtn.width = 100;
			delBtn.height = 50;
			delBtn.x = 800;
			delBtn.y = 20;
			delBtn.visible = false;
			listInfoSp.addChild(delBtn);
			delBtn.addEventListener(Event.TRIGGERED,delBtnHandle);
		}
		private function setInfoSp(_name:String,_price:String,isSave:Boolean=true):void{
			nameInput.text = _name;
			priceInput.text = _price;
			
			if(isSave){
				delBtn.visible = false;
				saveBtn.visible = true;
			}else{
				saveBtn.visible = false;
				delBtn.visible = true;
			}
		}
		//装备上传服务器
		private function saveBtnHandle():void{
			
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,doSave,"确定要上架装备 "+currentSuit.name +" ？"));

		}
		private function doSave():void{
			if(currentSuit){
				PackData.app.CmdIStr[0] = CmdStr.INUP_EQUIPMENT;
				PackData.app.CmdIStr[1] = "0";
				PackData.app.CmdIStr[2] = currentSuit.name;
				PackData.app.CmdIStr[3] = priceInput.text;
				PackData.app.CmdInCnt = 4;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(INUP_EQUIPMENT));
			}
		}
		//删除服务器装备
		private function delBtnHandle():void{
			
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,doDel,"确定要将 "+currentSuit.name +" 从商城下架？"));
			
		}
		private function doDel():void{
			if(currentSuit){
				PackData.app.CmdIStr[0] = CmdStr.DEL_MARKET_EQUIPMENT;
				PackData.app.CmdIStr[1] = currentSuit.equipId;
				PackData.app.CmdInCnt = 2;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_EQUIPMENT));
			}
		}
		
		
		
		
		
		
		private function itemFactory():IListItemRenderer{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.accessoryFunction = itemFun;
			return renderer;
		}
		private function itemFun( item:DressSuitsVO ):DisplayObject{
			var render:DMManagItemRender = new DMManagItemRender();
			render.data = item;
			return render;
		}
		
		
		//取后台装备列表
		private function getEquipForServer():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_EQUIPMENT;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_EQUIPMENT));
		}
		
		private var isFirstIn:Boolean = true;
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case QRY_EQUIPMENT:
					//取商城所有装备
					if(!result.isEnd){
						
						var dressSuitVo:DressSuitsVO = new DressSuitsVO();
						dressSuitVo.equipId = PackData.app.CmdOStr[1];
						dressSuitVo.name = PackData.app.CmdOStr[2];
						dressSuitVo.price = PackData.app.CmdOStr[3];
						
						marketSuitList.push(dressSuitVo);
						
					}else{
						if(isFirstIn){
							isFirstIn = false;
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}else{
							locList.selectedItem = null;
							marketList.selectedItem = null;
							nameInput.text = "";
							priceInput.text = "";
							
							filterLoclist();
							
							updateList(locList,loalSuitList);
							updateList(marketList,marketSuitList);
							
							
						}
						
						
						
					}
					break;
				case INUP_EQUIPMENT:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						//成功上传装备，刷新两边列表
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"装备"+currentSuit.name+"上架成功，正在刷新列表"));
						
						loalSuitList.splice(0,loalSuitList.length);
						marketSuitList.splice(0,marketSuitList.length);
						
						
						getEquipForServer();
						
					}else if((PackData.app.CmdOStr[0] as String)=="0M1"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"该装备已存在，请与技术人员联系"));
						
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"莫名错误导致购买失败，请与技术人员联系"));
					}
					break;
				case DEL_EQUIPMENT:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						//成功删除
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"装备"+currentSuit.name+"已经下架，正在刷新列表"));
						
						loalSuitList.splice(0,loalSuitList.length);
						marketSuitList.splice(0,marketSuitList.length);
						
						
						getEquipForServer();
						
					}else if((PackData.app.CmdOStr[0] as String)=="0M1"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"该装备不存在，请与技术人员联系"));
						
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"莫名错误导致购买失败，请与技术人员联系"));
					}
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [QRY_EQUIPMENT,INUP_EQUIPMENT,DEL_EQUIPMENT];
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void
		{
			view.removeChildren(0,-1,true);
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
		}
	}
}