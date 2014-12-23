package com.studyMate.world.screens.component.drawGetWord
{
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GridCore extends Sprite
	{
		protected var gap:Number = 30;
		protected var useKeyBoard:Boolean;
		protected var oldColor:uint;
		protected var newColor:uint;
		protected var currentEdit:Sprite;
		
		public function GridCore()
		{
			super();
		}
		
		public function DrawSentence(targetTF:TextField):void{
			DrawGetWord.getInstance().MaintextField = targetTF;
		}
		
		public function addElement(str:String):void{
			
			if(this.numChildren>20) return;
			var lineUI:Sprite = this.makeElement(str);
			var num:Number = this.numChildren;
			if(num>0){
				lineUI.y = this.getChildAt(num-1).y + this.getChildAt(num-1).height + gap;				
			}
			this.addChild(lineUI);	
			
		}
		/**
		 * @param str 需要建立的类型
		 */		
		protected function makeElement(str:String):Sprite{
			throw new Error("请继承覆盖表格单元函数");
			return null;
		}
		
		//删除
		protected function removeElement(e:MouseEvent):void{
			var element:Sprite = e.target.parent as Sprite;
			var i:int = this.getChildIndex(element);
			this.removeChild(element);
			element = null;
			var total:int = this.numChildren;
			if(i==0 && total){
				this.getChildAt(i).y = 0;
				i++;
			}
			for(i;i<total;i++){				
				this.getChildAt(i).y = this.getChildAt(i-1).y + this.getChildAt(i-1).height + gap;//间距
			}
		}
		
		//上移
		protected function UpChangeElement(e:MouseEvent):void{
			var back:Sprite = e.target.parent as Sprite;
			useKeyBoard = false;
			var txt:TextFieldHasKeyboard = back.getChildAt(1) as TextFieldHasKeyboard;
			this.stage.focus = txt;	
			
			var i:int = this.getChildIndex(back);			
			if(i!=0){			
				i--;
				var front:Sprite = this.getChildAt(i) as Sprite;
				back.y = front.y ;//后一个上移
				front.y = gap+back.height;//前一个下移
				this.swapChildren(front,back);
			}	
		}
		
		//插入行		
		protected function insertElement(e:MouseEvent):void{
			var sp:Sprite = e.target.parent as Sprite;
			var tempIndex:int = this.getChildIndex(sp);	
			var sent:SentenceElement = new SentenceElement();
			sent.y = sp.y;
			this.addChild(sent);
			sent.addEventListener(MouseEvent.CLICK,insertHandler);
			
			function insertHandler(e:MouseEvent):void{
				var btn:Button = e.target as Button;
				this.installElementAt(btn.label,tempIndex);
			}
		}
		private function installElementAt(str:String,index:int):void{
			if(this.numChildren>20) return;
			var lineUI:Sprite = this.makeElement(str);			
			lineUI.y = this.getChildAt(index).y+ this.getChildAt(index).height+gap;			
			this.addChildAt(lineUI,index+1);
			var total:int = this.numChildren;			
			while((index+2)<total){
				this.getChildAt(index+2).y = this.getChildAt(index+1).y + this.getChildAt(index+2).height+ gap;//间距
				index++;
			}			
		}
		
		//输入框获得焦点
		protected function focusInHandler(e:FocusEvent):void{
			if(!useKeyBoard){//如果不用软键盘，则阻止事件派发
				e.stopImmediatePropagation();
				useKeyBoard = true;
			}
			if(currentEdit){//上一个
				currentEdit.graphics.clear();
				currentEdit.graphics.beginFill(oldColor);
				currentEdit.graphics.drawRect(0,0,currentEdit.width,currentEdit.height);
				currentEdit.graphics.endFill();
			}
			
			DrawGetWord.getInstance().receive = e.target as TextField;
			var holder:Sprite = e.target.parent as Sprite;
			holder.graphics.clear();
			holder.graphics.beginFill(newColor);
			holder.graphics.drawRect(0,0,holder.width,holder.height);
			holder.graphics.endFill();
			
			currentEdit = holder;
		}
		//输入框失去焦点
		protected function focusOutHandler(e:FocusEvent):void{
			if(currentEdit){//上一个
				currentEdit.graphics.clear();
				currentEdit.graphics.beginFill(0xDDDDDD);
				currentEdit.graphics.drawRect(0,0,currentEdit.width,currentEdit.height);
				currentEdit.graphics.endFill();
			}
		}
		
		//从索引i开始，重新排列坐标
		protected function refreshScreen(i:int):void{
			var total:int = this.numChildren;
			if(i==0){
				this.getChildAt(i).y = 0;
				i++;
			}
			for(i;i<total;i++){				
				this.getChildAt(i).y = this.getChildAt(i-1).y + this.getChildAt(i-1).height + gap;//间距
			}
		}
	}
}