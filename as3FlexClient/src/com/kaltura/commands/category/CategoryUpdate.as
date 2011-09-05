package com.kaltura.commands.category
{
	import com.kaltura.vo.KalturaCategory;
	import com.kaltura.delegates.category.CategoryUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class CategoryUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param category KalturaCategory
		 **/
		public function CategoryUpdate( id : int,category : KalturaCategory )
		{
			service= 'category';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(category, 'category');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CategoryUpdateDelegate( this , config );
		}
	}
}
