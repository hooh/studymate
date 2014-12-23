package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.classroom.list.ListClassItemRenderer;
	import com.studyMate.module.classroom.list.ListClassItemSearchRenderer;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	
	/**
	 * note
	 * 2014-7-31上午11:27:10
	 * Author wt
	 *
	 */	
	
	public class SearchCRMediator extends ScreenBaseMediator
	{
		private var croomList:List;//列表组件
		private var useridTxt:TextFieldHasKeyboard;
		private var cridTxt:TextFieldHasKeyboard;
		public var croomDVec:ListCollection;
		private var temp:String;

		
		private const SEARCH_CR_COMPLETE:String = 'searchCrComplete';
		
		public function SearchCRMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("SearchCRMediator", viewComponent);
		}
		
		override public function onRemove():void{
			Starling.current.stage.color = 0xFFFFFF;
			KeyBoardConst.current_Keyboard = '';
			removeListener();
			if(useridTxt.parent){
				useridTxt.parent.removeChild(useridTxt);
			}
			if(cridTxt.parent){
				cridTxt.parent.removeChild(cridTxt);
			}
			super.onRemove();
		}
		override public function onRegister():void{
			Starling.current.stage.color = 0x8BDDFD;
			croomDVec = new ListCollection();
			
			var txt:TextField = new TextField(720,80,'请输入"用户id"或者"房间id"点击回车实现搜索',"HeiTi",25,0,true);
			txt.x = 100;
			view.addChild(txt);
			
			var tf:TextFormat = new TextFormat("HeiTi",33);
			
			useridTxt = new TextFieldHasKeyboard();//输入文本
			useridTxt.defaultTextFormat = tf;
			useridTxt.prompt = '用户id';
			useridTxt.x = 410;
			useridTxt.y = 100;
			useridTxt.width = 200;
			useridTxt.height = 55;
			useridTxt.maxChars = 8;
			useridTxt.restrict = "0-9";
			useridTxt.softKeyboardRestrict = /[0-9]/;
			useridTxt.border = true;
			AppLayoutUtils.cpuLayer.addChild(useridTxt);
			
			
			
			cridTxt = new TextFieldHasKeyboard();//输入文本
			cridTxt.defaultTextFormat = tf;
			cridTxt.prompt = '房间号';
			cridTxt.x = 700;
			cridTxt.y = 100;
			cridTxt.width = 200;
			cridTxt.height = 55;
			cridTxt.maxChars = 8;
			cridTxt.restrict = "0-9";
			cridTxt.softKeyboardRestrict = /[0-9]/;
			cridTxt.border = true;
			AppLayoutUtils.cpuLayer.addChild(cridTxt);
			
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 5;		
			croomList = new List();
			croomList.x = 100;
			croomList.y = 180;
			croomList.width = 1100;
			croomList.height = 550;
			croomList.layout = layout;
			croomList.itemRendererType = ListClassItemSearchRenderer;
			view.addChild(croomList);	
			croomList.dataProvider = croomDVec;

			KeyBoardConst.current_Keyboard = KeyboardType.SIMPLE_KEYBOARD;
			croomList.addEventListener( Event.CHANGE, list_changeHandler );			

			
			useridTxt.addEventListener(KeyboardEvent.KEY_DOWN,userKeyDownHandler);
			cridTxt.addEventListener(KeyboardEvent.KEY_DOWN,crKeyDownHandler);
		}
		
		private function list_changeHandler( event:Event ):void
		{
			var item:CroomVO = croomList.selectedItem as CroomVO;			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ClassroomMediator,item)]);
		}
		
		
		protected function crKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13) {//回车	
				var str:String = StringUtil.trim(cridTxt.text);
				if(str!=''){
					croomDVec.removeAll();
					removeListener();
					useridTxt.text = '';
					cridTxt.selectTextRange(0,cridTxt.length);
					temp = '房间'+str+'数据';
					PackData.app.CmdIStr[0] = CmdStr.QRY_CLASSROOM_PROP;
					PackData.app.CmdIStr[1] = '';
					PackData.app.CmdIStr[2] = str
					PackData.app.CmdInCnt = 3;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(SEARCH_CR_COMPLETE));					
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("请输入房间id"));
				}
			}
		}
		
		protected function userKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13) {//回车	
				var str:String = StringUtil.trim(useridTxt.text);
				if(str!=''){		
					croomDVec.removeAll();
					removeListener();
					cridTxt.text = '';
					useridTxt.selectTextRange(0,useridTxt.length);
					temp = '用户'+str+'数据';;
					
					PackData.app.CmdIStr[0] = CmdStr.QRY_CLASSROOM_PROP;
					PackData.app.CmdIStr[1] = str;
					PackData.app.CmdInCnt = 2;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(SEARCH_CR_COMPLETE));
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("请输入用户id"));
				}
			}
		}
		
		private function addListener():void{
			useridTxt.addEventListener(KeyboardEvent.KEY_DOWN,userKeyDownHandler);
			cridTxt.addEventListener(KeyboardEvent.KEY_DOWN,crKeyDownHandler);
		}
		private function removeListener():void{
			useridTxt.removeEventListener(KeyboardEvent.KEY_DOWN,userKeyDownHandler);
			cridTxt.removeEventListener(KeyboardEvent.KEY_DOWN,crKeyDownHandler);
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()) {
				case SEARCH_CR_COMPLETE:
					if(!result.isErr){
						if(!result.isEnd){
							var croomVO:CroomVO = new CroomVO(PackData.app.CmdOStr);
							croomVO.crstat = 'D';
							croomDVec.push(croomVO);
						}else{
							if(croomDVec.length==0){
								sendNotification(CoreConst.TOAST,new ToastVO("抱歉,没有检索"+temp));

							}
							croomList.stopScrolling();
							addListener();
						}
					}else{
						sendNotification(CoreConst.TOAST,new ToastVO("抱歉,没有检索到"+temp));

						croomList.stopScrolling();
						addListener();
					}
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [SEARCH_CR_COMPLETE];
		}
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{	
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}