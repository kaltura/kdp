/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 *  A utility for dealing with popups
	 * @author Alaric Cole
	 *
	 */
	public class PopUpManager
	{
	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    /**
     *  Pops up a top-level display object.
     * 
     *  @param popUp The DisplayObject to be popped up.
     *
     *  @param parent DisplayObject to pop up above.
     *
     */
    public static function addPopUp(popUp:DisplayObject, parent:DisplayObjectContainer):void
    {
    	parent.addChild(popUp);
    }
    
     /**
     *  Removes a popup window popped up by 
     *  the <code>addPopUp()</code> method.
     *  
     *  @param popUp The DisplayObject representing the popup window.
     */
    public static function removePopUp(popUp:DisplayObject):void
    {
		popUp.parent.removeChild(popUp);
    }
	}
}