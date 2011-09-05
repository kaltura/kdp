package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUiConfAdminBaseFilter;

	[Bindable]
	public dynamic class KalturaUiConfAdminFilter extends KalturaUiConfAdminBaseFilter
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
