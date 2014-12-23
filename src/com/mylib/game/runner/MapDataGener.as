package com.mylib.game.runner
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class MapDataGener
	{
		private var baseLevelDis:int = 8000;
		private var baseLevelSpeed:int = 5;
		private var baseLevelSpace:int = 1500;
		
		private var pieces:Vector.<Vector.<Number>>;
		
		public function MapDataGener()
		{
			
		}
		
		
		public function moveData(_data:Vector.<Number>,distance:int):Vector.<Number>{
			
			for (var i:int = 0; i < _data.length; i+=2) 
			{
				_data[i]+=distance;
				
			}
			
			return _data;
		}
		
		public function scaleData(_data:Vector.<Number>,scale:Number):Vector.<Number>{
			
			for (var i:int = 0; i < _data.length; i+=2) 
			{
				_data[i]=int(_data[i]*scale);
				
			}
			
			return _data;
		}
		
		public function mergeData():Vector.<Number>{
			var pList:Array = Global.document.resolvePath(Global.localPath+"runnerGen/piece").getDirectoryListing();
			var p:Vector.<Number>;
			var ii:int;
			pieces = new Vector.<Vector.<Number>>;
			for (ii = 0; ii < pList.length; ii++) 
			{
				if((pList[ii] as File).extension=="data"){
					p = readFile(pList[ii]);
					if(p.length%2==1){
						p.pop();
					}
					pieces.push(p);
				}
				
			}
			
			
			
			
			var result:Vector.<Number> = new Vector.<Number>(9999);
			
			var target:int
			var current:int;
			var dis:int=0;
			var i:int = 0;
			var minCount:int = 0;
			var preP:int;
			
			for (var j:int = 0; j < 20; j++) 
			{
				current += baseLevelSpace*(j*0.1+1);
				target = current+baseLevelDis*(j*0.3+1);
				
				result[i] = MapItemType.LEVEL;
				i++;
				result[i] = j+1;
				i++;
				
				
				result[i] = current;
				i++;
				result[i] = MapItemType.SPEEDUP+baseLevelSpeed+j*0.8;
				i++;
				
				result[i] = current;
				i++;
				result[i] = MapItemType.ACCUP+1.4;
				i++;
				
				result[i] = current+140;
				i++;
				result[i] = MapItemType.ACCUP;
				i++;
				
				
				while(current<target){
					
					p = pieces[int(Math.random()*pieces.length)];
					
					for (var k:int = 0; k < p.length; k++) 
					{
						if(k%2==0){
							if(k>=2){
								preP = p[k-2];
							}else{
								preP = p[k];
							}
							current+=p[k]-preP+j*j*5;
							result[i] = current;
						}else{
							result[i] = p[k];
						}
						i++;
						
					}
					current+=300+Math.random()*400;
					
				}
				current+=1280;
				result[i] = current;
				i++;
				result[i] = MapItemType.LEVEL_END;
				i++;
				
				
				
			}
			
			result.length = i;
			
			return result;
		}
		
		
		
		
		
		public function randomPiece():Vector.<Number>{
			var result:Vector.<Number> = new Vector.<Number>(9999);
			
			var target:int = Math.random()*2000+1000;
			var current:int;
			var dis:int=0;
			var i:int=0;
			
			while(current<target){
				
				dis=Math.random()*500;
				
				current+=dis;
				
				result[i] = current;
				i++;
				result[i] = int(Math.random()*MapItemType.items.length)+1;
				i++;
			}
			
			result.length = i;
			
			return result;
		}
		
		public function save(data:Vector.<Number>):void{
			var str:String="";
			
			
			/*for (var i:int = 0; i < data.length; i++) 
			{
				if(!data[i]){
					break;
				}
				str+=data[i];
				str+=",";
			}*/
			str = data.toString();
			
			var file:File = Global.document.resolvePath(Global.localPath+"runner.data");
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeMultiByte(str,PackData.BUFF_ENCODE);
			fileStream.close();
			
			
			
		}
		
		public function readMap():Vector.<Number>{
			return readFile(Global.document.resolvePath(Global.localPath+"runner.data"));
			
		}
		
		public function readFile(file:File):Vector.<Number>{
			
			
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file,FileMode.READ);
			
			var str:String = fileStream.readMultiByte(fileStream.bytesAvailable,PackData.BUFF_ENCODE);
			fileStream.close();
			
			var result:Vector.<Number> = Vector.<Number>(str.split(","));
			
			return result;
			
		}
		
		
		
	}
}