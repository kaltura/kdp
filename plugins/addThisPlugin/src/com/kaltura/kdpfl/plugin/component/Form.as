package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.controller.AbstractCommand;
	import com.kaltura.kdpfl.controller.ICommand;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;

	public class Form implements IForm
	{
		public var id:String			=	"";
		private var _action:ICommand;

		public var textFields:Array		= new Array();
		public var components:Array		= new Array();
		public var radioGroup:Array		= new Array();
		
		public var definition:XML;
		//response url
		private var _url:String			= 	"";
		//data objects can be anything in addition to keyvalpairs
		private var _data:Object		= new Object();
		//key/value pairs
		private var _keyValPairs:Object	= new Object();

		public function Form()
		{
			
		}
		
		//reset form values to default
		public function resetFormToDefault():void{
			for each(var item:RadioGroup in radioGroup){
				item.resetToDefault();
			}
		}
		
		public function set action(a:ICommand):void{
			_action			= a;
			(_action as AbstractCommand).addEventListener(AbstractCommand.COMMAND_RESPONSE, onComResponse);
		}
		
		public function get action():ICommand{
			return _action;
		}
		
		public function set url(s:String):void{_url 		= s;}
		public function get url():String{return _url;}
		
		public function get formComponents():Array{
			return components;
		}
		
		public function set data(o:Object):void{_data		= o;}
		public function get data():Object{return _data;}
		
		
		public function set params(val:String):void{
			if(val.indexOf("=") > -1){
				var keyValues:Array	= val.split("&");
				
				for each(var singlePair:String in keyValues){
					var spr:Array 	= singlePair.split("=");
					_keyValPairs[spr[0]]	= spr[1];
				}
			}
		}
		
		private function onComResponse(e:AddThisEvent):void{
			
		}
		
		public function get formParams():Object{
			return _keyValPairs;
		}
		
		
		public function submit():void{
			try{
				action.execute(this);
			}catch(e:Error){
				trace("FORM ERRROR	"+e);
				throw e;
			}
		}
	}
}