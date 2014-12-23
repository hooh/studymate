package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.AssetTool;
	
	import fl.controls.Slider;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getDefinitionByName;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexMouseEvent;
				
	public class SelectMenuTextfield extends TextField
	{
		
		public var holder:Sprite;
		public var buttonBarPopOver:Sprite;
		public var contentGroup:DisplayObjectContainer;
		public var holderCover:Sprite;
		public static var gotoPageHS:Slider;
		//public static var textSelectRightSource:Class;
		//public static var textSelectLeftSource:Class;
		
		public var selectStart:int=0;
		public var selectEnd:int=0;
		public var word_selectStart:int=0;
		public var word_selectEnd:int=0;
		public var word_localX:int=0;
		public var word_localY:int=0;
		public var tf2:TextField;
		//public var btn:Button;
		public static var selectWord:String;
		
		private var pressSign:Boolean = false;
		
		public function SelectMenuTextfield()
		{
			
			var format:TextFormat=new TextFormat();
			format.font = "HeiTi";
			format.size = 40;
			
			this.embedFonts = true;
			this.defaultTextFormat = format;
			this.multiline = true;
			this.wordWrap = true;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,touchDown);
			this.addEventListener(MouseEvent.MOUSE_UP,touchUp);			
		}
		
		private function touchDown(e:MouseEvent):void{
			
			if(buttonBarPopOver.visible || (gotoPageHS&&gotoPageHS.visible))
				pressSign = true;
			buttonBarPopOver.visible = false;

			this.selectable=false;
			
			word_selectStart=0;
			word_selectEnd=0;
			selectWord = "";
			
			word_localX=e.localX;

			word_localY=((int)(e.localY/this.getLineMetrics(0).height))*this.getLineMetrics(0).height;
			selectStart=this.getCharIndexAtPoint(e.localX,e.localY);
			TweenLite.delayedCall(0.6,touchPress,[e]);			
		}
		
		private function touchUp(e:MouseEvent):void{
			
			if(pressSign == false){
			}
			else
				pressSign = false;
			
			
			TweenLite.killTweensOf(touchPress);
			
		}
		
		private function touchPress(e:MouseEvent):void{
			try{
				pressSign = true;
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
						//trace(this.text.substring(word_selectStart,word_selectEnd));
						selectWord = this.text.substring(word_selectStart,word_selectEnd);						
						
						if(word_selectStart!=0 || word_selectEnd!=0){							
							//显示菜单、选择游标
							//trace("第几行："+(int)(e.localY/this.getLineMetrics(0).height));
							var lineOfsetIndex:int = this.getLineOffset((int)(e.localY/this.getLineMetrics(0).height));
							var firstString:String = this.text.substring(lineOfsetIndex,word_selectStart);
							var secondString:String = this.text.substring(lineOfsetIndex,word_selectEnd);
							
							var textSelectRightSource:Class = AssetTool.getCurrentLibClass("textSelectRight");
							var textSelectLeftSource:Class = AssetTool.getCurrentLibClass("textSelectLeft");
							
							buttonBarPopOver.x=word_localX+this.x-buttonBarPopOver.width/2;
							//trace("高度："+buttonBarPopOver.height);
							buttonBarPopOver.y=word_localY+this.y-buttonBarPopOver.height;
							if(buttonBarPopOver.x < 0)
								buttonBarPopOver.x = 0;
							if(buttonBarPopOver.x + buttonBarPopOver.width > 1280)
								buttonBarPopOver.x = 1280 - buttonBarPopOver.width;
							if(buttonBarPopOver.y < 0)
								buttonBarPopOver.y = 0;
							buttonBarPopOver.visible = true;
							
						}
						this.stage.focus=this;
						this.selectable=true;
						this.setSelection(word_selectStart,word_selectEnd);												
					}
				}
			}catch(e:Error){
				
			}
			
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