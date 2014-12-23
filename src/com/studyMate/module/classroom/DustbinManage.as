package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * note
	 * 2014-6-16下午4:35:01
	 * Author wt
	 *
	 */	
	
	public class DustbinManage
	{
		private static var _hasSelfData:Boolean;
		private static var _hasOtherData:Boolean;
		
		public static function get hasOtherData():Boolean
		{
			return _hasOtherData;
		}

		public static function get hasSelfData():Boolean
		{
			return _hasSelfData;
		}

		public static function set hasSelfData(value:Boolean):void{
			if(_hasSelfData== value ) return;
			_hasSelfData = value;
			if(_hasSelfData){//显示垃圾桶
				Facade.getInstance(CoreConst.CORE).sendNotification(CRoomConst.SHOW_DUSTBIN);
			}else if(!_hasOtherData){//隐藏垃圾桶
				Facade.getInstance(CoreConst.CORE).sendNotification(CRoomConst.HIDE_DUSTBIN);
			}
		}
		
		public static function set hasOtherData(value:Boolean):void{
			if(_hasOtherData == value) return;
			_hasOtherData = value;
			if(_hasOtherData){//显示垃圾桶
				Facade.getInstance(CoreConst.CORE).sendNotification(CRoomConst.SHOW_DUSTBIN);
			}else if(!_hasSelfData){//隐藏垃圾桶
				Facade.getInstance(CoreConst.CORE).sendNotification(CRoomConst.HIDE_DUSTBIN);

			}
		}
		
		public static function dispose():void{
			_hasSelfData = false;
			_hasOtherData = false;
		}
	}
}