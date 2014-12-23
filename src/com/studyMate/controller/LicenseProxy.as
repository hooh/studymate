package com.studyMate.controller
{
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class LicenseProxy extends Proxy
	{
		public static const NAME:String = "LicenseProxy";
		
		
		public function LicenseProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		public function getLicensFile():File{
			var filePort:String = Global.getSharedProperty(ShareConst.PORT);
			
			var file:File;
			if(Global.getSharedProperty(ShareConst.NETWORK_ID)==1){
				file=Global.document.resolvePath("EDU_4112_License.properties");
			}else{
				file=Global.document.resolvePath("EDU_8820_License.properties");
			}
			
			
			return file;
			
		}
		
		public function getLicense():LicenseVO{
			
			var file:File = getLicensFile();
			var license:LicenseVO;
			if(file.exists){
				
				var stream:FileStream = new FileStream();
				stream.open(file,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				var arr:Array = str.split("\n");
				
				stream.close();
				
				if(arr.length==3){
					license = new LicenseVO(null,arr[0],arr[1],arr[2]); 
				}
				
			}
			
			return license;
			
			
		}
		
		
		
		
		
	}
}