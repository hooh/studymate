package com.studyMate.world.model.vo
{
	public class PromiseInf
	{
		private var _unFinishCount:int;
		private var _minTarget:int;
		private var _newFinishCount:int;
		
		public function PromiseInf(){
		}

		public function get newFinishCount():int
		{
			return _newFinishCount;
		}

		public function set newFinishCount(value:int):void
		{
			_newFinishCount = value;
		}

		public function get minTarget():int
		{
			return _minTarget;
		}

		public function set minTarget(value:int):void
		{
			_minTarget = value;
		}

		public function get unFinishCount():int
		{
			return _unFinishCount;
		}

		public function set unFinishCount(value:int):void
		{
			_unFinishCount = value;
		}

	}
}