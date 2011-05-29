package com.kaltura.commands.widget
{
	import com.kaltura.delegates.widget.WidgetGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class WidgetGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function WidgetGet( id : String )
		{
			service= 'widget';
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
			delegate = new WidgetGetDelegate( this , config );
		}
	}
}
