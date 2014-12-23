package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.controller.vo.ScrollRadio;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.logic.AbstractBoidMediator;
	import com.mylib.game.house.House;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.TaskListManagementMediator;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.component.ButterflyMediator;
	import com.studyMate.world.screens.effects.WindFlower;
	import com.studyMate.world.screens.talkingbook.TalkingBookMediator;
	import com.studyMate.world.screens.wordcards.UnrememberWordCardMediator;
	
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PixelHitArea;
	import starling.extensions.PixelImageTouch;
	import starling.textures.Texture;
	
	public class EnglishIslandMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "EnglishIslandMediator";
		private var cloudRange01:Rectangle = new Rectangle(-740,-681,3300,100);
		private var cloudRange02:Rectangle = new Rectangle(-1640,-581,4000,100);
		
		private var camera:CameraSprite;
		
		private var _background:EnglishIslandBackground;
//		private var wave:EngIslandWave;
		
//		private var charaterHolder:Sprite;
		private var houseHolder:Sprite; //摆放building、tree和野人
		private var flowerHolder:Sprite;
		
//		private var isTap:Boolean;
		private var beginX:Number;
		private var endX:Number;
		
		private var windFlower:WindFlower;
		
//		private var passtime:Number;
		
//		private var p:Point;
//		private var walkRange:Rectangle;
//		private var touchBeginPoint:Point;
		
		
		private var taskNum_Word:int;	//学单词任务个数
		private var taskNum_Reading:int;	//阅读任务个数
		private var taskNum_Exercise:int;	//习题任务数
		private var taskNum_Oral:int;	//口语任务数
		
//		private var taskTips:TaskTips;
		private var taskListManagementMediator:TaskListManagementMediator;

		
		private var butterfly:AbstractBoidMediator;
		
		private var tvo:TransformVO;


		
//		private var touchBG:Quad;

		
		public function EnglishIslandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			var path:String = File.documentsDirectory.resolvePath(Global.localPath+"mp3/mainambient.mp3").url
//			SoundAS.loadSound(path,"mainambient");			
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(path,"mainambient"));
			
//			walkRange = new Rectangle(-500,160,2500,80);
			
//			p = new Point();
//			touchBeginPoint = new Point();
			var bg:Image = new Image(Assets.getTexture("engIslandBg01"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			_background = new EnglishIslandBackground();
			_background.touchable = false;
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			camera.addChild(_background);
			
			
			windFlower = new WindFlower;
//			windFlower.x = 400;
//			windFlower.y = 300;
			windFlower.y = -450;
			windFlower.touchable = false;
			camera.addChild(windFlower);
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			
			camera.moveTo(0, 0, 1, 0, false); //set a broader zoom (pull out slowly)
			
			var local:Point = new Point(0,0);
			var edge:Rectangle = new Rectangle(-1000,0,1000,0);
			tvo = new TransformVO(local,edge);
			
			tvo.radio = new ScrollRadio(0.5,0.5,0,0.1);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
			]);
			view.root.stage.color = 0xaea24e;
						
			houseHolder = new Sprite();
			camera.addChild(houseHolder);
			
			createHouse();
			
			
			
			
			flowerHolder = new Sprite();
			camera.addChild(flowerHolder);
			
//			charaterHolder = new Sprite();
//			camera.addChild(charaterHolder);
			
			
			var range:Rectangle = new Rectangle(-500,160,2500,80);;

			
			var i:int;

			
			var cloud01:Image =new Image(Assets.getAtlasTexture("bg/engIsland_cloud01"));
			var cloud02:Image =new Image(Assets.getAtlasTexture("bg/engIsland_cloud02"));
			
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud01,holder:camera,range:cloudRange01,randomAction:false});
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud02,holder:camera,range:cloudRange02,randomAction:false});

//			passtime = 0;
			runEnterFrames = true;
			
			
			createFlowers();

