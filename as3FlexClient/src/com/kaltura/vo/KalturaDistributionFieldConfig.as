package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionFieldConfig extends BaseFlexVo
	{
		/** 
		* A value taken from a connector field enum which associates the current configuration to that connector field
Field enum class should be returned by the provider's getFieldEnumClass function.		* */ 
		public var fieldName : String = null;

		/** 
		* A string that will be shown to the user as the field name in error messages related to the current field		* */ 
		public var userFriendlyFieldName : String = null;

		/** 
		* An XSLT string that extracts the right value from the Kaltura entry MRSS XML.
The value of the current connector field will be the one that is returned from transforming the Kaltura entry MRSS XML using this XSLT string.		* */ 
		public var entryMrssXslt : String = null;

		/** 
		* Is the field required to have a value for submission ?		* */ 
		public var isRequired : int = int.MIN_VALUE;

		/** 
		* Trigger distribution update when this field changes or not ?		* */ 
		public var updateOnChange : Boolean;

		/** 
		* Entry column or metadata xpath that should trigger an update
		* */ 
		public var updateParams : Array = new Array();

		/** 
		* Is this field config is the default for the distribution provider?		* */ 
		public var isDefault : Boolean;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fieldName');
			arr.push('userFriendlyFieldName');
			arr.push('entryMrssXslt');
			arr.push('isRequired');
			arr.push('updateOnChange');
			arr.push('updateParams');
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
