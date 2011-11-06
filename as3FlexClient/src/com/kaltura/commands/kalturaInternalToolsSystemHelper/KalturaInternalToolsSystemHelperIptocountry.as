package com.kaltura.commands.kalturaInternalToolsSystemHelper
{
	import com.kaltura.delegates.kalturaInternalToolsSystemHelper.KalturaInternalToolsSystemHelperIptocountryDelegate;
	import com.kaltura.net.KalturaCall;

	public class KalturaInternalToolsSystemHelperIptocountry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param remote_addr String
		 **/
		public function KalturaInternalToolsSystemHelperIptocountry( remote_addr : String )
		{
			service= 'kalturainternaltools_kalturainternaltoolssystemhelper';
			action= 'iptocountry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('remote_addr');
			valueArr.push(remote_addr);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new KalturaInternalToolsSystemHelperIptocountryDelegate( this , config );
		}
	}
}
