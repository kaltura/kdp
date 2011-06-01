package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPermissionItem extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var type : String;

		public var partnerId : int = int.MIN_VALUE;

		public var tags : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			return arr;
		}
	}
}
