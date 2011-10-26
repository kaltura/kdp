package com.kaltura.commands.captionParams
{
	import com.kaltura.vo.KalturaCaptionParams;
	import com.kaltura.delegates.captionParams.CaptionParamsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionParamsUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param captionParams KalturaCaptionParams
		 **/
		public function CaptionParamsUpdate( id : int,captionParams : KalturaCaptionParams )
		{
			service= 'caption_captionparams';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(captionParams, 'captionParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionParamsUpdateDelegate( this , config );
		}
	}
}
