package com.studyMate.view.component.myRadioButton
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	internal class MyRadioButtonGroup implements IRadioButtonGroup
	{
		private static var instance:MyRadioButtonGroup;
		
		private var groupDic:Dictionary = new Dictionary;//属于的组群
		private var RadioBtn_Arr:Array;
				
		public static function getInstance():MyRadioButtonGroup
		{
			if (instance == null) instance = new MyRadioButtonGroup( );
			return instance as MyRadioButtonGroup;
		}

		/** 
		 * 注册按钮后，将接受发送send()命令
		 */		
		public function registerGoup(btn:MyRadioButton):void
		{
			//如果在订阅者群体（RadioBtn_Arr）中不存这个订阅者(bo),就把这个订阅者加入到订阅者群体中
			if (RadioBtn_Arr.indexOf(btn) < 0) {
				RadioBtn_Arr.push(btn);
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			}
		}
		
		
		private function removeFromStageHandler(e:Event):void{
			if(instance){
				instance=null;
			}
		}
			
			
		private function clickHandler(e:MouseEvent):void{	
			var btn:MyRadioButton = e.currentTarget as MyRadioButton;
			
			RadioBtn_Arr = groupDic[btn.groupName];
			var b_index:int = RadioBtn_Arr.indexOf(btn);
			if(b_index>=0) {
				var arr2:Array = RadioBtn_Arr.splice(b_index, 1);
				arr2[0].unupdate();
			}
			
			send(btn.groupName);
			registerGoup(btn);
		}
		
		

		/**
		 * 通知所有注册按钮接受事件
		 */
		private function send(groupName:String):void{
			RadioBtn_Arr=groupDic[groupName];
			//给订阅者群体中的每个订阅者发送信息（报刊）
			var bookers_len:int = RadioBtn_Arr.length;
			for(var i:int=0;i < bookers_len;i++) {
				RadioBtn_Arr[i].update();
			}
		}				
		

		public function set groupName(groupName:String):void{
			if (!groupDic[groupName]) {
				RadioBtn_Arr = [];
				groupDic[groupName] = RadioBtn_Arr;
			}else{//如果_groupNameArr已经包含了，则说明是同一个组，则继续添加
				RadioBtn_Arr=groupDic[groupName];
			}			
		}

	}
}