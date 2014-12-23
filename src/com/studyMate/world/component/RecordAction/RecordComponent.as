package com.studyMate.world.component.RecordAction
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class RecordComponent
	{
		private var file:File;
		
		public function RecordComponent()
		{
			
			
		}
		
		
		private var clickBX:Number;
		private var clickBY:Number;
		private var clickEX:Number;
		private var clickEY:Number;
		private var isClickDown:Boolean = false;
		public function startRecrod():void{
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,recordKeyHandle);
			
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, recordDownHandle);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, recordUpHandle);
			
//			file = Global.document.resolvePath(Global.localPath+"TestScript/"+getScreen()+".txt");
//			file = Global.document.resolvePath(Global.localPath+"TestScript/Series/0.txt");
			file = Global.document.resolvePath(Global.localPath+"TestScript/tmpScript.txt");
			
			cleanFile();
		}
		public function stopRecord():void{
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,recordKeyHandle);
			
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN, recordDownHandle);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP, recordUpHandle);
		}
		public function moveFile(toView:String):void{
			if(file.exists){
				var _fileTmp:Array = new Array;
				var _file:File = Global.document.resolvePath(Global.localPath + "TestScript/"+toView+"/");
				if(_file.exists){
					_fileTmp = _file.getDirectoryListing();
				}
				
				var f:File = Global.document.resolvePath(Global.localPath+"TestScript/"+toView+"/"+_fileTmp.length+".txt");
				file.moveTo(f);
			}
			
		}
		
		
		
		private function recordDownHandle(e:MouseEvent):void{
			if(e.target is SimpleButton || e.target is RecordActionSprite || isClickDown){
				return;
			}
			
			isClickDown = true;
			clickBX = e.stageX;
			clickBY = e.stageY;
			
		}
		private function recordUpHandle(e:MouseEvent):void{
			if(e.target is SimpleButton || e.target is RecordActionSprite || !isClickDown){
				return;
			}
			
			clickEX = e.stageX;
			clickEY = e.stageY;
			var result:String = "";
			
			//50像素内范围移动，判断为点击事件， 否则为移动事件
			if(Math.abs(clickEX-clickBX) <= 50 && Math.abs(clickEY-clickBY) <= 50){
				result = getTap(e.stageX, e.stageY);
				
			}else{
				//移动
				result = getSwipe(clickBX,clickBY,clickEX,clickEY);
				
			}
			
			writeFile(result);
			isClickDown = false;
			
		}
		private function recordKeyHandle(e:KeyboardEvent):void{
			var result:String = "";
			//后退
			if(e.keyCode == Keyboard.BACK || e.keyCode == Keyboard.ESCAPE){
				result = getKeyevent(Keyboard.BACK);
				
			}
			writeFile(result);
		}
		public function addDelay():void{
			
			writeFile("sleep 1s");
		}
		
		
		
		private function getTap(x:int, y:int):String{
			var str:String = "input tap " + x.toString() + " " + y.toString();
			trace("======================================="+str);
			return str;
			
		}
		private function getKeyevent(code:uint):String{
			var str:String;
			
			if(code == Keyboard.BACK || code == Keyboard.ESCAPE){
				str = "input keyevent 4";
				trace("======================================="+str);
				return str;
			}
			trace("======================================="+str);
			return "";
		}
		private function getSwipe(bx:int, by:int, ex:int, ey:int):String{
			var str:String = "input swipe " + bx.toString() + " " + by.toString() + " "+ ex.toString() + " " + ey.toString();;
			trace("======================================="+str);
			return str;
		}
		
		
		
		
		private function getScreen():String{
			if(Facade.getInstance(CoreConst.CORE).hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)
				&&(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen){
				return (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName();
			}
			return "tmp"+(new Date);
		}
		
		private var stream:FileStream = new FileStream();
		private function writeFile(str:String):void{
			try
			{
				stream.open(file,FileMode.APPEND);
				
				stream.writeMultiByte(str+"\r\n",PackData.BUFF_ENCODE);
				stream.close();
				
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		private function cleanFile():void{
			try
			{
				stream.open(file,FileMode.WRITE);
				
				stream.writeMultiByte("",PackData.BUFF_ENCODE);
				stream.close();
				
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function dispose():void{
			
			stopRecord();
			
			
		}
	}
}