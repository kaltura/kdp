package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAssetBaseFilter extends KalturaFilter
	{
		public var idEqual : String;

		public var idIn : String;

		public var entryIdEqual : String;

		public var entryIdIn : String;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		public var statusNotIn : String;

		public var sizeGreaterThanOrEqual : int = int.MIN_VALUE;

		public var sizeLessThanOrEqual : int = int.MIN_VALUE;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var deletedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var deletedAtLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			arr.push('sizeGreaterThanOrEqual');
			arr.push('sizeLessThanOrEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('deletedAtGreaterThanOrEqual');
			arr.push('deletedAtLessThanOrEqual');
			return arr;
		}
	}
}
