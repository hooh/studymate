package com.studyMate.utils
{
	import com.greensock.TimelineMax;
	import com.studyMate.world.script.LayoutTool;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.Sprite;
	
	import utils.FunctionQueue;
	import utils.FunctionQueueEvent;

	public class LayoutToolUtils
	{
		/**
		 *执行page脚本 
		 */		
		public static var pageQueue:FunctionQueue = new FunctionQueue();
		/**
		 *执行自定义脚本 
		 */		
		public static var commandQueue:FunctionQueue = new FunctionQueue();
		
		public static var typeTimeLine:TimelineMax = new TimelineMax();
		
		public static var holderObjs:Object={};
		public static var script:Vector.<String>;
		
		public static var jump:Boolean;
		public static var LibSCRPos:Number = 0;
		public static var LibSCRSelect:String = "pictureBook";
		
		public static var queue:FunctionQueue;
		
		public static var holder:flash.display.Sprite;
		
		
		public static function disposeHolder():void{
			
			if(holder){
				while(holder.numChildren>0){
					holder.removeChildAt(0);
				}
				
				
				LayoutToolUtils.holder = null;
			}
			
			LayoutTool.mainHolder=null;
			LayoutTool.holder = null;
			LayoutTool.subHolder = null;
		}
		
		public static function initQueue():void{
			
			//清除队列
			queue.reset();
		}
		
		public static function removeAll():void{
			
			
			
			if(LayoutToolUtils.holder){
				
				while(LayoutToolUtils.holder.numChildren>0){
					LayoutToolUtils.holder.removeChildAt(0);
				}
				
			}
			
			
			//MyUtils.functionTimeLine.stop();
			//MyUtils.functionTimeLine.clear();
			killLayoutScript();
			
			
		}
		public static function killLayoutScript():void{
			
			LayoutTool.killSound();
			
			if(LayoutToolUtils.typeTimeLine){
				LayoutToolUtils.typeTimeLine.stop();
				LayoutToolUtils.typeTimeLine.clear();
				
			}
			if(LayoutTool.soundChannel){
				LayoutTool.soundChannel.stop();
			}
			
			TypeTool.killType();
			
			if(queue){
				queue.reset();
				
			}
			
			holderObjs = {};
		}
		
		
		public static function queueExecuse():void{
			queue.dispatcher.dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.FUNCTION_COMPLETE));
		}
	}
}