package com.kaltura.vo
{
	import com.kaltura.vo.KalturaVirusScanProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaVirusScanProfileFilter extends KalturaVirusScanProfileBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
