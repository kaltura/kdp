package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.vo.KalturaEmailIngestionProfile;
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param EmailIP KalturaEmailIngestionProfile
		 **/
		public function EmailIngestionProfileAdd( EmailIP : KalturaEmailIngestionProfile )
		{
			service= 'emailingestionprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(EmailIP, 'EmailIP');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EmailIngestionProfileAddDelegate( this , config );
		}
	}
}
