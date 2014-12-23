package com.studyMate.module.engLearn.ui
{
	import com.studyMate.world.component.gridList.ListExtends;
	
	
	/**
	 * note
	 * 2014-10-28下午3:22:22
	 * Author wt
	 *
	 */	
	
	public class ListExtendEnableUI extends ListExtends
	{
		private var nextBoo:Boolean;
		public static const ScrollPageEvent:String = 'ScrollPageEvent';
		
		public function ListExtendEnableUI()
		{
			super();
		}
		override protected function throwToPage(targetHorizontalPageIndex:int=-1, targetVerticalPageIndex:int=-1, duration:Number=0.5):void
		{
			dispatchEventWith(ScrollPageEvent);
			super.throwToPage(targetHorizontalPageIndex, targetVerticalPageIndex, duration);
			this.selectedIndex = targetHorizontalPageIndex;
		}
		/*override protected function throwToPage(targetHorizontalPageIndex:int=-1, targetVerticalPageIndex:int=-1, duration:Number=0.5):void
		{
			if(nextBoo || targetHorizontalPageIndex<=this.horizontalPageIndex){
				super.throwToPage(targetHorizontalPageIndex, targetVerticalPageIndex, duration);
			}else{
				super.throwToPage(horizontalPageIndex, targetVerticalPageIndex, duration);

			}
		}
		
		public function set enableNext(value:Boolean):void{
			nextBoo = value;
		}*/
	}
}