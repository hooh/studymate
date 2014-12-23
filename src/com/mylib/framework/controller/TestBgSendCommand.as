package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * 1 优先先遍历文件的。命令字列表
	 * 2 符合命令字和in条件的则插入out数组
	 * 3 向应用层派发数据。最后一条数据时插入！！！标记。
	 * 2014-11-25上午11:10:05
	 * Author wt
	 */	
	
	public class TestBgSendCommand extends BGSendCommand
	{
		private var file:File = Global.document.resolvePath(Global.localPath + "testData.txt");
		
		override public function execute(notification:INotification):void
		{
			var isSend:Boolean;//是否发送成功
			if(file.exists && (notification.getBody() is Array)){				
				var paras:Array = (notification.getBody() as Array).concat();
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				stream.close();
				var config:XMLList = XML(str).cmd;
				var outVec:Vector.<XMLList> = new Vector.<XMLList>();
				paras.shift();
				paras.shift();
				var cmd:String = paras.shift();
				var type:String;
				var len:int = config.length();
				for(var i:int=0; i < len; i++){
					if(config[i].@name == cmd){
						type = config[i].@type;
						var inXMLList:XMLList;
						inXMLList = config[i].child('in')[0].children();
						var isSame:Boolean=true;
						if(config[i].child('in')[0].@ignore=='true'){
							//整体忽略检测
							//trace("整体忽略检测:",config[i].child('in')[0].@ignore);
						}else{
							for(var m:int=0;m<inXMLList.length();m++){//检查输入参数是否完全匹配
								if(inXMLList[m].@ignore=='true'){
									//忽略元素检测
									//trace("元素忽略检测：",inXMLList[m].@ignore,'元素：',inXMLList[m].toString());
								}else{
									if(inXMLList[m].toString()!=paras[m]){
										isSame = false;
										break;
									}
								}								
							}
						}
						
						if(isSame){//匹配则发送数据
							var proxy:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
							//获取所有out节点
							var outXMLList:XMLList = config[i].child('out');
							if(outXMLList){
								outVec.push(outXMLList);
							}
						}											
					}
				}
				if(outVec.length>0){
					for(var k:int=0;k<outVec.length;k++){
						for(var j:int=0;j<outVec[k].length();j++){
							var resultVO:DataResultVO = new DataResultVO();   																			
							//遍历out节点	
							resultVO.result  = [];
							var slotXMList:XMLList = outVec[k][j].children();
							for(var n:int = 0 ;n<slotXMList.length();n++){
								if(slotXMList[n].localName()=='byte'){
									file = new File(slotXMList[n].toString());
									if(file.exists){										
										stream = new FileStream();
										stream.open(file,FileMode.READ);
										var upBytes:ByteArray = new ByteArray;
										stream.readBytes(upBytes,0,file.size);
										stream.close();
									}									
									proxy.CmdOStr[n] = upBytes;			
									resultVO.result[n] = upBytes;
								}else{									
									proxy.CmdOStr[n] = slotXMList[n].toString();			
									resultVO.result[n] = slotXMList[n].toString();
								}
							}
							resultVO.resultCnt = slotXMList.length();
							if(type =='1:1'){
								resultVO.isEnd = true;
							}
							sendNotification(CoreConst.BG_SEND_COMPLETE,resultVO);								
							isSend = true;
						}
						
						if(k == outVec.length -1 && type!='1:1'){
							proxy.CmdOStr[0] = '!!!';
							resultVO.isEnd = true;
							sendNotification(CoreConst.BG_SEND_COMPLETE,resultVO);		
						}
					}
					
				}		
			}
			
			
			if(!isSend){
				super.execute(notification);
			}
			
		}
		
	}
}