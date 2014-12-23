package com.studyMate.world.controller.vo
{
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	public class CharaterInfoVO 
	{
		/**
		 * 显示个人信息用 
		 */		
		public var reltVo:RelListItemSpVO;
		
		
		/**
		 * 人物菜单用 
		 */		
		public var id:String;
		public var equip:String;
		
		
		/**
		 * 标记:<br>"加为好友(1)"<br>"删除好友(0)" 
		 */		
		public var sign:int;
		
		public var level:String;
		
		public function CharaterInfoVO(_reltVo:RelListItemSpVO=null, _id:String=null, _equip:String=null, _sign:int=1, _level:String="0")
		{
			this.reltVo = _reltVo;
			
			this.id = _id;
			this.equip = _equip;
			
			this.sign = _sign;
			
			this.level = _level;
			
			
		}
	}
}