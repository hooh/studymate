package com.studyMate.model.vo
{
	import com.studyMate.model.vo.tcp.PackData;

	public final class LoginSettingVO
	{
		public var pack:PackData;
		
		public var loginVO:LoginVO;
		
		
		public function LoginSettingVO(pack:PackData,loginVO:LoginVO)
		{
			this.pack = pack;
			this.loginVO = loginVO;
		}
	}
}