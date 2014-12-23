package com.studyMate.world.screens
{
	
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ChapterSeleterMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ChapterSeleterMediator";
		
		private var chapters:Vector.<Point>;
		
		private var prevChapter:Point;
		protected var curChapter:Point;
		private var nextChapter:Point;
		protected var curChapterIdx:uint;
		private var dragging:Boolean;
		private var targetX:int;
		protected var centerX:Number;
		private var mouseDownX:Number;
		
		private var stageWidth:int;
		private var pageWidth:int;
		
		private var offsetX:Number=0;
		
		private var flipDis:int;
		
		protected var totalPage:int;
		
		private var downTime:int;
		
		private var minFlipDis:int = 50;
		private var minFlipTime:Number = 0.5;
		
		public function ChapterSeleterMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			addToStageHandle(null);
			
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			totalPage = vo.data as int;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		
		protected function addToStageHandle(event:starling.events.Event):void
		{
			init();
			createChapters();
			
			updateChapters();
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,onTransform);
			
			runEnterFrames = true;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,onTransform);
			view.removeFromParent(true);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.SET_ROLL_SCREEN : 
					var enable:Boolean = notification.getBody() as Boolean;
					if(enable){
						view.stage.addEventListener(TouchEvent.TOUCH,onTransform);
					}else{
						view.stage.removeEventListener(TouchEvent.TOUCH,onTransform);
					}
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.SET_ROLL_SCREEN];
		}
		
		
		override public function advanceTime(time:Number):void
		{
			
			if(!totalPage){
				return;
			}
			
			var radio:Number;
			
			if(dragging){
				radio = 1;
				if(offsetX<0&&curChapterIdx==this.chapters.length-1){
					radio=0.5;
				}else if(offsetX>0&&curChapterIdx==0){
					radio=0.5;
				}
				targetX = centerX+radio*offsetX;
				
			}
			
			var step:Number = (targetX-curChapter.x)*0.1;
			
			if(step<0.001&&step>-0.001){
				return;
			}
			
			curChapter.x +=step;
			sendNotification(WorldConst.UPDATE_CAMERA,int(curChapterIdx*pageWidth-curChapter.x+centerX));
			
			
			if(prevChapter){
				prevChapter.x = curChapter.x-pageWidth;
			}
			
			if(nextChapter){
				nextChapter.x = curChapter.x+pageWidth;
			}
			
		}
		
		protected function onTransform(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			var target:DisplayObject = touch.target;
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				mouseDownX = touch.globalX;
				downTime = getTimer();
				offsetX = 0;
			}else if(touch.phase == TouchPhase.MOVED){
				offsetX = touch.globalX - mouseDownX;
				
				if(!dragging&&(offsetX>20||offsetX<-20)){
					dragging = true;
				}
				
				
			}
			else if (touch.phase == TouchPhase.ENDED){
				dragging = false;
				//change page or not
				var changed:Boolean;
				var t:int = getTimer() - downTime;
				var speed:Number = offsetX/t;
				
				if(offsetX<0&&curChapterIdx<chapters.length-1&&(
					(-offsetX>minFlipDis&&-speed>minFlipTime)||
					(-offsetX>flipDis)
				)){
					curChapterIdx++;
					changed = true;
					trace("change+",curChapterIdx);
				}else if(offsetX>0&&curChapterIdx>0&&
					((offsetX>minFlipDis&&speed>minFlipTime)||
					(offsetX>flipDis))){
					curChapterIdx--;
					changed = true;
					
					trace("change-",curChapterIdx);
				}
				
				updateChapters();
				targetX = centerX;
				if(changed){
					sendNotification(WorldConst.UPDATE_FLIP_PAGE_INDEX,curChapterIdx);
				}
				
				
			}
			
		}
		
		private function updateChapters():void{
			if(chapters.length != 0){
				prevChapter = curChapterIdx>0?chapters[curChapterIdx-1]:null;
				curChapter = chapters[curChapterIdx];
				nextChapter = curChapterIdx<chapters.length-1?chapters[curChapterIdx+1]:null;
			}else{
				prevChapter = null;
				curChapter =null;
				nextChapter = null;
			}
		}
		
		private function init():void{
			stageWidth = Global.stageWidth;
			pageWidth = stageWidth;
			
			centerX = pageWidth>>1;
			targetX = centerX;
			flipDis = pageWidth>>2;
			
			
		}
		
		protected function createChapters():void{
			var cp:Point;
			chapters = new Vector.<Point>(totalPage);
			var halfHeight:int = Global.stage.stageHeight>>1
			
			
			for (var i:int = 0; i < totalPage; i++) 
			{
				cp = new Point();
				
				cp.x = centerX+pageWidth*i;
				
				cp.y = halfHeight;
				
				
				chapters[i]=cp;
				
				
			}
			
			curChapterIdx = 0;
			
			
			
			
		}
		
		
		
		
		
		public function get view():Sprite{
			
			return getViewComponent() as Sprite;
		}
		
		
		
	}
}