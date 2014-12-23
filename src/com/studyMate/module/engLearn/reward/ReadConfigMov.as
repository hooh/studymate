package com.studyMate.module.engLearn.reward
{
	import com.studyMate.module.engLearn.vo.RewardVO;
	
	/**
	 * note
	 * 2014-12-5下午4:01:32
	 * Author wt
	 *
	 */	
	
	public class ReadConfigMov
	{
		public function ReadConfigMov()
		{
		}
		
		/**
		 * 解析配置文件列表 
		 * @param vo
		 * @return 配置文件数组
		 */		
		public static function getMov(vo:RewardVO):Array{
			var config:ConfigMov = new ConfigMov();
			var arr:Array = [];
			for(var key:int in config.dic){
				arr.push(key);
			}
			key = binarysearchKey(arr,vo.rate);
			var obj:Array = config.dic[key];
			
			/*var type:String = 'a';
			if(vo.bestTime-vo.time>120){//时长120秒
				if(obj.b.length>1){
					type = 'b';
				}
			}*/
//			var targetType:Array = obj[type];
			var index:int = Math.random()*obj.length;
			var resultArr:Array = obj[index];
//			trace('result');
			return resultArr;
		}
		
		
		private static function binarysearchKey(arr:Array,targetNum:int):int{
			arr.sort(Array.NUMERIC);
//			for (var i:int = 0; i < arr.length; i++) {  
//				trace(arr[i]);  } 
			var targetindex:int = 0;  
			var left:int = 0, right:int = 0;  
			for (right = arr.length-1; left!=right;) {  
				var midIndex:int = (right + left)/2;  
				var mid:int = (right - left);  
				var midValue:int = arr[midIndex]; 
				if (targetNum == midValue) {  
					return targetNum;  
				} 
				if(targetNum > midValue){  
					left = midIndex;  
				}else{  
					right = midIndex;  
				}  
				
				if (mid <=1) {  
					break;  
				}  
			}
			var rightnum:int =  arr[right];  
			var leftnum:int =  arr[left];  
			var ret:int =  Math.abs((rightnum - leftnum)/2) > Math.abs(rightnum -targetNum) ? rightnum : leftnum;  
//			trace("和要查找的数："+targetNum+ "最接近的数：" + ret);  
			return ret
			
		}
		
		
	}
}