package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSearch extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var keyWords : String = null;

		/** 
		* 		* */ 
		public var searchSource : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var mediaType : int = int.MIN_VALUE;

		/** 
		* Use this field to pass dynamic data for searching
For example - if you set this field to "mymovies_$partner_id"
The $partner_id will be automatically replcaed with your real partner Id
		* */ 
		public var extraData : String = null;

		/** 
		* 		* */ 
		public var authData : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('keyWords');
			arr.push('searchSource');
			arr.push('mediaType');
			arr.push('extraData');
			arr.push('authData');
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
