/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers.layoutClasses
{
	import com.yahoo.astra.layout.modes.BaseLayoutMode;
	import com.yahoo.astra.layout.modes.IAdvancedLayoutMode;
	import com.yahoo.astra.layout.modes.ILayoutMode;
	
	import flash.display.DisplayObject;

	/**
	 * Adds support for padding and configurations to the BaseLayoutPane.
	 * 
	 * @author Josh Tynjala
	 */
	public class AdvancedLayoutPane extends BaseLayoutPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * @param mode				An instance of an ILayoutMode implementation.
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function AdvancedLayoutPane(mode:ILayoutMode = null, configuration:Array = null)
		{
			super(mode);
			this.configuration = configuration;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the paddingLeft property.
		 */
		private var _paddingLeft:Number = 0;
		
		/**
		 * The number of pixels of extra spacing between the left edge of the
		 * container and its children.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}
		
		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft != value)
			{
				this._paddingLeft = value;
				this.invalidate(INVALIDATION_TYPE_LAYOUT);
			}
		}
		
		/**
		 * @private
		 * Storage for the paddingRight property.
		 */
		private var _paddingRight:Number = 0;
		
		/**
		 * The number of pixels of extra spacing between the right edge of the
		 * container and its children.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}
		
		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight != value)
			{
				this._paddingRight = value;
				this.invalidate(INVALIDATION_TYPE_LAYOUT);
			}
		}
		
		/**
		 * @private
		 * Storage for the paddingTop property.
		 */
		private var _paddingTop:Number = 0;
		
		/**
		 * The number of pixels of extra spacing between the top edge of the
		 * container and its children.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}
		
		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop != value)
			{
				this._paddingTop = value;
				this.invalidate(INVALIDATION_TYPE_LAYOUT);
			}
		}
		
		/**
		 * @private
		 * Storage for the paddingBottom property.
		 */
		private var _paddingBottom:Number = 0;
			
		/**
		 * The number of pixels of extra spacing between the bottom edge of the
		 * container and its children.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}
		
		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom != value)
			{
				this._paddingBottom = value;
				this.invalidate(INVALIDATION_TYPE_LAYOUT);
			}
		}
		/**
		 * @private
		 * Flag indicating that the configuration property has changed.
		 */
		protected var configurationChanged:Boolean = false;
		
		/**
		 * @private
		 * Storage for the configuration property.
		 */
		private var _configuration:Array;
		
		/**
		 * A list of settings used by the layout algorithm for specific children
		 * of the container.
		 */
		public function get configuration():Array
		{
			return this._configuration;
		}
		
		/**
		 * @private
		 */
		public function set configuration(value:Array):void
		{
			if(this._configuration && this._configuration.length > 0)
			{
				//go through the existing configuration and remove the old targets
				var oldConfigCount:int = this._configuration.length;
				for(var i:int = 0; i < oldConfigCount; i++)
				{
					var configItem:Object = this._configuration[i];
					var child:DisplayObject = configItem.target as DisplayObject;
					if(!child)
					{
						continue;
					}
					
					//remove from the display list
					this.removeChild(child);
					
					//remove as a client
					if(this.layoutMode is IAdvancedLayoutMode)
					{
						var layoutWithClients:IAdvancedLayoutMode = IAdvancedLayoutMode(this.layoutMode)
						if(layoutWithClients.hasClient(child))
						{
							layoutWithClients.removeClient(child);
						}
					}
				}
			}
			
			this._configuration = value;
			
			if(this._configuration && this._configuration.length > 0)
			{
				var configCount:int = this._configuration.length;
				for(i = 0; i < configCount; i++)
				{
					configItem = this._configuration[i];
					child = configItem.target as DisplayObject;
					if(!child || this.contains(child))
					{
						//if we have an invalid target or the child is already
						//on our display list, we can skip this part
						continue;
					}
					
					//we'll add the target as a client later (because the layoutMode could change)
					//but it's safe to add it as a child now
					this.addChild(child);
				}
			}
			this.configurationChanged = true;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Flag that indicates if the layoutMode property has changed.
		 */
		protected var layoutModeChanged:Boolean = false;
		
		/**
		 * @private
		 */
		override public function set layoutMode(value:ILayoutMode):void
		{
			super.layoutMode = value;
			this.layoutModeChanged = true;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			if(this.layoutMode is BaseLayoutMode)
			{
				var mode:BaseLayoutMode = BaseLayoutMode(this.layoutMode);
				
				if((this.layoutModeChanged || this.configurationChanged) && this._configuration && this._configuration.length > 0)
				{
					//if the configuration has changed, add the configured targets as clients
					//of the layoutMode.
					var configCount:int = this._configuration.length;
					for(var i:int = 0; i < configCount; i++)
					{
						var configItem:Object = this._configuration[i];
						var child:DisplayObject = configItem.target as DisplayObject;
						mode.addClient(child, configItem);
					}
				}
				
				//pass the padding values to the layout mode
				mode.paddingTop = this.paddingTop;
				mode.paddingRight = this.paddingRight;
				mode.paddingBottom = this.paddingBottom;
				mode.paddingLeft = this.paddingLeft;
			}
			
			super.draw();
				
			//clear the flags
			this.layoutModeChanged = false;
			this.configurationChanged = false;
		}
		
	}
}