package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSshDropFolderFilter;

	[Bindable]
	public dynamic class KalturaScpDropFolderBaseFilter extends KalturaSshDropFolderFilter
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
