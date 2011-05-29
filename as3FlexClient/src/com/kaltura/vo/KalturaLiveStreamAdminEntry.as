package com.kaltura.vo
{
	import com.kaltura.vo.KalturaLiveStreamEntry;

	[Bindable]
	public dynamic class KalturaLiveStreamAdminEntry extends KalturaLiveStreamEntry
	{
		public var encodingIP1 : String;

		public var encodingIP2 : String;

		public var streamPassword : String;

		public var streamUsername : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('encodingIP1');
			arr.push('encodingIP2');
			arr.push('streamPassword');
			return arr;
		}
	}
}
