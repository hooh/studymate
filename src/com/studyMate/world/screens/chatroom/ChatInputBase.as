package com.studyMate.world.screens.chatroom
{
	import com.studyMate.global.Global;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.interfaces.IInputBase;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	
	internal class ChatInputBase extends Sprite implements IInputBase
	{
		protected var holder:Sprite;
		protected var _dropDownView:DisplayObject;
		
		public function ChatInputBase()
		{
			holder = new Sprite();
			holder.x = 72;
//			holder.y = 9;
			holder.y = 639;
			this.addChild(holder);
			
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
		
		override public function dispose():void
		{
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(_dropDownView){
				_dropDownView.removeFromParent(true);
			}
			super.dispose();
		}
		
		
		//打开下拉菜单按钮
		public function get addDropdownDisplayobject():DisplayObject{
			return null;
		}
		//下拉界面
		public function set dropDownViewDisplayobject(value:DisplayObject):void{
			_dropDownView = value;
		}
		//下拉后的状态
		public function dropdownState():void{
//			if(!_dropDownView.parent){
//				this.addChildAt(_dropDownView,0);
//			}
//			_dropDownView.x = 719;
//			_dropDownView.y = 612;
//			VoicechatComponent.owner.updateHeight(462);
//			rect = holder.getBounds(Starling.current.stage);
//			rect.height += _dropDownView.height;
//			Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,3);
		}
		private var rect:Rectangle ;		
		protected function clickHandler(event:MouseEvent):void
		{
			
			if(rect.contains(event.stageX,event.stageY)){
				
			}else{
				defaultState();
			}
		}
		
		//默认状态
		public function defaultState():void{
//			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(VoicechatComponent.owner(core)){
				VoicechatComponent.owner(core).updateHeight(VoicechatComponent.owner(core).configView.viewHeight);
				
			}
//			
//			if(_dropDownView){
//				_dropDownView.removeFromParent();
//			}
		}
	}
}