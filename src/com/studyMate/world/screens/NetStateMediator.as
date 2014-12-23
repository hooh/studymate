package com.studyMate.world.screens
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.NetStateProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.runner.RunnerGlobal;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.component.NetStateItemRender;
	
	import flash.desktop.NativeApplication;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Graphics;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class NetStateMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "NetStateMediator";
		
		private var vo:SwitchScreenVO;
		private var tipsTF:Label;
		
		private var ckeckSocketProxy:NetStateProxy;
		
		private var fastvo:IPSpeedVO = new IPSpeedVO("-1","-1",0,int.MAX_VALUE);	//优先推荐网络
		
		private var alert:Alert;
		private var is10Call:Object;
		
		public function NetStateMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			is10Call = vo.data;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			
			ckeckSocketProxy = new NetStateProxy();
			facade.registerProxy(ckeckSocketProxy);
			
			readIplist();
			
			initBg();
			
			initList();
			
			
		}
		private function initBg():void{
			
			var bg:Graphics = new Graphics(view);
			bg.lineStyle(1);
			bg.beginFill(0x286785);//0x99CCFF  //0x286785  //0x1a4458
			bg.drawRect(0,0,630,375);
			bg.endFill();
				
			bg.lineStyle(2);	
			bg.moveTo(0,50);
			bg.lineTo(630,50);
			
			bg.lineStyle(1,0x455f9f);
			bg.beginFill(0xffffff);//0x99CCFF  //0x286785  //0x1a4458
			bg.drawRect(20,72,590,238);
			bg.endFill();
			
			/*var title:Label = new Label(130,30,"网络测速","",23,0xffffff);*/
			var title:Label = new Label();
			title.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			title.textRendererProperties.textFormat = new TextFormat( "Verdana", 23, 0xffffff, null, null, null,null,null, TextFormatAlign.CENTER);
			title.width = 130;
			title.height = 40;
//			title.x = 185;
			title.x = 250;
			title.y = 10;
			title.text = "网络测速";
			view.addChild(title);
			
			
			tipsTF = new Label();
			tipsTF.width = 630;
			tipsTF.height = 23;
			tipsTF.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			tipsTF.textRendererProperties.textFormat = new TextFormat( "Verdana", 13, 0xffffff, null, null, null,null,null, TextFormatAlign.CENTER);
			tipsTF.textRendererProperties.isHTML = true;
//			tipsTF.text = "根据网络测速结果，建议您选择 <font color='#ffa200' size='13'>\"电信\"</font> 入口登录系统，祝您使用愉快";//ffa200
			
			if(is10Call){
				tipsTF.text = "十分抱歉！网络出现问题，请测试网络并重新选择网络入口，或者点击关闭退出系统";
			}else{
				tipsTF.text = "尊敬的用户，您好! 如需使用<font color='#ffa200' size='13'>\"网页认证\"</font>，请先进行测速检查网络";
			}
			
			tipsTF.y = 310;
			view.addChild(tipsTF);
			
			
			selectBtn = new Button;
			selectBtn.label = "选择网络";
			selectBtn.width = 100;
			selectBtn.height = 38;
//			selectBtn.x = 70;
			selectBtn.x = 135;
			selectBtn.y = 335;
			selectBtn.isEnabled = false;
			selectBtn.addEventListener(Event.TRIGGERED,selectBtnHandle);
			view.addChild(selectBtn);
			
			webBtn = new Button;
			webBtn.label = "网页认证";
			webBtn.width = 100;
			webBtn.height = 38;
//			webBtn.x = 200;
			webBtn.x = 265;
			webBtn.y = 335;
			webBtn.isEnabled = false;
			webBtn.addEventListener(Event.TRIGGERED,webBtnHandle);
			view.addChild(webBtn);
			
			checkBtn = new Button;
			checkBtn.label = "开始测速";
			checkBtn.width = 100;
			checkBtn.height = 38;
//			checkBtn.x = 330;
			checkBtn.x = 395;
			checkBtn.y = 335;
			checkBtn.addEventListener(Event.TRIGGERED,checkBtnHandle);
			view.addChild(checkBtn);
			
			
			
			var closeBtn:Button = new Button;
			closeBtn.label = "X";
//			closeBtn.x = 450;
			closeBtn.x = 580;
			closeBtn.width = 50;
			closeBtn.height = 50;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
		}
		private var selectBtn:Button;
		private var checkBtn:Button;
		private var webBtn:Button;
		
		private var list:List;
		private var data:ListCollection = new ListCollection;
		private function initList():void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 35;
			layout.paddingBottom = 35;
			
			
			list = new List;
			list.x = 20;
			list.y = 72;
