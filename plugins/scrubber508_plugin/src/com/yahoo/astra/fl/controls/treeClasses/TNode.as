/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {

//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The TNode class is the base class for three different types of node objects
 *  that may appear in a Tree component data provider. The TNode class provides 
 *  the necessary logic for linking the nodes hierarchically, recording the information
 *  about the nesting level of a node, and checking whether a node is currently
 *  visible.
 *
 *  @author Allen Rabinovich
 *
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 *  @see com.yahoo.astra.fl.controls.treeClasses.BranchNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.LeafNode
 *  @see com.yahoo.astra.fl.controls.treeClasses.RootNode
 */
	public dynamic class TNode extends Object {
		
	/**
	 * @private
	 * The parent node of this node.
	 */
		protected var _parentNode:BranchNode;
	
	/**
	 * @private
	 * The nesting level of this node.
	 */
		protected var _nodeLevel:int;
	
	/**
	 * @private
	 * The data provider that contains this node.
	 */
		protected var _parentDataProvider:TreeDataProvider;
	
	/**
     *  Constructor.
     *
	 * @param pDP The data provider that will contain this node.
	 */
		public function TNode (pDP:TreeDataProvider) {
			_parentDataProvider = pDP;
		}

	/**
	 * Checks whether all of the nodes parents are currently open in the Tree
	 * (thus making the node visible).
	 *
	 * @return <code>true</code> if all of the nodes parents are open; <code>false</code> otherwise.
	 */

		public function isVisible () : Boolean {
			var nodePointer:BranchNode = _parentNode as BranchNode;
			
			while (!(nodePointer is RootNode)) {
				if (!(nodePointer.isOpen())) {
					return false;
				}
				nodePointer = nodePointer.parentNode;
			}
			
			return true;
		}

	/**
	 * @private
	 *
	 * Placeholder for a function that draws the node by placing it into the dataProvider;
	 * overridden in BranchNode and LeafNode.
	 */
		public function drawNode () : void {
			
		}

	/**
	 * @private
	 *
	 * Placeholder for a function that hides the node by removing it from the dataProvider;
	 * overridden in BranchNode and LeafNode.
	 */
		public function hideNode () : void {
			
		}

	/**
	 *
	 * Completely removes the node from the tree.
	 * 
	 * @return The node that has been removed.
	 *
	 */
	 	public function removeNode () : TNode {
			this.parentNode.removeChild(this);
			return this;
		}
		
	/**
	 * @private (setter)
	 */
		public function set nodeLevel (value:int) : void {
			if (value == _parentNode.nodeLevel + 1) {
				_nodeLevel = value;
			}
		}

	/**
	 * Gets or sets the node level for this node.
	 * The level will only set if it's one greater
	 * that the nodeLevel of the parent node.
	 */
		public function get nodeLevel () : int {
			return _nodeLevel;
		}
		
	/**
	 * @private (setter)
	 */	
		public function set parentNode (value:BranchNode) : void {
			if (value.children.indexOf(this) >= 0) {
				_parentNode = value;
			}
		}

    /**
	 * Gets or sets the parent node for this node.
	 * The parent node will only be set if this node
	 * is in the <code>children</code> array of the parent node.
	 */		
		public function get parentNode () : BranchNode {
			return _parentNode;
		}
	}
	
}