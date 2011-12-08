package com.kaltura.kdpfl.component
{
	import fl.core.UIComponent;
	
	import flash.utils.getQualifiedClassName;
	/**
	 * Class desribing a UI component 
	 * @author Hila
	 * 
	 */	
	public class ComponentData
	{
		/**
		 * The component's KDP class (i.e KButton, KLabel, etc).
		 */		
		private var _ui:Object;
		/**
		 * The component's attributes as specified on its xml tag in the config.xml file. 
		 */		
		public var attr:Object;
		/**
		 * The component's skin class name. 
		 */		
		public var styleName:String
		/**
		 * The component's class name 
		 */		
		public var className:String;
		
		/**
		 * Constructor 
		 * @param ui
		 * @param styleName
		 * @param attr
		 * 
		 */		
		public function ComponentData(ui:Object, styleName:String, attr:Object)
		{
			this.ui = ui;
			this.styleName = styleName;
			this.attr = attr;
		}
		
		/**
		 * Set the ui componet reference and extract class name 
		 * @param ui
		 * 
		 */		
		public function set ui(ui:Object):void
		{
			_ui = ui;
			className = getQualifiedClassName(ui);
			className = className.substring(className.indexOf("::") + 2);
		}
		
		/**
		 * return the ui reference 
		 * @return 
		 * 
		 */		
		public function get ui():Object
		{
			return _ui;
		}
	}
}