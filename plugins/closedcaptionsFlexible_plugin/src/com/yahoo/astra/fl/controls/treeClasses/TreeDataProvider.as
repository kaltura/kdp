/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {

	import flash.events.EventDispatcher;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import RangeError;

	import fl.data.DataProvider;

	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**
	 * The TreeDataProvider class provides methods and properties that allow you to query and modify
	 * the data in a Tree Component.
	 *
	 * <p>A <em>TreeDataProvider</em> is the current linear representation of the state of the Tree component.
	 * However, even if some nodes are not visible, the TreeDataProvider holds information about them in member
	 * fields of the visible nodes. For example, consider the following tree: 
	 * <p>
	 * &lt;node&nbsp;label=\&quot;Folder&nbsp;1\&quot;&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;1\&quot;/&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;2\&quot;/&gt;
	 * <br />&lt;/node&gt;
	 * <br />&lt;node&nbsp;label=\&quot;Folder&nbsp;2\&quot;&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;3\&quot;/&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;4\&quot;/&gt;
	 * <br />&lt;/node&gt;
	 * </p>
	 * <p>When the TreeDataProvider is initialized with the XML shown above, it will contain two items: one with label 
	 * "Folder 1", and one with label "Folder 2". However, each of these items will have a number of fields that tie
	 * them to the Tree structure. These fields are: <em>nodeType</em> (either branch or leaf), <em>nodeState</em>
	 * (either open or closed), <em>nodeLevel</em> (the depth within the tree), and <em>nodeChildren</em> (a set of 
	 * references to all of the node's children, if applicable. In the example, the node with label "Folder 1" will 
	 * have <em>nodeType</em> set to "branch node", <em>nodeState</em> set to "closed node", <em>nodeLevel</em> to 0, 
	 * and <em>nodeChildren</em> would contain references to nodes with labels "File 1" and "File 2".
	 * </p><p>
	 * When the node "Folder 1" is expanded, the <em>TreeDataProvider</em> will contain 4 items: "Folder 1", "File 1", 
	 * "File 2", "Folder 2".
	 * </p>
	 *
	 * @author Allen Rabinovich
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0 
	 * 
	 * <p>
	 * <strong>Example usage:</strong><br/>
	 * <em>
	 * var mytree:Tree = new Tree();<br/>
	 * var myxml:XML = &lt;node&nbsp;label=\&quot;Folder&nbsp;1\&quot;&gt;&lt;node&nbsp;label=\&quot;File&nbsp;2\&quot;/&gt;&lt;/node&gt;;<br/>
	 * mytree.dp = new TreeDataProvider(myxml);<br/>
	 * addChild(mytree);<br/>
	 * </em>
	 * </p>
	 */
	 
	public class TreeDataProvider extends DataProvider {

	/**
	 * A constant used for populating the <em>nodeState</em> field.
     */
 	     public static const OPEN_NODE : String = "openNode";
	/**
	 * A constant used for populating the <em>nodeState</em> field.
     */
		 public static const CLOSED_NODE : String = "closedNode";

	/**
	 * A constant used for populating the <em>nodeType</em> field.
     */
		 public static const BRANCH_NODE : String = "branchNode";
		 
	/**
	 * A constant used for populating the <em>nodeType</em> field.
     */
		 public static const LEAF_NODE : String = "leafNode";
		 
	/**
	 * A constant used for populating the <em>nodeType</em> field.
	 */
	 	public static const ROOT_NODE : String = "rootNode";
	
		/**
		*  @private
	 	*  Used for traversing the tree
	 	*/				 
		 private var nodeCounter:int;
		 
		 public var rootNode:TNode;
	
		/**
		 * Creates a new TreeDataProvider object using an instance of XML object as data source. 
		 * The hierarchical structure of the XML object is reproduced in the Tree as parent-child
		 * relationships between Objects. Each XML node is converted into an Object, and its attributes
		 * are converted to fields within the Object. In addition, the following values are populated 
		 * for each node: 
		 * <p><em>nodeType</em> - Can be either <em>BRANCH_NODE</em> or <em>LEAF_NODE</em>. Represents
		 * whether a Node has any children.</p>
		 * <p><em>nodeState</em> - If the node is a <em>BRANCH_NODE</em>, represents whether it's currently
		 * open or closed. The value can be either <em>OPEN_NODE</em> or <em>CLOSED_NODE</em></p>
		 * <p><em>nodeLevel</em> - The depth of the Node within the Tree. Can be used for indenting the node
		 * by the cell renderer.</p>
		 * <p><em>nodeChildren</em> - An Array of pointers to the objects representing children of the current node.</p>
		 * 
		 * @param data The XML data that is used to create the DataProvider.
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
				 
		public function TreeDataProvider(value:Object=null) {
			data = [];
			super(value);
		}

		
        /** 
		 * Toggles the node state of a branch node. If the node is currently open, it becomes closed; and vice versa.
		 * The effect on the dataProvider is as follows: if the node is being opened, all of its children are added
		 * to the dataProvider below the node; if the node is being closed, all of its children are removed from the
		 * dataProvider.
		 * <p>The state of the child nodes of the current node is preserved; that is, if a child node of the current node
		 * is a branch node and was open when its parent node was closed, it will be open when the parent node is 
		 * reopened.</p>
	     *  <p>This method is deprecated. Use <code>BranchNode.openNode()</code> and <code>BranchNode.closeNode()</code> instead.</p>
		 *
		 * @param nodeIndex The dataProvider index of the node to be toggled.
         *
	     *  @see com.yahoo.astra.fl.controls.treeClasses.BranchNode
		 */
		public function toggleNode (nodeIndex:int) : void {
			var currentNode:TNode = this.getItemAt(nodeIndex) as TNode;
			if (currentNode is BranchNode && !(currentNode is RootNode)) {
				if (currentNode.isOpen()) {
					currentNode.closeNode();
				}
				else {
					currentNode.openNode();
				}
			}
		}

		/** 
		 * @private
		 * Placeholder for next release.
		 */
		private function moveNode (oldNodeIndex:int, newNodeIndex:int) : void {
		}
		
		/**
		 * @private (protected)
		 * Overrides the DataProvider's main method for parsing objects
		 * to allow for hierarchical XML
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private function createTreeFromXML(xml:XML) : void {
				
				rootNode = new RootNode(this);
				
				rootNode.drawNode();
				for each (var child:XML in xml.children()) {
				parseXMLNode(child, rootNode as BranchNode);
				}
		}
		
       /** 
		 * @private
		 * Parses a specific XML node and gives it Tree-specific properties.
		 */	
		private function parseXMLNode(xml:XML, parentNode:BranchNode) : void {
				var newNode:TNode;				
				
				if (xml.children().length() > 0) { 
					newNode = new BranchNode(this); 
				}
				else { 
					newNode = new LeafNode(this); 
				}
					 
				var attrs:XMLList = xml.attributes();
				for each (var attr:XML in attrs) {
					newNode[attr.localName()] = attr.toString();
				}
				
				parentNode.addChildNode(newNode);
				
				
				for each (var child:XML in xml.children()) {
				parseXMLNode(child, newNode as BranchNode);
				}
			
		}
		
		/** 
		 * @private
		 * Checks whether something is a tree node.
		 */	
		private function isTreeNode (obj:Object) : Boolean {
			return (obj is TNode);
		}
		
		/** 
		 * @private
		 * Initialized retrieval from a data object that's passed in. Currently only works with XML files.
		 */	

		override protected function getDataFromObject(obj:Object):Array {
			if (obj is XML) {
				var xml:XML = obj as XML;
				createTreeFromXML(xml);
				return this.toArray();
			} else {
				throw new TypeError("Error: Type Coercion failed: cannot convert " + obj + " to TreeDataProvider.");
				return null;
			}
		}
	}

}