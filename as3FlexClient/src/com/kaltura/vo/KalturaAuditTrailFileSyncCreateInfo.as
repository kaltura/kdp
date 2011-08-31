package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailInfo;

	[Bindable]
	public dynamic class KalturaAuditTrailFileSyncCreateInfo extends KalturaAuditTrailInfo
	{
		/** 
		* 		* */ 
		public var version : String = null;

		/** 
		* 		* */ 
		public var objectSubType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dc : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var original : Boolean;

		/** 
		* 		* */ 
		public var fileType : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('version');
			arr.push('objectSubType');
			arr.push('dc');
			arr.push('original');
			arr.push('fileType');
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
