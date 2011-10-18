package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsFilter;

	[Bindable]
	public dynamic class KalturaThumbParamsBaseFilter extends KalturaAssetParamsFilter
	{
		/** 
		* 		* */ 
		public var formatEqual : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('formatEqual');
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
