/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls
{
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * A type of cell renderer that provides simple hooks for designers and
	 * quick developer mockups. Intended to be used as a <strong>Base Class</strong>
	 * for <strong>Library symbols</strong> in the Adobe Flash authoring tool.
	 * Extends MovieClip to allow timeline scripting.
	 * 
	 * @see #commitFunction commitFunction provides a hook for updating children on stage every time the component redraws.
	 * @author Josh Tynjala
	 */
	public dynamic class CellRendererSymbol extends MovieClip implements ICellRenderer
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function CellRendererSymbol()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * This TextField isn't actually used. The reason it is referenced is
		 * because Flash CS3 will not automatically add an import statement for
		 * flash.text.TextField when a TextField is placed on stage. It will
		 * include import statements for components like fl.controls.Button, though,
		 * so TextField appears to be the only type that must be forcefully imported.
		 */
		private var _importTF:TextField;
		
		/**
		 * @private
		 * Storage for the width property.
		 */
		private var _width:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			if(!isNaN(this._width))
			{
				return this._width;
			}
			return super.width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this._width = value;
			this.invalidate();
		}
		
		/**
		 * @private
		 * Storage for the height property.
		 */
		private var _height:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			if(!isNaN(this._height))
			{
				return this._height;
			}
			return super.height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			this._height = value;
			this.invalidate();
		}
		
		/**
		 * @private
		 * Storage for the commitFunction property.
		 */
		private var _commitFunction:Function;
		
		/**
		 * A function hook used to allow designers or developers to pass data
		 * from the cell renderer to children placed on stage in the Flash
		 * authoring environment.
		 * 
		 * <p>Note: This function, regardless of its origin is called from the
		 * scope of the cell renderer. The <code>this</code> keyword will always
		 * refer to the instance of the CellRendererSymbol.</p>
		 * 
		 * @example The following code passes data to child components. This code should appear on the timeline in the cell renderer symbol.
		 * <listing version="3.0">
		 * this.commitFunction = function( data:Object ):void
		 * {
		 * 	// label is a TextField placed on stage
		 * 	this.label.text = data.label;
		 * 
		 * 	// imageLoader is a UILoader placed on stage
		 * 	this.imageLoader.source = data.imageURL;
		 * }
		 * </listing>
		 * 
		 * @example Alternatively, you can access the <code>listData</code> object to get some automatically extracted data (from labelField, labelFunction, iconField, etc). The <code>selected</code> property is another important one, and you can access anything available on the renderer using <code>this</code>.
		 * <listing version="3.0">
		 * this.commitFunction = function( data:Object ):void
		 * {
		 * 	// label is a TextField placed on stage
		 * 	this.label.text = this.listData.label;
		 * 
		 * 	// imageLoader is a UILoader placed on stage
		 * 	this.iconLoader.source = this.listData.source;
		 * 
		 * 	//a rectangle in the background that is only visible when the item is selected
		 * 	this.selectedBackground.visible = this.selected;
		 * }
		 * </listing>
		 * 
		 * <p>Warning: When commitFunction is defined as a timeline script,
		 * the CellRendererSymbol may be displayed before the frame scripts
		 * are run. TextFields with filler text or other objects with
		 * similar design placeholders may flicker for a very brief moment.
		 * This is generally not noticeable.
		 */
		public function get commitFunction():Function
		{
			return this._commitFunction;
		}
		
		/**
		 * @private
		 */
		public function set commitFunction(value:Function):void
		{
			this._commitFunction = value;
			this.invalidate();
		}
		
		/**
		 * @private
		 * Storage for the listData property.
		 */
		private var _listData:ListData;
		
		/**
		 * @inheritDoc
		 */
		public function get listData():ListData
		{
			return this._listData;
		}
		
		/**
		 * @private
		 */
		public function set listData(value:ListData):void
		{
			this._listData = value;
			this.invalidate();
		}
		
		/**
		 * @private
		 * Storage for the data property.
		 */
		private var _data:Object;
		
		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			this._data = value;
			this.invalidate();
		}
		
		/**
		 * @private
		 * Storage for the selected property.
		 */
		private var _selected:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			this._selected = value;
			this.invalidate();
		}
		
		/**
		 * The current mouse state initialized by <code>setMouseState()</code>.
		 */
		protected var mouseState:String;
		
		/**
		 * @private
		 * Flag indicating if the draw state is valid or not.
		 */
		protected var invalid:Boolean = false;
		
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void
		{
			this._width = width;
			this._height = height;
			this.invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		public function setMouseState(state:String):void
		{
			this.mouseState = state;
			this.invalidate();
		}
		
		/**
		 * Forces an immediate redraw and validation.
		 */
		public function drawNow():void
		{
			this.draw();
			this.invalid = false;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Draws the component and tells child UIComponents to redraw.
		 * Calls the <code>commitFunction</code> so that library symbols
		 * can pass data to their stage-based children.
		 */
		protected function draw():void
		{
			if(this._commitFunction !== null)
			{
				this._commitFunction.apply(this, [this.data]);
			}
			
			for(var i:int = 0; i < this.numChildren; i++)
			{
				var child:UIComponent = this.getChildAt(i) as UIComponent;
				if(child)
				{
					child.drawNow();
				}
			}
		}
		
		/**
		 * @private
		 * Invalidates so that the component may redraw at some point in the
		 * future.
		 */
		protected function invalidate():void
		{	
			this.invalid = true;
			
			if(this.stage)
			{
				//TODO: It is expected that Flash Player 10 will have a new
				//event that will work better than the stage.invalidate() and
				//Event.RENDER combination. I believe Event.EXIT_FRAME is what
				//will be recommended.
				//for now, we completely redraw every time the component is
				//invalidated. this could lead to poor performance in some
				//extreme cases, but it's all we can do because Event.RENDER is
				//pretty much useless.
				this.drawNow();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, renderHandler);
			}
		}
		
	//--------------------------------------
	//  Private Event Handlers
	//--------------------------------------
		
		/**
		 * @private
		 * Draws and validates when an event is fired.
		 */
		private function renderHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, renderHandler);
			
			//if we just validated, there's no reason to draw again.
			if(!this.invalid)
			{
				return;
			}
			this.drawNow();
		}
		
	}
}