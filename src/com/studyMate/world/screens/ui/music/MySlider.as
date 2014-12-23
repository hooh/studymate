package com.studyMate.world.screens.ui.music
{
	import fl.controls.Slider;
	
	public class MySlider extends Slider
	{
		public function MySlider()
		{
			super();
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			thumb.setSize(43,43);
			track.setSize(262,14);
		}
		
		
		
		
	}
}