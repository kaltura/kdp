package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaModerationFlag extends BaseFlexVo
	{
		/** 
		* Moderation flag id		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The user id that added the moderation flag		* */ 
		public var userId : String = null;

		/** 
		* The type of the moderation flag (entry or user)		* */ 
		public var moderationObjectType : int = int.MIN_VALUE;

		/** 
		* If moderation flag is set for entry, this is the flagged entry id		* */ 
		public var flaggedEntryId : String = null;

		/** 
		* If moderation flag is set for user, this is the flagged user id		* */ 
		public var flaggedUserId : String = null;

		/** 
		* The moderation flag status		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* The comment that was added to the flag		* */ 
		public var comments : String = null;

		/** 
		* 		* */ 
		public var flagType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flaggedEntryId');
			arr.push('flaggedUserId');
			arr.push('comments');
			arr.push('flagType');
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
