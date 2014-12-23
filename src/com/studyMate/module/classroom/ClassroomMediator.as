package com.studyMate.module.classroom
{
	import com.edu.Dialog.NativeAlertDialog;
	import com.edu.Dialog.events.NativeDialogEvent;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.p2p.P2pProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.DefaultBeatCommand;
	import com.studyMate.world.screens.Const;
	import com.studyMate.world.screens.DictionaryMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 辅导教室首页主面板
	 * @author wt
	 * 
	 */	
	public class ClassroomMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'ClassroomMediator';
				
		private var croomVO:CroomVO;		
		private var dustbins:Button;//垃圾桶工具

//		private var beat_qid:String;		//题目id号
//		private var beat_msgId:int; 		//聊天索引
//		private var beat_userIds:String;	//用户id串
		
		public function ClassroomMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			croomVO = null;
			sendNotification(WorldConst.SHOW_NOTICE_BOARD);
			Starling.current.stage.removeChild(dustbins,true);
			DustbinManage.dispose();

			sendNotification(CoreConst.SET_BEAT_DUR, Const.DEFAULT_BEAT_DUR);
			Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,DefaultBeatCommand);//恢复默认心跳
			sendNotification(CoreConst.START_BEAT);
			CacheTool.clr(NAME,'crid');
			CacheTool.clr(NAME,'tid');
			
			facade.removeProxy(P2pProxy.NAME);

			super.onRemove();
		}
		override public function onRegister():void{
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			facade.registerProxy(new P2pProxy);
			
			var bg:Image = new Image(Assets.getCnClassroomTexture('exClassBg'));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);			
			
			
			if(croomVO.crstat=="U" || croomVO.crstat=="N"){
				CRoomConst.isComplete = false;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowDrawBoardMediator,null,SwitchScreenType.SHOW)]);//左侧习题界面.

			}else{
				CRoomConst.isComplete = true;
			}
						
			CacheTool.put(NAME,'crid',croomVO.crid);
			CacheTool.put(NAME,'tid',croomVO.tid);
			
			sendNotification(CoreConst.STOP_BEAT);
			//获取习题内容，并启动教室心跳
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExercisesLeftMediator,croomVO,SwitchScreenType.SHOW)]);//左侧习题界面.
			
			//右侧聊天内容。
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExerciseRightMediator,croomVO,SwitchScreenType.SHOW)]);//左侧习题界面.

			
			dustbins = new Button(Assets.getCnClassroomTexture("clearBtn"));
			dustbins.x = 645;
			dustbins.y = 14;
			dustbins.visible = false;
			Starling.current.stage.addChild(dustbins);
			dustbins.addEventListener(Event.TRIGGERED,dustbinHandler);
			
			
			backHandle = keybackHandle;
			
			
		}
		
		private function dustbinHandler():void
		{
			sendNotification(CRoomConst.CLEAR_DRAWBOARD);
			
			PackData.app.CmdIStr[0] = CmdStr.IN_CLASSROOM_MESSAGE;
			PackData.app.CmdIStr[1] =  CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			PackData.app.CmdIStr[2] = (facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).current_Qid;//题目标识
			PackData.app.CmdIStr[3] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[4] = Global.player.realName;
			PackData.app.CmdIStr[5] = 'write';
			PackData.app.CmdIStr[6] = 'C'; 								
			PackData.app.CmdIStr[7] = 'all';
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO('suiyi',null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		
		
		
		private function keybackHandle():void{	
			if(Global.OS ==OSType.ANDROID){				
				NativeAlertDialog.showAlert( "确定退出吗？" , "提示" ,  Vector.<String>(["YES","NO"]) ,
					function someAnswerFunction(event:NativeDialogEvent):void{
						if(event.index=='0'){
							sendNotification(WorldConst.POP_SCREEN);
						}
					});
			}else{
				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {	
				case CRoomConst.SHOW_DUSTBIN:
					dustbins.visible = true;
					break;
				case CRoomConst.HIDE_DUSTBIN:
					dustbins.visible = false;
					break;
				case WorldConst.DICTIONARY_SHOW://解决层级关系问题
					var dictionMediator:DictionaryMediator = Facade.getInstance(CoreConst.CORE).retrieveMediator(DictionaryMediator.NAME) as DictionaryMediator;
					if(dictionMediator){
						if(dictionMediator.view.parent){
							Global.stage.addChild(dictionMediator.view.parent.removeChild(dictionMediator.view));							
						}
					}
					break;
				
			}
		}
		
		
		override public function listNotificationInterests():Array{
			return [CRoomConst.SHOW_DUSTBIN,
					CRoomConst.HIDE_DUSTBIN,
					WorldConst.DICTIONARY_SHOW
			];
		}		
		
		


		
		override public function prepare(vo:SwitchScreenVO):void{	
			croomVO = vo.data as CroomVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}