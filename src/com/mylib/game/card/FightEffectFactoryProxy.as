package com.mylib.game.card
{
	import com.mylib.game.charater.JobTypes;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class FightEffectFactoryProxy extends Proxy
	{
		public static const NAME:String = "FightEffectFactoryProxy";
		
		private var meleeEff1:Vector.<Texture>;
		private var magicEff1:Vector.<Texture>;
		private var keepEff1:Vector.<Texture>;
		private var addBlooadEff:Vector.<Texture>;
		private var yuzhouEff:Vector.<Texture>;
		private var chargeEff1:Vector.<Texture>;
		
		override public function onRegister():void
		{
			meleeEff1 = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/meleeEff1");
			magicEff1 = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/magicEff1");
			
			keepEff1 = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/jixu");
			addBlooadEff = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/addBloodEff");
			yuzhouEff = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/yuzhou");
			chargeEff1 = (Assets.petTexture.texture as TextureAtlas).getTextures("effect/charge");
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		public function FightEffectFactoryProxy()
		{
			super(NAME, data);
		}
		
		public function getEffect(job:uint):FightEffectVO{
			var vo:FightEffectVO = new FightEffectVO;
			switch(job){
				case JobTypes.warrior:
					vo.effect = new MovieClip(meleeEff1);
					vo.type = FightEffectVO.FIX;
					break;
				case JobTypes.keep:
					vo.effect = new MovieClip(keepEff1);
					vo.type = FightEffectVO.FIX;
					break;
				case JobTypes.addBlood:
					vo.effect = new MovieClip(addBlooadEff);
					vo.type = FightEffectVO.FIX;
					break;
				case JobTypes.yuzhou:
					vo.effect = new MovieClip(yuzhouEff);
					vo.type = FightEffectVO.FIX;
					break;
				case JobTypes.charge:{
					vo.effect = new MovieClip(chargeEff1);
					vo.type = FightEffectVO.FIX;
					break;
				}
				default :
					vo.effect = new MovieClip(magicEff1);
					vo.type = FightEffectVO.MOV;
					break;
			}

			return vo;
		}
		
		
		
		
		
		
	}
}