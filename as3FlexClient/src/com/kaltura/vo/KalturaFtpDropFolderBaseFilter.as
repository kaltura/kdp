package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDropFolderFilter;

	[Bindable]
	public dynamic class KalturaFtpDropFolderBaseFilter extends KalturaDropFolderFilter
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
