package com.kaltura.vo
{
	import com.kaltura.vo.KalturaRemoteDropFolderBaseFilter;

	[Bindable]
	public dynamic class KalturaRemoteDropFolderFilter extends KalturaRemoteDropFolderBaseFilter
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
