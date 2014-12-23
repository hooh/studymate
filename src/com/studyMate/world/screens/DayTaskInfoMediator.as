package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class DayTaskInfoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "DayTaskInfoMediator";
		public static const GETDEALTRNOTIFICATION:String = NAME + "Get_Dealtr";
		public static const GETTASKDETAIL:String = NAME + "GetTaskDetail";
		
		private var vo:SwitchScreenVO; 
		private var id:String;
		private var date:String;
		//private var monthArray:Array = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
		//private var dayArray:Array = ["一日","二日","三日","四日","五日","六日","七日","八日","九日","十日","十一日","十二日","十三日","十四日","十五日"
		//	,"十六日","十七日","十八日","十九日","二十日","二十一日","二十二日","二十三日","二十四日","二十五日","二十六日","二十七日","二十八日","二十九日","三十日","三十一日"];
		private var taskArray:Array;
		private var container:ScrollContainer; 
		private var layout:TiledRowsLayout;
		private var onTouchBeginY:int;
		private var onTouchEndY:int;
		private var backBtn:Button;
		
		private var quad:Quad;
		private var taskDetail:Sprite;
		
		public function DayTaskInfoMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
//			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			var data:Array = vo.data as Array;
			id = data[0];
			date = data[1];
			taskArray = new Array();
			PackData.app.CmdIStr[0] = CmdStr.QUERYLNDAYDETAIL;
			PackData.app.CmdIStr[1] = id;
			PackData.app.CmdIStr[2] = date;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GETDEALTRNOTIFICATION));
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		private var goldNum:int;
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;		
			switch(notification.getName()){
//				case 
				case GETDEALTRNOTIFICATION :
					if(!result.isEnd){
						var obj:Object = tranceRRL(PackData.app.CmdOStr[3]);
						if(obj.kemu != "Default" && obj.tixing != "Default"){
							taskArray.push({sid:PackData.app.CmdOStr[2].toString(), rrl:PackData.app.CmdOStr[3].toString(), 
								status:PackData.app.CmdOStr[4].toString(), fengshu:PackData.app.CmdOStr[5].toString(), 
								goldNum:PackData.app.CmdOStr[6].toString(), date:PackData.app.CmdOStr[7].toString(), 
								achieve:PackData.app.CmdOStr[8].toString(), rrlTrance:obj, recid:PackData.app.CmdOStr[1].toString()});
						}
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					}
					break;
				case "Hide_DayTaskInfoMediator" : 
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case GETTASKDETAIL : 
					if(!result.isErr){
						var listString:String = PackData.app.CmdOStr[8];
						var rrl:String = PackData.app.CmdOStr[4];
						var list:Array = dealTaskDetail(rrl, listString);
						if(list) showDetail(list);
						else{
							showingDetail = false;
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,647,352, null, "该任务为首次学习任务，系统默认全对，O(∩_∩)O哈哈~"));
						}
					}
					break;
			}
		}
		
		private function showDetail(listArray:Array):void{
			quad = new Quad(Global.stageWidth, Global.stageHeight, 0x000000);
			quad.alpha = 0.3;
			view.addChild(quad);
			taskDetail = new Sprite;
			var img:Image = new Image(Assets.getTexture("taskDetail"));
			taskDetail.addChild(img);
			view.addChild(taskDetail);
			taskDetail.x = ( Global.stageWidth - 705 ) / 2; taskDetail.y = ( Global.stageHeight - 501 ) / 2;
			
			var lay:TiledRowsLayout = new TiledRowsLayout();
			lay.paging = TiledRowsLayout.PAGING_NONE;
			lay.gap = 0;
			lay.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			lay.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			lay.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			lay.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			lay.useSquareTiles = false;
			
			var con:ScrollContainer = new ScrollContainer();
			con.layout = lay;
			con.snapScrollPositionsToPixels = true;
			con.snapToPages = false;
			con.x = 25; con.y = 174;
			con.width = 656; con.height = 287;
			taskDetail.addChild(con);
			
			var rightNum:int = 0;
			var wrongNum:int = 0;
			
			var spItem:Sprite;
			var q:Quad;
			var txtField:TextField;
			var color:int = 0xcd6f22;
			var sign:Image;
			for(var i:int = 0; i < listArray.length; i++){
				spItem = new Sprite;
				spItem.width = 656; spItem.height = 52;
				q = new Quad(656, 52, 0xFFFFFF);
				q.alpha = 0;
				spItem.addChild(q);
				
				if(listArray[i].judge == "R"){
					color = 0x198500;
					sign = new Image(Assets.getAtlasTexture("parents/rightSign"));
					rightNum++;
				}
				else if(listArray[i].judge == "E"){
					color = 0xff0000;
					sign = new Image(Assets.getAtlasTexture("parents/wrongSign"));
					wrongNum++;
				}
				else{
					color = 0xcd6f22;
					sign = null;
				}
				
				//添加题目标号
				txtField = new TextField(103,52,"","HeiTi",30,0xcd6f22);
				txtField.autoScale = true;
				txtField.text = String(((i+1) < 10) ? "0" : "") + (i+1);
				spItem.addChild(txtField);
				
				//添加用户答案
				txtField = new TextField(233,52,"","HeiTi",30,color);
				txtField.autoScale = true;
				txtField.text = listArray[i].userAnswer;
				txtField.x = 104;
				spItem.addChild(txtField);
				
				//添加标准答案
				txtField = new TextField(202,52,"","HeiTi",30,color);
				txtField.autoScale = true;
				txtField.text = listArray[i].answer;
				txtField.x = 338;
				spItem.addChild(txtField);
				
				if(sign){					
					sign.x = 573; sign.y = 10;
					spItem.addChild(sign);
				}
				
				con.addChild(spItem);
			}
			var rightTld:TextField = new TextField(120,52,"对"+rightNum.toString()+"个","HeiTi",25,0x198500);
			rightTld.autoScale = true;
			rightTld.x = 182; rightTld.y = 90;
			taskDetail.addChild(rightTld);
			var wrongTld:TextField = new TextField(120,52,"错"+wrongNum.toString()+"个","HeiTi",25,0xff0000);
			wrongTld.autoScale = true;
			wrongTld.x = 302; wrongTld.y = 90;
			taskDetail.addChild(wrongTld);
			var goldTld:TextField = new TextField(120,52,"获得"+goldNum.toString()+"金币","HeiTi",25,0xFBC926);
			goldTld.autoScale = true;
			goldTld.x = 422; goldTld.y = 90;
			taskDetail.addChild(goldTld);
			
			var texture:Texture = Assets.getAtlasTexture("parents/close");
			backBtn = new Button(texture);
			backBtn.x = 666; backBtn.y = 70;
			backBtn.addEventListener(Event.TRIGGERED, closeTaskDetal);
			taskDetail.addChild(backBtn);
		}
		
		private function closeTaskDetal(e:Event):void{
			taskDetail.removeChildren(0,1,true);
			taskDetail.dispose();
			view.removeChild(quad);
			view.removeChild(taskDetail);
			showingDetail = false;
		}
		
		private function dealTaskDetail(rrl:String, taskDetail:String):Array{
			var lastidx:int = taskDetail.lastIndexOf("<@A");
			var i:int = taskDetail.indexOf(">", lastidx);
			var lastflg:String = taskDetail.substring(lastidx, i+1);
			if(i + 1 == taskDetail.length) return null;
			var detail:String = taskDetail.substring(i+1, taskDetail.length);
			var ques:Array = detail.split('\n');
			var quesDetail:Array;
			var listArray:Array = new Array;
			for(i = 0; i < ques.length; i++){
				if(ques[i] == "") continue;
				quesDetail = String(ques[i]).split('`');
				if(quesDetail.length < 5) continue;
				listArray.push({judge:quesDetail[2],userAnswer:quesDetail[3],answer:quesDetail[4]});
			}
			return listArray;
		}
		
		override public function listNotificationInterests():Array{
			return [GETDEALTRNOTIFICATION,"Hide_DayTaskInfoMediator",GETTASKDETAIL];
		}
		
		override public function onRegister():void{
			var img:Image = new Image(Assets.getTexture("dayinfo"));
			view.addChild(img);
			img.x = ( Global.stageWidth - 860 ) / 2; img.y = ( Global.stageHeight - 515 ) / 2;
			
			var mon:int = parseInt(date.substr(4,2));
			var day:int = parseInt(date.substr(6,2));
			var dateTextFld:TextField = new TextField(228, 60, mon + "月" + day + "日", "HeiTi", 50, 0x784700,true);
			dateTextFld.autoScale = true;
			view.addChild(dateTextFld);
//			dateTextFld.border = true;
			dateTextFld.x = 520; dateTextFld.y = 167;
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_NONE;
			layout.paddingBottom = 5; layout.paddingTop = 5;
			layout.paddingLeft = 18;
			layout.gap = 13;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = false;
			container.x = 252; container.y = 263;
			container.width = 813; container.height = 318;
			view.addChild(container);
			if(taskArray.length > 0){
				var kemu:TextField;
				var tixing:TextField;
				var bianhao:TextField;
				var tileImage:Image;
				var sp:Sprite;
				var score:int;
				for(var i:int = 0; i < taskArray.length; i++){
					sp = new Sprite();
					sp.name = i.toString();
					if(taskArray[i].status == "Y"){ //任务完成
						tileImage = new Image(Assets.getAtlasTexture("parents/usual"));
					}else if(taskArray[i].status == "U"){  //任务异常
						tileImage = new Image(Assets.getAtlasTexture("parents/unusual"));
					}else if(taskArray[i].status == "A"){  //放弃任务
						tileImage = new Image(Assets.getAtlasTexture("parents/unDo"));
					}else{  //任务未完成
						tileImage = new Image(Assets.getAtlasTexture("parents/unDo"));
					}
					sp.addChild(tileImage);
					
					kemu = new TextField(140,20,taskArray[i].rrlTrance.kemu,"HeiTi",18,0xdc6200,true);
					tixing = new TextField(160,50,taskArray[i].rrlTrance.tixing,"HeiTi",35,0x018093,true);
					bianhao = new TextField(150,20,taskArray[i].rrlTrance.bianhao,"HeiTi",18,0xdc6200,true);
					kemu.autoScale = true;
					tixing.autoScale = true;
					bianhao.autoScale = true;
					
					sp.addChild(kemu);
//					kemu.border = true;
					kemu.x = 15; kemu.y = 39;
					kemu.hAlign = HAlign.LEFT;
					
					sp.addChild(tixing);
//					tixing.border = true;
					tixing.x = 5; tixing.y = 62;
					
					sp.addChild(bianhao);
//					bianhao.border = true;
					bianhao.x = 8; bianhao.y = 39;
					bianhao.hAlign = HAlign.RIGHT;
					
					/*
					 * 缺素材，显示科目、题型*/
					
					score = parseInt(taskArray[i].achieve);
					var numStar:Number = MyUtils.getRewardStar(score);
					var star:Image;
					switch(numStar){
						case 3 : 
							drawStar(sp,"222");
							break;
						case 2.5 :
							drawStar(sp,"221");
							break;
						case 2 :
							drawStar(sp,"220");
							break;
						case 1.5 :
							drawStar(sp,"210");
							break;
						case 1 :
							drawStar(sp,"200");
							break;
						case 0.5 :
							drawStar(sp,"100");
							break;
						default : 
							drawStar(sp,"000");
							break;
					}
					
					sp.addEventListener(TouchEvent.TOUCH, taskTouchHandler);
					container.addChild(sp);
				}
			}
			
			var texture:Texture = Assets.getAtlasTexture("parents/back");
			backBtn = new Button(texture);
			backBtn.x = 587; backBtn.y = 600;
			backBtn.addEventListener(Event.TRIGGERED, backBtnTriggeredHandler);
			view.addChild(backBtn);
			
			sendNotification("Hide_MonthTaskInfoMediator");
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
//			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler,false,1);
		}
		
		protected function stageKeydownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}
		
		private function drawStar(stage:Sprite,sta:String):void{
			var star:Image;
			star = selectStar(sta.charAt(0));
			star.y = 116; star.x = 47;
			stage.addChild(star);
			star = selectStar(sta.charAt(1));
			star.y = 116; star.x = 47 + 28;
			stage.addChild(star);
			star = selectStar(sta.charAt(2));
			star.y = 116; star.x = 47 + 28 * 2;
			stage.addChild(star);
		}
		
		private function selectStar(sta:String):Image{
			if(sta == "2"){
				return (new Image(Assets.getAtlasTexture("parents/star")));
			}else if(sta == "1"){
				return (new Image(Assets.getAtlasTexture("parents/banStar")));
			}
			return (new Image(Assets.getAtlasTexture("parents/anStar")));
		}
		
		private function backBtnTriggeredHandler(e:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,id,SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer)]);
		}
		
		private var showingDetail:Boolean = false;
		
		private function taskTouchHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				onTouchBeginY = touch.globalY;
			}
			if(touch.phase == TouchPhase.ENDED){
				onTouchEndY = touch.globalY;
				if(Math.abs(onTouchBeginY - onTouchEndY) < 10){
					if(Global.isLoading){
						return;
					}
					if(showingDetail){
						return;
					}else{
						showingDetail = true;
					}
					var i:int = parseInt((e.currentTarget as DisplayObject).name);
					var recid:String = taskArray[i].recid;
					trace(recid);
					goldNum = taskArray[i].goldNum;
					PackData.app.CmdIStr[0] = CmdStr.SELECT_OPPROC;
					PackData.app.CmdIStr[1] = recid;
					PackData.app.CmdInCnt = 2;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(GETTASKDETAIL));
				}
			}
		}		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		public function tranceRRL(rrl:String):Object{
			var kemu:String;
			var tixing:String;
			var bianhao:String;
			var a:String = rrl.substr(0,4);
			switch(a){
				case "yy.W" : 
					kemu = "英语";
					tixing = "单词";
					break;
				case "yy.G" : 
					kemu = "英语";
					tixing = "语法";
					break;
				case "yy.P" : 
					kemu = "英语";
					tixing = "试卷";
					break;
				case "yy.L" : 
					kemu = "英语";
					tixing = "听力";
					break;
				case "yy.R" : 
					kemu = "英语";
					tixing = "阅读";
					break;
				case "yy.C" : 
					kemu = "英语";
					tixing = "写作";
					break;
				case "yy.@" : 
					kemu = "英语";
					tixing = "题目";
					break;
				case "yy.E" : 
					kemu = "英语";
					tixing = "习题";
					break;
				case "yy.P" : 
					kemu = "英语";
					tixing = "知识点";
					break;
				default : 
					kemu = "Default";
					tixing = "Default";
			}
			a = rrl.substr(5,rrl.length);
			if(a.substr(0,5) == "WRONG"){
				bianhao = "错题" + a.substr(6,a.length) + "组";
			}else{
				if(a.indexOf(".") != -1){
					bianhao = a.substr(0,a.indexOf(".")) + "级" + a.substr(3,a.length) + "组";
				}else{
					bianhao = a + "组";
				}
			}
			return {kemu:kemu, tixing:tixing, bianhao:bianhao};
		}
		
	}
}