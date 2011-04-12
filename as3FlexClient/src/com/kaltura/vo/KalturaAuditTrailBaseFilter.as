package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAuditTrailBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var parsedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var parsedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		public var auditObjectTypeEqual : String;

		public var auditObjectTypeIn : String;

		public var objectIdEqual : String;

		public var objectIdIn : String;

		public var relatedObjectIdEqual : String;

		public var relatedObjectIdIn : String;

		public var relatedObjectTypeEqual : String;

		public var relatedObjectTypeIn : String;

		public var entryIdEqual : String;

		public var entryIdIn : String;

		public var masterPartnerIdEqual : int = int.MIN_VALUE;

		public var masterPartnerIdIn : String;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var requestIdEqual : String;

		public var requestIdIn : String;

		public var userIdEqual : String;

		public var userIdIn : String;

		public var actionEqual : String;

		public var actionIn : String;

		public var ksEqual : String;

		public var contextEqual : int = int.MIN_VALUE;

		public var contextIn : String;

		public var entryPointEqual : String;

		public var entryPointIn : String;

		public var serverNameEqual : String;

		public var serverNameIn : String;

		public var ipAddressEqual : String;

		public var ipAddressIn : String;

		public var clientTagEqual : String;

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
	}
}
