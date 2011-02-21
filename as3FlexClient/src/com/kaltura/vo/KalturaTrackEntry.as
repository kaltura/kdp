package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaTrackEntry extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var trackEventType : int = int.MIN_VALUE;

		public var psVersion : String;

		public var context : String;

		public var partnerId : int = int.MIN_VALUE;

		public var entryId : String;

		public var hostName : String;

		public var userId : String;

		public var changedProperties : String;

		public var paramStr1 : String;

		public var paramStr2 : String;

		public var paramStr3 : String;

		public var ks : String;

		public var description : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var userIp : String;

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
	}
}
