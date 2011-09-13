package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCropDimensions;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionProfile extends BaseFlexVo
	{
		/** 
		* The id of the Conversion Profile
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : String = null;

		/** 
		* The name of the Conversion Profile
		* */ 
		public var name : String = null;

		/** 
		* System name of the Conversion Profile
		* */ 
		public var systemName : String = null;

		/** 
		* Comma separated tags
		* */ 
		public var tags : String = null;

		/** 
		* The description of the Conversion Profile
		* */ 
		public var description : String = null;

		/** 
		* ID of the default entry to be used for template data
		* */ 
		public var defaultEntryId : String = null;

		/** 
		* Creation date as Unix timestamp (In seconds) 
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* List of included flavor ids (comma separated)
		* */ 
		public var flavorParamsIds : String = null;

		/** 
		* Indicates that this conversion profile is system default
		* */ 
		public var isDefault : int = int.MIN_VALUE;

		/** 
		* Indicates that this conversion profile is partner default
		* */ 
		public var isPartnerDefault : Boolean;

		/** 
		* Cropping dimensions
DEPRECATED		* */ 
		public var cropDimensions : KalturaCropDimensions;

		/** 
		* Clipping start position (in miliseconds)
DEPRECATED		* */ 
		public var clipStart : int = int.MIN_VALUE;

		/** 
		* Clipping duration (in miliseconds)
DEPRECATED		* */ 
		public var clipDuration : int = int.MIN_VALUE;

		/** 
		* XSL to transform ingestion MRSS XML
		* */ 
		public var xslTransformation : String = null;

		/** 
		* ID of default storage profile to be used for linked net-storage file syncs
		* */ 
		public var storageProfileId : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('status');
			arr.push('name');
			arr.push('systemName');
			arr.push('tags');
			arr.push('description');
			arr.push('defaultEntryId');
			arr.push('flavorParamsIds');
			arr.push('isDefault');
			arr.push('cropDimensions');
			arr.push('clipStart');
			arr.push('clipDuration');
			arr.push('xslTransformation');
			arr.push('storageProfileId');
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
