package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param virusScanProfileId int
		 **/
		public function VirusScanProfileDelete( virusScanProfileId : int )
		{
			service= 'virusscan_virusscanprofile';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('virusScanProfileId');
			valueArr.push(virusScanProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanProfileDeleteDelegate( this , config );
		}
	}
}
