/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.FormItemLabel;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.events.FormDataManagerEvent;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;
	import com.yahoo.astra.layout.modes.BoxLayout;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * Defines a label and one or more children arranged horizontally or vertically. 	 * Similar to Flex FormItem, the label is vertically aligned with the first child in the FormItem container and is right-aligned in the region to the left of the container.	 * It is designed to be nested in a Form, but it can be used as a standalone class as desired.	 * 	 * @example The following code shows a use of <code>FormItem</code>:	 *	<listing version="3.0">	 *		 *	var addressInput_line_1:TextInput = new TextInput();	 *	var addressInput_line_2:TextInput = new TextInput();	 *		 *	var addressFormItem : FormItem = new FormItem("Address", addressInput_line_1, addressInput_line_2);	 *	addressFormItem.itemAlign = FormLayoutStyle.VERTICAL;	 *	addressFormItem.labelTextFormat = new TextFormat("Arial", 11, 0xFF00FF);	 *	addressFormItem.labelWidth = 60;	 *	addressFormItem.showErrorMessageBox = true;	 *	addressFormItem.required = true;	 *	</listing>
	 *	@see com.yahoo.astra.fl.containers.Form
	 * @author kayoh
	 */

	public class FormItem extends LayoutContainer implements IForm {

		//--------------------------------------		//  Constructor		//--------------------------------------		/**		 * Constructor.		 * The parameter can be either String or DisplayObject. 		 * If the first argument is <code>Sting</code>, it will be set as a label on leftside and any string afterward will be a label aligned with other DisplayObjects.		 * 		 * @param args	String or DisplayObjectsto be contained in the FormItem.		 */

		public function FormItem( ...args ) {			formItemLayout = new BoxLayout();
			formItemLayout.horizontalGap = horizontalGap; 
			
			super(formItemLayout);						this.autoMask = false;
			
			_skin = new Sprite();			formItemLayout.addClient(_skin, {includeInLayout:false});			this.addChild(_skin);									errorGrayBoxSpriteHolder = new Sprite();
			formItemLayout.addClient(errorGrayBoxSpriteHolder, {includeInLayout:false});
			this.addChild(errorGrayBoxSpriteHolder);						//attach Label			var i : int = 0;			if(args[0] is String) {
				var argStr : String = args[0].toString();				labelItem = addLabel(argStr);
				i = 1;			} else {				labelItem = addLabel(null);
				horizontalGap = 0;			}						//attach ItemContainer			itemContainer = new FormItemContainer();			if(itemAlign) itemContainer.itemAlign = this.itemAlign;			if(itemHorizontalGap) itemContainer.itemHorizontalGap = this.itemHorizontalGap;			if(itemVerticalGap) itemContainer.itemVerticalGap = this.itemVerticalGap;			itemContainer.addEventListener(LayoutEvent.LAYOUT_CHANGE, handler_fomItemContainer_listener, false, 0, true);						for (i;i < args.length; i++) {				var curObject : * = args[i];				if(curObject is String) {					curObject = addTextField(curObject);					textfieldArray.push(curObject);				}				if(curObject is Array) {					var curObjectArr : Array = curObject as Array;					var curObjectlength : int = curObjectArr.length;					for (var j : int = 0;j < curObjectlength; j++) {						var curObj : * = curObject[j];						if(curObj is String) {							curObj = addTextField(curObj);							textfieldArray.push(curObj);						}						itemContainer.addItem(curObj);					}				} else {					itemContainer.addItem(curObject);					}			}			this.addChild(labelItem);			this.addChild(itemContainer);		}

		//--------------------------------------		//  Properties		//--------------------------------------		/**		 * @private		 */		private var formItemLayout : BoxLayout = null;		/**		 * @private		 */		private var errorGrayBoxSprite : Sprite = null;
		/**
		 * @private
		 */
		private var errorGrayBoxSpriteHolder : Sprite;		/**		 * @private		 */		private var textfieldArray : Array = [];		/**		 * @private		 */		private var formEventObserver : IFormEventObserver = null;
		/**
		 * @private
		 */		private var sidePadding : Number = NaN;
		/**		 * @private		 */		private var _skin : Sprite ;

		/**		 * Background skin of FormItem.
		 * 		 * @param value DisplayObject		 */
		public function get skin() : DisplayObject {			return _skin;		}

		/**		 * @private		 */		public function set skin(value : DisplayObject) : void {			_skin.addChild(value);		}

		/**		 * @private		 */		private var _gotResultBool : Boolean = true;

		/**		 * @private		 * 		 * When <code>multipleResult</code> is <code>true</code>, used as a reference to determine to pass/fail in validation  in <code>FormDataManager</code>.		 * In case <code>multipleResult</code> is <code>true</code>, 		 * In case <code>FormItem</code> has multiple form inputs to validate and part of them are not passed the validation, <code>gotResultBool</code> will be set as <code>false</code> to show ErrorMessageBox or ErrorMessageMessage.		 * 		 * @default true;		 */		public function get gotResultBool() : Boolean {			return _gotResultBool;		}

		/**		 * @private		 */		public function set gotResultBool(value : Boolean) : void {			_gotResultBool = value;		}

		/**		 * @private		 * Storage for the showErrorMessageBox property.		 */		private var _showErrorMessageBox : Boolean = false;

		/**		 * Decides to present error result message box : a translucent gray box(alpha:.2 , color:0x666666) behind the item that failed to validation.<br>		 * 		 * @default false;		 */		public function get showErrorMessageBox() : Boolean {			return _showErrorMessageBox;		}

		/**		 * @private		 */		public function set showErrorMessageBox(value : Boolean) : void {
			if(isFormHeadingLabel) return;
			if(_showErrorMessageBox == value) return;			_showErrorMessageBox = value;			(value) ? this.addListeners() : this.removeListeners();		}

		/**		 * @private		 * Storage for the showErrorMessageText property.		 */		private var _showErrorMessageText : Boolean = false;

		/**		 * Decides to present error result string: a error message returned from <code>FormDataManager</code> that failed to validate.		 * 		 * @default false;		 */		public function get showErrorMessageText() : Boolean {			return _showErrorMessageText;		}

		/**		 * @private		 */		public function set showErrorMessageText(value : Boolean) : void {
			if(isFormHeadingLabel) return;
			if(_showErrorMessageText == value) return;			_showErrorMessageText = value;
			if(value) {
				if(!instructionText) instructionText = " ";
				addListeners();			} else {
				removeListeners();
			}
		}

		/**		 * @private		 * Storage for the itemContainer property.		 */		private var _itemContainer : FormItemContainer = null;

		/**		 * @private		 */		public function get itemContainer() : FormItemContainer {			return _itemContainer;		}

		/**		 * @private		 */		public function set itemContainer(value : FormItemContainer) : void {			_itemContainer = value;		}

		/**		 * @private		 * Storage for the labelItem property.		 */		private var _labelItem : FormItemLabel = null;

		/**		 * @private		 * FormItemLabel to contain a label in a FormItem.		 * 		 *  @param value LayoutContainer to be used as label container.		 */		public function get labelItem() : FormItemLabel {			return _labelItem;		}

		/**		 * @private		 */		public function set labelItem(value : FormItemLabel) : void {			_labelItem = value;		}

		/**		 * @private		 * Storage for the errorString property.		 */		private var _errorString : String = FormLayoutStyle.DEFAULT_ERROR_STRING;

		/**		 * Sets and gets the text to be used for validation error. 		 * 		 * @param value String to be set as error message.		 * @default "Invalid input"		 */		public function get errorString() : String {			return _errorString;		}

		/**		 * @private		 */		public function set errorString(value : String) : void {			_errorString = value;		}

		/**
		 * @private
		 */
		private var _instructionText : String;

		/**		 * Sets and gets an additional text label bottom of the item field		 */
		public function get instructionText() : String {
			return itemContainer.instructionText;		}

		/**
		 * @private
		 */		public function set instructionText(value : String) : void {
			if(!_instructionText) _instructionText = value;
			itemContainer.instructionText = value;
		}

		/**		 * @private		 * Storage for the labelAlign property.		 */		private var _labelAlign : String = FormLayoutStyle.DEFAULT_LABELALIGN;

		/**		 * <p>Alignment of labels in each FormItems.</p>
		 * <p>Acceptable values for the <code>labelAlign</code>: 
		 * <dl>
		 *  <dt><strong><code>FormLayoutStyle.RIGHT</code></strong>(default) : right end of label field.</dt>
		 *  <dt><strong><code>FormLayoutStyle.LEFT</code></strong> :  far left of <code>Form</code>.</dt>
		 *  <dt><strong><code>FormLayoutStyle.TOP</code></strong> : will be stacked vertically</dt>
		 * </dl>
		 * </p>		 * @default FormLayoutStyle.DEFAULT_LABELALIGN(FormStyle.RIGHT)		 * @param value String of alignment.		 */		public function get labelAlign() : String {			return _labelAlign;		}

		/**		 * @private		 */		public function set labelAlign(value : String) : void {			if(_labelAlign == value) return; 			_labelAlign = value;						this.updatelabelAlign(value);		}

		/**		 * @private		 * Storage for the labelWidth property.		 */		private var _labelWidth : Number = NaN;

		/**		 * Sets and gets the width of label field.		 * <code>Form</code> automatically matches the width of labels on the longest label among FormItems in it. 		 * However, if consistance width of label field needed, you can fix the size of the label by setting <code>labelWidth</code>.
		 * 		 * @param value Number of pixels.
		 * @default NaN		 */		public function get labelWidth() : Number {			return _labelWidth;		}

		/**		 * @private		 */		public function set labelWidth(value : Number) : void {			if(_labelWidth == value) return;			_labelWidth = value;					if(this.labelItem) {					this.labelItem.preferredLabelWidth = value;			}		}

		/**		 * @private		 * Storage for the required property.		 */		private var _required : Boolean = false;

		/**		 * Sets and gets the requirement of the item(s).		 * Case of <code>true</code> Form inserts a red asterisk (*) character on the spot that a <code>indicatorLocation</code> has specified. 		 * 		 * @default false		 */		public function get required() : Boolean {			return _required;			}

		/**		 * @private		 */		public function set required(value : Boolean) : void {			_required = value;			if(required) labelItem.required = true;			if(required) itemContainer.required = true;						if(this.itemContainer) itemContainer.update_indicatiorLocation(indicatorLocation);			if(this.labelItem) labelItem.update_indicatiorLocation(indicatorLocation);		}

		/**		 * @private		 *  Storage for the indicatiorLocation property.		 */		private var _indicatorLocation : String = FormLayoutStyle.DEFAULT_INDICATOR_LOCATION;

		/**		 * <p>Sets and gets the location of required indicator(~~) when the item is set to be required.</p>		 * <p>Acceptable values for the <code>indicatorLocation</code>: 
		 * <dl>
		 *  <dt><strong><code>FormLayoutStyle.INDICATOR_LABEL_RIGHT</code></strong>(default) : between a label and items.</dt>		 *  <dt><strong><code>FormLayoutStyle.INDICATOR_LEFT</code></strong> : left of a label.</dt>		 *  <dt><strong><code>FormLayoutStyle.INDICATOR_RIGHT</code></strong> : right of items.</dt>
		 * </dl>		 * </p>		 * @default FormLayoutStyle.DEFAULT_INDICATOR_LOCATION(FormLayoutStyle.RIGHT)		 */		public function get indicatorLocation() : String {			return _indicatorLocation;			}

		/**		 * @private		 */		public function set indicatorLocation(value : String) : void {			if(_indicatorLocation == value) return;			_indicatorLocation = value;			if(itemContainer) itemContainer.update_indicatiorLocation(value);			if(labelItem) labelItem.update_indicatiorLocation(value);		}

		/**		 * @private		 * Storage for the itemAlign property.		 */
		private var _itemAlign : String = FormLayoutStyle.DEFAULT_ITEM_ALIGN;

		/**		 * <p>Set alignment of multiple items in a FormItem.</p>
		 * <p>Acceptable values for the <code>itemAlign</code>: 
		 * <dl>
		 *  <dt><strong><code>FormLayoutStyle.HORIZONTAL</code></strong>(default)</dt>
		 *  <dt><strong><code>FormLayoutStyle.VERTICAL</code></strong></dt>
		 * </dl>		 * </p>		 * @default FormLayoutStyle.DEFAULT_ITEM_ALIGN(FormLayoutStyle.HORIZONTAL)		 */		public function get itemAlign() : String {
			return _itemAlign;
		}

		/**		 * @private		 */		public function set itemAlign(value : String) : void {
			if(_itemAlign == value) return;
			_itemAlign = value;
			if(this.itemContainer) itemContainer.itemAlign = value;
		}

		/**		 * @private		 * Storage for the itemVerticalGap property.		 */
		private var _itemVerticalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP;

		/**		 * The number of pixels in gaps between each items in a <code>FormItem</code> verticaly.		 * 		 * @default FormLayoutStyle.DEFAULT_FORMITEM_VERTICAL_GAP(6px)		 */		public function get itemVerticalGap() : Number {
			return _itemVerticalGap;
		}

		/**		 * @private		 */		public function set itemVerticalGap(value : Number) : void {
			if(itemVerticalGap == value) return;			_itemVerticalGap = itemContainer.itemVerticalGap = value;
		}

		/**		 * @private		 * Storage for the itemHorizontalGap property.		 */
		private var _itemHorizontalGap : Number = FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP;

		/**		 * The number of pixels in gaps between each items in a <code>FormItem</code> horizontaly.		 * 		 * @default FormLayoutStyle.DEFAULT_FORMITEM_HORIZONTAL_GAP(6px)		 */		public function get itemHorizontalGap() : Number {
			return _itemHorizontalGap;
		}

		/**		 * @private		 */		public function set itemHorizontalGap(value : Number) : void {			if(itemHorizontalGap == value) return;			_itemHorizontalGap = itemContainer.itemHorizontalGap = value;		}

		/**		 * @private		 * Storage for the horizontalGap property.		 */
		private var _horizontalGap : Number = FormLayoutStyle.DEFAULT_HORIZONTAL_GAP;

		/**		 * The number of pixels in gaps between labels and items.		 * 		 * @default FormLayoutStyle.DEFAULT_HORIZONTAL_GAP(6 px)		 * 		 * @see com.yahoo.astra.containers.formClasses.FormLayoutStyle		 */		public function get horizontalGap() : Number {
			return _horizontalGap;
		}

		/**		 * @private		 */		public function set horizontalGap(value : Number) : void {
			if(_horizontalGap == value) return;
			_horizontalGap = value;
			formItemLayout.horizontalGap = value;
		}

		
		/**		 * @private		 * Storage for the multipleResult property.		 */		private var _hasMultipleItems : Boolean = false;

		/**		 * @private		 * 		 * A Boolean value whether <code>FormItem</code> has multiple form inputs to collect data. 		 * <code>Form</code> sets this value to <code>true</code> when the current <code>FormItem</code> has multiple <code>id</code>s.		 * <p>No explicit use.</p>		 * 		 * 		 * @deafult false		 */		public function get hasMultipleItems() : Boolean {			return _hasMultipleItems;			}

		/**		 * @private		 */		public function set hasMultipleItems(value : Boolean) : void {			_hasMultipleItems = value;
		}

		/**		 * @private		 * Storage for the isHeadLabel property.		 */		private var _isFormHeadingLabel : Boolean = false;

		/**		 * @private		 * 		 * A Boolean value whether current <code>FormItem</code> is used as a container for FromHeading.		 * <code>Form</code> sets this value to <code>true</code> when the current <code>FormItem</code> is FormHeading container.		 * 		 */		public function get isFormHeadingLabel() : Boolean {
			return _isFormHeadingLabel;		}

		/**
		 * @private
		 */		public function set isFormHeadingLabel(value : Boolean) : void {			_isFormHeadingLabel = value;			if(itemContainer) itemContainer.isFormHeadingLabel = value;		}

		/**		 * @private		 * Storage for the labelTextFormat property.		 */		private var _labelTextFormat : TextFormat = FormLayoutStyle.defaultStyles["textFormat"];

		/**		 * Gets and sets the <code>TextFormat</code> of the label.		 * 		 * @default TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)		 */		public function get labelTextFormat() : TextFormat {			var TxtFormat : TextFormat = (_labelTextFormat) ? _labelTextFormat : FormLayoutStyle.defaultStyles["textFormat"];			return TxtFormat;		}

		/**		 * @private		 */		public function set labelTextFormat(value : TextFormat) : void {			if(_labelTextFormat == value) return;			_labelTextFormat = value;			if(value is TextFormat && labelItem) {				labelItem.preferredLabelTextFormat = value;			}		}

		/**		 * @private		 * Storage for the instructionTextFormat property.		 */		private var _instructionTextFormat : TextFormat;

		/**		 * Gets and sets the <code>TextFormat</code> of the <code>instructionText</code>.		 * @default TextFormat("_sans", 10, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)		 */		public function get instructionTextFormat() : TextFormat {			var TxtFormat : TextFormat = (_instructionTextFormat) ? _instructionTextFormat : FormLayoutStyle.defaultStyles["instructionTextFormat"];			return TxtFormat;		}

		/**		 * @private		 */		public function set instructionTextFormat(value : TextFormat) : void {			_instructionTextFormat = value;			if(itemContainer) {				if(!formEventObserver) subscribeObserver(new FormEventObserver());				formEventObserver.setUpdate(FormLayoutEvent.UPDATE_INSTRUCTION_FONT_CHANGE, value);			}		}

		/**		 * Gets and sets DisplayObject of the required indicator. Default is "~~" in red(0xff0000). Set any DisplayObject to apply the skin of the indicator.
		 * @return RequiredIndicator		 */		public function get requiredIndicator() : DisplayObject {			return (labelItem.requiredIndicator) ? labelItem.requiredIndicator : (itemContainer.requiredIndicator) ? itemContainer.requiredIndicator : null;		}

		/**
		 * @private
		 */
		public function set requiredIndicator(value : DisplayObject) : void {
			FormLayoutStyle.defaultStyles["indicatorSkin"] = value;
		}

		/**		 * 		 * @private 		 * 		 * Sets FormEventObserver as an event observer class and register IForm class into it.		 * Returns <code>IFormEventObserver</code>(the return type of <code>FormEventObserver.subscribeObserver</code>) to force to add IForm instance into formEventObserver's subscription for notifing and updating FormEvents.		 * 		 */		public function subscribeObserver(formEventObserver : IFormEventObserver ) : IFormEventObserver {			this.formEventObserver = formEventObserver;						itemContainer.subscribeObserver(formEventObserver);			labelItem.subscribeObserver(formEventObserver);						return formEventObserver.subscribeObserver(this);		}

		/**		 * @private 		 * 		 * Update FormLayoutEvents and properties.		 * Mainly, it will be tiggered by <code>setUpdate</code> from <code>FormEventObserver</code> class to notify <code>FormLayoutEvent</code>s.		 * 		 */		public function update(target : String , value : Object = null) : void {			switch(target) {				case FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE:					updateTextFields(value as TextFormat);					break;				case FormLayoutEvent.UPDATE_HORIZONTAL_GAP:
					this.horizontalGap = Number(value);					break;				case FormLayoutEvent.UPDATE_LABEL_ALIGN:					this.labelAlign = String(value);					break;				case FormLayoutEvent.UPDATE_ERROR_MSG_TEXT:					this.showErrorMessageText = true;					break;				case FormLayoutEvent.UPDATE_ERROR_MSG_BOX:					this.showErrorMessageBox = true;					break;
				case FormLayoutEvent.UPDATED_PADDING_RIGHT:
					this.sidePadding = Number(value);
					break;	
			}		}

		//--------------------------------------		//  Private Methods		//--------------------------------------		/**		 * @private		 */		private function handler_fomItemContainer_listener(e : LayoutEvent) : void {			this.dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}

		/**		 * @private		 */		private function label_change(e : FormLayoutEvent) : void {						var label : FormItemLabel = e.target as FormItemLabel;			if(this.labelWidth != label.actualLabelTextWidth) this.labelWidth = label.actualLabelTextWidth;			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));		}

		/**		 * @private		 */		private function updateTextFields(textformat : TextFormat) : void {			var arrLength : int = textfieldArray.length;			if(arrLength < 1) return;			for (var i : int = 0;i < arrLength; i++) {				var textFieldToChg : TextField = textfieldArray[i];				var str : String = textFieldToChg.text;				textFieldToChg.defaultTextFormat = textformat;				textFieldToChg.htmlText = str;			}		}

		/**		 * @private		 */		private function updatelabelAlign(value : String) : void {			switch(value) {				case FormLayoutStyle.TOP:					formItemLayout.direction = "vertical";					break;									case FormLayoutStyle.LEFT:					formItemLayout.direction = "horizontal";					break;									case FormLayoutStyle.RIGHT:					formItemLayout.direction = "horizontal";					break;					}						if(this.labelItem) LayoutManager.update(this.labelItem, "labelAlign", value);		}

		/**		 * @private		 */		private function addTextField(value : String) : TextField {
			var tf : TextField = FormLayoutStyle.defaultTextField;
			tf.defaultTextFormat = FormLayoutStyle.defaultStyles["textFormat"];
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.htmlText = value;
			return tf;
		}

		private function addLabel( txt : String = "") : FormItemLabel {
			var labelItem : FormItemLabel = new FormItemLabel();
			labelItem.addEventListener(FormLayoutEvent.LABEL_ADDED, label_change, false, 0, true);
			labelItem.attLabel(txt);
			return labelItem;
		}

		/**		 * @private		 */		private function handler_validation_passed(e : FormDataManagerEvent = null) : void {
			gotResultBool &&= true;
			if(!gotResultBool && hasMultipleItems) return;			if(showErrorMessageText && itemContainer.instructionTextField) instructionText = " ";			if(_instructionText) instructionText = _instructionText;			if(errorGrayBoxSprite && showErrorMessageBox) errorGrayBoxSprite.visible = false;
		}

		/**		 * @private		 */		private function handler_validation_failed(e : FormDataManagerEvent = null) : void {			gotResultBool = false;
			if(showErrorMessageText) instructionText = e.errorMessage ? e.errorMessage.toString() : this.errorString;			if(!showErrorMessageBox) return;
			if(!errorGrayBoxSprite) {				// Make gray box around form with 2 px paddings.
				var w : Number = this.width;
				var form : Object = this.parent.parent;
				// If this FormItem is a part of Form, width of gray box will be set to width of Form.
				if(this.parent.parent is IForm && form.paddingRight is Number) {
					var formWidth : Number = form.width - form.paddingRight - form.paddingLeft;
					if(formWidth > w) w = formWidth;
				}
				errorGrayBoxSprite = drawErrorGrayBox(-2, -2, w + 4, this.height + 4, FormLayoutStyle.defaultStyles["errorBoxColor"], FormLayoutStyle.defaultStyles["errorBoxAlpha"]);				errorGrayBoxSpriteHolder.addChild(errorGrayBoxSprite);
			}
			errorGrayBoxSprite.visible = true;
		}

		/**		 * @private		 */		private function addListeners() : void {			this.addEventListener(FormDataManagerEvent.VALIDATION_PASSED, handler_validation_passed, false, 0, true);			this.addEventListener(FormDataManagerEvent.VALIDATION_FAILED, handler_validation_failed, false, 0, true);		}

		/**		 * @private		 */		private function removeListeners() : void {
			this.removeEventListener(FormDataManagerEvent.VALIDATION_PASSED, handler_validation_passed);			this.removeEventListener(FormDataManagerEvent.VALIDATION_FAILED, handler_validation_failed);		}

		/**
		 * @private
		 */
		private function drawErrorGrayBox(x : Number, y : Number,w : Number, h : Number, clr : uint = 0xffffff, alpha : Number = 0) : Sprite {
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill(clr, alpha);
			sprite.graphics.drawRect(x, y, w, h);
			sprite.graphics.endFill();
			return sprite;
		}
	}
}

