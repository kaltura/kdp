package com.kaltura.commands.widget
{
	import com.kaltura.vo.KalturaWidget;
	import com.kaltura.delegates.widget.WidgetCloneDelegate;
	import com.kaltura.net.KalturaCall;

	public class WidgetClone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param widget KalturaWidget
		 **/
		public function WidgetClone( widget : KalturaWidget )
		{
			service= 'widget';
			action= 'clone';

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
			delegate = new WidgetCloneDelegate( this , config );
		}
	}
}
