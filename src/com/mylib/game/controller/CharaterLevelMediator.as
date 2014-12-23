package com.mylib.game.controller
{
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class CharaterLevelMediator extends Mediator implements IMediator
	{
		public static const NAME :String = "CharaterLevelMediator";
		
		
		private var dealEquipMap:HashMap;
		private var idlist:Array;
		
		public function CharaterLevelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			idx = 0;
			
			dealEquipMap = new HashMap;
			idlist = new Array;
			
		}
		
		private var idx:int = 0;
		private function getListLevel():void{
			
			if(idx < idlist.length){
				
				sendNotification(WorldConst.GET_STD_FNLVL, idlist[idx]);
				
				return;
			}
			
			
			//结束
			
			sendNotification(WorldConst.GET_LEVEL_LIST_COMPLETE, dealEquipMap);
			
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.GET_LEVEL_LIST:
					idx = 0;
					dealEquipMap = notification.getBody()[0] as HashMap;
					idlist = notification.getBody()[1] as Array;
					
					
					getListLevel();
					
					break;
				case WorldConst.GET_STD_FNLVL_COMPLETE:
					
					if(dealEquipMap.containsKey(idlist[idx])){
						
						var _equip:String = dealEquipMap.find(idlist[idx]);
						dealEquipMap.remove(idlist[idx]);
						dealEquipMap.insert(idlist[idx],[_equip,PackData.app.CmdOStr[1]]);
						
						
					}
					trace("取等级========================================="+idlist[idx]+":"+PackData.app.CmdOStr[1]);
					
					idx++;
					getListLevel();
					
					break;
				
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.GET_LEVEL_LIST,WorldConst.GET_STD_FNLVL_COMPLETE];
		}
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
		}
	}
}