package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import fl.controls.TextArea;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;

	public class SentenceDictionaryMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'SentenceDictionaryMediator';
		private  var prepareVO:SwitchScreenVO;
		
//		public static const SERACH_SENTENCE:String = NAME +"SERACH_SENTENCE";
		
		private var main:Sprite;
		private var startDragBtn:SimpleButton;
		private var closeBtn:Sprite;
		private var dic_title:TextArea;
		private var dic_content:TextArea;
		public function SentenceDictionaryMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			Starling.current.stage.touchable = true;
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
			main.removeChildren();
			super.onRemove();
		}
		override public function onRegister():void
		{
			Starling.current.stage.touchable = false;
			sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
			
			var bgClass:Class =  AssetTool.getCurrentLibClass("SearchScentence_UI");//右上角退出图片
			main = new bgClass;
			view.addChild(main);
		
			closeBtn = main.getChildByName("closeBtn") as Sprite;
			startDragBtn = main.getChildByName("startDragBtn") as SimpleButton;
			
			var textformat:TextFormat = new TextFormat("comic",22);
			var textformat1:TextFormat = new TextFormat("HeiTi",20);
			dic_content = main.getChildByName("dic_content") as TextArea;
			dic_content.setStyle("textFormat",textformat1);	
			dic_content.setStyle("antiAliasType",AntiAliasType.ADVANCED);
			dic_content.setStyle("upSkin",new Sprite);
			dic_content.editable = false;
			dic_content.wordWrap = true;
			
			dic_title = main.getChildByName("dic_title") as TextArea;
			dic_title.setStyle("textFormat",textformat);		
			dic_title.setStyle("antiAliasType",AntiAliasType.ADVANCED);
			dic_title.setStyle("upSkin",new Sprite);
			dic_title.editable = false;
			dic_title.wordWrap = true;						
			dic_title.text = prepareVO.data.title;
			dic_content.htmlText = prepareVO.data.content;
			
			closeBtn.addEventListener(MouseEvent.CLICK,removeHandler);
			startDragBtn.addEventListener(MouseEvent.MOUSE_DOWN,startDragMouseDownHandler);
			
			
			view.x = (Global.stage.stageWidth-view.width)/2;
			view.y = (Global.stage.stageHeight-view.height)/2;
		}
		private function removeHandler(e:Event):void{
			prepareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
		}
		protected function startDragMouseDownHandler(event:MouseEvent):void
		{
			view.startDrag();
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
		}		
		
		protected function StageMouseUpHandler(event:MouseEvent):void
		{
			view.stopDrag();
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
		}
		
		/*override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SERACH_SENTENCE:
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [SERACH_SENTENCE];
		}*/
		
		
		override public function prepare(vo:SwitchScreenVO):void{				
			prepareVO = vo;			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);			
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}