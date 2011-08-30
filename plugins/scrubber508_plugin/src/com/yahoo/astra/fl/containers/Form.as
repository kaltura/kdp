/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.containers {
	import fl.core.UIComponent;

	import com.yahoo.astra.containers.formClasses.FormEventObserver;
	import com.yahoo.astra.containers.formClasses.FormItem;
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.containers.formClasses.IFormEventObserver;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.fl.containers.BoxPane;
	import com.yahoo.astra.fl.containers.layoutClasses.BaseLayoutPane;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.modes.BoxLayout;
	import com.yahoo.astra.managers.IFormDataManager;
	import com.yahoo.astra.utils.NumberUtil;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	//--------------------------------------
	//  Style
	//--------------------------------------
	/**
	 * 
	 * The skin of required field indicator's skin.
	 *
	 * @default indicatorSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="indicatorSkin", type="Class")]

	/**
	 * 
	 * The TextFormat object to use to render the instructionText fields in the Form.
	 * @default TextFormat("_sans", 10, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0).
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="instructionTextFormat", type="flash.text.TextFormat")]

	/**
	 * 
	 * The TextFormat object to use to render the formHeading field in the Form in the Form.
	 * @default TextFormat("_sans", 11, 0x000000, bold, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0).
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="headTextFormat", type="flash.text.TextFormat")]

	/**
	 * Color Object of error box Sprite(<code>showErrorMessageBox = true</code>) in the Form.
	 * @default Color 0x666666;
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="errorBoxColor", type="Object")]

	/**
	 * 
	 * Alpha value of error box Sprite(<code>showErrorMessageBox = true</code>) in the Form.
	 * @default .2
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="errorBoxAlpha", type="Number")]

	/**
	 * 
	 *	The Form is a layout element containing multiple component items arranged vertically along with the definition for each items. 
	 *	Similar to the <a href="http://livedocs.adobe.com/flex/3/html/help.html?content=layouts_08.html" target="_blank">Flex Form</a> container, 
	 *	it is mainly used with nested <code>FormItem</code>s which are containers defined by a label and one or more children arranged horizontally or vertically. 
	 *	
	 * @example The following code shows a simple use of <code>Form</code>:
	 *  <listing version="3.0">
	 *  
	 *	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	 *	import com.yahoo.astra.fl.containers.Form;
	 *	import fl.controls.TextInput;  
	 *	import fl.controls.TextArea;  
	 *	import fl.controls.Button; 
	 *	
	 *	// Init input fields.  
	 *	// Make sure that you have Form component and UIcomponents(TextInput,TextArea,Button) in your library.  
	 *	var nameInput:TextInput = new TextInput();  
	 *	var emailInput:TextInput = new TextInput();  
	 *	var commentInput:TextArea = new TextArea();  
	 *	nameInput.width = emailInput.width = commentInput.width = 200;
	 *	var submitButton:Button = new Button();  
	 *	submitButton.label = "SUBMIT";  
	 * 
	 *	var myForm:Form = new Form("Contact Us");
	 *	// additional parameters for Form
	 *	myForm.autoSize = true;
	 *	myForm.indicatorLocation = FormLayoutStyle.INDICATOR_LEFT;
	 *	myForm.verticalGap = 10;
	 *	
	 *	var myFormDataArr : Array = [
	 *		{label:"Name", items:nameInput},
	 *		{label:"Email", items:emailInput},
	 *		{label:"Message", items:commentInput,required:true},
	 *		{label:"", items:submitButton}];
	 * 
	 *	// define dataSource with data array.	
	 *	myForm.dataSource = myFormDataArr;
	 *	
	 *	this.addChild(myForm);  
	 *	</listing>
	 *	
	 * @see http://developer.yahoo.com/flash/astra-flash/form
	 * @see http://livedocs.adobe.com/flex/3/html/help.html?content=layouts_08.html
	 * @see com.yahoo.astra.containers.formClasses.FormItem
	 * @see com.yahoo.astra.managers.FormDataManager 
	 * @author kayoh
	 */
	public class Form extends VBoxPane implements IForm {

		//--------------------------------------
		//  Constructor
		//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param formHeadingString		String for optional text field of <code>"FormHeading"</code>.
		 */
		public function Form(formHeadingString : String = null) {
			super();
			
			formItemArr = [];
			
			//EventObserver to dispatch/listen event from Form class.
			formEventObserver = new FormEventObserver();
			subscribeObserver(formEventObserver);
				
			if(formHeadingString && !headFormItem) attachFormHeadingLabel(formHeadingString);
			
			//Will show Form when the container settled right size.
			this.visible = false;
			this.addEventListener(Event.ENTER_FRAME, handler_enterFrame, false, 0, true);
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var temp_adjusting_height : Number;
		/**
		 * @private
		 */
		private var formItemArr : Array = [];
		/**
		 * @private
		 */	
		private var gotRequiredField : Boolean = false;
		/**
		 * @private
		 */
		private var headingLabelField : TextField = null;
		/**
		 * @private
		 */
		private var subHeadLineTxtFieldArray : Array = [];
		/**
		 * @private
		 */
		private var longestlabelWidth : Number = NaN;
		/**
		 * @private
		 */
		private var preferredheadLabelTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var preferredLabelTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var preferredInstructionTextFormat : TextFormat = null;
		/**
		 * @private
		 */
		private var dataManager : IFormDataManager = null;
		/**
		 * @private
		 */
		private var headFormItem : FormItem = null;
		/**
		 * @private
		 */
		private var loopCatcher : int = 0;
		/**
		 * @private
		 */
		private var formEventObserver : FormEventObserver = null;

		/**
		 * Sets and gets dataManager for Form to collect and validate data.
		 * 
		 * @see com.yahoo.astra.managers.FormDataManager
		 */
		public function get formDataManager() : IFormDataManager {
			return dataManager;
		}
		/**
		 * @private
		 */
		public function set formDataManager(value : IFormDataManager) : void {
			dataManager = value;
		}

		/**
		 * @private 
		 * Storage for the dataSource property.
		 */
		private var _dataSource : Object = null;

		/**
		 * <p>Gets and sets the data to be shown and validated in a <code>Form</code>. 
		 * In order to collect and validate data, <code>FormDataManager</code> must be set <strong>before</strong> setting of <code>dataSource</code> in the <code>Form</code>.</p> 
		 * <p><strong>Property Options:</strong></p>
		 * <dl>
		 * 	<dt><strong><code>label</code></strong> : String</dt>
		 * 		<dd>The String for label text field.(e.g. lable:"State")</dd>
		 * 	<dt><strong><code>items</code></strong> : Object or String(or Object or String Array)</dt>
		 * 		<dd>The DisplayObject to be contained  and to be shown in a FormItem. String value will be attached as a textfield object.If there is multiple items, nest them into an array.(e.g.items:[stateComboBox,"Zip Code",zipcodeInput])</dd>
		 * 	<dt><strong><code>itemAlign</code></strong> : String</dt>
		 * 		<dd>The alignment of multiple items in a FormItem. The default alignment is "horizontal"(<code>FormLayoutStyle.HORIZONTAL</code>)(e.g. itemAlign:FormLayoutStyle.VERTICAL)</dd>
		 * 	<dt><strong><code>instructionText</code></strong> : String</dt>
		 * 		<dd>The String for additional label text field bottom of the item(s).(e.g. instructionText:"we'll not spam you!")</dd>
		 * 	<dt><strong><code>skin</code></strong> : DisplayObject</dt>
		 * 		<dd>The DisplayObject to be applied as a background skin of the FormItem (e.g. skin:new myBeautifulSkinMC())</dd>
		 * 	<dt><strong><code>labelTextFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The TextFormat to be applied to label of the FormItem (e.g. labelTextFormat:new TextFormat("Times", 12, 0xff0000))</dd>
		 * 	<dt><strong><code>itemHorizontalGap</code></strong> : Number</dt>
		 * 		<dd>The number of pixels in gaps between each items in a FormItems horizontaly.(e.g. itemHorizontalGap:8)</dd>
		 * 	<dt><strong><code>itemVerticalGap</code></strong> : Number</dt>
		 * 		<dd>The number of pixels in gaps between each items in a FormItems verticaly.(e.g. itemVerticalGap:8)</dd>
		 * 	<dt><strong><code>id</code></strong> : String(or String Array)</dt>
		 * 		<dd>The property of collected data.(e.g. id:"zip"  will be saved in FormDataManager as <code>FormDataManager.collectedData</code>["zip"] = "94089")</dd>
		 * 	<dt><strong><code>source</code></strong> : Object(or Object Array)</dt>
		 * 		<dd>The actual input source contains user input data.(e.g. source:[stateComboBox, zipcodeInput])</dd>
		 * 	<dt><strong><code>property</code></strong> : Object(or Object Array)</dt>
		 * 		<dd>The additional property of <code>source</code>. If you defined <code>valuePaser</code> of FormDataManager as <code>FlValueParser</code>, don't need to set this property in general(e.g. source:[comboBox, textInput] , property:["abbreviation","text"]</dd>
		 * 	<dt><strong><code>validator</code></strong> : Function(or Function Array)</dt>		 * 		<dd>The Function to validate the <code>source</code>.(e.g.  validator:validator.isZip)</dd>
		 * 	<dt><strong><code>validatorExtraParam</code></strong> : Object(or Object Array)</dt>		 * 		<dd>extra parameter(beside first parameter) of the validation.</dd>
		 * 	<dt><strong><code>required</code></strong> : Boolean(or Boolean Array)</dt>
		 * 		<dd>The Boolean to decide to show required filed indicator(~~) and apply validation(<code>validator</code>).(e.g. id:["stateComboBox", "zipcodeInput"], required:[false, true]) </dd>
		 * 	<dt><strong><code>errorString</code></strong> : String</dt>
		 * 		<dd>The String to show under the item(s) fail to validation when <code>showErrorMessageText</code> is set <code>true</code>. If there is existing <code>instructionText</code>, will be replaced by <code>errorString</code>.(e.g. errorString:"What kind of zipcode is that?.")</dd>
		 * </dl>
		 * 
		 * 
		 * @example The following code shows a use of <code>dataSource</code>:
		 *	<listing version="3.0">
		 *	// Download Adobe validator and add in the classpath
		 *	import com.adobe.as3Validators.as3DataValidation;
		 *	import com.yahoo.astra.fl.utils.FlValueParser;
		 *	// Init formDataManager with FlValueParser. 
		 *	myForm.formDataManager = new FormDataManager(FlValueParser);
		 *	// Init validator to be used.
		 *	var validator : as3DataValidation = new as3DataValidation();
		 *	var myFormDataArr : Array = [
		 *		{label:"Name", items:nameInput, id:"name", source:nameInput},
		 *		{label:"Address", items:[addressInput_line_1,addressInput_line_2 ], id:["address_line_1", "address_line_2"], source:[addressInput_line_1,addressInput_line_2]},
		 *		{label:"Email", items:emailInput, id:"email", instructionText :"we'll not spam you!", source:emailInput, required:true, validator:validator.isEmail},
		 *		{label:"", items:submitButton}];
		 *	myForm.dataSource = new dataSource(myFormDataArr);
		 * </listing>
		 * 
		 * @default null
		 */
		public function get dataSource() : Object {
			return this._dataSource;
		}

		/**
		 * @private
		 */
		public function set dataSource(value : Object) : void {
			this._dataSource = value;
			buildFromdataSource();
		}

		/**
		 * Setting string of optional text field on top of the Form.
		 * @param value Text to be shown in the FormHeading text field.
		 */
		public function set formHeading(value : String) : void {
			if(!value) return;
			if(!headFormItem) attachFormHeadingLabel(value);
			headingLabelField.htmlText = value;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageText property.
		 */
		private var _showErrorMessageText : Boolean = false;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#showErrorMessageText
		 * 
		 * @default false
		 */
		public function get showErrorMessageText() : Boolean {
			return _showErrorMessageText;
		}

		/**
		 * @private
		 */
		public function set showErrorMessageText(value : Boolean) : void {
			_showErrorMessageText = value;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageBox property.
		 */
		private var _showErrorMessageBox : Boolean = false;

		/**
		 * Sets and gets to present the error result message box : a translucent gray box(alpha:.2 , color:0x666666) behind the item that failed to validate.<br>
		 * 
		 * @example The following code shows a use of <code>showErrorMessageBox</code>:
		 *  <listing version="3.0"> 
		 *  myForm.setStyle("errorBoxColor", 0xff00ff);
		 *  myForm.setStyle("errorBoxAlpha", 1);
		 *  myForm.showErrorMessageBox = true;
		 *  </listing>
		 * @see setStyle
		 * @default false
		 */
		public function get showErrorMessageBox() : Boolean {
			return _showErrorMessageBox;
		}

		/**
		 * @private
		 * Storage for the showErrorMessageBox property.
		 */
		public function set showErrorMessageBox(value : Boolean) : void {
			_showErrorMessageBox = value;
		}

		/**
		 * @private
		 * Storage for the labelWidth property.
		 */
		private var _labelWidth : Number = NaN;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#labelWidth
		 * 
		 * @default NaN;
		 */
		public function get labelWidth() : Number {
			return _labelWidth;
		}

		/**
		 * @private
		 */
		public function set labelWidth(value : Number) : void {
			if(_labelWidth == value) return;
			_labelWidth = value;
			if(headFormItem) {
				if(headFormItem.labelItem)	LayoutManager.update(headFormItem.labelItem, "preferredWidth", labelWidth);
			}
		}

		/**
		 * @private
		 * Storage for the itemVerticalGap property.
		 */
		private var _itemVerticalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#itemVerticalGap
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP(6 px)
		 */
		public function get itemVerticalGap() : Number {
			return _itemVerticalGap;
		}

		/**
		 * @private
		 */
		public function set itemVerticalGap(value : Number) : void {
			_itemVerticalGap = value;
		}

		/**
		 * @private
		 * Storage for the itemHorizontalGap property.
		 */
		private var _itemHorizontalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#itemHorizontalGap 
		 * 
		 * @default FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP(6 px)
		 */
		public function get itemHorizontalGap() : Number {
			return _itemHorizontalGap;
		}

		/**
		 * @private
		 */
		public function set itemHorizontalGap(value : Number) : void {
			_itemHorizontalGap = value;
		}

		/**
		 * @private
		 * Storage for the horizontalGap property.
		 */
		private var _horizontalGap : Number = FormLayoutStyle.DEFAULT_HORIZONTAL_GAP;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#horizontalGap 
		 * 
		 *  @default FormLayoutStyle.DEFAULT_HORIZONTAL_GAP(6 px)
		 */
		override public function get horizontalGap() : Number {
			return _horizontalGap;
		}

		/**
		 * @private
		 */
		override public function set horizontalGap(value : Number) : void {
			_horizontalGap = value;
		}

		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap : Number = FormLayoutStyle.DEFAULT_VERTICAL_GAP;

		/**
		 * The number of pixels in gaps between FormItems.
		 * 
		 * @param value Number of pixels.
		 * @default FormLayoutStyle.DEFAULT_VERTICAL_GAP(6 px)
		 */
		override public function get verticalGap() : Number {
			return _verticalGap;
		}

		/**
		 * @private
		 */
		override public function set verticalGap(value : Number) : void {
			if(_verticalGap == value) return;
			super.verticalGap = _verticalGap = value;
		}

		/**
		 * @private
		 * Storage for the indicatorLocation property.
		 */
		private var _indicatorLocation : String = FormLayoutStyle.DEFAULT_INDICATOR_LOCATION; 

		/**
		 *  @copy com.yahoo.astra.containers.formClasses.FormItem#indicatorLocation 
		 *  
		 *  @default FormLayoutStyle.INDICATOR_LABEL_RIGHT
		 */
		public function get indicatorLocation() : String {
			return _indicatorLocation;
		}

		/**
		 * @private
		 */
		public function set indicatorLocation(value : String) : void {
			_indicatorLocation = value;
		}

		/**
		 * @private
		 * Storage for the labelAlign property.
		 */
		private var _labelAlign : String = FormLayoutStyle.DEFAULT_LABELALIGN;

		/**
		 * @copy com.yahoo.astra.containers.formClasses.FormItem#labelAlign 
		 * 
		 * @default FormLayoutStyle.RIGHT
		 */
		public function get labelAlign() : String {
			return _labelAlign;
		}

		/**
		 * @private
		 */
		public function set labelAlign(value : String) : void {
			_labelAlign = value;
		}

		
		//--------------------------------------
		//  Public Methods
		//--------------------------------------
		/**
		 * Adds DisplayObject into the <code>Form</code>. If the data is provied by dataSource, <code>addItem</code> will not be used explicitly.
		 * Also, if the <code>child</code> is not a <code>FormItem</code> instance, it will be attached to left edge of a <code>Form</code>.
		 * 
		 * @param child DisplayObject to be contained.
		 * @param required Optional parameter determines the requirement of the form.
		 */
		public function addItem(child : DisplayObject, required : Boolean = false) : void {
			if(child is FormItem) {
				var formItem : FormItem = child as FormItem;
			
				formItem = child as FormItem;
				formItem.subscribeObserver(formEventObserver);
				
				if(preferredLabelTextFormat) {
					notifyObserver(FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE, preferredLabelTextFormat);	
				}
				if(preferredInstructionTextFormat) {
					notifyObserver(FormLayoutEvent.UPDATE_INSTRUCTION_FONT_CHANGE, preferredInstructionTextFormat);	
				}
				if(isNaN(labelWidth)) {
					
					if(!isNaN(formItem.labelWidth)) findLongestLabelWidth(formItem.labelWidth);
					
					if(longestlabelWidth > 0) {
						notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, longestlabelWidth);
					}
					
					formItem.addEventListener(FormLayoutEvent.LABEL_ADDED, handler_formItemLabelAdded, false, 0, true);
				} else {
					notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, labelWidth);
				}
				
				if(required) {
					formItem.required = true;	
					gotRequiredField = true;
				}

				if(gotRequiredField)  notifyObserver(FormLayoutEvent.UPDATE_GOT_REQUIRED_ITEM, gotRequiredField);
				if(showErrorMessageText)  notifyObserver(FormLayoutEvent.UPDATE_ERROR_MSG_TEXT, showErrorMessageText);
				if(showErrorMessageBox)  notifyObserver(FormLayoutEvent.UPDATE_ERROR_MSG_BOX, showErrorMessageBox);
				
				if(horizontalGap != FormLayoutStyle.DEFAULT_HORIZONTAL_GAP) {
					notifyObserver(FormLayoutEvent.UPDATE_HORIZONTAL_GAP, horizontalGap);
				}
				if(itemVerticalGap != FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP) notifyObserver(FormLayoutEvent.UPDATE_ITEM_VERTICAL_GAP, itemVerticalGap);
				if(itemHorizontalGap != FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP)  notifyObserver(FormLayoutEvent.UPDATE_ITEM_HORIZONTAL_GAP, itemHorizontalGap);
				if(gotRequiredField && indicatorLocation)  notifyObserver(FormLayoutEvent.UPDATE_INDICATOR_LOCATION, indicatorLocation);
				if(labelAlign != FormLayoutStyle.DEFAULT_LABELALIGN)  notifyObserver(FormLayoutEvent.UPDATE_LABEL_ALIGN, labelAlign);
				this.addChild(formItem);
			} else {
				var container : FormItemContainer = new FormItemContainer();
				container.addItem(child);
				this.addChild(container);	
			}
		}

		/**
		 * Sets additional items under the <cod>FormHeading</code> field.
		 * 
		 *  @example The following code shows a use of <code>subFormHeading</code>:
		 *	<listing version="3.0">
		 *	var myForm:Form = new Form("Contact Us.");
		 *	var asteriskMC : MovieClip = new indicatorSkin();
		 *	myForm.subFormHeading(asteriskMC, "is required field.");
		 *	</listing>
		 * 	
		 * @param args Elements to be contained in subFormHeading field. Either String or DisplayObjects will be accepted.
		 */
		public function subFormHeading(...args) : void {
			
			if(args.length < 1) return;
			
			if(!headFormItem) attachFormHeadingLabel("");
		
			var subHeadLabel : LayoutContainer = new LayoutContainer(new BoxLayout());
			subHeadLineTxtFieldArray = [];
			
			for (var i : int = 0;i < args.length; i++) {
				var obj : * = args[i];
				if(obj is String) {
					var subHeadLineTxtField : TextField = FormLayoutStyle.instructionTextField;
					if(preferredInstructionTextFormat) {
						subHeadLineTxtField.defaultTextFormat = preferredInstructionTextFormat;					}
					
					subHeadLineTxtField.htmlText = obj.toString();	
					subHeadLabel.addChild(subHeadLineTxtField);
					subHeadLineTxtFieldArray.push(subHeadLineTxtField);
				} else {
					subHeadLabel.addChild(obj);
				}
			}
			headFormItem.itemContainer.addItem(subHeadLabel);
		}

		/**
		 * Sets a style property on this component instance.
		 * Calling this method can result in decreased performance, so use it only when necessary.
		 * 	  <p><strong>Additional Styles for Form:</strong></p>
		 * <dl>
		 * 	<dt><strong><code>skin</code></strong> : Object</dt>
		 * 		<dd>The skin of Form. Default is none.</code></dd>
		 * 	<dt><strong><code>indicatorSkin</code></strong> : DisplayObjectContainer</dt>
		 * 		<dd>The skin of required field indicator's skin. Default is asterisk(~~).</dd>
		 *	<dt><strong><code>errorBoxColor</code></strong> : Object</dt>
		 * 		<dd>The color of <code>errorMessageBox</code>. Default is 0x6666.</code></dd>
		 * 	<dt><strong><code>errorBoxAlpha</code></strong> : Number</dt>
		 * 		<dd>The alpha of <code>errorMessageBox</code>. Default is .2</code></dd>
		 * 	<dt><strong><code>textFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of all the labels in the <code>Form</code>. Default is : "_sans", 11, 0x000000.</dd>
		 * 	<dt><strong><code>instructionTextFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of all the <code>instructionText</code> fields in the <code>Form</code>. Default is : "_sans", 10, 0x000000.</dd>
		 * 	<dt><strong><code>headTextFormat</code></strong> : TextFormat</dt>
		 * 		<dd>The text format of <code>formHeading</code> field in the <code>Form</code>. Default is : "_sans", 11, 0x000000, bold.</dd>
		 * 	</dl>
		 *  
		 * @example The following code shows a use of <code>setStyle</code>:
		 *  <listing version="3.0">
		 *	var myForm:Form = new Form();
		 *	myForm.setStyle("indicatorSkin", "myCustomIndicatorSkinMC");  
		 *	myForm.setStyle("textFormat",  new TextFormat("Times", 13, 0xFF0000));
		 *	</listing>
		 * 
		 * 
		 *  @param style The name of the style property.
		 *
		 *  @param value The value of the style. 
		 *  
		 *  @see com.yahoo.astra.containers.formClasses.FormLayoutStyle
		 */
		override public function setStyle(style : String, value : Object) : void {
			if(value && style == "textFormat") {
				longestlabelWidth = 0;
				preferredLabelTextFormat = value as TextFormat;
				return;
			}
			if(value && style == "instructionTextFormat") {
				preferredInstructionTextFormat = value as TextFormat;
				if(subHeadLineTxtFieldArray) {
					var subHeadLineTxtFieldArrayLeng : int = subHeadLineTxtFieldArray.length;
					for (var i : int = 0;i < subHeadLineTxtFieldArrayLeng; i++) {
						var subTextField : TextField = subHeadLineTxtFieldArray[i];
						subTextField.setTextFormat(preferredInstructionTextFormat);
					}
				}
				return;
			}
			if(value && style == "headTextFormat") {
				preferredheadLabelTextFormat = value as TextFormat;
				if(headingLabelField) {
					headingLabelField.defaultTextFormat = preferredheadLabelTextFormat;
					this.formHeading = headingLabelField.text;
				}
				return;
			}
			
			if(style == "indicatorSkin" || style == "errorBoxAlpha" || style == "errorBoxColor") {
				FormLayoutStyle.defaultStyles[style] = value;
			}
			super.setStyle(style, value);
		}

		/**
		 * @private 
		 *  @see com.yahoo.astra.fl.containers.formClasses.FormItem#subscribeObserver 
		 */
		public function subscribeObserver(formEventObserver : IFormEventObserver) : IFormEventObserver {
			return formEventObserver.subscribeObserver(this);
		}

		/**
		 * @private
		 * @see com.yahoo.astra.fl.containers.formClasses.FormItem#update 
		 */
		public function update(target : String,value : Object = null) : void {
			/*
			 * have no event to update in this class.
			 */
		}

		//--------------------------------------
		//  Private Methods
		//--------------------------------------

		/**
		 * @private
		 */
		private function notifyObserver(target : String, value : Object = null) : void {
			if(!formEventObserver) return;
			formEventObserver.setUpdate(target, value);
		}

		/**
		 * @private
		 */
		private function handler_enterFrame(e : Event) : void {
			if(NumberUtil.fuzzyEquals(this.height, temp_adjusting_height) || loopCatcher > 20) {
				this.removeEventListener(Event.ENTER_FRAME, handler_enterFrame);	
				this.visible = true;
				loopCatcher = 0;
				// all adjustment for Form is done.
				this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.FORM_BUILD_FINISHED));
				return;
			}
			temp_adjusting_height = this.height;
			loopCatcher++;
		}

		/**
		 * @private
		 */	
		private function attachFormHeadingLabel(value : String) : void {
			headingLabelField = FormLayoutStyle.headTextField;
			if(preferredheadLabelTextFormat) headingLabelField.defaultTextFormat = preferredheadLabelTextFormat;
			headingLabelField.htmlText = value;
			
			headFormItem = new FormItem(headingLabelField);
			headFormItem.isFormHeadingLabel = true;
			headFormItem.itemAlign = FormLayoutStyle.VERTICAL;
			this.addItem(headFormItem, false);
		}

		/**
		 * @private
		 */
		private function handler_formItemLabelAdded(e : FormLayoutEvent) : void {
			var formItem : FormItem = e.target as FormItem;
			findLongestLabelWidth(formItem.labelWidth);
		}

		/**
		 * @private
		 */
		private function findLongestLabelWidth(labelWidth : Number = 0) : void {
			if(isNaN(longestlabelWidth)) longestlabelWidth = 0;
			if(labelWidth > longestlabelWidth) {
				longestlabelWidth = labelWidth;
				notifyObserver(FormLayoutEvent.UPDATE_LABEL_WIDTH, longestlabelWidth);
			}
		}

		/**
		 * @private
		 */
		private function buildFromdataSource() : void {
			var dataLength : int = dataSource.length;
			
			for (var i : int = 0;i < dataLength; i++) {
				var curData : Object = dataSource[i];
				if(curData["label"] == undefined ) {
					/*
					 * Item with no Label.
					 */
					var itemContainer : FormItemContainer = new FormItemContainer();
					if (curData["itemAlign"]) itemContainer.itemAlign = curData["itemAlign"];
					if(curData["items"] is Array) {
						var curItemDataLength : int = curData["items"].length;
						for (var j : int = 0;j < curItemDataLength; j++) {
							itemContainer.addItem(curData["items"][j]);
						}
					} else {
						itemContainer.addItem(curData["items"]);
					}
					this.addItem(itemContainer, curRequired);
				} else {
					var curLabel : String = (curData["label"]) ? curData["label"] : "";
					var curItmes : Object = (curData["items"]) ? curData["items"] : [];
					var curRequired : Boolean = false;
					if(curData["required"] is Array) {
						var reqLeng : int = curData["required"].length;
						for (var k : int = 0;k < reqLeng; k++) {
							var temp : Boolean = Boolean(curData["required"][k] as Boolean);
							curRequired ||= temp;
						}
					} else if(curData["required"] is String) {
						curRequired = (curData["required"] == "true") ? true : false;	
					} else {
						curRequired = (curData["required"]) ? curData["required"] : false;	
					}
					var curFormItem : FormItem = new FormItem(curLabel, curItmes);
					if (curData["errorString"]) curFormItem.errorString = curData["errorString"];
					if (curData["itemAlign"]) curFormItem.itemAlign = curData["itemAlign"];
					if (curData["instructionText"]) curFormItem.instructionText = curData["instructionText"];					if (curData["itemHorizontalGap"]) curFormItem.itemHorizontalGap = curData["itemHorizontalGap"];					if (curData["itemVerticalGap"]) curFormItem.itemVerticalGap = curData["itemVerticalGap"];					if (curData["skin"]) curFormItem.skin = curData["skin"];					if (curData["labelTextFormat"]) curFormItem.labelTextFormat = curData["labelTextFormat"];					this.addItem(curFormItem, curRequired);
				}
				
				var curId : Object = curData["id"];
				if(!curId ) continue;
				if(curId && !dataManager) {
					throw new Error("You must set formDataManager before set the dataSource.");
				}
				
				if(curData["id"] is Array) {
					var curIdDataLength : int = curId.length;
					for (var l : int = 0;l < curIdDataLength; l++) {
						var curSource : Object = (curData["source"] is Array) ? curData["source"][l] : null;
						var curProperty : Object = (curData["property"] is Array) ? curData["property"][l] : null;
						var curValidator : Function = (curData["validator"] is Array) ? curData["validator"][l] : null;						var validatorExtraParam : Object = (curData["validatorExtraParam"] is Array) ? curData["validatorExtraParam"][l] : null;
						var curRequiredArr : Boolean = (curData["required"] is Array) ? curData["required"][l] : false;
						var curTargetObj : DisplayObject = (curData["targetObj"] is Array) ? curData["targetObj"][l] as DisplayObject : curFormItem;
						var curEventFunction_success : Function = (curData["eventFunction_success"] is Array) ? curData["eventFunction_success"][l] as Function : null;
						var curEventFunction_fail : Function = (curData["eventFunction_fail"] is Array) ? curData["eventFunction_fail"][l] as Function : null;
						if(curFormItem) curFormItem.hasMultipleItems = true;
						dataManager.addItem( curData["id"][l], curSource, curProperty, curRequiredArr, curValidator, validatorExtraParam, curTargetObj, curEventFunction_success, curEventFunction_fail);	
					}
				} else {
					dataManager.addItem( curData["id"], curData["source"], curData["property"], curRequired, curData["validator"], curData["validatorExtraParam"], (curData["targetObj"] is DisplayObject) ? curData["targetObj"] : curFormItem, curData["eventFunction_success"], curData["eventFunction_fail"]);	
				}
			}
		}
	}
}

