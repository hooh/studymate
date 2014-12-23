package com.studyMate.world.screens.offPictureBook
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.screens.EBookNewView2Mediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class OffEbookNewView2Mediator extends EBookNewView2Mediator
	{
		public const NAME:String = 'OffEbookNewView2Mediator';
		public function OffEbookNewView2Mediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = NAME;
		}
		
		override protected function checkPic():void
		{
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			viewVO = vo;
			
			var item:Object = viewVO.data;
			_vec = new Vector.<UpdateListItemVO>;
//			var _itemAs:UpdateListItemVO = new UpdateListItemVO('',item.asPath,'','');
//			_itemAs.hasLoaded = true;			
//			_vec.push(_itemAs);//as文件
			
			var _itemSwf:UpdateListItemVO;
			
			for(var i:int=0;i<item.swfPath.length;i++){
				_itemSwf = new UpdateListItemVO("",item.swfPath[i],"","");
				_itemSwf.hasLoaded = true;
				_vec.push(_itemSwf);//swf文件
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec,PRE_PARE,null,true));
		}
		override protected function backEvent(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.ESCAPE || event.keyCode == 16777238){
				event.preventDefault();			
				event.stopImmediatePropagation();
				sendNotification(WorldConst.POP_SCREEN);
			}else{				
				super.backEvent(event);
			}
		}
		override protected function alertTips():void
		{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		
	}
}