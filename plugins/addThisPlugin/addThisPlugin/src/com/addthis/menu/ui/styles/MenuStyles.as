package com.addthis.menu.ui.styles
{
	/**
    * MenuStyles
    **/  
	public class MenuStyles
	{
		//Service button styles
		public static var SERVICE_BUTTON_STYLE:Object ={
			border_color:0x000000,
			start_color:0x000000,
            end_color:0x000000,
            label_color:0xFFFFFF,
            corner_radius:0,
            border_size:1,
            alpha:1
		}
		
		//Service button styles - hover
		public static var SERVICE_BUTTON_STYLE_HOVER:Object ={
			border_color:0x818180,
			start_color:0x0066FF,
            end_color:0x0099FF,
            label_color:0x3366FF,
            corner_radius:0,
            border_size:1,
            alpha:1
		}
		
		//Menu container style
		public static var MENU_STYLE:Object = {
			border_color:0x000000,
			start_color:0x000000,
            end_color:0x000000,
            corner_radius:5,
            border_size:1,
            alpha:1
		}
		
		//Dock (Get & Share) styles
		public static var DOCK_STYLE:Object = {
			border_color:0x6666666,
			start_color:0x999999,
            end_color:0xCCCCCC,
            corner_radius:2,
            border_size:1,
            alpha:1
		}
		
		//Label control text display styles
		public static var LABEL_STYLE:Object = {
			color:0xFFFFFF,
			font_size:11,
            alpha:1 
		}
		
		public function MenuStyles(){}
	}
}