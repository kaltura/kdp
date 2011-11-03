package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemUser extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var email : String;

		public var firstName : String;

		public var lastName : String;

		public var password : String;

		public var createdBy : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var isPrimary : Boolean;

		public var statusUpdatedAt : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var role : String;

public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('email');
			arr.push('firstName');
			arr.push('lastName');
			arr.push('password');
			arr.push('status');
			arr.push('role');
			return arr;
		}
	}
}
