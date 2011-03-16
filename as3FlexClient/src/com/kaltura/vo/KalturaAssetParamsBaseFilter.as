package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsBaseFilter extends KalturaFilter
	{
		public var isSystemDefaultEqual : int = int.MIN_VALUE;

		public var formatEqual : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isSystemDefaultEqual');
			arr.push('formatEqual');
			return arr;
		}
	}
}
