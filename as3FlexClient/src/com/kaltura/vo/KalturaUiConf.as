package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUiConf extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* Name of the uiConf, this is not a primary key		* */ 
		public var name : String;

		/** 
		* 		* */ 
		public var description : String;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var objType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var objTypeAsString : String;

		/** 
		* 		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var htmlParams : String;

		/** 
		* 		* */ 
		public var swfUrl : String;

		/** 
		* 		* */ 
		public var confFilePath : String;

		/** 
		* 		* */ 
		public var confFile : String;

		/** 
		* 		* */ 
		public var confFileFeatures : String;

		/** 
		* 		* */ 
		public var confVars : String;

		/** 
		* 		* */ 
		public var useCdn : Boolean;

		/** 
		* 		* */ 
		public var tags : String;

		/** 
		* 		* */ 
		public var swfUrlVersion : String;

		/** 
		* Entry creation date as Unix timestamp (In seconds)		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Entry creation date as Unix timestamp (In seconds)		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var creationMode : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('objType');
			arr.push('width');
			arr.push('height');
			arr.push('htmlParams');
			arr.push('swfUrl');
			arr.push('confFile');
			arr.push('confFileFeatures');
			arr.push('confVars');
			arr.push('useCdn');
			arr.push('tags');
			arr.push('swfUrlVersion');
			arr.push('creationMode');
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
