package com.studyMate.module.engLearn.ui
{
	import com.lorentz.SVG.utils.StringUtil;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ExamQuestionUI extends Sprite
	{
		protected var maxWidth:Number = 1100;
		protected var maxHeight:Number = 432;
		protected var left:Number = 62;
		protected var title_select_gap:Number = 20;
		protected var y_gap:Number = 10;
		protected var top:Number = 112;
		protected var scrollHeight:Number = 230
		
		protected var tf:TextFormat = new TextFormat("HeiTi",22,0x262626,true);
		protected var tf1:TextFormat = new TextFormat("HeiTi",20,0x262626,true);
		
		
		private  var titleBottom:Number = 10;//题目最底端
		
		private var tilte:String;
		private var option:Array;
		
		public function ExamQuestionUI(tilte:String,option:Array)
		{
//			tf = new TextFormat("HeiTi",22,0x262626,true);
//			tf1 = new TextFormat("HeiTi",20,0x262626,true);			
			this.tilte = tilte;
			this.option = option;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}		
		
		private function addToStageHandler():void
		{
			initTitle(tilte);			
			initSelect(option);
		}
		
		protected function get viewClass():Class{
			return TextFieldToGPU;
		}
		
		/**------------------------题目------------------------*/
		private function initTitle(title:String):void{
						
			var titileTxt:TextField = new TextField();
			titileTxt.embedFonts = true;
			titileTxt.autoSize = TextFieldAutoSize.LEFT;
			titileTxt.antiAliasType = AntiAliasType.ADVANCED;
			titileTxt.defaultTextFormat = tf;
			titileTxt.width = maxWidth;
			titileTxt.multiline = true;
			titileTxt.wordWrap = true;
			titileTxt.htmlText = title;
			if(titileTxt.textWidth>maxWidth){
				titileTxt.width = maxWidth;
			}else{				
				titileTxt.width = titileTxt.textWidth+23;
			}
			
			
			var titleGpu:Sprite = new viewClass(titileTxt);
			titleGpu.x = left;
			titleGpu.y = top;
			this.addChild(titleGpu);
			
			titleBottom = titleGpu.height + top;
		}
		
		/**-----------------选项-----------------------------*/
		private function initSelect(option:Array):void{
			var selectTxt:TextField;
			var selectTxtVec:Vector.<TextField> = new Vector.<TextField>();
			var x_maxWidth:Number = 10;//选项的最大宽度
			
			for(var i:int=0;i<option.length;i++){
				selectTxt = new TextField();
				selectTxt.defaultTextFormat = tf1;
				selectTxt.width = maxWidth;
				selectTxt.embedFonts = true;
				selectTxt.autoSize = TextFieldAutoSize.LEFT;
				selectTxt.antiAliasType = AntiAliasType.ADVANCED;
				selectTxt.multiline = true;
				selectTxt.wordWrap = true;
//				selectTxt.htmlText = option[i];
				selectTxt.htmlText = StringUtil.rtrim(option[i]);
				if(selectTxt.textWidth>maxWidth){
					selectTxt.width = maxWidth;
				}else{
					selectTxt.width = selectTxt.textWidth + 23;					
				}
				
				
				selectTxtVec.push(selectTxt);
				
				if(x_maxWidth<selectTxt.width){
					x_maxWidth = selectTxt.width;
				}
			}
			
			var selectGpu:Sprite;
			if(x_maxWidth<maxWidth/4){//四列
				for(i=0; i<selectTxtVec.length; i++){
					selectGpu = new viewClass(selectTxtVec[i]);					
					selectGpu.x = maxWidth/4*int(i%4) + left;
					selectGpu.y = titleBottom + title_select_gap + (y_gap+selectGpu.height)*int(i/4);
					this.addChild(selectGpu);
				}
			}else if(x_maxWidth<maxWidth/2){//两列
				for(i=0; i<selectTxtVec.length; i++){
					selectGpu = new viewClass(selectTxtVec[i]);	
					selectGpu.x = maxWidth/2*int(i%2) + left;
					selectGpu.y = titleBottom + title_select_gap + (y_gap+selectGpu.height)*int(i/2) ;
					this.addChild(selectGpu);
				}
			}else{//竖排
				
				var scroll:Scroller = new Scroller();
				scroll.x = left;
				scroll.y = titleBottom+title_select_gap;
				scroll.width = maxWidth+4;
				scroll.height = maxHeight - scroll.y;

				var viewPort:LayoutViewPort = new LayoutViewPort();
								
				var preGpu:Sprite;
				for(i=0; i<selectTxtVec.length; i++){	
					selectGpu = new viewClass(selectTxtVec[i]);
					if(preGpu==null){
						selectGpu.y =  0;
					}else{
						selectGpu.y =preGpu.y + preGpu.height + y_gap;
					}
					preGpu = selectGpu;
					viewPort.addChild(selectGpu);
				}
				scroll.viewPort = viewPort;
				this.addChild(scroll);
				preGpu = null;
			}
			
			selectTxtVec.length = 0;
			selectTxtVec = null;
			
		}
	}
}