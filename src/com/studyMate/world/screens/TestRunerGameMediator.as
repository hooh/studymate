package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.mylib.game.runner.GuideRunner;
	import com.mylib.game.runner.Item;
	import com.mylib.game.runner.ItemManager;
	import com.mylib.game.runner.MapDataGener;
	import com.mylib.game.runner.OperType;
	import com.mylib.game.runner.PlayerRunner;
	import com.mylib.game.runner.RecordPicker;
	import com.mylib.game.runner.Runner;
	import com.mylib.game.runner.RunnerAwardVO;
	import com.mylib.game.runner.RunnerCloudProxy;
	import com.mylib.game.runner.RunnerGameConst;
	import com.mylib.game.runner.RunnerGlobal;
	import com.mylib.game.runner.RunnerPool;
	import com.mylib.game.runner.RunnerRecordVO;
	import com.mylib.game.runner.RunnerRecorder;
	import com.mylib.game.runner.levelStage.LevelStage;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class TestRunerGameMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "com.studyMate.world.screens.TestRunerGameMediator";
		private var camera:CameraSprite;
		
		
		private var background:ParallaxSprite;
		private var background2:ParallaxSprite;
		private var background3:ParallaxSprite;
		
		private var backgrounds:Vector.<ParallaxSprite>;
		
		private var currentBackground:ParallaxSprite;
		private var bgIndex:int;
		
		
		
		private var xPos:int;
		
		private var speed:int;
		
		private var cameraOffsetX:int;
		private var cameraOffsetY:int;
		private var frontGround:ParallaxSprite;
		private var _velocity:Vector3D;
		private var itemManger:ItemManager;
		private var itemHolder:Sprite;
		private var frontItem:Item;
		private var isEnd:Boolean;
		private var restartBtn:feathers.controls.Button;
		private var gener:MapDataGener;
		
