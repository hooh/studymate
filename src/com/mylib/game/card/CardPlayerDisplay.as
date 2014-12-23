package com.mylib.game.card
{
	import com.byxb.utils.centerPivot;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.logic.BMPCharaterFactoryProxy;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.model.BMPFighterPoolProxy;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.text.TextField;
	
	public class CardPlayerDisplay
	{
		private var _data:GameCharaterData;
		protected var hpTxt:TextField;
		protected var valueDisplay:CardValueDisplay;
		public var islander:FighterControllerMediator;
		
		
		public function CardPlayerDisplay()
		{
			super();
			valueDisplay = new CardValueDisplay();
			hpTxt = new TextField(100,24,"","arial");
			
			centerPivot(hpTxt);
			
			
			
			
			
		}
		
		public function refresh():void{
//			hpTxt.text = _data.hp.toString();
		}
		public function dispose():void
		{
			if(valueDisplay.view){
				valueDisplay.view.removeFromParent(true);
			}
			islander.charater.view.removeFromParent();
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = islander;
			
		}
		
		
		public function get data():GameCharaterData
		{
			return _data;
		}
		
		private function initCharater():void{
			
			if(_data.skeleton==SkeletonType.BMP){
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool;
			}else{
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			}
			
			islander = (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object;
			islander.charater.velocity = 2*Math.random()+2;
		}

		public function set data(value:GameCharaterData):void
		{
			_data = value;
			
			valueDisplay.data = _data.values;
			valueDisplay.refresh();
			valueDisplay.view.y = 30;
			initCharater();
			
			GlobalModule.charaterUtils.humanDressFun(islander.charater,_data.equiment);
			centerPivot(valueDisplay.view);
		}

	}
}