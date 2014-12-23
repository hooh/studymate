package com.studyMate.world.component.SVGEditor.product.display
{
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditGraph;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditText;
	

	public class Creator
	{
		public function Creator()
		{
		}
		
		//这是生产方法  
		public static function creatText():IEditText{
			return new EditSVGTextExtend;
		}
		
		
		public static function creatMath():IEditText{
			return new EditSVGMath;
		}
		
		public static function creatRect():IEditGraph{
			return new EditSVGRect;
		}
		
		public static function creatEllipse():IEditGraph{
			return new EditSVGEllipse;
		}
		
		public static function creatSwfImage():IEditGraph{
			return new EditSVGSwfImage;
		}
		
		public static function creatPolygon():IEditGraph{
			return new EditSVGPolygon
		}
	}
}