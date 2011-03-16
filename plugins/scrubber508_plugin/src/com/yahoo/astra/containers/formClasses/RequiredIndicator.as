/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.containers.formClasses {
	import com.yahoo.astra.containers.formClasses.FormLayoutStyle;
	import com.yahoo.astra.events.FormLayoutEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;	

	/**
	 * Attach a required field indicator object to FormItem. 
	 * 
	 * @author kayoh
	 */
	public class RequiredIndicator extends Sprite implements IForm {
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function RequiredIndicator() {
			super();
		}

		//--------------------------------------
		//  Properties
		//--------------------------------------
		/**
		 * Required field mark(red asterisk). the default is indicatorSkin movieclip in Form.
		 * @private
		 */
		private var checkBox : DisplayObjectContainer = null;
		/**
		 * Place holder to make even gap.
		 * @private
		 */
		private var emptyBox : Sprite = null;
		/**
		 * @private
		 */
		private var _requiredIndicator : DisplayObject = null;

		/**
		 * Return requiredIndicator DisplayObject being used in <code>Form</code> or <code>FormItem</code>.
		 * @param value DisplayObject to be used as requiredIndicator.
		 */
		public function get requiredIndicator() : DisplayObject {
			return _requiredIndicator;
		}

		/**
		 * @private
		 * @see com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle#DEFAULT_INDICATORFIELD_WIDTH
		 */
		private var boxWidth : Number = FormLayoutStyle.INDICATORFIELD_WIDTH;
		/**
		 * @private
		 * @see com.yahoo.astra.fl.containers.formClasses.FormLayoutStyle#DEFAULT_INDICATORFIELD_HEIGHT
		 */
		private var boxHeight : Number = FormLayoutStyle.INDICATORFIELD_HEIGHT;
		/**
		 * @private
		 */
		private var formEventObserver : IFormEventObserver = null;

		
		//--------------------------------------
		//  internal Methods
		//--------------------------------------
		/**
		 *  @private
		 */
		private function upateEmptyBoxWidthHeight(w : Number, h : Number) : void {
			boxWidth = w;
			boxHeight = h;
			if(emptyBox) {
				emptyBox.width = w;
				emptyBox.height = h;
			}
		}

		/**
		 *  @private
		 */
		internal function cleanBox() : void {
			_requiredIndicator = null;
			while(this.numChildren) this.removeChildAt(0);
		}

		/**
		 *  @private
		 */
		internal function makeEmptyGap() : void {
			if(this.getChildByName("emptyBox")) {
				this.removeChild(this.getChildByName("emptyBox"));
			}
			var sp : Sprite = new Sprite();
			sp.graphics.beginFill(0xff00ff, 0);
			sp.graphics.drawRect(0, 0, boxWidth, boxHeight);
			sp.graphics.endFill();
			
			emptyBox = Sprite(this.addChild(sp));
			emptyBox.name = "emptyBox";
		}

		/**
		 * @private
		 * 
		 * Show the required indicator(asterisk mark or custom movieclip).
		 */
		internal function showIndicator() : void {
			try {
				/*
				 * When FormItem is nested in Form, attaches one from Form.
				 */ 
				var ClassReference : Class = getDefinitionByName(FormLayoutStyle.defaultStyles["indicatorSkin"]) as Class;
				checkBox = new ClassReference();
			}
			
			catch(e : ReferenceError) {
				if(FormLayoutStyle.defaultStyles["indicatorSkin"] is DisplayObjectContainer) {
					/*
					 * When "indicatorSkin" was defined by set setIndicatorSkin in FormItem.
					 */
					checkBox = FormLayoutStyle.defaultStyles["indicatorSkin"];
				} else {
					checkBox = new Sprite();
					var astTxtField : TextField = FormLayoutStyle.asteriskTextField;
					astTxtField.y = -astTxtField.height / 2;
					astTxtField.x = -astTxtField.width / 2;
					checkBox.addChild(astTxtField);
				}
			}
			if(FormLayoutStyle.INDICATORFIELD_WIDTH < checkBox.width || FormLayoutStyle.INDICATORFIELD_HEIGHT < checkBox.height) {
				boxWidth = FormLayoutStyle.INDICATORFIELD_WIDTH = checkBox.width;	
				boxHeight = FormLayoutStyle.INDICATORFIELD_HEIGHT = checkBox.height;
				
				if(formEventObserver) formEventObserver.setUpdate(FormLayoutEvent.INDICATOR_SIZE_CHAGE, [boxWidth, boxHeight]);
			}
			checkBox.x = boxWidth / 2;
			checkBox.y = boxHeight / 2;
			
			makeEmptyGap();
			_requiredIndicator = this.addChild(checkBox);
		}

		//--------------------------------------
		//  Public Methods
		//--------------------------------------

		/**
		 * @private
		 */
		public function update(target : String, value : Object = null) : void {
			switch(target) {
				case FormLayoutEvent.INDICATOR_SIZE_CHAGE:
					upateEmptyBoxWidthHeight(value[0], value[1]);
					break;
			}
		}

		
		/**
		 * @private
		 */
		public function subscribeObserver(formEventObserver : IFormEventObserver) : IFormEventObserver {
			this.formEventObserver = formEventObserver;
			return formEventObserver.subscribeObserver(this);
		}
	}
}
