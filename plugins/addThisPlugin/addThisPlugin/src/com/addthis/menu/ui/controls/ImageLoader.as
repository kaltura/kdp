package com.addthis.menu.ui.controls
{
    import com.addthis.menu.ui.util.Constants;
    
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    
	/**
    * BitmapLoader class 
    * Used to load service icons to display in the menu
    */
    public class ImageLoader extends Sprite {
    	//Holds the id of the service button to load
        public var serviceName:String;
        
        /**
        * Constructor - setting the servicename for loading the icon
        **/ 
        public function ImageLoader(service:String) {
            serviceName = service;
        }
        
        /**
        * Loads image using the loader
        **/ 
        public function loadImage():void{
        	var loader:Loader = new Loader();
        	loader.load(new URLRequest(Constants.IMAGE_ENDPOINT + serviceName + "_16.png"));
        	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addBitmapToStage);
        } 
        
        /**
        * Adds the content of loader into stage as bitmap.
        **/
        private function addBitmapToStage(event:Event):void{
        	var loader:Loader = event.target.loader;
        	var image:Bitmap = Bitmap(loader.content);
        	image.width = 16;
	        image.height = 16;
        	addChild(image);
        }        
    }
}