package com.studyMate.view.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.PushViewType;
	import com.studyMate.model.vo.PushViewVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.view.IPreloadMediator;
	import com.studyMate.view.KeyboardViewMediator;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableTextBase;
	import spark.components.supportClasses.StyleableTextField;
	
	import views.KeyboardView;
	import com.studyMate.utils.MyUtils;
	
	public class MyTextInputMediator extends Mediator implements IMediator, IPreloadMediator
	{
		public static const NAME:String = "MyTextInputMediator";
		private static var textInputId:int;

		public var prepareVO:PushViewVO;
		private var vokeyboard:PushViewVO;
		//private var hasBoolean:Boolean=false;
		
		public function MyTextInputMediator(viewComponent:Object=null)
		{
			textInputId++;
			super(NAME+textInputId, viewComponent);
		}
		
		override public function onRegister():void{
			view.needsSoftKeyboard = false;				
			view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);	
			view.addEventListener(MouseEvent.MOUSE_UP,Mouse_IN_Handler);
			//view.addEventListener(FocusEvent.FOCUS_OUT,Mouse_IN_Handler);//这里需要用FOCUS_OUT，因为初始的时候focus会自动进入,导致尚未点击输入框即开始加载键盘。
		}
		public function StopSoftKeyBoard():void{
			view.needsSoftKeyboard = true;
			view.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);	
			view.removeEventListener(MouseEvent.MOUSE_UP,Mouse_IN_Handler);
			
			//trace("MyUtils.view.numChildren"+MyUtils.view.);
			/*if(hasBoolean){
				trace("不会吧。还要显示啊。");
				vokeyboard.type = PushViewType.HIDE;
				sendNotification(ApplicationFacade.PUSH_VIEW,vokeyboard);
				hasBoolean = false;
			}	*/		
		}
		public function StartSoftKeyBoard():void{
			view.needsSoftKeyboard = false;				
			view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);	
			view.addEventListener(MouseEvent.MOUSE_UP,Mouse_IN_Handler);
		}
		//禁止android平板自带输入面板,并添加自定义键盘
		private function Keyboard_Activating_Handler(event:SoftKeyboardEvent):void{
			event.preventDefault();//关闭调用android键盘事件	
		}
		private function Mouse_IN_Handler(event:Event):void{
			//trace("helllo--------------------------hello");
			if(!facade.hasMediator(KeyboardViewMediator.NAME)){//如果屏幕没有键盘，则添加
				vokeyboard = new PushViewVO(KeyboardView,view,null,null,null,null,null,PushViewType.SHOW,MyUtils.view);
				sendNotification(CoreConst.PUSH_VIEW,vokeyboard);//派发添加键盘事件
				
				//hasBoolean = true;
				//trace("11111111111111111");				
			}else{
				//trace(getMediatorName());
				sendNotification(CoreConst.SWITCH_KEYBOARD_INPUT,view);
			}
		}	
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			prepareVO = null;
		}
				
		public function get view():SkinnableTextBase{
			return getViewComponent() as SkinnableTextBase;
		}
		
		public function prepare(vo:PushViewVO):void{
			prepareVO = vo;
			vo.data.toString();
			
			sendNotification(CoreConst.PREPARE_READY,vo);
		}				
	}
}