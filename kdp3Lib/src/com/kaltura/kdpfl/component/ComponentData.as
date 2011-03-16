package com.kaltura.kdpfl.component
{
	import fl.core.UIComponent;
	
	import flash.utils.getQualifiedClassName;
	
	public class ComponentData
	{
		//referance to ths ui control
		private var _ui:Object;
		
		//Control's attributes, taken from inside the <layout> xml
		public var attr:Object;
		
		public var styleName:String
		
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