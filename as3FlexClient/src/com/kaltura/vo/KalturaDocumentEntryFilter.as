package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDocumentEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaDocumentEntryFilter extends KalturaDocumentEntryBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
