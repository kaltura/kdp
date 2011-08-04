package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaBaseEntryFilter extends KalturaBaseEntryBaseFilter
	{
		/** 
		* 		* */ 
		public var freeText : String;

		/** 
		* 		* */ 
		public var isRoot : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('freeText');
			arr.push('isRoot');
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
