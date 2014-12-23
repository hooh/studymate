package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.p2p.P2pProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.world.model.vo.CutSignVO;
	
	import flash.text.TextField;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class LsjTestMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "LsjTestMediator";
		
		public static const TEST_TEXT:String = NAME + "TestText";
		public static const TEST_TRACE:String = NAME + "TestTrace";
		
		private var vo:SwitchScreenVO;
		
		private var p2pProxy:P2pProxy;
		
		public function LsjTestMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			Starling.current.stage.color = 0xFFFFFF;
			
			//测试P2P语音
//			p2pProxy = new P2pProxy;
//			facade.registerProxy(new P2pProxy);
//			
			init();
			
			
			
			cutInit();
			
		}
		
		private var btn1:Button;
		private var btn2:Button;
		private var btn3:Button;
		private var inforText:TextField;
		private var traceText:TextField;
		private function init():void{
			
			btn1 = new Button;
			btn1.label = "测试1";
			btn1.width = 100;
			btn1.height = 50;
			btn1.x = 100;
			btn1.y = 200;
			btn1.addEventListener(Event.TRIGGERED,btn1Handle);
			view.addChild(btn1);
			
			
			btn2 = new Button;
			btn2.label = "测试2";
			btn2.width = 100;
			btn2.height = 50;
			btn2.x = 250;
			btn2.y = 200;
			btn2.addEventListener(Event.TRIGGERED,btn2Handle);
//			view.addChild(btn2);
			
			btn3 = new Button;
			btn3.label = "测试3";
			btn3.width = 100;
			btn3.height = 50;
			btn3.x = 400;
			btn3.y = 200;
			btn3.addEventListener(Event.TRIGGERED,btn3Handle);
//			view.addChild(btn3);
			
			inforText = new TextField();
			inforText.width = 250;
			inforText.height = 350;
			inforText.x = 1000;
			inforText.y = 100;
			inforText.border = true;
			inforText.multiline = true;
//			Global.stage.addChild(inforText);
			
			traceText = new TextField();
			traceText.width = 250;
			traceText.height = 350;
			traceText.x = 700;
			traceText.y = 100;
			traceText.border = true;
			traceText.multiline = true;
//			Global.stage.addChild(traceText);
			
		}
		
		private function btn1Handle():void{
			trace("点击了：btn1");
			
//			p2pProxy.doConnect("student1", "hh");
			
			showEditSp();
			
		}
		
		private function btn2Handle():void{
			trace("点击了：btn2");
			
			p2pProxy.doConnect("yy", "student1");
//			p2pProxy.subClient();
			
//			facade.removeProxy(P2pProxy.NAME);
//			if(p2pProxy){
//				p2pProxy.close();
//			}
		}
		
		private function btn3Handle():void{
			
			p2pProxy.doConnect("hh", "student1");
		}
		
		
		private function cutInit():void{
			
			contSp.x = 10;
			contSp.y = 300;
			view.addChild(contSp);
			
			editSp.x = 250;
			editSp.y = 100;
			view.addChild(editSp);
			
			
			dealText();
		}
		
		private var contSp:Sprite = new Sprite;
		private var editSp:Sprite = new Sprite;
		
		private var longText:String = "Spring Festival is.the most importantand popular festival in China Before Spring Festival the people usually clean and decorate their houses";
		private var textArr:Array = [];
		
		private var cutSignList:Vector.<CutSignVO> = new Vector.<CutSignVO>;
		
		//切分文章
		private function dealText():void{
			longText.replace(/[ ,.]/g, " ");
			//切分算法，可优化
//			textArr = longText.split(" ");
			textArr = longText.split(" ");
			trace("得到什么");
			
//			showEditSp();
			
			showConSp();
		}
		
		
		private function showEditSp():void{
			var btn:Button;
			
			var preX:int = 0;
			var preY:int = 0;
			for (var i:int = 0; i < textArr.length; i++) 
			{
				btn = new Button();
				btn.label = textArr[i];
				btn.width = 20*textArr[i].length;
				btn.height = 50;
				btn.x = preX+30;
				btn.y = preY;
				
				preX = btn.x + btn.width;
				
				if(btn.x > 560){
					preX = 0;
					preY += 100;
				}
			
				editSp.addChild(btn);
				
			}
			
			btn.alpha = 0.5;
		}
		
		
		
		private var b1:Button;
		private var b2:Button;
		private var b3:Button;
		private var b4:Button;
		private function showConSp():void{
			b1 = new Button;
			b1.label = "/";
			b1.width = 100;
			b1.height = 50;
			b1.addEventListener(Event.TRIGGERED,b1Handle);
			contSp.addChild(b1);
			
			b2 = new Button;
			b2.label = "()";
			b2.width = 100;
			b2.height = 50;
			b2.y = 70;
			b2.addEventListener(Event.TRIGGERED,b2Handle);
			contSp.addChild(b2);
			
			b3 = new Button;
			b3.label = "[]";
			b3.width = 100;
			b3.height = 50;
			b3.y = 140;
			b3.addEventListener(Event.TRIGGERED,b3Handle);
			contSp.addChild(b3);
			
			b4 = new Button;
			b4.label = "X";
			b4.width = 100;
			b4.height = 50;
			b4.y = 210;
			b4.addEventListener(Event.TRIGGERED,b4Handle);
			contSp.addChild(b4);
			
		}
		private function b1Handle():void{
			
		}
		private function b2Handle():void{
			
		}
		private function b3Handle():void{
			
		}
		private function b4Handle():void{
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case TEST_TEXT:
					
					inforText.text = notification.getBody() as String;
					
					break;
				case TEST_TRACE:
					
					traceText.text = notification.getBody() as String;
					
					break;
				
				
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TEST_TEXT,TEST_TRACE];
		}
		
		
		
		
		
		
		
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			if(p2pProxy){
				p2pProxy.close();
			}
			
			facade.removeProxy(P2pProxy.NAME);
		}
		
	}
}