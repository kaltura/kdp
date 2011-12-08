package com.kaltura.commands.cuePoint
{
	import com.kaltura.delegates.cuePoint.CuePointDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class CuePointDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function CuePointDelete( id : String )
		{
			service= 'cuepoint_cuepoint';
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
			delegate = new CuePointDeleteDelegate( this , config );
		}
	}
}
