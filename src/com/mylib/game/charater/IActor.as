package com.mylib.game.charater
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public interface IActor
	{
		function playAnimation(_to:Object, _toFrames:uint, _listFrames:uint=0, _loop:Boolean=false):void;
		function switchCostume(boneName:String,equipmentName:String,itemName:String,loop:Boolean=true):void;
		function removeBoneDisplay(boneName:String):void;
		function addBoneDisplay(boneName:String,_display:DisplayObject,textureId:String,orderId:int):void;
		function replaceBoneDisplay(boneName:String,_display:DisplayObject,textureId:String):void;
		function removeBoneDisplayItem(boneName:String,itemName:String):void;
		function getProfile():CharaterSuitsVO;
		function setProfile(_p:CharaterSuitsVO):void;
		function dressUp():void;
		function dressDown():void;
		function  get display():Sprite;
		function addFace(faceSuitEquipmentVo:SuitEquipmentVO):void;
		
		/**
		 *stop all animations 
		 * 
		 */		
		function stop():void;
		function start():void;
		function stopMove():void;
	}
}