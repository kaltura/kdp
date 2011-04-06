package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAssetParams extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var name : String;

		public var description : String;

		public var createdAt : int = int.MIN_VALUE;

		public var isSystemDefault : int = int.MIN_VALUE;

		public var tags : String;

		public var format : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('tags');
			arr.push('format');
			return arr;
		}
	}
}
