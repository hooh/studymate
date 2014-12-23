package com.studyMate.world.screens
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.game.card.GameSceneMediator;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.JumpUriVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.ModuleUtils;
	import com.studyMate.view.ExecuteScriptViewMediator;
	import com.studyMate.world.component.RecordAction.RecordActionSprite;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	import com.studyMate.world.screens.ui.music.MusicBaseClass;
	import com.studyMate.world.screens.ui.music.MusicClassify;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import myLib.myTextBase.GpuTextInput;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class LaboratoryMediator extends ScreenBaseMediator{
		public static const NAME:String = "LaboratoryMediator";
		private var PASSWORD:String = "122333";
//		private var UNCHECK_PERSON:Array = ["student1","student2","student5","student7","hongtao"];
		
		private var passwordInput:GpuTextInput;
		private var enterBtn:Button;
		private var fankuiBtn:Button;
		
		private const List_All_NewUser_Rrl:String =  NAME+"ListAllNewUserRrl";
		private const End_Update:String = NAME + "EndUpdate";
		private var classifyArr:Vector.<String>;
		private var _vec:Vector.<UpdateListItemVO>;//需要更新的资源列表
		private const BGMUSIC_CLASSIFY:String = NAME+ "CLASSIFY";
		private const MUSIC_LIST:String = NAME+"MUSICLIST";
		private var needDownTxt:TextInput;
		private var queueDownMediator:QueueDownMediator;
		
		private static var isPass:Boolean;
		private var one:Image;
		public function LaboratoryMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			queueDownMediator = new QueueDownMediator();
			facade.registerMediator(queueDownMediator);
			var bg:Image = new Image(Assets.getTexture("task_bg"));
			bg.touchable = false;
			view.addChild(bg);
			
			/*if( UNCHECK_PERSON.indexOf(Global.user) != -1){
				isPass = true;
			}*/
			if( Global.user == "student1"){
				isPass = true;
			}
			
			if(isPass){
				drawTabBar();
				return;
			}else{
				one = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
				view.addChild(one);
				one.x = (Global.stageWidth - 346) / 2; one.y = 100;
				
				passwordInput = new GpuTextInput();
//				passwordInput.textEditorProperties.fontFamily = "HeiTi";
//				passwordInput.textEditorProperties.fontSize = 12;
//				passwordInput.textEditorProperties.color = 0;
//				passwordInput.useDefaultSkin = true;//是否使用默认皮肤，默认不使用
//				passwordInput.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
//				passwordInput.defaultTextFormat = new TextFormat("HeiTi",28);
//				passwordInput.displayAsPassword = true;
				passwordInput.maxChars = 8;
				passwordInput.x = (Global.stageWidth - 346) / 2 + 14; passwordInput.y = 113;
				passwordInput.width = one.width; passwordInput.height = 47;
//				Starling.current.nativeOverlay.addChild(passwordInput);
				view.addChild(passwordInput);
//				passwordInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,touchHandle);
//				passwordInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
				passwordInput.addEventListener(FeathersEventType.ENTER,inputHandle);
				
				enterBtn = new Button();
				enterBtn.label = "确定";
				enterBtn.x = 750; enterBtn.y = 100;
				enterBtn.height = one.height; enterBtn.width = one.height + 20;
				view.addChild(enterBtn);
				enterBtn.addEventListener(Event.TRIGGERED,enterBtnHandler);
			}
		}
		
		/*private function addToStageHandler():void
		{
			// TODO Auto Generated method stub
			passwordInput.backgroundDisabledSkin.visible = false;
			passwordInput.backgroundSkin.visible = false;
			passwordInput.backgroundFocusedSkin.visible = false;
			
			
		}*/
		
		/*private function touchHandle(e:flash.events.TouchEvent):void{
			passwordInput.setSelection(0,passwordInput.text.length);
		}
		*/
		private function inputHandle(e:Event):void{
//			if(e.keyCode==13){
				enterBtnHandler(null);
//			}						
		}
		
		private var container:ScrollContainer;
		private var layout:TiledRowsLayout;
		
		private function drawTabBar():void{
			var tabs:TabBar = new TabBar();
			tabs.dataProvider = new ListCollection(
				[
					{label: "正在测试"},
					{label: "测试完毕"},
					{label: "工       具"},
				]);
			view.addChild(tabs);
			tabs.x = 506;
			tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 20;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = true;
			container.x = ( Global.stageWidth - 892 ) / 2; container.y = 81;
			container.width = 892; container.height = 470;
			view.addChild(container);
			
			drawTestingBtn();
			
		}
		
		private function tabs_changeHandler( event:Event ):void{
			var tabs:TabBar = TabBar( event.currentTarget );
			if(tabs.selectedIndex == 0){
				drawTestingBtn();
			}else if(tabs.selectedIndex == 1){
				drawTestedBtn();
			}else if(tabs.selectedIndex == 2){
				drawToolBtn();
			}
		}
		
		private var btn:Button;
		
		private function drawTestingBtn():void{      /*正在测试的按钮*/
			container.removeChildren(0, -1, true);
			
		/*	var spokenBtn:Button = new Button();
			spokenBtn.label = "口语任务";
			spokenBtn.addEventListener(Event.TRIGGERED, testSpokenHandler);
			container.addChild(spokenBtn);*/
			
			btn = new Button;
			btn.label = "上传图片";
			btn.addEventListener(Event.TRIGGERED, uploadPictureHandler);
			container.addChild(btn);
			
			var crBtn:Button = new Button();
			crBtn.label = "辅导教室界面";
			crBtn.addEventListener(Event.TRIGGERED, crBtnHandler);
			container.addChild(crBtn);
			
			/*btn = new Button();
			btn.label = "习题界面";
			btn.addEventListener(Event.TRIGGERED, practiceBtnHandler);
			container.addChild(btn);*/
			
			var engTaskIslandBtn:Button = new Button();
			engTaskIslandBtn.label = "英语任务菜单";
			engTaskIslandBtn.addEventListener(Event.TRIGGERED, engTaskIslandBtnHandler);
			container.addChild(engTaskIslandBtn);
			
			/*var musicList:Button =new Button();
			musicList.label = "音乐厅";
			musicList.addEventListener(Event.TRIGGERED, enterMusicBtnHandler);
			container.addChild(musicList);*/
			
		/*	var musicMarket:Button = new Button();
			musicMarket.label = "music市场";
			musicMarket.addEventListener(Event.TRIGGERED, MusicMarketBtnHandler);
			container.addChild(musicMarket);*/
			
			var cardGame:Button = new Button();
			cardGame.label = "决战吧，海盗";
			cardGame.addEventListener(Event.TRIGGERED, cardGameHandle);
			container.addChild(cardGame);
			

			var houseEditor:Button = new Button();
			houseEditor.label = "房屋编辑器";
			houseEditor.addEventListener(Event.TRIGGERED,houseEditorHandle);
			container.addChild(houseEditor);
			
			/*btn = new Button();
			btn.label = "设置";
			btn.addEventListener(Event.TRIGGERED, settingHandler);
			container.addChild(btn);*/
			
			var npcEditor:Button = new Button();
			npcEditor.label = "npc编辑器";
			npcEditor.addEventListener(Event.TRIGGERED,npcEditorHandle);
			container.addChild(npcEditor);
			
			var gameTaskEditor:Button = new Button();
			gameTaskEditor.label = "关卡编辑器";
			gameTaskEditor.addEventListener(Event.TRIGGERED,gameTaskEditorHandle);
			container.addChild(gameTaskEditor);
			
			var islandEditor:Button = new Button();
			islandEditor.label = "岛屿编辑器";
			islandEditor.addEventListener(Event.TRIGGERED,islandEditorHandle);
			container.addChild(islandEditor);
			
			
			var formulaTest:Button = new Button();
			formulaTest.label = "数学公式测试";
			formulaTest.addEventListener(Event.TRIGGERED,testFormulaHandle);
			container.addChild(formulaTest);
			
			btn = new Button();
			btn.label = "注册用户";
			btn.addEventListener(Event.TRIGGERED, registerBtnHandler);
			container.addChild(btn);
			
			btn = new Button();
			btn.label = "家园-广场-战场（关卡1）";
			btn.addEventListener(Event.TRIGGERED, cardBattleFieldBtnHandler);
			container.addChild(btn);
			
			var svgBtn:Button = new Button();
			svgBtn.label = "SVG编辑器";
			svgBtn.addEventListener(Event.TRIGGERED, enterSVGBtnHandler);
			container.addChild(svgBtn);
			
			var svgShowBtn:Button = new Button();
			svgShowBtn.label = "SVG展示器";
			svgShowBtn.addEventListener(Event.TRIGGERED, enterSVGShowBtnHandler);
			container.addChild(svgShowBtn);
			
			var bmpEditorBtn:Button = new Button();
			bmpEditorBtn.label = "Bmp角色编辑器";
			bmpEditorBtn.addEventListener(Event.TRIGGERED, bmpEditorBtnHandler);
			container.addChild(bmpEditorBtn);
			
			var battleBtn:Button = new Button();
			battleBtn.label = "战斗场景";
			battleBtn.addEventListener(Event.TRIGGERED, battleGameHandle);
			container.addChild(battleBtn);
			
			var grammarBtn:Button = new Button();
			grammarBtn.label = "检查语法";
			grammarBtn.addEventListener(Event.TRIGGERED, grammarBtnHandle);
			container.addChild(grammarBtn);
			
			
			var recordBtn:Button = new Button;
			recordBtn.label = "录像操作";
			recordBtn.addEventListener(Event.TRIGGERED, recordBtnHandle);
			container.addChild(recordBtn);
			
			var cardSentenceBtn:Button = new Button;
			cardSentenceBtn.label = "断句测试";
			cardSentenceBtn.addEventListener(Event.TRIGGERED, testSentenceBtnHandle);
			container.addChild(cardSentenceBtn);
			
			
			var userPerBtn:Button = new Button;
			userPerBtn.label = "用户上传数据";
			userPerBtn.addEventListener(Event.TRIGGERED,userUpHandler);
			container.addChild(userPerBtn);
			/*			
			var smmJump:Button = new Button();
			smmJump.label = "SMM跳转";
			smmJump.addEventListener(Event.TRIGGERED, smmJumpHandler);
			container.addChild(smmJump);
			
			
			var enLearnChart:Button = new Button();
			enLearnChart.label = '单词统计图表';
			enLearnChart.addEventListener(Event.TRIGGERED, enLearnChartHandler);
			container.addChild(enLearnChart);
			
			var personSpace:Button = new Button();
			personSpace.label = '单词统计图表';
			personSpace.addEventListener(Event.TRIGGERED, personSpaceHandler);
			container.addChild(personSpace);*/
		}
		
		private function testSentenceBtnHandle():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestCardSentence)]);

		}
		
		private function userUpHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UserPerDataMediator)]);

		}
		
		private function recordBtnHandle():void{
			
			if(!Global.hadRecordView){
				var recordSp:RecordActionSprite = new RecordActionSprite;
				facade.registerMediator(recordSp);
				
				recordSp.view.x = 100;
				Global.stage.addChild(recordSp.view);
			}
			
			
		}
		
		private function crBtnHandler():void
		{
			// TODO Auto Generated method stub
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.CLASSROOM),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		private function personSpaceHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PersonSpaceMediator)]);
		}
		
		private function enLearnChartHandler():void
		{
			sendNotification(CoreConst.SEND_JUMP_URI,new JumpUriVO("SMM","views.EnLearnLineChartMediator"));
		}
		
		private function smmJumpHandler(e:Event):void{
			
			sendNotification(CoreConst.SEND_JUMP_URI,new JumpUriVO("SMM","views.TestFlexViewMediator"));
			
		}
		

		private function battleGameHandle(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GameSceneMediator)]);
		}
		
		private function grammarBtnHandle(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CheckGrammarViewMediator)]);
		}
		
		
		private function enterSVGShowBtnHandler(e:Event):void
		{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.SVG_SHOW),new SwitchScreenVO(CleanGpuMediator)]);
		}
		
		private function bmpEditorBtnHandler(e:Event):void{
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BmpCharaterEditorMediator)]);
		}
		
		private function enterSVGBtnHandler(e:Event):void
		{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.SVG_MAIN),new SwitchScreenVO(CleanGpuMediator)]);
		}
		
		private function cardBattleFieldBtnHandler():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandsMapMediator)]);
			
		}
		
		private function registerBtnHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RegisterUserMediator)]);
		}
		
		private function islandEditorHandle(event:Event):void
		{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.ISLAND_EDITOR)]);
		}
		
		private function gameTaskEditorHandle(event:Event):void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.GAMETASK_EDITOR)]);
		}
		
		private function testFormulaHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ModuleUtils.getModuleClass(ModuleConst.FORMULA_TEST))]);
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGTestMediator),new SwitchScreenVO(CleanGpuMediator)]);
		}
		
		private function npcEditorHandle(event:Event):void
		{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.NPC_EDITOR)]);
		}
		private function houseEditorHandle(event:Event):void{
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HouseEditorMediator)]);
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ModuleUtils.getModuleClass(ModuleConst.HOUSE_EDITOR))]);
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.HOUSE_EDITOR)]);
		}
		
		private function settingHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SystemSetMediator)]);
			
		}
		
		private function cardGameHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BattleFieldMediator)]);
		}
		
		private function drawTestedBtn():void{      /*测试完成的按钮*/
			container.removeChildren(0, -1, true);
			
			var sendMsg:Button = new Button();
			sendMsg.label = "发送消息";
			sendMsg.addEventListener(Event.TRIGGERED,sendMsgHandle);
			container.addChild(sendMsg);
			
			var chaEditorBtn:Button = new Button();
			chaEditorBtn.label = "编辑人物";
			chaEditorBtn.addEventListener(Event.TRIGGERED,chaEditorBtnHandle);
			container.addChild(chaEditorBtn);
			
			var videoBtn:Button = new Button();
			videoBtn.label = "视频播放";
			videoBtn.addEventListener(Event.TRIGGERED,videoBtnHandle);
			container.addChild(videoBtn);
			
			var testScriptBtn:Button = new Button();
			testScriptBtn.label = "绘本测试";
			testScriptBtn.addEventListener(Event.TRIGGERED, testScriptHandle);
			container.addChild(testScriptBtn);
			
			var marketViewBtn:Button = new Button();
			marketViewBtn.label = "进入商城";
			marketViewBtn.addEventListener(Event.TRIGGERED,marketViewBtnHandle);
			container.addChild(marketViewBtn);
			
			var battleBtn:Button = new Button();
			battleBtn.label = "进入战场";
			battleBtn.addEventListener(Event.TRIGGERED,battleViewBtnHandle);
			container.addChild(battleBtn);
			
			var promise:Button = new Button();
			promise.label = "家长约定";
			promise.addEventListener(Event.TRIGGERED,promiseHandle);
			container.addChild(promise);
			
			fankuiBtn = new Button();
			fankuiBtn.label = "家长反馈";
			fankuiBtn.addEventListener(Event.TRIGGERED, fankuiBtnHandler);
			container.addChild(fankuiBtn);
			
		}
		
		private function battleViewBtnHandle(event:Event):void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BattleFieldMediator)]);
		}
		
		private function drawToolBtn():void{      /*工具按钮*/
			container.removeChildren(0, -1, true);
			
			var openApp:Button = new Button();
			openApp.label = "开启应用";
			openApp.addEventListener(Event.TRIGGERED,openAppHandle);
			container.addChild(openApp);
			
			var closeApp:Button = new Button();
			closeApp.label = "关闭应用";
			closeApp.addEventListener(Event.TRIGGERED,closeAppHandle);
			container.addChild(closeApp);
			
			var openPort:Button = new Button();
			openPort.label = "开启端口";
			openPort.addEventListener(Event.TRIGGERED,openPortHandle);
			container.addChild(openPort);
			
			var closePort:Button = new Button();
			closePort.label = "关闭端口";
			closePort.addEventListener(Event.TRIGGERED,closePortHandle);
			container.addChild(closePort);
			
			var test:Button = new Button();
			test.label = "测试按钮";
			test.addEventListener(Event.TRIGGERED,sendTest);
			container.addChild(test);
			
			var picBookDownBtn:Button = new Button();
			picBookDownBtn.label = "绘本强制下载";
			picBookDownBtn.addEventListener(Event.TRIGGERED,picBookDownHandler);
			container.addChild(picBookDownBtn);
			
			var updatePicBookDownBtn:Button = new Button();
			updatePicBookDownBtn.label = "绘本刷新下载";
			updatePicBookDownBtn.addEventListener(Event.TRIGGERED,updatePicBookDownHandler);
			container.addChild(updatePicBookDownBtn);
			
			needDownTxt = new TextInput();
			needDownTxt.x = 20;
			needDownTxt.width = 100;	
			var holder:Sprite = new Sprite();
			holder.addChild(needDownTxt);			
			var updateBgMusicBtn:Button = new Button();
			updateBgMusicBtn.label = "同步背景音乐";
			updateBgMusicBtn.addEventListener(Event.TRIGGERED,updateBgMuiscDownHandler);
			holder.addChild(updateBgMusicBtn);
			updateBgMusicBtn.y = 30;
			container.addChild(holder);
			
			var packEquipmentBtn:Button = new Button();
			packEquipmentBtn.label = "打包人物素材";
			packEquipmentBtn.addEventListener(Event.TRIGGERED,packEquipmentBtnHandler);
			container.addChild(packEquipmentBtn);
			
			var spokenBtn:Button = new Button();
			spokenBtn.label = "学习快速测试入口";
			spokenBtn.addEventListener(Event.TRIGGERED,fastTrackHandler);
			container.addChild(spokenBtn);
		}
		//更新背景音乐
		private function updateBgMuiscDownHandler():void
		{		
			if(StringUtil.trim(needDownTxt.text)=="") return;
			if(classifyArr){
				classifyArr.length = 0;
			}
			_vec = new Vector.<UpdateListItemVO>;//需要更新的资源列表
			classifyArr = new Vector.<String>;
			sendinServerInofFunc(CmdStr.GET_ALL_CLASSIFY,BGMUSIC_CLASSIFY,[StringUtil.trim(needDownTxt.text),"MUSIC","*"]);//第一步取得所有分类.
		}
		
		private function fastTrackHandler():void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.FAST_LEARN)]);
		}
		
		
		private function packEquipmentBtnHandler():void{
			
			Assets.store["MHumanSK"] = null;
			Assets.store["myCharater"] = null;
			
			sendNotification(WorldConst.CREATE_CHARATER_TEXTURE);
			
		}
		
		private function updatePicBookDownHandler():void
		{
			// TODO Auto Generated method stub
			_vec = new Vector.<UpdateListItemVO>;//需要更新的资源列表
			sendinServerInfo(CmdStr.List_All_NewUser_Rrl,"All",List_All_NewUser_Rrl);//派发第一步获取所有绘本基本信息,对比版本号，选择性下载
		}
		
		
		private function practiceBtnHandler(event:Event):void{
			/*var data:Object={}
			data.rrl = "yy.E.12.001";
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PracticeViewMediator,data)]);*/
//			var data:Object = new Object;
//			data.rrl = "yy.E.12.001";
//			data.practiceId = "16,17,18,20,22";
//			data.status = "yy.E.";
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PracticeComponentViewMediator,data),new SwitchScreenVO(CleanGpuMediator)]);
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.E"}),new SwitchScreenVO(CleanCpuMediator)]);
		
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.E"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		private function picBookDownHandler():void
		{
			// TODO Auto Generated method stub
			_vec = new Vector.<UpdateListItemVO>;//需要更新的资源列表
			sendinServerInfo(CmdStr.List_All_NewUser_Rrl,"All2",List_All_NewUser_Rrl);//派发第一步获取所有绘本基本信息,不管本地有没有，全部发过来
		}		
		
		private function sendTest(e:Event):void{
			/*PackData.app.CmdIStr[0] = "USERYW.InUpdclientcomp(gdgz)";
			PackData.app.CmdIStr[1] = "";
			PackData.app.CmdIStr[2] = Global.player.operId.toString();
			PackData.app.CmdIStr[3] = Global.license.macid;
			PackData.app.CmdInCnt = 4;
			sendNotification(ApplicationFacade.SEND_11,new SendCommandVO("Test"));*/
		}
		
		private function promiseHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowProMediator)]);
		}
		
		private function sendMsgHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SendMessageMediator)]);
		}
		
		private function openPortHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
				640,381,null,"开启端口中...请等待1~2秒..."));
			
			var commands:String = "iptables -F\n" + 
					"iptables -P OUTPUT ACCEPT\n";
			EduAllExtension.getInstance().rootExecuteExtension(commands);
		}
		
		private function closePortHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
				640,381,null,"关闭端口中...请等待1~2秒..."));
			
			var commands:String = "iptables -F\n" +
				"iptables -P OUTPUT DROP\n" + 
				"iptables -A OUTPUT -p tcp --dport 8820 -j ACCEPT\n" + 
				"iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT\n" + 
				"iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT\n" + 
				"iptables -A OUTPUT -p udp --dport 53 -j ACCEPT\n" + 
				"iptables -A OUTPUT -d 211.234.103.10 -p TCP --dport 80 -j ACCEPT\n";
			EduAllExtension.getInstance().rootExecuteExtension(commands);
		}
		private function videoBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ResTableMediator)]);
		}
		private function openAppHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
				640,381,null,"正在开启桌面应用...请等待2~3秒..."));
			
			var commands:String = 
				"pm enable com.android.browser\n"+
				"pm enable com.danesh.system.app.remover\n"+
				"pm enable com.speedsoftware.rootexplorer\n"+
				"pm enable jackpal.androidterm\n"+
				"pm enable com.wandoujia.phoenix2\n"+
				"pm enable com.wandoujia.phoenix2.usbproxy\n";

			EduAllExtension.getInstance().rootExecuteExtension(commands);
		}
		
		private function closeAppHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
				640,381,null,"正在关闭桌面应用...请等待2~3秒..."));
			
			var commands:String = 
				"pm disable com.android.browser\n"+
				"pm disable com.danesh.system.app.remover\n"+
				"pm disable com.speedsoftware.rootexplorer\n"+
				"pm disable jackpal.androidterm\n"+
				"pm disable com.wandoujia.phoenix2\n"+
				"pm disable com.wandoujia.phoenix2.usbproxy\n";
			EduAllExtension.getInstance().rootExecuteExtension(commands);
		}
		
		private function marketViewBtnHandle(event:Event):void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MarketViewMediator)]);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ResTableMediator)]);
		}
		
		private function chaEditorBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CharaterEditorMediator)]);
		}
			
		
		private function testScriptHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExecuteScriptViewMediator),new SwitchScreenVO(CleanGpuMediator)]);
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);
		}
		
		/*private function testSpokenHandler(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListSpokenMeidator,{taskStyle:"@y.O"}),new SwitchScreenVO(CleanCpuMediator)]);
			//sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenCpuMediator),new SwitchScreenVO(CleanGpuMediator)]);

		}*/

		/*private function enterMusicBtnHandler(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IndexMusicMediator)]);
		}*/
		
		/*private function MusicMarketBtnHandler(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicMarketMediator)]);
		}*/
		private function engTaskIslandBtnHandler(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EngTaskIslandMediator)]);
		}
		
		private function fankuiBtnHandler(e:Event):void{
			CacheTool.clrView("MonthTaskInfoMediator");
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,PackData.app.head.dwOperID.toString(),SwitchScreenType.SHOW,view)]);
		}
		
		private function enterBtnHandler(e:Event):void{
			if(isPass||passwordInput.text == PASSWORD){
				isPass = true;
//				passwordInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,touchHandle);
//				passwordInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
				passwordInput.removeEventListener(FeathersEventType.ENTER,inputHandle);
				view.removeChild(passwordInput);
				view.removeChild(enterBtn);
				view.removeChild(one);
				passwordInput = null;
				drawTabBar();
			}else{
				passwordInput.text = "";
			}
		}
		
		private function uploadPictureHandler(e:Event):void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UploadPictureMediator)]);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PictureManagerMediator)]);
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			facade.removeMediator(QueueDownMediator.NAME);
			if(passwordInput){
				//passwordInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,touchHandle);
				//passwordInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
				//Starling.current.nativeOverlay.removeChild(passwordInput);
				passwordInput.removeEventListener(FeathersEventType.ENTER,inputHandle);
				passwordInput = null;
			}
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case "Test" : 
					trace("CmdOStr[0]=" + PackData.app.CmdOStr[0] + "=");
					trace("CmdOStr[1]=" + PackData.app.CmdOStr[1] + "=");
					trace("CmdOStr[2]=" + PackData.app.CmdOStr[2] + "=");
					break;
				case List_All_NewUser_Rrl://获取所有需要更新的列表
					if((PackData.app.CmdOStr[0] as String).charAt(0)!="!"){
						var _item:UpdateListItemVO;
						_item = new UpdateListItemVO(PackData.app.CmdOStr[1].toString(),PackData.app.CmdOStr[2].toString(),PackData.app.CmdOStr[3].toString(),PackData.app.CmdOStr[4].toString());
						_item.hasLoaded = false;
						_vec.push(_item);//swf文件						
					}else{
						sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec,End_Update));//检查本地文件
						_vec = new Vector.<UpdateListItemVO>;
					}	
					
					break;
				case End_Update:
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n更新完毕!",false));//提交订单
					break;
				case BGMUSIC_CLASSIFY:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var musicClassify:MusicClassify = new MusicClassify();
						classifyArr.push(PackData.app.CmdOStr[1]);						
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						classifyArr.push("0");												
						//第二部获取未分类的歌曲			
						sendinServerInofFunc(CmdStr.GET_RESOURCE_LIST2,MUSIC_LIST,[StringUtil.trim(needDownTxt.text),"MUSIC","*","0"]);
					}
					break;
				case MUSIC_LIST:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var baseClass:MusicBaseClass = new MusicBaseClass(PackData.app.CmdOStr);
						if(baseClass.isBgMusic!='0'){
							if(!baseClass.hasSource){
								_vec.push(new UpdateListItemVO(baseClass.downId,baseClass.path,"BOOK",baseClass.version))
							}
						}
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						classifyArr.pop();
						if(classifyArr.length){
							sendinServerInofFunc(CmdStr.GET_RESOURCE_LIST2,MUSIC_LIST,[StringUtil.trim(needDownTxt.text),"MUSIC","*",classifyArr[classifyArr.length-1]]);
						}else{
							//sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec,End_Update));//检查本地文件							
							for(var i:int=0;i<_vec.length;i++){
								queueDownMediator.addDownQueue(_vec[i],null)
							}
							_vec.length = 0;
						}
					}
					break;
				case CoreConst.REC_VERSION:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n程序列表已上传!",false));
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return ["Test",List_All_NewUser_Rrl,End_Update,MUSIC_LIST,BGMUSIC_CLASSIFY,CoreConst.REC_VERSION];
		}
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
		//后台信息派发函数
		private function sendinServerInfo(command:String,info:String,reveive:String):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.license.macid;
			PackData.app.CmdIStr[3] = info;
			PackData.app.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台		
		}
		
	}
}