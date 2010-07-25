package com.kaltura.kdpfl.view.controls
{

import com.kaltura.kdpfl.component.IComponent;
import com.kaltura.kdpfl.style.FontManager;
import com.kaltura.kdpfl.style.TextFormatManager;

import fl.controls.Label;

import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextFormat;

public dynamic class KLabel extends Label implements IComponent
{
	public var color1:Number = -1;
	public var dynamicColor:Boolean = false;
	public var font:String = "";
	
    /**
     *  If this propery is true, and the Label control size is
     *  smaller than its text, the text of the Label control is truncated using 
     *  the string "..."
     *  If this property is false, text that does not fit is clipped.
     * 
     *  @default true
     */
	public var truncateToFit:Boolean = true;
	/**
	 * The original text in case the text was truncated 
	 */
	private var untruncatedText:String;
	
	private var _isTruncate : Boolean = false;
	
	
	internal static const TEXT_WIDTH_PADDING:int = 5;
	
	
	public function KLabel()
	{
		super();
		this.text = ""; //clear the default "Label"
		
	}
	

	
/* 	private function onLabelResize( event : Event ) : void
	{
		runTruncateToFit();
	} */
	
	public function initialize():void 
	{
	}
	
	public function setSkin( styleName:String, setSkinSize:Boolean=false ):void
	{
		var tf:TextFormat = TextFormatManager.getInstance().getTextFormat( styleName );
		if(dynamicColor && color1 > -1)
			tf.color = color1;
			
		var item : Font = FontManager.getInstance().getEmbeddedFont( font );
   		
		if(item)
		{
			super.setStyle( "embedFonts", true );
			tf.font = item.fontName;
		}
		else if (font)
			tf.font = font;
		
		super.setStyle( "textFormat", tf );
	}
	
	override protected function drawLayout():void
	{
		super.drawLayout();
		runTruncateToFit();
		textField.y = actualHeight/2 - textField.textHeight/2;
	}

	override public function set text(value:String):void {
		// Value is the same as what is already set.
		if (value == text) { 
			return;
		}
		super.text = untruncatedText = value;	
		runTruncateToFit();
	}
	

	//wether to use visibility thedependancy 
	private var _activateHide:Boolean;

	[Bindable]
	public function set isVisible(value:String):void
	{
		if(value == "true"){
		 	visible = true;
		 	super.visible = true;
		}
		else{
			visible = false;
		 	super.visible = false;
		}
	}
	//[Bindable] 
	public function get isVisible():String
	{
		return String(visible);
	}
		
    public function runTruncateToFit():Boolean
    {
    	if (!truncateToFit)
    		return false;
    		
		var truncationIndicator:String = "...";

        var w:Number = width;

        // Need to check if we should truncate, but it 
        // could be due to rounding error.  Let's check that it's not.
        // Examples of rounding errors happen with "South Africa" and "Game"
        // with verdana.ttf.
		
		if (untruncatedText != null)
		{
	        if (untruncatedText != "" && textField.textWidth + TEXT_WIDTH_PADDING > w + 0.00000000000001)
	        {
	            // This should get us into the ballpark.
	            var s:String = super.text = untruncatedText;
	                untruncatedText.slice(0,
	                    Math.floor((w / (textField.textWidth + TEXT_WIDTH_PADDING)) * untruncatedText.length));
	
	            while (s.length > 1 && textField.textWidth + TEXT_WIDTH_PADDING > w)
	            {
	                s = s.slice(0, -1);
	                super.text = s + truncationIndicator;
	            }
	            
	            _isTruncate = super.text != truncationIndicator;
	           	this.tooltip = untruncatedText;
	            return true;
	        }
	        else if(_isTruncate)
	        {
	        	// if the text is Truncate and now the Label size is changed
	        	// and we don't need a truncat text now we will return to untruncated text
	        	_isTruncate = false;
	        	super.text = untruncatedText;
	        }
		}
	
		this.tooltip = "";
        return false;
    }
}
}