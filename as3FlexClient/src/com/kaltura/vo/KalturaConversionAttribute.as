package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionAttribute extends BaseFlexVo
	{
		public var flavorParamsId : int = int.MIN_VALUE;

		public var name : String;

		public var value : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorParamsId');
			arr.push('name');
			arr.push('value');
			return arr;
		}
	}
}
