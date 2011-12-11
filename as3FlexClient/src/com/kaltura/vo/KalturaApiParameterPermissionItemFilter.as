package com.kaltura.vo
{
	import com.kaltura.vo.KalturaApiParameterPermissionItemBaseFilter;

	[Bindable]
	public dynamic class KalturaApiParameterPermissionItemFilter extends KalturaApiParameterPermissionItemBaseFilter
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
