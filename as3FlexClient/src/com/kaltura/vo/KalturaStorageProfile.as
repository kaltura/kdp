package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStorageProfile extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var systemName : String = null;

		/** 
		* 		* */ 
		public var desciption : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var protocol : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var storageUrl : String = null;

		/** 
		* 		* */ 
		public var storageBaseDir : String = null;

		/** 
		* 		* */ 
		public var storageUsername : String = null;

		/** 
		* 		* */ 
		public var storagePassword : String = null;

		/** 
		* 		* */ 
		public var storageFtpPassiveMode : Boolean;

		/** 
		* 		* */ 
		public var deliveryHttpBaseUrl : String = null;

		/** 
		* 		* */ 
		public var deliveryRmpBaseUrl : String = null;

		/** 
		* 		* */ 
		public var deliveryIisBaseUrl : String = null;

		/** 
		* 		* */ 
		public var minFileSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var maxFileSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var flavorParamsIds : String = null;

		/** 
		* 		* */ 
		public var maxConcurrentConnections : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var pathManagerClass : String = null;

		/** 
		* 		* */ 
		public var urlManagerClass : String = null;

		/** 
		* 		* */ 
		public var urlManagerParams : Array = new Array();

		/** 
		* No need to create enum for temp field
		* */ 
		public var trigger : int = int.MIN_VALUE;

		/** 
		* Delivery Priority
		* */ 
		public var deliveryPriority : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var deliveryStatus : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('systemName');
			arr.push('desciption');
			arr.push('status');
			arr.push('protocol');
			arr.push('storageUrl');
			arr.push('storageBaseDir');
			arr.push('storageUsername');
			arr.push('storagePassword');
			arr.push('storageFtpPassiveMode');
			arr.push('deliveryHttpBaseUrl');
			arr.push('deliveryRmpBaseUrl');
			arr.push('deliveryIisBaseUrl');
			arr.push('minFileSize');
			arr.push('maxFileSize');
			arr.push('flavorParamsIds');
			arr.push('maxConcurrentConnections');
			arr.push('pathManagerClass');
			arr.push('urlManagerClass');
			arr.push('urlManagerParams');
			arr.push('trigger');
			arr.push('deliveryPriority');
			arr.push('deliveryStatus');
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
