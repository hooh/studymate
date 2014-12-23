package com.studyMate.world.model.vo
{
	public class PlaySoundEffectVO
	{
		public var type:String;
		public var volume:Number = 1;
		
		public function PlaySoundEffectVO(type:String,volume:Number=1)
		{
			this.type = type;
			this.volume = volume;
		}
	}
}