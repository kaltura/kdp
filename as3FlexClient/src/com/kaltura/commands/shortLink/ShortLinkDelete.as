package com.kaltura.commands.shortLink
{
	import com.kaltura.delegates.shortLink.ShortLinkDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function ShortLinkDelete( id : String )
		{
			service= 'shortlink_shortlink';
			action= 'delete';

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
			delegate = new ShortLinkDeleteDelegate( this , config );
		}
	}
}
