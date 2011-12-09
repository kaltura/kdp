/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.accessibility
{
import com.yahoo.astra.accessibility.EventTypes;
import com.yahoo.astra.accessibility.ObjectRoles;
import com.yahoo.astra.accessibility.ObjectStates;

import com.yahoo.astra.fl.controls.Tree;
import com.yahoo.astra.fl.controls.treeClasses.BranchNode;
import com.yahoo.astra.fl.controls.treeClasses.TNode;
import com.yahoo.astra.fl.events.TreeEvent;

import fl.accessibility.SelectableListAccImpl;
import fl.controls.listClasses.ICellRenderer;
import fl.core.UIComponent;

import flash.accessibility.Accessibility;
import flash.events.Event;


/**
 * The TreeAccImpl class, also called the Tree Accessiblity Implementation class, 
 * is used to make a Tree component accessible.
 * 
 * <p>The TreeAccImpl class supports system roles, object-based events, and states.</p>
 * 
 * <p>A Tree reports the role <code>ObjectRoles.ROLE_SYSTEM_OUTLINE</code> (0x23) to a screen 
 * reader. Items of a Tree report the role <code>ObjectRoles.ROLE_SYSTEM_OUTLINEITEM</code> (0x24).</p>
 *
 *
 * @see com.yahoo.astra.fl.controls.Tree
 * @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
 * 
 * @author Alaric Cole
 */
public class TreeAccImpl extends SelectableListAccImpl
{

	//--------------------------------------------------------------------------
	//
	//  Class initialization
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Static variable triggering the <code>hookAccessibility()</code> method.
	 *  This is used for initializing <code>TreeAccImpl</code> class to hook its
	 *  <code>createAccessibilityImplementation()</code> method to the <code>Tree</code> class 
	 *  before it gets called when <code>UIComponent</code> invokes the <code>initializeAccessibility()</code> method.
	 * 
	 *  @see fl.accessibility.UIComponent#createAccessibilityImplementation()
	 *  @see fl.accessibility.UIComponent#initializeAccessibility()
	 *  @see fl.accessibility.UIComponent#initialize()
	 */
	private static var accessibilityHooked:Boolean = hookAccessibility();
	
	/**
	 *  Static method that swaps the <code>createAccessibilityImplementation()</code>
	 *  method of <code>UIComponent</code> subclass with the appropriate <code>AccImpl</code> subclass.
	 * 
	 *  @see fl.accessibility.UIComponent#createAccessibilityImplementation()
	 *  @see fl.accessibility.UIComponent#initializeAccessibility()
	 *  @see fl.accessibility.UIComponent#initialize()
	 */
	private static function hookAccessibility():Boolean
	{
		Tree.createAccessibilityImplementation = createAccessibilityImplementation;

		return true;
	}

	//--------------------------------------------------------------------------
	//
	//  Enabling Accessibility
	//
	//--------------------------------------------------------------------------

	/**
	 *  Method for creating the Accessibility Implementation class for a component.
	 *  <p>This method is called by the <code>initializeAccessibility()</code> method for the <code>UIComponent</code> 
	 *  subclass when the component initializes.</p>
	 *  <p>All <code>AccImpl</code> subclasses must implement this method</p>
	 * 
	 *  @param component The UIComponent instance that this TreeAccImpl instance makes accessible.
	 * 
	 *  @see fl.accessibility.AccImpl#createAccessibilityImplementation()
	 *  @see fl.core.UIComponent#createAccessibilityImplementation() 
	 *  @see fl.core.UIComponent#initalizeAccessibility()
	 *  @see fl.core.UIComponent#initialize()
	 */
	public static function createAccessibilityImplementation(component:UIComponent):void
	{
		component.accessibilityImplementation = new TreeAccImpl(component);
	}

	/**
	 *  Method call for enabling accessibility for a component.
	 *  This method is required for the compiler to activate the accessibility classes for a component.
	 */
	public static function enableAccessibility():void
	{
		//empty
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new TreeAccImpl instance for the specified Tree component.
	 *
	 * @param master The UIComponent instance that this TreeAccImpl instance is making accessible.
	 * 
	 */
	public function TreeAccImpl(master:UIComponent)
	{
		super(master);

		role = ObjectRoles.ROLE_SYSTEM_OUTLINE;
	}


	//--------------------------------------------------------------------------
	//  Role
	//--------------------------------------------------------------------------

	/**
	 * @inheritDoc
	 * @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 * 
	 */
	override public function get_accRole(childID:uint):uint
	{
		//return the Tree's role itself, or the role of the items
		if (childID == 0)
		{
			return role;			
		}

		return ObjectRoles.ROLE_SYSTEM_OUTLINEITEM;
	}

	//--------------------------------------------------------------------------
	//  Name
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 */
	override protected function getName(childID:uint):String
	{
		if (childID == 0)
			return "";

		var name:String = "";
		
		var tree:Tree = Tree(master);

		var index:int = childID - 1;
		if (index > -1)
		{
			var item:Object = tree.dataProvider.getItemAt(index);
			if (!item)
				return name;
		
		
			if (tree.itemToLabel(item))
				name = tree.itemToLabel(item);

			name += getLocationDescription(item);
		}
			
		return name;
	}
	
	//--------------------------------------------------------------------------
	//  Value
	//--------------------------------------------------------------------------

	/**
	 *  @inheritDoc
	 *  @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 */
	override public function get_accValue(childID:uint):String
	{
		var accValue:String = "";
		
		var tree:Tree = Tree(master);
		var index:int;
		var item:Object;

		if (childID == 0)
		{
			index = tree.selectedIndex;
			if (index > -1)
			{
				item = tree.dataProvider.getItemAt(index);
				if (!item)
					return accValue;
				
				if (tree.itemToLabel(item))
					accValue = tree.itemToLabel(item)
					
				//return the item plus its location
				accValue += getLocationDescription(item);
			}
		}
		else
		{
			index = childID - 1;
			if (index > -1)
			{
				item = tree.dataProvider.getItemAt(index);
				if (!item)
					return accValue;
				var node:TNode = item as TNode;
				accValue = node.nodeLevel + 1 + "";
			}
		}

		return accValue;
	}

	//--------------------------------------------------------------------------
	//  State
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 *  @see http://msdn.microsoft.com/en-us/library/ms697605(VS.85).aspx Microsoft Accessibility Developer Center User Interface Element Reference: Tree View Control
	 */
	override public function get_accState(childID:uint):uint
	{
		var accState:uint = getState(childID);
		
		if (childID > 0)
		{
			var tree:Tree = Tree(master);

			var index:int = childID - 1;

			if (index < tree.verticalScrollPosition ||
				index >= tree.verticalScrollPosition + tree.rowCount)
			{
				accState |= ObjectStates.STATE_SYSTEM_INVISIBLE;
			}
			else
			{
				accState |= ObjectStates.STATE_SYSTEM_SELECTABLE;

				var item:Object = tree.dataProvider.getItemAt(index);
				var node:TNode = item as TNode;
		
				if (item && item is BranchNode)
				{
					if (BranchNode(item).isOpen())
						accState |= ObjectStates.STATE_SYSTEM_EXPANDED;
					else
						accState |= ObjectStates.STATE_SYSTEM_COLLAPSED;
				}

				var renderer:ICellRenderer = tree.itemToCellRenderer(item);

				if (renderer != null && tree.isItemSelected(renderer.data))
					accState |= ObjectStates.STATE_SYSTEM_SELECTED | ObjectStates.STATE_SYSTEM_FOCUSED;
			}
		}
		return accState;
	}
	
	/**
	 *	@inheritDoc
	 */
	override protected function get eventsToHandle():Array
	{
		return super.eventsToHandle.concat([TreeEvent.ITEM_CLOSE, TreeEvent.ITEM_OPEN]);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handler
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Override the generic event handler.
	 *  All AccImpl must implement this to listen for events from its master component. 
	 *  Here we add a few events.
	 * 
     *  @param event The event object
     */
	override protected function eventHandler(event:Event):void
	{
		var index:int = Tree(master).selectedIndex;
		
		var childID:uint = index + 1;

		switch (event.type)
		{
			case Event.CHANGE:
			{
				if (index >= -1)
				{
					if(Accessibility.active) 
					{
						Accessibility.sendEvent(master, childID,
												EventTypes.EVENT_OBJECT_FOCUS);
	
						Accessibility.sendEvent(master, childID,
												EventTypes.EVENT_OBJECT_SELECTION);
					}
				}
				break;
			}
										
			case TreeEvent.ITEM_OPEN:
			case TreeEvent.ITEM_CLOSE:
			{
				if (index >= -1)
				{
					if(Accessibility.active) 
					{
						Accessibility.sendEvent(master, childID,
											EventTypes.EVENT_OBJECT_STATECHANGE);
					}
				}
				break;
			} 
		}
	}
	
	//--------------------------------------------------------------------------
	//  Default Action
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 */
	override public function get_accDefaultAction(childID:uint):String
	{
		if (childID == 0)
			return null;

		var tree:Tree = Tree(master);

		var item:Object = tree.dataProvider.getItemAt(childID - 1);
		if (!item)
			return null;
		
		if ( item is BranchNode)
			return BranchNode(item).isOpen() ? "Collapse" : "Expand";

		return null;
	}

	/**
	 * @inheritDoc
	 */
	override public function accDoDefaultAction(childID:uint):void
	{
		var tree:Tree = Tree(master);

		if (childID == 0 || !tree.enabled)
			return;

		var item:Object = tree.dataProvider.getItemAt(childID - 1);
		
		if (!item)
			return;
		
		if (item is BranchNode)
		{
			var node:BranchNode = item as BranchNode;
			
			if(node.isOpen()) node.closeNode();
			else node.openNode();
		}

	}

	/**
	 *  Returns a string with information about the location of a node within a tree structure. 
	 * 
	 * <p>E.g. "[item] 2 of 12 [items]"</p>
	 *
	 *  @param item Object
	 *
	 *  @return String.
	 */
	private function getLocationDescription(item:Object):String
	{
 		var tree:Tree = Tree(master);
		var i:int = 0;
		var n:int = 0;

		var node:TNode = item as TNode;
		var parent:BranchNode = node.parentNode;
		var childNodes:Array =  parent.children;
		
		if (childNodes)
		{
			n = childNodes.length;
			for (i = 0; i < n; i++)
			{
				//get the index of this node, in relation to sibling nodes
				if (item == childNodes[i])
					break;
			}
		}
		
		
		if (i == n)
			i = 0;

		//make it 1-based.
		if (n > 0)
			i++;
		
		return ", " + i + " of " + n; 
	}


}

}
