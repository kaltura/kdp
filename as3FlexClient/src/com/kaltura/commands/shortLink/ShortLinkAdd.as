package com.kaltura.commands.shortLink
{
	import com.kaltura.vo.KalturaShortLink;
	import com.kaltura.delegates.shortLink.ShortLinkAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param shortLink KalturaShortLink
		 **/
		public function ShortLinkAdd( shortLink : KalturaShortLink )
		{
			service= 'shortlink_shortlink';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(shortLink, 'shortLink');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ShortLinkAddDelegate( this , config );
		}
	}
}
