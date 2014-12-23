package 
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * note
	 * 2014-12-2下午2:34:11
	 * Author wt
	 *
	 */	
	
	public class CmdRigister
	{
		private static var file:File = Global.document.resolvePath(Global.localPath + "allTestData.txt");
		
		public function CmdRigister()
		{
		}
		/**
		 * 插入输入数据 
		 * @param arr
		 */		
		public static function inExe(arr:Array):void{
			initXML();
			if(arr.length>=2){
				var paras:Array = arr.concat();	
				
				paras.shift();
				paras.shift();
				var cmd:String = paras.shift();
				var root:XML = readXML();
				var config:XMLList = root.cmd;
				var needInsert:Boolean = true;
				var len:int = config.length();
				for(var i:int=0; i < len; i++){
					if(config[i].@name == cmd){//如果已经有了就不用插入了
						needInsert = false;						
						break;
					}
				}
				if(needInsert){
					var cmdXML:XML = new XML(<cmd name={cmd}>
												<in ignore="true"/>																 
												<out/>
											</cmd>);
					root = root.appendChild(cmdXML);
					for(var j:int=0;j<paras.length;j++){
						var newnode:XML = new XML();
						if(paras[j].length>12){							
							cmdXML.child('in').appendChild(<slot>超长串(超出12)</slot>);
						}else{
							cmdXML.child('in').appendChild(<slot>{paras[j]}</slot>);
						}
					}					
					writeXML(root.toXMLString());
				}
			}
		}
		
		/**
		 * 插入输出数据
		 * @param arr
		 */		
		public static function outExe(cmd:String,data:DataResultVO):void{
			if(data.result){				
				var arr:Array = data.result.concat();
				
				initXML();
				var root:XML = readXML();
//				if(data.para==null || data.para[0]=='') return;
//				var cmd:String = data.para[0].completeNotice;
				
				var config:XMLList = root.cmd;
				var needInsert:Boolean;
				var len:int = config.length();
				for(var i:int=0; i < len; i++){
					if(config[i].@name == cmd){//如果已经有了就不用插入了
						var outXMLList:XMLList = config[i].child('out');
						if(outXMLList.length()<=0){
							for(var j:int=0;j<arr.length;j++){
								needInsert = true;
								var newnode:XML = new XML();
								if(arr[j].length>200){							
									outXMLList.appendChild(<slot>超长串(超出200)</slot>);
								}else{
									outXMLList.appendChild(<slot>{arr[j]}</slot>);
								}
							}					
						}	
						break;
					}
				}
				if(needInsert){
					writeXML(root.toXMLString());
				}
			}
		}
		
		private static function initXML():void{
			if(!file.exists){
				var initxml:XML = <testData></testData>;
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeMultiByte(initxml.toXMLString(), PackData.BUFF_ENCODE);
				stream.close();
			}
		}
		
		private static function readXML():XML{
			if(file.exists){
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				stream.close();;
				var root:XML = XML(str);
				if(str=='') root = <testData></testData>;
				return root;
			}
			return <testData></testData>;
		}
		
		private static function writeXML(str:String):void{
			var stream:FileStream = new FileStream();
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(str, PackData.BUFF_ENCODE);
			stream.close();
		}
	}
}