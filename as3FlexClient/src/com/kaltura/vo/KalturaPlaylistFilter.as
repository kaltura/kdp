package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlaylistBaseFilter;

	[Bindable]
	public dynamic class KalturaPlaylistFilter extends KalturaPlaylistBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
