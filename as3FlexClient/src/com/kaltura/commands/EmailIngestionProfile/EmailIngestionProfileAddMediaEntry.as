package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileAddMediaEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileAddMediaEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntry KalturaMediaEntry
		 * @param uploadTokenId String
		 * @param emailProfId int
		 * @param fromAddress String
		 * @param emailMsgId String
		 **/
		public function EmailIngestionProfileAddMediaEntry( mediaEntry : KalturaMediaEntry,uploadTokenId : String,emailProfId : int,fromAddress : String,emailMsgId : String )
		{
			service= 'emailingestionprofile';
			action= 'addMediaEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			keyArr.push('emailProfId');
			valueArr.push(emailProfId);
			keyArr.push('fromAddress');
			valueArr.push(fromAddress);
			keyArr.push('emailMsgId');
			valueArr.push(emailMsgId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EmailIngestionProfileAddMediaEntryDelegate( this , config );
		}
	}
}
