package com.studyMate.world.screens.ui
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.UserPerDataMediator;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	
	/**
	 * note
	 * 2014-12-8下午6:12:40
	 * Author wt
	 *
	 */	
	
	public class UserPerDataItemRenderer extends BaseListItemRenderer
	{
		private var typeTxt:TextField;
		private var pathTxt:TextField;
		private var dateTxt:TextField;
		
		
		private var bg:Quad;
		private const defaultAlpha:Number=0.1;
		private const setAlpha:Number = 0.3;
		
		public function UserPerDataItemRenderer()
		{
			super();
		}
		override public function dispose():void
		{
			super.dispose();
		}
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
			this.bg = new starling.display.Quad(655,48,0x0a4475);
			this.bg.alpha = 0.25;
			this.addChild(this.bg);
			this.bg.addEventListener(TouchEvent.TOUCH,BgTounchHandler);
			
			typeTxt = new TextField(80,48,'','HeiTi',16,0xFFFFFF);
			typeTxt.hAlign = HAlign.LEFT;
			typeTxt.autoScale = true;
			typeTxt.x = 46;
			typeTxt.touchable = false;
			
			pathTxt = new TextField(350,48,'','HeiTi',16,0xFFFFFF);
			pathTxt.hAlign = HAlign.LEFT;
			pathTxt.autoScale = true;
			pathTxt.x = 130;
			pathTxt.touchable = false;
			
			dateTxt = new TextField(175,48,'','HeiTi',16,0xFFFFFF);
			dateTxt.hAlign = HAlign.LEFT;
			dateTxt.autoScale = true;
			dateTxt.x = 480;
			dateTxt.touchable = false;
			
			this.addChild(typeTxt);
			this.addChild(pathTxt);
			this.addChild(dateTxt);
		}
		private var beginY:Number;
		private function BgTounchHandler(event:TouchEvent):void
		{		
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(Math.abs(touchPoint.globalY-beginY) < 20){	
						trace('点击到了');
						isSelected = true;
						
						Facade.getInstance(CoreConst.CORE).sendNotification(UserPerDataMediator.ITEM_CLICK,this._data);
					}
				}
			}
		}
		override protected function commitData():void
		{
			if(this._data)//进入过的转绿色
			{
				var type:String = this._data.path;
				var typeArr:Array = type.split(".");
				type = typeArr[typeArr.length-1];
				
				typeTxt.text = type;	
				
				type = this._data.path;
				typeArr = type.split('/');
				type = typeArr[typeArr.length-1];
				pathTxt.text = type;				
				dateTxt.text = this._data.date;
				
				this.height = 48;
			}
		}
	}
}