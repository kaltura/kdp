/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.data.SimpleCollectionItem;
	import fl.events.DataChangeEvent;
	import fl.controls.Button;
	
	/**
	 * Abstract class that extends UIComponent and creates a row of buttons.
	 *
	 * @see fl.core.UIComponent
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges
	 */
	public class AbstractButtonRow extends UIComponent
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor
		 */
		public function AbstractButtonRow()
		{
			super();
		}
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Creates the Accessibility class.
		 * This method is called from UIComponent.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static var createAccessibilityImplementation:Function;	
		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private (protected)
		 */
		//When redrawing, buttons are saved in this cache for reuse. 
		protected var _cachedButtons:Array = [];
		
		/**
		 * @private (protected)
		 */
		//Storage for the buttons displayed in the AbstractButtonRow.
		protected var _buttons:Array = [];
		
		/**
		 * @private (protected)
		 */
		protected var _focusIndex:int = 0;
		
		/**
		 * Gets or sets the index of the currently focused tab (used for keyboard navigation).
		 */
		public function get focusIndex():int
		{
			return this._focusIndex;
		}
		
		/**
		 * @private (setter)
		 */
		public function set focusIndex(value:int):void
		{
			this._focusIndex = value;
			if(this._focusIndex >= 0)
			{
				var button:Button = this._buttons[this._focusIndex];
				button.setFocus();
				
				//internal event used for accessibility
				//similar implementation in Flex TabBar control.
				this.dispatchEvent(new Event("focusUpdate"));
			}
			this.invalidate();
		}
		
		/**
		 * @private
		 */
		//Like fl.controls.List, the purpose of this variable is
		//only to make sure the SimpleCollectionItem is included.
		private var collectionItemImport:SimpleCollectionItem;
		
		/**
		 * @private (protected)
		 */
		//Storage for the dataProvider property.
		protected var _dataProvider:DataProvider;		
		
		[Collection(collectionClass="fl.data.DataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]		
		/**
		 * Gets or sets the data model of the list of items to be viewed. A data provider 
		 * can be shared by multiple list-based components. Changes to the data provider 
		 * are immediately available to all components that use it as a data source. 
		 *  
		 * @default null
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get dataProvider():DataProvider
		{
			return this._dataProvider;
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set dataProvider(value:DataProvider):void
		{
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, dataChangeHandler);
			}
			
			this._dataProvider = value;
			
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, dataChangeHandler, false, 0, true);
			}
			
			this.invalidate();
		}
		
		/**
		 * @private (protected)
		 * Storage for the labelField property.
		 */
		protected var _labelField:String = "label";
		
		/**
		 * Gets or sets the name of the field in the <code>dataProvider</code> object 
		 * to be displayed as the label in the tabs. 
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
		public function get labelField():String
		{
			return this._labelField;	
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField != value)
			{
				this._labelField = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private (protected)
		 * Storage for the labelFunction property.
		 */
		protected var _labelFunction:Function = null;
		
		/**
		 * Gets or sets the function to be used to obtain the label for the item.
		 *
		 * <p>By default, the component displays the <code>label</code> property
		 * for a <code>dataProvider</code> item. But some data sets may not have 
		 * a <code>label</code> field or may not have a field whose value
		 * can be used as a label without modification. For example, a given data 
		 * set might store full names but maintain them in <code>lastName</code> and  
		 * <code>firstName</code> fields. In such a case, this property could be
		 * used to set a callback function that concatenates the values of the 
		 * <code>lastName</code> and <code>firstName</code> fields into a full 
		 * name string to be displayed.</p>
		 *
		 * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
		 * if the <code>labelFunction</code> property is set to a callback function.</p>
		 *
		 * @default null
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;	
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction != value)
			{
				this._labelFunction = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private (protected)
		 * Storage for the selectedIndex property.
		 */
		protected var _selectedIndex:int = 0;
		
		/**
		 * Gets or sets the index of the tab that is selected. Only one item can be selected 
		 * at a time. 
		 *
		 * <p>A value of -1 indicates that no tab is selected.</p>
		 *
		 * <p>When ActionScript is used to set this property, the item at the specified index
		 * replaces the current selection. When the selection is changed programmatically, 
		 * a <code>change</code> event object is not dispatched. </p>
		 *
		 * @see #selectedItem
		 *  
		 * @default 0
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set selectedIndex(value:int):void
		{
			if(value >= this._dataProvider.length) value = -1;
			if(this._selectedIndex != value)
			{
				this._selectedIndex = value;
				this.focusIndex = value;
				this.invalidate();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Gets or sets the item that was selected. 
		 *
		 * <p>If no selection is made, the value of this property is <code>null</code>.</p>
		 *
		 * @see #selectedIndex
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function get selectedItem():Object
		{
			if(this.selectedIndex >= 0)
			{
				return this._dataProvider.getItemAt(this.selectedIndex);
			}
			return null;
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function set selectedItem(value:Object):void
		{
			var index:int = this._dataProvider.getItemIndex(value);
			this.selectedIndex = index;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * Returns the index of the given data object.
		 * 
		 * @param	item	The object to be rendered.
		 * @return the index of the object in the data provider. -1 if it cannot be found.
		 */
		public function itemToIndex(item:Object):int
		{
			return this._dataProvider.getItemIndex(item);
		}
		
		/**
		 * Retrieves the string that the renderer displays for the given data object 
		 * based on the <code>labelField</code> and <code>labelFunction</code> properties.
		 *
		 * <p><strong>Note:</strong> The <code>labelField</code> is not used  
		 * if the <code>labelFunction</code> property is set to a callback function.</p>
		 *
		 * @param item	The object to be rendered.
		 *
		 * @return	The string to be displayed based on the data.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function itemToLabel(item:Object):String
		{
			if(this.labelFunction != null)
			{
				this.labelFunction(item, this.itemToIndex(item));
			}
			else if(this.labelField && item.hasOwnProperty(this.labelField))
			{
				return item[this.labelField];
			}
			return "";
		}
		
		/**
		 * Returns the data object corresponding to an index.
		 * 
		 * @param	index	a zero-based index
		 * @return	the item at the specified index within the data provider.
		 */
		public function indexToItem(index:int):Object
		{
			return this._dataProvider.getItemAt(index);
		}
		
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * 
		 */
		//Placeholder - TB, does it need to even be here?
		override protected function initializeAccessibility():void
		{
			if(AbstractButtonRow.createAccessibilityImplementation != null)
			{
				AbstractButtonRow.createAccessibilityImplementation(this);
			}
		}
	
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void
		{	
			this.createCache();
			if(this._dataProvider)
			{
				this.drawButtons();
			}
			this.clearCache();
			this.drawBackground();			
			super.draw();
		}
		
		/**
		 * @private (protected)
		 * 
		 * Updates the position and size of the buttons.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function drawButtons():void
		{
			//place holder must be overridden
		}
		
		/**
		 * @private (protected)
		 * 
		 * Either retrieves a button from the cache or creates a new one.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function getButton():Button
		{
			//place holder must be overridden
			return new Button();
		}
		
		/**
		 * @private (protected)
		 * 
		 * Saves the buttons from the last redraw so that they may be reused.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function createCache():void
		{
			this._cachedButtons = this._buttons.concat();
			this._buttons = [];
		}
		
		/**
		 * @private (protected)
		 * 
		 * Removes unneeded buttons that were cached for a redraw.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
	     */
		protected function clearCache():void
		{
			//placeholder must be overridden
		}
		
		/**
		 * @private (protected)
		 * 
		 * Requests a redraw when the data provider changes.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function dataChangeHandler(event:DataChangeEvent):void
		{
			this.invalidate();
		}
		
		/**
		 * @private (protected)
		 * Listen for events to allow for keyboard navigation.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function navigationKeyDownHandler(event:KeyboardEvent):void
		{
			//place holder must be overridden
		}	
		
		/**
		 * @private
		 */
		protected function drawBackground():void{} 
	}
}