package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProviderFilter;

	[Bindable]
	public dynamic class KalturaGenericDistributionProviderBaseFilter extends KalturaDistributionProviderFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var isDefaultEqual : Boolean;

		public var isDefaultIn : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('isDefaultEqual');
			arr.push('isDefaultIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}
	}
}
