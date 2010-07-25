package com.kaltura.core
{
	import flash.utils.getDefinitionByName;
	
	public class KClassFactory 
	{
	 	public var generator:Class;
	 	
	    public function KClassFactory(generator:Class = null)
	    {
			super();
	
	    	this.generator = generator;
	    }
	
	
		public function newInstanceFromObject( properties:Object = null ):*
		{
			var instance:Object = new generator();
	
	        if (properties != null)
	        {
	        	for (var p:String in properties)
				{
	        		instance[p] = properties[p];
				}
	       	}
	
	       	return instance;
		}
		
		public function newInstanceFromXML( xmlList:XMLList = null ):*
		{
			var instance:Object = new generator();
			var cls : Class = null;
			var obj : *;
	        for each(var prop:XML in xmlList.children())
	        {
	        	if(prop.hasComplexContent())
	        	{
	        		if(prop.children()[0].name() == "item") //Assumption that Array will always consist of <item></item>
	        		{
	        			var arrName : String = prop.name();
	        			instance[arrName] = new Array();
	        			
	        			for each( var item:XML in prop.children() )
	        			{
	        				cls = getDefinitionByName('com.kaltura.vo.'+ item.objectType) as Class;
	        				obj = (new KClassFactory( cls )).newInstanceFromXML( XMLList(item) );
	        				instance[arrName].push(obj);		
	        			}
	        		}
	        		else //if complex object and not an array
	        		{
	        			cls = getDefinitionByName('com.kaltura.vo.'+ prop.objectType) as Class;
	        			obj = (new KClassFactory( cls )).newInstanceFromXML(  XMLList(prop) );
	        			instance[prop.name()] = obj;
	        		}
	        	}
	        	else
	        	{
	        		if( prop.name() && !(instance[prop.name()] is Array) )
	        		{
	        			if(instance[prop.name()] is Boolean)
	        			{
	        				if( prop.toString() == "1")
	        					instance[prop.name()] = true;
	        				else
	        					instance[prop.name()] = false;
	        			}
						else
						{
							instance[prop.name()] = prop.toString(); //casting from String to Number / int if needed
						}
	        		}	
	        	}
	       	}
	
	       	return instance;
		}
	}
}
