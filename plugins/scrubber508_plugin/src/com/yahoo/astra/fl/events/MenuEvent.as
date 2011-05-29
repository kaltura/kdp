/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.events
{
import com.yahoo.astra.fl.controls.Menu;
//import com.yahoo.astra.fl.controls.MenuBar;
import com.yahoo.astra.fl.*;
import flash.events.Event;
import fl.events.ListEvent;
import fl.controls.listClasses.*;
/**
 *  The MenuEvent class represents events that are associated with menu activities. 
 *
 *  @see com.yahoo.astra.fl.controls.Menu
 */
public class MenuEvent extends ListEvent
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    /**
     *  The MenuEvent.CHANGE event type constant indicates that selection
     *  changed as a result of user interaction.
     *
     *  @eventType change
     */
    public static const CHANGE:String = "change";
    /**
     *  The MenuEvent.ITEM_CLICK event type constant indicates that the
     *  user selected a menu item.
     *
     *  @eventType itemClick
     */
    public static const ITEM_CLICK:String = "itemClick";
    /**
     *  The MenuEvent.MENU_HIDE event type constant indicates that
     *  a menu or submenu closed.
     *
     *  @eventType menuHide
     */
     public static const MENU_HIDE:String = "menuHide";
    /**
     *  The MenuEvent.ITEM_ROLL_OUT type constant indicates that
     *  the mouse pointer rolled out of a menu item.
     *
     *  @eventType itemRollOut
     */
    public static const ITEM_ROLL_OUT:String = "itemRollOut";
    /**
     *  The MenuEvent.ITEM_ROLL_OVER type constant indicates that
     *  the mouse pointer rolled over a menu item.
     *  @eventType itemRollOver
     */
    public static const ITEM_ROLL_OVER:String = "itemRollOver";
    /**
     *  The MenuEvent.MENU_SHOW type constant indicates that
     *  the mouse pointer rolled a menu or submenu opened.
     *
     *  @eventType menuShow
     */
    public static const MENU_SHOW:String = "menuShow";
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     * 
     *  Normally called by the Menu object. 
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *  @param menu The specific Menu instance associated with the event,
     *  such as the menu or submenu that was hidden or opened. This property
     *  is null if a MenuBar item dispatches the event. 
     *
     *  @param item The item in the dataProvider of the assicated menu item.
     *
     *  @param itemRenderer The ListItemRenderer of the associated menu item.
     * 
     *  @param label The label text of the associated menu item.
     * 
     *  @param index The index in the menu of the associated menu item. 
     */
    public function MenuEvent(type:String, bubbles:Boolean = false,
                              cancelable:Boolean = true,
                              menuBar:Object = null, menu:Menu = null,
                              item:Object = null,
                              itemRenderer:CellRenderer = null,
                              label:String = null, index:int = -1)
    {
        super(type, bubbles, cancelable);
        //this.menuBar = menuBar;
        this.menu = menu;
        this._item = item;
        //this.itemRenderer = itemRenderer;
        this.label = label;
        this._index = index;
    }
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
   
    //----------------------------------
    //  label
    //----------------------------------
    /**
     *  The label text of the associated menu item.
     *  This is null for the menuShow and menuHide events. 
     */
    public var label:String;
    //----------------------------------
    //  menu
    //----------------------------------
    /**
     *  The specific Menu instance associated with the event,
     *  such as the menu or submenu that was hidden or opened.
     *  
     *  This property is null if a MenuBar item is dispatching
     *  the event. 
     */
    public var menu:Menu;
    //----------------------------------
    //  menuBar
    //----------------------------------
    /**
     *  The MenuBar instance that is the parent of the selected Menu control,
     *  or null when the target Menu control is not parented by a
     *  MenuBar control.
     */
    //public var menuBar:MenuBar;
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     */
    override public function clone():Event
    {
        return new MenuEvent(type, bubbles, cancelable,
                             null, menu, _item, null, label, index);
    }
	
		/**
		 * Returns a string that contains all the properties of the MenuEvent object. 
         * @return A string representation of the MenuEvent object.
         *
         */
		override public function toString():String {
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", 
								  //"menuBar", 
								  "menu", "item", 
								  //"itemRenderer", 
								  "label", "index");
		}
		
}
}
