package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryContextDataParams extends BaseFlexVo
	{
		public var referrer : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('referrer');
			return arr;
		}
	}
}
