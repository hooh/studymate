package com.studyMate.module.classroom.view
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
	
	
	/**
	 * note
	 * 2014-6-10上午11:18:08
	 * Author wt
	 *
	 */	
	
	internal class CRInputBase extends Sprite implements IInputBase
	{
		protected var holder:Sprite;
		protected var dropDownBtn:Button;
		protected var _dropDownView:DisplayObject;
		
		public function CRInputBase()
		{
			holder = new Sprite();
			holder.x = 720;
			holder.y = 663;
			this.addChild(holder);
			
			dropDownBtn = new Button(Assets.getCnClassroomTexture("dropdownBtn"));
			dropDownBtn.x = 19;
			dropDownBtn.y = 21;
		}
		
		override public function dispose():void
		{
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(_dropDownView){
				_dropDownView.removeFromParent(true);
			}
			super.dispose();
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
		
		
		
		//打开下拉菜单按钮
		public function get addDropdownDisplayobject():DisplayObject{
			return dropDownBtn;
		}
		//下拉界面
		public function set dropDownViewDisplayobject(value:DisplayObject):void{
			_dropDownView = value;
		}
		//下拉后的状态
		public function dropdownState():void{
			if(!_dropDownView.parent){
				this.addChildAt(_dropDownView,0);
			}
			_dropDownView.x = 719;
			_dropDownView.y = 612;
			VoicechatComponent.owner(core).updateHeight(462);
			rect = holder.getBounds(Starling.current.stage);
			rect.height += _dropDownView.height;
			Global.stage.addEventListener(MouseEvent.CLICK,clickHandler,false,3);
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
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			if(VoicechatComponent.owner(core))
				VoicechatComponent.owner(core).updateHeight(VoicechatComponent.owner(core).configView.viewHeight);
			
			if(_dropDownView){
				_dropDownView.removeFromParent();
			}
		}
	}
}