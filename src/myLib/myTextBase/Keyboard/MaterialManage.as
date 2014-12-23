package myLib.myTextBase.Keyboard
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	
	import flash.system.Capabilities;
	
	/**
	 * 素材管理
	 * 2014-6-18上午11:55:14
	 * Author wt
	 *
	 */	
	
	internal class MaterialManage
	{
		public var useBigSize:Boolean;
		
		private static var _instance : MaterialManage;
		
		
		
		public function MaterialManage()
		{
			var dpi:Number = dpi = Capabilities.screenDPI;
			var stageWidth:Number = Global.stage.stageWidth;
			
			if(dpi>210 && stageWidth<1900){//酷比1920*1200
				useBigSize = true;
			}else{
				useBigSize = false;
			}
		}
		
		public function get cn_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("Left_Pinyin_Keyboard_213");
			}else{
				return AssetTool.getCurrentLibClass("Left_Pinyin_Keyboard");
			}
		}
		
		public function get en_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("Left_Big_Keyboard_213");
			}else{
				return AssetTool.getCurrentLibClass("Left_Big_Keyboard");
			}
		}
		
		public function get math_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("Left_Math_Keyboard_213");
			}else{
				return AssetTool.getCurrentLibClass("Left_Math_Keyboard");
			}
		}
		
		public function get sign_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("Left_Sign_Keyboard_213");
			}else{
				return AssetTool.getCurrentLibClass("Left_Sign_Keyboard");
			}
		}
		
		public function get simple_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("Simple_Keyboard_213");
			}else{
				return AssetTool.getCurrentLibClass("Simple_Keyboard");
			}
		}
		
		public function get pinyinBar_meterial():Class{
			if(useBigSize){
				return AssetTool.getCurrentLibClass("PinyinBar_213");
			}else{
				return AssetTool.getCurrentLibClass("PinyinBar");
			}
		}
		
		public static function getInstance() : MaterialManage
		{
			return _instance ? _instance : new MaterialManage();
		}
	}
}