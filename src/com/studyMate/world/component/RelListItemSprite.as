package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.RelationListMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class RelListItemSprite extends Sprite
	{
		private var relListItemSpVo:RelListItemSpVO;
		
		
		private var nameTF:TextField;
		private var delBtn:Button;
		
		
		public function RelListItemSprite(_relListItemSpVo:RelListItemSpVO)
		{
			this.relListItemSpVo = _relListItemSpVo;
			
			init();
		}
		
		private function init():void{
			
			nameTF = new TextField(168,58,"","HuaKanT",23,0xa53a00);
			nameTF.text = relListItemSpVo.rstdId+"："+relListItemSpVo.realName;
			nameTF.hAlign = HAlign.LEFT;
			nameTF.vAlign = VAlign.CENTER;
			addChild(nameTF);
			
			delBtn = new Button();
			delBtn.label = "删除";
			delBtn.x = 170;
			delBtn.visible = true;
			addChild(delBtn);
			delBtn.validate();
			delBtn.y = (this.height - 35)>>1;
			delBtn.addEventListener(Event.TRIGGERED,delBtnHandle);

		}
		private function delBtnHandle():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(this.parent.parent.parent,
				this.parent.parent.parent.width>>1,this.parent.parent.parent.height>>1,doDel,"确定要删除好友 "+relListItemSpVo.realName+" ？"));
			
			
		}
		private function doDel():void{
			if(!Global.isLoading)
				Facade.getInstance(CoreConst.CORE).sendNotification(RelationListMediator.DEL_RELATE,relListItemSpVo.rstdId);
		}
		
		override public function dispose():void
		{
			super.dispose();
			delBtn.removeEventListener(Event.TRIGGERED,delBtnHandle);
			
			relListItemSpVo = null;

			removeChildren(0,-1,true);
		}

	}
}