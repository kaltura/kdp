package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaBaseJobBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idGreaterThanOrEqual : int = int.MIN_VALUE;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var partnerIdNotIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var processorExpirationGreaterThanOrEqual : int = int.MIN_VALUE;

		public var processorExpirationLessThanOrEqual : int = int.MIN_VALUE;

		public var executionAttemptsGreaterThanOrEqual : int = int.MIN_VALUE;

		public var executionAttemptsLessThanOrEqual : int = int.MIN_VALUE;

		public var lockVersionGreaterThanOrEqual : int = int.MIN_VALUE;

		public var lockVersionLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idGreaterThanOrEqual');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('partnerIdNotIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('processorExpirationGreaterThanOrEqual');
			arr.push('processorExpirationLessThanOrEqual');
			arr.push('executionAttemptsGreaterThanOrEqual');
			arr.push('executionAttemptsLessThanOrEqual');
			arr.push('lockVersionGreaterThanOrEqual');
			arr.push('lockVersionLessThanOrEqual');
			return arr;
		}
	}
}
