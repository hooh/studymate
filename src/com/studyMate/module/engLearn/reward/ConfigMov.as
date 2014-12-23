package com.studyMate.module.engLearn.reward
{
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_1_0;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_2_0;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_2_1;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_3_0;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_3_1;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_3_2;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_3_3;
	import com.studyMate.module.engLearn.reward.TextLayer.RewardTxt_3_4;
	import com.studyMate.module.engLearn.reward.centerManLayer.RAnimationMediator;
	import com.studyMate.module.engLearn.reward.particalLayer.SnowParticle;
	
	import flash.utils.Dictionary;
	
	/**
	 * note
	 * 2014-12-5下午3:48:20
	 * Author wt
	 * 配置动画参数.
	 */	
	
	public class ConfigMov
	{
		public var dic:Dictionary;
		
		public function ConfigMov()
		{
			dic = new Dictionary();
			
			dic[100] = [[SnowParticle,RAnimationMediator,RewardTxt_3_0],[SnowParticle,RAnimationMediator,RewardTxt_3_1],[SnowParticle,RAnimationMediator,RewardTxt_3_2],[SnowParticle,RAnimationMediator,RewardTxt_3_3],[SnowParticle,RAnimationMediator,RewardTxt_3_4]];
			
			
			dic[80] = [[SnowParticle,RAnimationMediator,RewardTxt_2_0],[SnowParticle,RAnimationMediator,RewardTxt_2_1]];

			dic[60] = [[SnowParticle,RAnimationMediator,RewardTxt_1_0]];

		}
		
		
	}
}