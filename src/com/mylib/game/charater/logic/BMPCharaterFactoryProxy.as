package com.mylib.game.charater.logic
{
	import com.mylib.game.charater.BMPCharaterMediator;
	import com.mylib.game.charater.BMPEnemyMediator;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.Sprite;
	
	public class BMPCharaterFactoryProxy extends Proxy
	{
		public static const NAME:String = "BMPCharaterFactoryProxy";
		
		public function BMPCharaterFactoryProxy()
		{
			super(NAME);
		}
		
		public function getBMPEnemy(name:String,suitName:String):BMPCharaterMediator{
			var bmpSuits:CharaterSuitsVO = (facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy).getCharaterSuit("bmpTemplet");
			var enemy:BMPEnemyMediator = new BMPEnemyMediator(name,bmpSuits,new Sprite(),null);
			facade.registerMediator(enemy);
			GlobalModule.charaterUtils.humanDressFun(enemy,"bmpNpc_"+suitName);
			
			return enemy;
		}
		
	}
}