package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailInfo;

	[Bindable]
	public dynamic class KalturaAuditTrailChangeInfo extends KalturaAuditTrailInfo
	{
		/** 
		* 		* */ 
		public var changedItems : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('changedItems');
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
