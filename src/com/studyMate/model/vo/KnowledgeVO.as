package com.studyMate.model.vo
{
	import de.polygonal.ds.TreeNode;

	public class KnowledgeVO
	{
		/**
		 * 树形路径标识；
		 */
		public var treeid:int;
		/**
		 * 应用路径类型；
		 */
		public var treekd:String;
		/**
		 *当前路径串；
		 */
		public var pathstr:String;
		/**
		 *归属父路径标识；取值-1表示没有父路径 
		 */
		public var ptreeid:int;
		/**
		 *在同一父路径下的显示顺序号
		 */
		public var seqno:int;
		
		/**
		 *关联英语知识点标识; 
		 */
		public var yyzsid:int;
		public function KnowledgeVO(_treeid:int,_treekd:String,_pathstr:String,_ptreeid:int,_seqno:int,_yyzsid:int)
		{
			this.treeid = _treeid;
			this.treekd = _treekd;
			this.pathstr = _pathstr;
			this.ptreeid = _ptreeid;
			this.seqno = _seqno;
			this.yyzsid = _yyzsid;
		}
	}
}