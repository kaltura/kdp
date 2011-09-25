/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls
{
import com.yahoo.astra.fl.controls.autoCompleteClasses.AutoCompleteCellRenderer;
import com.yahoo.astra.fl.events.DropdownEvent;

import fl.controls.List;
import fl.controls.TextInput;
import fl.controls.listClasses.CellRenderer;
import fl.data.DataProvider;
import fl.events.ListEvent;
import fl.events.ScrollEvent;
import fl.transitions.easing.*;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.utils.*;
//--------------------------------------
//  Events
//--------------------------------------
/**
 *  Dispatched when the <code>filterFunction</code> property changes.
 *
 *  You can listen for this event and update the component
 *  when the <code>filterFunction</code> property changes.</p>
 * 
 *  @eventType flash.events.Event
 */
[Event(name="filterFunctionChange", type="flash.events.Event")]
/**
 *  Dispatched when the <code>typedText</code> property changes.
 *
 *  You can listen for this event and update the component
 *  when the <code>typedText</code> property changes.</p>
 * 
 *  @eventType flash.events.Event
 */
[Event(name="typedTextChange", type="flash.events.Event")]
/**
 *  Dispatched when the completion box becomes visible.
 * 
 *  @eventType com.yahoo.astra.fl.events.DropdownEvent
 */
[Event(name="open", type="com.yahoo.astra.fl.events.DropdownEvent")]
/**
 *  Dispatched when the completion box becomes invisible.
 * 
 *  @eventType com.yahoo.astra.fl.events.DropdownEvent
 */
[Event(name="close", type="com.yahoo.astra.fl.events.DropdownEvent")]
//--------------------------------------
//  Other metadata
//--------------------------------------
[IconFile("assets/AutoComplete.png")]
//--------------------------------------
//  Class description
//--------------------------------------
/**
 *  The AutoComplete control works like a
 *  TextInput control, but can pop up a list of suggestions 
 *  based on text entered. These suggestions
 *  are to be provided by setting the 
 *  <code>dataProvider</code> property.
 *
 *  @author Alaric Cole
 */
public class AutoComplete extends TextInput
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function AutoComplete()
	{
	    super();
	
        addEventListener("unload", unloadHandler);
		addEventListener("addedToStage", stageAdded);
		textField.addEventListener(MouseEvent.MOUSE_DOWN, close);
	}
	//--------------------------------------------------------------------------
	//
	//  Private variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private var showingDropdown:Boolean=false;
	
	/**
	 *  @private
	 */
	private var filteredData:Array;
	
	/**
     *  @private
     *  A reference to the internal List that pops up to display a row
     *  for each dataProvider item.
     */
    private var _dropdown:List;
    
    /**
     *  @private
     *  A int to track the oldIndex, used when the dropdown is dismissed using the ESC key.
     */
    private var _oldIndex:int;
    
    /**
     *  @private
     *  Is the dropdown list currently shown?
     */
    private var _showingDropdown:Boolean = false;
	
	/**
     *  @private
     */
    private function get isShowingDropdown():Boolean
    {
        return _showingDropdown;
    }
    
    /**
     *  @private
     */
    private var _selectedIndexOnDropdown:int = -1;
    
    /**
     *  @private
     */
    private var bRemoveDropdown:Boolean = false;
    
    /**
     *  @private
     */
    private var inTween:Boolean = false;
    
    /**
     *  @private
     */
    private var bInKeyDown:Boolean = false;
    
    /**
     *  @private
     *  Flag that will block default data/listData behavior
     */
    private var selectedItemSet:Boolean;
    
    /**
     *  @private
     *  Event that is causing the _dropdown to open or close.
     */
    private var triggerEvent:Event;
    
	/**
	 *  @private
	 */
	private var usingLocalHistory:Boolean=false;
	
	/**
	 *  @private
	 */
	private var dropdownClosed:Boolean=true;
	
	/**
	 *  @private
	 */
	private var cursorPosition:Number = 0;
	
	/**
	 *  @private
	 */
	private var prevIndex:Number = -1;
	
	/**
	 *  @private
	 */
	private var removeHighlight:Boolean = false;	
	
	/**
	 *  @private
	 */
	private var _showDropdown:Boolean=false;
	 
	/**
     *  @private
     */
	private var _unfilteredDataProvider:DataProvider;
	
	/**
	 *  This holds the original data provider (without filtering based on what was typed).
	 */
	protected function  get unfilteredDataProvider():DataProvider
	{
		return _unfilteredDataProvider;
	}
	
	/**
	 *  This holds the data provider without filters.
	 */
	protected function  set unfilteredDataProvider(value:DataProvider):void
	{
		_unfilteredDataProvider = value;
	}
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	  /**
     *  @private
     *  Storage for the popUpRenderer property.
     */
    private var _defaultPopUpRenderer:Class = List ;
	  /**
     *  @private
     *  Storage for the popUpRenderer property.
     */
    private var _popUpRenderer:Class = _defaultPopUpRenderer ;

     /**
     *  The custom renderer that creates a List-derived instance to use
     *  as the drop-down.
     *  @default fl.controls.List
     *
     */
    public function get popUpRenderer():Class
    {
        return _popUpRenderer;
    }

    /**
     *  @private
     */
    public function set popUpRenderer(value:Class):void
    {
        _popUpRenderer = value;
		
		//remove all previous instances of dropdowns
		
    }
	/**
	 *  @private
	 *  Method for creating the Accessibility class.
	 *  This method is called from UIComponent.
	 */
	public static var createAccessibilityImplementation:Function;
	
	//----------------------------------
	//  dataProvider
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _dataProvider:DataProvider;
	
	/**
	 *  Gets or sets the data model of the list of items to be viewed. 
	 *  A data provider can be shared by multiple list-based components. 
	 *  Changes to the data provider are immediately available to all components that use it as a data source.
	 * 
	 *  @default null
	 */
	public function  get dataProvider():DataProvider
	{
		return _dataProvider;
	}
	
	[Collection(collectionClass="fl.data.DataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]
	public function set dataProvider(value:DataProvider):void
    {
        _dataProvider = value;
		
		dropdown.dataProvider = value;
        unfilteredDataProvider = value.clone();

    }
    //----------------------------------
    //  selectedIndex
    //----------------------------------
    /**
     *  Index of the selected item in the drop-down list.
     *  Setting this property sets the current index and displays
     *  the associated label in the TextInput portion.
     *  <p>The default value is -1, but it set to 0
     *  when a <code>dataProvider</code> is assigned, unless there is a prompt.
     *  If the control is editable, and the user types in the TextInput portion,
     *  the value of the <code>selectedIndex</code> property becomes 
     *  -1. If the value of the <code>selectedIndex</code> 
     *  property is out of range, the <code>selectedIndex</code> property is set to the last
     *  item in the <code>dataProvider</code>.</p>
     */
    public function get selectedIndex():int
    {
		return _dropdown.selectedIndex
	}
	
    /**
     *  Index of the selected item in the drop-down list.
     *  Setting this property sets the current index and displays
     *  the associated label in the TextInput portion.
     *  <p>The default value is -1, but it set to 0
     *  when a <code>dataProvider</code> is assigned, unless there is a prompt.
     *  If the control is editable, and the user types in the TextInput portion,
     *  the value of the <code>selectedIndex</code> property becomes 
     *  -1. If the value of the <code>selectedIndex</code> 
     *  property is out of range, the <code>selectedIndex</code> property is set to the last
     *  item in the <code>dataProvider</code>.</p>
     */
    public function set selectedIndex(value:int):void
    {
        _dropdown.selectedIndex = value;
         if ( value >=0)
         {
            text = selectedLabel; 
			setSelection(text.length, text.length);

			textField.scrollH = 0;
			
			removeHighlight = false;
			if(!bInKeyDown) updateDataProvider(false);
			
			typedTextChanged = true;
			_dropdown.scrollToSelected();
		    invalidate();
        	
        }
    }
    //----------------------------------
    //  selectedItem
    //----------------------------------
	 
	/**
     *  The selectedItem in the dropdown
     */
	public function  get selectedItem():Object
	{
		return _dropdown.selectedItem;
	}
	
	/**
     *  The selectedItem in the dropdown
     */
	public function  set selectedItem(value:Object):void
	{
		
		_dropdown.selectedItem = value;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  dropdown
    //----------------------------------
    /**
     *  A reference to the List control that acts as the drop-down in the AutoComplete.
     *
     *  @tiptext Returns a reference to the List component
     *  
     */
    public function get dropdown():List
    {
        return getDropdown();
    }
    //----------------------------------
    //  dropdownWidth
    //----------------------------------
    /**
     *  @private
     *  Storage for the dropdownWidth property.
     */
    private var _dropdownWidth:Number = 100;
	
	/**
     *  Width of the drop-down list, in pixels.
     *  <p>The default value is 100 or the width of AutoComplete component
     *  in the <code>dataProvider</code>, whichever is greater.</p>
     *
     */
    protected function get dropdownWidth():Number
    {
        return _dropdownWidth;
    }
    /**
     *  @private
     */
    protected function set dropdownWidth(value:Number):void
    {
        if(_dropdownWidth == value) return;

        _dropdownWidth = value;
        if (_dropdown)
           _dropdown.setSize(value, dropdownHeight);

        dispatchEvent(new Event("dropdownWidthChanged"));
    }
    
    //----------------------------------
    //  dropdownHeight
    //----------------------------------
	/**
     *  Height of the drop-down list, in pixels.
     *  @default 100
     *
     */
    protected function get dropdownHeight():Number
    {
        return _dropdown.rowCount * _dropdown.rowHeight;
    }

    //----------------------------------
    //  labelField
    //----------------------------------
    /**
     *  @private
     *  Storage for the labelField property.
	 *  @default "label"
     */
    private var _labelField:String = "label";
    /**
     *  @private
     */
    private var labelFieldChanged:Boolean;
    [Inspectable(category="Data", defaultValue="label")]
    /**
     *  Name of the field in the items in the <code>dataProvider</code>
     *  Array to display as the label in the TextInput portion and drop-down list.
     *  By default, the control uses a property named <code>label</code>
     *  on each Array object and displays it.
     *  <p>However, if the <code>dataProvider</code> items do not contain
     *  a <code>label</code> property, you can set the <code>labelField</code>
     *  property to use a different property.</p>
     *
     */
    public function get labelField():String
    {
        return _labelField;
    }
    /**
     *  @private
     */
    public function set labelField(value:String):void
    {
        _labelField = value;
        labelFieldChanged = true;
        invalidate();
		drawLayout();
        dispatchEvent(new Event("labelFieldChanged"));
    }
    //----------------------------------
    //  labelFunction
    //----------------------------------
    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;
    /**
     *  @private
     */
    private var labelFunctionChanged:Boolean;
     /**
     *  User-supplied function to run on each item to determine its label.
     *  By default the control uses a property named <code>label</code>
     *  on each <code>dataProvider</code> item to determine its label.
     *  However, some data sets do not have a <code>label</code> property,
     *  or do not have another property that can be used for displaying
     *  as a label.
     *  <p>An example is a data set that has <code>lastName</code> and
     *  <code>firstName</code> fields but you want to display full names.
     *  You use <code>labelFunction</code> to specify a callback function
     *  that uses the appropriate fields and return a displayable String.</p>
     *
     *  <p>The labelFunction takes a single argument which is the item
     *  in the dataProvider and returns a String:</p>
     *  <pre>
     *  myLabelFunction(item:Object):String
     *  </pre>
     *
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }
    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;
        labelFunctionChanged = true;
        invalidate();
        dispatchEvent(new Event("labelFunctionChanged"));
    }
    //----------------------------------
    //  rowCount
    //----------------------------------
    /**
     *  @private
     *  Storage for the rowCount property.
     */
    private var _rowCount:int = 5;
    /**
     *  Maximum number of rows visible in the AutoComplete control list.
     *  If there are fewer items in the
     *  dataProvider, the AutoComplete shows only as many items as
     *  there are in the dataProvider.
     *  
     *  @default 5
     */
    public function get rowCount():int
    {
        return Math.max(1, Math.min(dropdown.dataProvider.length, _rowCount));
    }
    /**
     *  @private
     */
    public function set rowCount(value:int):void
    {

        _rowCount = value;
        if (_dropdown)
            _dropdown.rowCount = value;
    }
    //----------------------------------
    //  selectedLabel
    //----------------------------------
    /**
     *  The String displayed in the TextInput portion of the AutoComplete. It
     *  is calculated from the data by using the <code>labelField</code> 
     *  or <code>labelFunction</code>.
     */
    public function get selectedLabel():String
    {
        var item:Object = selectedItem;
        return itemToLabel(item);
    }
  
	//----------------------------------
	//  filterFunction
	//----------------------------------
	/**
	 *  @private
	 *  Storage for the filterFunction property.
	 */
	private var _filterFunction:Function = defaultFilterFunction;
	/**
	 *  @private
	 */
	private var filterFunctionChanged:Boolean = true;
	/**
	 *  A function that is used to select items that match the
	 *  function's criteria. 
	 *  A filterFunction is expected to have the following signature:
	 *
	 *  <pre>f(element:~~, index:int, arr:Array):Boolean</pre>
	 *
	 *  where the return value is <code>true</code> if the specified item
	 *  should displayed as a suggestion. 
	 *  Whenever there is a change in text in the AutoComplete control, this 
	 *  filterFunction is run on each item in the <code>dataProvider</code>.
	 *  
 	 *  <p>The default implementation for filterFunction works as follows:<br>
 	 *  If "AB" has been typed with or without leading or trailing whitespace, 
 	 *  it will display all the items matching 
	 *  "AB~~" (ABaa, ABcc, abAc etc.).</p>
	 *
	 *  <p>An example usage of a customized filterFunction is when text typed
	 *  is a regular expression and we want to display all the
	 *  items which come in the set.</p>
	 *
	 *  @example
	 *  <pre>
	 *  public function myFilterFunction(element:~~, index:int = 0, arr:Array = null):Boolean
	 *  {
	 *     public var regExp:RegExp = new RegExp(text,"");
	 *     return regExp.test(element);
	 *  }
	 *  </pre>
	 *
	 */
	public function get filterFunction():Function
	{
		return _filterFunction;
	}
	/**
	 *  @private
	 */
	public function set filterFunction(value:Function):void
	{
		//An empty filterFunction is allowed but not a null filterFunction
		if(value!=null)
		{
			_filterFunction = value;
			filterFunctionChanged = true;
			
			invalidate();
	
			dispatchEvent(new Event("filterFunctionChange"));
		}
		else
			_filterFunction = defaultFilterFunction;
	}
	
	/**
	 *  @private
	 *  Storage for the keepLocalHistory property.
	 */
	private var _keepLocalHistory:Boolean = false;
	/**
	 *  @private
	 */
	private var keepLocalHistoryChanged:Boolean = true;
	[Inspectable(category="General")]
	/**
	 *  When true, this causes the control to keep track of the
	 *  entries that are typed into the control, and saves the
	 *  history as a local shared object. When true, the
	 *  completionFunction and dataProvider are ignored.
	 *
	 *  @default false
	 */
	public function get keepLocalHistory():Boolean
	{
		return _keepLocalHistory;
	}
	/**
	 *  @private
	 */
	public function set keepLocalHistory(value:Boolean):void
	{
		_keepLocalHistory = value;
		if(value)
		{
			addEventListener("focusOut",focusOutHandler);
		}
		else
		{
			removeEventListener("focusOut",focusOutHandler);
		}
		
	}
	//----------------------------------
	//  autoFillEnabled
	//----------------------------------
	/**
	 *  @private
	 *  Storage for the autoFillEnabled property.
	 */
	private var _autoFillEnabled:Boolean;
	/**
	 *  @private
	 */
	private var autoFillEnabledChanged:Boolean;
	[Inspectable]
	/**
	 *  Whether to complete the text in the text field
	 *  with the first item in the drop down list or not. 
	 *
	 *  @default false
	 */
	public function get autoFillEnabled():Boolean
	{
		return _autoFillEnabled;
	}
	/**
	 *  @private
	 */
	public function set autoFillEnabled(value:Boolean):void
	{
		_autoFillEnabled = value;
		autoFillEnabledChanged = true;
	}
	
	/**
	 *  @private
	 *  Storage
	 */
	private var _minCharsForCompletion:int = 0;
	
	[Inspectable]
	/**
	 *  The minimum number of characters that must be typed in to display the completion list
	 * @default 0
	 */
	public function get minCharsForCompletion():int
	{
	    return _minCharsForCompletion;
	}
	public function set minCharsForCompletion(value:int):void
	{
	    _minCharsForCompletion =  value;
	}
	
	[Inspectable]
	/**
     *  A flag that indicates whether to loop the selection in the dropdown when
     * using the arrow keys. 
     *
     *  @default true
     */
    public var loopSelection:Boolean = true;
    
	/**
	 *  @private 
	 */
	private var continuation:Boolean = false;
	
	
	//----------------------------------
	//  typedText
	//----------------------------------
	/**
	 *  @private
	 *  Storage for the typedText property.
	 */
	private var _typedText:String="";
	/**
	 *  @private
	 */
	protected var typedTextChanged:Boolean;
	
	/**
	 *  A String to keep track of the text changed as 
	 *  a result of user interaction.
	 */
	protected function get typedText():String
	{
	    return _typedText;
	}
	
	/**
	 *  @private
	 */
	protected function set typedText(input:String):void
	{
		_typedText = input;
	    typedTextChanged = true;
		updateDataProvider();
	  
		if(autoFillEnabled && dropdown.visible && typedText!="")
		{
			var lbl:String = itemToLabel(dataProvider.getItemAt(0));
			var index:Number =  lbl.toLowerCase().indexOf(text.toLowerCase());
			if(index==0)
			{
				var t:String = lbl.substr(text.length);
			   
			   if(!removeHighlight)
				{
					text = text + t;
					setSelection(text.length,_typedText.length);
					textField.scrollH = 0;
				}
				else
				{
					setSelection(text.length,text.length);
					//keeping the autoFillEnabled highlighted text from being scrolled to
					//This should highlight the text but keep the original text in the same place horizontally
					textField.scrollH = 0;
				}
				removeHighlight = false;
				
			}
		}
		dispatchEvent(new Event("typedTextChange"));
	}
	
	/**
	 *  @private
	 *  Storage for the property.
	 */
	private var _dropdownEnabled:Boolean = true;
	
	[Inspectable]
	/**
	 *  Allows completion of a word or phrase with a dropdown list. 
	 *  Setting to false could allow this to be used as an autofill/lookahead only component
	 *  @default true
	 */
	public function get dropdownEnabled():Boolean
	{
	    return _dropdownEnabled;
	}
	
	public function set dropdownEnabled(value:Boolean):void
	{
		_dropdownEnabled = value;
	
	}
	
	/**
	 *  @private
	 *  Storage for the property.
	 */
	private var _emphasizeMatch:Boolean = false;
	
	[Inspectable]
	/**
	 *  Highlights the characters or words in each item in the dropdown list
	 *  that match the characters the user typed in the input field.
	 * 
	 *  @default false
	 */
	public function get emphasizeMatch():Boolean
	{
	    return _emphasizeMatch;
	}
	
	public function set emphasizeMatch(value:Boolean):void
	{
		_emphasizeMatch = value;
	
	}
	
	/**
	 *  @private
	 */
	protected function defaultFilterFunction(element:*, index:int = 0, arr:Array = null):Boolean 
	{
	    var label:String = itemToLabel(element);
	    var input:String = text.toLowerCase();
	    var potentialMatch:String = label.toLowerCase().substring(0,input.length);
	    var b:Boolean = potentialMatch == input;
		
		return b;
	}
	/**
	 *  @private
	 */
 	private function templateFilterFunction(element:*):Boolean 
	{
		var flag:Boolean=false;
		if(filterFunction!=null)
			flag=filterFunction(element,typedText);
		return flag;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
	 /**
     *  @private
     *  Make sure the drop-down width is the same as the rest of the AutoComplete
     */
    override protected function draw():void
    {
        super.draw();
        if (!_showingDropdown && inTween)
        {
            bRemoveDropdown = true;
        }
		
        if (labelFieldChanged)
        {
            if (_dropdown)
                _dropdown.labelField = _labelField;
        }
        if (labelFunctionChanged)
        {
            if (_dropdown)
                _dropdown.labelFunction = _labelFunction;
        }
        
    }
    
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
				
	/**
	 *  @private
	 *  If keepLocalHistory is enabled, stores the text typed 
	 * 	by the user in the local history on the client machine
	 */
	private function addToLocalHistory():void
	{
        if ( text != null && text != "")
        {
            var so:SharedObject = SharedObject.getLocal(name + "AutoCompleteData");
            var savedData : Array = so.data.suggestions;
            //No shared object has been created so far
            if (savedData == null)
                savedData = new Array();
             var i:Number=0;
             var flag:Boolean=false;
             //Check if this entry is there in the previously saved shared object data
             for(i=0;i<savedData.length;i++)
				if(savedData[i]==text)
				{
					flag=true;
					break;
				}
             if(!flag)
             {
             	//Also ensure it is not there in the dataProvider
	             for(i=0;i<dataProvider.length;i++)
	             	if(defaultFilterFunction(
											 itemToLabel(DataProvider(dataProvider).getItemAt(i)))
					   						)
					{
						flag=true;
						break;
					}
             }
     		if(!flag)
     			savedData.push(text);
           so.data.suggestions = savedData;
           //write the shared object in the .sol file
	       so.flush();
        }
	}	
	/**
	 *  @private
	 *  Updates the dataProvider used for showing suggestions
	 */
	private function updateDataProvider(allowOpen:Boolean= true):void
	{

		if(!_dropdown) getDropdown();
		
		if(typedText.length <= minCharsForCompletion && !bInKeyDown) 
		{
			displayDropdown(false);
			return;
		}
		
		filteredData = unfilteredDataProvider.toArray();
		filteredData = filteredData.filter(filterFunction);
		
		_dropdown.dataProvider = new DataProvider(filteredData);
		
		
	    //In case there are no suggestions, check there is something in the localHistory
  	    if(dataProvider.length==0 && keepLocalHistory)
  	    {
            var so:SharedObject = SharedObject.getLocal(name + "AutoCompleteData");
			
			if(so.data.suggestions)
			{
           		dataProvider = new DataProvider(so.data.suggestions);
				usingLocalHistory = true;
			
				usingLocalHistory = false;
				filteredData = dataProvider.clone().toArray();
				filteredData = filteredData.filter(filterFunction);
				
				_dropdown.dataProvider = new DataProvider(filteredData);
			}
  	    }
		
		positionDropdown();
		
  	    if(allowOpen) 
		{
			(_dropdown.dataProvider.length > 0) ? open(): close();
		
		}
			
  	    
		_dataProvider = _dropdown.dataProvider;
  	}
	
	  
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    /**
     *  Returns a string representing the <code>item</code> parameter.
     *  
     *  <p>This method checks in the following order to find a value to return:</p>
     *  
     *  <ol>
     *    <li>If you have specified a <code>labelFunction</code> property,
     *  returns the result of passing the item to the function.</li>
     *    <li>If the item is a String, Number, Boolean, or Function, returns
     *  the item.</li>
     *    <li>If the item has a property with the name specified by the control's
     *  <code>labelField</code> property, returns the contents of the property.</li>
     *    <li>If the item has a label property, returns its value.</li>
     *  </ol>
	 * @private
     */
    public function itemToLabel(item:Object):String
    {
        // we need to check for null explicitly otherwise
        // a numeric zero will not get properly converted to a string.
        // (do not use !item)
        if (item == null)
            return "";
        if (labelFunction != null)
            return labelFunction(item);
        if (typeof(item) == "object")
        {
            try
            {
                if (item[labelField] != null)
                    item = item[labelField];
            }
            catch(e:Error)
            {
            }
        }
        else if (typeof(item) == "xml")
        {
            try
            {
                if (item[labelField].length() != 0)
                    item = item[labelField];
            }
            catch (e:Error)
            {
            }
        }
        if (typeof(item) == "string")
			var s:String = String(item);
			
        try
        {
            return item.toString();
        }
        catch(e:Error)
        {
        }
        return " ";
    }
	/**
     *  Emphasizes the matching characters in the dropdown. 
	 *  You can override this method to create your own styles for emphasis.
	 * @private
     */
    protected function applyEmphasis():void
    {
		//force itemToCellRenderer to work properly
	     dropdown.drawNow();
		 
		 var len:int = dropdown.dataProvider.length;
		 for(var i:int; i < len; i++)
		 {
			var item:Object = dropdown.dataProvider.getItemAt(i);
			var l:String = itemToLabel(item);
			var c:CellRenderer = CellRenderer(dropdown.itemToCellRenderer(item)) ;
			
			var input:String = text.toLowerCase();
			
			var format:TextFormat = new TextFormat();
            
			//add other formatting goodies here and they'll be applied
			format.color = 0x0285DB;
            //format.bold = true;
			
			if(c) 
			{
				c.textField.setTextFormat(format, 0, input.length);
			}
			
		 }
    }
	
    /**
     *  Displays the drop-down list.
     */
    public function open():void
    {
		displayDropdown(true);
		
		//run the emphasis function
		if (emphasizeMatch) applyEmphasis();
    }
    /**
     *  Hides the drop-down list.
     */
    public function close(trigger:* = null, forceSelection:Boolean = false):void
    {
        if (_showingDropdown)
        {
            if (_dropdown)
            {
            	//if a selection is false, and this close isn't coming from the dropdown selection being changed
            	if(forceSelection )
            	{
            		if(_dropdown.selectedIndex < 0) _dropdown.selectedIndex = 0;
            		//will put text from the selection
            		selectedIndex = _dropdown.selectedIndex;
            	}
            	
				 displayDropdown(false, trigger);
				showingDropdown = false;
				invalidate();
            }
               
        }
    }
    /**
     *  @private
     */
    private function hasDropdown():Boolean
    {
        return _dropdown != null;
    }
    /**
     *  @private
     */
    private function getDropdown():List
    {

       if (!hasDropdown())
        {
        	//create the dropdown list
            _dropdown = new _popUpRenderer();
            _dropdown.visible = false;
            _dropdown.focusEnabled = false;
 			_dropdown.setStyle("skin", "AutoCompleteSkin");
 			_dropdown.setStyle("cellRenderer", AutoCompleteCellRenderer);
			
			// Set up a data provider in case one doesn't yet exist,
            // so we can share it with the dropdown listbox.
            if (!dataProvider)
                dataProvider = new DataProvider();

			selectedIndex = -1;
            _oldIndex = selectedIndex;
            _dropdown.labelField = _labelField;
            _dropdown.labelFunction = _labelFunction;
            _dropdown.addEventListener(ScrollEvent.SCROLL, dropdown_scrollHandler);
            _dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER, dropdown_itemRollOverHandler);
            _dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT, dropdown_itemRollOutHandler);
            // the drop down should close if the user clicks on any item.
            // add a handler to detect a click in the list
            _dropdown.addEventListener(Event.CHANGE, dropdown_changeHandler);
            _dropdown.validateNow();
        }
		
		return _dropdown;
    }
    /**
     *  @private
     */
    protected function displayDropdown(show:Boolean, trigger:Event = null):void
    {

        if (show == _showingDropdown)
            return;
		var endY:Number;
        
        var easingFunction:Function;
        
        
        //opening the dropdown 
        if (show)
        {
            // Store the selectedIndex temporarily so we can tell
            // if the value changed when the dropdown is closed
            _selectedIndexOnDropdown = selectedIndex;
            getDropdown();
            
          	
			var sel:int = _dropdown.selectedIndex;
            
            var pos:Number = _dropdown.verticalScrollPosition;
            // try to set the verticalScrollPosition one above the selected index so
            // it looks better when the dropdown is displayed
            pos = sel - 1;
            pos = Math.min(Math.max(pos, 0), _dropdown.maxVerticalScrollPosition);
            _dropdown.verticalScrollPosition = pos;
            
            // Make sure we don't remove the dropdown at the end of the tween
            bRemoveDropdown = false;
            
            // Set up the tween and relevant variables. 
            _showingDropdown = show;
            
            easingFunction = getStyle("openEasingFunction") as Function;
            
			var f:Number = getStyleValue("focusRectPadding") as Number;
			
           dropdownWidth = width + 2 * (f+ getStyleValue("borderThickness"));
			
        }
        
        // closing the dropdown 
        else if (_dropdown)
        {
            _showingDropdown = show;
            
            easingFunction = getStyle("closeEasingFunction") as Function;
            
            _showingDropdown = show;
        }
        
        inTween = true;
        
         var duration:Number;
         
         if(show)
         {
         	
         	//Don't display an empty dropdown
         	if(_dropdown.dataProvider.length < 1 || length < 1)  
            {
            	_dropdown.dataProvider = unfilteredDataProvider.clone();
            }
			
			positionDropdown();
         	
            
         	_dropdown.alpha = 1;
         	_dropdown.visible = true;
         	duration = Math.max(1, getStyle("openDuration") as Number);
         	
         	//Hack to get fades to work on device fonts
         	if (filters.length < 1) {
				var filter:BlurFilter=new BlurFilter(0,0,1);
				_dropdown.filters=[filter];
         	}
			
         }
         else if(!show && _dropdown.visible)
         {

         	duration =  Math.max(1, getStyle("closeDuration") as Number);

			onTweenEnd(0);
			
         	
         }
       
		var evt:DropdownEvent = new DropdownEvent(_showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
        evt.triggerEvent = trigger;
        dispatchEvent(evt);
		
    }
    /**
     *  @private
     */
    private function dispatchChangeEvent(oldEvent:Event, prevValue:int,
                                         newValue:int):void
    {
        if (prevValue != newValue)
        {
            var newEvent:Event = oldEvent is ListEvent ?
                                 oldEvent :
                                 new ListEvent("change");
            dispatchEvent(newEvent);
        }
    }
	    /**
     *  @private
     */
	 private function stageAdded(event:Event):void
	 {
		 stage.addChild(dropdown);
		 stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
		 stage.addEventListener("mouseDown", dropdown_mouseDownOutsideHandler);
	 }
            
    /**
     *  @private
     */
    private function destroyDropdown():void
    {
        if (_dropdown && !_showingDropdown)
        {
            stage.removeChild(_dropdown);
            _dropdown = null;
        }
    }
    
     /**
     * @private
     * Sets the size of the pop up
     */
    private function positionDropdown():void
    {
    	var point:Point = new Point
    	(
    		- (getStyleValue("focusRectPadding") + getStyle("borderThickness")), 
    		height + getStyleValue("focusRectPadding")+ getStyle("borderThickness")
    	);
    	
        point = localToGlobal(point);

    	if(_dropdown.rowCount != rowCount) _dropdown.rowCount = rowCount; 
    	
    	
      	// if we do not have enough space in the bottom display the dropdown
      	// at the top. 
		if (point.y + dropdownHeight > stage.stageHeight && point.y > dropdownHeight)
      	{
          // Dropdown will go below the bottom of the stage
          // and be clipped. Instead, have it grow up.
          point.y -= (height + dropdownHeight + getStyleValue("focusRectPadding")+ getStyle("borderThickness"));
      	    
     	}
		
		if (_dropdown.x != point.x || _dropdown.y != point.y)
		{
		       _dropdown.move(point.x, point.y);
		}

    }   
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    override protected function handleChange(event:Event):void
    {
		//Stores the text typed by the user in a variable
	    typedText=text;
	    
        super.handleChange(event);
    }
  
	/**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        // event.relatedObject is what's getting focus
        if (_showingDropdown && _dropdown)
        {
            // If focus is moving outside the dropdown...
            if (!event.relatedObject ||
                !_dropdown.contains(event.relatedObject))
            {
                // Close the dropdown.
                close(null, false);
            }
        }
        super.focusOutHandler(event);
        
        if(keepLocalHistory && dataProvider.length==0)
        {
        	addToLocalHistory();
        }
 			
    }
    
    
    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
		
		if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
        {
            displayDropdown(true, event);
            event.stopPropagation();
        }
        else if (event.ctrlKey && event.keyCode == Keyboard.UP)
        {
            close(event, false);
            event.stopPropagation();
        }
        else if (event.keyCode == Keyboard.ESCAPE)
        {
            if (_showingDropdown)
            {
                //sets the old index
                if (_oldIndex != _dropdown.selectedIndex)
                    selectedIndex = _oldIndex;
                displayDropdown(false);
                event.stopPropagation();
            }
        }
        else if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT) 
        {
            if (_showingDropdown)
            {
                
                close(null, false);
                
                event.stopPropagation();
                
            }
        }
        
        else if((event.keyCode ==  Keyboard.BACKSPACE)
			|| (autoFillEnabled && event.keyCode == Keyboard.DELETE))
			{
				removeHighlight = true;
				event.stopPropagation();
			}
			    
        else
        {
            if (event.keyCode == Keyboard.UP ||
                event.keyCode == Keyboard.DOWN ||
                event.keyCode == Keyboard.PAGE_UP ||
				event.keyCode == Keyboard.HOME ||
				event.keyCode == Keyboard.END ||
                event.keyCode == Keyboard.PAGE_DOWN)
            {
            	//Change selection of the drop down if it's there
            	if(_dropdown.visible)
            	{
            		var oldIndex:int = selectedIndex;
            
	                // Make sure we know we are handling a keyDown,
	                // so if the dropdown sends out a "change" event
	                // (like when an up-arrow or down-arrow changes
	                // the selection) we know not to close the dropdown.
	                bInKeyDown = _showingDropdown;
	                
	                //Add the ability to make the selection loop at the beginning or end
	                if(_dropdown)
	                {
	                	if(_dropdown.selectedIndex == _dropdown.dataProvider.length - 1 &&  event.keyCode == Keyboard.DOWN)
						{
							if(loopSelection)
							{
								selectedIndex = 0
								
							}
							
							event.stopPropagation();
						}
	                	
						else if(_dropdown.selectedIndex == 0 &&  event.keyCode == Keyboard.UP)
						{
							if(loopSelection)
							{
								selectedIndex = _dropdown.dataProvider.length - 1;
							}
							
							event.stopPropagation();
							
						}
						else
						{
			                switch (event.keyCode) {
								case Keyboard.UP:
								case Keyboard.PAGE_UP:
									selectedIndex --;
									break;
								
								case Keyboard.PAGE_DOWN:
								case Keyboard.DOWN:
									selectedIndex ++;
									break;
									
								case Keyboard.HOME:
									selectedIndex = 0;
									break;
									
								case Keyboard.END:
									selectedIndex = _dropdown.dataProvider.length - 1;
									break;
								
								default:
									selectedIndex = 0;
								
								
								event.stopPropagation();
								
							}
						}
					}
		           
	               bInKeyDown = false;
            	}
            	
            	//otherwise display the dropdown 
            	else
            	{
            		open();
            		event.stopPropagation();
            	}
                
            }
        }
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
	
	/**
     *  @private
     */
    private function dropdown_mouseDownOutsideHandler(event:MouseEvent):void
    {
        if (!_showingDropdown) { return; }
			
		if (! contains(event.target as DisplayObject) && !dropdown.contains(event.target as DisplayObject)) 
				
		{  
			close(event, false);
		}
    }
	/**
     * @private
     * Remove the dropdown if the app is resized
     */
    private function stage_resizeHandler(event:Event):void
    {
        if (_dropdown)
        {
            close(null, false);
            _showingDropdown = false;
        }
    } 
    /**
     *  @private
     */
    private function dropdown_scrollHandler(event:Event):void
    {
        // TextField.scroll bubbles so you might see it here
        if (event is ScrollEvent)
        {
            var se:ScrollEvent = ScrollEvent(event);
            dispatchEvent(se);
        }
    }
    /**
     *  @private
     */
    private function dropdown_itemRollOverHandler(event:Event):void
    {
        dispatchEvent(event);
    }
    /**
     *  @private
     */
    private function dropdown_itemRollOutHandler(event:Event):void
    {
        dispatchEvent(event);
    }
    /**
     *  @private
     */
    private function dropdown_changeHandler(event:Event):void
    {
        var prevValue:int = selectedIndex;
        // This assignment will also assign the label to the text field.
        if (_dropdown)
            selectedIndex = _dropdown.selectedIndex;
        // If this was generated by the dropdown as a result of a keystroke, it is
        // likely a Page-Up or Page-Down, or Arrow-Up or Arrow-Down.
        // If the selection changes due to a keystroke,
        // we leave the dropdown displayed.
        // If it changes as a result of a mouse selection,
        // we close the dropdown.
        if (!_showingDropdown)
            dispatchChangeEvent(event, prevValue, selectedIndex);
        else if (!bInKeyDown)
        {
            // this will also send a change event if needed
            close(event, false);
			
        }
    }
    
    /**
     *  @private
     *  This acts as the destructor.
     */
    private function unloadHandler(event:Event):void
    {
       inTween = false;
        if (_dropdown)
            removeChild(_dropdown);
    }
    /**
     *  @private
     * Closes the dropdown
     */
    private function onTweenEnd(value:Number):void
    {
        if (_dropdown)
        {
            _dropdown.alpha = 1;
            inTween = false;
            _dropdown.visible = _showingDropdown;
        }
    }
	/**
     * @private (protected)
     * @inheritDoc
	 */
	override protected function initializeAccessibility():void {
		if (AutoComplete.createAccessibilityImplementation != null) {
			AutoComplete.createAccessibilityImplementation(this);
		}
	}
	
}



}
