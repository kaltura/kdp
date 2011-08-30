package com.kaltura.commands.uiConf
{
	import com.kaltura.delegates.uiConf.UiConfCloneDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfClone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function UiConfClone( id : int )
		{
			service= 'uiconf';
			action= 'clone';

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
			delegate = new UiConfCloneDelegate( this , config );
		}
	}
}
