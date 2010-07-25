package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaFileSyncFilter extends KalturaFilter
	{
		public var partnerIdEqual : int = int.MIN_VALUE;
		public var objectTypeEqual : int = int.MIN_VALUE;
		public var objectTypeIn : String;
		public var objectIdEqual : String;
		public var objectIdIn : String;
		public var versionEqual : String;
		public var versionIn : String;
		public var objectSubTypeEqual : int = int.MIN_VALUE;
		public var objectSubTypeIn : String;
		public var dcEqual : String;
		public var dcIn : String;
		public var originalEqual : int = int.MIN_VALUE;
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;
		public var readyAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var readyAtLessThanOrEqual : int = int.MIN_VALUE;
		public var syncTimeGreaterThanOrEqual : int = int.MIN_VALUE;
		public var syncTimeLessThanOrEqual : int = int.MIN_VALUE;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		public var fileTypeEqual : int = int.MIN_VALUE;
		public var fileTypeIn : String;
		public var linkedIdEqual : int = int.MIN_VALUE;
		public var linkCountGreaterThanOrEqual : int = int.MIN_VALUE;
		public var linkCountLessThanOrEqual : int = int.MIN_VALUE;
		public var fileSizeGreaterThanOrEqual : int = int.MIN_VALUE;
		public var fileSizeLessThanOrEqual : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('partnerIdEqual');
			propertyList.push('objectTypeEqual');
			propertyList.push('objectTypeIn');
			propertyList.push('objectIdEqual');
			propertyList.push('objectIdIn');
			propertyList.push('versionEqual');
			propertyList.push('versionIn');
			propertyList.push('objectSubTypeEqual');
			propertyList.push('objectSubTypeIn');
			propertyList.push('dcEqual');
			propertyList.push('dcIn');
			propertyList.push('originalEqual');
			propertyList.push('createdAtGreaterThanOrEqual');
			propertyList.push('createdAtLessThanOrEqual');
			propertyList.push('updatedAtGreaterThanOrEqual');
			propertyList.push('updatedAtLessThanOrEqual');
			propertyList.push('readyAtGreaterThanOrEqual');
			propertyList.push('readyAtLessThanOrEqual');
			propertyList.push('syncTimeGreaterThanOrEqual');
			propertyList.push('syncTimeLessThanOrEqual');
			propertyList.push('statusEqual');
			propertyList.push('statusIn');
			propertyList.push('fileTypeEqual');
			propertyList.push('fileTypeIn');
			propertyList.push('linkedIdEqual');
			propertyList.push('linkCountGreaterThanOrEqual');
			propertyList.push('linkCountLessThanOrEqual');
			propertyList.push('fileSizeGreaterThanOrEqual');
			propertyList.push('fileSizeLessThanOrEqual');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('partnerIdEqual');
			arr.push('objectTypeEqual');
			arr.push('objectTypeIn');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('versionEqual');
			arr.push('versionIn');
			arr.push('objectSubTypeEqual');
			arr.push('objectSubTypeIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('originalEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('readyAtGreaterThanOrEqual');
			arr.push('readyAtLessThanOrEqual');
			arr.push('syncTimeGreaterThanOrEqual');
			arr.push('syncTimeLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('fileTypeEqual');
			arr.push('fileTypeIn');
			arr.push('linkedIdEqual');
			arr.push('linkCountGreaterThanOrEqual');
			arr.push('linkCountLessThanOrEqual');
			arr.push('fileSizeGreaterThanOrEqual');
			arr.push('fileSizeLessThanOrEqual');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('partnerIdEqual');
			arr.push('objectTypeEqual');
			arr.push('objectTypeIn');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('versionEqual');
			arr.push('versionIn');
			arr.push('objectSubTypeEqual');
			arr.push('objectSubTypeIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('originalEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('readyAtGreaterThanOrEqual');
			arr.push('readyAtLessThanOrEqual');
			arr.push('syncTimeGreaterThanOrEqual');
			arr.push('syncTimeLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('fileTypeEqual');
			arr.push('fileTypeIn');
			arr.push('linkedIdEqual');
			arr.push('linkCountGreaterThanOrEqual');
			arr.push('linkCountLessThanOrEqual');
			arr.push('fileSizeGreaterThanOrEqual');
			arr.push('fileSizeLessThanOrEqual');
			return arr;
		}

	}
}
