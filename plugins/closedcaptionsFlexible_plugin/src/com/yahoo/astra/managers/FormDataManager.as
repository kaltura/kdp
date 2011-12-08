/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿﻿package com.yahoo.astra.managers {
	import com.yahoo.astra.containers.formClasses.FormItem;	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;	import com.yahoo.astra.events.FormDataManagerEvent;	import com.yahoo.astra.utils.IValueParser;	import com.yahoo.astra.utils.ValueParser;	import flash.display.DisplayObject;	import flash.events.EventDispatcher;	import flash.events.MouseEvent;			/**
	 * Collects user input data and validate it before you submit the data to the server. 
	 * Astra does not provide a separate validation class, but there are compatible validation classes available from Adobe. 
	 * Another option for the validation is the mx.validators distributed in the Flex SDK. For convenient use of Flex validators, you can use the Astra <code>MXValidatorHelper</code> class. 
	 * Flex MXvalidator provides a variety of validation types and detailed error messages. However, the use of the MXvalidator will increase your overall file size by approximately 20K.
	 * @example The following code shows a use of <code>FormDataManager</code>:	 *	<listing version="3.0">	 *  	import fl.controls.Button;	 *  	import fl.controls.TextInput;	 *  	import com.adobe.as3Validators.as3DataValidation;	 *  	import com.yahoo.astra.containers.formClasses.FormItem;	 *  	import com.yahoo.astra.events.FormDataManagerEvent;	 *  	import com.yahoo.astra.fl.utils.FlValueParser;	 *  	import com.yahoo.astra.managers.FormDataManager;	 *  		 *  	// Make sure that you have TextInput and Button component in your library	 *  	var nameTextInput:TextInput = new TextInput();	 *  	var nameFormItem : FormItem = new FormItem("Name", nameTextInput);	 *  	this.addChild(nameFormItem);	 *  		 *  	var emailTextInput : TextInput = new TextInput();	 *  	var emailFormItem : FormItem = new FormItem("Email", emailTextInput);	 *  	emailFormItem.required = true;	 *  	emailFormItem.y = 30;	 *  	this.addChild(emailFormItem);	 *  		 *  	var submitButton : Button = new Button();	 *  	submitButton.label="SUBMIT";	 *  	submitButton.y = 60;	 *  	this.addChild(submitButton);	 *  		 *  	// Init FormDataManager with FlValueParser.	 *  	var formDataManager : FormDataManager = new FormDataManager(FlValueParser);	 *  	formDataManager.functionValidationPassed = handlerValidationPassed;	 *  	formDataManager.functionValidationFailed = handlerValidationFailed;	 *  	formDataManager.addTrigger(submitButton, handlerDataCollectionSuccess, handlerDataCollectionFail);	 *  		 *  	var validator : as3DataValidation = new as3DataValidation();	 *  	formDataManager.dataSource = [{ id: "name", source:nameTextInput},	 *		 { id:"email", source:emailTextInput, required:true, validator:validator.isEmail, eventTargetObj:emailFormItem }];	 *  		 *  	// This will be called when eventTargetObj receives FormDataManagerEvent.VALIDATION_PASSED	 *  	function handlerValidationPassed(e : FormDataManagerEvent):void {	 *  		trace("required collectedData:", e.collectedData.toString());	 *  		if (e.target is FormItem) {	 *  		// If the eventTargetObj is FormItem, hide the requiredIndicator(.	 *  			var formItemRequiredIndicator : DisplayObject = (e.target as FormItem).requiredIndicator;	 *  			if (formItemRequiredIndicator) formItemRequiredIndicator.visible = false;	 *  		}	 *  	}	 *  		 *  	// This will be called when eventTargetObj receives FormDataManagerEvent.VALIDATION_FAILED	 *  	function handlerValidationFailed(e : FormDataManagerEvent):void {	 *  		trace("required errorMessage:", e.errorMessage.toString());	 *  		if (e.target is FormItem) {	 *  		// If the eventTargetObj is FormItem, show the requiredIndicator(.	 *  			var formItemRequiredIndicator : DisplayObject = (e.target as FormItem).requiredIndicator;	 *  		if (formItemRequiredIndicator) formItemRequiredIndicator.visible = true;	 *  		}	 *  	}	 *  	// Below will be called when all the required fields are passed validation(FormDataManagerEvent.DATACOLLECTION_SUCCESS).	 *  	function handlerDataCollectionSuccess(e : FormDataManagerEvent) {	 *  		for (var i:String in FormDataManager.collectedData) {	 *  			trace("SUCCESS ",i + " : " + FormDataManager.collectedData[i] + "\n");	 *  			// "SUCCESS ", email : address&#64;yahoo.com  	 *  		}	 *  	}	 *  	// Below will be called when there is any invalid required field(FormDataManagerEvent.DATACOLLECTION_FAIL).	 *  	function handlerDataCollectionFail(e : FormDataManagerEvent) {	 *  		for (var i:String in FormDataManager.failedData) {	 *  			trace("FAIL ",i + " :: " + FormDataManager.failedData[i] + "\n");	 *  			// "FAIL ", email : Missing an &#64; character in your email address.  	 *  		}	 *  	}	 *	</listing>	 * 
	 * @see com.yahoo.astra.utils.ValueParser	 * @see com.yahoo.astra.fl.utils.FlValueParser
	 * @see com.yahoo.astra.utils.MXValidationHelper
	 * @see http://code.google.com/p/flash-validators
	 * @author kayoh  
	 */
	public class FormDataManager extends EventDispatcher implements IFormDataManager {
		//--------------------------------------
		// Constructor
		//--------------------------------------
		/**
		 * Constructor.		 * 		 * @param customValuePaser IValuePaser Class. If there is no defined <code>customValuePaser</code>, <code>com.yahoo.astra.utils.ValuePaser</code> will be used to strip input data.
		 */
		public function FormDataManager(customValuePaser : Class = null) {
			valueParser = (customValuePaser) ? customValuePaser : ValueParser;
			managerArray = [];
		}
		//--------------------------------------
		// Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var valueParser : Class = null;
		/**
		 * @private
		 */
		private var managerArray : Array = [];
		/**
		 * @private
		 */
		private var validFunction : Function = null;
		/**
		 * @private
		 */
		private var inValidFunction : Function = null;
		/**		 * @private
		 */
		private var idToRemove : String ;
		/**
		 * @private		 */		private var _functionValidationPassed : Function = null;
		/**
		 * Sets the method to be called as a handler function, when validation is success(FormDataManagerEvent.VALIDATION_PASSED).
		 */
		public  function get functionValidationPassed() : Function {
			return _functionValidationPassed;
		}
		/**
		 * @private
		 */
		public  function set functionValidationPassed(value : Function) : void {
			_functionValidationPassed = value;
		}
		/**
		 * @private
		 */
		private var _functionValidationFailed : Function = null;
		/**
		 * Gets and sets the method to be called as a handler function, when validation is failed(FormDataManagerEvent.VALIDATION_FAILED).
		 */
		public  function get functionValidationFailed() : Function {
			return _functionValidationFailed;
		}
		/**
		 * @private
		 */
		public  function set functionValidationFailed(value : Function) : void {
			_functionValidationFailed = value;
		}
		/**
		 * @private
		 */
		private var _errorString : String = FormLayoutStyle.DEFAULT_ERROR_STRING;
		/**
		 * Gets and sets the text representing error.
		 * 
		 * @default "Invalid input"
		 */
		public  function get errorString() : String {
			return _errorString;
		}
		/**
		 * @private
		 */
		public  function set errorString(value : String) : void {
			_errorString = value;
		}
		/**
		 * @private
		 */
		private static var _collectedData : Object;
		/**
		 * Collection of form input data variables object array. 
		 * The <code>"id"</code> will be the key and the user input from the <code>"source"</code> will be value of the array.(e.g. collectedData["zip"] = "94089")
		 * You can loop over each value within the <code>collectedData</code> object instance by using a for..in loop.
		 * 
		 * @example The following code configures shows usage of <code>collectedData</code>:
		 * <listing version="3.0">		 *	for (var i:String in FormDataManager.collectedData) {  
		 *		trace( i + " : " + FormDataManager.collectedData[i] + "\n");  
		 *	}
		 *	// state : CA
		 *	// zip :  94089
		 * </listing>
		 * 
		 */
		public static function get collectedData() : Object {
			return _collectedData;
		}
		/**
		 * @private
		 */
		public static function set collectedData(value : Object) : void {
			_collectedData = value;
		}
		/**
		 * @private
		 */
		private static var _failedData : Object = null;
		/**
		 * Collection of error messages object array. 
		 * Any error string from validation or default <code>errorString</code> will be collected as a object array with <code>"id"</code> as a key and the message as value.
		 * 
		 *  * @example The following code configures shows usage of <code>failedData</code>:
		 * <listing version="3.0">		 *	for (var i:String in FormDataManager.failedData) {  
		 *		trace( i + " : " + FormDataManager.failedData[i] + "\n");  
		 *	}
		 *	// zip : Unkown Zip type.
		 *	// email : The email address contains invalid characters.
		 * </listing>
		 */
		public static function get failedData() : Object {
			return _failedData;
		}
		/**
		 * @private
		 */
		public static function set failedData(value : Object) : void {
			_failedData = value;
		}
		/**		 * @private		 */		private var _dataSource : Object = null;
		/**		 * Gets or sets the data to be shown and validated in <code>Form</code>. 		 * <code>id</code>and <code>source</code> are required.		 * 		 * <p><strong>Property Options:</strong></p>		 * <dl>		 * 	<dt><strong><code>id</code></strong> : String(or an Array of String)</dt>		 * 		<dd>The property of collected data.(e.g. id:"zip"  will be saved in FormDataManager as <code>FormDataManager.collectedData</code>["zip"] = "94089")</dd>		 * 	<dt><strong><code>source</code></strong> : Object(or Object Array)</dt>		 * 		<dd>The actual input source contains user input data.(e.g. source:stateComboBox  or  source:[stateComboBox, zipcodeInput])</dd>		 * 	<dt><strong><code>property</code></strong> : Object(or Object Array)</dt>		 * 		<dd>The additional property of <code>source</code>. If you defined <code>valuePaser</code> of FormDataManager as <code>FlValueParser</code>, don't need to set this property in general(e.g. source:[comboBox, textInput] , property:["abbreviation","text"]</dd>		 * 	<dt><strong><code>validator</code></strong> : Function(or Function Array)</dt>		 * 		<dd>The Function to validate the <code>source</code>.(e.g.  validator:validator.isZip)</dd>		 * 	<dt><strong><code>validatorExtraParam</code></strong> : Object(or Object Array)</dt>		 * 		<dd>The additional parameter of the <code>validator</code>.(e.g. validator:validator.isIntegerInRange, validatorExtraParam:[1, 20])</dd>		 * 	<dt><strong><code>required</code></strong> : Boolean(or Boolean Array)</dt>		 * 		<dd>The Boolean to decide to show required filed indicator(~~) and apply validation(<code>validator</code>).(e.g. id:["stateComboBox", "zipcodeInput"], required:[false, true]) </dd>		 * 	<dt><strong><code>errorString</code></strong> : String</dt>		 * 		<dd>The String to show under the item(s) fail to validation when <code>showErrorMessageText</code> is set <code>true</code>. If there is existing <code>instructionText</code>, will be replaced by <code>errorString</code>.(e.g. errorString:"What kind of zipcode is that?.")</dd>		 * 	<dt><strong><code>targetObj</code></strong> : DisplayObject</dt>		 * 		<dd>The DisplayObject to listen <code>FormDataManagerEvent</code> type of <code>FormDataManagerEvent.VALIDATION_PASSED</code> and <code>FormDataManagerEvent.VALIDATION_FAILED</code></dd>		 * 	<dt><strong><code>functionValidationPassed</code></strong> : Function</dt>		 * 		<dd>The Function to be triggered for <code>FormDataManagerEvent</code> type of <code>FormDataManagerEvent.VALIDATION_PASSED</code></dd>		 * 	<dt><strong><code>functionValidationFailed</code></strong> : Function</dt>		 * 		<dd>The Function to be triggered for <code>FormDataManagerEvent</code> type of <code>FormDataManagerEvent.VALIDATION_FAILED</code></dd>			 * </dl>		 * 		 * @example The following code shows a use of <code>dataSource</code>:		 *  <listing version="3.0">		 *	formDataManager.dataSource = [		 *		{id:"firstname", source:firstNameInput, validator:validator.isNotEmpty, required:true},		 *		{id:"email", source:emailInput},		 *		{id:"emailformat", source:radioGroup},		 *		{id:"zipcode", source:zipcodeInput, validator:validator.isZip, required:true, eventTargetObj:zipcodeInput, functionValidationPassed:handlerZipPassed, functionValidationFailed:handlerZipFailed} ];		 *			 *	function handlerZipPassed(e:FormDataManagerEvent) { trace("zipcode:"+e.collectedData) } ;		 *	function handlerZipFailed(e:FormDataManagerEvent) { trace("zipcode Error:"+e.errorMessage) } ;		 * </listing>		 * 		 */		public function get dataSource() : Object {
			return this._dataSource;
		}
		/**
		 * @private
		 */
		public function set dataSource(value : Object) : void {
			this._dataSource = value;
			buildFromDataSource();
		}
						//--------------------------------------
		//  Public Methods
		//--------------------------------------
				/**		 * <p>Registers items into the FormDataManager with it's properties.		 * Since FormDataManager collects and saves data as form of associative arrays, "id" will be used as a property of the array. (e.g. collectedData["zip"] = "94089")</p>		 * <code>id</code>and <code>source</code> are mandatory. 		 * 		 * @param id String to be a property of the data array(collectedData or failedData)		 * @param source Object contains form input.		 * @param property Object property of the <code>source</code>.		 * @param required Boolean determinds to be validated or not.		 * @param validation Function to be used for validation of the <code>source</code>. 		 * @param validatorExtraParam Object extra parameter(beside the first parameter) of the validation.		 * @param eventTargetObj DisplayObject to be listen <code>FormDataManagerEvent</code> (<code>FormDataManagerEvent.VALIDATION_PASSED</code> and <code>FormDataManagerEvent.VALIDATION_FAILED</code>)		 * @param functionValidationPassed Function Object to be triggered when <code>eventTargetObj</code> gets <code>FormDataManagerEvent.VALIDATION_PASSED</code> event.		 * @param functionValidationFailed Function Object to be triggered when <code>eventTargetObj</code> gets <code>FormDataManagerEvent.VALIDATION_FAILED</code> event.		 */
		public function addItem(id : String, source : Object, property : Object = null , required : Boolean = false , validation : Function = null, validatorExtraParam : Object = null,eventTargetObj : DisplayObject = null,functionValidationPassed : Function = null,functionValidationFailed : Function = null, errorString : String = null) : void {
			var valueParserObject : * = new valueParser();
			var valueParser : IValueParser = ( valueParserObject is IValueParser) ? valueParserObject : new ValueParser();			managerArray.push({id:id, value : valueParser.setValue(source, property), validation:validation, validatorExtraParam:validatorExtraParam, required:required, eventTargetObj:eventTargetObj, errorString:errorString});
			if(eventTargetObj ) {
				var handlerSuccessFunction : Function = (functionValidationPassed is Function) ? functionValidationPassed : this.functionValidationPassed;
				var handlerFailFunction : Function = (functionValidationFailed is Function) ? functionValidationFailed : this.functionValidationFailed;
				if(handlerSuccessFunction is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_PASSED, handlerSuccessFunction);
				if(handlerFailFunction is Function) eventTargetObj.addEventListener(FormDataManagerEvent.VALIDATION_FAILED, handlerFailFunction);
			}
		}	
		/**		 * Unregisters items from the FormDataManager 		 * 		 * @param id String		 */		public  function removeItem(id : String) : void {			if(!managerArray) return;			idToRemove = id;			managerArray = managerArray.filter(removeFromArray);		}
		/**
		 * Starts collecting and validating data.		 * If there is registered trigger(<code>addTrigger</code>), this function will be called by <code>MouseEvent.CLICK</code> event of the button.		 * 
		 * @param e MouseEvent		 */
		public function collectData(e : MouseEvent = null) : void {			var arrLeng : Number = managerArray.length;
			FormDataManager.collectedData = FormDataManager.failedData = null;
			FormDataManager.collectedData = {};	
			FormDataManager.failedData = {};	
			var passedBool : Boolean = true;
			
			for (var j : Number = 0;j < arrLeng; j++) {
				if(managerArray[j].eventTargetObj is FormItem) {
					var curFormItme : FormItem = managerArray[j].eventTargetObj as FormItem;
					curFormItme.gotResultBool = true;
				}
			}						
			for (var i : Number = 0;i < arrLeng; i++) {				var result : Boolean = validateAndStore(managerArray[i].id, managerArray[i].value, managerArray[i].validation, managerArray[i].validatorExtraParam, managerArray[i].required, managerArray[i].eventTargetObj, managerArray[i].errorString);
				passedBool &&= result;
			}	
			
			(passedBool) ? this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_SUCCESS, false, false, null, FormDataManager.collectedData)) : this.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.DATACOLLECTION_FAIL, false, false, FormDataManager.failedData, collectedData));
		}
		/**
		 * Registers a button(DisplayObject) to trigger <code>collectData</code> by MouseEvent.CLICK event.
		 * Also sets <code>functionDataCollectionSuccess</code> and <code>functionDataCollectionFail</code> to be triggered when <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> or <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code> happens.
		 * 
		 * @param button DisplayObject button to be clicked.		 * @param functionDataCollectionSuccess Function to be triggered when all the forms passed validation(<code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code>)		 * @param functionDataCollectionFail Function to be triggered when any the forms failed validation(<code>FormDataManagerEvent.DATACOLLECTION_FAIL</code>)
		 */
		public function addTrigger(button : DisplayObject, functionDataCollectionSuccess : Function = null, functionDataCollectionFail : Function = null) : void {
			if(functionDataCollectionSuccess is Function) { 
				validFunction = functionDataCollectionSuccess;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_SUCCESS, functionDataCollectionSuccess);
			}
			if(functionDataCollectionFail is Function) { 
				inValidFunction = functionDataCollectionFail;
				this.addEventListener(FormDataManagerEvent.DATACOLLECTION_FAIL, functionDataCollectionFail);
			}
			if(button is DisplayObject) {
				button.addEventListener(MouseEvent.CLICK, collectData);
			}
		}
		/**		 * Unregisters the button(DisplayObject calling <code>collectData</code>).		 * Also removes FormDataManagerEvent listeners : <code>FormDataManagerEvent.DATACOLLECTION_SUCCESS</code> and <code>FormDataManagerEvent.DATACOLLECTION_FAIL</code>.		 * @param button DisplayObject		 */		public function removeTrigger(button : DisplayObject) : void {			if(button) button.removeEventListener(MouseEvent.CLICK, collectData);			if(validFunction is Function) this.removeEventListener(FormDataManagerEvent.DATACOLLECTION_SUCCESS, validFunction);			if(inValidFunction is Function) this.removeEventListener(FormDataManagerEvent.DATACOLLECTION_FAIL, inValidFunction);		}
		//--------------------------------------		//  Private Methods		//--------------------------------------				/**		 * @private		 */		private function removeFromArray(element : *, index : int, arr : Array) : Boolean {			return (element.id.toString() != idToRemove);		}
		/**		 * @private		 */		private function buildFromDataSource() : void {						var dataLength : int = dataSource.length;						for (var i : int = 0;i < dataLength; i++) {				var curData : Object = dataSource[i];				/*				 * no Id, no collection				 */				var curId : String = curData["id"] as String;				var curSource : Object = curData["source"] as Object;				if(!curId || !curSource) {					throw new Error("id and source are needed."); 					continue;				} else {					addItem( curId, curSource, curData["property"], curData["required"], curData["validator"], curData["validatorExtraParam"], curData["eventTargetObj"], curData["functionValidationPassed"], curData["functionValidationFailed"], curData["errorString"]);					}			}		}
		/**		 * @private		 */		private function validateAndStore(id : String , value : Object , validation : Function = null, validatorExtraParam : Object = null,required : Boolean = false,eventTargetObj : DisplayObject = null, errorString : String = null) : Boolean {			var curErrStr : String = this.errorString;						if(value == null) {				if(required) {					FormDataManager.failedData[id] = curErrStr; 					if(eventTargetObj) eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_FAILED, false, false, curErrStr));					return false;				}				// prevent storing null.				FormDataManager.collectedData[id] = "";				if(eventTargetObj)eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_PASSED, false, false, null, value));				return true;			}						if(value is Function) {				var func : Function = value as Function;				value = func();			}      			var tempResult : Boolean = true;			if(validation != null && value != null) { 				var validationResult : Object;				if(validatorExtraParam is Array) {					var arrLeng : int = validatorExtraParam.length;					switch(arrLeng) {						case 1:							validationResult = validation(value, validatorExtraParam[0]);							break;													case 2:							validationResult = validation(value, validatorExtraParam[0], validatorExtraParam[1]);							break;													default:							validationResult = validation(value, validatorExtraParam[0], validatorExtraParam[1], validatorExtraParam[2]);							break;					}				} else {					validationResult = (validatorExtraParam) ? validation(value, validatorExtraParam) : validation(value);				}							if(required) {					tempResult = false;					//ADOBE Validator result					if(validationResult is Boolean ) {						if(validationResult) tempResult = true;					} else {						//MX Validator result						if(validationResult is Array) {							if(validationResult.length > 0) {								//trace(validationResult[0] ["subField"], validationResult[0] ["errorCode"], validationResult[0] ["isError"])								var errMsg : String = validationResult[0].errorMessage;								var subField : String = validationResult[0].subField;								if(errMsg) curErrStr = (subField) ? subField + errMsg : errMsg;							} else {								tempResult = true;							} 						}						//ADOBE Validator result						if(validationResult.errorStr) curErrStr = validationResult.errorStr;						if(validationResult.result) tempResult = true; 					}				}			}			if(errorString) curErrStr = errorString;			if(eventTargetObj is FormItem) {				var formItem : FormItem = eventTargetObj as FormItem;				if(formItem.errorString != FormLayoutStyle.DEFAULT_ERROR_STRING) curErrStr = formItem.errorString;			}			if(tempResult) {				FormDataManager.collectedData[id] = value;				if(eventTargetObj)eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_PASSED, false, false, null, value));				return true;			} else {				FormDataManager.failedData[id] = curErrStr; 				if(eventTargetObj) eventTargetObj.dispatchEvent(new FormDataManagerEvent(FormDataManagerEvent.VALIDATION_FAILED, false, false, curErrStr));				return false;			}		}	}}