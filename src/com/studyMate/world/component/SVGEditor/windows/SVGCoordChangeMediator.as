package com.studyMate.world.component.SVGEditor.windows
{
	import com.greensock.TweenLite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.PropertyVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	public class SVGCoordChangeMediator extends SVGBasePannelMediator
	{
		
		public static const NAME:String = "SVGCoordChangeMediator";
		
		private var pareVO:SwitchScreenVO;
		
		private var mainSp:Sprite;
		private var upBtn:SimpleButton;
		private var downBtn:SimpleButton;
		private var leftBtn:SimpleButton;
		private var rightBtn:SimpleButton;
		
		public function SVGCoordChangeMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			var pageClass:Class = AssetTool.getCurrentLibClass("SVGCoordChange");
			mainSp = new pageClass;
			view.addChild(mainSp);
			mainSp.alpha = 0.5;
			
			upBtn = mainSp.getChildByName("upBtn") as SimpleButton;
			downBtn = mainSp.getChildByName("downBtn") as SimpleButton;
			leftBtn = mainSp.getChildByName("leftBtn") as SimpleButton;
			rightBtn = mainSp.getChildByName("rightBtn") as SimpleButton;
			
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN,upHandler);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,leftHandler);
			rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,rightHandler);
			
			upBtn.addEventListener(MouseEvent.MOUSE_UP,stop);
			downBtn.addEventListener(MouseEvent.MOUSE_UP,stop);
			leftBtn.addEventListener(MouseEvent.MOUSE_UP,stop);
			rightBtn.addEventListener(MouseEvent.MOUSE_UP,stop);
			
			upBtn.addEventListener(MouseEvent.MOUSE_OUT,stop);
			downBtn.addEventListener(MouseEvent.MOUSE_OUT,stop);
			leftBtn.addEventListener(MouseEvent.MOUSE_OUT,stop);
			rightBtn.addEventListener(MouseEvent.MOUSE_OUT,stop);
			super.onRegister();
		}
		
		private function stop(e:MouseEvent):void{
			
			TweenLite.killDelayedCallsTo(changeCoord);
		}
		
		protected function rightHandler(event:MouseEvent):void
		{
			var propertyVO:PropertyVO = new PropertyVO('x','5');
			changeCoord(propertyVO);
			
		}
		
		protected function leftHandler(event:MouseEvent):void
		{
			var propertyVO:PropertyVO = new PropertyVO('x','-5');
			changeCoord(propertyVO);
		}
		
		protected function downHandler(event:MouseEvent):void
		{
			var propertyVO:PropertyVO = new PropertyVO('y','5');
			changeCoord(propertyVO);
		}
		
		protected function upHandler(event:MouseEvent):void
		{
			var propertyVO:PropertyVO = new PropertyVO('y','-5');
			changeCoord(propertyVO);
		}
		
		private function changeCoord(propertyVO:PropertyVO):void{
			
			
			
			sendNotification(SVGConst.COORD_CHANGE,propertyVO);
			TweenLite.delayedCall(0.2,changeCoord,[propertyVO]);
		}
		
		override public function onRemove():void
		{
			TweenLite.killDelayedCallsTo(changeCoord);
			view.removeChildren();
			super.onRemove();
		}
		
		override protected function svg_handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SVGConst.RESET_COORD:
					pareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
					break;
			}
		}
		
		override protected function svg_listNotificationInterests():Array
		{
			return [SVGConst.RESET_COORD];
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			super.prepare(vo);
		}
		
	}
}