package com.kaltura.commands.shortLink
{
	import com.kaltura.delegates.shortLink.ShortLinkGotoDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkGoto extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param proxy Boolean
		 **/
		public function ShortLinkGoto( id : String,proxy : Boolean=false )
		{
			service= 'shortlink_shortlink';
			action= 'goto';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('proxy');
			valueArr.push(proxy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ShortLinkGotoDelegate( this , config );
		}
	}
}
