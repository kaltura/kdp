/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {
//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The LeafNode class is the base class for leaf nodes in the Tree.
 *  Leaf nodes are nodes that do not have any children.
 *  The class inherits from the base TNode class and provides logic
 *  for linking nodes hierarchically and retrieving relevant information
 *  about them.
 *
 *  @author Allen Rabinovich
 *
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 *  @see com.yahoo.astra.fl.controls.treeClasses.TNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.LeafNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.RootNode
 */
	public dynamic class LeafNode extends TNode {

	/**
	 * @private
	 * The type of the node
	 */
		protected var _nodeType:String;
	
    /**
     *  Constructor.
     *
	 * @param pDP The data provider that will contain this node.
	 */
		public function LeafNode (pDP:TreeDataProvider) {
			super(pDP);
			_nodeType = TreeDataProvider.LEAF_NODE;
		}

	/**
	 * The node type marker. For the LeafNode,
	 * the value is constant and set to <code>TreeDataProvider.LEAF_NODE</code>
	 *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
	 */
		public function get nodeType () : String {
			return _nodeType;
		}
	
	/**
	 *
	 * Checks whether a particular field <code>fieldName</code> in the node
	 * object holds a particular <code>value</code>
	 *
	 * @return true if the field contains the specified value; false if not.
	 */
		public function checkForValue (fieldName:String, value:String) : TNode {
			if (this[fieldName] == value) {
				return (this as TNode);
			}
			else {
				return null;
			}
		}
	/**
	 *
	 * Gets the number of visible nodes for this node.
	 * For LeafNode, the value is always 1.
	 *
	 * @return 1
	 */
		public function getVisibleSize () : int {
			return 1;
		}

	/**
	 * Draws the node by adding it to the Tree's dataProvider.
	 * Will only draw the node if all of its parents are open
	 * and if the node hasn't already been drawn.
	 *
	 */
		override public function drawNode () : void {
			// Only draw the node if it's not already drawn and if it's open
			if (_parentDataProvider.getItemIndex(this) == -1 && isVisible()) {
				var myIndex:int = _parentNode.children.indexOf(this);
				var actualIndex:int = 0;
				for (var i:int = 0; i < myIndex; i++) {
					actualIndex += _parentNode.children[i].getVisibleSize();
				}
				// If the node is at the top level, add it directly to the DataProvider at the right location
				if (_parentNode is RootNode) {
					if (_parentDataProvider.length > 0) {
						_parentDataProvider.addItemAt(this, actualIndex);
					}
					else {
						_parentDataProvider.addItem(this);
					}
				}
				// If the node is nested, add it below the parent node with the correct offset
				else {
					var parentIndex:int = _parentDataProvider.getItemIndex(_parentNode);
					_parentDataProvider.addItemAt(this, parentIndex + actualIndex + 1);
				}
			}
		}
		
	/**
	 * Hides the node by removing it from the dataProvider.
	 * Only hides the node if one of its parents is closed.
	 *
	 */		
		override public function hideNode () : void {
				// Only hide the node if it's not already hidden and is closed
				if (_parentDataProvider.getItemIndex(this) != -1 && !isVisible()) {
					_parentDataProvider.removeItem(this);
				}
		}
		
		
	}
}