package com.studyMate.world.component.AndroidGame
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.AndroidGameShowMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.ProgressBar;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class MyGameItem extends Sprite
	{
		
		public var gameVo:AndroidGameVO;
		private var stateBtn:Button;
		private var iconsateSp:Sprite;
		
		private var delBtn:Button;
		private var proBar:ProgressBar;
		private var iconStateSp:MyGameIconStateSp;
		
		private var icon:Image;
		
		public function MyGameItem(_gameVo:AndroidGameVO)
		{
			
			gameVo = _gameVo;
			

			icon = new MyGameItemIcon(gameVo.bitmap,gameVo.gameName);
			addChild(icon);
			
			
			
			//下载、安装状态
			iconsateSp = new Sprite;
			iconsateSp.x = 24;
			addChild(iconsateSp);
			
			
			
			//删除那妞
			delBtn = new Button(Assets.getAndroidGameTexture("delBtn"));
			delBtn.x = 5;
			delBtn.y = -(delBtn.height>>1);
			addChild(delBtn);
			delBtn.visible = false;
			delBtn.addEventListener(Event.TRIGGERED,applyDel);
			
			//下载、安装按钮
			updateItemState(gameVo.state);
		}
		
		public function showDelBtn(_isshow:Boolean):void{
			//如果是系统应用则，不可以删除
			if(gameVo.type != "SYS")
				delBtn.visible = _isshow;
			
		}
		private function applyDel():void{
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(stage,640,381,doApply,"确定要卸载和删除 \""+gameVo.gameName+" \" 吗？"));
			
			
		}
		private function doApply():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(AndroidGameShowMediator.APPLE_DEL,this);
		}
		

		
		public function updateItemState(_state:String):void{
			if(stateBtn){
				stateBtn.removeEventListener(Event.TRIGGERED,stateBtnHandle);
				stateBtn.removeFromParent(true);
			}
			icon.removeEventListener(TouchEvent.TOUCH,itemClickHandle);
			
			//更新item状态
			gameVo.state = _state;
			
			var stateBtnTexture:Texture;
			if(_state == "down")
				stateBtnTexture = Assets.getAndroidGameTexture("downloadBtn");
			else if(_state == "install")
				stateBtnTexture = Assets.getAndroidGameTexture("installBtn");
			else if(_state == "play"){
				
				icon.addEventListener(TouchEvent.TOUCH,itemClickHandle);
				
				
				
			}
			
			
			
			
			
			if(stateBtnTexture){
				stateBtn = new Button(stateBtnTexture);
				stateBtn.x = (this.width - stateBtn.width)>>1;
				stateBtn.y = this.height;
				addChild(stateBtn);
				stateBtn.addEventListener(Event.TRIGGERED,stateBtnHandle);
			}
			
		}

		private var beginX:Number;
		private var endX:Number;
		private function itemClickHandle(event:TouchEvent):void{
			var item:Image = event.currentTarget as Image;
			var touchPoint:Touch = event.getTouch(item);
			
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						//点击
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
						Facade.getInstance(CoreConst.CORE).sendNotification(AndroidGameShowMediator.APPLY_PLAY_GAME,this);
						
						
					}
				}
			}
			
		}
		
		
		
		
		public function updateStateBtn(_isEnable:Boolean=true):void{
			if(stateBtn){
				stateBtn.enabled = _isEnable;
			
			}
		}
		
		public var myIconSp:MyGameIconStateSp;
		private function stateBtnHandle():void{
			
//			delBtn.visible = !delBtn.visible;
			
			
			
			
			iconsateSp.removeChildren(0,-1,true);
			updateStateBtn(false);
			
			myIconSp = new MyGameIconStateSp(gameVo);
			iconsateSp.addChild(myIconSp);

			
			
			
			
		}
		
		
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			if(stateBtn)
				stateBtn.removeEventListener(Event.TRIGGERED,stateBtnHandle);
			icon.removeEventListener(TouchEvent.TOUCH,itemClickHandle);
			
			removeChildren(0,-1,true);
		}
	}
}