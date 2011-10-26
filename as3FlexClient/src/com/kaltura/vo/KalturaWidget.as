package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaWidget extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var sourceWidgetId : String = null;

		/** 
		* 		* */ 
		public var rootWidgetId : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var uiConfId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var securityType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var securityPolicy : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* Can be used to store various partner related data as a string 		* */ 
		public var partnerData : String = null;

		/** 
		* 		* */ 
		public var widgetHTML : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('sourceWidgetId');
			arr.push('entryId');
			arr.push('uiConfId');
			arr.push('securityType');
			arr.push('securityPolicy');
			arr.push('partnerData');
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
