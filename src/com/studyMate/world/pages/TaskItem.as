package com.studyMate.world.pages
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filters.GlowFilter;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class TaskItem extends Sprite
	{
		private var bg:Image;
		private var textField:TextField;

		
		private var taskItem:Object;
		private var info:String;
		public var taskRRL:String;
		public var taskStatu:String;
		
		private var tapDown:Boolean;
		
		public function TaskItem(taskItem:Object,title:String)
		{
			this.taskItem = taskItem;
			this.info = title;
			this.taskRRL = taskItem.rrl;
			this.taskStatu =  taskItem.lnstatus;
			
			if(taskStatu == "A" || taskStatu == "R"){
				//未开始
				bg = new Image(Assets.getTaskListTexture("itemBg_undo"));
			}else if(taskStatu == "Z"){
				//已完成
				bg = new Image(Assets.getTaskListTexture("itemBg_do"));
			}
			addChild(bg);
			
			
			textField = new TextField(this.width,70,info,"HuaKanT",60,0xffffff);
			textField.nativeFilters = [new GlowFilter(0,0.8,1,1,5)];  //bitmap字体无法使用nativeFilters
			textField.y = 17;
			addChild(textField);
			
//			var font:Sprite = Assets.getWordSprite(info,"HK");
//			font.x = (this.width-font.width)>>1;
//			font.y = 17;
//			addChild(font);
			
			textField = new TextField(this.width,26,taskItem.title,"HuaKanT",15,0xffffff);
			textField.y = 76;
			addChild(textField);

			
			var star:Image;
			var starNum:Number = 0;
			if(taskItem.rlevel){
				
				starNum = MyUtils.getRewardStar(Number(taskItem.rlevel));
			}
			var tmpNum:int = 0;
			
			//如果是整数，直接加星星
			if(starNum is int){
				tmpNum = starNum;
				
			}else{
				tmpNum = Math.floor(starNum);
				
				star = new Image(Assets.getTaskListTexture("itemStar1"));
				star.x = 42*tmpNum+31;
				star.y = bg.height-33;
				addChild(star);
			}
			for (var i:int = 0; i < tmpNum; i++) 
			{
				star = new Image(Assets.getTaskListTexture("itemStar"));
				star.x = 42*i+31;
				star.y = bg.height-33;
				addChild(star);
			}
			
			
			addEventListener(TouchEvent.TOUCH,touchHandle);
			
			
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
			
		}
		private function addToStage(event:Event):void{
			if(taskStatu == "R"){
				var lernIcon:Image = new Image(Assets.getTaskListTexture("learningIcon"));
				lernIcon.x = 126;
				lernIcon.y = -12;
				addChild(lernIcon);
				
			}
		}
		
		
		private var beginX:Number;
		private var endX:Number;
		private function touchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(this);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						
						if(Global.isLoading){
							return;
						}
						
						//				beginTask();
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ITEM_TASK_INFO,[taskRRL,taskStatu]);
					}
				}
			}
		}
	}
}