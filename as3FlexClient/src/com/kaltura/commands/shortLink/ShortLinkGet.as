package com.kaltura.commands.shortLink
{
	import com.kaltura.delegates.shortLink.ShortLinkGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function ShortLinkGet( id : String )
		{
			service= 'shortlink_shortlink';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ShortLinkGetDelegate( this , config );
		}
	}
}
