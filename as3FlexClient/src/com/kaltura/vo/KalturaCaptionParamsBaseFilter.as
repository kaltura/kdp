package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsFilter;

	[Bindable]
	public dynamic class KalturaCaptionParamsBaseFilter extends KalturaAssetParamsFilter
	{
		/** 
		* 		* */ 
		public var formatEqual : String = null;

		/** 
		* 		* */ 
		public var formatIn : String = null;

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
