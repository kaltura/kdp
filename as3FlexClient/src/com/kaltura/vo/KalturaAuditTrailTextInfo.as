package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailInfo;

	[Bindable]
	public dynamic class KalturaAuditTrailTextInfo extends KalturaAuditTrailInfo
	{
		/** 
		* 		* */ 
		public var info : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('info');
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
