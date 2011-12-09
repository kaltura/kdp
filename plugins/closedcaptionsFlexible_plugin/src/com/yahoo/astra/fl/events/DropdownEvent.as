/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.events
{
import flash.events.Event
/**
 *  The DropdownEvent class represents the event object passed to 
 *  the event listener for the <code>open</code> and <code>close</code> events.
 * @author Alaric Cole
 */
public class DropdownEvent extends Event
{
   
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	/**
	 *  The <code>DropdownEvent.CLOSE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>close</code> event.
	 *
	 *
     *  @eventType close
	 */
	public static const CLOSE:String = "close";
	
	/**
	 *  The <code>DropdownEvent.OPEN</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>open</code> event.
	 *
     *  @eventType open
	 */
	public static const OPEN:String = "open";
	
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
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 *
	 *  @param triggerEvent A value indicating the 
     *  type of input action that triggered the event
	 */
	public function DropdownEvent(type:String, bubbles:Boolean = false,
                                  cancelable:Boolean = false,
                                  triggerEvent:Event = null)
	{
		super(type, bubbles, cancelable);
		this.triggerEvent = triggerEvent;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  If the control is opened or closed in response to a user action, 
	 *  this property contains a value indicating the type of input action. 
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
		return new DropdownEvent(type, bubbles, cancelable, triggerEvent);
	}
}
}
