package com.kaltura.commands.uiConfAdmin
{
	import com.kaltura.vo.KalturaUiConfAdmin;
	import com.kaltura.delegates.uiConfAdmin.UiConfAdminAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfAdminAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param uiConf KalturaUiConfAdmin
		 **/
		public function UiConfAdminAdd( uiConf : KalturaUiConfAdmin )
		{
			service= 'adminconsole_uiconfadmin';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(uiConf, 'uiConf');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UiConfAdminAddDelegate( this , config );
		}
	}
}
