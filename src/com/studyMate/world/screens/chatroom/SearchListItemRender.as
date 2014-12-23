package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Label;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SearchListItemRender extends BaseListItemRenderer
	{
		public function SearchListItemRender()
		{
			super();
		}
		
		private var bg:Image;
		private var bg2:Image;
		
		private var nameLabel:Label;
		private var schoolLabel:Label;
		private var sexLabel:Label;
		private var ageLabel:Label;
		
		
		private var addBtn:Button;
		
		
		override protected function initialize():void
		{
			if(!this.bg)
			{
				
				bg = new Image(BitmapFontUtils.getTexture("bg_00000"));
				bg.x = 2;
				this.addChild(bg);
				bg2 = new Image(BitmapFontUtils.getTexture('bg2_00000'));
				bg2.x = 2;
				bg2.touchable = false;
				bg2.visible = false;
				this.addChild(bg2);
				
				
				this.nameLabel = BitmapFontUtils.getLabel();
				this.nameLabel.touchable = false;
				this.nameLabel.setSize(150,40);
				this.nameLabel.x = 63;
				this.nameLabel.y = 18;
//				this.nameLabel.textRendererProperties.border = true;
				this.addChild(nameLabel);
				
				this.schoolLabel = BitmapFontUtils.getLabel();
				this.schoolLabel.touchable = false;
				this.schoolLabel.setSize(230,40);
				this.schoolLabel.x = 240;
				this.schoolLabel.y = 18;
//				this.schoolLabel.textRendererProperties.border = true;
				this.addChild(schoolLabel);
				
				this.sexLabel = BitmapFontUtils.getLabel();
				this.sexLabel.touchable = false;
				this.sexLabel.setSize(75,40);
				this.sexLabel.x = 570;
				this.sexLabel.y = 18;
//				this.sexLabel.textRendererProperties.border = true;
				this.addChild(sexLabel);
				
				this.ageLabel = BitmapFontUtils.getLabel();
				this.ageLabel.touchable = false;
				this.ageLabel.setSize(95,40);
				this.ageLabel.x = 762;
				this.ageLabel.y = 18;
//				this.ageLabel.textRendererProperties.border = true;
				this.addChild(ageLabel);
				
				
				this.addBtn = new Button(BitmapFontUtils.getTexture("addFriendBtn_00000"));
				this.addBtn.x = 927;
				this.addBtn.y = 12;
				this.addBtn.addEventListener(Event.TRIGGERED,addBtnHandle);
				this.addBtn.visible = false;
				this.addChild(this.addBtn);
				
				
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var _vo:RelListItemSpVO = this._data as RelListItemSpVO;
				
				this.nameLabel.text = _vo.realName;
				this.schoolLabel.text = _vo.school;
				this.sexLabel.text = _vo.gender == "1" ? "男" : "女";
				this.ageLabel.text = getAge(_vo.birth).toString();
				
				if(_vo.rstdId != PackData.app.head.dwOperID.toString())
				{
					this.addBtn.visible = true;
				}
			}
		}
		private function getAge(_birth:String):int{
			return ((new Date).getFullYear() - (int(_birth.substr(0,4))));
			
		}
		
		private var beginY:Number;
		private var endY:Number;
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					beginY = touch.globalY;
					
					bg2.visible = true;
				}else if(touch.phase==TouchPhase.MOVED){
					endY = touch.globalY;
					if(Math.abs(endY-beginY) > 10)
						bg2.visible = false;
					
				}else if(touch.phase == TouchPhase.ENDED){
					bg2.visible = false;
					
					endY = touch.globalY;
					if(Math.abs(endY - beginY) <= 10){
//						this.dispatchEvent(new Event(CLICK,e.bubbles,e.data));
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
							[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(this._data as RelListItemSpVO),
								SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					}
				}
				
			}		
		}
		
		private function addBtnHandle():void{
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(ChatAlertMediator,[addFun,"确定增加 "+(this.data as RelListItemSpVO).realName+" 为好友？"],
					SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
		}
		private function addFun():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ChatRoomMediator.APPLY_ADD_RELATE,
				new CharaterInfoVO(this.data as RelListItemSpVO,null,null,1));
			
			
			/*PackData.app.CmdIStr[0] = CmdStr.INSERT_STD_RELAT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = (this.data as RelListItemSpVO).rstdId;
			PackData.app.CmdIStr[3] = "F";
			PackData.app.CmdInCnt = 4;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,
				new SendCommandVO(ChatRoomMediator.INSERT_STD_RELATE,null,"cn-gb",null,SendCommandVO.QUEUE));*/
			
			
		}
		
		
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}