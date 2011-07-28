package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadataProfile extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var metadataObjectType : String;

		/** 
		* 		* */ 
		public var version : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var name : String;

		/** 
		* 		* */ 
		public var systemName : String;

		/** 
		* 		* */ 
		public var description : String;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var xsd : String;

		/** 
		* 		* */ 
		public var views : String;

		/** 
		* 		* */ 
		public var createMode : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('metadataObjectType');
			arr.push('name');
			arr.push('systemName');
			arr.push('description');
			arr.push('createMode');
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
