package com.studyMate.module.engLearn.ui
{
	import com.lorentz.SVG.utils.StringUtil;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-10-20下午2:14:50
	 * Author wt
	 *
	 */	
	
	public class ReadAloudUI extends Sprite
	{
		protected var maxWidth:Number = 1100;
		protected var maxHeight:Number = 432;
		protected var y_gap:Number = 10;
//		protected var left:Number = 62;
//		protected var top:Number = 112;
		protected var tf:TextFormat = new TextFormat("HeiTi",22,0x262626,true);
		protected var tf1:TextFormat = new TextFormat("HeiTi",20,0x262626,true);
		
		protected var index:int = 0;
		public function ReadAloudUI()
		{
			super();
		}
		
		
		public function updateView(readVO:ReadAloudVO,showCn:Boolean):void{
			index = 0;
			showUI(readVO,showCn);
		}
		
		
		public function updateVecView(vec:Vector.<ReadAloudVO>,showCn:Boolean):void{
			for(var i:int=0;i<vec.length;i++){
				showUI(vec[i],showCn);
				index++;
			}
			index = 0;
		}
		
		
		
		private function showUI(readVO:ReadAloudVO,showCn:Boolean):void{
			var usTxt:TextField = new TextField();
			usTxt.embedFonts = true;
			usTxt.autoSize = TextFieldAutoSize.LEFT;
			usTxt.antiAliasType = AntiAliasType.ADVANCED;
			usTxt.defaultTextFormat = tf;
			usTxt.width = maxWidth;
			usTxt.multiline = true;
			usTxt.wordWrap = true;
			usTxt.htmlText = (index+1).toString() + readVO.usSentence;
			if(usTxt.textWidth>maxWidth){
				usTxt.width = maxWidth;
			}else{				
				usTxt.width = usTxt.textWidth+23;
			}			
			var usGpu:Sprite = new TextFieldToGPU(usTxt);
//			usGpu.x = left;
			usGpu.y = index*100;
			this.addChild(usGpu);
			
			if(showCn){				
				var cnTxt:TextField = new TextField();
				cnTxt.defaultTextFormat = tf1;
				cnTxt.width = maxWidth;
				cnTxt.embedFonts = true;
				cnTxt.autoSize = TextFieldAutoSize.LEFT;
				cnTxt.antiAliasType = AntiAliasType.ADVANCED;
				cnTxt.multiline = true;
				cnTxt.wordWrap = true;
				cnTxt.htmlText = StringUtil.rtrim(readVO.cnSentence);
				if(cnTxt.textWidth>maxWidth){
					cnTxt.width = maxWidth;
				}else{
					cnTxt.width = cnTxt.textWidth + 23;					
				}
				var cnGpu:Sprite = new TextFieldToGPU(cnTxt);
//				cnGpu.x = left;
				cnGpu.y = usTxt.y + y_gap;
				this.addChild(cnGpu);
			}
		}
	}
}