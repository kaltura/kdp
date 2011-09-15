package com.kaltura.commands.kalturaInternalToolsSystemHelper
{
	import com.kaltura.delegates.kalturaInternalToolsSystemHelper.KalturaInternalToolsSystemHelperGetRemoteAddressDelegate;
	import com.kaltura.net.KalturaCall;

	public class KalturaInternalToolsSystemHelperGetRemoteAddress extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function KalturaInternalToolsSystemHelperGetRemoteAddress(  )
		{
			service= 'kalturainternaltools_kalturainternaltoolssystemhelper';
			action= 'getRemoteAddress';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new KalturaInternalToolsSystemHelperGetRemoteAddressDelegate( this , config );
		}
	}
}
