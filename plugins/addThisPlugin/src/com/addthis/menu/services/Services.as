package com.addthis.menu.services
{
	/**
    * Services class
    * 
    * Add or remove services from this list to delete it from menu.
    */
	public class Services
	{
		//Constructor
		public function Services():void{}
	    
	    /**
	    * Sharing services - Menu takes services from here to display 
	    **/
	    public static const SHARING_LIST:Array=
	    [
          {
		      displayName : "Facebook",
		      id : "facebook"
		  },
          {
		      displayName : "iGoogle",
		      id : "igoogle"
          },
          {
		      displayName : "MySpace",
		      id : "myspace"          
          },
          {
		      displayName : "Netvibes",
		      id : "netvibes"
          },
          {
		      displayName : "More",
		      id : "more"          
          }
	    ]
	}
}