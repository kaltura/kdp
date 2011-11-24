/**
 * Allows binding for all properties within the AddThisUI configuration. 
 * **/

package com.kaltura.kdpfl.manager
{
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;

	public class BindingManager
	{
		public var _components:Array	= new Array();
		public var definition:XML;
		
		private var _bindingDef:Array	= new Array();
		
		public function set component(item:*):void{
			_components.push(item);
			//trace("ITEM NAME: "+item.name);
		}
		
		public function BindingManager()
		{
			
		}

		public function init():void{
			parseXML(definition);
			
			for each(var idx:int in _bindingDef){
				BindingUtils.bindProperty(getComponent(_bindingDef[idx].target), 
														_bindingDef[idx].targetProperty, 
														getComponent(_bindingDef[idx].src),
														_bindingDef[idx].srcProperty); 
			}
		}
		
		private function getComponent(id:String):*{
			var target:*;
			for(var i:int=0;i<_components.length;i++){
				if(_components[i].name == id){
					target	= _components[i];
					break;
				}
			}
			return target;
		}

		private function parseXML(xml:XML):void{
		 	var rxLabel:RegExp			= /\{[A-Za-z0-9]+\.[A-Za-z0-9]+\}/;	
			
			for each(var item:XML in xml.descendants()){//for each node
				var idx:Number	= 0;
				for each(var attr:XML in item.attributes()){//for each attribute
					if(String(attr.toXMLString()).indexOf("{") > -1 &&
						String(attr.toXMLString()).indexOf("}") > -1){
					
						var str:String 		= String(attr.toXMLString());
						//go through each instance of the bindable property
						while(str.indexOf("{") > -1 && str.indexOf("}") > -1){
							var match:String		= rxLabel.exec(str);
							
							match				= match.replace("{","");
							match				= match.replace("}","");
							
							var keyValue:Array		= match.split(".");
							
							str 				= str.replace(rxLabel.exec(str), "");

							_bindingDef.push({src:item.@id, srcProperty:attr.name().toString(), target:keyValue[0], targetProperty:keyValue[1]});
						}
					}
				}

			}
		}
		
	}
}