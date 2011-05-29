package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.vo.KalturaVirusScanProfile;
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param virusScanProfileId int
		 * @param virusScanProfile KalturaVirusScanProfile
		 **/
		public function VirusScanProfileUpdate( virusScanProfileId : int,virusScanProfile : KalturaVirusScanProfile )
		{
			service= 'virusscan_virusscanprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('virusScanProfileId');
			valueArr.push(virusScanProfileId);
 			keyValArr = kalturaObject2Arrays(virusScanProfile, 'virusScanProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanProfileUpdateDelegate( this , config );
		}
	}
}
