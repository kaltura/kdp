package com.kaltura.vo
{
	import com.kaltura.vo.KalturaNotificationBaseFilter;

	[Bindable]
	public dynamic class KalturaNotificationFilter extends KalturaNotificationBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
