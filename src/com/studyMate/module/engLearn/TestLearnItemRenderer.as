package com.studyMate.module.engLearn
{
	import com.studyMate.module.engLearn.vo.TestLearnVO;
	import com.studyMate.world.component.BaseListItemRenderer;
	
	import flash.geom.Point;
	
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	internal class TestLearnItemRenderer extends BaseListItemRenderer
	{
		public function TestLearnItemRenderer()
		{
			super();
		}
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		
		private var titleLabel:TextField;
		private var _rateLabel:TextField;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:Quad;
		
		private const defaultAlpha:Number=0.3;
		private const setAlpha:Number = 0.5;
		
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){					
				this.bg.alpha=setAlpha;				
			}else{
				this.bg.alpha=defaultAlpha;		
			}
			
		}
		
		override protected function initialize():void
		{
			if(!this.titleLabel)
			{
				this.bg = new starling.display.Quad(800,50,0xFFFFFF);
				//this.bg.alpha = defaultAlpha;
				this.addChild(this.bg);
				this.titleLabel = new TextField(280,50,"","HeiTi",18,0x666666);
				this.titleLabel.hAlign = HAlign.LEFT;
				this.titleLabel.autoScale = true;
				this.titleLabel.touchable = false;
				this.addChild(this.titleLabel);
				
				
				this._rateLabel = new starling.text.TextField(200, 50, "0", "HeiTi", 16, 0);
				this._rateLabel.x = 500;
				this._rateLabel.touchable = false;
				this.addChild(this._rateLabel);				
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:TestLearnVO = this._data as TestLearnVO;
				this.titleLabel.text = baseClass.title;
				this._rateLabel.text = baseClass.rate;
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}
		}
		
		
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos = touch.getLocation(this);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				canPlayBoo = true;
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(this);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					canPlayBoo = false;
				}
			}else if(touch && touch.phase == TouchPhase.ENDED){
				if(canPlayBoo ){					
					isSelected = true;
					
				}
				
			}		
		}


	}
}