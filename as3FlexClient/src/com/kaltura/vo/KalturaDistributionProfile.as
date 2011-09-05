package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionProfile extends BaseFlexVo
	{
		/** 
		* Auto generated unique id
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* Profile creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Profile last update date as Unix timestamp (In seconds)
		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var providerType : String = null;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var submitEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updateEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var deleteEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var reportEnabled : int = int.MIN_VALUE;

		/** 
		* Comma separated flavor params ids that should be auto converted		* */ 
		public var autoCreateFlavors : String = null;

		/** 
		* Comma separated thumbnail params ids that should be auto generated		* */ 
		public var autoCreateThumb : String = null;

		/** 
		* Comma separated flavor params ids that should be submitted if ready		* */ 
		public var optionalFlavorParamsIds : String = null;

		/** 
		* Comma separated flavor params ids that required to be readt before submission		* */ 
		public var requiredFlavorParamsIds : String = null;

		/** 
		* Thumbnail dimensions that should be submitted if ready		* */ 
		public var optionalThumbDimensions : Array = new Array();

		/** 
		* Thumbnail dimensions that required to be readt before submission		* */ 
		public var requiredThumbDimensions : Array = new Array();

		/** 
		* If entry distribution sunrise not specified that will be the default since entry creation time, in seconds		* */ 
		public var sunriseDefaultOffset : int = int.MIN_VALUE;

		/** 
		* If entry distribution sunset not specified that will be the default since entry creation time, in seconds		* */ 
		public var sunsetDefaultOffset : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('status');
			arr.push('submitEnabled');
			arr.push('updateEnabled');
			arr.push('deleteEnabled');
			arr.push('reportEnabled');
			arr.push('autoCreateFlavors');
			arr.push('autoCreateThumb');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('sunriseDefaultOffset');
			arr.push('sunsetDefaultOffset');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('providerType');
			return arr;
		}

	}
}
