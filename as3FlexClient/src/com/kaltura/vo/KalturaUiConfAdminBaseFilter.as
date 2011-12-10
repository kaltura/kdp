package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUiConfFilter;

	[Bindable]
	public dynamic class KalturaUiConfAdminBaseFilter extends KalturaUiConfFilter
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
