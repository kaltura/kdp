package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaGenericDistributionProviderActionBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var idIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var genericDistributionProviderIdEqual : int = int.MIN_VALUE;

		public var genericDistributionProviderIdIn : String;

		public var actionEqual : int = int.MIN_VALUE;

		public var actionIn : String;

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
			arr.push('genericDistributionProviderIdEqual');
			arr.push('genericDistributionProviderIdIn');
			arr.push('actionEqual');
			arr.push('actionIn');
			return arr;
		}
	}
}
