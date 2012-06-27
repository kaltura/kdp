/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.FormItemContainer;
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.containers.formClasses.IForm;
	import com.yahoo.astra.events.FormLayoutEvent;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	/**
	 * <code>FormItemLabel</code> contains a label and required indicator in <code>FormItem</code> .
	 * 
	 * @see com.yahoo.astra.containers.formClasses.FormItem	 * @see com.yahoo.astra.containers.formClasses.FormItemContainer
	 * @author kayoh
	 */
	public class FormItemLabel extends FormItemContainer  implements IForm {

		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		/**
		 * Constructor.
		 */
		public function FormItemLabel() {
			super();
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * @private
		 */
		private var labelTextField : TextField = null;
		/**
		 * @private
		 */
		private var lableText : String = null;
		/**
		 * @private
		 */
		private var lableSprite : Sprite = null;

		/**
		 * @private
		 */
		private var _actualLabelTextWidth : Number = NaN;

		/**
		 * @private
		 */
		internal function get actualLabelTextWidth() : Number {
			return _actualLabelTextWidth;	
		}

		/**
		 * @private
		 */
		internal function set actualLabelTextWidth(value : Number) : void {
			if(_actualLabelTextWidth == value) return;
			_actualLabelTextWidth = value;
		}

		/**
		 * @private
		 */
		private var _preferredWidth : Number;

		/**
		 * @private
		 */
		internal function get preferredLabelWidth() : Number {
			return _preferredWidth;	
		}

		/**
		 * @private
		 */
		internal function set preferredLabelWidth(value : Number) : void {
			if(_preferredWidth == value) return;
			_preferredWidth = value;

			var tempHeight : Number = (labelTextField) ? labelTextField.height : 0;
			LayoutManager.resize(subItemContainer, value, tempHeight);
			
			if(labelAlign)	this.alignLabel = labelAlign;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}

		/**
		 * @private
		 */
		private var _preferredLabelTextFormat : TextFormat;

		/**
		 * @private
		 */
		internal function get preferredLabelTextFormat() : TextFormat {
			return _preferredLabelTextFormat;	
		}

		/**
		 * @private
		 */
		internal function set preferredLabelTextFormat(value : TextFormat) : void {
			updateTextFields(value as TextFormat);
			_preferredLabelTextFormat = value;
		}

		
		//--------------------------------------
		//  Internal Methods
		//--------------------------------------

		/**
		 * @private
		 */
		override internal function update_indicatiorLocation(value : String) : void {
			cleanRequiredIndicatorBoxs();
			switch(value) {
				case FormLayoutStyle.INDICATOR_LEFT:
					if(!lableText && labelAlign == FormLayoutStyle.TOP) {
						break;
						return;
					}
					if(required) reqBox_l.showIndicator();
					reqBox_l.makeEmptyGap();
					break;
					
				case FormLayoutStyle.INDICATOR_LABEL_RIGHT:
					if(!lableText && labelAlign == FormLayoutStyle.TOP) {
						break;
						return;
					}
					if(required) reqBox_r.showIndicator();
					reqBox_r.makeEmptyGap();
					break;
			}
		}

		//--------------------------------------
		//  Private Methods
		//--------------------------------------
		/**
		 * @private
		 */
		override public function update(target : String, value : Object = null) : void {
			switch(target) {
				case FormLayoutEvent.UPDATE_LABEL_FONT_CHANGE:
					if(!preferredLabelTextFormat) updateTextFields(value as TextFormat);
					break;
				case FormLayoutEvent.UPDATE_LABEL_WIDTH:
					this.preferredLabelWidth = Number(value);
					break;
						
				case FormLayoutEvent.UPDATE_REQUIRED_ITEM:
					required = Boolean(value);
					break;
						
				case FormLayoutEvent.UPDATE_INDICATOR_LOCATION:
					indicatorLocation = String(value);
					break;
						
				case FormLayoutEvent.UPDATE_LABEL_ALIGN:
					labelAlign = String(value);
					break;
			}
		}

		/**
		 * @private
		 */
		override internal function set labelAlign(value : String) : void {
			if(this.labelAlign == value) return;
			this.alignLabel = _labelAlign = value;
			update_indicatiorLocation(indicatorLocation);
		}

		/**
		 * @private
		 */
		internal function attLabel(lableTxt : String) : void {
			
			lableSprite = new Sprite();
			if(lableTxt is String && lableTxt != "" ) {
				lableText = lableTxt;
				if(!labelTextField) labelTextField = FormLayoutStyle.labelTextField;
				labelTextField.htmlText = lableText;
				actualLabelTextWidth = labelTextField.width;
				labelTextField.x = 0;
				lableSprite.addChild(labelTextField);
			} else {
				lableText = null;
				actualLabelTextWidth = 0;
			}
			

			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));
			
			this.addItem(lableSprite);
		}

		/**
		 * @private
		 */
		override protected function updateTextFields(textformat : TextFormat) : void {
			if(!labelTextField) return;
			actualLabelTextWidth = NaN;
		
			var textFieldToChg : TextField = labelTextField;
			var str : String = textFieldToChg.htmlText;
			textFieldToChg.htmlText = str;
//			trace("updateTextFields", textformat, str)
			textFieldToChg.setTextFormat(textformat);
			actualLabelTextWidth = textFieldToChg.width;
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.LABEL_ADDED));
		}

		/**
		 * @private
		 */

		private  function set alignLabel(value : String) : void {
			if(!lableText) return;
			switch(value) {
				case FormLayoutStyle.TOP:
					labelTextField.x = 0;
					break;
				case FormLayoutStyle.RIGHT:
					labelTextField.x = (preferredLabelWidth) ? preferredLabelWidth - actualLabelTextWidth : 0;
					break;
				case FormLayoutStyle.LEFT:
					labelTextField.x = 0;
					break;
			}
		}
	}
}

