package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaInternalToolsSession extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var partner_id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var valid_until : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partner_pattern : String;

		/** 
		* 		* */ 
		public var type : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var error : String;

		/** 
		* 		* */ 
		public var rand : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var user : String;

		/** 
		* 		* */ 
		public var privileges : String;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partner_id');
			arr.push('valid_until');
			arr.push('partner_pattern');
			arr.push('type');
			arr.push('error');
			arr.push('rand');
			arr.push('user');
			arr.push('privileges');
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
