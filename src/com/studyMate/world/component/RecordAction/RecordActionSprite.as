package com.studyMate.world.component.RecordAction
{
	import com.greensock.TweenLite;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.DictionaryMediator;
	import com.studyMate.world.screens.FAQChatMediator;
	import com.studyMate.world.screens.FullScreenMenuMediator;
	import com.studyMate.world.screens.HonourViewMediator;
	import com.studyMate.world.screens.MonthTaskInfoMediator;
	import com.studyMate.world.screens.ShowProMediator;
	import com.studyMate.world.screens.SystemSetMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	import com.studyMate.world.screens.email.EmailViewMediator;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.BreakOpportunity;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	public class RecordActionSprite extends Mediator implements IMediator
	{
		public static const NAME:String = "RecordActionSprite";
		
		private var recordBtn:NormalButton;
		private var exitBtn:NormalButton;
		private var delayBtn:NormalButton;
		
		private var recordComponent:RecordComponent;
		
		public function RecordActionSprite(viewComponent:Object=null)
		{
			super(NAME, new Sprite);
			
		}
		
		override public function onRegister():void{
			Global.hadRecordView = true;
			recordComponent = new RecordComponent;
			
			
			view.graphics.beginFill(0x579aff,1);
			view.graphics.beginFill(0,1);
			view.graphics.drawRect(0,0,280,60);
			view.graphics.endFill();
			
			var tf1:TextFormat = new TextFormat("HeiTi",20,0,true);
			tf1.align = TextFormatAlign.CENTER;
			
			recordBtn = new NormalButton(65,30,0xff0000,0,tf1);
			recordBtn.label = "录制";
			recordBtn.x = 20;
			recordBtn.y = 15;
			recordBtn.addEventListener(MouseEvent.CLICK,recordHandle);
			view.addChild(recordBtn);
			
			delayBtn = new NormalButton(60,30,0xff0000,0,tf1);
			delayBtn.label = "+1s";
			delayBtn.x = 95;
			delayBtn.y = 15;
			delayBtn.addEventListener(MouseEvent.CLICK, delayBtnHandle);
			view.addChild(delayBtn);
			
			exitBtn = new NormalButton(65,30,0xff0000,0,tf1);
			exitBtn.label = "停止";
			exitBtn.x = 170;
			exitBtn.y = 15;
			exitBtn.addEventListener(MouseEvent.CLICK, exitBtnHandle);
			view.addChild(exitBtn);
			
//			recordBtn.enable = false;
//			exitBtn.enable = false;
			
			view.addEventListener(MouseEvent.MOUSE_DOWN, downHandle);
			view.addEventListener(MouseEvent.MOUSE_UP,upHandle);
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
			
			
		}
		
		
		
		
		
		
		
		
		private var recording:Boolean = false;
		private function recordHandle(e:MouseEvent):void{
			if(recording){
				//暂停
				recordBtn.label = "录制";
				recordComponent.stopRecord();
				recordComponent.moveFile(currentView);
				
			}else{
				//开始录制
				recordBtn.label = "暂停";
				recordComponent.startRecrod();
				
				
			}
			recording = !recording;
		}
		
		private function delayBtnHandle(e:MouseEvent):void{
			recordComponent.addDelay();
		}
		
		private function exitBtnHandle(e:MouseEvent):void{
			recordComponent.moveFile(currentView);
			Global.hadRecordView = false;
			
			
			facade.removeMediator(NAME);
			
			
		}
		
		
		
		
		
		
		
		
		private var spedgeX:Number;
		private var spedgeY:Number;
		private var doMove:Boolean = false;
		private function downHandle(e:MouseEvent):void{
			TweenLite.killTweensOf(view);
			
			spedgeX = e.stageX - view.x;
			spedgeY = e.stageY - view.y;
			
			doMove = true;
			
		}
		private function moveHandle(e:MouseEvent):void{
			if(doMove){
				
				view.x = e.stageX - spedgeX;
				view.y = e.stageY - spedgeY;
			}
		}
		private function upHandle(e:MouseEvent):void{
			if(doMove){
				var endX:Number = e.stageX - spedgeX;
				var endY:Number = 0;
				
				if(endX < 0){
					endX = 0;
				}
				if(endX > (1280-view.width)){
					endX = 1280-view.width;
				}
				
				
				TweenLite.to(view,0.2,{x:endX,y:endY});
				doMove = false;
				
			}
		}
		
		private var _currentView:String = "";
		private function get currentView():String{
			return _currentView;
		}
		private function set currentView(val:String):void{
			if(val == "CleanCpuMediator" || val == ""){val.split(".")
				return;
			}
			
			var newVal:String = "";
			var _tmparr:Array = val.split(".");
			if(_tmparr.length > 2){
				newVal = _tmparr[_tmparr.length-1];				
				
			}else{
				newVal = val;
				
			}
			
			if(newVal != currentView){
				//录入中，操作归档
				if(recording){
					
					recordComponent.moveFile(currentView);
				}
				
				
			}
			_currentView = newVal;
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.SWITCH_SCREEN_COMPLETE:
					
					trace("切换界面++++++++++++++++++++++++++++++++++++++++开始");
					var views:Vector.<SwitchScreenVO> = notification.getBody() as Vector.<SwitchScreenVO>;
					for (var i:int = 0; i < views.length; i++) 
					{
						trace("第"+i+"个："+views[i].mediatorName);
						currentView = views[i].mediatorName;
						
					}
					trace("切换界面========================================结束");
					
					
					
					break;
				case WorldConst.SWITCH_SCREEN:
					var _vo:SwitchScreenVO = notification.getBody() as SwitchScreenVO;
					if(notification.getBody() is Array){
						_vo = notification.getBody()[0] as SwitchScreenVO;
					}
					if(_vo && _vo.type == SwitchScreenType.SHOW){
						
						
						
						if(_vo && _vo.mediatorClass && _vo.mediatorClass.NAME){
							switch(_vo.mediatorClass.NAME){
								case FullScreenMenuMediator.NAME:
								case FAQChatMediator.NAME:
								case EmailViewMediator.NAME:
								case HonourViewMediator.NAME:
								case MonthTaskInfoMediator.NAME:
								case ShowProMediator.NAME:
								case DictionaryMediator.NAME:
								case SystemSetMediator.NAME:
								case ChatRoomMediator.NAME:
									currentView = _vo.mediatorClass.NAME;
									
									trace("进入这里录制======================================="+currentView);
									break;
								
							}
							
						}
						break;
					}
					
					if(_vo && _vo.type == SwitchScreenType.HIDE){
						
						switch(_vo.mediatorName){
							case FAQChatMediator.NAME:
								
								currentView = getScreen();
								trace("进入这里录制======================================="+currentView);
								break;
							case EmailViewMediator.NAME:
							case HonourViewMediator.NAME:
							case MonthTaskInfoMediator.NAME:
							case ShowProMediator.NAME:
							case DictionaryMediator.NAME:
							case SystemSetMediator.NAME:
								currentView = "FullScreenMenuMediator";
								
								trace("进入这里录制======================================="+currentView);
								
								break;
							case ChatRoomMediator.NAME:
								
								currentView = "FullScreenMenuMediator";
								if(menuClosed){
									currentView = getScreen();
								}
								menuClosed = false;
								trace("进入这里录制======================================="+currentView);
								
								break;
							
						}
						
						
					}
					
					
					
					
					break;
				case WorldConst.CLOSE_MENU:
					menuClosed = true;
					currentView = getScreen();
					trace("进入这里录制======================================="+currentView);
					
					break;
				case WorldConst.OPEN_MENU:
					menuClosed = false;
					
					break;
				
				//播放器特殊处理
				case MusicSoundMediator.SHOW_MUSIC:
					currentView = "MusicSoundMediator";
					
					break;
				
				//专门录像标记
				case WorldConst.RECORD_ACTION_FLAG:
					var _view:String = notification.getBody() as String;
					currentView = _view;
					
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.SWITCH_SCREEN_COMPLETE,WorldConst.SWITCH_SCREEN,
				MusicSoundMediator.SHOW_MUSIC,WorldConst.RECORD_ACTION_FLAG,
				WorldConst.CLOSE_MENU,WorldConst.OPEN_MENU];
		}
		
		private var menuClosed:Boolean = true;
		
		
		private function getScreen():String{
			if(Facade.getInstance(CoreConst.CORE).hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)
				&&(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen){
				return (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName();
			}
			return "tmp"+(new Date);
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRemove():void{
			
			TweenLite.killTweensOf(view);
			
			if(recordBtn){
				recordBtn.removeEventListener(MouseEvent.CLICK,recordHandle);
			}
			if(exitBtn){
				exitBtn.removeEventListener(MouseEvent.CLICK, exitBtnHandle);
			}
			if(Global.stage){
				Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
			}
			view.removeEventListener(MouseEvent.MOUSE_DOWN,downHandle);
			view.removeEventListener(MouseEvent.MOUSE_UP,upHandle);
			
			recordComponent.dispose();
			
			
			view.removeChildren();
			if(view.parent && view.parent.contains(view)){
				
				view.parent.removeChild(view);
				
			}
		}
		
	}
}