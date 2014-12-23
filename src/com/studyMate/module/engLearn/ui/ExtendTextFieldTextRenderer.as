package com.studyMate.module.engLearn.ui
{
	import feathers.controls.text.TextFieldTextRenderer;
	
	
	/**
	 * note
	 * 2014-10-31下午5:13:04
	 * Author wt
	 *
	 */	
	
	public class ExtendTextFieldTextRenderer extends TextFieldTextRenderer
	{
		public function ExtendTextFieldTextRenderer()
		{
			super();
		}
		
		override protected function refreshSnapshot():void
		{
			this._snapshotWidth += 2;
			this.actualWidth += 2;
			this._snapshotHeight += 2;
			this.actualHeight += 2;
			super.refreshSnapshot();
		}
		
	}
}