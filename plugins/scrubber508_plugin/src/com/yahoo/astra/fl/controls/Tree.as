/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls {
	import com.yahoo.astra.fl.controls.treeClasses.*;
	import com.yahoo.astra.fl.events.TreeEvent;
	
	import fl.controls.List;
	import fl.controls.listClasses.*;
	import fl.core.InvalidationType;
	import fl.data.DataProvider;
	import fl.events.*;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The Tree class creates a List-based Tree component that displays hierarchical information.
 *  The Tree rendering is achieved via a custom TreeDataProvider that receives and parses an XML data structure,
 *  the TreeNode data structure, and a supplied TreeCellRenderer (though other CellRenderers can be used in lieu 
 *  of the default one.)
 *
 *  @author Allen Rabinovich
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeCellRenderer
 *  @see com.yahoo.astra.fl.controls.treeClasses.TNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.BranchNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.LeafNode
 */

	public class Tree extends List {
		
	/**
	 * The name of the field in the data object that contains information about an icon to use for a leaf node
	 */	
	public var leafIconField:String = "leafIcon";

	/**
	 * The name of the field in the data object that contains information about an icon to use for an open branch node
	 */	
	public var openBranchIconField:String = "openBranchIcon";

	/**
	 * The name of the field in the data object that contains information about an icon to use for a closed branch node
	 */	
	public var closedBranchIconField:String = "closedBranchIcon";
	

	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates and returns an instance of the Tree class. The Tree control's content
	 *  is determined by assigning a TreeDataProvider to the dataProvider field of
	 *  the Tree class.
     * 
     *  To display the Tree, add it as a child to your current display list or drag an instance
	 *  of the Tree onto Stage.
     *
     *  @return An instance of the Tree class. 
     *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
     */		
		public function Tree() {
			super();
			// The default processor of item click events is nodeClick function
			addEventListener(ListEvent.ITEM_CLICK, nodeClick);
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, nodeClick);
			setStyle('cellRenderer', TreeCellRenderer);
		}

    /**
     *  Opens all nodes at all levels in the Tree. 
     *
     */		
		public function openAllNodes () : void {
			var visibleNodes:Array = dataProvider.toArray();
			for each (var node:TNode in visibleNodes) {
				if (!(node is LeafNode) && (node.nodeLevel == 0)) {
					node.openAllChildren();
				}
			}
		}
		
    /**
     *  Closes all nodes at all levels in the Tree. 
     *
     */			
		public function closeAllNodes () : void {
			var visibleNodes:Array = dataProvider.toArray();
			for each (var node:TNode in visibleNodes) {
				if (!(node is LeafNode) && (node.nodeLevel == 0)) {
					node.closeAllChildren();
				}
			}
		}
		
	/**
     *  Finds the first instance of the node in the tree where
	 *  the value in the field designated by <code>fieldName</code>
	 *  is equal to <code>fieldValue</code>
     *
	 *  @param fieldName The name of the field in the node object to check.
	 *  @param fieldValue The value to look for in the specified field.
	 *
	 *  @return A node that contains the given value in the specified field; or null if
	 *  no such node is found.
	 *
     */	
		public function findNode (fieldName:String, fieldValue:String) : TNode {
			var visibleNodes:Array = dataProvider.toArray();
			for each (var node:TNode in visibleNodes) {
				if (node.nodeLevel == 0) {
					var foundNode:TNode = node.checkForValue(fieldName, fieldValue);
					if (foundNode != null) {
						return foundNode;
					}
				}
			}
			return null;
		}
		
	/**
     *  Opens all parent nodes of a specified node, so that the specified
	 *  node becomes visible.
     *
	 *  @param foundNode The node to be made visible.
	 *
	 *  @return The index of the node in the current view of the Tree (this is the
	 *  absolute index: i.e., the number of the nodes visible above the specified node.)
	 *
     */	
		public function showNode (foundNode:TNode) : int {
			if (foundNode != null) {
				var parentPointer:TNode = foundNode.parentNode;
				while (!(parentPointer is RootNode)) {
					parentPointer.openNode();
					parentPointer = parentPointer.parentNode;
				}
			var foundIndex:int = dataProvider.getItemIndex(foundNode);
			return foundIndex;
			}
			return -1;
		}
		
	/**
     *  Finds the first instance of the node in the tree where
	 *  the value in the field designated by <code>fieldName</code>
	 *  is equal to <code>fieldValue</code> and opens all parent nodes 
	 *  of the found node, so that the found node becomes visible.
     *
	 *  @param fieldName The name of the field in the node object to check.
	 *  @param fieldValue The value to look for in the specified field.
	 *
	 *  @return A node that contains the given value in the specified field; or null if
	 *  no such node is found.
	 *
     */	
		
		public function exposeNode (fieldName:String, fieldValue:String) : TNode {
			var foundNode:TNode = findNode(fieldName, fieldValue);
			if (foundNode != null) {
			showNode(foundNode);
			return(foundNode);
			}
			return null;
		}
		
	/**
	 *  Toggles a specified branch node to change state:
	 *  if the node is open, it would close, and vice versa.
	 *  <p>This method is deprecated. Use <code>BranchNode.openNode()</code> 
	 *  and <code>BranchNode.closeNode()</code> instead.</p>
     *
	 *  @param node The node that should be triggered.
	 *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.BranchNode
     */	
		public function toggleNode (node:BranchNode) : void {
			if (node.nodeState == TreeDataProvider.OPEN_NODE) {
				node.closeNode();
				
			}
			else {
				node.openNode();
			}
		}
		
	/**
	 *  @private
	 *  Default Node click behavior
	 */				
		private function nodeClick(event:ListEvent):void {
			var dp:TreeDataProvider = dataProvider as TreeDataProvider;
			var node:Object = dp.getItemAt(event.index);
			dp.toggleNode(event.index);
		}
		
		/**
         * Gets or sets the name of the field in the <code>dataProvider</code> object 
         * to be displayed as the label for the TextInput field and drop-down list. 
		 *
         * <p>By default, the component displays the <code>label</code> property 
		 * of each <code>dataProvider</code> item. If the <code>dataProvider</code> 
		 * items do not contain a <code>label</code> property, you can set the 
		 * <code>labelField</code> property to use a different property.</p>
         *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         * 
         * @default "label"
         *
         * @see #labelFunction 
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get labelField():String {
			return _labelField;
		}
		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set labelField(value:String):void {
			if (value == _labelField) { return; }
			if (value.substr(0,1) == "@") {
				_labelField = value.substr(1);
			}
			else {
				_labelField = value;
			}
			invalidate(InvalidationType.DATA);
		}		
		
		

		
    /**
     *  Gets or sets the data model of the Tree of items to be displayed. 
	 *  The Tree dataProvider is required to be of type TreeDataProvider. 
	 *  Changes to the data provider are immediately available to all Tree 
	 *  components that use it as a data source. 
     *
     *  @default null
     *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
     */		
	 		
		override public function get dataProvider () : DataProvider {
			return _dataProvider;
		}

		override public function set dataProvider(value:DataProvider):void {

			if ((value is DataProvider && value.length == 0) || value is TreeDataProvider) {
				if (_dataProvider != null) {
					_dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange);
					_dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
				}
				_dataProvider = value;

				_dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange,false,0,true);
				_dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE,onPreChange,false,0,true);
				clearSelection();
				invalidateList();
			}
			else {
			throw new TypeError("Error: Type Coercion failed: cannot convert " + value + " to TreeDataProvider.");
			}
		}


        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void {
			if (!selectable) { return; }
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.DOWN:
				case Keyboard.END:
				case Keyboard.HOME:
				case Keyboard.PAGE_UP:
				case Keyboard.PAGE_DOWN:
					moveSelectionVertically(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
					break;
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
				case Keyboard.SPACE:
				case Keyboard.ENTER:
					if(caretIndex == -1) {
						caretIndex = 0;
					}
					//doKeySelection(caretIndex, event.shiftKey, event.ctrlKey);
					//scrollToSelected();
					var renderer:TreeCellRenderer =  event.currentTarget as TreeCellRenderer;
                	
                var node:TNode = selectedItem as TNode;
				
				
				if(node is BranchNode)
				{
					var branchNode:BranchNode = node as BranchNode;
					if (branchNode.isOpen()) 
					{
						branchNode.closeNode();
						
						var closeEvent:TreeEvent = new TreeEvent(TreeEvent.ITEM_CLOSE);
						closeEvent.triggerEvent = event;
						closeEvent.itemRenderer = renderer;
						dispatchEvent(closeEvent);
					
					}
						
					else 
					{
						branchNode.openNode();
						
						var openEvent:TreeEvent = new TreeEvent(TreeEvent.ITEM_OPEN);
						openEvent.triggerEvent = event;
						openEvent.itemRenderer = renderer;
						dispatchEvent(openEvent);
					}
					
					
					
				}
                //	}
					break;
				default:
					var nextIndex:int = getNextIndexAtLetter(String.fromCharCode(event.keyCode), selectedIndex);
					if (nextIndex > -1) {
						selectedIndex = nextIndex;
						scrollToSelected();
					}
					break;
			}
			event.stopPropagation();
			
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Accessibility
		//
		//--------------------------------------------------------------------------
		/**
		* Placeholder for mixin by TreeAccImpl.
		*/
		public static var createAccessibilityImplementation:Function;
					
		/**
	     *  @inheritDoc
	     */
	    override protected function initializeAccessibility():void
	    {
			if (Tree.createAccessibilityImplementation != null)
	            Tree.createAccessibilityImplementation(this);
	    }

		
	}
}