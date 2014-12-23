package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.runner.RunnerChartItemRender;
	import com.mylib.game.runner.RunnerChartVO;
	import com.mylib.game.runner.RunnerGlobal;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class RunnerGameChartMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RunnerGameChartMediator";
		private static const GET_CHART_COMPLETE:String = NAME + "getChartComplete";
		private static const GET_MY_RANK:String = NAME + "getMyRank";
		private static const GET_STUDENT_INFO:String = NAME + "getStudentInfo";
		
		private var vo:SwitchScreenVO;
		
		private var chartList:List;
		private var dataArray:ListCollection = new ListCollection;
		
		private var tabar:TabBar;
		private var topScoreTF:TextField;
		
		private var isFirstIn:Boolean = true;
		private var mysex:String = "M";
		
		public function RunnerGameChartMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			isFirstIn = true;
			
			getInfo();
			
		}
		
		override public function onRegister():void{
			isFirstIn = false;
			
			var bg:Image = new Image(Assets.getTexture("RunerChatBg"));
			bg.x = 12;
			bg.y = 18;
			view.addChild(bg);
			
			var closeBtn:Button = new Button(Assets.getRunnerGameTexture("closeBtn"));
			closeBtn.x = 1212;
			closeBtn.y = 6;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			
			initTabar();
			
			topScoreTF = new TextField(280,45,top10Score.toString()+" m","HeiTi",33,0xa95830);
			topScoreTF.x = 900;
			topScoreTF.y = 53;
			topScoreTF.vAlign = VAlign.CENTER;
			topScoreTF.hAlign = HAlign.RIGHT;
			view.addChild(topScoreTF);
			
			refreshList(dataArray);
			
		}
		private function refreshList(data:ListCollection):void{
			if(topScoreTF)
			{
				topScoreTF.text = top10Score.toString()+"m";
			}
			
			if(chartList){
				chartList.removeFromParent(true);
			}
			
			if(data.length > 0){
				var layout:VerticalLayout = new VerticalLayout();
				layout.gap = 66;
				layout.paddingBottom = 66;
				layout.hasVariableItemDimensions = true;
				
				//初始化列表
				chartList = new List;
				chartList.layout = layout;
				chartList.allowMultipleSelection = false;
				chartList.itemRendererType = RunnerChartItemRender;
				chartList.verticalScrollPolicy =  Scroller.SCROLL_POLICY_ON;
				chartList.x = 58;
				chartList.y = 115;
				chartList.width = 1150;
				chartList.height = 605;
				view.addChild(chartList);
				
				
				initBitmapFont(data);
				chartList.dataProvider = data;
				
			}
			
			
		}
		
		private function initTabar():void{
			
			tabar = new TabBar();
			tabar.width = 561;
			tabar.x = 68;
			tabar.y = 42;
			tabar.dataProvider = new ListCollection(
				[				
					{ label: "" ,type:"" ,
						defaultIcon:new Image(Assets.getRunnerGameTexture("groupA_up")) ,
						defaultSelectedIcon:new Image(Assets.getRunnerGameTexture("groupA_down")),
						downIcon:new Image(Assets.getRunnerGameTexture("groupA_down"))},
					{ label: "" ,type:"F" ,
						defaultIcon:new Image(Assets.getRunnerGameTexture("groupF_up")) ,
						defaultSelectedIcon:new Image(Assets.getRunnerGameTexture("groupF_down")),
						downIcon:new Image(Assets.getRunnerGameTexture("groupF_down"))},
					{ label: "" ,type:"M" ,
						defaultIcon:new Image(Assets.getRunnerGameTexture("groupM_up")) ,
						defaultSelectedIcon:new Image(Assets.getRunnerGameTexture("groupM_down")),
						downIcon:new Image(Assets.getRunnerGameTexture("groupM_down"))},
				]);
			
			tabar.addEventListener(Event.CHANGE, tabarChangeHandler);
			view.addChild(tabar);
			tabar.direction = TabBar.DIRECTION_HORIZONTAL;
			tabar.selectedIndex = 0;
			
			
			tabar.customTabName = "btnTabBar";
			tabar.tabProperties.stateToSkinFunction = null;
			
			
			
			
		}
		
		private function tabarChangeHandler(event:Event):void{
			
			getChartData(tabar.selectedItem.type);
		}
		
		
		private function closeBtnHandle():void{
			
//			sendNotification(WorldConst.POP_SCREEN);
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		
		

		private var top10Score:uint = 0;
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_STUDENT_INFO:
					if(!result.isErr){
						mysex = (PackData.app.CmdOStr[21] == "0") ? "F" : "M";
						
					}
					
					getChartData();
					break;
				case GET_CHART_COMPLETE:
					if(!result.isEnd){
						var cvo:RunnerChartVO;
						
						cvo = new RunnerChartVO;
						cvo.operId = PackData.app.CmdOStr[1];
						cvo.name = PackData.app.CmdOStr[3];
						cvo.rank = dataArray.length+1;
						cvo.distance = PackData.app.CmdOStr[2];
						dataArray.push(cvo);
						
						top10Score += cvo.distance;
						//是否前十
						if(cvo.operId.toString() == PackData.app.head.dwOperID.toString()){
							isTop10 = true;
						}
					}else{
						if(isTop10){
							if(isFirstIn){
								Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
								
							}else{
								initBitmapFont(dataArray);
//								chartList.dataProvider = dataArray;
								refreshList(dataArray);
								
							}
							
						}else{
							//没有前十，如果是自己性别/全部，则取自己排名，否则直接显示
							if(isFirstIn || tabar.selectedIndex == 0 || tabar.selectedItem.type == mysex){
								getMyRank();
								
							}else{
								refreshList(dataArray);
							}
							
							
							
						}
						
						
					}
					break;
				case GET_MY_RANK:
					if(!result.isErr)
					{
						if(PackData.app.CmdOStr[6] == 0 || PackData.app.CmdOStr[3] == 0){
							if(isFirstIn){
								Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
								
							}else{
								refreshList(dataArray);
							}
							break;
						}
						
						cvo = new RunnerChartVO;
						cvo.operId = PackData.app.head.dwOperID;
						cvo.name = Global.player.realName;
						cvo.distance = PackData.app.CmdOStr[3];
						//如果查自己组排名，则取第9字段
						cvo.rank = (isFirstIn || tabar.selectedIndex == 0) ? PackData.app.CmdOStr[6] : PackData.app.CmdOStr[8];
						
						
						//如果是第11，则中间不需要插省略号
						if(cvo.rank <= 11){
							dataArray.push(cvo);
							
						}else{
							var tmpvo:RunnerChartVO = new RunnerChartVO;
							tmpvo.operId = -1;
							dataArray.push(tmpvo);
							dataArray.push(cvo);
						}
						if(isFirstIn){
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
							
						}else{
							refreshList(dataArray);
						}
					}
					
					
					
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_CHART_COMPLETE,GET_MY_RANK,GET_STUDENT_INFO];
		}
		
		
		private var isTop10:Boolean = false;
		//取数据
		private function getChartData(_group:String=""):void{
			dataArray.removeAll();
			isTop10 = false;
			top10Score = 0;
			
			PackData.app.CmdIStr[0] = CmdStr.GET_PLAYER_RANK;
			PackData.app.CmdIStr[1] = "10";
			PackData.app.CmdIStr[2] = RunnerGlobal.map;
			PackData.app.CmdIStr[3] = _group;
			PackData.app.CmdInCnt = 4;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_CHART_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));	
			
		}
		//取自己排名
		private function getMyRank():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_PLAYER_DATA;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = RunnerGlobal.map;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MY_RANK,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));	
		}
		
		
		
		private function getInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		
		
		
		//初始化位图字体
		public function initBitmapFont(_dataList:ListCollection):void{
			var len:int = _dataList.length;
			var _vo:RunnerChartVO;
			var str:String = '';
			for(var i:int=0;i< len;i++){
				_vo = (_dataList.data[i] as RunnerChartVO);
				str += (_vo.name);
			}
			if(str!=''){
				BitmapFontUtils.dispose();
				
				str += "\%.0123456789m";
				var assets:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"firstIcon");
				bmp.name = "firstIcon";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"secondIcon");
				bmp.name = "secondIcon";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"thirdIcon");
				bmp.name = "thirdIcon";
				assets.push(bmp);
				
				bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"chartItemBg");
				bmp.name = "chartItemBg";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"chartItemBg_Me");
				bmp.name = "chartItemBg_Me";
				assets.push(bmp);
				
				bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"chartPoints");
				bmp.name = "chartPoints";
				assets.push(bmp);
				
				//增加动物徽章
				for (var j:int = 0; j < 11; j++) 
				{
					bmp = Assets.getTextureAtlasBMP(Assets.store["runerGameTexture"],Assets.store["runerGameXML"],"badge/"+(j+1));
					bmp.name = "badge/"+(j+1);
					assets.push(bmp);
				}
				
				var tf:TextFormat = new TextFormat("HeiTi",25,0xfffdfd,true);
				tf.letterSpacing = -2;
				BitmapFontUtils.init(str,assets,tf,null,false);
			}
		}
		
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
			
			BitmapFontUtils.dispose();
		}
	}
}