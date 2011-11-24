package com.addthis.menu.ui.controls
{
	import com.addthis.menu.ui.styles.MenuStyles;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
    
    /**
    * Label class
    * Class for text display control.
    **/ 
  	public class Label extends TextField
	{
		//Text properties
		private var format:TextFormat;
		public var labelText:String;
		public var labelColor:*;	
		
		/**
		* Constructor 
		**/  
		public function Label(text:String,color:*)
		{
			labelText = text;
			labelColor = color;
			createLabel();
		}
		
		/**
		* Creating a label from defined properties
		**/ 
		private function createLabel():void{
			format = new TextFormat();
			with (format){
				font = "Arial";
	            color = labelColor;
	            bold = true;
	            size = MenuStyles.LABEL_STYLE.font_size;
            }
            autoSize = TextFieldAutoSize.LEFT;
            background = false;
            border = false;
            selectable = false;
            alpha = MenuStyles.LABEL_STYLE.alpha;
            text = labelText;
            setTextFormat(format);
		}
	}
}