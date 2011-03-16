package com.kaltura.commands.uiConf
{
	import com.kaltura.vo.KalturaUiConf;
	import com.kaltura.delegates.uiConf.UiConfUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param uiConf KalturaUiConf
		 **/
		public function UiConfUpdate( id : int,uiConf : KalturaUiConf )
		{
			service= 'uiconf';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(uiConf, 'uiConf');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UiConfUpdateDelegate( this , config );
		}
	}
}
