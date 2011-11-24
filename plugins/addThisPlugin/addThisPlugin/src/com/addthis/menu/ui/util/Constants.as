package com.addthis.menu.ui.util
{
	/**
    * Constants for menu and controls
    */
	public class Constants
	{
		//Menu constants
		public static const MENU_ROW_HEIGHT:int = 27;
		
		public static const DEFAULT_DISPLAY_STYLE:int = 3;
		
		public static const BUTTON_SPACING:int = 10;
		
		public static const DOCK_HEIGHT:int = 18;
		
		public static const SERVICE_BUTTON_LEFT_SPACING:int = 0;
		
		public static const MENU_LEFT_PADDING:int = 12;
		
		public static const SERVICE_BUTTON_TOP_SPACING:int = 22;
		
		public static const BOTTOM_SPACING:int = 8;
		
		public static const CLOSE_BUTTON_WIDTH:int = 7;
		
		public static const CLOSE_BUTTON_HEIGHT:int = 10;
		
		public static const MINIMUM_GET_AND_SHARE_WIDTH:int = 30;
		
		//Service button constants
    	public static const SERVICE_BUTTON_HEIGHT:int = 21;
			
		public static const SERVICE_BUTTON_ICON_WIDTH:int = 35;

		public static const SERVICE_BUTTON_TEXT_WIDTH:int = 55;		
			
		public static const SERVICE_BUTTON_ICON_AND_TEXT_WIDTH:int = 85;
		
		public static const MENU_SPACING:int = 12;
		
		//End point constants
		private static const BASE_DIR:String = 'http://cache.addthis.com/downloads/demo/flash-menu-lib/';
		public static const IMAGE_ENDPOINT:String = BASE_DIR + 'images/';
		
		//Icon Embeds
		[Embed(source='/../assets/images/icons/facebook_16.png')]
		public static var FACEBOOK_ICON:Class;
		
		[Embed(source='/../assets/images/icons/igoogle_16.png')]
		public static var IGOOGLE_ICON:Class;
		
		[Embed(source='/../assets/images/icons/myspace_16.png')]
		public static var MYSPACE_ICON:Class;
		
		[Embed(source='/../assets/images/icons/netvibes_16.png')]
		public static var NETVIBES_ICON:Class;
		
		[Embed(source='/../assets/images/icons/16x16.png')]
		public static var MORE_ICON:Class;
		
		public static var SERVICE_ICONS:Object = {facebook:FACEBOOK_ICON, igoogle:IGOOGLE_ICON, myspace:MYSPACE_ICON, netvibes:NETVIBES_ICON, more:MORE_ICON};
		
     	public function Constants(){}
	}
}