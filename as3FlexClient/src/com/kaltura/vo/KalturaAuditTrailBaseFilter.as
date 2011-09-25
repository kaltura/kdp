package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAuditTrailBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var parsedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var parsedAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var auditObjectTypeEqual : String = null;

		/** 
		* 		* */ 
		public var auditObjectTypeIn : String = null;

		/** 
		* 		* */ 
		public var objectIdEqual : String = null;

		/** 
		* 		* */ 
		public var objectIdIn : String = null;

		/** 
		* 		* */ 
		public var relatedObjectIdEqual : String = null;

		/** 
		* 		* */ 
		public var relatedObjectIdIn : String = null;

		/** 
		* 		* */ 
		public var relatedObjectTypeEqual : String = null;

		/** 
		* 		* */ 
		public var relatedObjectTypeIn : String = null;

		/** 
		* 		* */ 
		public var entryIdEqual : String = null;

		/** 
		* 		* */ 
		public var entryIdIn : String = null;

		/** 
		* 		* */ 
		public var masterPartnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var masterPartnerIdIn : String = null;

		/** 
		* 		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerIdIn : String = null;

		/** 
		* 		* */ 
		public var requestIdEqual : String = null;

		/** 
		* 		* */ 
		public var requestIdIn : String = null;

		/** 
		* 		* */ 
		public var userIdEqual : String = null;

		/** 
		* 		* */ 
		public var userIdIn : String = null;

		/** 
		* 		* */ 
		public var actionEqual : String = null;

		/** 
		* 		* */ 
		public var actionIn : String = null;

		/** 
		* 		* */ 
		public var ksEqual : String = null;

		/** 
		* 		* */ 
		public var contextEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var contextIn : String = null;

		/** 
		* 		* */ 
		public var entryPointEqual : String = null;

		/** 
		* 		* */ 
		public var entryPointIn : String = null;

		/** 
		* 		* */ 
		public var serverNameEqual : String = null;

		/** 
		* 		* */ 
		public var serverNameIn : String = null;

		/** 
		* 		* */ 
		public var ipAddressEqual : String = null;

		/** 
		* 		* */ 
		public var ipAddressIn : String = null;

		/** 
		* 		* */ 
		public var clientTagEqual : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('parsedAtGreaterThanOrEqual');
			arr.push('parsedAtLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('auditObjectTypeEqual');
			arr.push('auditObjectTypeIn');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('relatedObjectIdEqual');
			arr.push('relatedObjectIdIn');
			arr.push('relatedObjectTypeEqual');
			arr.push('relatedObjectTypeIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('masterPartnerIdEqual');
			arr.push('masterPartnerIdIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('requestIdEqual');
			arr.push('requestIdIn');
			arr.push('userIdEqual');
			arr.push('userIdIn');
			arr.push('actionEqual');
			arr.push('actionIn');
			arr.push('ksEqual');
			arr.push('contextEqual');
			arr.push('contextIn');
			arr.push('entryPointEqual');
			arr.push('entryPointIn');
			arr.push('serverNameEqual');
			arr.push('serverNameIn');
			arr.push('ipAddressEqual');
			arr.push('ipAddressIn');
			arr.push('clientTagEqual');
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
