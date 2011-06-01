package com.kaltura.kdpfl.util
{	
	import fl.containers.BaseScrollPane;
	
	import flash.display.DisplayObject;
	/**
	 * Class KAstraAdvancedLayoutUtil is designed to allow a developer to easily and 
	 * quickly add children to Astra-based containers that have the <code>configuration</code> property.
	 * The configuration property allows for the parent container to easily position and resize its children.
	 * @author Hila
	 * 
	 */
	public class KAstraAdvancedLayoutUtil
	{
		public function KAstraAdvancedLayoutUtil()
		{
		}
		
		/**
		 * Function to add a sepcific DisplayObject as the last child of a parent container. 
		 * @param parentComponent - the parent container
		 * @param childToAppend - the DisplayObject that needs to be appanded to the parent container
		 * @param percentWidth - the width that the child should have relative to the parent.
		 * @param percentHeight - the height that the child should have relative to the parent.
		 * 
		 */		
		public static function appendToLayout (parentComponent : BaseScrollPane, childToAppend : DisplayObject, percentWidth : Number = 0, percentHeight : Number = 0) : void
		{
			if ( parentComponent.hasOwnProperty("configuration") )
			{
				if (!parentComponent["configuration"])
					parentComponent["configuration"] = new Array();
				var child_config : Object = new Object();
				child_config.target = childToAppend;
				if (percentWidth)
					child_config.percentWidth = percentWidth;
				if (percentHeight)
					child_config.percentHeight = percentHeight;
				
				var parent_copy_config : Array = (parentComponent["configuration"] as Array).concat();
				parent_copy_config.push(child_config);
				parentComponent["configuration"] = parent_copy_config;
			}
		}
		/**
		 * Function adds a specific DisplayObject to the parent container at a specified index.
		 * @param parentComponent - the parent container
		 * @param childToAppend - the DisplayObject to append to the parent container.
		 * @param index - the index at which to appent the child to the parent container
		 * @param percentWidth - the width of the child DisplayObject realtive to the parent.
		 * @param percentHeight - the height of the child DisplayObject realtive to the parent.
		 * 
		 */		
		public static function appendToLayoutAt (parentComponent : BaseScrollPane, childToAppend : DisplayObject, index : int, percentWidth : Number = 0, percentHeight : Number = 0) : void
		{
			if ( parentComponent.hasOwnProperty("configuration") )
			{
				if (!parentComponent["configuration"])
					parentComponent["configuration"] = new Array();
				var child_config : Object = new Object();
				child_config.target = childToAppend;
				if (percentWidth)
					child_config.percentWidth = percentWidth;
				if (percentHeight)
					child_config.percentHeight = percentHeight;
				
				var parent_copy_config : Array = (parentComponent["configuration"] as Array).concat();
				parent_copy_config.splice(index,0, child_config);
				parentComponent["configuration"] = parent_copy_config;
			}
		}
		/**
		 * Function to remove a specific DisplayObject from the configuration of a parent container . If the DisplayObject is not a child of the parent
		 * container, nothing happens.
		 * @param parentComponent - the parent container
		 * @param childToRemove - the DisplayObject to remove from the parent configuration
		 * 
		 */		
		public static function removeFromLayout (parentComponent : BaseScrollPane, childToRemove : DisplayObject) : void
		{
			if ( parentComponent.hasOwnProperty("configuration") )
			{
				var a : Array = parentComponent["configuration"].concat();
				for each (var item : * in a)
				{
					if (item.target == childToRemove)
					{
						a.splice(a.indexOf(item), 1);
					}
				}
				parentComponent["configuration"] = a;
			}
		}
		/**
		 * Function to remove all children from the configuration of a container 
		 * @param parentComponent - the container to empty.
		 * 
		 */		
		public static function removeAllChildren (parentComponent : BaseScrollPane) : void
		{
			if ( parentComponent.hasOwnProperty("configuration") )
			{
				var a : Array = parentComponent["configuration"].concat();
				
				a = new Array();
				
				parentComponent["configuration"] = a;
			}
		}
	}
}