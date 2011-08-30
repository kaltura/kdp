package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileScanDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileScan extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorAssetId String
		 * @param virusScanProfileId int
		 **/
		public function VirusScanProfileScan( flavorAssetId : String,virusScanProfileId : int=undefined )
		{
			service= 'virusscan_virusscanprofile';
			action= 'scan';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('flavorAssetId');
			valueArr.push(flavorAssetId);
			keyArr.push('virusScanProfileId');
			valueArr.push(virusScanProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanProfileScanDelegate( this , config );
		}
	}
}
