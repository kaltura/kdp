package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSshDropFolder;

	[Bindable]
	public dynamic class KalturaSftpDropFolder extends KalturaSshDropFolder
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