//			SoundAS.play("mainambient",0.4);
			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("mainambient",0.4));
			
			_background.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));

			
			butterfly = new ButterflyMediator("butterfly",camera);
			butterfly.start();
			
			
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);//隐藏公告栏

			
			var w:Number = view.stage.stageWidth;
			var h:Number = view.stage.stageHeight;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0xc6e5f5;
			
			var waterHeight:Number = h-80;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, h, waterColorBottom,0.5 );
			waterFill.addVertex(0, h, waterColorBottom,0.5 );
			waterFill.touchable = false;
			view.addChild(waterFill);
			
			var waterSurfaceThickness:Number = 20;
			var waterSurfaceStroke:Stroke = new Stroke();
			waterSurfaceStroke.material.vertexShader = new RippleVertexShader();
			for ( i = 0; i < 50; i++ )
			{
				var ratio:Number = i / 49;
				waterSurfaceStroke.addVertex( ratio * w, waterHeight - waterSurfaceThickness*0.25, waterSurfaceThickness, waterColorSurface, 0.8, waterColorTop, 0.3);
			}
			waterSurfaceStroke.touchable = false;
			view.addChild(waterSurfaceStroke);

			trace("@VIEW:EnglishIslandMediator:");
		}
		
		//初始化building、tree和野人
		private var flagInt:Number = 200;
		private function createHouse():void{
			var texture:Texture;
			var house:House; 
			var tree:House; //树和建筑物有通用性，暂时使用同一个类实现
			
			var hit_1:PixelHitArea = new PixelHitArea ( Assets.store["EnglishLandAtlasTexture"],0.5);
			var bg:PixelImageTouch;
			

				for(var k:int =0;k<2;k++){
					texture = Assets.getEgLandAtlasTexture("en_tree1");
					bg = new PixelImageTouch(texture,hit_1);
					//bg.hitArea= hit_1;
					tree = new House("en_tree1",bg,-200+k*500,130,false);
					houseHolder.addChild(tree);
					tree.touchable = false;
				}
				
				//朗读任务剩余个数提示
				if(Global.hasLogin)
					taskNum_Reading = taskListManagementMediator.getTodayUnfinishedTaskByStyle("yy.D");
				else
					taskNum_Reading = 0;
				texture = Assets.getEgLandAtlasTexture("aloundBtn");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("aloundBtn",bg,-900,210,true,taskNum_Reading.toString());
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				
				//学单词任务剩余个数提示
				if(Global.hasLogin)
					taskNum_Word = taskListManagementMediator.getTodayUnfinishedTaskByStyle("yy.W");
				else
					taskNum_Word = 0;
				//texture = Assets.getAtlasTexture("building/fruitTree01");
				texture = Assets.getEgLandAtlasTexture("house1");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("house1",bg,-513,200,true,taskNum_Word.toString());
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				texture = Assets.getEgLandAtlasTexture("house2");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("house2",bg,-40-flagInt,170,false);
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);

				//阅读任务剩余个数提示
				if(Global.hasLogin)
					taskNum_Reading = taskListManagementMediator.getTodayUnfinishedTaskByStyle("yy.R");
				else
					taskNum_Reading = 0;
				texture = Assets.getEgLandAtlasTexture("house3");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("house3",bg,200-flagInt,170,true,taskNum_Reading.toString());
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				//习题任务剩余个数提示
				if(Global.hasLogin)
					taskNum_Exercise = taskListManagementMediator.getTodayUnfinishedTaskByStyle("yy.E");
				else
					taskNum_Exercise = 0;
				texture = Assets.getEgLandAtlasTexture("ExerciseHouse");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("ExerciseHouse",bg,650-flagInt*2,170,true,taskNum_Exercise.toString());
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				
				//口语任务剩余个数提示
				if(Global.hasLogin)
					taskNum_Oral = taskListManagementMediator.getTodayUnfinishedTaskByStyle("@y.O");
				else
					taskNum_Oral = 0;
				texture = Assets.getEgLandAtlasTexture("OralHouse");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("OralHouse",bg,950-flagInt*2,170,true,taskNum_Oral.toString());
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				
				texture = Assets.getEgLandAtlasTexture("house6");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("house6",bg,1250-flagInt*2,170,false);
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				
				texture  = Assets.getEgLandAtlasTexture("house7");
				bg = new PixelImageTouch(texture,hit_1);
				house = new House("house7",bg,1650-flagInt*2,170,false);
				houseHolder.addChild(house);
				house.addEventListener(TouchEvent.TOUCH,houseTouchHandle);
				
				

				
				texture = Assets.getEgLandAtlasTexture("fish_desk");//鱼桌
				bg = new PixelImageTouch(texture,hit_1);
				houseHolder.addChild(bg);
				bg.x = 180;
				bg.y = 218;
				
			
		}
		
		private function createFlowers():void{
			var flowerImg:Image;
			for (var i:int = 0; i < 6; i++) 
			{
				flowerImg = new Image(Assets.getAtlasTexture("plant/flower"+int(Math.random()*4)));
				flowerImg.x = Math.random()*2000-600;
				flowerImg.y = 160+int(Math.random()*10);
				sendNotification(WorldConst.ADD_FLOWER_CONTROL,flowerImg);
				flowerHolder.addChild(flowerImg);
			}
		}

		

		
		private var isShow:Boolean;
		private function houseTouchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						var localX:int = (event.currentTarget as House).x;
						var localY:int = (event.currentTarget as House).y-(event.currentTarget as House).height-100;
						
