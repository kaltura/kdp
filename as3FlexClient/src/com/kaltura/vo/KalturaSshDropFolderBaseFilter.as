package com.kaltura.vo
{
	import com.kaltura.vo.KalturaRemoteDropFolderFilter;

	[Bindable]
	public dynamic class KalturaSshDropFolderBaseFilter extends KalturaRemoteDropFolderFilter
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
