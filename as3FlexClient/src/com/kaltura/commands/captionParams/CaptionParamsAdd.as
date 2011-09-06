package com.kaltura.commands.captionParams
{
	import com.kaltura.vo.KalturaCaptionParams;
	import com.kaltura.delegates.captionParams.CaptionParamsAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionParamsAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param captionParams KalturaCaptionParams
		 **/
		public function CaptionParamsAdd( captionParams : KalturaCaptionParams )
		{
			service= 'caption_captionparams';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(captionParams, 'captionParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionParamsAddDelegate( this , config );
		}
	}
}
