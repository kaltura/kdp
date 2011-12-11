package com.kaltura.commands.liveStream
{
	import com.kaltura.delegates.liveStream.LiveStreamDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function LiveStreamDelete( entryId : String )
		{
			service= 'livestream';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamDeleteDelegate( this , config );
		}
	}
}
