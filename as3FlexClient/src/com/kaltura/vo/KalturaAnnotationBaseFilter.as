package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAnnotationBaseFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;

		public var entryIdEqual : String;

		public var parentIdEqual : String;

		public var parentIdIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var userIdEqual : String;

		public var userIdIn : String;

override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('entryIdEqual');
			arr.push('parentIdEqual');
			arr.push('parentIdIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('userIdEqual');
			arr.push('userIdIn');
			return arr;
		}
	}
}
