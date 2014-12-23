package com.mylib.game.card
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.HumanMediator;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class NPCSelectItem extends Sprite
	{
		private var selectBtn:Button;
		private var removeBtn:Button;
		private var charater:HumanMediator;
		private var _charaterData:GameCharaterData;
		
		public static const SELECT:String = "select";
		public static const DELETE:String = "delete";
		
		
		public function NPCSelectItem()
		{
			
			selectBtn = new Button;
			selectBtn.label = "分派";
			
			removeBtn = new Button();
			removeBtn.label = "删除";
			
			removeBtn.y = 60;
			
			removeBtn.addEventListener(Event.TRIGGERED,deleteHandle);
			addChild(selectBtn);
			selectBtn.addEventListener(Event.TRIGGERED,seleteHandle);
			
		}
		
		private function deleteHandle(event:Event):void
		{
			this.dispatchEventWith(DELETE);
		}
		
		private function seleteHandle(event:Event):void{
			
			this.dispatchEventWith(SELECT);
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			recycle();
			selectBtn.dispose();
		}
		
		
		public function set charaterData(__charaterData:GameCharaterData):void{
			_charaterData = __charaterData;
			if(__charaterData){
				selectBtn.removeFromParent();
				addChild(removeBtn);
				
				if(!charater){
					charater = (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object;
					charater.view.addEventListener(TouchEvent.TOUCH,touchHandle);
					addChild(charater.view);
					charater.view.x = charater.view.y = 0;
				}
				GlobalModule.charaterUtils.configHumanFromDressList(charater,__charaterData.equiment,null);
				charater.look("normal");
				
			}else{
				
				addChild(selectBtn);
				removeBtn.removeFromParent();
				recycle();
				
			}
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject,TouchPhase.ENDED);
			if(touch){
				this.dispatchEventWith(SELECT);
			}
			
		}
		
		public function get charaterData():GameCharaterData{
			return _charaterData;
		}
		
		private function recycle():void{
			
			if(charater){
				charater.view.removeFromParent();
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object = charater;
				charater = null;
			}			
			
		}
		
		
	}
}