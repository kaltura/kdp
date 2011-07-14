package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSearchAuthData extends BaseFlexVo
	{
		/** 
		* The authentication data that further should be used for search
		* */ 
		public var authData : String;

		/** 
		* Login URL when user need to sign-in and authorize the search		* */ 
		public var loginUrl : String;

		/** 
		* Information when there was an error		* */ 
		public var message : String;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('authData');
			arr.push('loginUrl');
			arr.push('message');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
