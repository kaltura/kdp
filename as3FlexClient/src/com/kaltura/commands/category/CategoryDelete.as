package com.kaltura.commands.category
{
	import com.kaltura.delegates.category.CategoryDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class CategoryDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function CategoryDelete( id : int )
		{
			service= 'category';
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
			delegate = new CategoryDeleteDelegate( this , config );
		}
	}
}
