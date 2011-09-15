/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.managers {	import flash.display.DisplayObject;	import flash.events.MouseEvent;		
	/**	 * Methods expected to be defined by <code>FormDataManager</code>.	 *  @author kayoh	 */	public interface IFormDataManager {		/**		 * Registers items from the FormDataManager 		 */ 
		function addItem(id : String,source : Object, property : Object = null , required : Boolean = false , validation : Function = null, validatorExtraParam : Object = null,eventTargetObj : DisplayObject = null,functionValidationPassed : Function = null,functionValidationFailed : Function = null, errorString : String = null) : void;		/**		 * Unregisters items from the FormDataManager 		 */		function removeItem(id : String) : void;		/**		 * Starts collecting and validating data.		 */
		function collectData(e : MouseEvent = null) : void;		/** 		 * Registers a button(DisplayObject) to trigger <code>collectData</code> by MouseEvent.CLICK event.		 * Also sets <code>functionDataCollectionSuccess</code> and <code>functionDataCollectionFail</code> to be triggered when <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> or <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code> happens.		 */
		function addTrigger(button : DisplayObject, functionDataCollectionSuccess : Function = null, functionDataCollectionFail : Function = null) : void;		/**		 * Unregisters a button(DisplayObject calling <code>collectData</code>).		 */
		function removeTrigger(button : DisplayObject) : void;	}}