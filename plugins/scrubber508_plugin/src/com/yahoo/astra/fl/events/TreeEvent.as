/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.events
{

import fl.controls.listClasses.ICellRenderer;

import flash.events.Event;

/**
 *  For events that are associated with activities
 *  in tree, such as when a tree branch opens or closes.
 *
 */
public class TreeEvent extends Event
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The TreeEvent.ITEM_CLOSE event type constant indicates that a tree
     *  branch closed or collapsed.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer for the node that closed</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>item</code></td><td>the Tree item (node) that closed</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>TreeEvent.ITEM_CLOSE</td></tr>
     *  </table>
     *
     *  @eventType itemClose
     */
    public static const ITEM_CLOSE:String = "itemClose";

    /**
     *  The TreeEvent.ITEM_OPEN event type constant indicates that a tree
     *  branch opened or expanded.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer for the item (node) that opened</td></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the item (node) opened in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>item</code></td><td>the Tree node that opened.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>TreeEvent.ITEM_OPEN</td></tr>
     *  </table>
     *
     *  @eventType itemOpen
     */
    public static const ITEM_OPEN:String = "itemOpen";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior associated with the event
     *  can be prevented.
     *
     *  @param item The Tree node (item) to which this event applies.
     *
     *  @param itemRenderer The item renderer object for the cell.
     *
     *  @param triggerEvent If the node opened or closed in response to a
     *  user action, indicates the type of input action.
     */
    public function TreeEvent(type:String, bubbles:Boolean = false,
                              cancelable:Boolean = false,
                              item:Object = null,
                              itemRenderer:ICellRenderer = null,
                              triggerEvent:Event = null)
    {
        super(type, bubbles, cancelable);

        this.item = item;
        this.itemRenderer = itemRenderer;
        this.triggerEvent = triggerEvent;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  item
    //----------------------------------

    /**
     *  Storage for the item property.
     */
    public var item:Object;

    //----------------------------------
    //  itemRenderer
    //----------------------------------

    /**
     *  The CellRenderer for the node that closed or opened.
     */
    public var itemRenderer:ICellRenderer;

 
    //----------------------------------
    //  triggerEvent
    //----------------------------------

    /**
     *  The low level MouseEvent or KeyboardEvent that triggered this
     *  event or <code>null</code> if this event was triggered programatically.
     */
    public var triggerEvent:Event;

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
        return new TreeEvent(type, bubbles, cancelable,
                             item, itemRenderer, triggerEvent);
    }
}

}
