package com.addthis.menu {
	// Import Menu API
	//import com.addthis.menu.MenuAPI;
	
	import flash.display.Sprite;
	import flash.system.Security;
	/**
    * Entry point for Menu 
    * 
    * Allows the option to configure sharing content,
    * shows the menu and hides the menu
    */
	public class Main extends Sprite {
		Security.allowDomain('*');
		Security.allowInsecureDomain('*');
		//menu instance
		private var menu:MenuAPI;
		private var _menu_width:Number;
		private var _menu_height:Number;
		
		//Constructor
		public function Main() {
			menu = new MenuAPI();
		}
		
		/**
		* Configuring the content to be shared from menu
		**/ 
		public function configure(url:String, params:Object = null):void{
			menu.configure(url,params);
		}
		
		/**
		* Showing the menu on stage 
		* Display style options
		* displayStyle = 1 - Icons only menu
		* displayStyle = 2 - Text only menu
		* displayStyle = 3 - Icons + Text menu    
		**/
		public function show(profileID:String='', rows:int = 1, displayStyle:int = 3):void{
			menu.display(profileID,rows,displayStyle);
			addChild(menu);
			width = menu.width;
			height = menu.height;
			trace(this, ': width  ->', width);
			trace(this, ': height ->', height);
		}
		
		/**
		* Hiding menu
		**/
		public function hide():void{
			if(menu){
				removeChild(menu);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */				
		override public function get width():Number {
			return _menu_width;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		override public function set width(value:Number):void {
			_menu_width = value;
		}
		/**
		 * 
		 * @return menu.height 
		 * 
		 */		
		override public function get height():Number {
			return _menu_height;	
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		override public function set height(value:Number):void {
			_menu_height = value;
		}
		
	}
}