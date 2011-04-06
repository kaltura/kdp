package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPartnerBaseFilter;

	[Bindable]
	public dynamic class KalturaPartnerFilter extends KalturaPartnerBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
