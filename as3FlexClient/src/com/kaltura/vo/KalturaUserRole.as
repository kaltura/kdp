package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUserRole extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var name : String;

		public var description : String;

		public var status : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var permissionNames : String;

		public var tags : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('status');
			arr.push('permissionNames');
			arr.push('tags');
			return arr;
		}
	}
}
