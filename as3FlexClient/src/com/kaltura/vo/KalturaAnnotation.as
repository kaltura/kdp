package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAnnotation extends BaseFlexVo
	{
		public var id : String;

		public var entryId : String;

		public var parentId : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var text : String;

		public var tags : String;

		public var startTime : int = int.MIN_VALUE;

		public var endTime : int = int.MIN_VALUE;

		public var userId : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			arr.push('parentId');
			arr.push('text');
			arr.push('tags');
			arr.push('startTime');
			arr.push('endTime');
			return arr;
		}
	}
}
