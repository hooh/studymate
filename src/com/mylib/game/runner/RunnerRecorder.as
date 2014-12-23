package com.mylib.game.runner
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class RunnerRecorder extends Proxy
	{
		public var data:Vector.<int>;
		
		public function RunnerRecorder(name:String)
		{
			reset();
			super(name);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		public function reset():void{
			data = new Vector.<int>;
		}
		
		public function jump(x:int):void{
			data.push(x);
			data.push(OperType.JUMP);
		}
		
		public function die(x:int):void{
			data.push(x);
			data.push(OperType.DIE);
		}
		
		public function save():void{
			var str:String=data.toString();
			
			
			var file:File = Global.document.resolvePath(Global.localPath+"UserRunner.data");
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeMultiByte(str,PackData.BUFF_ENCODE);
			fileStream.close();
		}
		
		public function read(path:String=null):Vector.<int>{
			
			var str:String="";
			
			var file:File;
			
			if(path){
				file = Global.document.resolvePath(Global.localPath+path);
			}else{
				file = Global.document.resolvePath(Global.localPath+"UserRunner.data");
			}
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file,FileMode.READ);
			str = fileStream.readMultiByte(fileStream.bytesAvailable,PackData.BUFF_ENCODE);
			data = Vector.<int>(str.split(","));
			
			fileStream.close();
			
			
			return data;
			
		}
		
		
		
	}
}