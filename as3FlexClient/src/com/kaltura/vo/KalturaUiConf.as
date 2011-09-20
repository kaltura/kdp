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
		public var name : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var objType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var objTypeAsString : String = null;

		/** 
		* 		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var htmlParams : String = null;

		/** 
		* 		* */ 
		public var swfUrl : String = null;

		/** 
		* 		* */ 
		public var confFilePath : String = null;

		/** 
		* 		* */ 
		public var confFile : String = null;

		/** 
		* 		* */ 
		public var confFileFeatures : String = null;

		/** 
		* 		* */ 
		public var confVars : String = null;

		/** 
		* 		* */ 
		public var useCdn : Boolean;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* 		* */ 
		public var swfUrlVersion : String = null;

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
