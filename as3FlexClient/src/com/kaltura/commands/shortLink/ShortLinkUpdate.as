package com.kaltura.commands.shortLink
{
	import com.kaltura.vo.KalturaShortLink;
	import com.kaltura.delegates.shortLink.ShortLinkUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param shortLink KalturaShortLink
		 **/
		public function ShortLinkUpdate( id : String,shortLink : KalturaShortLink )
		{
			service= 'shortlink_shortlink';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(shortLink, 'shortLink');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ShortLinkUpdateDelegate( this , config );
		}
	}
}
