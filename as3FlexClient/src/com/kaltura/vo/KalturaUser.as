package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUser extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var screenName : String = null;

		/** 
		* DEPRECATED		* */ 
		public var fullName : String = null;

		/** 
		* 		* */ 
		public var email : String = null;

		/** 
		* 		* */ 
		public var dateOfBirth : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var country : String = null;

		/** 
		* 		* */ 
		public var state : String = null;

		/** 
		* 		* */ 
		public var city : String = null;

		/** 
		* 		* */ 
		public var zip : String = null;

		/** 
		* 		* */ 
		public var thumbnailUrl : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* Admin tags can be updated only by using an admin session		* */ 
		public var adminTags : String = null;

		/** 
		* 		* */ 
		public var gender : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* Creation date as Unix timestamp (In seconds)		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Last update date as Unix timestamp (In seconds)		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* Can be used to store various partner related data as a string 		* */ 
		public var partnerData : String = null;

		/** 
		* 		* */ 
		public var indexedPartnerDataInt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var indexedPartnerDataString : String = null;

		/** 
		* 		* */ 
		public var storageSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var password : String = null;

		/** 
		* 		* */ 
		public var firstName : String = null;

		/** 
		* 		* */ 
		public var lastName : String = null;

		/** 
		* 		* */ 
		public var isAdmin : Boolean;

		/** 
		* 		* */ 
		public var lastLoginTime : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusUpdatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var deletedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var loginEnabled : Boolean;

		/** 
		* 		* */ 
		public var roleIds : String = null;

		/** 
		* 		* */ 
		public var roleNames : String = null;

		/** 
		* 		* */ 
		public var isAccountOwner : Boolean;

		/** 
		* 		* */ 
		public var allowedPartnerIds : String = null;

		/** 
		* 		* */ 
		public var allowedPartnerPackages : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
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
			arr.push('allowedPartnerIds');
			arr.push('allowedPartnerPackages');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('password');
			return arr;
		}

	}
}
