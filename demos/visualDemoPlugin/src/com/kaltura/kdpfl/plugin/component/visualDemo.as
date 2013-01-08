package com.kaltura.kdpfl.plugin.component
{
	import flash.display.Sprite;
	
	
	/**
	 * This class is the view component for this plugin.
	 * @author Eitan
	 * 
	 */		
	public class visualDemo extends Sprite
	{
		
		/**
		 * Constructor. 
		 * <br>
		 * This function draws a rectangle with an X to show how plugins
		 * behave in terms of streaching and full screen. the 10X10 square
		 * will be stretched as the component streches. </br>  	
		 * The parameters are passed from the config.xml file, as can be 
		 * seen in <code>visualDemoCode.initializePlugin</code>. 
		 * Remove them and replace with your own parameters if needed. 
		 * 
		 * @param viewColor		color of created rectangle
		 * @param viewAlpah		alpha of created rectangle
		 * 
		 */		
		public function visualDemo(viewColor:Number , viewAlpah:Number)
		{	
			
			graphics.beginFill(viewColor,viewAlpah);
			graphics.drawRect(0,0,10,10);
			graphics.endFill();
			graphics.lineStyle(0,0xFFFF00,0.8);
			graphics.moveTo(0,0);
			graphics.lineTo(10,10);
			graphics.moveTo(0,0);
			graphics.lineTo(10,0);
			graphics.lineTo(0,10);
			
		}
	}
}