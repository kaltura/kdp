package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaPlayableEntry extends KalturaBaseEntry
	{
		public var plays : int = int.MIN_VALUE;

		public var views : int = int.MIN_VALUE;

		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public var duration : int = int.MIN_VALUE;

		public var msDuration : int = int.MIN_VALUE;

		public var durationType : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
