package com.kaltura.commands.system
{
	import com.kaltura.delegates.system.SystemPingDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPing extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function SystemPing(  )
		{
			service= 'system';
			action= 'ping';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPingDelegate( this , config );
		}
	}
}
