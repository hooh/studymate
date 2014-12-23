package com.studyMate.world.screens.chatroom
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	
	/**
	 * 敏感字过滤
	 *  
	 * @author Administrator
	 * 
	 */	
	public class ChatRoomFilterProxy extends Proxy implements IProxy
	{
		public static const NAME :String = "ChatRoomFilterProxy";
		
		
		public var treeRoot:FilterTree;
		
		private var bsArr:Array = [];
		private var bsStr:String = "";
		private var BSFile:File = Global.document.resolvePath(Global.localPath+"systemFile/bs.edu");
		
		public function ChatRoomFilterProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			readFilterFile();
			
			
			
			
		}
		
		
		
		private function readFilterFile():void{
			
			var stream:FileStream = new FileStream();
			if(BSFile.exists){
				stream.open(BSFile,FileMode.READ);
				bsStr = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
				bsArr = bsStr.split(";");
				
				//行程树形结构
				regSensitiveWords(bsArr);
				
				stream.close();
			}else{
				stream.open(BSFile,FileMode.WRITE);
				stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
				stream.close();
				
			}
			
			
		}	
		
		
		public function regSensitiveWords(words:Array):void
		{
			//这是一个预处理步骤，生成敏感词索引树，功耗大于查找时使用的方法，但只在程序开始时调用一次。
			treeRoot = new FilterTree();
			treeRoot.value = "";
			var words_len:int = words.length;
			for (var i:int = 0; i < words_len; i++)
			{
				var word:String = words[i];
				var len:int = word.length;
				var currentBranch:FilterTree = treeRoot;
				for (var c:int = 0; c < len; c++)
				{
					var char:String = word.charAt(c);
					var tmp:FilterTree = currentBranch.getChild(char);
					if (tmp)
					{
						currentBranch = tmp;
					}
					else
					{
						currentBranch = currentBranch.addChild(char);
					} //end if
				} //end for
				currentBranch.isEnd = true;
			} //end for
		} //end of Function
		
		/**
		 *替换字符串中的敏感词返回 
		 * @param dirtyWords
		 * @return 
		 * 
		 */                
		public function replaceSensitiveWord(dirtyWords:String):String
		{
			//
			if(!treeRoot)
			{
				return dirtyWords;
			}
			
			var char:String;
			var curTree:FilterTree = treeRoot;
			var childTree:FilterTree;
			var curEndWordTree:FilterTree;
			var dirtyWord:String;
			
			var c:int = 0;//循环索引
			var endIndex:int = 0;//词尾索引
			var headIndex:int = -1;//敏感词词首索引
			while (c < dirtyWords.length)
			{
				char = dirtyWords.charAt(c);
				childTree = curTree.getChild(char);
				if (childTree)//在树中遍历
				{
					if (childTree.isEnd)
					{
						curEndWordTree = childTree;
						endIndex = c;
					}
					if (headIndex == -1)
					{
						headIndex = c;
					}
					curTree = childTree;
					c++;
				}
				else//跳出树的遍历
				{
					if (curEndWordTree)//如果之前有遍历到词尾，则替换该词尾所在的敏感词，然后设置循环索引为该词尾索引
					{
						dirtyWord = curEndWordTree.getFullWord();
						dirtyWords = dirtyWords.replace(dirtyWord, getReplaceWord(dirtyWord.length));
						c = endIndex;
					}
					else if (curTree != treeRoot)//如果之前有遍历到敏感词非词尾，匹配部分未完全匹配，则设置循环索引为敏感词词首索引
					{
						c = headIndex;
						headIndex = -1;
					}
					curTree = treeRoot;
					curEndWordTree = null;
					c++;
				}
			}
			
			//循环结束时，如果最后一个字符满足敏感词词尾条件，此时满足条件，但未执行替换，在这里补加
			if (curEndWordTree)
			{
				dirtyWord = curEndWordTree.getFullWord();
				dirtyWords = dirtyWords.replace(dirtyWord, getReplaceWord(dirtyWord.length));
			}
			
			return dirtyWords;
		}
		
		/**
		 *判断是否包含敏感词 
		 * @param dirtyWords
		 * @return 
		 * 
		 */                
		public function containsBadWords(dirtyWords:String):Boolean
		{
			var char:String;
			var curTree:FilterTree = treeRoot;
			var childTree:FilterTree;
			var curEndWordTree:FilterTree;
			var dirtyWord:String;
			
			var c:int = 0;//循环索引
			var endIndex:int = 0;//词尾索引
			var headIndex:int = -1;//敏感词词首索引
			while (c < dirtyWords.length)
			{
				char = dirtyWords.charAt(c);
				childTree = curTree.getChild(char);
				if (childTree)//在树中遍历
				{
					if (childTree.isEnd)
					{
						curEndWordTree = childTree;
						endIndex = c;
					}
					if (headIndex == -1)
					{
						headIndex = c;
					}
					curTree = childTree;
					c++;
				}
				else//跳出树的遍历
				{
					if (curEndWordTree)//如果之前有遍历到词尾，则替换该词尾所在的敏感词，然后设置循环索引为该词尾索引
					{
						dirtyWord = curEndWordTree.getFullWord();
						dirtyWords = dirtyWords.replace(dirtyWord, getReplaceWord(dirtyWord.length));
						c = endIndex;
						return true;
					}
					else if (curTree != treeRoot)//如果之前有遍历到敏感词非词尾，匹配部分未完全匹配，则设置循环索引为敏感词词首索引
					{
						c = headIndex;
						headIndex = -1;
					}
					curTree = treeRoot;
					curEndWordTree = null;
					c++;
				}
			}
			
			//循环结束时，如果最后一个字符满足敏感词词尾条件，此时满足条件，但未执行替换，在这里补加
			if (curEndWordTree)
			{
				return true;
				dirtyWord = curEndWordTree.getFullWord();
				dirtyWords = dirtyWords.replace(dirtyWord, getReplaceWord(dirtyWord.length));
			}
			return false;
		}
		
		private function getReplaceWord(len:uint):String
		{
			var replaceWord:String = "";
			for (var i:uint = 0; i < len; i++)
			{
				replaceWord += "*";
			}
			return replaceWord;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			treeRoot = null;
		
		}
		
		
	}
}