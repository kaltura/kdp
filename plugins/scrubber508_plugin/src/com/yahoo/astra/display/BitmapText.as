/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.display
{
	import flash.display.Sprite;
	import flash.text.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	
	/**
	 * BitmapText is a class that can be used to create rotating text fields with
	 * device fonts. When the rotation property is set to a value other than 0
	 * and the <code>embedFonts</code> is false, the text field will be replaced
	 * by a Sprite containing a bitmap.
	 *
	 * @author Tripp Bridges
	 */
	public class BitmapText extends Sprite
	{
		/**
		 * Constructor
		 */
		public function BitmapText()
		{
			super();
			this.addChild(_bitmapContainer);
			this.addChild(this.textField);
		}
		
		/**
		 * @private
		 * Used to hold the bitmap object
		 */
		private var _bitmap:Bitmap = null;
		
		/**
		 * @private
		 * Sprite that holds the bitmap container
		 */
		private var _bitmapContainer:Sprite = new Sprite();
	
		/**
		 * @private
		 * Placeholder for the width value. Equals the width of a bitmap when the bitmap
		 * displays text and the text field when it displays text. Since the text field and
		 * bitmap sprite are always present, the returned dimensions would always be innacurate.
		 */
		private var _width:Number = 0;


		/**
		 * @private
		 * Placeholder for the height value. Equals the height of a bitmap when the bitmap
		 * displays text and the text field when it displays text. Since the text field and
		 * bitmap sprite are always present, the returned dimensions would always be innacurate.
		 */
		private var _height:Number = 0;	
	

		/**
		 * @private 
		 * Placeholder for the text field
		 */
		private var _textField:TextField = new TextField();
		
		/**
		 * Specifies the format applied to newly inserted text, such as text inserted with the 
		 * <code>replaceSelectedText()</code> method or text entered by a user.
		 */
		public function get defaultTextFormat():TextFormat
		{
			return this.textField.defaultTextFormat;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set defaultTextFormat(value:TextFormat):void
		{
			this.textField.defaultTextFormat = value; 
		}
		
		/**
		 * Specifies whether to render by using embedded font outlines.
		 */
		public function get embedFonts():Boolean
		{
			return this.textField.embedFonts;
		}
		
		/**
		 * @private (setter)
		 */
		public function set embedFonts(value:Boolean):void
		{
			this.textField.embedFonts = value;
		}
		
		/**
		 * @private
		 * Placeholder for the rotation property of the text field
		 */
		private var _rotation:Number = 0;

		/**
		 * @inheritDoc
		 */
		override public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 * @private (setter)
		 */		
		override public function set rotation(value:Number):void
		{
			_rotation = value;
			setTextRotation(value);
		}
	
		/**
		 * A string that is the current text in the text field.
		 */
		public function get text():String
		{
			return this.textField.text;
		}
		
		/**
		 * @private (setter)
		 */
		public function set text(value:String):void
		{
			this.textField.text = value;
			this.textField.visible = true;
			this.contentWidth = _width = this.textField.width;
			this.contentHeight = _height = this.textField.height;
		}
		
		/**
		 * A Boolean value that indicates whether the text field is selectable.
		 */
		public function get selectable():Boolean
		{
			return this.textField.selectable;
		}
		
		/**
		 * @private (setter)
		 */
		public function set selectable(value:Boolean):void
		{
			this.textField.selectable = value;
		}

		/**
		 * Controls automatic sizing and alignment of text fields.
		 */
		public function get autoSize():String
		{
			return this.textField.autoSize;
		}
		
		/**
		 * @private (setter)
		 */
		public function set autoSize(value:String):void
		{
			this.textField.autoSize = value;
		}
		
		/**
		 * Reference to the text field
		 */
		public function get textField():TextField
		{
			return _textField;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set textField(value:TextField):void
		{
			_textField = value;
		}
		
		/**
		 * @private (setter)
		 */
		public function set border(value:Boolean):void
		{
			this.textField.border = value;
		}	
		
		/**
		 * Gets the minimum distance for placement of labels of the same rotation
		 */
		public function get rotationWidth():Number
		{
			var adjustedWidth:Number = 0;
			if(this.rotation == 0 || Math.abs(this.rotation) == 90)
			{
				adjustedWidth = this.width;
			}
			else if(this.rotation > 0)
			{
				if(this.rotation < 15)
				{
					adjustedWidth = this.width - (Math.sin(Math.abs(this.rotation)*Math.PI/180)*this.textField.textHeight*2);	
				}
				else if(this.rotation > 40 && this.rotation < 50)
				{
					adjustedWidth = this.contentHeight / (Math.cos((90-Math.abs(this.rotation))*Math.PI/180));
					adjustedWidth = Math.min(adjustedWidth, this.width);					
				}
				else
				{
					adjustedWidth = this.contentHeight / (Math.cos((90-Math.abs(this.rotation))*Math.PI/180));
					adjustedWidth = Math.min(adjustedWidth, this.width);					
				}
			}
			else
			{
				if(this.rotation > -15)
				{
					adjustedWidth = this.width - (Math.sin(Math.abs(this.rotation)*Math.PI/180)*this.textField.textHeight*2);
				}
				else if(this.rotation < -40 && this.rotation > -50)
				{
					adjustedWidth = this.contentHeight / (Math.cos((90-Math.abs(this.rotation))*Math.PI/180));
					adjustedWidth = Math.min(adjustedWidth, this.width);					
				}
				else
				{
					adjustedWidth = this.contentHeight / (Math.cos((90-Math.abs(this.rotation))*Math.PI/180));
					adjustedWidth = Math.min(adjustedWidth, this.width);					
				}
			}			
			return adjustedWidth;
		}

		public function get rotationHeight():Number
		{
			var adjustedHeight:Number;
			if(this.rotation == 0 || Math.abs(this.rotation) == 90)
			{
				adjustedHeight = this.height;
			}
			else
			{
				if(Math.abs(this.rotation) > 70)
				{
					adjustedHeight = this.height;	
				}
				else
				{
					adjustedHeight = this.contentHeight / (Math.sin((90 - Math.abs(this.rotation))*Math.PI/180));	
				}			
			}			
			
			return adjustedHeight;
		}
		
		/**
		 * @private
		 * Placeholder for contentWidth
		 */
		private var _contentWidth:Number = 0;
		
		/** 
		 * Width of the text field without rotation.
		 */
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		
		/** 
		 * @private (setter)
		 */
		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}
		
		/**
		 * @private
		 * Placeholder for contentHeight
		 */
		private var _contentHeight:Number = 0;
		
		/**
		 * Height of the text field without rotation.
		 */
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		/**
		 * @private (setter)
		 */
		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}
		
		
		public function get textWidth():Number
		{
			return this.textField.textWidth;
		}
		
		public function get textHeight():Number
		{
			return this.textField.textHeight;
		}
		
		/**
		 * @private
		 *
		 * Sets the rotation of the text. When the value is 0 or <code>embedFonts</code>
		 * is set to true, rotate the text field. Otherwise, draw the text field into a bitmap
		 * and rotate its container sprite.
		 */
		private function setTextRotation(value:Number):void
		{
			if(this.text == null || this.text == "") return;
		
			if(value == 0 || this.embedFonts) 
			{
				this.contentWidth = this.textField.width;
				this.contentHeight = this.textField.height;
				this.textField.visible = true;
				this.textField.x = 0;
				this.textField.y = 0;
				_bitmapContainer.visible = false;
			}
			else
			{
				var smoothing:Boolean = Math.abs(value)%90 != 0;
				var matrix:Matrix = new Matrix();
				//Have to move text over if it is right-aligned. Need to add an extra 5 pixels to the x value. We will also add 5 pixels to 
				//the width argument of the bitmap data. Depending on the letters, the left-most letters get cut-off. The additional 5 pixels
				//prevents this from happening.
				if(this.autoSize == TextFieldAutoSize.RIGHT) matrix.translate(-Math.ceil(this.textField.x)+5, -Math.ceil(this.textField.y));
				var wid:Number = this.autoSize == TextFieldAutoSize.RIGHT ? (this.textField.width) + 5 : this.textField.width; 
				var bitmapDataText:BitmapData = new BitmapData(Math.ceil(wid), Math.ceil(this.textField.height), true, 0x000000);
				bitmapDataText.draw(textField, matrix, null, null, null, smoothing);
				_bitmap = new Bitmap(bitmapDataText);
				_bitmap.smoothing = smoothing;
				if(_bitmapContainer.numChildren > 0) _bitmapContainer.removeChildAt(0);
				this.textField.visible = false;
				_bitmapContainer.addChild(_bitmap);
				this.contentWidth = _bitmapContainer.width;
				this.contentHeight = _bitmapContainer.height;			
				_bitmapContainer.visible = true;	
			}
			
			super.rotation = value;
		}	
		
	}
}