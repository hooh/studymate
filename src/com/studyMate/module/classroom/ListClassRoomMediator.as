package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ListClassRoomMediator extends ScreenBaseMediator
	{
		private const NAME:String = 'ListClassRoomMediator';
		
		protected var prepareVO:SwitchScreenVO;	
		
		private const CLASSROMM_INFO:String = 'classroom_info';//用户即将使用的信息
		public var croomUVec:ListCollection = new ListCollection();
		public var croomDVec:ListCollection = new ListCollection();
		private var isFirst:Boolean;
		
		private var tabs:TabBar;
		
		public function ListClassRoomMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(ModuleConst.CLASSROOM, viewComponent);
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			super.onRemove();
		}
		override public function onRegister():void{
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			var bg:Image = new Image(Assets.getTexture('listClassroomBg'));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			
			tabs = new TabBar();
			tabs.selectedIndex = 0;			
			tabs.x = 853;
			tabs.y = 660;
			tabs.direction = TabBar.DIRECTION_HORIZONTAL;
			tabs.gap = 0;
			tabs.dataProvider = new ListCollection(
				[					
					{label: "未辅导"} , 
					{label: "已辅导" }, 
					{label: "搜 索 "}
				]);
			tabs.customTabName = "ClassRoomTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;			
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 32, 0xFFFFFF,true);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HeiTi", 32, 0xFFFFFF,true);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 32, 0xFFFFFF);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 32, 0xFFFFFF)
			view.addChild(tabs);
			
				
			if(croomUVec.length>0 && croomUVec.getItemAt(0).tid == PackData.app.head.dwOperID.toString()){				
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ListCRteacherMediator,null,SwitchScreenType.SHOW)]);//左侧习题界面.
			}else{
				if(CacheTool.has(NAME,'tab')){
					var value:int = CacheTool.getByKey(NAME,'tab') as int;
					if(value==0){
						tabs.selectedIndex = 0;
					}else{
						tabs.selectedIndex = 1;
					}
				}
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ListCRstudentMediator,null,SwitchScreenType.SHOW)]);//左侧习题界面.
			}
		
			tabs.addEventListener(Event.CHANGE,changeStateHandler);
		}

		private function changeStateHandler(event:Event):void
		{
			switch(tabs.selectedIndex){
				case 0:
					sendNotification(CRoomConst.CHANGE_U_LIST);
					CacheTool.put(NAME,'tab',0);
					break;
				case 1:
					sendNotification(CRoomConst.CHANGE_D_LIST);
					CacheTool.put(NAME,'tab',1);
					break;
				case 2:
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SearchCRMediator)]);//左侧习题界面.					
					break;
			}
		}
		
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Quad(1,1,0x372901);;
			tab.defaultSelectedSkin = new Image(Assets.getListClassTexture("tabBarSelect"));
			tab.downSkin = new Image(Assets.getListClassTexture("tabBarSelect"));
			return tab;
		}	
		
		
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case CLASSROMM_INFO:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var croomVO:CroomVO = new CroomVO(PackData.app.CmdOStr);
						if(croomVO.crstat == 'U'){							
							croomUVec.push(croomVO);
						}else{
							croomDVec.push(croomVO);
						}
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						if(!isFirst){
							isFirst = true;
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);	
						}
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("获取房间信息后台返回错误"));
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [CLASSROMM_INFO];
		}
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			croomUVec.removeAll();
			croomDVec.removeAll();
			PackData.app.CmdIStr[0] = CmdStr.QRY_CLASSROOM_PROP;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(CLASSROMM_INFO));
			
		}		
	}
}