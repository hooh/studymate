package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.vo.TestLearnVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	internal class TestLearnListMediator extends ScreenBaseMediator
	{
		private var title:TextField ;
		public static const NAME:String = "TestLearnListMediator";
		private var vo:SwitchScreenVO;
		private var list:List;
		private var listCollection:ListCollection;
		
		public function TestLearnListMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void
		{
			super.onRemove();
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			var texture:Image = new Image(Assets.getTexture("indexRateBg"));
			texture.blendMode = BlendMode.NONE;
			texture.touchable = false;
			view.addChild(texture);	
			
			
			var texture1:Image = new Image(Assets.getTexture("alertRateBg"));
			texture1.touchable = false;
			texture1.x = 206;
			texture1.y = 18;
			view.addChild(texture1);	
			
			switch(vo.data.type){
				case 'word':
					title = new TextField(210,56,'学单词测评',"HuaKanT",30,0xFFFFFF);
					
					break;
				case 'read':
					title = new TextField(210,56,'英语阅读测评',"HuaKanT",30,0xFFFFFF);
					break;
				default:
					title = new TextField(260,56,'学习综合测评',"HuaKanT",30,0xFFFFFF);
					break;
			}
			
			title.x = 550;
			title.y = 36;
			view.addChild(title);
									
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 52;		
			layout.paddingBottom =100;
			
			list = new List();
			list.x = 241;
			list.y = 103;
			list.width = 912;
			list.height = 608;
			list.layout = layout;
			list.itemRendererType = TestLearnItemRenderer;
			view.addChild(list);
			
			this.backHandle = quitHandler;
			
			var file:File = vo.data.file;
			if(!file.exists){
				return;
			}
			if(CacheTool.has(NAME,'ListCollection')){
				listCollection =  CacheTool.getByKey(NAME,"ListCollection") as ListCollection;
			}else{				
				var stream:FileStream = new FileStream();
				stream.open(file,FileMode.READ);				
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				stream.close();	
				var tempArr:Array = str.split('\r\n');			
				
				var len:int = tempArr.length;
				listCollection = new ListCollection();
				for(var i:int=0;i<len;i++){
					var item:TestLearnVO = new TestLearnVO();
					item.title = tempArr[i];
					item.rate = '';
					listCollection.push(item);
				}
				
				CacheTool.put(NAME,'ListCollection',listCollection);
			}
			
			
			
			
			list.dataProvider = listCollection;
			
			if(CacheTool.has(NAME,'vertical')){
				list.verticalScrollPosition = CacheTool.getByKey(NAME,"vertical") as Number;
			}
			list.addEventListener( Event.CHANGE, list_changeHandler );
			
		}
		
		private function quitHandler():void{//先停止消息后，再退出	
			if(CacheTool.has(NAME,'ListCollection')){
				CacheTool.clr(NAME,'ListCollection');
			}
			if(CacheTool.has(NAME,'vertical')){
				CacheTool.clr(NAME,'vertical')
			}
			listCollection = null;
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.POP_SCREEN);
			
		}
		
		private function list_changeHandler():void
		{
			CacheTool.put(NAME,'vertical',list.verticalScrollPosition);//保存滚动坐标
			var item:TestLearnVO = list.selectedItem as TestLearnVO;
			var rrl:String;
			var data:Object;
			switch(vo.data.type){
				case 'word':					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("word ","TestLearnListMediator",0));

					rrl = item.title.split('\t')[0];
					if(StringUtil.trim(rrl)=='') return;
					data ={rrl:rrl,item:item}
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RATE_WordLearningBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("word end","TestLearnListMediator",0));

					break;
				case 'read':
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("read  ","TestLearnListMediator",0));

					rrl = 'yy.R.'+item.title.split(' ')[0];
					if(StringUtil.trim(item.title.split(' ')[0])=='') return;
					data ={rrl:rrl,item:item};
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RATE_ReadBGMediator,data),new SwitchScreenVO(CleanCpuMediator)]);
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("read  end","TestLearnListMediator",0));

					break;
			}
			
		}		
		
		
		private function wordLearnTestHandler():void
		{
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests();
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}