package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDropFolderFileBaseFilter;

	[Bindable]
	public dynamic class KalturaDropFolderFileFilter extends KalturaDropFolderFileBaseFilter
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
