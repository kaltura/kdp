package com.kaltura.commands.liveStream
{
	import com.kaltura.vo.KalturaLiveStreamAdminEntry;
	import com.kaltura.delegates.liveStream.LiveStreamAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamAdd extends KalturaCall
	{
		public var filterFields : String;
		public function LiveStreamAdd( liveStreamEntry : KalturaLiveStreamAdminEntry )
		{
			service= 'livestream';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(liveStreamEntry,'liveStreamEntry');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new LiveStreamAddDelegate( this , config );
		}
	}
}
