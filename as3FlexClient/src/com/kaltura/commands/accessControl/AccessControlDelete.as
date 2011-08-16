package com.kaltura.commands.accessControl
{
	import com.kaltura.delegates.accessControl.AccessControlDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class AccessControlDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function AccessControlDelete( id : int )
		{
			service= 'accesscontrol';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AccessControlDeleteDelegate( this , config );
		}
	}
}
