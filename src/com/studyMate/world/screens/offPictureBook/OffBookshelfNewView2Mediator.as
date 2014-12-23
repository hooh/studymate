package com.studyMate.world.screens.offPictureBook
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.LibInitializedCommand;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.controller.ExecuseScriptNewCommand;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.component.offline.FileRead;
	import com.studyMate.world.controller.HideScreenCommand;
	import com.studyMate.world.screens.BookshelfNewView2Mediator;
	import com.studyMate.world.screens.ScrollShelfPicturebook2Mediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class OffBookshelfNewView2Mediator extends BookshelfNewView2Mediator
	{
//		public const NAME:String = 'OffBookshelfNewView2Mediator';
		
		private var file:File = Global.document.resolvePath(Global.localPath + "offline/bookShelf2.ini");
		
		public function OffBookshelfNewView2Mediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = ModuleConst.OFF_BOOKSHELF_NEWVIEW2_MEDIATOR;
		}
		
		override public function onRegister():void
		{
			sendNotification(CoreConst.LOADING,false);
			facade.registerProxy(new SimpleScriptNewProxy());//新的绘本修改界面
			facade.registerCommand(WorldConst.HIDE_SCREEN,HideScreenCommand);
			facade.registerCommand(CoreConst.EXECUSE_SCRIPT_NEW,ExecuseScriptNewCommand);//新的as3的界面显示绘本
			this.backHandle = quitHandle;
			super.onRegister();
		}
		private function quitHandle():void{
			//离线绘本回退处理
			sendNotification(WorldConst.UNLOAD_WORLD_MODULE);
			facade.registerCommand(CoreConst.LIB_INITIALIZED,LibInitializedCommand);
			
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		
		override protected function picturebookHandler():void{
			var object:Object = {};
			object.txtPage = txtFiled;
			object.whichShelf = "All";
			
			
			var AllStr:String;
			var AllArr:Array;
			var infoArr:Array;
			if(!file.exists){
				AllStr = FileRead.getValue("offline/bookShelf.ini");
				if(AllStr!=''){
					AllArr = (JSON.parse(AllStr)).picbook as Array;//String转JSON
					infoArr = AllArr.filter(doEach);//本地可以用书本数组。
					var s:String = JSON.stringify(AllArr);
					var stream:FileStream = new FileStream()
					stream.open(file, FileMode.WRITE);
					stream.writeMultiByte(s,PackData.BUFF_ENCODE);
					stream.close();
				}
			}else{
				AllStr = FileRead.getValue("offline/bookShelf2.ini");
				AllArr = (JSON.parse(AllStr)) as Array;//String转JSON
				infoArr = AllArr.filter(doEach);//本地可以用书本数组。
			}
			if(infoArr){
				var len:int = infoArr.length;
				var book:BookPicture;
				var obj:Object;
				var bookArr:Array = [];
				for(var i:int=0;i<len;i++){
					book = new BookPicture();
					obj = infoArr[i]; 
					book.facePath = obj.jpg;
					book.rrlPath = obj.rrl;
					book.swfPath = obj.swf;
					book.asPath = obj.as3;
					book.hasCache = true;
					book.orderId = i;
					bookArr.push(book);
				}
				if(bookArr.length>0){					
					CacheTool.put(ScrollShelfPicturebook2Mediator.NAME,"PicturebookArr",bookArr);
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(offScrollShelfPicBookMediator,object,SwitchScreenType.SHOW,view)]);
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("本机没有离线绘本，请登录系统下载绘本.",2));
				}
			}	
		}
		
				
		//测试文件是否都存在
		private function doEach(item:Object, index:int, array:Array):Boolean{
			if(item.hasOwnProperty("jpg")){//本地文件存在
				if(item.jpg=="" || !test(item.jpg) || !test(item.as3)){//如果jpg和as3不存在则退出
					return false;
				}else{//否则继续测试swf素材
					var swfArr:Array = item.swf as Array;
					for each(var swfobj:* in swfArr){
						if(!test(swfobj)){
							return false;//如果swf脚本有一个不存在就马上退出
						}
					}
					return true;//以上均完成测试，还没退出则证明是存在的
				}				
			}else{
				return false;
			}
		}
		
		//根据相对路径查看文件是否存在
		private function test(str:String):Boolean{
			var file:File = Global.document.resolvePath(Global.localPath+str);
			if(file.exists){
				return true;//文件存在
			}else
				return false;//文件不存在
		}
		
		
		
		
	}
}