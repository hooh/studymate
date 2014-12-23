package com.mylib.api
{
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.ProfileAndDressSuitsMediator;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSeriesVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public interface ICharaterUtils
	{
		function configHumanFromPool(human:HumanMediator,charaterName:String,range:Rectangle,isCopy:Boolean=false):void;
		function configHumanFromDressList(human:ICharater,dressList:String,range:Rectangle):void;
		function humanDressFun(human:ICharater,dressList:String):void;
		function getHumanFaceList(faceName:String):Array;
		function getHumanDressList(_charater:ICharater):String;
		function getNormalEquipImg(_dressSuitsVO:DressSuitsVO, scale:Number=1):DisplayObject;
		function getEquipImgByName(_dressName:String, scale:Number=1):DisplayObject;
		function getEquipProperty(_dressList:String):String;
		function get suitsProxy():CharaterSuitsProxy;
		function get profileAndDressSuits():ProfileAndDressSuitsMediator;
		
		function getEquipSerInfo(_dressName:String):DressSeriesVO;
		function getEquipItemInfo(_dressName:String):DressSeriesItemVO;
		function getNextLevelEquip(_dressName:String):DressSeriesItemVO;
		
		
		function setCharaterLevel(_view:Sprite, _level:int, isMe:Boolean=false):void;
		
		
		
	}
}