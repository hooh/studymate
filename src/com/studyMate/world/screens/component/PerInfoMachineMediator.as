package com.studyMate.world.screens.component
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PerInfoMachineMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "PerInfoMachineMediator";
		private var bone0:Bone0;
		private var bone1:Bone1;
		
		private var segWidthMin:Number;
		private var segWidthMax:Number;
		private var segHeightMin:Number;
		
		public function PerInfoMachineMediator( viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function onRegister():void{				
			bone0 = new Bone0();
			bone1 = new Bone1();//电视机
			bone0.x = 500;//中心点
			bone0.y = 500;
			
			var point:Point = reach(bone1,bone0.x+bone0.segmentWidth,22);
			reach(bone0, point.x, point.y);
			bone1.x =bone0.getPin().x;
			bone1.y = bone0.getPin().y;
			
			view.addChild(bone0);
			view.addChild(bone1);
			
			bone1.addEventListener(TouchEvent.TOUCH, bone1TouchHandler);
			
			segWidthMin = bone0.x-bone0.segmentWidth;
			segWidthMax = bone0.x + bone1.segmentWidth;
		}

		private var useClick:Boolean;
		private function bone1TouchHandler(e:TouchEvent):void{
			var target:DisplayObject = e.currentTarget as DisplayObject;
			var touch:Touch=e.getTouch(target);
			if(touch){
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						useClick = true;
						break;
					case TouchPhase.MOVED:						
						if(touch.globalX>bone0.x ){
							useClick = false;
							var point:Point = reach(bone1,touch.globalX,touch.globalY);
							reach(bone0, point.x, point.y);
							bone1.x =bone0.getPin().x;
							bone1.y = bone0.getPin().y;
						}
						break;
					case TouchPhase.ENDED:
						if(useClick) clickHandler();
						break;
				}
			}			
		}

		/**--------------------------存放调用个人信息界面事件-----------------------*/
		private function clickHandler():void{
			trace("打开个人界面");
		}
		private function reach(segment:IBone, xpos:Number, ypos:Number):Point{
			var dx:Number = xpos - (segment as Image).x;
			var dy:Number = ypos - (segment as Image).y;
			var angle:Number = Math.atan2(dy, dx);
			(segment as Image).rotation = angle;
			var w:Number = segment.getPin().x - (segment as Image).x;
			var h:Number = segment.getPin().y - (segment as Image).y;
			var tx:Number = xpos - w;
			var ty:Number = ypos - h;
			return new Point(tx, ty);
		}

		
		override public function onRemove():void{
			super.onRemove();
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				
			}			
		}
		
		override public function listNotificationInterests():Array{
			return [];
		}
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			//prepareVO = vo;
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);						
		}
	}
}

import flash.geom.Point;

import starling.display.Image;
import starling.textures.Texture;


interface IBone{
	function getPin():Point;
}
class Bone0 extends Image implements IBone{
	public var segmentWidth:Number = 40;
	public function Bone0(){
		var texture:Texture = Assets.getWhaleInsideTexture("ui/perBone2");
		super(texture);
	}
	public function getPin():Point{
		this.pivotX = 5;
		this.pivotY = 11;
		var angle:Number = this.rotation;
		var xPos:Number = this.x + Math.cos(angle) * segmentWidth;
		var yPos:Number = this.y + Math.sin(angle) * segmentWidth;
		return new Point(xPos, yPos);
	}
}
class Bone1 extends Image implements IBone{
	public var segmentWidth:Number = 194;	
	public function Bone1(){
		var texture:Texture = Assets.getWhaleInsideTexture("ui/perBone3");
		super(texture);
	}	
	public function getPin():Point{
		this.pivotX = 14;
		this.pivotY = 54;
		var angle:Number = this.rotation;
		var xPos:Number = this.x + Math.cos(angle) * segmentWidth;
		var yPos:Number = this.y + Math.sin(angle) * segmentWidth;
		return new Point(xPos, yPos);
	}
}

