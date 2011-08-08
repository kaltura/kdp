package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadata extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var metadataProfileId : int = int.MIN_VALUE;

		public var metadataProfileVersion : int = int.MIN_VALUE;

		public var metadataObjectType : int = int.MIN_VALUE;

		public var objectId : String;

		public var version : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var xml : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
