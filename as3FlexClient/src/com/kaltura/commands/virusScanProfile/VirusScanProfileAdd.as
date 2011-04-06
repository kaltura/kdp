package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.vo.KalturaVirusScanProfile;
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param virusScanProfile KalturaVirusScanProfile
		 **/
		public function VirusScanProfileAdd( virusScanProfile : KalturaVirusScanProfile )
		{
			service= 'virusscan_virusscanprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(virusScanProfile, 'virusScanProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanProfileAddDelegate( this , config );
		}
	}
}
