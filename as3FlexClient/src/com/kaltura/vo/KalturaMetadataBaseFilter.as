package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaMetadataBaseFilter extends KalturaFilter
	{
		public var partnerIdEqual : int = int.MIN_VALUE;

		public var metadataProfileIdEqual : int = int.MIN_VALUE;

		public var metadataProfileVersionEqual : int = int.MIN_VALUE;

		public var metadataProfileVersionGreaterThanOrEqual : int = int.MIN_VALUE;

		public var metadataProfileVersionLessThanOrEqual : int = int.MIN_VALUE;

		public var metadataObjectTypeEqual : int = int.MIN_VALUE;

		public var objectIdEqual : String;

		public var objectIdIn : String;

		public var versionEqual : int = int.MIN_VALUE;

		public var versionGreaterThanOrEqual : int = int.MIN_VALUE;

		public var versionLessThanOrEqual : int = int.MIN_VALUE;

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
			arr.push('partnerIdEqual');
			arr.push('metadataProfileIdEqual');
			arr.push('metadataProfileVersionEqual');
			arr.push('metadataProfileVersionGreaterThanOrEqual');
			arr.push('metadataProfileVersionLessThanOrEqual');
			arr.push('metadataObjectTypeEqual');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('versionEqual');
			arr.push('versionGreaterThanOrEqual');
			arr.push('versionLessThanOrEqual');
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
