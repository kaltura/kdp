package com.kaltura.commands.accessControl
{
	import com.kaltura.vo.KalturaAccessControl;
	import com.kaltura.delegates.accessControl.AccessControlAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class AccessControlAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param accessControl KalturaAccessControl
		 **/
		public function AccessControlAdd( accessControl : KalturaAccessControl )
		{
			service= 'accesscontrol';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(accessControl, 'accessControl');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AccessControlAddDelegate( this , config );
		}
	}
}
