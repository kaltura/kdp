package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDropFolderFileHandlerConfig;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDropFolder extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var type : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dc : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var path : String = null;

		/** 
		* The ammount of time, in seconds, that should pass so that a file with no change in size we'll be treated as "finished uploading to folder"		* */ 
		public var fileSizeCheckInterval : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var fileDeletePolicy : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var autoFileDeleteDays : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var fileHandlerType : String = null;

		/** 
		* 		* */ 
		public var fileNamePatterns : String = null;

		/** 
		* 		* */ 
		public var fileHandlerConfig : KalturaDropFolderFileHandlerConfig;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* 		* */ 
		public var ignoreFileNamePatterns : String = null;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('type');
			arr.push('status');
			arr.push('conversionProfileId');
			arr.push('dc');
			arr.push('path');
			arr.push('fileSizeCheckInterval');
			arr.push('fileDeletePolicy');
			arr.push('autoFileDeleteDays');
			arr.push('fileHandlerType');
			arr.push('fileNamePatterns');
			arr.push('fileHandlerConfig');
			arr.push('tags');
			arr.push('ignoreFileNamePatterns');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerId');
			return arr;
		}

	}
}
