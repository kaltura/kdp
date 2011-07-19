package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaModerationFlag extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var userId : String;

		public var moderationObjectType : int = int.MIN_VALUE;

		public var flaggedEntryId : String;

		public var flaggedUserId : String;

		public var status : int = int.MIN_VALUE;

		public var comments : String;

		public var flagType : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

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
	}
}
