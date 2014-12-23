package com.mylib.game.card
{
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PlayerCardsChooser extends Sprite
	{
		private var rollers:Vector.<CardRoller>;
		private var template:CardRollerItem;
		private var dir:int;
		private var texture:Texture;
		protected var _result:Vector.<CValue>;
		public var addValue:int;
		
		public function PlayerCardsChooser(template:CardRollerItem,dir:int=1)
		{
			this.template = template;
			this.dir = dir;
			addValue = 0;
			_result = new Vector.<CValue>;
		}
		
		public function roll():void{
			var i:int;
			for (i = 0; i < rollers.length; i++) 
			{
				rollers[i].roll();
			}
			
			
		}
		
		public function getResult():Vector.<CValue>{
			_result.length = 0;
			
			for (var i:int = 0; i < rollers.length; i++) 
			{
				
				_result.push(rollers[i].result);
			}
			
			return _result;
			
		}
		
		
		
		
		public function refresh(_data:Vector.<CValue>,addValue:int):void{
			
			var i:int;
			this.addValue = addValue;
			if(rollers){
				texture.dispose();
				texture = CardRoller.genTexutre(_data,template,addValue);
				
				for (i = 0; i < rollers.length; i++) 
				{
					rollers[i].data = _data;
					rollers[i].refresh(texture);
				}
			}else{
				
				var roller:CardRoller;
				texture = CardRoller.genTexutre(_data,template,addValue);
				rollers = new Vector.<CardRoller>;
				for (i = 0; i < 3; i++) 
				{
					roller = new CardRoller(_data,texture,template.width,template.height,dir,2+i,3+i);
					rollers.push(roller);
					addChild(roller);
					roller.x = template.width*i;
				}
				
			}
			
			
			
			
			
		}
		
		
	}
}