package com.studyMate.view.component
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.view.component.myDrawing.helpFile.IsLetter;
	import com.studyMate.view.component.myDrawing.helpFile.IsSentence;
	import com.studyMate.world.screens.PopMenuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	public class ReadingTextField extends TextField
	{
		/**
		 * 显示翻译组件
		 * @param localX 组件点击的本地X坐标
		 * @param localY 组件点击的本地Y坐标
		 */		
		public function show(localX:Number=0,localY:Number=0):void{
			var selectStart:int=this.getCharIndexAtPoint(localX,localY);
			if(selectStart==-1){
				return;
			}			
			this.stage.focus=this;
			this.setSelection(0,0);
			
			/************************翻译组件显示坐标*****************************/
			//var myX:int = 0;
			//var myY:int = 0;
			var point:Point = this.localToGlobal(new Point(localX,localY));
			var stageX:Number = point.x;
			var stageY:Number = point.y;			
			// 默认在光标左上角
			//	myY = stageY +20;

			var myX:int = stageX;
			var myY:int;

			if(stageY-47>20){
				myY = stageY-47-20;
			}else{
				myY = stageY +20;
			}
			/************************单词选择*****************************/
			var start:int = IsLetter.search(this.text,selectStart,"Left");
			var end:int = IsLetter.search(this.text,selectStart,"Right");
			this.setSelection(start,end+1);
			var selectWord:String = this.text.substring(start,end+1);
			var holder:Sprite = AppLayoutUtils.cpuLayer;
			
			var data:Object = {};
			data.selectWord = selectWord;
			data.sentenceStr = IsSentence.search(this.text,selectStart);
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PopMenuMediator,data,SwitchScreenType.SHOW,holder,myX,myY)]);
			this.selectable = false;
			
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.CHECK_SENTENCE,IsSentence.search(this.text,selectStart));
		}
	}
}