package com.kaltura.kdpfl.controller
{
	import com.kaltura.commands.widget.WidgetAdd;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	import com.kaltura.kdpfl.plugin.component.IForm;
	import com.kaltura.types.KalturaWidgetSecurityType;
	import com.kaltura.vo.KalturaWidget;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class EmbedCommand  extends AbstractCommand implements ICommand
	{
		public static const NAME:String	= "EmbedCommand";
		
		private var _uiconfId:String;
		private var _embedCode:String;
		private var _loadWithNewConfig:Boolean;
		private var _embedContent:Object	= {};
		
		public function EmbedCommand(f:IFacade)
		{
			super(f);
			
		}	

		//this parses through params, find physical component and insert text
		protected function assignContents():Boolean{
			var width:String;
			var height:String;
			var success:Boolean		= false;
			try{
				for (var key:String	in _form.formParams){
					if(key == "size"){
						var size:Array	= String(_form.formParams[key]).split("x");
						width		= size[0];
						height		= size[1];
					}
				}
				

				for(var i:int= 0;i<_form.formComponents.length;i++){
					for (var key:String	in _form.formParams){
						if(_form.formComponents[i].name		== _form.formParams[key]){
							_form.data.embedCode	= _form.data.embedCode.replace(/\&\#60\;/g,"<");
							_form.data.embedCode	= _form.data.embedCode.replace(/\&\#62\;/g,">");
							var xml:XML		= XML(_form.data.embedCode);
								xml.@width			= width;
								xml.@height			= height;
								_form.data.embedCode	= xml.toXMLString();
								_form.data.embedCode	= _form.data.embedCode.replace(/\</g,"&#60;");
								_form.data.embedCode	= _form.data.embedCode.replace(/\>/g,"&#62;");
								//trace(xml.toXMLString());
							_form.formComponents[i].text =	xml;//_form.data.embedCode;
							
						}
					}

				}
				
				success				= true;
			}catch(e:Error){
				trace("AddThis Error: EmbedCommand - problem assigning form textfields to expected email properties.  Please ensure email properties are correctly define.");
				success				= false;
			}
			return success;
		}
		
		override public function execute(form:IForm):void{
			var success:Boolean	= false;
			_form			= form;

			success		= assignContents();
			//insert embed code into 
		}
	}
}