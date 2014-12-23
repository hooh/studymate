package com.studyMate.world.model.vo
{
	import flash.utils.ByteArray;
	
	
	public class RelListItemSpVO{
		
		public var userId:String = "";
		public var rstdId:String = "";
		public var rstdCode:String = "";
		public var realName:String = "";
		public var relaType:String = "";
		
		public var isShake:Boolean;
		
		public var messNum:int = 0;
		
		//好友列表 显示用
		public var nickName:String = "";
		public var gender:String = "";
		public var goldNum:String = "";
		public var birth:String = "";
		public var school:String = "";
		public var sign:String = "";
		
		
		public function RelListItemSpVO()
		{
			
			
		}
		
		public function clone():RelListItemSpVO{
			
			var newVo:RelListItemSpVO = new RelListItemSpVO;
			
			newVo.userId = this.userId;
			newVo.rstdId = this.rstdId;
			newVo.rstdCode = this.rstdCode;
			newVo.realName = this.realName;
			newVo.relaType = this.relaType;
			
			newVo.isShake = this.isShake;
			
			newVo.messNum = this.messNum;
			
			newVo.nickName = this.nickName;
			newVo.gender = this.gender;
			newVo.goldNum = this.goldNum;
			newVo.birth = this.birth;
			newVo.school = this.school;
			newVo.sign = this.sign;
			
			return newVo;
		}
	}
}