package com.kaltura.commands.thumbParams
{
	import com.kaltura.vo.KalturaThumbParams;
	import com.kaltura.delegates.thumbParams.ThumbParamsAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param thumbParams KalturaThumbParams
		 **/
		public function ThumbParamsAdd( thumbParams : KalturaThumbParams )
		{
			service= 'thumbparams';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(thumbParams, 'thumbParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbParamsAddDelegate( this , config );
		}
	}
}
