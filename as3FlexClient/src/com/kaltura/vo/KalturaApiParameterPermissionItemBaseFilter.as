package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPermissionItemFilter;

	[Bindable]
	public dynamic class KalturaApiParameterPermissionItemBaseFilter extends KalturaPermissionItemFilter
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