//		private var runner:Runner;
		
		private var currentPlayer:PlayerRunner;
		private var player:PlayerRunner;
		private var guid:GuideRunner;
		
		private var recorder:RunnerRecorder;
		private var islanderPool:IslanderPoolProxy;
		
		private var count:Number;
		
		private const playerOffset:int = -400;
		private var label:starling.text.TextField;
		private var label2:Label;
		private var textInput:TextInput;
		
		private var runners:Vector.<Runner>;
		private var runner:Runner;
		private var runnerHolder:Sprite;
		private var runnersPool:RunnerPool;
		private var uiHolder:Sprite;
		
		private static const UPLOAD_RECORD_COMPLETE:String = "uploadRecordComplete";
		private static const UPLOAD_MAP_COMPLETE:String = "uploadMapComplete";
		
		private var picker:RecordPicker;
		private static const MAX_RUNNER:uint = 5;
		private var isGuide:Boolean;
		
		private var _fsm:StateMachine;
		
		private const START:String = "start";
		private const PLAY:String = "play";
		private const RESTART:String = "restart";
		private const END:String = "end";
		private const PAUSE:String = "pause";
		private const PLAYING:String = "playing";
		
		
		private var startBtn:starling.display.Button;
		
		private static const PLAYER_SCORE_REC:String = NAME+"playerSocreRec";
		private static const START_RUN_REC:String = NAME + "startRunRec";
		private static const MAP_REC:String = NAME + "mapRec";
		
		private var startUIHolder:Sprite;
		private var runTimeLabel:TextField;
		private var timesIcon:Image;
		
		private var alert:Alert;
		private var showChartBtn:starling.display.Button;
		private var helpBtn:starling.display.Button;
		
		private var pauseBtn:starling.display.Button;
		private var bgMusic:Sound;
		
		private var jumpEff:Sound;
		
		private var bgMusicChannel:SoundChannel;
		
		private var levelStage:LevelStage;
		
		private var bgItemHodler:Sprite;
		
		private var ground:ParallaxSprite;
		
		private var cloudProxy:RunnerCloudProxy;
		
		private var liveRecord:RunnerRecorder;
		
		public function TestRunerGameMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			RunnerGlobal.distance =0;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			bgMusicChannel.stop();
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
			
			
			TweenMax.killAll(true);
			itemManger.recycleAll();
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
			recorder.reset();
			picker.reset();
			player.dispose();
			guid.dispose();
			levelStage.dispose();
			facade.removeMediator(picker.getMediatorName());
			
			starling.text.TextField.unregisterBitmapFont("en35BS",true);
				
			facade.removeProxy(recorder.getProxyName());
			facade.removeProxy(liveRecord.getProxyName());
			
			for (var i:int = 0; i < runners.length; i++) 
			{
				runnersPool.object = runners[i];
			}
			
			runners.length = 0;
			
			runnersPool.deconstruct();
			facade.removeMediator(itemManger.getMediatorName());
			Starling.juggler.remove(RunnerGlobal.juggler);
			
			/*sendNotification(WorldConst.STOP_RANDOM_ACTION);*/
			facade.removeProxy(CharaterSuitsInfoProxy.NAME);
			facade.removeProxy(RunnerCloudProxy.NAME);
			
			sendNotification(CoreConst.START_BEAT);
			sendNotification(WorldConst.SHOW_NOTICE_BOARD);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var vo:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case RunnerGameConst.GAME_END:
				{
					
					_fsm.changeState(END);
					
					
					break;
				}
				case RunnerGameConst.SET_SPEED:{
					runner.speed = _velocity.x = currentPlayer.speed = notification.getBody() as Number;
					
					for (var i:int = 0; i < runners.length; i++) 
					{
						runners[i].speed = currentPlayer.speed;
					}
					
					
					break;
				}
				case RunnerGameConst.SET_ACC:{
					currentPlayer.acc = notification.getBody() as Number;
					
					break;
				}
				case UPLOAD_RECORD_COMPLETE:{
					if(vo.isErr){
						sendNotification(CoreConst.TOAST,new ToastVO("上传记录失败"));
					}else{
						RunnerGlobal.maxDistance = RunnerGlobal.distance;
					}
					
					
					break;
				}
				case RunnerGameConst.RESTART:{
					startBtnHandle();
					break;
				}
				case PLAYER_SCORE_REC:{
					
					if(!vo.isErr){
						
						
						RunnerGlobal.runTime = PackData.app.CmdOStr[1];
						RunnerGlobal.gold =  PackData.app.CmdOStr[2];
						RunnerGlobal.maxDistance = PackData.app.CmdOStr[3];
						RunnerGlobal.maxRunTime = PackData.app.CmdOStr[4];
						RunnerGlobal.runCost = PackData.app.CmdOStr[5];
						
						
						if(RunnerGlobal.maxRunTime>RunnerGlobal.runTime){
							runTimeLabel.text = (RunnerGlobal.maxRunTime-RunnerGlobal.runTime).toString();
						}else{
							
							var matrix:Vector.<Number>= Vector.<Number>([0.3086, 0.6094, 0.0820, 0, 0,  
								0.3086, 0.6094, 0.0820, 0, 0,  
								0.3086, 0.6094, 0.0820, 0, 0,  
								0,      0,      0,      1, 0]);  
							var myfilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);  
							startBtn.filter=myfilter;
							
							runTimeLabel.text = "0";
						}
						
						
					}
					break;
				}
				case START_RUN_REC:{
					
					if(!vo.isErr){
						
						

						if(String(PackData.app.CmdOStr[0])!="000"){
							sendNotification(CoreConst.TOAST,new ToastVO(PackData.app.CmdOStr[1]));
							_fsm.changeState(START);
							return;
						}
						RunnerGlobal.runTime = int(PackData.app.CmdOStr[1]);
						var remain:int = RunnerGlobal.maxRunTime-RunnerGlobal.runTime;
						
						remain>0?remain:remain=0;
						runTimeLabel.text = remain.toString();
						_fsm.changeState(PLAY);
						
						RunnerGlobal.gold = int(PackData.app.CmdOStr[2]);
						
						showChartBtn.visible = false;
						helpBtn.visible = false;
					}
					
					break;
				}
				case MAP_REC:{
					
					if(!vo.isErr){
						
						RunnerGlobal.map = PackData.app.CmdOStr[1];
						mapData = Vector.<Number>(String(PackData.app.CmdOStr[2]).split(","));
						
						
					}
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					
					
					break;
				}
				case RunnerGameConst.LEVEL_UP:{
					
					if(notification.getBody()>1){
						levelStage.x = camera.viewport.right;
						bgItemHodler.addChild(levelStage);
						levelStage.y = 50;
						
						levelStage.refresh();
						
					}else{
						bgIndex = -1;
					}
					
					TweenLite.to(currentBackground,1,{alpha:0,onComplete:currentBackground.removeFromParent});
					bgIndex++;
					bgIndex>=backgrounds.length?bgIndex = 0:bgIndex;
					
					currentBackground = backgrounds[bgIndex];
					currentBackground.alpha = 0;
					TweenLite.to(currentBackground,1,{alpha:1});
					camera.addChildAt(currentBackground,0);
					System.pauseForGCIfCollectionImminent(1);
					
					
					break;
				}
				case UPLOAD_MAP_COMPLETE:{
					if(!vo.isErr){
						sendNotification(CoreConst.TOAST,new ToastVO("上传地图成功"));
					}else{
						sendNotification(CoreConst.TOAST,new ToastVO("上传地图失败"));
					}
					
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [RunnerGameConst.GAME_END,RunnerGameConst.SET_SPEED,RunnerGameConst.SET_ACC,UPLOAD_RECORD_COMPLETE,RunnerGameConst.RESTART,PLAYER_SCORE_REC,START_RUN_REC
			,MAP_REC,RunnerGameConst.LEVEL_UP,UPLOAD_MAP_COMPLETE
			
			];
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			sendNotification(CoreConst.STOP_BEAT);
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);//隐藏公告栏
			
			RunnerGlobal.juggler = new Juggler();
			Starling.juggler.add(RunnerGlobal.juggler);
			
			recorder = new RunnerRecorder("record");
			facade.registerProxy(recorder);
			
			liveRecord = new RunnerRecorder("liveRecord");
			facade.registerProxy(liveRecord);
			
			runnerViewMap = new Dictionary;
			picker = new RecordPicker();
			facade.registerMediator(picker);
			
			islanderPool = new IslanderPoolProxy(true);
			facade.registerProxy(islanderPool);
			islanderPool.init();
			
			facade.registerProxy(new CharaterSuitsInfoProxy());
			
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			background = new ParallaxSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			background2 = new ParallaxSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			background3 = new ParallaxSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			backgrounds = Vector.<ParallaxSprite>([background,background2,background3]);
			
			ground = new ParallaxSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			background2.alpha = 0;
			
			camera.addChild(ground);
			
			//			addStretchable(Assets.getAtlas().getTexture("bg/sky"),1,new InfiniteRectangle(Number.NEGATIVE_INFINITY, -396, Number.POSITIVE_INFINITY, 762));
			boundR.x=-640;
			boundR.y=-110;
			camera.moveTo(xPos, 0, 1, 0, false);
			background.addTileable(Assets.getRunnerGameAtlas().getTextures("bg1"),0.5,boundR.clone(), null, Tiling.TILE_X);
			background2.addTileable(Assets.getRunnerGameAtlas().getTextures("bg2"),0.3,boundR.clone(), null, Tiling.TILE_X);
			boundR.y=-90;
			background3.addTileable(Assets.getRunnerGameAtlas().getTextures("bg3"),0.3,boundR.clone(), null, Tiling.TILE_X);
			boundR.y=-110;
			ground.addTileable(Assets.getRunnerGameAtlas().getTextures("ground1"),1,boundR.clone(), null, Tiling.TILE_X); 
			
			currentBackground = background;
			
			
			
			
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			runEnterFrames = true;
			
			bgItemHodler = new Sprite();
			camera.addChild(bgItemHodler);
			
			
			count = 0;
			itemHolder = new Sprite;
			
			camera.addChild(itemHolder);
			
			runnerHolder = new Sprite;
			camera.addChild(runnerHolder);
			
			speed = 4;
			
			
			cameraOffsetX = 400;
			cameraOffsetY = -80;
			itemManger = new ItemManager(itemHolder);
			facade.registerMediator(itemManger);
			
			player = new PlayerRunner("myPlayer");
			player.recorder = liveRecord;
			player.offset = playerOffset;
			facade.registerMediator(player);
			player.dressUp(Global.myDressList);
			runnerViewMap[player.view] = player;
			player.start();
			sendNotification(WorldConst.MARK_MY_CHARATER,player.charater.charater);
			
			
			runner = new Runner("runner1");
			runner.offset = -500;
