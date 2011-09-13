package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailInfo;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAuditTrail extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Indicates when the data was parsed		* */ 
		public var parsedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var auditObjectType : String = null;

		/** 
		* 		* */ 
		public var objectId : String = null;

		/** 
		* 		* */ 
		public var relatedObjectId : String = null;

		/** 
		* 		* */ 
		public var relatedObjectType : String = null;

		/** 
		* 		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var masterPartnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var requestId : String = null;

		/** 
		* 		* */ 
		public var userId : String = null;

		/** 
		* 		* */ 
		public var action : String = null;

		/** 
		* 		* */ 
		public var data : KalturaAuditTrailInfo;

		/** 
		* 		* */ 
		public var ks : String = null;

		/** 
		* 		* */ 
		public var context : int = int.MIN_VALUE;

		/** 
		* The API service and action that called and caused this audit		* */ 
		public var entryPoint : String = null;

		/** 
		* 		* */ 
		public var serverName : String = null;

		/** 
		* 		* */ 
		public var ipAddress : String = null;

		/** 
		* 		* */ 
		public var userAgent : String = null;

		/** 
		* 		* */ 
		public var clientTag : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var errorDescription : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('auditObjectType');
			arr.push('objectId');
			arr.push('relatedObjectId');
			arr.push('relatedObjectType');
			arr.push('entryId');
			arr.push('userId');
			arr.push('action');
			arr.push('data');
			arr.push('clientTag');
			arr.push('description');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
