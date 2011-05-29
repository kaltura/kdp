package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUser extends BaseFlexVo
	{
		public var id : String;

		public var partnerId : int = int.MIN_VALUE;

		public var screenName : String;

		public var fullName : String;

		public var email : String;

		public var dateOfBirth : int = int.MIN_VALUE;

		public var country : String;

		public var state : String;

		public var city : String;

		public var zip : String;

		public var thumbnailUrl : String;

		public var description : String;

		public var tags : String;

		public var adminTags : String;

		public var gender : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var partnerData : String;

		public var indexedPartnerDataInt : int = int.MIN_VALUE;

		public var indexedPartnerDataString : String;

		public var storageSize : int = int.MIN_VALUE;

		public var password : String;

		public var firstName : String;

		public var lastName : String;

		public var isAdmin : Boolean;

		public var lastLoginTime : int = int.MIN_VALUE;

		public var statusUpdatedAt : int = int.MIN_VALUE;

		public var deletedAt : int = int.MIN_VALUE;

		public var loginEnabled : Boolean;

		public var roleIds : String;

		public var roleNames : String;

		public var isAccountOwner : Boolean;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('screenName');
			arr.push('fullName');
			arr.push('email');
			arr.push('dateOfBirth');
			arr.push('country');
			arr.push('state');
			arr.push('city');
			arr.push('zip');
			arr.push('thumbnailUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('adminTags');
			arr.push('gender');
			arr.push('status');
			arr.push('partnerData');
			arr.push('indexedPartnerDataInt');
			arr.push('indexedPartnerDataString');
			arr.push('firstName');
			arr.push('lastName');
			arr.push('isAdmin');
			arr.push('roleIds');
			return arr;
		}
	}
}
