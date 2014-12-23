package com.studyMate.utils
{
	import com.emibap.textureAtlas.DynamicAtlas;
	
	import flash.display.DisplayObject;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import feathers.controls.Label;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class BitmapFontUtils
	{
		private static var atlas:TextureAtlas;
		/**
		 * 是否已经初始化，true为已经初始化，可以调用了
		 */		
		public static var isInit:Boolean; //是否已经初始化
		
		public function BitmapFontUtils()
		{
			
		}
		
		/**
		 * 实现字体位图处理。
		 * @param str		要包含的字符串，函数会自动清除重复字符
		 * @param assets	包含的其他要图片数组
		 * @param tf		要显示的文本样式，可以不写，但是一定程度上会影响效率
		 * @return string	返回已经嵌入的文本字符串
		 */		
		public static function init(str:String,assets:Vector.<DisplayObject>=null,tf:TextFormat=null,filters:Array=null,embedFonts:Boolean=true):String{
			if(isInit) dispose();//已经实例化则排除
			isInit = true;
			var charHasDic:Dictionary = new Dictionary;
			var len:int = str.length;
			for(var i:int=0;i<len;i++){
				charHasDic[str.charAt(i)] = i;
				
			}
			var resultStr:String = '';
			for( var key:String in charHasDic){
				resultStr+=key;
			}
			charHasDic = null;
			
			var textField:flash.text.TextField = new flash.text.TextField();
			if(tf == null){				
				tf = new TextFormat("HeiTi",20,0);
			}
			textField.defaultTextFormat = tf;
			textField.embedFonts = embedFonts;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.text = resultStr;
			textField.filters = filters;
			atlas = DynamicAtlas.bitmapFontFromTextField(textField,0,"dHei",assets);	
			
			return resultStr;
		}				
		/**
		 * 
		 * @return 已经实例化的Label文本
		 * 
		 */		
		public static function getLabel():Label{
			var label:Label = new Label();
			label.textRendererFactory = function():ITextRenderer
			{
				return new BitmapFontTextRenderer();
			}
			label.textRendererProperties.textFormat = new BitmapFontTextFormat("dHei");
			label.textRendererProperties.useSeparateBatch = false;
			label.textRendererProperties.snapToPixels = true; 	
//			label.textRendererProperties.smoothing = TextureSmoothing.NONE;
			return label;
		}
		
		public static function getTexture(name:String):Texture{			
			return atlas.getTexture(name);
		}
		
		public static function dispose():void{
			isInit = false;
			if(atlas){
				
				atlas.dispose();
				atlas = null;
				starling.text.TextField.unregisterBitmapFont('dHei',true);
			}
		}
	}
}