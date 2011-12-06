package com.kaltura.vo
{
	import com.kaltura.vo.KalturaIdeticDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaIdeticDistributionProfileFilter extends KalturaIdeticDistributionProfileBaseFilter
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
