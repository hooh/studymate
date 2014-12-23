package com.studyMate.world.component.weixin
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.weixin.interfaces.IVoiceInputView;
	
	import flash.filesystem.File;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 录音语音输入的类
	 * 支持pc录入，pc格式为MP3，android为amr
	 * @author wt
	 * 
	 */	
	internal class VoiceInputMediator extends Mediator
	{
		private var NAME:String ;
		private var initialization:Boolean;
		public static const UPLAOD_SPEECH:String = NAME+ 'UPLAOD_SPEECH';
		private const timeOut:int = 2000;//毫秒，聊天间隔，防止刷屏

		private var recordName:String = "";//文件名
		private var startTime:Number=0;//开始录音计时
		private var endTime:Number=0;//结束录音
		public var totalTime:String;//录音总时长
		private var tryListenMediator:ListenTestMeidator;
		
		public var core:String;
		
		public function VoiceInputMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			NAME = mediatorName;
			super(mediatorName, viewComponent);
		}
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(insertVoice);
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
			if(dropDown) {
				dropDown.removeFromParent(true);
				dropDown = null;
			}
			super.onRemove();			
			AMRMedia.getInstance().stopRecordAMR();
			TweenLite.killDelayedCallsTo(overtimeHandler);
			clearWinSounds();
			if(tryListenMediator){
				facade.removeMediator(tryListenMediator.getMediatorName());
				tryListenMediator = null
			}
