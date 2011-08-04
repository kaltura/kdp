package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaPlayableEntry extends KalturaBaseEntry
	{
		/** 
		* Number of plays
		* */ 
		public var plays : int = int.MIN_VALUE;

		/** 
		* Number of views
		* */ 
		public var views : int = int.MIN_VALUE;

		/** 
		* The width in pixels
		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* The height in pixels
		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* The duration in seconds
		* */ 
		public var duration : int = int.MIN_VALUE;

		/** 
		* The duration in miliseconds
		* */ 
		public var msDuration : int = int.MIN_VALUE;

		/** 
		* The duration type (short for 0-4 mins, medium for 4-20 mins, long for 20+ mins)
		* */ 
		public var durationType : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
