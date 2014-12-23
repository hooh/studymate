package myLib.myTextBase.Keyboard
{
	import com.studyMate.global.Global;

	public class Creator
	{
		public function Creator()
		{
		}
		
		public static function creatCNKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new CNKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
		
		public static function creatUSKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new USKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
		
		public static function creatNumKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new NumKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
		
		public static function creatSignKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new SignKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
		
		public static function creatSimpleKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new SimpleKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
		public static function creatAspectKeyboard():AbstractKeyboard{
			var keyboard:AbstractKeyboard = new AspectKeyboard;
			keyboard.scaleX = Global.widthScale;
			keyboard.scaleY = Global.heightScale;
			return keyboard;
		}
	}
}