//			AppLayoutUtils.gpuLayer.removeChild(view as DisplayObject,true);
			(view as DisplayObject).removeFromParent(true);
			TweenLite.killTweensOf(updateTimes);
		}
		
		override public function onRegister():void{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			view.core = core;
			if(!initialization){
				initialization = true;
				
				super.onRegister();
				AppLayoutUtils.gpuLayer.addChild(view as DisplayObject);
				if(view.recordDisplayObject)
					view.recordDisplayObject.addEventListener(TouchEvent.TOUCH,startRecorHandler);
				if(view.switchTextInputDisplayObject)
					view.switchTextInputDisplayObject.addEventListener(TouchEvent.TOUCH,changeInputHandler);
				if(view.addDropdownDisplayobject){
					view.addDropdownDisplayobject.addEventListener(TouchEvent.TOUCH,addDropDownHandler);
				}
				clearWinSounds();
			}
		}
		
		private var dropDown:DropDownComponent;
		private function addDropDownHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if (touch.phase == TouchPhase.ENDED){
					if(dropDown==null){
						dropDown = new DropDownComponent();
						dropDown.core = core;
						view.dropDownViewDisplayobject = dropDown;
					}				
					view.dropdownState();
				}
			}
		}
		
		private function changeInputHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if (touch.phase == TouchPhase.ENDED){
					Facade.getInstance(core).sendNotification(SpeechConst.USE_WRITE_OPERATE);
				}
			}
		}
		
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case UPLAOD_SPEECH:
					endRecord();
					break;
				case CoreConst.DEACTIVATE:
					if(Global.OS == OSType.WIN){	
						startTime = getTimer();
					}else{						
						AMRMedia.getInstance().stopRecordAMR();
					}
					break;
				case SpeechConst.FILE_DOWNCOMPLETE_STATE:
					if(Global.OS == OSType.WIN){	
						clearWinSounds();
						Facade.getInstance(core).sendNotification(SpeechConst.RECOVER_AMR_SOUND);
					}
					break;
				
			
			}
		}
		override public function listNotificationInterests():Array{
			return [UPLAOD_SPEECH,CoreConst.DEACTIVATE,SpeechConst.FILE_DOWNCOMPLETE_STATE];
		}
		
		
		
		private function overtimeHandler():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO('录音时长请尽量不要超出半分钟'));
		}
		
		
		private function startRecorHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(Global.OS == OSType.WIN){
					winPlatform(touch);
				}else{
					andPlatform(touch);
				}
			}
		}
		
		/**------------------------------------windows平台----------------------------*/
		//启动录音文件必备的文件
		private var winRecordFile:File = Global.document.resolvePath(Global.localPath+'startRecord.edu');
		private function winPlatform(touch:Touch):void{
			if (touch.phase == TouchPhase.ENDED){
				var file:File = this.winSoundFile;
				if(file==null){
					Facade.getInstance(core).sendNotification(SpeechConst.STOP_AMR_SOUND);
					if(winRecordFile.exists)
						winRecordFile.openWithDefaultApplication();
				}else{
					if(file.exists){
						Facade.getInstance(core).sendNotification(SpeechConst.RECOVER_AMR_SOUND);
						if(file.size<100){
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO('您录音时长太短啦...'));
						}else{
							try{
								recordName = PackData.app.head.dwOperID.toString()+Global.nowDate.time+'.mp3';							
								var destination:File = Global.document.resolvePath( 'mp3recorder/'+recordName);
								file.moveTo(destination,true);								
								insertVoice(destination);
							}catch(e:Error){
								recordName = file.name;
								insertVoice(file);
							}
						}
					}else{
						Facade.getInstance(core).sendNotification(SpeechConst.STOP_AMR_SOUND);
						if(winRecordFile.exists)
							winRecordFile.openWithDefaultApplication();
					}
				}
				
			}
		}
		
		/**------------------------------------安卓平台----------------------------*/
		private function andPlatform(touch:Touch):void{
			if (touch.phase == TouchPhase.BEGAN){
				Facade.getInstance(core).sendNotification(SpeechConst.STOP_AMR_SOUND);
				this.startRecord();
				view.startRecordState();
				
				TweenLite.delayedCall(40,overtimeHandler);
			}else if(touch.phase == TouchPhase.ENDED){
				AMRMedia.getInstance().stopRecordAMR();
				if(view.recordDisplayObject.getBounds(Starling.current.stage).contains(touch.globalX,touch.globalY)){
					this.endRecord();
				}else if(view.startListenDisplayObject && view.startListenDisplayObject.getBounds(Starling.current.stage).contains(touch.globalX,touch.globalY)){
					tryListenMediator = new ListenTestMeidator(null,new (VoicechatComponent.owner(core).configVoice.tryListenView));
					tryListenMediator.recordName = recordName;
					tryListenMediator.core = core;
					facade.registerMediator(tryListenMediator);
					endTime = getTimer();
				}else{
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO('取消发送当前语音'));
				}					
				view.endRecordState();					
				Facade.getInstance(core).sendNotification(SpeechConst.RECOVER_AMR_SOUND);
				TweenLite.killDelayedCallsTo(overtimeHandler);
			}
		}	
		private function startRecord():void{
			recordName ='/'+ PackData.app.head.dwOperID.toString()+Global.nowDate.time+'.amr';
			AMRMedia.getInstance().RecordAMR( VoicechatComponent.owner(core).localFile(recordName).nativePath);
			startTime = getTimer();
		}		
		private function endRecord():void{
			var file:File = VoicechatComponent.owner(core).localFile(recordName);
			if(file.exists){
				if(file.size<100){
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO('您录音时长太短啦'));
				}else{			
					insertVoice(file);									
				}
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO('录音失败'));
			}
		}
		/**------------------------------------分割线----------------------------------*/
		
		
		private var talkTimes:int = 3; //说话次数，防刷屏
		private function updateTimes():void{
			
			if(talkTimes < 3 && talkTimes >= 0){
				talkTimes++;
				
				if(talkTimes != 3){
					TweenLite.delayedCall(3,updateTimes);
				}
			}
		}
		
		private var preTime:int;
		private function insertVoice(file:File):void{
			TweenLite.killTweensOf(insertVoice);
			//有发言次数，才能发言
			if(talkTimes > 0){
				talkTimes--;
				TweenLite.killTweensOf(updateTimes);
				
				if(talkTimes == 0){
					//刷屏，导致次数为0 ,惩罚至9秒加会次数1
					TweenLite.delayedCall(6,updateTimes);
					
				}else{
					TweenLite.delayedCall(3,updateTimes);
				}
				
				if(endTime!=0){
					totalTime = int((endTime - startTime)/1000).toString();
					endTime = 0;
				}else{					
					totalTime =  int((getTimer() - startTime)/1000).toString();
				}
				if(Global.isLoading){
					TweenLite.delayedCall(1,insertVoice,[file]);
					return;
				}
				var obj:* = VoicechatComponent.owner(core).configVoice.inserVoiceFun.apply(null,[file,totalTime]);
				if(obj)
				{
					VoicechatComponent.owner(core).addMsgItem(obj);
				}
				
			}else{
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("发送消息太快了,送消息的快递员很忙哦"));
				
			}
			
			
			/*if(getTimer()-preTime<timeOut){		
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("发送消息太快了,送消息的快递员很忙哦"));
			}else{
				preTime = getTimer();
				if(endTime!=0){
					totalTime = int((endTime - startTime)/1000).toString();
					endTime = 0;
				}else{					
					totalTime =  int((getTimer() - startTime)/1000).toString();
				}
				var obj:* = VoicechatComponent.owner(core).configVoice.inserVoiceFun.apply(null,[file,totalTime]);
				if(obj)
				{
					VoicechatComponent.owner(core).addMsgItem(obj);
				}
			}*/
		}
		
		//清理掉windows下的录音文件
		private function clearWinSounds():void{
			if(Global.OS == OSType.WIN){	
				var directory:File = Global.document.resolvePath('mp3recorder');
				if(directory.exists){
					try{
						if(directory.isDirectory){
							directory.deleteDirectory(true);
						}else{						
							directory.deleteFile();
						}
					}catch(e:Error){
						
					}					
				}
			}
		}
		
		private function get winSoundFile():File{
			var directory:File = Global.document.resolvePath( 'mp3recorder');
			if(directory.exists){
				var arr:Array = directory.getDirectoryListing();
				if(arr.length>0){
					arr.sort(compare,Array.CASEINSENSITIVE);//用户列表内的视频再按时间排序
					while(arr.length>1){
						if(arr[0].exists){
							if(arr[0].isDirectory){
								arr[0].deleteDirectory(true);
							}else{						
								arr[0].deleteFile();
							}
						}
						arr.shift();
					}
					return arr[arr.length-1]
				}else{
					return null;
				}
			}else{				
				return null;
			}
		}
		private function compare(a:File,b:File):Number{
			if(a.modificationDate.time>b.modificationDate.time){
				return 1;
			}else if(a.modificationDate.time==b.modificationDate.time){
				return 0;
			}else{
				return -1;
			}
		}

		public function get view():IVoiceInputView{
			return getViewComponent() as IVoiceInputView;
		}
	}
}