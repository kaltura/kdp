package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProvider;

	[Bindable]
	public dynamic class KalturaGenericDistributionProvider extends KalturaDistributionProvider
	{
		/** 
		* Auto generated
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* Generic distribution provider creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Generic distribution provider last update date as Unix timestamp (In seconds)
		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var isDefault : Boolean;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var optionalFlavorParamsIds : String = null;

		/** 
		* 		* */ 
		public var requiredFlavorParamsIds : String = null;

		/** 
		* 		* */ 
		public var optionalThumbDimensions : Array = new Array();

		/** 
		* 		* */ 
		public var requiredThumbDimensions : Array = new Array();

		/** 
		* 		* */ 
		public var editableFields : String = null;

		/** 
		* 		* */ 
		public var mandatoryFields : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('editableFields');
			arr.push('mandatoryFields');
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
