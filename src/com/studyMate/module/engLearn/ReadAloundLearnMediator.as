package com.studyMate.module.engLearn
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SoundGroup2Proxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.ui.AloundLearnItemRenderer;
	import com.studyMate.module.engLearn.ui.ListExtendEnableUI;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	
	/**
	 * 学习阶段 
	 * 2014-10-20上午11:55:00
	 * Author wt
	 *
	 */	
	
	public class ReadAloundLearnMediator extends EgLearnBaseMediator
	{
		public const NAME:String = 'ReadAloundLearnMediator';
		
		public static const CONFIRM_SUBMIT:String = NAME+ 'confirmSubmit';
		private const ABANDON_TASK_COMPLETE:String = NAME+ "AbandonTask";
		private const SUBMIT_TASK_COMPLETE:String = NAME + 'submitTask';

		private var dataVec:Vector.<ReadAloudVO>;
		private var prepareVO:SwitchScreenVO;	
		
		private var config:IConfigProxy;
		private var soundGroup:SoundGroup2Proxy;
		private var _viewEnable:Boolean;
		private var isChange:Boolean;
		private var _isPlaying:Boolean;
		private var _isRecording:Boolean;
		
		private var startTime:String;
		private var startSS:Number;
		private var costTime:String;
		private var rate:String='0';
		private var dataProvider:ListCollection;
		
		
		public function ReadAloundLearnMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void
		{			
			config = null;
			facade.removeProxy(SoundGroup2Proxy.NAME);
			super.onRemove();
		}
		override public function onRegister():void
		{
			super.onRegister();
			startTime = MyUtils.getTimeFormat();
			startSS = getTimer();
			
			view.recordUI.clear();
			soundGroup = new SoundGroup2Proxy();
			facade.registerProxy(soundGroup);
			
			//设定中文开关初始状态
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			if(CacheTool.has(NAME,'cnSwitch')){
				AloundLearnItemRenderer.showCn = CacheTool.getByKey(NAME,'cnSwitch') as Boolean;
				view.cnSwitch.isSelected = AloundLearnItemRenderer.showCn;
			}else{				
				var tmpString:String = config.getValueInUser("readAloudCnSwitch");
				if(tmpString == "true"){
					view.cnSwitch.isSelected = true;
				}else if(tmpString == "false"){
					view.cnSwitch.isSelected = false;
				}else{
					view.cnSwitch.isSelected = false;
					config.updateValueInUser("readAloudCnSwitch", false);
				}
				CacheTool.put(NAME,"cnSwitch",view.cnSwitch.isSelected);		
				AloundLearnItemRenderer.showCn = view.cnSwitch.isSelected;
			}
			
			//数据初始化
			dataProvider = new ListCollection();
			var obj:Object;
			for(var i:int=0;i<dataVec.length;i++){	//显示普通界面	
				obj = new Object();
				obj.vo = dataVec[i];
				obj.hasEnter = false;
				dataProvider.push(obj);
			}
			obj = new Object();
			obj.vo = dataVec;
			obj.hasEnter = false;
			dataProvider.push(obj);//增加汇总页面	
			
			obj = new Object();
			obj.vo = dataVec[0].LEA;
			obj.hasEnter = true;
			dataProvider.push(obj);//增加最后判断页面			
			view.list.dataProvider = dataProvider;
						
					
			(facade.retrieveMediator(ReadAloudBGMediator.NAME) as ReadAloudBGMediator).backHandle = function():void{
				var alertVO:AlertVo = new AlertVo("\n确定退出朗读任务吗？");
				alertVO.noBtn = true;
				alertVO.yesFun = abandonStateHandler;
				sendNotification(WorldConst.ALERT_SHOW,alertVO);//提交订单				
			};
			
			//初始化事件
			view.preBtn.addEventListener(Event.TRIGGERED,preHandler);
			view.nextBtn.addEventListener(Event.TRIGGERED,nextHandler);			
			view.list.addEventListener(Event.CHANGE,scrollChangeHandler);
			view.list.addEventListener(FeathersEventType.CREATION_COMPLETE,flatenHandler);
			view.list.addEventListener(FeathersEventType.SCROLL_START,scrollStartHandler);
			view.list.addEventListener(FeathersEventType.SCROLL_COMPLETE,scrollCompleteHandler);
			view.list.addEventListener(ListExtendEnableUI.ScrollPageEvent,scrollPageHandler);
			view.cnSwitch.addEventListener(Event.CHANGE,cnSwithHandler);
		}
		
	
		private function cnSwithHandler(e:Event):void{
			var boo:Boolean = view.cnSwitch.isSelected;
			AloundLearnItemRenderer.showCn = boo;
			config.updateValueInUser("readAloudCnSwitch", boo);
			CacheTool.put(NAME,'cnSwitch',boo);
			view.list.dataProvider.updateItemAt(0);
			view.list.dataProvider.updateItemAt(view.list.horizontalPageIndex);
			view.list.dataProvider.updateItemAt(view.list.horizontalPageIndex+1);
			view.list.dataProvider.updateItemAt(view.list.horizontalPageIndex-1);						
		}
		private function flatenHandler(e:Event):void
		{
			view.list.selectedIndex = 0;
			refreshViewHandler();
		}
		private function scrollChangeHandler(e:Event):void
		{
			isChange = true;
		}
		private function scrollStartHandler():void
		{
			viewEnable = false;
			view.list.isEnabled = false;
		}
		
		private function scrollCompleteHandler():void
		{
			viewEnable = true;
			view.list.isEnabled = true;
			if(isChange){
				isChange = false;
				refreshViewHandler();
			}				
			
		}
		private function preHandler():void{
			if(view.list.horizontalPageIndex>0){
				view.list.scrollToPageIndex(view.list.horizontalPageIndex-1,0.5);								
			}
		}
		private function nextHandler():void{
			if(view.list.horizontalPageIndex<view.list.dataProvider.length-1){
				view.list.scrollToPageIndex(view.list.horizontalPageIndex+1,0.5);	
			}
		}
		private function scrollPageHandler():void
		{
			soundGroup.stop();
			_isPlaying = false;
		}
		
		/**==========================状态机驱动逻辑↓========================== */				
		//刷新界面状态
		private function refreshViewHandler():void{
			trace('刷新界面!');
			
			if(view.list.horizontalPageIndex==0){
				view.preBtn.visible = false;
				view.nextBtn.visible = true;
			}else if(view.list.horizontalPageIndex==view.list.horizontalPageCount-1){
				view.nextBtn.visible = false;
				view.recordUI.visible = false;
			}else{
				view.recordUI.visible = true;
				view.preBtn.visible = true;
				view.nextBtn.visible = true;
			}			
			if(view.list.horizontalPageIndex!=view.list.horizontalPageCount-1){
				var obj:Object = this.dataProvider.getItemAt(view.list.selectedIndex);
				if(!obj.hasEnter){	
//					obj.hasEnter = true;
					viewEnable = false;
					sendNotification(LearnConst.SOUND_PLAY,obj.vo);
				}else{
					viewEnable = true;
				}
				view.recordUI.update(view.list.horizontalPageIndex.toString());
			}			
		}

		//提交结果
		private function submitStateHandler():void{
			if(!isSubmit){	
				view.touchGroup = false;
				isSubmit = true;
				viewEnable = false;
				submit(CmdStr.SUBMIT_YYDaily,SUBMIT_TASK_COMPLETE);
			}
		}
		//放弃任务
		private function abandonStateHandler():void{
			if(!isSubmit){	
				view.touchGroup = false;	
				isSubmit = true;
				viewEnable = false;
				submit(CmdStr.ANDON_YYDaily,ABANDON_TASK_COMPLETE);
			}
		}
		
		private function submit(cmd:String,recive:String):void{
			soundGroup.stop();
			_isPlaying = false;
			costTime = String(int((getTimer() - startSS)*0.001));
			var idArr:Array = [];
			for(var i:int=0;i<dataVec.length;i++){
				idArr.push(dataVec[i].rankid);
			}
			PackData.app.CmdIStr[0] = cmd;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = prepareVO.data.rrl;
			PackData.app.CmdIStr[3] = prepareVO.data.topic;
			PackData.app.CmdIStr[4] = costTime;//#学习时长(秒数)
			PackData.app.CmdIStr[5] = rate;///#学习结果正确率，取值0-100
			PackData.app.CmdIStr[6] = dataVec.length+1;//学习正确数
			PackData.app.CmdIStr[7] = '0';//学习错误数
			PackData.app.CmdIStr[8] = dataVec.length+1;//学习总数
			PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
			PackData.app.CmdIStr[10] = MyUtils.getTimeFormat();//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
			PackData.app.CmdIStr[11] = idArr.join(',');
			PackData.app.CmdInCnt =12;			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(recive));
		}
		/**==========================状态机驱动逻辑↑==========================*/		
		
		
		/**
		 *是否禁止屏幕点击 
		 */		
		private function set viewEnable(value):void{
			_viewEnable = value;
			if(value && !_isPlaying && !_isRecording){
				view.list.isEnabled = true;
				view.nextBtn.enabled = true;	
				view.preBtn.enabled = true;
				view.recordUI.touchable = true;
			}else{
				view.list.isEnabled = false;
				view.nextBtn.enabled = false;	
				view.preBtn.enabled = false;
//				view.recordUI.touchable = false;
			}
		}
		private function get viewEnable():Boolean{
			return _viewEnable;
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case LearnConst.SOUND_PLAY:
					_isPlaying = true;
					var soundVO:SoundVO;
					if(notification.getBody() is ReadAloudVO){
						var aloudVO:ReadAloudVO = notification.getBody() as ReadAloudVO;
						soundVO = new SoundVO(aloudVO.soundPath,aloudVO.starttime,aloudVO.durtime);
						soundGroup.play(soundVO);
					}else if(notification.getBody() is Vector.<ReadAloudVO>){
						var aloudVec:Vector.<ReadAloudVO> = notification.getBody() as Vector.<ReadAloudVO>;
						var  soundVec:Vector.<SoundVO> = new Vector.<SoundVO>;
						for(var i:int=0;i<aloudVec.length;i++){
							soundVO = new SoundVO(aloudVec[i].soundPath,aloudVec[i].starttime,aloudVec[i].durtime);
							soundVec.push(soundVO);
						}
						soundGroup.playVec(soundVec);
					}
					break;
				case LearnConst.SOUND_COMPLETE:
					var obj:Object = this.dataProvider.getItemAt(view.list.selectedIndex);
					if(!obj.hasEnter){
						obj.hasEnter = true;
						obj.effect = true;
						view.list.dataProvider.updateItemAt(view.list.horizontalPageIndex);
					}
					_isPlaying = false;
					viewEnable = true;
					break;				
				case SUBMIT_TASK_COMPLETE://提交成功
					trace('提交成功');
					trace(PackData.app.CmdOStr[0]);
					trace(PackData.app.CmdOStr[1]);					
					trace(PackData.app.CmdOStr[2]);
					trace(PackData.app.CmdOStr[3]);
					trace(PackData.app.CmdOStr[4]);
					sendNotification(WorldConst.UPDATE_TASK_DATA,new UpdateTaskDataVO('yy.D',prepareVO.data.rrl,'Z','100'));
					var result:DataResultVO = notification.getBody() as DataResultVO;
					if(!result.isErr){
						var rewardData:Object={};
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	_rrl=StringUtil.trim(_rrl);
						else	_rrl="";
						rewardData = {right:dataVec.length+1,wrong:0,time:costTime};
						var script:String = PackData.app.CmdOStr[3];
						rewardData.rrl = _rrl;						
						rewardData.gold = script;
						rewardData.oralid = PackData.app.CmdOStr[2];
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}else if(PackData.app.CmdOStr[0] == "EEE"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，朗读提交失败。请通过faq反馈我们.",false));//提交订单
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，返回数据出错。请通过faq反馈我们.",false));//提交订单
					}					
					break;
				case CONFIRM_SUBMIT:
					rate = notification.getBody() as String;
					submitStateHandler();
					break;
				case ABANDON_TASK_COMPLETE://放弃成功
					sendNotification(WorldConst.POP_SCREEN);	
					break;
				case LearnConst.RECORD_START://开始录音禁止滚动
					_isRecording = true;
					viewEnable = false;
					break;
				case LearnConst.RECORD_STOP://结束录音可以滚动
					_isRecording = false;
					viewEnable = true;
					break;
				case WorldConst.GET_SCREEN_FAQ:
					if(view.list.horizontalPageIndex<dataVec.length){						
						var str1:String = "朗读界面/LEA:"+prepareVO.data.LEA+",topic:"+prepareVO.data.topic+",id:"+dataVec[view.list.horizontalPageIndex].rankid;
					}else{
						var idArr:Array = [];
						for(var j:int=0;j<dataVec.length;j++){
							idArr.push(dataVec[j].rankid);
						}
						str1 = "朗读界面/LEA:"+prepareVO.data.LEA+",topic:"+prepareVO.data.topic+",组合句:"+idArr.join(',');
					}
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;
				case LearnConst.RESET_LEARN:
					view.list.scrollToPageIndex(0,0,0);
					refreshViewHandler();
					break;
				case CoreConst.DEACTIVATE:
					soundGroup.stop();
					_isPlaying = false;
					viewEnable = true;
					break;
					
			}
		}
		override public function listNotificationInterests():Array
		{
			return [LearnConst.SOUND_PLAY,LearnConst.SOUND_COMPLETE,CONFIRM_SUBMIT,LearnConst.RECORD_STOP,WorldConst.GET_SCREEN_FAQ,
				SUBMIT_TASK_COMPLETE,LearnConst.RECORD_START,ABANDON_TASK_COMPLETE,LearnConst.RESET_LEARN,CoreConst.DEACTIVATE];
		}
		override public function get viewClass():Class
		{
			return ReadAloundLearnView;
		}
		
		public function get view():ReadAloundLearnView{
			return getViewComponent() as ReadAloundLearnView;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			dataVec = prepareVO.data.dataVec;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
		}
	}
}