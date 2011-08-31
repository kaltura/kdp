package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaGenericDistributionProviderAction extends BaseFlexVo
	{
		/** 
		* Auto generated
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* Generic distribution provider action creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Generic distribution provider action last update date as Unix timestamp (In seconds)
		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var genericDistributionProviderId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var action : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var resultsParser : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var protocol : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var serverAddress : String = null;

		/** 
		* 		* */ 
		public var remotePath : String = null;

		/** 
		* 		* */ 
		public var remoteUsername : String = null;

		/** 
		* 		* */ 
		public var remotePassword : String = null;

		/** 
		* 		* */ 
		public var editableFields : String = null;

		/** 
		* 		* */ 
		public var mandatoryFields : String = null;

		/** 
		* 		* */ 
		public var mrssTransformer : String = null;

		/** 
		* 		* */ 
		public var mrssValidator : String = null;

		/** 
		* 		* */ 
		public var resultsTransformer : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('resultsParser');
			arr.push('protocol');
			arr.push('serverAddress');
			arr.push('remotePath');
			arr.push('remoteUsername');
			arr.push('remotePassword');
			arr.push('editableFields');
			arr.push('mandatoryFields');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('genericDistributionProviderId');
			arr.push('action');
			return arr;
		}

	}
}
