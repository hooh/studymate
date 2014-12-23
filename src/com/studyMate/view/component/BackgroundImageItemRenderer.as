package com.studyMate.view.component
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import mx.core.FlexTextField;
	import mx.flash.UIMovieClip;
	
	import spark.components.IconItemRenderer;
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.StyleableTextField;
	
	
	[Style(name="itemSelectionImage", type="String", inherit="yes")]
	[Style(name="selectionImage", type="String", inherit="yes")]
	//[Style(name="statuSign", type="String", inherit="yes")]
	
	
	public class BackgroundImageItemRenderer extends LabelItemRenderer
	{
		private var _backgroundField:String;
		
		private var _itemRelation:String;
		
		private var _backgroundX:String;
		
		private var _backgroundY:String;
		
		private var _fatherOpenState:String;
		
		private var _myLabelText:String;
		
		private var _statuSign:String;
		
		private var _statu:String;
		
		private var bgChanged:Boolean;
		
		private var bg:DisplayObject;
		
		private var statuSignMC:DisplayObject;
		
		private var preSelected:Boolean;
		
		private var myText:StyleableTextField;
		
		public function BackgroundImageItemRenderer()
		{
			super();
			
			
			//var righSign:Class   = AssetTool.getCurrentLibClass("rightBtn");
			
			//var righSignMC:UIMovieClip   = new righSign;
			
			//taskList.addElement(righSignMC);
		}
		
		
		public function get itemRelation():String
		{
			return _itemRelation;
		}
		public function set itemRelation(value:String):void
		{
			_itemRelation = value;
		}
		
		public function get backgroundX():String
		{
			return _backgroundX;
		}
		public function set backgroundX(value:String):void
		{
			_backgroundX = value;
		}
		
		public function get backgroundY():String
		{
			return _backgroundY;
		}
		public function set backgroundY(value:String):void
		{
			_backgroundY = value;
		}
		
		public function get fatherOpenState():String
		{
			return _fatherOpenState;
		}
		public function set fatherOpenState(value:String):void
		{
			_fatherOpenState = value;
		}
		
		public function get statuTerm():String
		{
			return _statu;
		}
		public function set statuTerm(value:String):void
		{
			_statu = value;
		}
		public function get statuSign():String
		{
			return _statuSign;
		}
		public function set statuSign(value:String):void
		{
			_statuSign = value;
		}
		
		
		
		
		
		
		public function get backgroundField():String
		{
			return _backgroundField;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			bgChanged = true;
			cleanSatuSign();
			cleanMyText();
			invalidateProperties();
		}
		
		private function cleanSatuSign():void
		{
			if(statuSignMC != null){
				removeChild(statuSignMC);
				statuSignMC=null;
			}
		}
		
		private function cleanMyText():void
		{
			if(myText != null){
				removeChild(myText);
				myText=null;
			}
		}
		
		public function set backgroundField(value:String):void
		{
			
			if (value == _backgroundField)
				return;
			
			_backgroundField = value;
			bgChanged = true;
			
			invalidateProperties();
			
			
		}
		
		
		override protected function commitProperties():void{
			super.commitProperties();
			if (bgChanged)
			{
				bgChanged = false;
				
				if (backgroundField)
				{
					try
					{
						if (backgroundField in data && data[backgroundField] != null)
							setBackgroundSource(data[backgroundField]);
						else
							setBackgroundSource(null);
					}
					catch(e:Error)
					{
						setBackgroundSource(null);
					}
				}
				
				
			}
			addStatuSign();
			createLabelTextDisplay();
		}
		
		private function addStatuSign():void{
			if(data[statuTerm] == "A" || data[statuTerm] == "" || data[statuTerm] == undefined) return;
			if(data[statuTerm] == "R" || data[statuTerm] == "Z"){
				var d:Class = getDefinitionByName(data[statuSign]) as Class;
				statuSignMC = new d;
				//addChild(statuSignMC);
				addChildAt(statuSignMC,1);
				if(data[statuTerm] == "Z")
				{
					statuSignMC.x = 200;
				}else{
					statuSignMC.x = 173;
				}
				
				statuSignMC.y = 19;
				data[statuTerm] == "";
			}
		}
		
		private function setBackgroundSource(_source:String):void{
			cleanBG();
			if(_source){
				var c:Class = getDefinitionByName(_source) as Class;
				
				bg = new c;
				
				addChildAt(bg,0);
				
				bg.x = Number(data[backgroundX]);
				bg.y = Number(data[backgroundY]);
				
				
			}else{
				
				
				
			}
			
		}
		
		private function cleanBG():void{
			if(bg&&bg.parent){
				removeChild(bg);
			}
			
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			layoutContents(unscaledWidth, unscaledHeight);
			
			
			if(preSelected!=selected&&data[itemRelation] != "father"){
				if(selected){
					setBackgroundSource(getStyle("itemSelectionImage"));
				}else{
					
					if(data[itemRelation] != "father"){
						setBackgroundSource(data[backgroundField]);
					}
					
				}
				
				preSelected = selected;
				
			}else if(data[itemRelation] == "father"){
				
				//selected&&
				if(data[fatherOpenState] == "true"){
					setBackgroundSource(getStyle("selectionImage"));
				}else{
					setBackgroundSource(data[backgroundField]);
				}
				
			}
			
		}
		
		public function get myLabelText():String
		{
			return _myLabelText;
		}
		public function set myLabelText(value:String):void
		{
			_myLabelText = value;
		}
		
		private function createLabelTextDisplay():void{
			if(data[itemRelation] == null || data[myLabelText] == null) return;
			
			myText = new StyleableTextField;
			myText.text = data[myLabelText];
			myText.selectable = false;
			myText.embedFonts = true;
			if(data[itemRelation] == "father")
			{
				myText.filters = [new GlowFilter(0x1387B3,1,5,5,50,1)];
				myText.x = 75;
				myText.y = 11;
				
			}else{
				myText.x = 20;
				myText.y = 16;
			}
			addChild(myText);

			var tf:TextFormat = new TextFormat();
			tf.bold = null;
			
			if(data[itemRelation] == "father")
			{
				tf.color = 0xF3F3F3;
				tf.font  = "HuaKanT";
				tf.size  = 30;
			}else{
				tf.color = 0x0F688A;
				tf.font  = "HeiTi";
				tf.size  = 20;
			}
			myText.setTextFormat(tf);
		}
	}
}