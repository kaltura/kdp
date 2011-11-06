package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSshDropFolderBaseFilter;

	[Bindable]
	public dynamic class KalturaSshDropFolderFilter extends KalturaSshDropFolderBaseFilter
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
