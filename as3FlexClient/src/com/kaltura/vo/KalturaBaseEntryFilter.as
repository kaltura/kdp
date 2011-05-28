package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaBaseEntryFilter extends KalturaBaseEntryBaseFilter
	{
		public var freeText : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('freeText');
			return arr;
		}
	}
}
