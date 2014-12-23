package com.mylib.game.runner
{
	import flash.utils.getTimer;

	public class RunnerAI
	{
		public var target:Runner;
		public var runner:Runner;
		private var lastUpdateTime:int;
		private var nextUpdateTimePeriod:int;
		
		public function RunnerAI(target:Runner,runner:Runner)
		{
			this.target = target;
			this.runner = runner;
			lastUpdateTime = getTimer();
			nextUpdateTimePeriod = 2000;
		}
		
		public function update():void{
			if(getTimer()-lastUpdateTime>nextUpdateTimePeriod){
				if(target.isEnd){
					return;
				}
				var dis:int = target.position-runner.position;
				if(dis>200){
					runner.acc = Math.random()*3+1;
				}else if(dis<-600){
					runner.acc = -Math.random()*3-1;
				}else{
					runner.acc = Math.random()*4;
					runner.acc *= Math.random()>0.5?1:-1;
				}
				
				nextUpdateTimePeriod = Math.random()*2000+2000;
				lastUpdateTime = getTimer();
			}
			
			
			
		}
		
	}
}