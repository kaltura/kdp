package com.addthis.demo.controls {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    public class RichShape extends Sprite {
        private var logoTextContainer:Sprite;
        private var _label:TextField = new TextField();
        private var format:TextFormat = new TextFormat();
        
        public function RichShape(buttonActive:Boolean = false) { 
			buttonMode = true;
			mouseChildren = false;
  
			if (buttonActive) {
				addEventListener(MouseEvent.MOUSE_OVER, changeAlpha);
				addEventListener(MouseEvent.MOUSE_OUT, changeAlpha);
			}
         
     	}
        public function drawRoundedRectangle(boxWidth:Number=300, boxHeight:Number=250, cornerRadius:uint=4, borderColor:uint=0x000000, beginColor:uint=0x000000, endColor:uint=0x000000, fillAlpha:Number=1, borderSize:Number=1):void {
            
            // Creating Rounded Rectangle Manually
            // Using drawRoundRect() SUCKS -- Stroke Hinting is atrocious
            var colors:Array = [endColor, beginColor];
            var fillType:String = "linear"
            var alphas:Array = [100, 100];
            var ratios:Array = [0, 255];
            var spreadMethod:String = "pad";
            var interpolationMethod:String = "RGB";
            var focalPointRatio:int = 0;
            var matrix:Matrix = new Matrix();
            
            // Start Drawing
            matrix.createGradientBox(boxWidth, boxHeight, ((-90/180)*Math.PI), 0, 0);
            graphics.lineStyle(borderSize, borderColor, 1.0, true);
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
            
            // Set 9 Slice Scaling
            if (cornerRadius > 0) {
                var sliceBound:Rectangle = new Rectangle(cornerRadius, cornerRadius, (boxWidth-(cornerRadius*2)), (boxHeight-(cornerRadius*2)))
                scale9Grid = sliceBound;
            }
        }
        public function drawRectangle(boxWidth:uint, boxHeight:uint, cornerRadius:uint=0, beginColor:uint=0x000000, endColor:uint=0x000000, fillAlpha:Number=1.0, borderSize:Number=1):void {
            with (graphics) {
             beginFill(beginColor, fillAlpha);
             drawRect(0, 0, boxWidth, boxHeight);
             endFill();
            }
        }
        public function drawTriangle(w:uint=20, h:uint=20, beginColor:uint=0x000000, borderColor:uint=0x000000, borderSize:Number=1, dir:String='left', name:String='play_button'):void {
            // Draw Triangle
            graphics.lineStyle(borderSize, borderColor, 1.0, true);
            graphics.beginFill(beginColor, 1);
            graphics.moveTo(0, h);
            graphics.lineTo(0, 0);
            graphics.lineTo(w, (h/2));
            graphics.lineTo(0, h);
            graphics.endFill();
 
            switch(dir) {
                case 'top':
                    rotation = -90;    
                    break;
                case 'right':
                    rotation = -180;
                    break;
                case 'bottom':
                    rotation = 90;
                    break;
                default:
                    break;
            }
        }
        
        public function drawPause(w:uint=20, h:uint=20, beginColor:uint=0x000000, borderColor:uint=0x000000, borderSize:Number=0, name:String='pause_button'):void {
            var rectangle_one:RichShape = new RichShape();
            var rectangle_two:RichShape = new RichShape();
            var overlay:RichShape = new RichShape();
            
            rectangle_one.drawRectangle(((w/2)-2), h, 0, borderColor, beginColor, beginColor, borderSize);
            rectangle_two.drawRectangle(((w/2)-2), h, 0, borderColor, beginColor, beginColor, borderSize);
            overlay.drawRectangle(w, h, 0, borderColor, beginColor, beginColor, borderSize);
            addChild(rectangle_one).x = 0;
            addChild(rectangle_two).x = (w/2)+2;
            addChild(overlay).alpha = 0;     
        }
        
        public function setLabel(lbl:Object):void {

            format.font = "Arial";
            format.color = lbl.color;
            format.bold = true;
            format.size = lbl.size;
        
            _label = new TextField();
            _label.autoSize = TextFieldAutoSize.LEFT;
            _label.background = false;
            _label.border = false;
            _label.selectable = false;
            _label.alpha = lbl.alpha;
            _label.text = lbl.profile;
            _label.setTextFormat(format);
            addChild(_label);
    
            // set position
            trace('_label:', label.width, ':', label.height);
            var y_padding:Number = 2;
            // y center
            setLabelPosition(0, (height/2)-(label.height/2)+y_padding);
        
        }
        public function setLabelPosition(x:int, y:int):void {
            label.x = x;
            label.y = y;
        }
        public function get label():TextField {
        	return _label;
        }
        
        public function drawOutline(boxWidth:Number=300, boxHeight:Number=250, cornerRadius:uint=4, borderColor:uint=0x000000, lineAlpha:Number=1, borderSize:Number=1):void {
            
            // Creating Rounded Rectangle Manually
            // Using drawRoundRect() SUCKS -- Stroke Hinting is atrocious
            
            // Start Drawing
            with (graphics) {
            	clear();
				lineStyle(borderSize, borderColor, lineAlpha, true);
				moveTo(cornerRadius, 0);
				lineTo(boxWidth - cornerRadius, 0);
				curveTo(boxWidth, 0, boxWidth, cornerRadius);
				lineTo(boxWidth, cornerRadius);
				lineTo(boxWidth, boxHeight - cornerRadius);
				curveTo(boxWidth, boxHeight, boxWidth - cornerRadius, boxHeight);
				lineTo(boxWidth - cornerRadius, boxHeight);
				lineTo(cornerRadius, boxHeight);
				curveTo(0, boxHeight, 0, boxHeight - cornerRadius);
				lineTo(0, boxHeight - cornerRadius);
				lineTo(0, cornerRadius);
				curveTo(0, 0, cornerRadius, 0);
				lineTo(cornerRadius, 0);  
            }
            
            
            // Set 9 Slice Scaling
            if (cornerRadius > 0) {
                var sliceBound:Rectangle = new Rectangle(cornerRadius, cornerRadius, (boxWidth-(cornerRadius*2)), (boxHeight-(cornerRadius*2)))
                scale9Grid = sliceBound;
            }
        }
        
        private function changeAlpha(event:Event):void {
        	var eventType:String = event.type.toString();
        	
        	switch(eventType.toLowerCase()) {
        		case 'mouseover':
					alpha = 0.85;
        			break;
        		default:
        			alpha = 1.0;
        			break;
        	}
        }
    }
}