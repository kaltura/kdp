package com.kaltura.commands.liveStream
{
	import com.kaltura.vo.KalturaLiveStreamAdminEntry;
	import com.kaltura.delegates.liveStream.LiveStreamUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param liveStreamEntry KalturaLiveStreamAdminEntry
		 **/
		public function LiveStreamUpdate( entryId : String,liveStreamEntry : KalturaLiveStreamAdminEntry )
		{
			service= 'livestream';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(liveStreamEntry, 'liveStreamEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamUpdateDelegate( this , config );
		}
	}
}
