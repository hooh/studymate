package com.studyMate.world.component.SVGEditor.data
{
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;

	public class EditSVGVO
	{
		public var id:String = SVGUtils.getRandomIDStr();//id号。唯一标识
		public var name:String;
		public var x:Number;
		public var y:Number;
		public var text:String='';//文本节点中的数据
		public var styleDeclaration:StyleDeclaration = new StyleDeclaration;//属性
		
		public function EditSVGVO(){
			
		}
	}
}