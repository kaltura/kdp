package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaResource;
	import com.kaltura.delegates.media.MediaAddContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param resource KalturaResource
		 **/
		public function MediaAddContent( entryId : String,resource : KalturaResource=null )
		{
			service= 'media';
			action= 'addContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			if (resource) { 
 			keyValArr = kalturaObject2Arrays(resource, 'resource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddContentDelegate( this , config );
		}
	}
}
