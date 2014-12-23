package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.view.EasyDownloadView;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import com.studyMate.utils.MyUtils;

	public class EasyDownloadMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "EasyDownloadMediator";
		
		private const yesHandler:String = NAME + "yesHandler";
		
		public function EasyDownloadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			view.confirm.addEventListener(MouseEvent.CLICK,confirmHandle);
			
			
			view.ipBtn4.addEventListener(MouseEvent.CLICK,netBtnHandle);
			view.ipBtn5.addEventListener(MouseEvent.CLICK,netBtnHandle);

			
			MyUtils.checkOS();
			
			view.ipBtn5.selected = true;
			netBtnHandle(null);
		}
		override public function onRemove():void{			
			super.onRemove();			
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case CoreConst.UPDATE_READY:
					var updateVO:UpdateListVO = notification.getBody() as UpdateListVO;
					sendNotification(CoreConst.UPDATE_ASSETS,updateVO);
					break;
				case CoreConst.UPDATE_COMPLETE:
					sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
					var str:String = "程序已恢复，请退出后重新打开";
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,false,yesHandler));
					/*SkinnableAlert.show("程序已恢复，请退出后重新打开","完成",SkinnableAlert.OK,null,
						function():void{
							NativeApplication.nativeApplication.exit();
						}
					);*/					
					break;
				case yesHandler:
					Global.isUserExit = true;
					NativeApplication.nativeApplication.exit();
					break;
			}
		}
		
		private function netBtnHandle(event:MouseEvent):void{
			
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			var xmlReader:IPReaderProxy = facade.retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var array:Array;var ipname:String;
			if(view.ipBtn5.selected){
				ipname = "telecom";
			}else if(view.ipBtn4.selected){
				ipname = "unicom";
			}
			array = xmlReader.getValueByKeys(IPReaderProxy.IP_INFO_FILE, ["ip",ipname,"host",null,"port",null,"networkId",null]);
			if(array != null){
				socket.host = array[0];
				socket.port = parseInt(array[1]);
				Global.networkId = parseInt(array[2]);
			}else{
				socket.host = "121.33.246.212";
				socket.port = 8820;
				Global.networkId = 5;
			}
			
		}
		
		private function confirmHandle(event:MouseEvent):void{
			
			Global.user = view.userName.text;
			Global.password = view.password.text;
			
			var updateType:String;
			Global.hasLogin = false;
			sendNotification(CoreConst.SOCKET_INIT,[false,"AB","f"]);
			
		}
		
		override public function listNotificationInterests():Array{
			return [CoreConst.UPDATE_READY,CoreConst.UPDATE_COMPLETE,yesHandler];
		}
		
		override public function get viewClass():Class{
			return EasyDownloadView;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{									
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}				
		public function get view():EasyDownloadView{
			return getViewComponent() as EasyDownloadView;
		}
	}
}