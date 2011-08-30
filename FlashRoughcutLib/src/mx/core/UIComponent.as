package mx.core {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
 	public class UIComponent extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		
		public function UIComponent()
		{
	        addEventListener(Event.ADDED, addedHandler);
	        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	        _width = super.width;
        	_height = super.height;
		}
		
	    private function addedHandler(event:Event):void
	    {
	    }
	    
	    private function addedToStageHandler(event:Event):void
	    {
	    }
	    
	    override public function get width():Number
	    {
	        return _width;
	    }
	    
		override public function set width(value:Number):void
		{
			_width = value;
		}

	    override public function get height():Number
	    {
	        return _height;
	    }
	    
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
	    public function setVisible(value:Boolean,
    	                           noEvent:Boolean = false):void 
	    {
	    	visible = value;
	    	/*xxx
	        _visible = value;
	
	        if (!initialized)
	            return;
	
	        if ($visible == value)
	            return;
	
	        $visible = value;
	        xxx*/
	    }
	}
}
