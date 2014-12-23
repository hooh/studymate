package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.JumpUriVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SendJumpUriCommand extends SimpleCommand
	{
		public function SendJumpUriCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:JumpUriVO = notification.getBody() as JumpUriVO;
			
			EduAllExtension.getInstance().sendURI(vo.scheme+"://jump="+vo.target+"&user="+Global.user+"&psw="+Global.password+"&host="+Global.getSharedProperty(ShareConst.IP)+"&port="+Global.getSharedProperty(ShareConst.PORT));
			
			
			
		}
		
	}
}