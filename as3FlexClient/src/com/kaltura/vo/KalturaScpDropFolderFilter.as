package com.kaltura.vo
{
	import com.kaltura.vo.KalturaScpDropFolderBaseFilter;

	[Bindable]
	public dynamic class KalturaScpDropFolderFilter extends KalturaScpDropFolderBaseFilter
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
