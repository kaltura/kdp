package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUploadTokenBaseFilter;

	[Bindable]
	public dynamic class KalturaUploadTokenFilter extends KalturaUploadTokenBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
