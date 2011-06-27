package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.vo.KalturaEmailIngestionProfile;
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param EmailIP KalturaEmailIngestionProfile
		 **/
		public function EmailIngestionProfileUpdate( id : int,EmailIP : KalturaEmailIngestionProfile )
		{
			service= 'emailingestionprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(EmailIP, 'EmailIP');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EmailIngestionProfileUpdateDelegate( this , config );
		}
	}
}
