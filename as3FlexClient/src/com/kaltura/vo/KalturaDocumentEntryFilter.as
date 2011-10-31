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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
