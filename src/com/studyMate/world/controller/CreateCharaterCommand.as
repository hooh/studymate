package com.studyMate.world.controller
{

	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.item.BoneImage;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.SuitVO;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import akdcl.skeleton.Armature;
	import akdcl.skeleton.BaseCommand;
	import akdcl.skeleton.export.TextureMix;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Starling 骨架生成工具
	 * @author hooh
	 */
	final public class CreateCharaterCommand {
		
		/**
		 * @private
		 */
		private static var textureMix:TextureMix;
		
		private static var store:Dictionary = new Dictionary();
		
		
		
		private static var creatingCharaterData:CharaterSuitsVO;
		
		/**
		 * 骨架生成方法
		 * @param _name 骨架名
		 * @param _animationName 动画名
		 * @param _textureMix 贴图数据
		 */
		public static function createArmature(_name:String, _animationName:String, _textureMix:TextureMix,charaterData:CharaterSuitsVO):Armature {
			textureMix = _textureMix;
			creatingCharaterData = charaterData;
			if (textureMix&&!textureMix.texture) {
				textureMix.texture = Texture.fromBitmap(textureMix.bitmap);
			}
			var _armature:Armature = BaseCommand.createArmature(_name, _animationName, new Sprite(), boneFactory, true);
			textureMix = null;
			return _armature;
		}
		
		/**
		 * 骨骼生成接口
		 * @private
		 */
		static private function boneFactory(_armarureName:String, _boneName:String):Object {
			if (textureMix) {
				
				var suit:SuitVO = creatingCharaterData.bones[_boneName];
				var img:Image = getTextureDisplay(textureMix, _armarureName +"_"+suit.id+ "_" + _boneName);
				if(suit.color==suit.color){
					img.color = suit.color;
				}
				if(!img)
					return new Sprite();
				else
					return img;
			}
			return null;
		}
		
		/**
		 * 从 TextureMix 获得 Image 的方法
		 * @param _textureMix 贴图数据
		 * @param _fullName 贴图全称
		 * @return 返回 Image 实例
		 */
		public static function getTextureDisplay(_textureMix:TextureMix, _fullName:String):Image {
			var _texture:XML = _textureMix.getTexture(_fullName);
			if (_texture) {
				var tex:Texture;
				if(store[_fullName]){
					tex = store[_fullName];
				}else{
					/*var _rect:Rectangle = new Rectangle(int(_texture.@x), int(_texture.@y), int(_texture.@width), int(_texture.@height));
					tex = new SubTexture(_textureMix.texture as Texture, _rect);*/
					tex = (_textureMix.texture as TextureAtlas).getTexture(_fullName);
					store[_fullName] = tex;
					
				}
				
				var _img:BoneImage = new BoneImage(tex);
				_img.id = _fullName;
				_img.pivotX = -int(_texture.@frameX);
				_img.pivotY = -int(_texture.@frameY);
				return _img;
			}
			return null;
		}
		
		public static function getTexture(_textureMix:TextureMix, _fullName:String):Texture{
			var _texture:XML = _textureMix.getTexture(_fullName);
			if (_texture) {
				var tex:Texture;
				if(store[_fullName]){
					tex = store[_fullName];
				}else{
//					var _rect:Rectangle = new Rectangle(int(_texture.@x), int(_texture.@y), int(_texture.@width), int(_texture.@height));
//					tex = new SubTexture(_textureMix.texture as Texture, _rect);
					tex = (_textureMix.texture as TextureAtlas).getTexture(_fullName);
					store[_fullName] = tex;
					
				}
				return tex;
			}
			
			return null;
			
		}
		
		
	}
}