package com.studyMate.model.ebook
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ScriptExecuseVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.studyMate.utils.LayoutToolUtils;
	
	public final class PictureBook implements IBook
	{
		public function PictureBook()
		{
			
			
		}
		
		public function getPage(pageIdx:int,type:String):DisplayObject
		{
			/*var c:Class = getDefinitionByName("com.danny.P"+pageIdx) as Class;
			
			var bd:BitmapData = new c;
			var bmp:Bitmap = new Bitmap(bd);*/
			var holder:Sprite = new Sprite();
			holder.name = "page"+pageIdx;
			//holder.addChild(bmp);
			
			LayoutToolUtils.holder = holder;
			getLogger(PictureBook).debug("page"+pageIdx);
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(ApplicationFacade.EXECUSE_SCRIPT,pageIdx);
			var jump:Boolean;
			if(type=="c"){
			}else{
				jump = true;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(pageIdx,-1,jump));
			}
			return holder;
		}
	}
}