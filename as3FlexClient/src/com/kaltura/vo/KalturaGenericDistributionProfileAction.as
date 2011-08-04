package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaGenericDistributionProfileAction extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var protocol : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var serverUrl : String;

		/** 
		* 		* */ 
		public var serverPath : String;

		/** 
		* 		* */ 
		public var username : String;

		/** 
		* 		* */ 
		public var password : String;

		/** 
		* 		* */ 
		public var ftpPassiveMode : Boolean;

		/** 
		* 		* */ 
		public var httpFieldName : String;

		/** 
		* 		* */ 
		public var httpFileName : String;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('protocol');
			arr.push('serverUrl');
			arr.push('serverPath');
			arr.push('username');
			arr.push('password');
			arr.push('ftpPassiveMode');
			arr.push('httpFieldName');
			arr.push('httpFileName');
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
