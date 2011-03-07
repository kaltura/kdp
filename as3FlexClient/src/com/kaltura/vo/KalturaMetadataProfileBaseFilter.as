package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaMetadataProfileBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var metadataObjectTypeEqual : int = int.MIN_VALUE;

		public var versionEqual : int = int.MIN_VALUE;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('partnerIdEqual');
			arr.push('metadataObjectTypeEqual');
			arr.push('versionEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}
	}
}