//						if(!isShow){
//							isShow = true;
							switch((event.currentTarget as House).name){
								case "house1":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,fruitTree01EnterHandle,"杨记词海~背一组、再背一组、再再背一组。O(∩_∩)O~"));
									break;
								case "house2":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,shop02EnterHandle,"苏记书店，书中有黄金屋，书中有和田玉~O(∩_∩)O~"));
									break;
								case "house3":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,house01EnterHandle,"王记阅读，做英语领头羊，你可以！~O(∩_∩)O~"));
									break;
								case "ExerciseHouse":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,exerciseHouseEnterHandle,"来一道习题~O(∩_∩)O~"));
									break;
								case "OralHouse":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,oralHouseEnterHandler,"英语说一说，你今天说了吗？~O(∩_∩)O~"));
									break;
								case "house6":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,crHouseEnterHandler,"习题辅导教室，你今天约了老师吗？~O(∩_∩)O~"));
									break;
								case "house7":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,wrongHouseEnterHandler,"错词学习~O(∩_∩)O~"));
									break;
								case "aloundBtn":
									sendNotification(WorldConst.DIALOGBOX_SHOW,
										new DialogBoxShowCommandVO(camera,localX,localY,aloundHouseEnterHandler,"谢记朗读，拳不离手，曲不离口。读一读吧~O(∩_∩)O~"));
									break;
							}
//						}else isShow = false;
					}
				}
			}
		}
		
		private function aloundHouseEnterHandler():void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.D"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		private function wrongHouseEnterHandler():void
		{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UnrememberWordCardMediator)]);
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.WRONGWORD),new SwitchScreenVO(CleanCpuMediator)]);
		}
		private function crHouseEnterHandler():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ListClassRoomMediator)]);
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.CLASSROOM),new SwitchScreenVO(CleanCpuMediator)]);

		}
		
		
		//fruitTree01的"确定"按钮事件
		private function fruitTree01EnterHandle():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
		
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.W"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		//shop02的"确定"按钮事件
		private function shop02EnterHandle():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TalkingBookMediator),new SwitchScreenVO(CleanCpuMediator)]);

		}
		//house01的"确定"按钮时间
		private function house01EnterHandle():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
		
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.R"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		//exerciseHouse的"确定"按钮事件
		private function exerciseHouseEnterHandle():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListMediator,{taskStyle:"yy.E"}),new SwitchScreenVO(CleanCpuMediator)]);
		
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST,{taskStyle:"yy.E"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		//oralHouse确定事件
		private function oralHouseEnterHandler():void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TaskListSpokenMeidator,{taskStyle:"@y.O"}),new SwitchScreenVO(CleanCpuMediator)]);
		
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SWITCH_MODULE,
				[new SwitchScreenVO(ModuleConst.TASKLIST_SPOKEN,{taskStyle:"@y.O"}),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		override public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			super.advanceTime(time);
		}
		
		private function updateBackground(e:CameraUpdateEvent):void
		{
			_background.show(e.viewport);
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case WorldConst.UPDATE_CAMERA:
					
					if(camera){
						var local:Point = notification.getBody() as Point;
						camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,tvo.scale,0,false);
					}
					
					break;
				case WorldConst.UPDATE_TASK_NUM_COMPLETE:
					
					//取完未完成任务数。
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					
					break;

			}		
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.UPDATE_TASK_NUM_COMPLETE];
		}
		
		
		override public function onRemove():void
		{
			super.onRemove();
			Assets.disposeTexture("engIslandBg01");
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			
			_background.dispose();
			view.root.stage.color = 0xffffff;
			windFlower.dispose();
			camera.removeChildren(0,-1,true);
			camera.removeFromParent(true);


			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
			facade.removeMediator(MyCharaterControllerMediator.NAME);
			//bgSoundPlayer.onRemove();
//			SoundAS.removeSound("mainambient");
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'mainambient');
			
			
			butterfly.dispose();
			
			PixelHitArea.dispose();
		}
		
		private var vo:SwitchScreenVO;
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			taskListManagementMediator = Facade.getInstance(CoreConst.CORE).retrieveMediator(TaskListManagementMediator.NAME) as TaskListManagementMediator;
			
			taskListManagementMediator.getTaskNum();
			
			
		}
		
		override public function activate():void
		{
			super.activate();
			if(!facade.hasMediator(FreeScrollerMediator.NAME)){
				Global.isFirstSwitch = false;
				sendNotification(WorldConst.SWITCH_SCREEN,[
					new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
				]);
				
				Global.isFirstSwitch = true;
				
			}
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			facade.removeMediator(FreeScrollerMediator.NAME);
		}
		
		
		override public function get viewClass():Class
		{
			// TODO Auto Generated method stub
			return Sprite;
		}
		
	}
}