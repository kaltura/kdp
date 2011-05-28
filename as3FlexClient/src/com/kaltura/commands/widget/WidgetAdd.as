package com.kaltura.commands.widget
{
	import com.kaltura.vo.KalturaWidget;
	import com.kaltura.delegates.widget.WidgetAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class WidgetAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param widget KalturaWidget
		 **/
		public function WidgetAdd( widget : KalturaWidget )
		{
			service= 'widget';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(widget, 'widget');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new WidgetAddDelegate( this , config );
		}
	}
}
