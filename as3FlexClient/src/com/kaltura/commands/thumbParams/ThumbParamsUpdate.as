package com.kaltura.commands.thumbParams
{
	import com.kaltura.vo.KalturaThumbParams;
	import com.kaltura.delegates.thumbParams.ThumbParamsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param thumbParams KalturaThumbParams
		 **/
		public function ThumbParamsUpdate( id : int,thumbParams : KalturaThumbParams )
		{
			service= 'thumbparams';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(thumbParams, 'thumbParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbParamsUpdateDelegate( this , config );
		}
	}
}
