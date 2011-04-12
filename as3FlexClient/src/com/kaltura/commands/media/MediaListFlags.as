package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.media.MediaListFlagsDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaListFlags extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param pager KalturaFilterPager
		 **/
		public function MediaListFlags( entryId : String,pager : KalturaFilterPager=null )
		{
			if(pager== null)pager= new KalturaFilterPager();
			service= 'media';
			action= 'listFlags';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaListFlagsDelegate( this , config );
		}
	}
}
