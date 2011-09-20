package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaModerationFlag;
	import com.kaltura.delegates.baseEntry.BaseEntryFlagDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryFlag extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param moderationFlag KalturaModerationFlag
		 **/
		public function BaseEntryFlag( moderationFlag : KalturaModerationFlag )
		{
			service= 'baseentry';
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
			delegate = new BaseEntryFlagDelegate( this , config );
		}
	}
}
