package com.kaltura.vo
{
	import com.kaltura.vo.KalturaShortLinkBaseFilter;

	[Bindable]
	public dynamic class KalturaShortLinkFilter extends KalturaShortLinkBaseFilter
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
