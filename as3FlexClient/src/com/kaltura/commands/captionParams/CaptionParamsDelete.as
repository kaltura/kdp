package com.kaltura.commands.captionParams
{
	import com.kaltura.delegates.captionParams.CaptionParamsDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionParamsDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function CaptionParamsDelete( id : int )
		{
			service= 'caption_captionparams';
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
			delegate = new CaptionParamsDeleteDelegate( this , config );
		}
	}
}
