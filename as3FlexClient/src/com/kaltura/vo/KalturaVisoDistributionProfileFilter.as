package com.kaltura.vo
{
	import com.kaltura.vo.KalturaVisoDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaVisoDistributionProfileFilter extends KalturaVisoDistributionProfileBaseFilter
	{
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
