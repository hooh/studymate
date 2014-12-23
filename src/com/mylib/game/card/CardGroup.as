package com.mylib.game.card
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	

	public class CardGroup
	{
		public var groupData:Vector.<GameCharaterData>;
		public var idx:uint;
		public var displays:Vector.<CardPlayerDisplay>;
		public var range:Rectangle;
		public var dirX:int;
		
		public var hp:int;
		
		public var values:Vector.<CValue>;
		
		public var isUpdateValue:Boolean;
		
		public function CardGroup()
		{
			idx = 0;
			values = new Vector.<CValue>(5);
			
			for (var i:int = 0; i < values.length; i++) 
			{
				values[i] = new CValue(i+1,0);
			}
			
			
			
		}

		
		public function reset():void{
			
			if(groupData){
				groupData.length = 0;
			}
			
			if(displays){
				displays.length = 0;
			}
			
			for (var i:int = 0; i < values.length; i++) 
			{
				values[i].value=0;
			}
			
			hp = 0;
			
			idx = 0;
			
		}
		
		public function refreshValue():void{
			
			if(!isUpdateValue){
				isUpdateValue = true;
				
				for (var i:int = 0; i < groupData.length; i++) 
				{
					var player:GameCharaterData = groupData[i];
					for (var j:int = 0; j < player.values.length; j++) 
					{
						var card:CValue = groupData[i].values[j];
						
						values[card.type-1].value+=card.value;
					}
				}
			}
		}
		
		

	}
}