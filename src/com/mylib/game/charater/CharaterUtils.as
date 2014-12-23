package com.mylib.game.charater
{
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.ProfileAndDressSuitsMediator;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSeriesVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class CharaterUtils extends Proxy implements ICharaterUtils
	{
		
		private var _suitsProxy:CharaterSuitsProxy;
		
		private var _profileAndDressSuitsMediator:ProfileAndDressSuitsMediator;
		
		
		public function CharaterUtils()
		{
			super(ModuleConst.CHARATER_UTILS);
			
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		public function configHumanFromPool(human:HumanMediator,charaterName:String,range:Rectangle,isCopy:Boolean=false):void{
			
			
			var profile:CharaterSuitsVO = suitsProxy.getCharaterSuit(charaterName,isCopy);
			
			human.actor.dressDown();
			human.actor.setProfile(profile);
			human.actor.dressUp();
			human.look(HumanMediator.FACE_NORMAL);
			human.range = range;
			
			
			
		}
		
		//创建人物
		public function configHumanFromDressList(human:ICharater,dressList:String,range:Rectangle):void{
			//清空人物装备
			human.actor.dressDown();
			human.actor.setProfile(new CharaterSuitsVO);
			
			humanDressFun(human,dressList);
			
//			human.actor.switchCostume("head","face","normal");
			
			human.range = range;
		}
		//穿上装备、配置脸部表情
		public function humanDressFun(human:ICharater,dressList:String):void{
			profileAndDressSuits.dressByDressList(human,dressList);
			

			if(human is HumanMediator){
				(human as HumanMediator).look(HumanMediator.FACE_NORMAL);
			}else{
				
			}

		}
		
		/**
		 *取装备属性，支持取多装备组合属性
		 * @param _dressList
		 * @return 
		 * 
		 */		
		public function getEquipProperty(_dressList:String):String{
			
			var proArr:Array = new Array;
			var dressArr:Array = _dressList.split(",");
			
			
			for (var i:int = 0; i < dressArr.length; i++) 
			{
				//表情、bmp动画跳过
				if(dressArr[i].indexOf("face") != -1 || dressArr[i].indexOf("bmpNpc") != -1)
					continue;
				
				for (var j:int = 0; j < Global.dressDatalist.length; j++) 
				{
					
					if(Global.dressDatalist[j].name == dressArr[i]){
						
						proArr.push(Global.dressDatalist[j].property);
						break;
					}
				}
			}
			
			if(proArr.length > 0)	return proArr.join(";");
			else	return "";
		}

				
		/**
		 *取面部表情列表 
		 * @param faceName
		 * @return 
		 * 
		 */		
		public function getHumanFaceList(faceName:String):Array{
			return profileAndDressSuits.getItemList(faceName);
		}
		/**
		 * 取人物装备串
		 * @param _charater
		 * @return 
		 * 
		 */		
		public function getHumanDressList(_charater:ICharater):String{
			return profileAndDressSuits.getDressList(_charater);
		}
		/**
		 *取装备贴图 
		 * @param _dressSuitsVO
		 * @param scale
		 * @return 
		 * 
		 */		
		public function getNormalEquipImg(_dressSuitsVO:DressSuitsVO, scale:Number=1):DisplayObject{
			
			return profileAndDressSuits.getNormalEquipImg(_dressSuitsVO,scale);
			
		}
		/**
		 * 根据装备名称，取装备贴图 
		 * @param _dressName
		 * @param _scale
		 * @return 
		 * 
		 */		
		public function getEquipImgByName(_dressName:String, scale:Number=1):DisplayObject{
			return profileAndDressSuits.getEquipImgByName(_dressName,scale);
		}
		
		
		
		/**
		 *取装备系列信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getEquipSerInfo(_dressName:String):DressSeriesVO{
			return profileAndDressSuits.getEquipSerInfo(_dressName);
		}
		/**
		 *取装备当前等级信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getEquipItemInfo(_dressName:String):DressSeriesItemVO{
			return profileAndDressSuits.getEquipItemInfo(_dressName);
		}
		/**
		 *取装备下一等级信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getNextLevelEquip(_dressName:String):DressSeriesItemVO{
			return profileAndDressSuits.getNextLevelEquip(_dressName);
		}
		
		
		
		
		public function get suitsProxy():CharaterSuitsProxy{
			
			if(!_suitsProxy){
				_suitsProxy =Facade.getInstance(CoreConst.CORE).retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			}
			
			
			return _suitsProxy;
		}
		
		public function get profileAndDressSuits():ProfileAndDressSuitsMediator{
			
			if(!_profileAndDressSuitsMediator){
				_profileAndDressSuitsMediator = Facade.getInstance(CoreConst.CORE).
					retrieveMediator(ProfileAndDressSuitsMediator.NAME) as ProfileAndDressSuitsMediator;
			}
			
			
			return _profileAndDressSuitsMediator;
		}
		
		
		public function setCharaterLevel(_view:Sprite, _level:int, isMe:Boolean=false):void{

			var _star0:Texture = Assets.getCharaterTexture("star0");
			var _star1:Texture = Assets.getCharaterTexture("star1");
			var _ringMy:Texture = Assets.getCharaterTexture("ringMy");
			
			
			var lvl:int = 0;
			if(_level != 0){
				var p:int = _level/100;
				var q:int = _level%100;
				
				//能被100整除
				if(q == 0){
					lvl = p;
				}else{
					lvl = p+1;
				}
			}
			
			
//			lvl = 12;
			//大于等于12级，加徽章
			if(lvl >= 12){
				lvl = 12;
				
				var star1:Image = new Image(_star1);
				star1.name = "clevel_star1";
				star1.pivotX = star1.width>>1;
				star1.pivotY = star1.height>>1;
				star1.y = -80;
				_view.addChild(star1);
				
			}
			
			var r:int = lvl/4;
			var l:int = lvl%4;
			var star:Image;
			
			//1菱形
			for (var i:int = 0; i < l; i++) 
			{
				star = new Image(_star0);
				star.name = "clevel_star0";
				star.pivotX = star.width>>1;
				star.pivotY = star.height>>1;
				_view.addChildAt(star,0);
				
				if(l == 1){
					star.y = 12;
				}else if(l == 2 ){
					star.y = 12;
					star.x = -5+i*10;
				}else if(l == 3 ){
					star.y = 12;
					star.x = -10+i*10;
				}
				
			}
			
			var ring:Image = new Image(Assets.getCharaterTexture("ring"+r));
			ring.name = "clevel_ring";
			ring.pivotX = ring.width>>1;
			ring.pivotY = ring.height>>1;
			_view.addChildAt(ring,0);
			ring.y = 0;
			ring.x = -2;
			
			
			if(isMe){
				var ringmy:Image = new Image(_ringMy);
				ringmy.name = "clevel_ringmy";
				ringmy.pivotX = ringmy.width>>1;
				ringmy.pivotY = ringmy.height>>1;
				_view.addChildAt(ringmy,0);
				ringmy.y = 0;
				ringmy.x = -2;
				
			}
			
		}
		
	}
}