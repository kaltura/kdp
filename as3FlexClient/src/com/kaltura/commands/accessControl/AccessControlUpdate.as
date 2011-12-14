package com.kaltura.commands.accessControl
{
	import com.kaltura.vo.KalturaAccessControl;
	import com.kaltura.delegates.accessControl.AccessControlUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class AccessControlUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param accessControl KalturaAccessControl
		 **/
		public function AccessControlUpdate( id : int,accessControl : KalturaAccessControl )
		{
			service= 'accesscontrol';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(accessControl, 'accessControl');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AccessControlUpdateDelegate( this , config );
		}
	}
}
