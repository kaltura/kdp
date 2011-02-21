package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadataProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var metadataObjectType : int = int.MIN_VALUE;

		public var version : int = int.MIN_VALUE;

		public var name : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var xsd : String;

		public var views : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('metadataObjectType');
			arr.push('name');
			return arr;
		}
	}
}
