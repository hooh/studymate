package com.studyMate.module.game
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.DressRoomConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.model.vo.StudentInfoVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class DressRoomMediator extends ScreenBaseMediator
	{
		
		private var tree:Image;
		
		private var vo:SwitchScreenVO;
		private var stuInfoVo:StudentInfoVO = new StudentInfoVO();
		
		private var charater:ICharater;
		
		public function DressRoomMediator(viewComponent:Object=null){
			super(ModuleConst.DRESS_ROOM, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			getInfo();
		}
		

		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.HIDE_MAIN_MENU);

			var bg:Image = new Image(Assets.getTexture("dressRoomBg"));
			view.addChild(bg);
			
			createWindow();
			
			createHuman();
			
			var dressPanelSp:Sprite = new Sprite();
			dressPanelSp.y = 480;
			view.addChild(dressPanelSp);
			
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(SuitsPanelMediator,[charater],SwitchScreenType.SHOW,dressPanelSp)]);
		
		}
		private function createWindow():void{
			tree = new Image(Assets.getDressSeriesTexture("DressRoom/tree"));
			tree.pivotY = tree.height;
			tree.x = 70;
			tree.y = 65+tree.height;
			tree.rotation = -0.05;
			
			view.addChild(tree);
			TweenMax.to(tree,3,{rotation:0.1,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			var window:Image = new Image(Assets.getDressSeriesTexture("DressRoom/window"));
			window.x = 65;
			view.addChild(window);
			
		}
		private function createHuman():void{
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object;
			
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			
			charater.view.x = 660;
			charater.view.y = 358;
			charater.view.scaleX = 4;
			charater.view.scaleY = 4;
			charater.view.alpha = 1;
			view.addChild(charater.view);
			
			
			if(stuInfoVo.sex == "0"){
				charater.actor.getProfile().sex = "F";
				charater.sex = "F";
			}else{
				charater.actor.getProfile().sex = "M";
				charater.sex = "M";
			}
			
			
			//保存按钮
			var saveBtn:starling.display.Button = new starling.display.Button(Assets.getAtlas().getTexture("dressSaveBtn"));
			saveBtn.x = 610;
			saveBtn.y = 460;
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			view.addChild(saveBtn);
		}
		private function saveBtnHandle(event:Event):void{
	
			updateEquipToServer(GlobalModule.charaterUtils.getHumanDressList(charater));
			
		}
		private function updateEquipToServer(dressList:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UPDATE_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = dressList;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE));

		}

		private function getInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DressRoomConst.GET_STUDENT_INFO));
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case DressRoomConst.GET_STUDENT_INFO:
					if(!result.isErr){
						stuInfoVo.operId = PackData.app.CmdOStr[1];
						stuInfoVo.nickName = PackData.app.CmdOStr[4];
						stuInfoVo.realName = PackData.app.CmdOStr[5];
						stuInfoVo.smsTelNo = PackData.app.CmdOStr[6];
						stuInfoVo.birth = PackData.app.CmdOStr[13];
						stuInfoVo.mtomrrow = PackData.app.CmdOStr[14];
						stuInfoVo.qanswer1 = PackData.app.CmdOStr[15];
						stuInfoVo.lixiang = PackData.app.CmdOStr[16];
						stuInfoVo.aihao = PackData.app.CmdOStr[17];
						stuInfoVo.smile = PackData.app.CmdOStr[18];
						stuInfoVo.school = PackData.app.CmdOStr[19];
						stuInfoVo.sclass = PackData.app.CmdOStr[20];
						stuInfoVo.sex = PackData.app.CmdOStr[21];
						stuInfoVo.sign = PackData.app.CmdOStr[22];
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE:
					Global.myDressList = GlobalModule.charaterUtils.getHumanDressList(charater);
					
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.parent.parent,640,381,null,"温馨提醒：换装修改已保存！"));
					
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [DressRoomConst.GET_STUDENT_INFO,WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE];
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object = charater;
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			
			TweenLite.killTweensOf(tree);
			view.removeChildren(0,-1,true);
		}
	}
}