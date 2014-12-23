package com.mylib.framework.model
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class OperRecordProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "OperRecordProxy";
		private var file:File = Global.document.resolvePath(Global.localPath+"operRecord.txt");
		private var stream:FileStream = new FileStream();
		
		public function OperRecordProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		
		
		
		public function record(vo:RecordVO):void{
			try
			{
				stream.open(file,FileMode.APPEND);
				var d:Date = Global.nowDate;
				
				if(d){
					var str:String = d.fullYear+"-"+(d.month+1)+"-"+d.date+"-"+d.hours+":"+d.minutes+":"+d.seconds+" "+vo.cmd+" "+vo.mark+" "+vo.num;
					stream.writeMultiByte(str,PackData.BUFF_ENCODE);
					stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
					stream.close();
					
					saveBigFile();
					
				}else{
					stream.close();
				}
				
			} 
			catch(error:Error) 
			{
				
			}
			
			
		}
		
		private function saveBigFile():void{
			if(file.exists&&file.size>900000){
				var d:Date = Global.nowDate;
				var f:File = new File(Global.document.nativePath+"/"+Global.localPath+"records/operRecord_"+d.getFullYear()+d.getMonth()+d.getDate()+d.getHours()+d.getMinutes()+d.getSeconds()+".txt");
				file.moveTo(f);
			}
			
		}
		
	}
}