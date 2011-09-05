package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSftpDropFolderBaseFilter;

	[Bindable]
	public dynamic class KalturaSftpDropFolderFilter extends KalturaSftpDropFolderBaseFilter
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
