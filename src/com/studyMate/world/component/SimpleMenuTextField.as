package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.PopMenuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;


	public class SimpleMenuTextField extends TextField
	{
		
		private var word_selectStart:int;
		private var word_selectEnd:int;
		private var selectWord:String;
		private var word_localX:Number;
		private var word_localY:int;
		private var selectStart:int;
		
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		
		public function SimpleMenuTextField()
		{
			if(Global.hasLogin){
				this.addEventListener(MouseEvent.MOUSE_DOWN,touchDown);
				this.addEventListener(MouseEvent.MOUSE_UP,touchUp);
				this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
				this.addEventListener(MouseEvent.MOUSE_MOVE,touchMove);
			}
		}
		
		private function removeFromStageHandler(event:Event):void{
			TweenLite.killTweensOf(touchPress);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,touchDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,touchUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,touchMove);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			
		}
		private function touchDown(e:MouseEvent):void{
			
			this.setSelection(0,0);
			this.selectable=false;
			
			word_selectStart=0;
			word_selectEnd=0;
			selectWord = "";
			
			word_localX=e.localX;
			word_localY=((int)(e.localY/this.getLineMetrics(0).height))*this.getLineMetrics(0).height;
			selectStart=this.getCharIndexAtPoint(e.localX,e.localY);
			TweenLite.delayedCall(0.6,touchPress,[e]);
			
			mouseDownX = e.stageX;
			mouseDownY = e.stageY;
			
		}
		private function touchMove(e:MouseEvent):void{
			if((e.stageX-mouseDownX)>15 || (e.stageX-mouseDownX)<-15 || (e.stageY-mouseDownY)>15 || (e.stageY-mouseDownY)<-15){
				TweenLite.killTweensOf(touchPress);
			}
		}
		
		private function touchUp(e:MouseEvent):void{			
			TweenLite.killTweensOf(touchPress);			
		}
		private function touchPress(e:MouseEvent):void{			
			var myX:int = e.stageX;
			var myY:int = 0;
			//myX = e.stageX;
			// 默认在光标左上角
			/*if(e.stageX-255>20){
				myX = e.stageX-255-20;
			}else{*/
				//myX = e.stageX+20;
			//}
			if(e.stageY-47>20){
				myY = e.stageY-47-20;
			}else{
				myY = e.stageY +20;
			}
			
			if(selectStart!=-1){
				if(this.isLetter(this.text.substring(selectStart,selectStart+1))){
					word_selectStart=selectStart;
					word_selectEnd=selectStart;
					
					
					while ( word_selectStart>=0 ) {
						if (!this.isLetter(this.text.substring(word_selectStart,word_selectStart+1))) { word_selectStart++; break; }
						word_selectStart--;
					}
					if ( word_selectStart < 0 ) word_selectStart=0;
					
					while( word_selectEnd<=this.length ) {
						if (!this.isLetter(this.text.substring(word_selectEnd,word_selectEnd+1))) { word_selectEnd--; break; }
						word_selectEnd++;
					}
					if ( word_selectEnd >this.length ) word_selectEnd = this.length;
					word_selectEnd++;
					
					//选中单词
					selectWord = this.text.substring(word_selectStart,word_selectEnd);
					
					this.stage.focus=this;
					this.selectable=true;
					this.setSelection(word_selectStart,word_selectEnd);
					
				}
			}else{
				return;
			}
			//var vo:PopUpMenuVO = new PopUpMenuVO(MyUtils.view,selectWord,myX,myY);
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(ApplicationFacade.SHOW_POP_UP_MENU,vo);
			
			
			var holder:Sprite = AppLayoutUtils.cpuLayer;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PopMenuMediator,selectWord,SwitchScreenType.SHOW,holder,myX,myY)]);
			
			/*var sp:Sprite = new Sprite();
			sp.x = myX;
			sp.y = myY;
			var popMenu:PopMenuMediator = new PopMenuMediator(sp);
			var switchScreenVO:SwitchScreenVO = new SwitchScreenVO(null,selectWord);
			popMenu.prepare(switchScreenVO);			
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(popMenu.view));
			Facade.getInstance(ApplicationFacade.CORE).registerMediator(popMenu)*/;
		}
		private function isLetter(str:String):Boolean{
			if(str.charAt(0) >= 'a' && str.charAt(0) <= 'z'){
				return true;
			}
			else if(str.charAt(0) >= 'A' && str.charAt(0) <= 'Z'){
				return true;
			}
			else
				return false;
		}
	}
}