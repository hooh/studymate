package com.studyMate.controller
{
	import com.studyMate.world.model.vo.BackgroundMusicVO;

	public class BackgroundMusicProxy extends ConfigProxy
	{
		public var musicList:Vector.<BackgroundMusicVO>;
		
		public function BackgroundMusicProxy(){
			musicList = getMusicList();
		}
		
		public function getMusicList():Vector.<BackgroundMusicVO>{
			var musicList:Vector.<BackgroundMusicVO> = new Vector.<BackgroundMusicVO>;
			var xml:XML = XML(getValueInUser("musicBg"));
			var musics:XMLList = xml.music;
			for(var i:int = 0; i < musics.length(); i++){
				var music:BackgroundMusicVO = new BackgroundMusicVO(musics[i].@id, musics[i].name, musics[i].path);
				musicList.push(music);
			}
			return musicList;
		}
		
		public function addMusic(music:BackgroundMusicVO):void{
			for(var i:int = 0;i<musicList.length;i++){
				if(musicList[i].id == music.id){
					musicList[i] = music;
					break;
				}
			}
			if(i == musicList.length){
				musicList.push(music);
			}
			updateMusicList();
		}
		
		public function deleMusic(music:BackgroundMusicVO):void{
			for(var i:int = 0;i<musicList.length;i++){
				if(musicList[i].id == music.id)	{
					musicList[i] = null;
					musicList.splice(i, 1);
					updateMusicList();
					return;
				}
			}						
		}
		
		public function updateMusicList():void{
			if(musicList == null) return;
			var musicBg:XML = <musicBg></musicBg>;
			var music:XML;
			for(var i:int = 0; i < musicList.length; i++){
				music = <music id={musicList[i].id}>
							<name>{musicList[i].name}</name>
							<path>{musicList[i].path}</path>
						</music>;
				musicBg.appendChild(music);
			}
			updateValueInUser("musicBg",musicBg);
		}
	}
}