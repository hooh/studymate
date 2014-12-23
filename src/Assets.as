
package
{
	import com.mylib.api.IAssetLibProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.vo.BitmapFontVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import akdcl.skeleton.export.TextureMix;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The Assets class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 *
	 */
	public class Assets
	{



		// Fonts

		// The 'embedAsCFF'-part IS REQUIRED!!!!
		/*   [Embed(source="../media/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
		private static const UbuntuRegular:Class; */

		// Texture Atlas


		//XML
		
		
		// Bitmaps
		
		private static var sSounds:Dictionary=new Dictionary();
		public static var charaterTexture:TextureMix;
		public static var petTexture:TextureMix;
		
		public static var rectangle:Rectangle = new Rectangle();
		
		public static var store:Dictionary=new Dictionary();
		public static var bitmapFontStore:Dictionary=new Dictionary();
		
		public static var recoverThemeBMPD:BitmapData;
		public static var recoverThemeXML:XML;
		
		public static var textureAtlass:Dictionary=new Dictionary();


		// Sounds

		/*[Embed(source="../media/audio/step.mp3")]
		public static const StepSound:Class;*/

		// Texture cache

		public static var sTextures:Dictionary=new Dictionary();

		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		public static function getAtlas():TextureAtlas
		{
			if (textureAtlass["AtlasTexture"] == undefined)
			{
				var texture:Texture=getTexture("AtlasTexture");
				
//				var texture:Texture=getAtfTexture("whaleUIATF");
				
				var xml:XML=store["AtlasXml"];
				
				if(texture&&xml){
					textureAtlass["AtlasTexture"]=new TextureAtlas(texture, xml);
				}
				

			}

			return textureAtlass["AtlasTexture"];
		}
		
		private static function getChapterAtlas():TextureAtlas{
			
			if (textureAtlass["chapterBMP"] == null)
			{
				var texture:Texture=getTexture("chapterBMP");
				
//				var texture:Texture=getAtfTexture("chapterATF");
				
				var xml:XML=store["chapterXML"];
				textureAtlass["chapterBMP"]=new TextureAtlas(texture, xml);
				
			}
			
			return textureAtlass["chapterBMP"];
			
		}
		
		
		private static function getRememberWordCardAtlas():TextureAtlas{
			if(textureAtlass["rememberWordCardXMLTexture"] == null){
				var texture:Texture = getTexture("rememberWordCardXMLTexture");
				var xml:XML = store["rememberWordCardXML"];
				textureAtlass["rememberWordCardXMLTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["rememberWordCardXMLTexture"];
		}
		
		
		public static function getWordCardAtlas():TextureAtlas{
			if(textureAtlass["wordCardTexture"] == null){
				var texture:Texture = getTexture("wordCardTexture");
				var xml:XML = store["wordCardXML"];
				textureAtlass["wordCardTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["wordCardTexture"];
		}
		
		
		private static function getEmailAtlas():TextureAtlas{
			if(textureAtlass["emailTexture"] == null){
				var texture:Texture = getTexture("emailTexture");
				var xml:XML = store["emailXML"];
				textureAtlass["emailTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["emailTexture"];
		}
		
		private static function getMenuAtlas():TextureAtlas{
			if(textureAtlass["menuTextures"] == null){
				var texture:Texture = getTexture("menuTextures");
				var xml:XML = store["menuXML"] ;
				textureAtlass["menuTextures"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["menuTextures"];
		}
		
		private static function getWallpaperAtlas():TextureAtlas
		{
			if(textureAtlass["wallpaperTexture"] == null){
				var texture:Texture = getTexture("wallpaperTexture");
				var xml:XML = store["wallpaperTextureXML"] ;
				textureAtlass["wallpaperTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["wallpaperTexture"];
		}
		

		
		private static function getEgLearningAtlas():TextureAtlas{
			if(textureAtlass["EgLearningAtlasTexture"]==null){
				
				var texture:Texture=getTexture("EgLearningAtlasTexture");
				
//				var texture:Texture=getAtfTexture("EgLearningAtlasATF");
				
				var xml:XML=store["EgLearningAtlasXML"];
				textureAtlass["EgLearningAtlasTexture"]=new TextureAtlas(texture, xml);
			}
			
			return textureAtlass["EgLearningAtlasTexture"];
		}
		
		private static  function getEgLandAtlas():TextureAtlas{
			if(textureAtlass["EnglishLandAtlasTexture"]==null){
				var texture:Texture = getTexture("EnglishLandAtlasTexture");
				
//				var texture:Texture=getAtfTexture("EnglishLandAtlasATF");
				
				var xml:XML = store["EnglishLandAtlasXML"];
				textureAtlass["EnglishLandAtlasTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["EnglishLandAtlasTexture"];
		}
		
		private static function getWhaleInsideAtlas():TextureAtlas{
			if(textureAtlass["whaleInsideAtlasTexture"]==null){
				var texture:Texture = getTexture("whaleInsideAtlasTexture");
				var xml:XML = store["whaleInsideXML"]
				textureAtlass["whaleInsideAtlasTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["whaleInsideAtlasTexture"];
		}
		
		private static function getVideoAtlas():TextureAtlas{
			/*if(InsideAtlas==null){
				var texture:Texture = getTexture("videoAtlasPlayer");
				var xml:XML = store["videoAtlasXML"]
				InsideAtlas = new TextureAtlas(texture,xml);
			}
			return InsideAtlas;*/
			if(textureAtlass["videoAtlasPlayer"]==null){
				var texture:Texture = getTexture("videoAtlasPlayer");
				var xml:XML = store["videoAtlasPlayerXML"]
				textureAtlass["videoAtlasPlayer"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["videoAtlasPlayer"];
		}
		
		private static function getMarketAtlas():TextureAtlas{
			if(textureAtlass["marketTexture"]==null){
				var texture:Texture = getTexture("marketTexture");
				var xml:XML = store["marketXML"]
				textureAtlass["marketTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["marketTexture"];
		}
		
		public static function getEngTaskIslandAtlas():TextureAtlas{
			if(textureAtlass["EngTaskIslandTexture"]==null){
				var texture:Texture = getTexture("EngTaskIslandTexture");
				var xml:XML = store["EngTaskIslandXML"]
				textureAtlass["EngTaskIslandTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["EngTaskIslandTexture"];
		}
		
		private static function getWorldMapAtlas():TextureAtlas{
			if(textureAtlass["worldMap"]==null){
				var texture:Texture = getTexture("worldMap");
				var xml:XML = store["worldMapXML"]
				textureAtlass["worldMap"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["worldMap"];
		}
		
		private static function getBattleGameAtlas():TextureAtlas{
			if(textureAtlass["battleGame"]==null){
				var texture:Texture = getTexture("battleGameTexture");
				var xml:XML = store["battleGameXML"]
				textureAtlass["battleGame"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["battleGame"];
		}
		
		private static function getFightGameAtlas():TextureAtlas{
			if(textureAtlass["fightGame"]==null){
				var texture:Texture = getTexture("FightGameTexture");
				var xml:XML = store["FightGameXML"]
				textureAtlass["fightGame"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["fightGame"];
		}
		
		public static function getHappyIslandAtlas():TextureAtlas{
			if(textureAtlass["HappyIslandTexture"]==null){
				var texture:Texture = getTexture("HappyIslandTexture");
				var xml:XML = store["HappyIslandXML"]
				textureAtlass["HappyIslandTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["HappyIslandTexture"];
		}
		
		public static function getHapIslandHouseAtlas():TextureAtlas{
			if(textureAtlass["HapIslandHouseTexture"]==null){
				var texture:Texture = getTexture("HapIslandHouseTexture");
				var xml:XML = store["HapIslandHouseXML"]
				textureAtlass["HapIslandHouseTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["HapIslandHouseTexture"];
		}
		
		private static function getMusicSeriesAtlas():TextureAtlas{
			if(textureAtlass["MusicSeriesTexture"]==null){
				var texture:Texture = getTexture("MusicSeriesTexture");
				var xml:XML = store["MusicSeriesXML"]
				textureAtlass["MusicSeriesTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["MusicSeriesTexture"];
		}
		
		public static function getUnderWorldAtlas():TextureAtlas{
			if(textureAtlass["UnderWorldTexture"]==null){
				var texture:Texture = getTexture("UnderWorldTexture");
				var xml:XML = store["UnderWorldXML"]
				textureAtlass["UnderWorldTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["UnderWorldTexture"];
		}
		
		public static function getDressSeriesAtlas():TextureAtlas{
			if(textureAtlass["DressSeriesTexture"]==null){
				var texture:Texture = getTexture("DressSeriesTexture");
				var xml:XML = store["DressSeriesXML"]
				textureAtlass["DressSeriesTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["DressSeriesTexture"];
		}
		
		public static function getTaskListAtlas():TextureAtlas{
			if(textureAtlass["TaskListTexture"]==null){
				var texture:Texture = getTexture("TaskListTexture");
				var xml:XML = store["TaskListXML"]
				textureAtlass["TaskListTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["TaskListTexture"];
		}
		
		public static function getChatViewAtlas():TextureAtlas{
			if(textureAtlass["ChatViewTexture"]==null){
				var texture:Texture = getTexture("ChatViewTexture");
				var xml:XML = store["ChatViewXML"]
				textureAtlass["ChatViewTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["ChatViewTexture"];
		}
		
		private static function getAndroidGameAtlas():TextureAtlas{
			if(textureAtlass["androidGameTexture"]==null){
				var texture:Texture = getTexture("androidGameTexture");
				var xml:XML = store["androidGameXML"]
				textureAtlass["androidGameTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["androidGameTexture"];
		}
		
		public static function getUnderWaterAtlas():TextureAtlas{
			
			if(textureAtlass["underWaterTexture"]==null){
				var texture:Texture = getTexture("underWaterTexture");
				var xml:XML = store["underWaterXML"]
				textureAtlass["underWaterTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["underWaterTexture"];
			
		}
		
		private static function getPersonSpaceAtlas():TextureAtlas{
			if(textureAtlass["personSpaceTexture"]==null){
				var texture:Texture = getTexture("personSpaceTexture");
				var xml:XML = store["personSpaceXML"]
				textureAtlass["personSpaceTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["personSpaceTexture"];
		}
		
		private static function getEgLearnSpokenAtlas():TextureAtlas{
			if(textureAtlass["EgLearnSpokenTexture"]==null){
				var texture:Texture = getTexture("EgLearnSpokenTexture");
				var xml:XML = store["EgLearnSpokenXML"]
				textureAtlass["EgLearnSpokenTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["EgLearnSpokenTexture"];
		}

		
		private static function getChirstmas():TextureAtlas{
			if(textureAtlass["ChristmasTreeTexture"]==null){
				var texture:Texture = getTexture("ChristmasTreeTexture");
				var xml:XML = store["ChristmasTreeXML"]
				textureAtlass["ChristmasTreeTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["ChristmasTreeTexture"];		}
		
		public static function getPersonalInfoAtlas():TextureAtlas{
			if(textureAtlass["PersonalInfoTexture"]==null){
				var texture:Texture = getTexture("PersonalInfoTexture");
				var xml:XML = store["PersonalInfoXML"]
				textureAtlass["PersonalInfoTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["PersonalInfoTexture"];
		}
		
		
		public static function getSentenceAtlas():TextureAtlas{
			if(textureAtlass["cardsen"]==null){
				var texture:Texture = getTexture("cardsen");
				var xml:XML = store["cardsenXML"]
				textureAtlass["cardsen"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["cardsen"];
		}
		
		
		public static function getTaskAppAtlas():TextureAtlas{
			if(textureAtlass["TaskAppTexture"]==null){
				var texture:Texture = getTexture("TaskAppTexture",2);	//将图缩小1倍
				var xml:XML = store["TaskAppXML"]
				textureAtlass["TaskAppTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["TaskAppTexture"];
		}
		
		public static function getCnClassAtlas():TextureAtlas{
			if(textureAtlass["EnClassroomTexture"]==null){
				var texture:Texture = getTexture("EnClassroomTexture");	//将图缩小1倍
				var xml:XML = store["EnClassroomXML"]
				textureAtlass["EnClassroomTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["EnClassroomTexture"];
		}
		
		public static function getWeixinAtlas():TextureAtlas{
			if(textureAtlass["weixinTexture"]==null){
				var texture:Texture = getTexture("weixinTexture");	
				var xml:XML = store["weixinXML"]
				textureAtlass["weixinTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["weixinTexture"];
		}
		
		public static function getListClassRoomAtlas():TextureAtlas{
			if(textureAtlass["listClassRoomTexture"]==null){
				var texture:Texture = getTexture("listClassRoomTexture");	
				var xml:XML = store["listClassRoomXML"]
				textureAtlass["listClassRoomTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["listClassRoomTexture"];
		}
		
		//pullToFreshTextures
		public static function getPullToFreshAtlas():TextureAtlas{
			if(textureAtlass["pullToFreshTextures"]==null){
				var texture:Texture = getTexture("pullToFreshTextures");	//将图缩小1倍
				var xml:XML = store["pullToFreshXML"]
				textureAtlass["pullToFreshTextures"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["pullToFreshTextures"];
		}
		
		public static function getRunnerGameAtlas():TextureAtlas{
			if(textureAtlass["runerGameTexture"]==null){
				var texture:Texture = getTexture("runerGameTexture");	
				var xml:XML = store["runerGameXML"]
				textureAtlass["runerGameTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["runerGameTexture"];
		}
		
		private static function getTalkingBookAtlas():TextureAtlas{
			if(textureAtlass["talkbookTexture"]==null){
				var texture:Texture = getTexture("talkbookTexture");	
				var xml:XML = store["talkbookXML"]
				textureAtlass["talkbookTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["talkbookTexture"];
		}
		public static function getLXLTestAtals():TextureAtlas{
			if(textureAtlass["lxlMovTexture"]==null){
				var texture:Texture = getTexture("lxlMovTexture");	
				var xml:XML = store["lxlMovXML"]
				textureAtlass["lxlMovTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["lxlMovTexture"];
		}
		
		private static function getReadAloudAtlas():TextureAtlas{
			if(textureAtlass["readAloudTexture"]==null){
				var texture:Texture = getTexture("readAloudTexture");	
				var xml:XML = store["readAloudXML"]
				textureAtlass["readAloudTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["readAloudTexture"];
		}
		
		public static function getAgentAppAtlas():TextureAtlas{
			if(textureAtlass["AgentAppTexture"]==null){
				var texture:Texture = getTexture("AgentAppTexture",2);	//将图缩小1倍
				var xml:XML = store["AgentAppXML"]
				textureAtlass["AgentAppTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["AgentAppTexture"];
		}
		
		public static function getRAnimationAtlas():TextureAtlas{
			if(textureAtlass["RewardAnimationTexture"]==null){
				var texture:Texture = getTexture("RewardAnimationTexture",1,true);	//将图缩小1倍
				var xml:XML = store["RewardAnimationXML"]
				textureAtlass["RewardAnimationTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["RewardAnimationTexture"];
		}
		
		private static function getRewardAtlas():TextureAtlas{
			if(textureAtlass["rewardTexture"]==null){
				var texture:Texture = getTexture("rewardTexture");	
				var xml:XML = store["rewardXML"]
				textureAtlass["rewardTexture"] = new TextureAtlas(texture,xml);
			}
			return textureAtlass["rewardTexture"];
		}

		/**
		 * 
		 * @param name
		 * @return 
		 * @throws ArgumentError
		 */
		public static function getSound(name:String):Sound
		{
			var sound:Sound=sSounds[name] as Sound;
			if (sound)
				return sound;
			else
				throw new ArgumentError("Sound not found: " + name);
		}

		/**
		 * Returns a texture from a texture atlas based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String,scale:Number=1,repeat:Boolean=false):Texture
		{
			if (sTextures[name] == undefined)
			{
				var bitmap:Bitmap=store[name];
				if(!bitmap){
					return null;
				}
				sTextures[name]=Texture.fromBitmap(bitmap,false,false,scale,Context3DTextureFormat.BGRA,repeat);
				
				
				(sTextures[name] as Texture).root.onRestore = function():void
				{
					(sTextures[name] as Texture).root.uploadBitmap(bitmap);
				};
				
			}

			return sTextures[name];
		}
		
		public static function getAtfTexture(name:String):Texture
		{
			if (sTextures[name] == undefined)
			{
				sTextures[name]=Texture.fromAtfData(store[name]);
			}
			
			return sTextures[name];
		}
		
		public static function disposeTexture(name:String):void{
			
			
			if (sTextures[name] != undefined)
			{
				(sTextures[name] as Texture).dispose();
				delete sTextures[name];
			}
			
			if(textureAtlass[name]!= undefined){
				(textureAtlass[name] as TextureAtlas).dispose();
				delete textureAtlass[name];
			}
			
			
		}
		
		public static function getAtlasTexture(name:String):Texture{
			
			if (sTextures[name] == undefined)
			{
				if(!getAtlas()){
					return null;
				}
				return getAtlas().getTexture(name);
			}
			
			return sTextures[name];
			
		}
		
		public static function getChapterAtlasTexture(name:String):Texture{
			
			if (sTextures[name] == undefined)
			{
				return getChapterAtlas().getTexture(name);
			}
			
			return sTextures[name];
			
		}
		
		
		public static function getWordCardAtlasTexture(name:String):Texture{
			if(sTextures[name] == undefined)
			{
				return getWordCardAtlas().getTexture(name);
			}
			return sTextures[name]
		}
		
		public static function getRememberWordCardAtlasTexture(name:String):Texture{
			if(sTextures[name] == undefined){
				return getRememberWordCardAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getEmailAtlasTexture(name:String):Texture{
			if(sTextures[name] == undefined)
			{
				return getEmailAtlas().getTexture(name);
			}
			return sTextures[name]
		}
		
		public static function getMenuAtlasTexture(name:String):Texture{
			if(sTextures[name] == undefined)
			{
				return getMenuAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getWallpaperAtlasTexture(name:String):Texture
		{
			if(sTextures[name]==undefined)
			{
				return getWallpaperAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getEgAtlasTexture(name:String):Texture{
			
			if (sTextures[name] == undefined)
			{
				return getEgLearningAtlas().getTexture(name);
			}
			
			return sTextures[name];
			
		}
		
		public static function getEgLandAtlasTexture(name:String):Texture{
			if(sTextures[name]== undefined)
			{
				return getEgLandAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getRunnerGameTexture(name:String):Texture{
			if(sTextures[name]== undefined)
			{
				return getRunnerGameAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getWhaleInsideTexture(name:String):Texture{
				return getWhaleInsideAtlas().getTexture(name);
		}
		
		public static function getCharaterTexture(name:String):Texture{
			
			if(sTextures[name]== undefined)
			{
				return (charaterTexture.texture as TextureAtlas).getTexture(name);;
			}
			return sTextures[name];
		}
		
		public static function getVideoTexture(name:String):Texture{			
			if(sTextures[name]==undefined)
			{
				return getVideoAtlas().getTexture(name);
			}
			return sTextures[name];
		}
		
		public static function getMarketTexture(name:String):Texture{			
			/*if(sTextures[name]==undefined)
			{*/
				return getMarketAtlas().getTexture(name);
			/*}
			return sTextures[name];*/
		}
		
		public static function getEngTaskIslandTexture(name:String):Texture{			
			/*if(sTextures[name]==undefined)
			{*/
			return getEngTaskIslandAtlas().getTexture(name);
			/*}
			return sTextures[name];*/
		}
		
		public static function getWorldMapTexture(name:String):Texture{
			
			
			if(sTextures[name]==undefined)
			{
				return getWorldMapAtlas().getTexture(name);
			}
			return sTextures[name];
			
			
		}
		
		public static function getBattleGameTexture(name:String):Texture{
			
			if (sTextures[name] == undefined)
			{
				return getBattleGameAtlas().getTexture(name);
			}
			
			return sTextures[name];
			
		}
		
		public static function getFightGameTexture(name:String):Texture{
			
			if (sTextures[name] == undefined)
			{
				return getFightGameAtlas().getTexture(name);
			}
			
			return sTextures[name];
			
		}
		
		
		public static function getSentenceTexture(name:String):Texture{
			if (sTextures[name] == undefined)
			{
				return getSentenceAtlas().getTexture(name);
			}
			
			return sTextures[name];
		}
		
		
		public static function getHappyIslandTexture(name:String):Texture{			
			/*if(sTextures[name]==undefined)
			{*/
			return getHappyIslandAtlas().getTexture(name);
			/*}
			return sTextures[name];*/
		}
		
		public static function getHapIslandHouseTexture(name:String):Texture{			
			/*if(sTextures[name]==undefined)
			{*/
			return getHapIslandHouseAtlas().getTexture(name);
			/*}
			return sTextures[name];*/
		}
		
		public static function getMusicSeriesTexture(name:String):Texture{
			return getMusicSeriesAtlas().getTexture(name);
		}
		
		public static function getUnderWorldTexture(name:String):Texture{			
			/*if(sTextures[name]==undefined)
			{*/
			return getUnderWorldAtlas().getTexture(name);
			/*}
			return sTextures[name];*/
		}
		
		public static function getDressSeriesTexture(name:String):Texture{			
			return getDressSeriesAtlas().getTexture(name);
		}
		
		public static function getTaskListTexture(name:String):Texture{
			return getTaskListAtlas().getTexture(name);
		}
		
		public static function getChatViewTexture(name:String):Texture{
			return getChatViewAtlas().getTexture(name);	
		}
		
		public static function getAndroidGameTexture(name:String):Texture{
			return getAndroidGameAtlas().getTexture(name);
		}
		
		public static function getUnderWaterTexture(name:String):Texture{
			return getUnderWaterAtlas().getTexture(name);
		}
		
		public static function getPersonSpaceTexture(name:String):Texture{
			return getPersonSpaceAtlas().getTexture(name);
		}
		
		public static function getEgLearnSpokenTexture(name:String):Texture{
			return getEgLearnSpokenAtlas().getTexture(name);
		}
		public static function getChristmasTexture(name:String):Texture{
			return getChirstmas().getTexture(name);
		}
		
		public static function getPersonalInfoTexture(name:String):Texture{
			return getPersonalInfoAtlas().getTexture(name);
		}

		//taskApp用
		public static function getTaskAppTexture(name:String):Texture{
			return getTaskAppAtlas().getTexture(name);
		}
		
		public static function getCnClassroomTexture(name:String):Texture{
			return getCnClassAtlas().getTexture(name);
		}
		
		public static function getWeixinTexture(name:String):Texture{
			return getWeixinAtlas().getTexture(name);
		}
		public static function getListClassTexture(name:String):Texture{
			return getListClassRoomAtlas().getTexture(name);
		}
		public static function talkingbookTexture(name:String):Texture{
			return getTalkingBookAtlas().getTexture(name);
		}
		public static function getPullToFresh(name:String):Texture{
			return getPullToFreshAtlas().getTexture(name);
		}
		public static function getLxlTexture(name:String):Texture{
			return getLXLTestAtals().getTexture(name);
		}
		public static function readAloudTexture(name:String):Texture{
			return getReadAloudAtlas().getTexture(name);
		}
		
		//agentApp用
		public static function getAgentAppTexture(name:String):Texture{
			return getAgentAppAtlas().getTexture(name);
		}
		
		public static function getRAnimationTexture(name:String):Texture{
			return getRAnimationAtlas().getTexture(name);
		}
		
		public static function getRewardTexture(name:String):Texture{
			return getRewardAtlas().getTexture(name);
		}
		
		/**
		 * 
		 */
		public static function prepareSounds():void
		{
			return;
			//sSounds["Step"] = new StepSound();   
		}
		
		public static function clean():void{
			
			for each (var i:TextureAtlas in textureAtlass) 
			{
				i.dispose();
			}
			
			
			for each (var j:Texture in sTextures) 
			{
				j.dispose();
			}
			
			
			for each (var k:Object in store) 
			{
				if(k is Bitmap){
					(k as Bitmap).bitmapData.dispose();
				}
				
			}
			
			for each (var i2:BitmapFontVO in bitmapFontStore) 
			{
				i2.texture.dispose();
			}
			
			
			if(petTexture){
				(petTexture.texture as TextureAtlas).dispose();
				petTexture.bitmap.bitmapData.dispose();
			}
			if(charaterTexture){
				(charaterTexture.texture as TextureAtlas).dispose();
				charaterTexture.bitmap.bitmapData.dispose();
			}
			
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as IAssetLibProxy).libs.length=0;
			
			bitmapFontStore = new Dictionary;
			store = new Dictionary();
			textureAtlass = new Dictionary();
			
			
			sTextures = new Dictionary();
			
			
			
			
			
			
		}
		
		
		
		public static function getTextureAtlasBMP(bmp:Bitmap,xml:XML,_fullName:String):Bitmap{
			
			var subXML:XML = xml.children().(@name.toString() == _fullName)[0];
			
			var _rect:Rectangle = new Rectangle(int(subXML.@x), int(subXML.@y), int(subXML.@width), int(subXML.@height));
			var destination:BitmapData = new BitmapData(_rect.width,_rect.height);
			
			destination.copyPixels(bmp.bitmapData, _rect, new Point());
			
			
					
			return new Bitmap(destination);
			
		}
		
		public static function getCharTexture(char:String,_fontname:String="mycomic"):BitmapFontVO{
			
			var fontTName:String;
			var fontXML:XML;
			var charCode:Number = char.charCodeAt(0);
			if(bitmapFontStore[charCode]){
				return bitmapFontStore[charCode];
			}
			
			if(_fontname=="mycomic"){
				fontTName = "MyComic_0";
				fontXML = Assets.store["MyComic"];
			}else if(_fontname=="HK"){
				fontTName = "HuaKanBF_0";
				fontXML = Assets.store["HuaKanBF"];
			}
			
			var fontTexture:Texture = Assets.getAtlasTexture(fontTName);
			
			var charItem:XML = fontXML.chars[0].char.(@id==char.charCodeAt(0))[0];
			if(charItem){
				rectangle.setTo(charItem.@x,charItem.@y,charItem.@width,charItem.@height);
				var t:SubTexture = new SubTexture(fontTexture,rectangle,true);
				
				var bf:BitmapFontVO = new BitmapFontVO();
				bf.texture = t;
				bf.xml = charItem;
				
				bitmapFontStore[charCode] = bf;
				return bf;
			}else{
				return null;
			}
		}
		
		public static function getWordSprite(word:String,_fontName:String="mycomic",letterSpace:int=2):Sprite{
			var result:Sprite = new Sprite();
			var image:Image;
			var t:Texture;
			var nextX:Number=0;
			var bf:BitmapFontVO;
			for (var i:int = 0; i < word.length; i++) 
			{
				
				bf = getCharTexture(word.charAt(i),_fontName);
				t = bf.texture;
				if(t){
					image = new Image(t);
					result.addChild(image);
					image.x = nextX;
					nextX = image.width+image.x+letterSpace;
					image.y+=bf.xml.@yoffset;
				}
			}
			
			
			return result;
		}
	}
}
