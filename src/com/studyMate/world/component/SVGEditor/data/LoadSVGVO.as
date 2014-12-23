package com.studyMate.world.component.SVGEditor.data
{
	public class LoadSVGVO
	{
		
		public var wrongid:String='0';//#错题标识；全局唯一标识
		
		public var subject:String = 'yw';//#科目（yw/sx/yy/wl/hx/sw/zz/ls/dl）
		
		public var srcdesc:String='';// #素材出处来源描述；小升初、中考、高考、书、网络等
		
		public var copcode:String;//#创建人工号
		
		public var mopcode:String;//#最后修改人工号
		
		public var modtime:String;//#最后修改时间
		
		public function LoadSVGVO(arr:Array=null)
		{
			if(arr){
				
				this.wrongid = arr[1];
				this.subject = arr[3];
				this.srcdesc = arr[4];
				this.copcode = arr[5];
				this.mopcode = arr[6];
				this.modtime = arr[7];
			}
			
		}
	}
}