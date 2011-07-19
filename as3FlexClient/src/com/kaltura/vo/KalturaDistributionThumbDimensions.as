package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionThumbDimensions extends BaseFlexVo
	{
		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('width');
			arr.push('height');
			return arr;
		}
	}
}
