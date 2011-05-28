package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaEntryFilter;

	[Bindable]
	public dynamic class KalturaMediaEntryFilterForPlaylist extends KalturaMediaEntryFilter
	{
		public var limit : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('limit');
			return arr;
		}
	}
}
