package com.studyMate.module.classroom.list
{
	import com.studyMate.module.classroom.CroomVO;
	
	import starling.events.TouchEvent;
	/**
	 * 老师辅导的list
	 * @author wt
	 * 
	 */	
	public class ListClassItemSearchRenderer extends ListClassItemRenderer
	{
		public function ListClassItemSearchRenderer()
		{
			super();
		}
		
		
		
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:CroomVO = this._data as CroomVO;
				this.nameLabel.text = baseClass.crname;
				this.idLable.text = baseClass.sid;
				this.qtypeLable.text = baseClass.qtype+'('+baseClass.crid+')';
				this.qidsLable.text = baseClass.qids;
				this.stimeLable.text = baseClass.stime;
				this.flagLable.text = baseClass.surplusTips;
				if(baseClass.surplusTips == '确认辅导完毕'){					
					this.flagLable.color = 0x0000FF;
				}else{
					this.flagLable.color = 0x000000;
				}
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				
				height = this.bg.height;
			}else{
				height = 20;
			}
		}
		
		
		
	}
}