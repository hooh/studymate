package com.studyMate.module.classroom.view
{
	import com.studyMate.global.AppLayoutUtils;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * note
	 * 2014-6-3下午5:16:04
	 * Author wt
	 *
	 */	
	
	public class DrawingBoardView extends Sprite
	{
		public var panel:Image;
		public var preBtn:Button;
		public var nextBtn:Button;
		public var penBtn:Button;
		public var penBgImg:Image;
		public var quitBtn:Button;
		
		public var setHolder:Sprite;
		private var dot:Image;
		private var blackBtn:Button;
		private var redBtn:Button;
		private var greenBtn:Button;
		private var blueBtn:Button;
		private var pinkBtn:Button;
		
		private static var _color:uint;//笔触颜色
		private static var _thickness:uint=3;//笔触大小

		
		public function DrawingBoardView()
		{
			layoutView();
			
		}

		public function get thickness():uint
		{
			return _thickness;
		}

		public function get color():uint
		{
			return _color;
		}

		override public function dispose():void
		{
			super.dispose();
		}
		
		
		private function layoutView():void{
			panel = new Image(Assets.getCnClassroomTexture('drawBoardBg'));
			penBtn = new Button(Assets.getCnClassroomTexture('penBtn'));
			preBtn = new Button(Assets.getCnClassroomTexture('prebackBtn'));
			nextBtn = new Button(Assets.getCnClassroomTexture('nextbackBtn'));
//			clearBtn = new Button(Assets.getCnClassroomTexture('clearBtn'));			
			penBgImg = new Image(Assets.getCnClassroomTexture('penbg'));
			var drawToolbg:Image = new Image(Assets.getCnClassroomTexture('drawToolbg'));
			quitBtn = new Button(Assets.getCnClassroomTexture('quitShare'));
			
			this.addChild(panel);
			drawToolbg.x = 219;
			drawToolbg.y = 671;
			penBtn.x = 0 + 224;
			penBtn.y = 676;
			preBtn.x = 77+ 224;
			preBtn.y = 676;
			nextBtn.x=142+ 224;
			nextBtn.y= 676;
//			clearBtn.x = 212+ 224;
//			clearBtn.y = 676;
			penBgImg.x = 224;
			penBgImg.y = 676;
			this.addChild(drawToolbg);
			this.addChild(penBgImg);
			penBgImg.touchable = false;
			this.addChild(penBtn);
			this.addChild(preBtn);
			this.addChild(nextBtn);
//			this.addChild(clearBtn);
			
			
			quitBtn.x = 716;
			quitBtn.y = 0;
			this.addChild(quitBtn);
			
			blackBtn = new Button(Assets.getCnClassroomTexture('stroke-black'));
			redBtn = new Button(Assets.getCnClassroomTexture('stroke-red'));
			greenBtn = new Button(Assets.getCnClassroomTexture('stroke-green'));
			blueBtn = new Button(Assets.getCnClassroomTexture('stroke-blue'));
			pinkBtn = new Button(Assets.getCnClassroomTexture('stroke-pink'));
			dot = new Image(Assets.getCnClassroomTexture('stroke-sizeDot'));
			var strokeBg:Image = new Image(Assets.getCnClassroomTexture('stroke-setbg'));
			
			setHolder = new Sprite();
			setHolder.x = 223;
			setHolder.y = 605;
			this.addChild(setHolder);			
			setHolder.addChild(strokeBg);
//			dot.x = 37;
			dot.x = 27+_thickness*10;
			dot.y = 28;
			setHolder.addChild(dot);
			blackBtn.x = 206;
			blackBtn.y = 20;
			redBtn.x = 246;
			redBtn.y = 20;
			greenBtn.x = 287;
			greenBtn.y = 20;
			blueBtn.x = 327;
			blueBtn.y = 20;
			pinkBtn.x = 368;
			pinkBtn.y = 20;
			var dotbg:Quad = new Quad(184,36);
			dotbg.y = 20;	
			dotbg.alpha = 0;
			setHolder.addChild(dotbg);
			
			blackBtn.name = '0';
			redBtn.name = '0xFF0000';
			greenBtn.name = '0x008716';
			blueBtn.name = '0x59189B';
			pinkBtn.name = '0xF700EE';
			setHolder.addChild(blackBtn);
			setHolder.addChild(redBtn);
			setHolder.addChild(greenBtn);
			setHolder.addChild(blueBtn);
			setHolder.addChild(pinkBtn);
			blackBtn.addEventListener(Event.TRIGGERED,colorHandler);	
			redBtn.addEventListener(Event.TRIGGERED,colorHandler);
			greenBtn.addEventListener(Event.TRIGGERED,colorHandler);
			blueBtn.addEventListener(Event.TRIGGERED,colorHandler);
			pinkBtn.addEventListener(Event.TRIGGERED,colorHandler);
			

			penBtn.addEventListener(Event.TRIGGERED,penHandler);
			dotbg.addEventListener(TouchEvent.TOUCH,sizeHandler);
			
			
		}
		
		
		private var pos:Point = new Point();
		private var value:int;
		private function sizeHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase == TouchPhase.MOVED){
					touchPoint.getLocation(event.target as DisplayObject,pos);					
					//trace(pos.x);
					value = pos.x;
					if(value<27){
						value = 27;
					}else if(value>150){
						value = 150;
					}
					
					
					dot.x = 27+ int((value-27)/10)*10;
					
					_thickness = (value-27)/10+1;
//					trace('_thickness',_thickness);
				}
			}
		}		
		


		
		private function penHandler():void
		{
			setHolder.visible = !setHolder.visible;
			if(setHolder.visible){
				penBgImg.visible = true;
			}else{
				penBgImg.visible = false;
			}
		}
		

		
		private function colorHandler(e:Event):void
		{
			var btn:Button = e.currentTarget as Button;
			_color = uint(btn.name);
		}		
		

	}
}