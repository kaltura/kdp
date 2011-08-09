package com.kaltura.commands.kalturaInternalToolsSystemHelper
{
	import com.kaltura.delegates.kalturaInternalToolsSystemHelper.KalturaInternalToolsSystemHelperFromSecureStringDelegate;
	import com.kaltura.net.KalturaCall;

	public class KalturaInternalToolsSystemHelperFromSecureString extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param str String
		 **/
		public function KalturaInternalToolsSystemHelperFromSecureString( str : String )
		{
			service= 'kalturainternaltools_kalturainternaltoolssystemhelper';
			action= 'fromSecureString';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('str');
			valueArr.push(str);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new KalturaInternalToolsSystemHelperFromSecureStringDelegate( this , config );
		}
	}
}
