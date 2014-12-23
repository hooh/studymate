package com.studyMate.module.engLearn.reward.TextLayer
{
	import com.studyMate.global.Global;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-12-9下午4:41:20
	 * Author wt
	 *
	 */	
	
	public class RewardTxt_3_4 extends Sprite implements IRewardTxt
	{
		public function RewardTxt_3_4()
		{
			var img:Image = new Image(Assets.getRewardTexture("tip8"));
			this.addChild(img);
			
			this.x = (Global.stageWidth - img.width)>>1;
			this.y = 612;
		}
	}
}