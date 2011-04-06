package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param virusScanProfileId int
		 **/
		public function VirusScanProfileGet( virusScanProfileId : int )
		{
			service= 'virusscan_virusscanprofile';
			action= 'get';

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
			delegate = new VirusScanProfileGetDelegate( this , config );
		}
	}
}
