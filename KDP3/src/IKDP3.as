package
{

	public interface IKDP3 {
				
		
		/**
		 * A way to set flashvars from Flex/Flash loading application. </br>
		 * After init the flashvars change to be the global flashvars and 
		 * not only the flashvars that were passed from the wrapper.
		 * @param obj	flashvars object; key-value pairs.
		 */		
		function set flashvars( obj : Object ) : void;
		
		
		/**
		 * @private
		 */		
		function get flashvars() : Object;
		
		
		/**
		 * Start the KDP sequence commands to build layout, load styles and 
		 * set them, add add the main built view to the stage. </br> 
		 * this method is called automaticlly on stand alone KDP, but a KDP 
		 * in a Flex/Flash wrapper should call init() by itself.
		 * @param kml	layout xml (uiconf). To inject uiconf at runtime, pass it </br>
		 * 			 	here and set flashvars.kml=inject.
		 */		
		function init( kml : XML = null ):void;
		
		
		/**
		 * An application that loads KDP can use sendNotification to dispatch notifications.
		 * @param notificationName the name of the notiification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */		
		function sendNotification( notificationName:String, body:Object=null, type:String= null ):void ;
		
		
		/**
		 * KDP3 provides a way to get any data that is in the bindObject to JS
		 * @param expression
		 * @return 
		 */
		function evaluate(expression:String):Object;
		
		
		/**
		 * KDP3 provides a way to set any data attribute using this function </br> 
		 * from any Flash/Flex Container.
		 * @param componentName	the component which holds the attribute
		 * @param prop			attribute to be changed
		 * @param newValue		new value for the attribute
		 */	
		function setAttribute(componentName : String , prop : String , newValue : String):void;
		
		
		/**
		 * Free memory and clean static vars which are used to store KDP configuration  
		 */		
		function dispose() : void;
				

		function set height(value:Number):void;
		function set width(value:Number):void;
	}
}