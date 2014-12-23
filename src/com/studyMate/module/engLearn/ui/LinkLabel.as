package com.studyMate.module.engLearn.ui
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	
	/**
	 * note
	 * 2014-10-22上午11:45:59
	 * Author wt
	 *
	 */	
	
	public class LinkLabel extends Label
	{
		public var rankId:String;
		public var type:String;
		public var mark:String;//判断mark标记是否相等。即可判断是否连线正确
		protected var selectColor:uint =0xFFE400;
		protected var defaultColor:uint = 0xFFFFFF;
//		protected var label:Label;
		
		public function LinkLabel()
		{	
			
			this.maxWidth = 438;
			this.textRendererFactory = function():ITextRenderer{			
				return  new ExtendTextFieldTextRenderer();//原来的有bug。无法显示border边框
			}
			this.textRendererProperties.textFormat = new TextFormat( "HeiTi", 25, defaultColor ,true);
			this.textRendererProperties.textFormat.align = TextFormatAlign.LEFT;
			this.textRendererProperties.embedFonts = true;
//			this.textRendererProperties.border = true;
//			this.textRendererProperties.borderColor = 0xFFFFFF;
			this.textRendererProperties.useGutter = true;
			this.textRendererProperties.backgroundColor = 0x123456;
			this.wordWrap = true;
			
		}
		
		/*private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			if(touch){
				if(touch.phase==TouchPhase.BEGAN){
					trace('BEGAN');
				}else if(touch.phase==TouchPhase.HOVER){
					trace('HOVER');
				}
			}
		}	*/	
		
		private var _border:Boolean;
		public function showBorder():void{
			if(_border) return;
			_border = true;
			this.textRendererProperties.border = true;
			this.textRendererProperties.borderColor = 0xFFFFFF;
			this.textRendererProperties.textFormat.color = selectColor;
		}
		
		public function hideBorder():void{
			if(!_border) return;
			_border = false;
			this.textRendererProperties.border = false;
			this.textRendererProperties.textFormat.color = defaultColor;
//			this.textRendererProperties.borderColor = 0xFFFFFF;
		}
		

		
		private var _isSelect:Boolean;
		public function set isSelected(value:Boolean):void{
			if(_isSelect!=value){
				_isSelect = value;
				
				if(value){
					showBorder();
					this.textRendererProperties.textFormat.color = selectColor;
				}else{
					hideBorder();
					this.textRendererProperties.textFormat.color = defaultColor;
				}
				this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
			}
		}
		
		

	}
}