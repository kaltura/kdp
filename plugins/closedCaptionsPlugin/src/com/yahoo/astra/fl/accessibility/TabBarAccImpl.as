/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.accessibility
{
	import com.yahoo.astra.accessibility.EventTypes;
	import com.yahoo.astra.accessibility.ObjectRoles;
	import com.yahoo.astra.accessibility.ObjectStates;
	
	import com.yahoo.astra.fl.controls.TabBar;
	import com.yahoo.astra.fl.controls.tabBarClasses.TabButton;
	
	import fl.accessibility.AccImpl;
	import fl.core.UIComponent;
	
	import flash.accessibility.Accessibility;
	import flash.events.Event;
	
	/**
	 * The TabBarAccImpl class, also called the TabBar Accessibility Implementation class,
	 * is used to make a TabBar component accessible.
	 *
	 * @see com.yahoo.astra.fl.controls.TabBar
	 */
	public class TabBarAccImpl extends AccImpl
	{		
		
	//--------------------------------------
	//  Class Properties
	//--------------------------------------

		/**
		 * @private
         * Static variable triggering the <code>hookAccessibility()</code> method.
		 * This is used for initializing TabBarAccImpl class to hook its
         * <code>createAccessibilityImplementation()</code> method to TabBar class 
         * before it gets called from UIComponent.
		 */
		private static var accessibilityHooked:Boolean = hookAccessibility();
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------

		/**
		 * @private
         * Static method for swapping the <code>createAccessibilityImplementation()</code>
         * method of TabBar with the TabBarAccImpl class.
		 */ 
		private static function hookAccessibility():Boolean
		{
			TabBar.createAccessibilityImplementation = createAccessibilityImplementation;
			return true;
		}
		
		/**
		 *  @private
		 *  Method for creating the Accessibility class.
		 *  This method is called from UIComponent.
		 * 
		 *  @param component The UIComponent instance that this AccImpl instance
         *  is making accessible.
		 */
		public static function createAccessibilityImplementation(component:UIComponent):void
		{
			component.accessibilityImplementation = new TabBarAccImpl(component);
		}
		
		/**
		 * Enables accessibility for a TabBar component.
		 * This method is required for the compiler to activate
         * the accessibility classes for a component.
		 */
		public static function enableAccessibility():void
		{
			//do nothing
		}
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static const MAX_NUM:uint = 100000;
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
         * @private
         *
		 * Creates a new TabBar Accessibility Implementation.
		 *
		 * @param master The UIComponent instance that this AccImpl instance
         * is making accessible.
		 */
		public function TabBarAccImpl(master:UIComponent)
		{
			super(master);
			this.role = ObjectRoles.ROLE_SYSTEM_PAGETABLIST;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
         * Array of events that we should listen for from the master component.
		 */
		override protected function get eventsToHandle():Array
		{
			return super.eventsToHandle.concat([ Event.CHANGE, "focusUpdate" ]);
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Gets the role for the component.
		 *
		 * @param childID The child id.
		 * 
         * @return Role.
		 */
		override public function get_accRole(childID:uint):uint
		{
			if(childID == 0)
			{
				return this.role;
			}
			
			//tabs use this role:
			return ObjectRoles.ROLE_SYSTEM_PAGETAB;
		}
		
		/**
		 * @private
		 * IAccessible method for returning the state of the Tabs.
		 * States are predefined for all the components in MSAA. Values are assigned to each state.
		 * Depending upon the Tab being Focusable, Focused and Moveable, a value is returned.
		 *
		 * @param childID The child id.
		 *
         * @return State.
		 */
		override public function get_accState(childID:uint):uint
		{
			var accState:uint = getState(childID);

			var tabBar:TabBar = TabBar(master);
			
			if(childID > 0)
			{
				accState = ObjectStates.STATE_SYSTEM_SELECTABLE | ObjectStates.STATE_SYSTEM_FOCUSABLE;

				var index:int = childID < MAX_NUM ? childID - 1 : childID - MAX_NUM - 1;

				if(index == tabBar.selectedIndex)
				{
					accState |= ObjectStates.STATE_SYSTEM_SELECTED;
				}
					
				if(index == tabBar.focusIndex)
				{
					accState |= ObjectStates.STATE_SYSTEM_FOCUSED;
				}
			}		
			return accState;
		}

		/**
		 * @private
		 * IAccessible method for returning the Default Action.
		 *
		 * @param childID uint
		 *
		 * @return DefaultAction.
		 */
		override public function get_accDefaultAction(childID:uint):String
		{
			return "Switch";
		}
		
		/**
		 * @private
		 * IAccessible method for executing the Default Action.
		 *
		 * @param childID uint
		 */
		override public function accDoDefaultAction(childID:uint):void
		{
			if(childID > 0)
			{
				var index:int = childID < MAX_NUM ?
								childID - 1 :
								childID - MAX_NUM - 1;
								
				TabBar(master).selectedIndex = index;
			}
		}

		/**
		 * @private
		 * Method to return the childID Array.
		 *
		 * @return Array
		 */
		override public function getChildIDArray():Array
		{
			var childIDs:Array = [];
			
			var n:int = TabBar(master).numChildren;
			for(var i:int = 0; i < n; i++)
			{
				childIDs[i] = i + 1;
			}
			
			return childIDs;
		}

		/**
		 * @private
		 * IAccessible method for returning the bounding box of the Tabs.
		 * 
		 * @param childID The child id
		 *
		 * @return Object Location
		 */
		override public function accLocation(childID:uint):*
		{
			var index:int = childID < MAX_NUM ?
							childID - 1 :
							childID - MAX_NUM - 1;

			return TabBar(master).getChildAt(index);
		}

		/**
		 * @private
		 * IAccessible method for returning the childFocus of the TabBar.
		 *
		 * @param childID uint
		 *
		 * @return focused childID.
		 */
		override public function get_accFocus():uint
		{
			var index:int = TabBar(master).focusIndex;
			
			if(index >= 0)
			{
				return index + 1;
			}
			return 0;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------

		/**
		 * @private
		 * method for returning the name of the Tab
		 * which is spoken out by the screen reader.
		 *
		 * @param childID The child id.
		 *
		 * @return Name
		 */
		override protected function getName(childID:uint):String
		{
			if(childID == 0)
			{
				return "";
			}

			var name:String;

			var tabBar:TabBar = TabBar(master);
			
			// Assuming childID is always ItemID + 1
			// because getChildIDArray is not always invoked.
			var index:int = childID < MAX_NUM ?
							childID - 1 :
							childID - MAX_NUM - 1;
			
			var item:TabButton = TabButton(tabBar.getChildAt(index));

			name = item.label;

			return name;
		}
		
		/**
		 * @private
		 * Override the generic event handler.
		 * All AccImpl must implement this to listen for events
		 * from its master component. 
		 */
		override protected function eventHandler(event:Event):void
		{
			switch (event.type)
			{
				case "change":
					this.updateSelection(TabBar(master).selectedIndex);
					break;
				case "focusUpdate":
					this.updateFocus(TabBar(master).focusIndex);
					break;
			}
		}
		
		/**
		 * @private
		 * Tells the client that a tab has been selected.
		 */
		protected function updateSelection(index:int):void
		{
			 if(index < 0 || !Accessibility.active)
			{
				return;
			} 
			
			var childID:uint = index + 1;
			Accessibility.sendEvent(master, childID, EventTypes.EVENT_OBJECT_FOCUS);
			Accessibility.sendEvent(master, childID, EventTypes.EVENT_OBJECT_SELECTION);
			//Accessibility.updateProperties();
		}
		
		/**
		 * @private
		 * Tells the client that a tab has been focused.
		 */
		protected function updateFocus(index:int):void
		{
			 if(index < 0 || !Accessibility.active)
			{
				return;
			} 
			
			var childID:uint = index + 1;
			Accessibility.sendEvent(master, childID, EventTypes.EVENT_OBJECT_FOCUS);
			//Accessibility.updateProperties();
		}
	}	
}
