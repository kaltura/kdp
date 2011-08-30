/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {
//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The RootNode is a special case of a BranchNode that's used
 *  to contain the top-level nodes. The RootNode itself is never drawn.
 *
 *  @author Allen Rabinovich
 *
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 *  @see com.yahoo.astra.fl.controls.treeClasses.TNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.LeafNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.BranchNode
 */
	public dynamic class RootNode extends BranchNode {
    /**
     *  Constructor.
     *
	 * @param pDP The data provider that will contain this node.
	 */
		public function RootNode (pDP:TreeDataProvider) {
			_nodeLevel = -1;
			_nodeType = TreeDataProvider.ROOT_NODE;
			_nodeState = TreeDataProvider.OPEN_NODE;
			super(pDP);
			
		}
	/**
	 * @private (setter);
	 */
		override public function set nodeLevel (value:int) : void {
			
		}
		
	/**
	 * Since the root node itself is not visible, this function
	 * draws all of the top-level nodes.
	 *
	 */
		override public function drawNode () : void {
			for each (var child:TNode in _children) {
				child.drawNode();
			}
		}

	/**
	 * @private
	 *
	 */
		override public function hideNode () : void {
		}
		
	/**
	 * Adds a child node at a particular index in the array
	 * of children of the current node. If the current node is
	 * open, the new child node is also made visible.
	 *
	 * @param childNode The node to be added as a child
	 * @param index The position in the <code>children</code> array where
	 * the child node is inserted.
	 *
	 */
		override public function addChildNodeAt (childNode:TNode, index:int) : void {
				_children.splice(index, 0, childNode);
				childNode.parentNode = this as BranchNode;
				childNode.nodeLevel = this.nodeLevel + 1;
				childNode.drawNode();
		}

	}
}