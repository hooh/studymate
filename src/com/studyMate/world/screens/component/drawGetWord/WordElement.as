package com.studyMate.world.screens.component.drawGetWord
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	
	public class WordElement extends Sprite
	{
		public function WordElement()
		{
			var zhu:Button  = new Button();
			zhu.label = "主语";
			this.addChild(zhu);
			
			var wei:Button  = new Button();
			wei.label = "谓语";
			this.addChild(wei);
			wei.x = 100;
			
			var bin:Button  = new Button();
			bin.label = "宾语";
			this.addChild(bin);
			bin.x = 200;
			
			var bu:Button  = new Button();
			bu.label = "补语";
			this.addChild(bu);
			bu.x = 300;
			
			var ding:Button  = new Button();
			ding.label = "定语";
			this.addChild(ding);
			ding.x = 400;
			
			var zhuang:Button  = new Button();
			zhuang.label = "状语";
			this.addChild(zhuang);
			zhuang.x = 500;
			
			var tong:Button  = new Button();
			tong.label = "同位语";
			this.addChild(tong);
			tong.x = 600;
		}
	}
}