//			list.width = 460;
			list.width = 590;
			list.height = 238;
			list.layout = layout;
			list.allowMultipleSelection = false;
			list.itemRendererType = NetStateItemRender;
			list.verticalScrollPolicy =  Scroller.SCROLL_POLICY_ON;
			list.addEventListener( Event.CHANGE, itemClickHandle );
			view.addChild(list);
			
			
			list.dataProvider = data;
			
		}
		
		private function itemClickHandle(e:Event):void{
			selectBtn.isEnabled = true;
			selectBtn.label = "确认";
		}
		
		private function selectBtnHandle():void{
			
			if(is10Call){
				sendNotification(WorldConst.CHECK_TO_RELOGIN, list.selectedItem as IPSpeedVO);
				
			}else{
				sendNotification(WorldConst.SELECT_IN_PORT, list.selectedItem as IPSpeedVO);
				
			}
			
			//退出界面
			doClose();
			
		}
		
		private function webBtnHandle():void{
			//电信、联通都连不上
			MyUtils.webUsingTime = 300;
			
			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service","exeCommands",["iptables -P OUTPUT ACCEPT"]);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WebBrowserMediator)]);
			
			
		}
		
		private function checkBtnHandle():void{
			//重置数据
			for (var i:int = 0; i < data.length; i++) 
			{
				(data.getItemAt(i) as IPSpeedVO).timeout  = -1;
				(data.getItemAt(i) as IPSpeedVO).checkState = -1;
				(data.getItemAt(i) as IPSpeedVO).speed = -1;
				data.updateItemAt(i);
			}
			
			list.selectedIndex = -1;
			selectBtn.isEnabled = false;
			selectBtn.label = "选择网络";
			list.isEnabled = false;
			//还原
			fastvo.name = "-1";
			fastvo.timeout = int.MAX_VALUE;
			
			if(ckeckSocketProxy)
			{
				checkBtn.isEnabled = false;
				ckeckSocketProxy.startCheck();
			}
		}
		
		private function updateTips():void{
			
			
			
		}
		
		
		
		private function closeBtnHandle():void{
			
			if(is10Call){
				
				
				alert = Alert.show( "确定退出系统吗？", '温馨提示', new ListCollection(
					[
						{ label: "确定",triggered:function exit():void{
							sendNotification(CoreConst.FLOW_RECORD,new RecordVO("10 relogin fail, Choose Exit","SystemNotificationMediator",0));
							NativeApplication.nativeApplication.exit();} },
						{ label: "取消" }
					]));
				
			}else{
				
				doClose();
				
				
			}
			
			
		}
		private function doClose():void{
			//检查中，禁止退出
			if(ckeckSocketProxy && ckeckSocketProxy.isChecking){
				
				alert = Alert.show( "正在为您测速，请耐心等待测试结果", "温馨提示", new ListCollection(
					[
						{ label: "好的"}
					]));
				
			}else{
				if(is10Call){
					var netstate:NetStateMediator = facade.retrieveMediator(NetStateMediator.NAME) as NetStateMediator;
					if(netstate){
						netstate.view.removeFromParent(true);
						facade.removeMediator(NetStateMediator.NAME);
					}
					
				}else{
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
				}
				
				
				
			}
		}
			
			
		
		//读取ip列表
		private function readIplist():void{
			var ipReader:IPReaderProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var ipList:XML = ipReader.getIpList();
			if(!ipList)
				return;
			
			var ips:XMLList = ipList.ip;
			for each (var ip:XML in ips) {
				var ipvo:IPSpeedVO = new IPSpeedVO(ip["name"], ip["host"], parseInt(ip["port"]), 0, ip["networkId"]);
				if(ip["networkId"] != "1")
				{
					data.push(ipvo);					
				}
			}
		}
		
		
		
		private function getDataIdx(_name:String):int{
			var len:int = data.length;
			for (var i:int = 0; i < len; i++) 
			{
				if((data.getItemAt(i) as IPSpeedVO).name == _name){
					return i;
				}
			}
			
			return 0;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.IP_SPEED_RESULT:
					var ipVO:IPSpeedVO = notification.getBody() as IPSpeedVO;
					
					var idx:int = getDataIdx(ipVO.name);
					(data.getItemAt(idx) as IPSpeedVO).checkState = 1;
					(data.getItemAt(idx) as IPSpeedVO).timeout = ipVO.timeout;
					(data.getItemAt(idx) as IPSpeedVO).stat = ipVO.stat;
					(data.getItemAt(idx) as IPSpeedVO).speed = ipVO.speed;
					data.updateItemAt(idx);
					
					//接收最快的返回
					if(ipVO.timeout != -1 && ipVO.timeout < fastvo.timeout)
					{
						fastvo.name = ipVO.name;
						fastvo.timeout = ipVO.timeout;
						
					}
					
					break;
				
				case WorldConst.IP_SPEED_CHECKING:
					ipVO = notification.getBody() as IPSpeedVO;
					
					idx = getDataIdx(ipVO.name);
					(data.getItemAt(idx) as IPSpeedVO).checkState = 0;
					(data.getItemAt(idx) as IPSpeedVO).timeout = ipVO.timeout;
					data.updateItemAt(idx);
					break;
					
					
				case WorldConst.IP_SPEED_COMPLETE:
					var _tmp:Boolean = notification.getBody() as Boolean;
					webBtn.isEnabled = !_tmp;
					if(!_tmp){
						if(tipsTF)
						{
							tipsTF.text = "十分抱歉，网络连接失败，请确保正确连接wifi，或者试试<font color='#ffa200' size='13'>\"网页认证\"</font>";//ffa200
						}
						
					}else if(fastvo.name != "-1"){
						if(tipsTF)
						{
							tipsTF.text = "根据网络测速结果，建议您选择 <font color='#ffa200' size='13'>\""+fastvo.name+"\"</font> 入口登录系统，祝您使用愉快";//ffa200
						}
						
						
					}
					
					checkBtn.isEnabled = true;
					list.isEnabled = true;
					
					//更正提示
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.IP_SPEED_RESULT,WorldConst.IP_SPEED_CHECKING,WorldConst.IP_SPEED_COMPLETE];
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
			
			facade.removeProxy(NetStateProxy.NAME);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			
			view.removeChildren(0,-1,true);
		}
	}
}