package com.kaltura.commands.category
{
	import com.kaltura.vo.KalturaCategoryFilter;
	import com.kaltura.delegates.category.CategoryListDelegate;
	import com.kaltura.net.KalturaCall;

	public class CategoryList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaCategoryFilter
		 **/
		public function CategoryList( filter : KalturaCategoryFilter=null )
		{
			if(filter== null)filter= new KalturaCategoryFilter();
			service= 'category';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CategoryListDelegate( this , config );
		}
	}
}
