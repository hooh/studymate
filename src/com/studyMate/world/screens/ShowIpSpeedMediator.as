package com.studyMate.world.screens
{
	import com.mylib.framework.model.CheckSocketProxy;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.world.model.IPSpeedMediator;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ShowIpSpeedMediator extends Mediator
	{
		public static var NAME:String = "ShowIpSpeedMediator";
		private var btn:Sprite;
		private var holder:Sprite;
		private var i:int = 0;
		
		private var ckeckSocketProxy:CheckSocketProxy;
		private var checkTips:TextField;
		
		public function ShowIpSpeedMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.IP_SPEED_RESULT:
				{
					var ipVO:IPSpeedVO = notification.getBody() as IPSpeedVO;
					var item:IpItemSprite = new IpItemSprite(ipVO);
//					item.btn.addEventListener(MouseEvent.CLICK, choiceHandler);
					item.x = 5; item.y = 40 + i * (40 + 5);
					i++;
					holder.addChild(item);
					break;
				}
				case WorldConst.IP_SPEED_COMPLETE:
					
					checkTips.text = "";
					
					break;
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.IP_SPEED_RESULT,WorldConst.IP_SPEED_COMPLETE];
		}
		
		override public function onRegister():void
		{
			ckeckSocketProxy = new CheckSocketProxy();
			facade.registerProxy(ckeckSocketProxy);
			
			var titleFormat:TextFormat = new TextFormat("HeiTi",22,0xffffff,true);
			titleFormat.align = TextFormatAlign.CENTER;
			
			view.graphics.lineStyle(1);
			view.graphics.beginFill(0x00AA8F);
			view.graphics.drawRect(0,0,350,435);
			view.graphics.endFill();
			
			view.graphics.lineStyle(1);
			view.graphics.beginFill(0xD62F2A);
			view.graphics.drawRect(0,0,350,35);
			view.graphics.endFill();
			
			var title:TextField = new TextField();
			title.text = "网络测速";
			title.setTextFormat(titleFormat);
			title.width = 350; title.height = 35;
			title.mouseEnabled = false;
			view.addChild(title);
			
			btn = new Sprite();
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0xfcaf42);
			btn.graphics.drawRect(0,0,35,35);
			btn.graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = "关闭";
			tf.x = 5; tf.y = 10;
			
			tf.mouseEnabled = false;
			tf.height = 40;
			btn.addChild(tf);
			btn.addEventListener(MouseEvent.CLICK, closeHandler);
			btn.x = 315; btn.y = 0;
			view.addChild(btn);
			
			btn = new Sprite();
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0xfcaf42);
			btn.graphics.drawRect(0,0,35,35);
			btn.graphics.endFill();
			tf = new TextField();
			tf.text = "刷新";
			tf.x = 5; tf.y = 10;
			
			tf.mouseEnabled = false;
			tf.height = 40;
			btn.addChild(tf);
			btn.addEventListener(MouseEvent.CLICK, frushHandler);
			btn.x = 0; btn.y = 0;
			view.addChild(btn);
			
			i = 0;
			
			holder = new Sprite();
			view.addChild(holder);
			
			checkTips = new TextField();
			checkTips.x = 5; 
			checkTips.y = 400;
			checkTips.width = 250;
			checkTips.mouseEnabled = false;
			checkTips.height = 40;
			view.addChild(checkTips);
			
			
			/*sendNotification(WorldConst.IP_CMP_SPEED);*/
			ckeckSocketProxy.startCheck();
			checkTips.text = "正在努力为您测速，请耐心等待...";
		}
		
		protected function frushHandler(event:MouseEvent):void
		{
			sendNotification(WorldConst.DISPOSE_CHECK_SOCKET);
			
			ckeckSocketProxy = new CheckSocketProxy();
			facade.registerProxy(ckeckSocketProxy);
			
			holder.removeChildren();
			i = 0;
			/*sendNotification(WorldConst.IP_CMP_SPEED);*/
			ckeckSocketProxy.startCheck();
			checkTips.text = "正在努力为您测速，请耐心等待...";
		}
		
		private function closeHandler(event:MouseEvent):void{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		
/*		private function choiceHandler(event:MouseEvent):void{
			var ip:IPSpeedVO = ((event.target as Sprite).parent as IpItemSprite).ip;
			sendNotification(CoreConst.CONFIG_IP_PORT,[ip.host, ip.port, 5]);
//			socket.host = ip.host;
//			socket.port = ip.port;
		}*/
		
		override public function onRemove():void
		{
			/*facade.removeMediator(IPSpeedMediator.NAME);*/
			sendNotification(WorldConst.DISPOSE_CHECK_SOCKET);
			
			view.removeChildren();
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}