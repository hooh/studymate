package com.studyMate.module.engLearn.reward.TextLayer
{
	import com.studyMate.global.Global;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * 三颗星的评价
	 * 2014-12-9下午3:58:06
	 * Author wt
	 *
	 */	
	
	public class RewardTxt_3_0 extends Sprite implements IRewardTxt
	{
		
		public function RewardTxt_3_0()
		{
			var img:Image = new Image(Assets.getRewardTexture("tip1"));
			this.addChild(img);
			
			this.x = (Global.stageWidth - img.width)>>1;
			this.y = 612;
		}
	}
}