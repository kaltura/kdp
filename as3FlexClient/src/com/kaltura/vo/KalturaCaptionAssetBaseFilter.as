package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetFilter;

	[Bindable]
	public dynamic class KalturaCaptionAssetBaseFilter extends KalturaAssetFilter
	{
		/** 
		* 		* */ 
		public var formatEqual : String;

		/** 
		* 		* */ 
		public var formatIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('formatEqual');
			arr.push('formatIn');
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
