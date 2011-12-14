package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMailJobBaseFilter;

	[Bindable]
	public dynamic class KalturaMailJobFilter extends KalturaMailJobBaseFilter
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