//			facade.registerMediator(runner);
			runner.speed = 4;
//			camera.addChild(runner.view);
			
			
			runnersPool = new RunnerPool;
			
			
			runners = new Vector.<Runner>;
			
			
			boundR.y=-200;
			frontGround = new ParallaxSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			camera.addChild(frontGround);
			frontGround.addTileable(Assets.getRunnerGameAtlas().getTextures("fg1"),2,boundR.clone(), null, Tiling.TILE_X); 
			Starling.current.stage.color = 0xB7EAE0;
			
			
			_velocity = new Vector3D(4,0);
			
			
			uiHolder = new Sprite;
			view.addChild(uiHolder);
			
			
			/*label2 = new Label();
			label2.x = 510;
			label2.y = 40;
			label2.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			label2.textRendererProperties.textFormat = new TextFormat( "HeiTi", 15, 0 );

			uiHolder.addChild(label2);
			
			gener = new MapDataGener;
			
			mapData = gener.readMap();
			
			
			var genBtn:feathers.controls.Button;
			genBtn = new feathers.controls.Button();
			genBtn.label = "gen";
			uiHolder.addChild(genBtn);
			genBtn.x = 100;
			genBtn.addEventListener(Event.TRIGGERED,genBtnhandle);
			
			var uploadBtn:feathers.controls.Button;
			uploadBtn = new feathers.controls.Button();
			uploadBtn.label = "uploadMap";
			uiHolder.addChild(uploadBtn);
			uploadBtn.x = 1000;
			uploadBtn.addEventListener(Event.TRIGGERED,uploadBtnHandle);*/
			
			/*restartBtn = new Button();
			restartBtn.label = "restart";
			uiHolder.addChild(restartBtn);
			restartBtn.addEventListener(Event.TRIGGERED,restart);
			
			var genBtn:Button;
			genBtn = new Button();
			genBtn.label = "gen";
			uiHolder.addChild(genBtn);
			genBtn.x = 100;
			genBtn.addEventListener(Event.TRIGGERED,genBtnhandle);
			
			
			
			var readBtn:Button;
			readBtn = new Button();
			readBtn.label = "read";
			uiHolder.addChild(readBtn);
			readBtn.x = 200;
			readBtn.addEventListener(Event.TRIGGERED,readBtnHandle);
			
			
			
			var saveBtn:Button;
			saveBtn = new Button();
			saveBtn.label = "save t";
			uiHolder.addChild(saveBtn);
			saveBtn.x = 280;
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			
			readBtn = new Button();
			readBtn.label = "read t";
			uiHolder.addChild(readBtn);
			readBtn.x = 360;
			readBtn.addEventListener(Event.TRIGGERED,readTrackBtnHandle);
			
			var reviveBtn:Button;
			reviveBtn = new Button();
			reviveBtn.label = "revive";
			uiHolder.addChild(reviveBtn);
			reviveBtn.x = 440;
			reviveBtn.addEventListener(Event.TRIGGERED,reviveBtnHandle);
			
			
			runner.data = recorder.read();
			runner.acc = 1;
			
			
			textInput = new TextInput();
			textInput.x = 550;
			textInput.restrict = "0-9";
			uiHolder.addChild(textInput);
			
			var goBtn:Button = new Button();
			goBtn.x = 750;
			goBtn.label = "go";
			goBtn.addEventListener(Event.TRIGGERED,goBtnHandle);
			uiHolder.addChild(goBtn);
			
			
			var rpBtn:Button;
			rpBtn = new Button();
			rpBtn.label = "rp";
			uiHolder.addChild(rpBtn);
			rpBtn.x = 830;
			rpBtn.addEventListener(Event.TRIGGERED,rpBtnHandle);
			
			var pauseBtn:Button;
			pauseBtn = new Button();
			pauseBtn.label = "pause";
			uiHolder.addChild(pauseBtn);
			pauseBtn.x = 900;
			pauseBtn.addEventListener(Event.TRIGGERED,pauseBtnHandle);
			
			
			var uploadBtn:Button;
			uploadBtn = new Button();
			uploadBtn.label = "uploadMap";
			uiHolder.addChild(uploadBtn);
			uploadBtn.x = 1000;
			uploadBtn.addEventListener(Event.TRIGGERED,uploadBtnHandle);
			
			
			var uploadDataBtn:Button;
			uploadDataBtn = new Button;
			uploadDataBtn.label = "uploadRecord";
			uiHolder.addChild(uploadDataBtn);
			uploadDataBtn.x = 1100;
			uploadDataBtn.addEventListener(Event.TRIGGERED,uploadRecordBtnHandle);*/
			
			var bmf:BitmapFont = new BitmapFont(Assets.getTexture("en35BS"),Assets.store["en35BSXML"]);
			starling.text.TextField.registerBitmapFont(bmf,"en35BS");
			
			guid = new GuideRunner("guider");
			facade.registerMediator(guid);
			
			startBtn = new starling.display.Button(Assets.getRunnerGameTexture("startBtn"));
			startBtn.addEventListener(Event.TRIGGERED,startBtnHandle);
			startBtn.pivotX = startBtn.width*0.5;
			startBtn.pivotY = startBtn.height*0.5 +100;
			
			startUIHolder = new Sprite;
			
			runTimeLabel = new TextField(100,80,"","HuaKanT",68,0xffffff);
			runTimeLabel.x = 290;
			runTimeLabel.y = 0;
			runTimeLabel.nativeFilters = [new DropShadowFilter(0,90,0x1b5a3f,1,4,4,6)];
			
			timesIcon = new Image(Assets.getRunnerGameTexture("starTime"));
			timesIcon.x = 260;
			timesIcon.y = 20;
			
			
			
			startUIHolder.addChild(timesIcon);
			startUIHolder.addChild(startBtn);
			startUIHolder.addChild(runTimeLabel);
			
			
			
			_fsm = new StateMachine();
			_fsm.addState(START,{enter:enterStart,exit:exitStart,from:[END]});
			_fsm.addState(PLAY,{enter:enterPlay,from:[START,END]});
			_fsm.addState(END,{enter:enterEnd,exit:exitEnd,from:[PLAYING]});
			_fsm.addState(PLAYING,{from:[PLAY,PAUSE]});
			_fsm.addState(PAUSE,{enter:enterPasue,exit:exitPasue,from:[PLAYING]});
			
			
			_fsm.initialState = START;
			
			pauseBtn = new starling.display.Button(Assets.getRunnerGameTexture("pause"));
			pauseBtn.x = 1200;
			pauseBtn.y = 20;
			pauseBtn.visible = false;
			pauseBtn.addEventListener(Event.TRIGGERED,pauseBtnHandle);
			view.addChild(pauseBtn);
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(RunnerGameAwardMediator,null,SwitchScreenType.SHOW,view));
			
			
			PackData.app.CmdIStr[0] = CmdStr.GET_PLAYER_DATA;
			PackData.app.CmdIStr[1] = Global.player.operId;
			PackData.app.CmdIStr[2] = RunnerGlobal.map;
			PackData.app.CmdInCnt = 3;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(PLAYER_SCORE_REC,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			
			showChartBtn = new starling.display.Button(Assets.getRunnerGameTexture("chartBtn"));
			showChartBtn.x = 140;
			showChartBtn.y = 18;
			showChartBtn.addEventListener(Event.TRIGGERED,showChartBtnHandle);
			view.addChild(showChartBtn);
			
			helpBtn = new starling.display.Button(Assets.getRunnerGameTexture("helpIcon"));
			helpBtn.x = 38;
			helpBtn.y = 18;
			helpBtn.addEventListener(Event.TRIGGERED,helpBtnHandle);
			view.addChild(helpBtn);
			
			
			bgMusic = new Sound();
			
			var file:File = Global.document.resolvePath(Global.localPath+"mp3/gameEff/stage.mp3");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			var byte:ByteArray = new ByteArray;
			fileStream.readBytes(byte);
			
			bgMusic.loadCompressedDataFromByteArray(byte,byte.length);
			byte.clear();
			byte.length = 0;
			fileStream.close();
			var soundTransf:SoundTransform = new SoundTransform(0.3);
			
			
			
			bgMusicChannel = bgMusic.play(0,int.MAX_VALUE,soundTransf);
			
			
			
			
			file = Global.document.resolvePath(Global.localPath+"mp3/gameEff/jump.mp3");
			fileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			fileStream.readBytes(byte);
			
			jumpEff = new Sound();
			jumpEff.loadCompressedDataFromByteArray(byte,byte.length);
			byte.clear();
			byte.length = 0;
			fileStream.close();
			
			levelStage = new LevelStage;
			
			var cloudHolder:Sprite = new Sprite;
			view.addChild(cloudHolder);
			
			
			player.jumpSound = jumpEff;
			
			/*label = new TextField(200,60,"");
			label.x = 1000;
			label.y = 50;
			view.addChild(label);*/
			
			
			cloudProxy = new RunnerCloudProxy;
			facade.registerProxy(cloudProxy);
			cloudProxy.holder = view;
			cloudProxy.start();
			
		}
		
		private function enterPasue(event:StateMachineEvent):void{
			runEnterFrames = false;
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
			Starling.juggler.remove(RunnerGlobal.juggler);
			currentPlayer.stop();
			pauseBtn.visible = false;
			
			view.addChild(startBtn);
			
		}
		
		private function exitPasue(event:StateMachineEvent):void{
			pauseBtn.visible = true;
			runEnterFrames = true;
			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			Starling.juggler.add(RunnerGlobal.juggler);
			currentPlayer.start();
			startUIHolder.addChild(startBtn);
		}
		
		private function showChartBtnHandle():void{
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RunnerGameChartMediator,null,SwitchScreenType.SHOW,null)]);
			
		}
		
		private function helpBtnHandle():void{
			
			alert = Alert.show( "快乐跑酷规则:\n\n" +
				"1、人物自动往前跑，点击屏幕跳起躲开障碍物.\n" +
				"2、人物下降中，可再次点击屏幕实现\"连跳\".\n" +
				"3、跑得距离越远，跑得越快，要小心哦。\n\n\n" +
				"4、周一中午十二点会发放奖励给（男女组）前10名的同学哦，排名越前奖励越丰厚，为钻石狂奔吧！！！！！",
				
				"规则说明", new ListCollection(
					[
						{ label: "我知道了"},
					]));
			
		}
		
		private function startBtnHandle():void
		{
			
			if(_fsm.state==PAUSE){
				_fsm.changeState(PLAYING);
				return;
			}
			
			if(RunnerGlobal.maxRunTime<=RunnerGlobal.runTime){
				
				alert = Alert.show( "今天的免费次数用完了，可以用"+RunnerGlobal.runCost+"个金币再来一局(当前剩余：  "+RunnerGlobal.gold+" 金币)", "温馨提示", new ListCollection(
					[
						{ label: "我钱多",triggered:requestStartGame},
						{ label: "还是算了",triggered:requestExit}
					]));
				
				
			}else{
				requestStartGame();
			}
			
		}
		
		private function requestStartGame():void{
			PackData.app.CmdIStr[0] = CmdStr.START_RUN;
			PackData.app.CmdIStr[1] = Global.player.operId;
			PackData.app.CmdIStr[2] = RunnerGlobal.version;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(START_RUN_REC,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		
		private function requestExit():void{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		
		private function exitStart(event:StateMachineEvent):void{
			startUIHolder.removeFromParent();
			
		}
		
		private function enterPlay(event:StateMachineEvent):void{
			
			isGuide = false;
			pauseBtn.visible = true;
			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			currentPlayer = player;
			currentPlayer.start();
			runnerHolder.addChild(currentPlayer.view);
			runnerHolder.sortChildren(compareLand);
			restart();
			
			
		}
		
		
		
		private function enterEnd(event:StateMachineEvent):void{
			pauseBtn.visible = false;
			gameEnd();
			
			sendNotification(RunnerGameConst.SHOW_REWARD,new RunnerAwardVO(RunnerGlobal.distance,RunnerGlobal.maxDistance));
			
		}
		
		private function exitEnd(event:StateMachineEvent):void{
			startUIHolder.removeFromParent();
			
		}
		
		
		
		private function enterStart(event:StateMachineEvent):void{
			uiHolder.addChild(startUIHolder);
			startBtn.x = view.stage.stageWidth*0.5;
			startBtn.y = view.stage.stageHeight*0.5;
			guide();
			readBtnHandle();
		}
		
		private function guide():void{
			isGuide = true;
			if(currentPlayer){
				currentPlayer.view.removeFromParent();
				currentPlayer.stop();
			}
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
			currentPlayer = guid;
			currentPlayer.start();
			
			
		}
		
		
		
		
		private function uploadRecordBtnHandle():void
		{
			var liveRecorder:RunnerRecorder = liveRecord;
			PackData.app.CmdIStr[0] = CmdStr.INS_RUN_DATA;
			PackData.app.CmdIStr[1] = Global.player.operId;
			PackData.app.CmdIStr[2] = Global.player.realName;
			PackData.app.CmdIStr[3] = RunnerGlobal.map;
			PackData.app.CmdIStr[4] = RunnerGlobal.distance.toString();
			PackData.app.CmdIStr[5] = Global.myDressList;
			PackData.app.CmdIStr[6] = liveRecorder.data.join();
			trace("------------------------------------------");
			trace(PackData.app.CmdIStr[6]);
			PackData.app.CmdInCnt = 7;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPLOAD_RECORD_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			
			
		}
		
		private function uploadBtnHandle():void
		{
			PackData.app.CmdIStr[0] = CmdStr.INS_UP_MAP;
			PackData.app.CmdIStr[1] = RunnerGlobal.map;
			PackData.app.CmdIStr[2] = gener.readMap().toString();
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPLOAD_MAP_COMPLETE));
			
			
			
		}
		
		private function pauseBtnHandle():void
		{
			_fsm.changeState(PAUSE);
			
		}
		
		private function rpBtnHandle():void
		{
			gener.save(gener.randomPiece());
		}
		
		private function callRunners():void{
			var tmpRecorder:RunnerRecorder = new RunnerRecorder("tempRecorder");
			for (var i:int = 0; i < 4; i++) 
			{
				var trunner:Runner = runnersPool.object;
				runners.push(trunner);
				trunner.view.y = trunner.land = 60+i*3;
				trunner.speed = RunnerGameConst.ORI_SPEED;
				trunner.start();
				trunner.position = trunner.offset = -400-Math.random()*150;
				
				trunner.ai.target = currentPlayer;
				trunner.ai.runner = trunner;
				trunner.data = tmpRecorder.read("runner/UserRunner"+(i+1)+".data");
				runnerHolder.addChild(trunner.view);
			}
		}
		
		private var runnerViewMap:Dictionary;
		private var mapData:Vector.<Number>;
		
		private function callRunner(name:String,dressList:String,_data:String):void{
			
			if(_data==""){
				trace("throw");
				return;
			}
			
			var trunner:Runner = runnersPool.object;
			runners.push(trunner);
			runnerViewMap[trunner.view] = trunner;
			trunner.view.y = trunner.land = 60+int(Math.random()*30);
			trunner.speed = _velocity.x;
			trunner.start();
			trunner.position = RunnerGlobal.distance-int(Math.random()*200)-800;
			trunner.ai.target = currentPlayer;
			trunner.ai.runner = trunner;
			var data:Vector.<int> = Vector.<int>(_data.split(","));
			if(data[data.length-1]!=OperType.DIE){
				data.push(data[data.length-2]);
				data.push(OperType.DIE);
			}
			
			
			
			for (var i:int = 0; i < data.length; i+=2) 
			{
				if(data[i]>RunnerGlobal.distance-800){
					break;
				}
			}
			if(i>2){
				trunner.currentIdx = i-2;
			}
			trace("callRunner",trunner.currentIdx);
			trunner.data = data;
			trunner.dressUp(dressList);
			trunner.name = name;
			runnerHolder.addChild(trunner.view);
			
			
			runnerHolder.sortChildren(compareLand);
			
			
		}
		
		
		private function compareLand(item1:starling.display.DisplayObject,item2:starling.display.DisplayObject):Number{
			
			
			if(!runnerViewMap[item1]||!runnerViewMap[item2]){
				return 0;
			}
			
			if(runnerViewMap[item1].land>runnerViewMap[item2].land){
				return 1;
			}else if(runnerViewMap[item1].land<runnerViewMap[item2].land){
				return -1;
			}else{
				return 0;
			}
			
		}
		
		
		
		
		
		
		private function readTrackBtnHandle():void
		{
			runner.reset();
			recorder.read();
			runner.position = currentPlayer.position-100;
			runner.data = recorder.data;
			
			for (var i:int = 0; i < runner.data.length; i+=2) 
			{
				if(runner.data[i]>=runner.position){
					break;
				}
			}
			
			runner.currentIdx = i-2;
			
			
		}
		
		private function goBtnHandle():void
		{
			var offset:int = currentPlayer.position -RunnerGlobal.distance;
			RunnerGlobal.distance = int(textInput.text);
			
			itemManger.recycleAll();
			camera.moveTo(RunnerGlobal.distance,cameraOffsetY,1,0,true);
			revive(offset);
			
			var liveRecorder:RunnerRecorder = liveRecord;
			
			
			for (var i:int = 0; i < liveRecorder.data.length; i+=2) 
			{
				if(liveRecorder.data[i]>currentPlayer.position){
					break;
				}
			}
			
			var delIdx:int = i-2>0?i-2:0;
			
			
			liveRecorder.data.splice(delIdx,liveRecorder.data.length-delIdx);
			
		}
		
		
		private function reviveBtnHandle(event:Event):void{
			var liveRecorder:RunnerRecorder = liveRecord;
			liveRecorder.data.splice(liveRecorder.data.length-2,2);
			
			revive(currentPlayer.position -RunnerGlobal.distance);
		}
		
		private function revive(offset:int):void{
			
			currentPlayer.reset();
			currentPlayer.position = RunnerGlobal.distance+offset;
			
			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			isEnd = false;
			runEnterFrames = true;
			
			
			
			
		}
		
		private function saveBtnHandle():void{
			
			liveRecord.save();
			
		}
		
		
		private function readBtnHandle():void{
			itemManger.recycleAll();
			itemManger.setItems(mapData);
		}
		
		
		
		private function genBtnhandle():void{
			gener.save(gener.mergeData());
		}
		
		
		public function restart():void{
			
			itemManger.recycleAll();
			camera.moveTo(0,cameraOffsetY,1,0,true);
			isEnd = false;
			_velocity.setTo(RunnerGameConst.ORI_SPEED,0,0);
			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			frontItem = null;
			recorder.reset();
			picker.reset();
//			runner.reset();
			
			for (var i:int = 0; i < runners.length; i++) 
			{
				runnersPool.object = runners[i];
			}
			runners.length = 0;
			
//			callRunners();
			
			
			liveRecord.reset();
			RunnerGlobal.distance = 0;
			currentPlayer.reset();
			currentPlayer.start();
			currentPlayer.speed = 4;
			runEnterFrames = true;
			_fsm.changeState(PLAYING);
			
			cloudProxy.restart();
		}
		
		
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject,TouchPhase.ENDED);
			if(touch&&touch.globalY>100){
				currentPlayer.jump();
			}
			
			
		}
		
		override public function advanceTime(time:Number):void
		{
			
			var runnerLen:int = runners.length;
			for (var i:int = 0; i < runnerLen; i++) 
			{
				if((runners[i].isEnd&&runners[i].position<camera.viewport.left-100)){
					runnersPool.object = runners[i];
					runnerLen--;
					runners.splice(i,1);
				}
			}
			
			if(runnerLen<MAX_RUNNER){
				
				var record:RunnerRecordVO = picker.getRecord();
				
				if(record){
					
					var found:Boolean;
					for (var j:int = 0; j < runnerLen; j++) 
					{
						if(runners[j].name==record.name){
							found = true;
							break;
						}
						
					}
					
					
					if(!found)
					callRunner(record.name,record.eqList,record.data);
				}
				
			}
			
			
			RunnerGlobal.distance+=_velocity.x;
			
			camera.moveTo(int(RunnerGlobal.distance),cameraOffsetY);
			
			
			
//			label.text = RunnerGlobal.distance.toString();
//			label2.text = camera.viewport.left.toString();
			
			
		}
		
		private function gameEnd():void{
			isEnd = true;
			
			runEnterFrames = false;
			
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
			camera.shake();
			
			
			if(RunnerGlobal.maxDistance<RunnerGlobal.distance){
				uploadRecordBtnHandle();
			}
			
			
		}
		
		
		
		private function updateBackground(e:CameraUpdateEvent):void{
			
			currentBackground.show(e.viewport);
			
			ground.show(e.viewport);
			frontGround.show(e.viewport);
			itemManger.show(e.viewport);
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_RUN_MAP;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdInCnt = 2;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(MAP_REC));
			
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			// TODO Auto Generated method stub
			return Sprite;
		}
		
	}
}