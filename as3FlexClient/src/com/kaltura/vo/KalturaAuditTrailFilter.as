package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailBaseFilter;

	[Bindable]
	public dynamic class KalturaAuditTrailFilter extends KalturaAuditTrailBaseFilter
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
