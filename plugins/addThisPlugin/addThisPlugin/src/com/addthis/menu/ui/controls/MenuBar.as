package com.addthis.menu.ui.controls
{
	import com.addthis.menu.ui.styles.MenuStyles;
	import com.addthis.menu.ui.util.Constants;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	
	/**
    * ServiceButton class
    * 
    * Creates service button. 
    */
 	public class MenuBar extends Sprite
	{
		//Public variables - holding keys for button instances
		public var displayName:String;
		public var id:String;
		
		//For text display
		private var label:Label;

        /**
        * Constructor
        **/ 
		public function MenuBar(serviceDetails:Object):void
		{
			buttonMode = true;
			mouseChildren = false;

            if(serviceDetails){
				displayName = serviceDetails.displayName;
				id = serviceDetails.id;
			}
		}
		
		/**
		* Displaying the text
		**/ 
        public function setLabel(serviceName:String,mode:String="",color:* = 0xFFFFFF):void {
            label = new Label(serviceName,color);
            addChild(label);
            // set position
            var y_padding:Number = .5;
            var x_padding:Number = 7;
            
            var xPos:int = (mode == "comp")? ((width/2)-(label.width/2) + x_padding):(width/2)-(label.width/2);
            xPos = (mode == "dock") ? 5 : xPos;
            var yPos:int = (height/2)-(label.height/2)+y_padding;
            setLabelPosition(xPos, yPos );
        }
        
        /**
        * Setting the text position inside the service button
        **/
        public function setLabelPosition(x:int, y:int):void {
            label.x = Constants.MENU_LEFT_PADDING + x;
            label.y = y;
        }
 		
 		/**
 		* Loads the service icon 
 		**/  
        public function loadImage(imageUrl:String,displayStyle:int):void{
        	var image:ImageLoader = new ImageLoader(imageUrl);
        	image.loadImage();
            image.x = (displayStyle > 1) ? 2:9;
          	image.y = 2;
        	addChild(image);
        }
        
        /**
         * 
         * Adds Icon via [embed]
         * @param serviceList
         * @param displayStyle
         * 
         */        
        public function setIcon(serviceList:String, displayStyle:int):void {
        	var icon:Bitmap = new Constants.SERVICE_ICONS[serviceList];
        	icon.x = (displayStyle > 1) ? 2:9;
          	icon.y = 2;
        	addChild(icon)
        }
        
        /**
        * Drawing the curved rectangle
        **/
        public function drawRoundedRectangle(boxWidth:int,boxHeight:int,drawItem:String,state:String = 'normal'):void {
            var drawItemStyle:Object = getDrawItemStyle(drawItem,state);
            var colors:Array = [drawItemStyle.end_color, drawItemStyle.start_color];
            var fillType:String = "linear"
            var alphas:Array = [100, 100];
            var ratios:Array = [0, 255];
            var spreadMethod:String = "pad";
            var interpolationMethod:String = "RGB";
            var focalPointRatio:int = 0;
            var matrix:Matrix = new Matrix();
            
            var cornerRadius:Number = drawItemStyle.corner_radius;
            
            // Start Drawing
            matrix.createGradientBox(boxWidth, boxHeight, ((-90/180)*Math.PI), 0, 0);
            graphics.lineStyle(drawItemStyle.border_size, drawItemStyle.border_color, 1.0, true);
            graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, 
            spreadMethod, interpolationMethod, focalPointRatio);        
            graphics.moveTo(cornerRadius, 0);
            graphics.lineTo(boxWidth - cornerRadius, 0);
            graphics.curveTo(boxWidth, 0, boxWidth, cornerRadius);
            graphics.lineTo(boxWidth, cornerRadius);
            graphics.lineTo(boxWidth, boxHeight - cornerRadius);
            graphics.curveTo(boxWidth, boxHeight, boxWidth - cornerRadius, boxHeight);
            graphics.lineTo(boxWidth - cornerRadius, boxHeight);
            graphics.lineTo(cornerRadius, boxHeight);
            graphics.curveTo(0, boxHeight, 0, boxHeight - cornerRadius);
            graphics.lineTo(0, boxHeight - cornerRadius);
            graphics.lineTo(0, cornerRadius);
            graphics.curveTo(0, 0, cornerRadius, 0);
            graphics.lineTo(cornerRadius, 0);
            graphics.endFill();     
        }
        
        /**
        * Returns style according to the display object we want to draw
        **/
        private function getDrawItemStyle(itemType:String,state:String):Object
        {
        	switch (itemType){
        	  case "button":
        	       return state == "hover" ? MenuStyles.SERVICE_BUTTON_STYLE_HOVER:MenuStyles.SERVICE_BUTTON_STYLE; 
        	       break;
        	  case "dock":
        	       return MenuStyles.DOCK_STYLE;
        	       break;
        	  case "menu":
        	       return MenuStyles.MENU_STYLE;
        	       break;  
         	}
        	return null;
       }
	}
}