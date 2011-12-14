package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaTrackEntry extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var trackEventType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var psVersion : String = null;

		/** 
		* 		* */ 
		public var context : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var hostName : String = null;

		/** 
		* 		* */ 
		public var userId : String = null;

		/** 
		* 		* */ 
		public var changedProperties : String = null;

		/** 
		* 		* */ 
		public var paramStr1 : String = null;

		/** 
		* 		* */ 
		public var paramStr2 : String = null;

		/** 
		* 		* */ 
		public var paramStr3 : String = null;

		/** 
		* 		* */ 
		public var ks : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var userIp : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('trackEventType');
			arr.push('psVersion');
			arr.push('context');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('hostName');
			arr.push('userId');
			arr.push('changedProperties');
			arr.push('paramStr1');
			arr.push('paramStr2');
			arr.push('paramStr3');
			arr.push('ks');
			arr.push('description');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('userIp');
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
