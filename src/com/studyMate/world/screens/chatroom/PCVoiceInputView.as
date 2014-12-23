package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.interfaces.IVoiceInputView;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class PCVoiceInputView extends Sprite implements IVoiceInputView
	{
		private var startRecordBtn:Button;//开始录音
		private var changeInputBtn:Button;//切换文字输入
		private var inputImg:Image;
		
		protected var dropDownBtn:Button;
		protected var holder:Sprite;
		protected var _dropDownView:DisplayObject;
		
		private var tipImg:Image;//提示取消和试听的图标
		
		public function PCVoiceInputView()
		{
			super();
			
			holder = new Sprite();
			holder.x = 325;
			holder.y = 649;
			this.addChild(holder);
			
			
			inputImg = new Image(Assets.getChatViewTexture("chatRoom/ptalk_inputBg"));
			holder.addChild(inputImg);
			
			
			startRecordBtn = new Button(Assets.getChatViewTexture('chatRoom/startRecordBtn'),'',Assets.getChatViewTexture('chatRoom/stopRecordBtn'));
			startRecordBtn.x = 74;
			startRecordBtn.y = 15;
			holder.addChild(startRecordBtn);

			
			changeInputBtn = new Button(Assets.getChatViewTexture('chatRoom/input_chagKeyBtn'));
			changeInputBtn.x = 872;
			changeInputBtn.y = 10;
			holder.addChild(changeInputBtn);
			
			
			dropDownBtn = new Button(Assets.getChatViewTexture("chatRoom/input_moreBtn"));
			holder.addChild(dropDownBtn);
						
			
		}
		
		private var _core:String;
		public function set core(value:String):void
		{
			_core = value;
		}
		
		public function get core():String
		{
			return _core;
		}
		
		public function get recordDisplayObject():DisplayObject
		{
			return startRecordBtn;
		}
		
		public function get switchTextInputDisplayObject():DisplayObject
		{
			return changeInputBtn;
		}
		
		public function get startListenDisplayObject():DisplayObject
		{
			if(tipImg==null){
				tipImg = new Image(Assets.getWeixinTexture('tryListenImg'));
				tipImg.x = 690;
				tipImg.y = 300;
			}
			
			return tipImg;
		}
		
		public function startRecordState():void{
			if(!startListenDisplayObject.parent) this.addChild(startListenDisplayObject);			
		}
		
		public function endRecordState():void{
			if(startListenDisplayObject) startListenDisplayObject.removeFromParent();
		}
		
		public  function dropdownState():void{
			if(holder.y!=430){
				holder.y = 430;
				dropdownState1();
			}else{
				defaultState();
			}
		}
		
		public function defaultState():void{//默认状态
//			holder.y = 663;
			TweenLite.to(holder,0.3,{y:663});
			defaultState1();
			
		}
		
		
		
		
		
		
		
		
		
		
		
		//打开下拉菜单按钮
		public function get addDropdownDisplayobject():DisplayObject{
			return dropDownBtn;
		}
		//下拉界面
		public function set dropDownViewDisplayobject(value:DisplayObject):void{
			_dropDownView = value;
		}
		
		
		
		public function dropdownState1():void{
			if(!_dropDownView.parent){
				this.addChildAt(_dropDownView,0);
			}
			_dropDownView.x = 326;
			_dropDownView.y = 510;
			VoicechatComponent.owner(core).updateHeight(360);
			rect = holder.getBounds(Starling.current.stage);
			rect.height += _dropDownView.height;
			Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,3);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			
			if(rect.contains(event.stageX,event.stageY)){
				
			}else{
//				defaultState1();
				defaultState();
			}
		}
		
		private var rect:Rectangle ;	
		public function defaultState1():void{
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(VoicechatComponent.owner(core)){
				VoicechatComponent.owner(core).updateHeight(VoicechatComponent.owner(core).configView.viewHeight);
				
			}
			
			if(_dropDownView){
				_dropDownView.removeFromParent();
			}
		}

		
		
		
		
		
		override public function dispose():void{		
			
			TweenLite.killTweensOf(holder);
			
			
			if(tipImg){
				tipImg.removeFromParent(true);
				tipImg = null;
			}
			
			
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(_dropDownView){
				_dropDownView.removeFromParent(true);
			}
			
			super.dispose();
		}
	}
}