package com.mylib.game.charater.logic
{
	
	import com.mylib.game.charater.BMPCharaterMediator;
	import com.mylib.game.charater.PetDogMediator;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.Sprite;
	
	public class PetFactoryProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PetFactoryProxy";
		
		
		public function PetFactoryProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
		}
		
		override public function onRemove():void
		{
			
		}
		
		public function getPetDog(petName:String,petType:String,range:Rectangle):PetDogMediator{
			
//			var dog1Suit:CharaterSuitsVO = (facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy).getCharaterSuit(petType);
			
			var dog1Suit:CharaterSuitsVO = (facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy).getCharaterSuit("bmpTemplet",true);
			
			var dog:PetDogMediator = new PetDogMediator(petName,dog1Suit,"bmp",new Sprite,range);
			facade.registerMediator(dog);
			
			return dog
			
			
		}
		
		
		
	}
}