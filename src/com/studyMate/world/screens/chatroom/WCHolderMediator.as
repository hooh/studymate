package com.studyMate.world.screens.chatroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.world.component.sysface.ScrollTextExtends;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class WCHolderMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "WCHolderMediator";
		
		private var vo:SwitchScreenVO;
		
		private var showStr:String;
		private var doFun:Function;
		
		public function WCHolderMediator(viewComponent:Object=null){
			super(NAME, new Sprite);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			createWorldChatSp();
			
			
		}
		
		public var holder:Sprite;
		
		private var wchatTF:ScrollText;
		private var wcRecordStr:String = "";
		
		private var cwSp:Sprite;
		
		//左下角聊天显示框
		public function createWorldChatSp():void{
			cwSp = new Sprite;
			holder.addChild(cwSp);
			
			var cwbg:Image = new Image(Assets.getHappyIslandTexture("worldChatBg"));
			cwSp.addChild(cwbg);
			
			cwSp.y = 735 - cwSp.height;
			
			
			//滚动字幕
			wchatTF= new ScrollText();
			cwSp.addChild(wchatTF);
			wchatTF.width = 220;
			wchatTF.height = 100;
			wchatTF.x = 14;
//			wchatTF.y = 12;
			
			var dpi:Number = dpi = Capabilities.screenDPI;
			var stageWidth:Number = Global.stage.stageWidth;
			
			if(dpi>210 && stageWidth<2048){
				wchatTF.y = 62;
			}else{
				wchatTF.y = 12;
			}
			
			wchatTF.verticalScrollPosition = -30;
			wchatTF.embedFonts = true;
			wchatTF.textFormat = new TextFormat("HeiTi",14, 0x3a2002);
			
			
			cwSp.addEventListener(TouchEvent.TOUCH,cwSpHandle);
		}
		
		public function displayHolder(val:Boolean):void{
			if(wchatTF)
			{
//				wchatTF.visible = val;
				if(val && cwSp.getChildIndex(wchatTF) == -1){
					cwSp.addChild(wchatTF);
					
				}else if(!val){
					wchatTF.removeFromParent();
					
				}
				
				
			}
		}
		
		//设置广播面板
		public function setWChatText(_str:String):void{
			wcRecordStr += _str+"\n\n";
			
			
			if(wcRecordStr.length>500){
				wcRecordStr = wcRecordStr.substring(wcRecordStr.indexOf("\n\n")+1);
			}else
				wchatTF.verticalScrollPosition += 20;
			
			wchatTF.scrollToPageIndex(0,wchatTF.verticalScrollPosition+1,1);
			
			wchatTF.text = wcRecordStr;
			
		}
		
		
		private var beginY:Number;
		private var endY:Number;
		private function cwSpHandle(event:TouchEvent):void{
			
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.OPEN_MENU, new SwitchScreenVO(ChatRoomMediator,null,SwitchScreenType.SHOW));
					}
				}
			}
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				
			}
		}
		override public function listNotificationInterests():Array{
			return [];
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			wchatTF.removeFromParent(true);
			view.removeChildren(0, -1, true);
			holder.removeChildren(0, -1, true);
		}
	}
}