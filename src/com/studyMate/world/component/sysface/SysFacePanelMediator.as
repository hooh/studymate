package com.studyMate.world.component.sysface
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import myLib.myTextBase.interfaces.ITextInput;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	
	public class SysFacePanelMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "SysFacePanelMediator";
		
		private var mainSp:Sprite ;
		private var pareVO:SwitchScreenVO;
		
		private var iTextInpu:ITextInput;
		private var currentIndex:int;
		
		public function SysFacePanelMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			Starling.current.stage.touchable = true;
			iTextInpu = null;
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);	//文字输入
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.onRemove();
		}
		override public function onRegister():void{
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			Starling.current.stage.touchable = false;
			var facePanelClass:Class = AssetTool.getCurrentLibClass("face_panel");			
			mainSp = new facePanelClass();			
			view.addChild(mainSp);
			mainSp.name = NAME;
			Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler,false,1);	//文字输入
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode==Keyboard.BACK){
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}
		}
		
		private function stageClickHandler(e:MouseEvent):void{	
			var arr_obj:Array = Global.stage.getObjectsUnderPoint(new Point(Global.stage.mouseX, Global.stage.mouseY));
			var hasClicked:Boolean = finditem(arr_obj[arr_obj.length - 1]);//查询是否点击到键盘
			
			if(!hasClicked){
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}else{
				if(e.target is SimpleButton){
					e.stopImmediatePropagation();
					var str:String ='/:'+ e.target.name.substr(1);
					iTextInpu.setFocus();
					
					if(iTextInpu.maxChars != 0 && iTextInpu.text.length>=iTextInpu.maxChars ){
						return;
					}
					
					if(iTextInpu.selectionAnchorPosition!=currentIndex){//如果光标位置改变，判断条件为光标末尾不等于长度
						currentIndex = iTextInpu.selectionAnchorPosition;				
					}
					iTextInpu.insertText(str);				
					currentIndex+=str.length;
					iTextInpu.selectTextRange(currentIndex,currentIndex);
					
				}
				
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}
			
		}
		/**
		 * -------当前点击显示列表，是否包含键盘组件 ，true点击到键盘，false没有点击到键盘 --------------*/				
		private function finditem(target:*):Boolean{
			if(target == null){
				return false;
			}
			if ((target.name==NAME)){
				return true;//点击到				
			}else{
				if(target.parent is Stage)	return false;//没有点击到,可以关闭
				else	return finditem(target.parent);						
			}
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			pareVO = vo;
			
			iTextInpu = pareVO.data as ITextInput;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);

		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}