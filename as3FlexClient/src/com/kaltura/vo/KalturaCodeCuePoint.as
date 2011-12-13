package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCuePoint;

	[Bindable]
	public dynamic class KalturaCodeCuePoint extends KalturaCuePoint
	{
		/** 
		* 		* */ 
		public var code : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var endTime : int = int.MIN_VALUE;

		/** 
		* Duration in milliseconds		* */ 
		public var duration : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('code');
			arr.push('description');
			arr.push('endTime');
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
