package com.studyMate.world.screens
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class TestLabelMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TestLabelMediator";
		
		
		public function TestLabelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			var label:Label;
			
			
			var t:Texture;
			
			
			var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"mainMenu/menuTalkBtn");
			bmp.name = "menuTalkBtn";
			
			
			var assets:Vector.<DisplayObject> = Vector.<DisplayObject>([bmp]);
			
			
			var textField:TextField = new TextField();
			var tf:TextFormat = new TextFormat("HeiTi",30,0xff0000);
			textField.defaultTextFormat = tf;
			textField.embedFonts = true;
			textField.text = "中文1234567890";
			var atlas:TextureAtlas = DynamicAtlas.bitmapFontFromTextField(textField,0,"dHei",assets);
			t = atlas.getTexture("menuTalkBtn_00000");
			
			for (var i:int = 0; i < 10; i++) 
			{
				
				var img:Image = new Image(t);
				view.addChild(img);
				label = new Label();
				label.textRendererFactory = function():ITextRenderer
				{
					return new BitmapFontTextRenderer();
				}
				label.textRendererProperties.textFormat = new BitmapFontTextFormat("dHei");
				
				label.textRendererProperties.useSeparateBatch = false;
				label.textRendererProperties.snapToPixels = false; 
				label.text = "中文"+i;
				label.x = 100;
				label.y = 100;
				view.addChild(label);
			}
			
			
//			Global.stage.addChild(DynamicAtlas.bmp);
			
			
		}
		
	}
}