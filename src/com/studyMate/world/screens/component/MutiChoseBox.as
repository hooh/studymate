package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MutiChoseBox extends Sprite
	{	
		private var chanelBg:Scale9Image;
		private var btnSp:Sprite = new Sprite;
		
		public function MutiChoseBox()
		{
			super();
			
			initBoxBg();
			
			initBtnSp();
		}
		
		private function initBoxBg():void{
			var chanelBgTexture:Scale9Textures = 
				new Scale9Textures(Assets.getChatViewTexture("channelBg"),new Rectangle(0,14,80,2));
			
			chanelBg = new Scale9Image(chanelBgTexture);
			chanelBg.y = 49;
			addChild(chanelBg);
		}
		
		private function initBtnSp():void{
			btnSp.x = 4;
			btnSp.y = 7;
			addChild(btnSp);
			
			var ACbtn:Button = new Button(Assets.getChatViewTexture("channel_AC_Btn"));
			ACbtn.name = "AC";
			btnSp.addChild(ACbtn);
			ACbtn.addEventListener(Event.TRIGGERED,chanelBtnHandle);
			
			var WCbtn:Button = new Button(Assets.getChatViewTexture("channel_WC_Btn"));
			WCbtn.name = "WC";
			WCbtn.y = ACbtn.height+7;
			btnSp.addChild(WCbtn);
			WCbtn.addEventListener(Event.TRIGGERED,chanelBtnHandle);
			
			var PCbtn:Button = new Button(Assets.getChatViewTexture("channel_PC_Btn"));
			PCbtn.name = "PC";
			PCbtn.y = WCbtn.y+WCbtn.height+7;
			btnSp.addChild(PCbtn);
			PCbtn.addEventListener(Event.TRIGGERED,chanelBtnHandle);
			
			
			btnSp.clipRect = new Rectangle(0,56,80,34);
			
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,hideBox);
		}
		
		private var isShow:Boolean;
		private function chanelBtnHandle(e:Event):void{
//			trace((e.currentTarget as DisplayObject).name);
			
			//显示
			if(!isShow){
				TweenLite.to(chanelBg,0.3,{height:83,y:0});
				TweenLite.to(btnSp.clipRect,0.3,{y:0,height:83});
				
				//广播消息，打开多选框
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.MUTI_CHOSE_REMIND,true);
				
			}else{
				//隐藏
				TweenLite.to(chanelBg,0.3,{height:34,y:49});
				TweenLite.to(btnSp.clipRect,0.3,{y:56,height:34});
				
				
				setBtnLocation((e.currentTarget as DisplayObject).name);
				
				//广播消息，隐藏多选框
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.MUTI_CHOSE_REMIND,false);
			}
			isShow = !isShow;
		}
		
		
		/**
		 * 显示不同频道
		 * @param _btnName
		 * 
		 */		
		public function setBtnLocation(_btnName:String):void{
			
			var lvl:int = 0;
			
			for(var i:int=0;i<btnSp.numChildren;i++){
				//是该按钮，放到最下面
				if(btnSp.getChildAt(i).name == _btnName){
					btnSp.getChildAt(i).y = 54;
				
					Facade.getInstance(CoreConst.CORE).sendNotification(ChatViewMediator.CHANGE_CHANEL,_btnName);
				}else{
					btnSp.getChildAt(i).y = lvl*27;
					lvl++;
				}
			}
		}
		

		private function hideBox(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(!this.getBounds(Starling.current.stage).contains(touchPoint.globalX,touchPoint.globalY) &&isShow){ //主菜单区域
						//关闭
						TweenLite.to(chanelBg,0.3,{height:34,y:49});
						TweenLite.to(btnSp.clipRect,0.3,{y:56,height:34});
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.MUTI_CHOSE_REMIND,false);
						
						isShow = !isShow;
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,hideBox);
			
			removeChildren(0,-1,true);
			
			TweenLite.killTweensOf(chanelBg);
			TweenLite.killTweensOf(btnSp);
		}
	}
}