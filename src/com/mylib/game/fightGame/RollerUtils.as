package com.mylib.game.fightGame
{
	public class RollerUtils
	{
		public function RollerUtils()
		{
		}
		
		public static function setChartByProperty(chart:CircleChart,property:String):void{
			
			var arr:Array = property.split(";");
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var arrItem:Array = (arr[i] as String).split(",");
				
				if(int(arrItem[0])>360){
					chart.addSector(int(arrItem[0])-360,int(arrItem[1]),CircleChart.ADV_ATT);
				}else if(int(arrItem[0])>=0&&int(arrItem[1])>=0){
					chart.addSector(int(arrItem[0]),int(arrItem[1]),CircleChart.BASE_ATT);
				}else if(int(arrItem[0])<=0&&int(arrItem[0])>-360){
					chart.addSector(-int(arrItem[0]),Math.abs(arrItem[1]),CircleChart.BASE_DEF,0.5);
				}else{
					chart.addSector(-int(arrItem[0])-360,Math.abs(arrItem[1]),CircleChart.ADV_DEF,0.5);
				}
				
			}
			
		}
		
		
		public static function setRollerByProperty(roller:CircleRoller,property:String):void{
			
			var arr:Array = property.split(";");
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				var arrItem:Array = (arr[i] as String).split(",");
				
				
				roller.addRange(arrItem[0],arrItem[1]);
				
			}
			
		}
		
		
		
		public static function getRollerValueByProperty(value:int,property:String,def:String=null):int{
			
			
			var arr:Array = property.split(";");
			var result:int = 0;
			var lastResult:int=0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var arrItem:Array = (arr[i] as String).split(",");
				var isDouble:Boolean;
				
				if(int(arrItem[0])<360){
					isDouble = false;
				}else{
					arrItem[0]=arrItem[0]-360;
					isDouble = true;
				}
				
				
				if(int(arrItem[0])<value&&(int(arrItem[0])+int(arrItem[1])>value)){
					
					if(def){
						arr = def.split(";");
						var isDefDouble:Boolean;
						var defValue:int=0;
						var defArrItem:Array;
						for (var j:int = 0; j < arr.length; j++) 
						{
							defArrItem = (arr[j] as String).split(",");
							defArrItem[0] = Math.abs(defArrItem[0]);
							defArrItem[1] = Math.abs(defArrItem[1]);
							if(defArrItem[0]>360){
								defArrItem[0] = defArrItem[0] -360;
								isDefDouble = true;
							}else{
								isDefDouble = false;
							}
							
							
							if(defArrItem[0]<value&&(defArrItem[0]+defArrItem[1]>value)){
								
								if(isDefDouble){
									defValue = 2;
								}else{
									defValue = 1;
								}
								
							}
							
						}
					}
					
					
					if(isDouble){
						lastResult = 2-defValue;
					}else{
						lastResult = defValue>0?0:1;
					}
					
					if(lastResult>result){
						result = lastResult;
					}
					
					
				}
				
			}
			
			
			return result;
		}
		
		
		
		
		
	}
}