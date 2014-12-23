package com.studyMate.controller
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class IPReaderProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "IPReaderProxy";
		private var ip_File:String = Global.localPath + "ipconfig.dat";
		private var stream:FileStream = new FileStream();
		
		public function IPReaderProxy(data:Object = null){
			super(NAME, data);
		}
		
		override public function onRegister():void{
			super.onRegister();
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		public function getIpInf(id:String):Array{
			var ipList:XML = getIpList();
			if(ipList == null) return null;
			
			var result:Array = new Array();
			
			var ip:XMLList = ipList.ip;
			for(var i:int = 0; i < ip.length(); i++){
				if(ip[i].@id != id) continue;
				result.push(String(ip[i]["host"]), parseInt(String(ip[i]["port"])), parseInt(String(ip[i]["networkId"])), String(ip[i]["name"]));
				break;
			}
			
			if(result.length <= 0) return null;
			return result;
		}
		
		public function getIpList():XML{
			var file:File = Global.document.resolvePath(ip_File);
			if(file.exists == false){
				file = File.applicationDirectory.resolvePath(ip_File);
			}
			if(file.exists == false) return null;
			
			stream.open(file, FileMode.READ);
			var str:String = stream.readMultiByte(stream.bytesAvailable, PackData.BUFF_ENCODE);
			var ipListXml:XML = XML(str);
			stream.close();
			return ipListXml;
		}
	}
}