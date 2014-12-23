package zhen.guo.yao.components.flipbook
{
	import com.studyMate.model.ebook.IBook;
	
	import flash.display.DisplayObject;

	public class PageUtils
	{
		public function PageUtils()
		{
		}
		
		public static var book:IBook;
		
		public static function getPage(idx:uint,type:String="p"):DisplayObject{
			
			return book.getPage(idx,type);
			
		}
		
		
		
	}
}