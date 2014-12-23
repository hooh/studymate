package com.studyMate.view.component.myDrawing.styles
{
	import com.studyMate.view.component.myDrawing.CreateStyleFactory;
	
	import flash.text.TextField;
	
	public class CreatorStyleUnderline extends CreateStyleFactory
	{
		private var target:TextField;
		private var type:String;
		
		public function CreatorStyleUnderline(_target:TextField,_type:String)
		{
			super(_target);
			target = _target;
			type = _type;
		}
		
		override protected function factoryMethodStyle():StyleBase
		{
			return new StyleSeting(target,type);
		}
		
	}
}