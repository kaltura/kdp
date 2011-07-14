/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.accessibility
{
	import com.yahoo.astra.accessibility.EventTypes;
	import com.yahoo.astra.accessibility.ObjectRoles;
	import com.yahoo.astra.accessibility.ObjectStates;
	
	import com.yahoo.astra.fl.controls.Carousel;
	
	import fl.accessibility.SelectableListAccImpl;
	import fl.core.UIComponent;

	/**
     * The CarouselAccImpl class is used to make a Carousel component accessible.
	 * 
	 * <p>A Carousel reports the role <code>ROLE_SYSTEM_LIST</code> (0x21) to a screen 
	 * reader. Its items report the role <code>ROLE_SYSTEM_LISTITEM</code> (0x22).</p>
     *
     * @see com.yahoo.astra.fl.controls.Carousel
     *
     * @author Alaric Cole
	 */
	public class CarouselAccImpl extends SelectableListAccImpl 
	{
		
		/**
		 *  @private
         *  Static variable triggering the <code>hookAccessibility()</code> method.
		 *  This is used for initializing CarouselAccImpl class to hook its
         *  <code>createAccessibilityImplementation()</code> method to Carousel class 
         *  before it gets called from UIComponent.
         *
		 */
		private static var accessibilityHooked:Boolean = hookAccessibility();

		/**
		 *  @private
         *  Static method for swapping the <code>createAccessibilityImplementation()</code>
         *  method of Carousel with the CarouselAccImpl class.
         *
		 */ 
		private static function hookAccessibility():Boolean 
		{
			Carousel.createAccessibilityImplementation = createAccessibilityImplementation;
			return true;
		}

	
		/**
		 *  @private
		 *  Method for creating the Accessibility class.
		 *  This method is called from UIComponent.
		 * 
		 *  @param component The UIComponent instance that this AccImpl instance
         *  is making accessible.
         *
		 */
		public static function createAccessibilityImplementation(component:UIComponent):void 
		{
			component.accessibilityImplementation = new CarouselAccImpl(component);
		}

		/**
		 *  Enables accessibility for a Carousel component.
		 *  This method is required for the compiler to activate
         *  the accessibility classes for a component.
		 */
		public static function enableAccessibility():void 
		{
			//
		}

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

        /**
		 *  Creates a new Carousel Accessibility Implementation.
		 *
		 *  @param master The UIComponent instance that this AccImpl instance
         *  is making accessible.
         *
		 */
		public function CarouselAccImpl(master:UIComponent) 
		{
			super(master);
		}


		//--------------------------------------------------------------------------
		//  Name
		//--------------------------------------------------------------------------
		/**
		 *  @inheritDoc
         *
		 */
		override protected function getName(childID:uint):String 
		{
			if (childID == 0) {
				return "";
			}
			var list:Carousel = Carousel(master);
			
			if(list.dataProvider) 
			{
				var index:int = childID - 1;
		
				if (index > -1)
				{
					var item:Object = list.getItemAt(index);
					var ext:String = " " + childID + " of " + list.dataProvider.length;
					if (item is String) {
						return item + ext;
					} else {
						return list.itemToLabel(item) + ext;
					}
				}
			}
			return "";
		}	
			
		//--------------------------------------------------------------------------
		//  Value
		//--------------------------------------------------------------------------
		/**
		 *  @inheritDoc
		 */
		override public function get_accValue(childID:uint):String 
		{
			var accValue:String;
			var list:Carousel = Carousel(master);
			var index:int = list.selectedIndex;
			if (childID == 0) {
				if (index > -1) {
					var ext:String = " " + (index + 1) + " of " + list.dataProvider.length;
					var item:Object = list.getItemAt(index);
					if (item is String) {
						accValue = item + ext;
					} else {
						accValue = list.itemToLabel(item) + ext;
					}
				}
			}
			return accValue;
		}

		//--------------------------------------------------------------------------
		//  State
		//--------------------------------------------------------------------------
		/**
		 *  @inheritDoc
		 */
		override public function get_accState(childID:uint):uint 
		{
			var accState:uint = getState(childID);
			if (childID > 0) {
				var list:Carousel = Carousel(master);
				var index:uint = childID - 1;
				
				if (index < list.horizontalScrollPosition || index >= list.horizontalScrollPosition + list.columnCount) {
					accState |= (ObjectStates.STATE_SYSTEM_OFFSCREEN | ObjectStates.STATE_SYSTEM_INVISIBLE);
				} else {
					accState |= ObjectStates.STATE_SYSTEM_SELECTABLE;
					var item:Object = list.getItemAt(index);
					var selItems:Array = list.selectedIndices;
					for(var i:int = 0; i < selItems.length; i++) {
						if(selItems[i] == index) {
							accState |= ObjectStates.STATE_SYSTEM_SELECTED | ObjectStates.STATE_SYSTEM_FOCUSED;
							break;
						}
					}
				}
			}
			return accState;
		}


	}
}
