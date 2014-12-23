package myLib.soundManager
{
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	/**
	 *
	 * @author wangtu
	 * 创建时间: 2014-9-28 下午6:03:55
	 * 
	 */	
	internal class SoundManager
	{
		public var dic:Dictionary;
		
		public function SoundManager()
		{
			dic = new Dictionary();
		}
		
		public function loadSound(url:String, type:String):void{
			if(dic[type]==null){				
				var sound:SoundPlay = new SoundPlay();
				sound.url = url;
				dic[type] = sound;
			}
		}
		
		public function play(type:String, volume:Number=1, startTime:Number=0, loops:int=0):void{
			if(dic[type]){
				if(dic[type].sound){//已经实例化
					if(dic[type].soundChannel)
						dic[type].soundChannel.stop();
					var soundTransform:SoundTransform = new SoundTransform(volume);
					dic[type].soundChannel = dic[type].sound.play(startTime,loops,soundTransform);										
				}else{
					dic[type].play(dic[type].url,startTime,loops,volume);
				}
			}
		}
		
		public function removeSound(type:String):void{
			if(dic[type]){
				dic[type].stop();
				delete dic[type];
			}
		}
		
		public function removeAll():void{
			for(var id:String in dic){
				dic[id].stop();	
				delete dic[id];
			}
		}
		
		public function set volume(value:Number):void{
			if(value>=0){
				for(var id:String in dic){
					dic[id].setVolume = value;
				}
			}
						
		}
		
		public function hasSound(type:String):Boolean{
			if(dic[type]){
				return true;
			}else{
				return false;
			}
		}
		
		public function soundCompleted(type:String,fun:Function):void{
			if(dic[type]){
				dic[type].onComplete = fun;
			}
		}
		
		
	}
}