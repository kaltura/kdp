package com.kaltura.commands.category
{
	import com.kaltura.vo.KalturaCategory;
	import com.kaltura.delegates.category.CategoryAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class CategoryAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param category KalturaCategory
		 **/
		public function CategoryAdd( category : KalturaCategory )
		{
			service= 'category';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(category, 'category');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CategoryAddDelegate( this , config );
		}
	}
}
