package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAuditTrailInfo;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAuditTrail extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var parsedAt : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var auditObjectType : String;

		public var objectId : String;

		public var relatedObjectId : String;

		public var relatedObjectType : String;

		public var entryId : String;

		public var masterPartnerId : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var requestId : String;

		public var userId : String;

		public var action : String;

		public var data : KalturaAuditTrailInfo;

		public var ks : String;

		public var context : int = int.MIN_VALUE;

		public var entryPoint : String;

		public var serverName : String;

		public var ipAddress : String;

		public var userAgent : String;

		public var clientTag : String;

		public var description : String;

		public var errorDescription : String;

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
	}
}
