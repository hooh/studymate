package com.mylib.framework.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ScriptCompleteVO;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.world.script.LayoutTool;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import utils.FunctionQueueEvent;
	import com.studyMate.utils.LayoutToolUtils;
	
	public final class SimpleScriptNewProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SimpleScriptNewProxy";
		private var scriptExecuseVO:ScriptExecuseVO;
		
		public function SimpleScriptNewProxy( data:Object=null)
		{
			super(NAME, data);
			
			LayoutToolUtils.pageQueue.dispatcher.addEventListener(FunctionQueueEvent.ALL_FUNCTION_COMPLETE,pageCompleteHandle);
			LayoutToolUtils.pageQueue.dispatcher.addEventListener(FunctionQueueEvent.EXECUSE_COMPLETE,functionStartHandle);
			
			
			LayoutToolUtils.commandQueue.dispatcher.addEventListener(FunctionQueueEvent.ALL_FUNCTION_COMPLETE,pageCompleteHandle);
			LayoutToolUtils.commandQueue.dispatcher.addEventListener(FunctionQueueEvent.EXECUSE_COMPLETE,functionStartHandle);
			
		}
		
		public  function pageCompleteHandle(event:FunctionQueueEvent):void{
			
			LayoutTool.destroy();
			
			LayoutTool.completePage();
			
			
			var completeType:String;
			
			if(LayoutToolUtils.queue == LayoutToolUtils.pageQueue){
				completeType = "page";
			}else{
				completeType = "command";
			}
			
			if(completeType=="page"){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SCRIPT_COMPLETE,new ScriptCompleteVO(true));
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.COMMAND_SCRIPT_COMPLETE,new ScriptCompleteVO(true));
				LayoutToolUtils.queue = LayoutToolUtils.pageQueue;
				LayoutToolUtils.queue.execuse();
			}
			
		}
		
		private function functionStartHandle(event:FunctionQueueEvent):void{
			LayoutTool.lastFun = event.vo;
			LayoutTool.nextFun = event.nextVO;
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(ApplicationFacade.SCRIPT_COMPLETE,event.vo);
		}
		//在PAGE标签里面的第一个函数前面插入initPage标签函数
		private function insertInitPageScript(_pageScript:Array):void{
			var ss:String = LayoutToolUtils.script.join(",");
			if(ss.indexOf("<"+LayoutTool.initPageTag+">")!=-1){
				var initPageScriptArr:Array = getTabScript(LayoutTool.initPageTag);
				initPageScriptArr = initPageScriptArr.reverse();
				for(var i:int=0;i<initPageScriptArr.length;i++){
					_pageScript.unshift(initPageScriptArr[i]);
				}
			}
		}
		
		private var isReverse:Boolean = false;
		public  function execusePage(vo:ScriptExecuseVO):void{
			scriptExecuseVO = vo;
			
			//MyUtils.functionTimeLine.addEventListener(TweenEvent.COMPLETE,MyUtils.pageCompleteHandle);
			
			var script:Array;
			
			var completeType:String;
			
			if(vo.pageNo is uint){
				LayoutToolUtils.queue = LayoutToolUtils.pageQueue;
				script = getPageScript(vo.pageNo);
				completeType = "page";
				isReverse = false;
				
				//插入initPage里面的函数到最前面
				insertInitPageScript(script);
				
			}else{
				LayoutToolUtils.queue = LayoutToolUtils.commandQueue;
				script = getTabScript(vo.pageNo);
				completeType = "command";
				isReverse = true;
				
				
			}
			
			if(script.length==0){
				LayoutTool.lastFun = null;
				
				if(completeType=="page"){
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SCRIPT_COMPLETE,new ScriptCompleteVO(true));
				}else{
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.COMMAND_SCRIPT_COMPLETE,new ScriptCompleteVO(true));
				}
				
			}else{
				
				
				execuseScript(script);
			}
			
			
		}
		
		
		public function execuseScript(scriptArr:Array):void{
			
			var itemArr:Array;
			var f:Function;
			var parameters:Array;
			var item:String;	
			var tweens:Array = [];
			var jumpflag:Boolean;
			
			jumpflag = scriptExecuseVO.jump;
			
			
			var fun1:String;
			var paraStr:String;
			
			
			if(isReverse){
				scriptArr = scriptArr.reverse();
			}
			for (var i:int=0;i<scriptArr.length;i++) 
			{
				item = scriptArr[i];
				itemArr = item.split(":");
				
				fun1 = itemArr.shift();
				paraStr = itemArr.join(":");
				
				if ( jumpflag && ( fun1=='Break') ) break;
				
				f = LayoutTool[fun1];
				
				if(f!=null){
					parameters = paraStr.split("`");
					
					if(isReverse){
						
						LayoutToolUtils.queue.addWithArrAtFirst(f,parameters);
					}else{
						LayoutToolUtils.queue.addWithArr(f,parameters);
						
					}
					
				}
			}
			//}
			
			LayoutToolUtils.jump = scriptExecuseVO.jump;
			if(scriptExecuseVO.doInit){
				LayoutTool.initPage();
			}
			LayoutToolUtils.queue.execuse();
			LayoutToolUtils.jump = false;
			
		}
		
		public static function getTabScript(tab:String):Array{
			return getScriptByTab("<"+tab+">","</"+tab+">",LayoutToolUtils.script);
		}
		
		public static function getPageCustomScript(_page:int,tab:String):Array{
			
			var commands:Array = getPageScript(_page);
			
			if(commands.length>0){
				return getScriptByTab("<"+tab+">","</"+tab+">",Vector.<String>(commands));
			}else{
				return commands;
			}
			
			
		}
		
		
		public static function getPageScript(_page:uint):Array{
			
			return getScriptByTab("<PAGE"+_page+">","<ENDPAGE>",LayoutToolUtils.script);
		}
		
		public static function getScriptByTab(sTab:String,eTab:String,source:Vector.<String>):Array{
			
			var indexStr:String;
			
			indexStr = sTab;
			
			
			var result:Array=[];
			var startIdx:int=-1;
			for (var i:int = 0; i < source.length; i++) 
			{
				if(source[i].indexOf(indexStr)>=0){
					startIdx=i+1;
					break;
				}
			}
			
			if(startIdx>0){
				
				for (i = startIdx; i < source.length; i++) 
				{
					if(source[i]==eTab){
						break;
					}
					
					result.push(source[i]);
				}
			}
			
			return result;
			
			
		}
		
		
		
		public static function getTotalPage():uint{
			
			
			var total:uint = 0;
			for each (var i:String in LayoutToolUtils.script) 
			{
				
				if(i=="<ENDPAGE>"){
					total++;
				}
			}
			
			
			return total;
			
			
			
			
			
		}
		
		
		
		
		
		
	}
}