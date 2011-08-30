package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearch;

	[Bindable]
	public dynamic class KalturaSearchResult extends KalturaSearch
	{
		/** 
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var title : String = null;

		/** 
		* 		* */ 
		public var thumbUrl : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* 		* */ 
		public var url : String = null;

		/** 
		* 		* */ 
		public var sourceLink : String = null;

		/** 
		* 		* */ 
		public var credit : String = null;

		/** 
		* 		* */ 
		public var licenseType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var flashPlaybackType : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('id');
			arr.push('title');
			arr.push('thumbUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('sourceLink');
			arr.push('credit');
			arr.push('licenseType');
			arr.push('flashPlaybackType');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
