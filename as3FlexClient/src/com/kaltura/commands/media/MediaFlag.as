package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaModerationFlag;
	import com.kaltura.delegates.media.MediaFlagDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaFlag extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param moderationFlag KalturaModerationFlag
		 **/
		public function MediaFlag( moderationFlag : KalturaModerationFlag )
		{
			service= 'media';
			action= 'flag';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(moderationFlag, 'moderationFlag');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaFlagDelegate( this , config );
		}
	}
}
