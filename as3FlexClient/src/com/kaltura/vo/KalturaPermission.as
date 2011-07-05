package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPermission extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var type : int = int.MIN_VALUE;

		public var name : String;

		public var friendlyName : String;

		public var description : String;

		public var status : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var dependsOnPermissionNames : String;

		public var tags : String;

		public var permissionItemsIds : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerGroup : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('friendlyName');
			arr.push('description');
			arr.push('status');
			arr.push('dependsOnPermissionNames');
			arr.push('tags');
			arr.push('permissionItemsIds');
			arr.push('partnerGroup');
			return arr;
		}
	}
}
