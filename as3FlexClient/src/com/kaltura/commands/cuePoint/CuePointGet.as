package com.kaltura.commands.cuePoint
{
	import com.kaltura.delegates.cuePoint.CuePointGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class CuePointGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function CuePointGet( id : String )
		{
			service= 'cuepoint_cuepoint';
			action= 'get';

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
			delegate = new CuePointGetDelegate( this , config );
		}
	}
}
