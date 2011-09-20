package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAsset extends BaseFlexVo
	{
		public var id : String;

		public var entryId : String;

		public var partnerId : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var version : int = int.MIN_VALUE;

		public var size : int = int.MIN_VALUE;

		public var tags : String;

		public var fileExt : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var deletedAt : int = int.MIN_VALUE;

		public var description : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('fileExt');
			return arr;
		}
	}
}
